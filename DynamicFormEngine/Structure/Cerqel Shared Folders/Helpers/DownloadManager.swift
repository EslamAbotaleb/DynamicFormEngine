//
//  DownloadManager.swift
//  CERQEL
//
//  Created by ahmed maher on 13/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
internal import Alamofire

class DownloadManager {
    static let shared = DownloadManager()

    private init() {}

    private var activeDownloads: [URL: DownloadRequest] = [:]

    func downloadFiles(from files: [FileModel],  completion: @escaping (FileModel?, Error?) -> Void) {
        for file in files {
            downloadFile(from: file) { file, error in
                completion(file, error)
            }
        }
    }

    func downloadFile(from file: FileModel, completion: @escaping (FileModel?, Error?) -> Void) {
        guard !activeDownloads.keys.contains(file.fileURl.cerqel_toURL()) else {
            // Already downloading this file
            return
        }

        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(file.title + "." + file.fileExtension)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let downloadRequest = AF.download(
            file.fileURl.cerqel_toURL(),
            headers: HTTPHeaders(globalHeaders),
            to: destination)
        .validate(statusCode: 200..<300)
        .responseData { response in
            
            self.activeDownloads.removeValue(forKey: file.fileURl.cerqel_toURL())
            
            switch response.result {
            
            case .success:
                if let downloadedFileURL = response.fileURL {
                    var downloadedFile = file
                    downloadedFile.localFileUrl = downloadedFileURL
                    completion(downloadedFile, nil)
                } else {
                    completion(nil, NSError(domain: "DownloadError", code: -1, userInfo: nil))
                }
            
            case .failure(let error):
                completion(nil, error)
            }
        }

        file.fileURl.cerqel_toURL().stopAccessingSecurityScopedResource()
            activeDownloads[file.fileURl.cerqel_toURL()] = downloadRequest

    }

    func cancelDownload(from url: URL) {
        if let downloadRequest = activeDownloads[url] {
            downloadRequest.cancel()
            activeDownloads.removeValue(forKey: url)
        }
    }
}
