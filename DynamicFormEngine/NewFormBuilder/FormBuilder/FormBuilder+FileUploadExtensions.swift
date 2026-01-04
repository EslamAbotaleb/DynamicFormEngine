//
//  FormBuilder+FileUploadExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 24/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

// MARK: - FormBuilder FileUploadControl Extension

import AVFoundation
import UIKit
internal import Alamofire
import MobileCoreServices


extension FormBuilder {
    
    /// Retrieves the FileUploadControl associated with a given field ID.
    /// - Parameter fieldID: The ID of the field to search for.
    /// - Returns: A tuple containing the section index and the corresponding FormViewModelFileUploadItem, or nil if not found.
    func getFileUploadControl(fieldID: String) -> (Int?, FormViewModelFileUploadItem?) {
        // Check in sectionObjects
        for (index, section) in sectionObjects.enumerated() {
            if let item = section.items.first(where: { $0.fieldId == fieldID }) as? FormViewModelFileUploadItem {
                return (index, item)
            }
        }
        // Check in nestedSectionObjects
        for (index, section) in nestedSectionObjects.enumerated() {
            if let item = section.items.first(where: { $0.fieldId == fieldID }) as? FormViewModelFileUploadItem {
                return (index, item)
            }
        }
        return (nil, nil)
    }
    
