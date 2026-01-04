//
//  FileViewerManager.swift
//  CERQEL
//
//  Created by ahmed maher on 18/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit
import QuickLook

public protocol FileViewer {
    func viewFile (atURL file: FileModel)
    func viewFile (atURL fileUrl: String)
}


public class FileViewerManager : NSObject, FileViewer {
 
//    var viewController: UIViewController
    public var router : CerqelRouterManager
    public var localFileURLToPreview: URL?
    
    public init(_ router: CerqelRouterManager = CerqelRouterManagerDynamicFormImpl()) {
//        self.viewController = viewController
        self.router = router
    }
    
    public func viewFile(atURL fileUrl: String) {
        let file = FileModel(fileURl: fileUrl)
        showFileInWebView(file)
        
    }
    
    public func viewFile(atURL file: FileModel) {
        showFileInWebView(file)
    }
    
    private func showFileInWebView(_ file: FileModel) {
        
        if file.fileExtension.lowercased().contains("pdf") {
            let fileWebViewController = FileWebViewController()
            fileWebViewController.file = file
            let navController = UINavigationController(rootViewController: fileWebViewController)
            router.present(vc: navController)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DownloadFileForPreviewStarted"), object: nil, userInfo: nil)
            downloadFileForPreview(file: file) { file in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DownloadFileForPreviewEnded"), object: nil, userInfo: nil)
                if let fileURL = file?.localFileUrl {
                    DispatchQueue.main.async {
                        self.openInQuickLook(url: fileURL)
                    }
                }
             }
        }
    }
    
    private static func showAlert(inViewController viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    public func openInQuickLook(url: URL) {
        self.localFileURLToPreview = url
        let preview = QLPreviewController()
        preview.dataSource = self
        preview.delegate = self
        router.present(vc: preview)
    }
    
    public func downloadFileForPreview(file: FileModel, completion: @escaping (FileModel?) -> Void) {
        DownloadManager.shared.downloadFiles(from: [file]) { (fileDownloaded, error) in
            if let fileDownloaded = fileDownloaded {
                completion(fileDownloaded)
            } else if let _ = error {
                self.downloadModifiedFile(file: file, completion: completion)
            }
        }
    }
    
    private func downloadModifiedFile(file: FileModel, completion: @escaping (FileModel?) -> Void) {
        var fileModified = file
        fileModified.fileURl = fileModified.fileURl.replacingOccurrences(of: "gw/", with: "")
        DownloadManager.shared.downloadFiles(from: [fileModified]) { (fileDownloaded, error) in
            if let fileDownloaded = fileDownloaded {
                completion(fileDownloaded)
            } else if let _ = error {
                completion(nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DownloadFileForPreviewFailed"), object: nil, userInfo: nil)
            }
        }
    }
}

extension FileViewerManager: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return localFileURLToPreview! as QLPreviewItem
    }
    
    public func previewControllerDidDismiss(_ controller: QLPreviewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