    /// Uploads a media file (image or file) to the server.
    /// - Parameters:
    ///   - fieldID: The ID of the field associated with the upload.
    ///   - photo: The UIImage to be uploaded (optional).
    ///   - fileUrl: The URL of the file to be uploaded (optional).
    ///   - completion: A closure that returns a FileUploadAnswer upon success.
    func uploadMedia(
        fieldID: String, photo: UIImage?, fileUrl: URL?,
        completion: @escaping ((FileUploadAnswer) -> Void)
    ) {
        guard let fileUploadFormItem = getFileUploadControl(fieldID: fieldID).1 else { return }
        guard let index = getFileUploadControl(fieldID: fieldID).0 else { return }
        
        let action = Dynamic_BasicActionDynamicForm.uploadFile(isPublic: false, serviceType: 0)
        let URL1 = action.baseURL + action.path
        let modelID = UUID().uuidString
        
        let model = UploadMediaUIModel(id: modelID, state: .inProgress(0.0))
        fileUploadFormItem.attachmentsList.append(model)
        reloadAt?(index, nil, nil)
        
        AF.upload(
            multipartFormData: { multipartFormData in
                // Append action parameters
                for (key, value) in action.actionParameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }

                // Append photo if available
                if let img = photo, let data = img.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(data, withName: "files", fileName: "photo.jpeg", mimeType: "image/jpeg")
                }

                // Append file URL if available
                if let url = fileUrl {
                    multipartFormData.append(url, withName: "files")
                }
            },
            to: URL1,
            usingThreshold: UInt64(10 * 1024 * 1024),
            method: action.method,
            headers: HTTPHeaders(action.authHeader))
        .uploadProgress { progress in
            DispatchQueue.main.async {
                if let attachment = fileUploadFormItem.attachmentsList.first(where: { $0.id == modelID }) {
                    attachment.state = .inProgress(progress.fractionCompleted)
                    self.reloadAt?(index, nil, nil)
                }
            }
        }
        .responseJSON { response in
            DispatchQueue.main.async {
                guard let attachment = fileUploadFormItem.attachmentsList.first(where: { $0.id == modelID }) else { return }

                // Handle errors
                if let error = response.error as NSError? {
                    if error.code == NSURLErrorCancelled {
                        fileUploadFormItem.attachmentsList.removeAll(where: { $0.id == modelID })
                        self.reloadAt?(index, nil, nil)
                        return
                    } else {
                        attachment.state = .failed
                        self.reloadAt?(index, nil, nil)
                        return
                    }
                }

                // Parse JSON response
                if let json = response.value as? [String: Any],
                   let resultArray = json["result"] as? [[String: Any]],
                   let firstItem = resultArray.first,
                   let media = ModelUploadedMedia(JSON: firstItem),
                   let _ = media.id {
                    
                    attachment.state = .success
                    attachment.uploadedMedia = media
                    self.reloadAt?(index, nil, nil)

                    let val = FileUploadAnswer(val: fileUploadFormItem.attachmentsList.map {
                        $0.uploadedMedia ?? ModelUploadedMedia()
                    })

                    if self.isNestedForm {
                        self.reloadAtNested?(index, val)
                    }
                    completion(val)
                } else {
                    attachment.state = .failed
                    self.reloadAt?(index, nil, nil)
                }
            }
        }
    }
    
    
    func mimeTypeForPath(path: URL) -> String {
        let pathExtension = path.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    
    func uploadVideo(videoURL: URL,
                     completion: @escaping ((FileUploadAnswer) -> Void)) {
        
        guard let fileUploadFormItem = getFileUploadControl(fieldID: fileUploadFieldID).1 else { return }
        guard let index = getFileUploadControl(fieldID: fileUploadFieldID).0 else { return }
        
        let modelID = UUID().uuidString
        
        let model = UploadMediaUIModel(id: modelID, state: .inProgress(0.0))
        fileUploadFormItem.attachmentsList.append(model)
        reloadAt?(index, nil, nil)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let action = Dynamic_BasicActionDynamicForm.uploadFile(isPublic: false, serviceType: 0)
        let urlString = action.baseURL + action.path
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        
        request.httpMethod = "POST"
        request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(AuthManagerDynamicForm.shared.token)", forHTTPHeaderField: "authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // Add other headers as needed…
        
        // Download the video first
        let task = URLSession.shared.downloadTask(with: videoURL) {[weak self] localURL, response, error in
            guard let `self` = self else {return}
            guard let localURL = localURL, error == nil else {
                print("Download error:", error ?? "Unknown error")
                return
            }
            
            // Read downloaded file into Data
            guard let videoData = try? Data(contentsOf: localURL) else {
                print("Failed to read downloaded video")
                return
            }
            
            // Prepare multipart body
            var body = Data()
            let paramName = "files"
            let fileName = videoURL.lastPathComponent
            let mimetype = self.mimeTypeForPath(path: videoURL)
            
            body += "--\(boundary)\r\n".data(using: .utf8)!
            body += "Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!
            body += "Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!
            body += videoData
            body += "\r\n".data(using: .utf8)!
            body += "--\(boundary)--\r\n".data(using: .utf8)!
            
            request.httpBody = body
            
            // Send the upload request
            let uploadTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Upload error:", error ?? "Unknown error")
                    fileUploadFormItem.attachmentsList.removeAll(where: { $0.id == modelID })
                    self.reloadAt?(index, nil, nil)
                    return
                }
                print("Upload response:", String(data: data, encoding: .utf8) ?? "Invalid response")
                
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let success = json["success"] as? Bool, success,
                       let results = json["result"] as? [[String: Any]],
                       let file = results.first {
                        
                        
                        let media = ModelUploadedMedia(JSON: file)
                        
                        DispatchQueue.main.async {
                            fileUploadFormItem.attachmentsList.first(where: { $0.id == modelID })?.state = .success
                            fileUploadFormItem.attachmentsList.first(where: { $0.id == modelID })?.uploadedMedia = media
                            self.reloadAt?(index, nil, nil)
                            let val = FileUploadAnswer(
                                val: fileUploadFormItem.attachmentsList.map({
                                    $0.uploadedMedia ?? ModelUploadedMedia()
                                })
                            )
                            if self.isNestedForm {
                                self.reloadAtNested?(index, val)
                            }
                            completion(val)
                        }
                        
                    } else {
                        print("Unexpected response structure or upload failed.")
                    }
                } catch {
                    print("Failed to decode response:", error)
                    if let rawResponse = String(data: data, encoding: .utf8) {
                        print("Raw response: \(rawResponse)")
                    }
                    
                    DispatchQueue.main.async {
                        fileUploadFormItem.attachmentsList.first(where: { $0.id == modelID })?.state = .failed
                        self.reloadAt?(index, nil, nil)
                    }
                    return
                }
            }
            
            uploadTask.resume()
        }
        
        task.resume()
    }
}
