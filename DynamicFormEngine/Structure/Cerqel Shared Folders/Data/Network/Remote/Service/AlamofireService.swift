//
//  AlamofireService.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 06/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import Alamofire
import Promises

class AlamofireService: EndpointExecuter {
 
//
    private let manager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        return Session(configuration: configuration)
    }()
    
     private let backgroundmanager: Session = {
         let configuration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier! + ".background")
         return Session(configuration: configuration)
     }()
     
    private var activeRequests: [FileVersionType: UploadRequest] = [:]

    func execute(_ endpoint: Endpoint) -> Promise<NetworkServiceResponse> {
        return Promise<NetworkServiceResponse>(on: .global()) { fulfill, reject in
            do {
                let request = try self.request(by: endpoint)
                request.responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success(let data):
                        print("🎉 Enter In Success")
                        fulfill(NetworkServiceResponse(data: data,
                                                       statusCode: response.response?.statusCode,
                                                       headers: response.response?.allHeaderFields))
                    case .failure(let error):
                        print("💀 Enter Failure")
                        reject(error)
                    }
                })
            } catch {
                print("💀 Parameter Error: \(error)")
                reject(error)
            }
        }
    }



    private func request(by endpoint: Endpoint) throws -> DataRequest {
        var params = [String: Any]()
        for (key, value) in endpoint.parameters {
            if value is String {
                 params[key] = (value as?String)?.cerqel_replacedArabicDigitsWithEnglish
                 params[key] = (value as?String)?.sanitized ?? ""
//                if (value as?String)!.containsScriptTag {
//                    params[key] = (value as?String)?.sanitized ?? ""
//                   throw ServerError (message : "\(key) has harmful value")
//                }
            }
            else{
                params[key] = value
            }
        }
        print("ℹ️ Endpoint URL : \(endpoint.service.url + endpoint.urlPrefix)")
        print("ℹ️ Method : \(endpoint.method.alamofireEndpoint)")
        print("ℹ️ Parameters : \(params.filter{ $0.value as?Int != 0})")
        print("ℹ️ Headers : \(concatenateHeaders(for: endpoint))")

//          var filtedParams: [String:Any] = params
//           filtedParams = params.filter{$0.value as?String != "" && $0.value as?Int != 0}

        var filtedParams: [String:Any] = params
         filtedParams = params.filter{ $0.value as?Int != 0}

        
        return manager.request(endpoint.service.url + endpoint.urlPrefix,
                               method: endpoint.method.alamofireEndpoint,
                               parameters: filtedParams,
                               encoding: endpoint.encoding.alamofireEncoding,
                               headers: HTTPHeaders(concatenateHeaders(for: endpoint)))
    }

    func uploadMultipart(
        _ endpoint: Endpoint,
        progressCallBack: @escaping (Double, FileVersionType) -> ()
    ) -> Promise<NetworkServiceResponse> {

        return Promise<NetworkServiceResponse>(on: .global()) { fulfill, reject in
            self.upload(by: endpoint) { result in

                let fileVersionType = endpoint.parameters["fileVersion"] as? FileVersionType ?? .english

                switch result {
                case .success(let uploadRequest):

                    uploadRequest.uploadProgress { progress in
                        print("💛💛💛 \(progress.fractionCompleted)")
                        progressCallBack(progress.fractionCompleted, fileVersionType)
                    }

                    self.activeRequests[fileVersionType] = uploadRequest

                    uploadRequest.response { response in
                        guard let data = response.data else {
                            reject(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
                            return
                        }
                        
                        fulfill(NetworkServiceResponse(
                            data: data,
                            statusCode: response.response?.statusCode,
                            headers: response.response?.allHeaderFields
                        ))
                    }

                case .failure(let error):
                    print("Enter Failure ❤️")
                    reject(error)
                }
            }
        }
    }

    private func upload(
        by endpoint: Endpoint,
        completionHandler: @escaping (Swift.Result<UploadRequest, AFError>) -> Void
    ) {
        var params = [String: Any]()
        
        for (key, value) in endpoint.parameters {
            if let v = value as? String {
                params[key] = v.cerqel_replacedArabicDigitsWithEnglish
            } else {
                params[key] = value
            }
        }

        let upload = AF.upload(
            multipartFormData: { form in
                for (key, value) in params {
                    if key == "files", let file = value as? FileRequest {
                        form.append(
                            file.date,
                            withName: key,
                            fileName: "file\(Date()).\(file.extenstion.rawValue)",
                            mimeType: file.extenstion == .PNG
                                ? "image/\(file.extenstion.rawValue)"
                                : "application/\(file.extenstion.rawValue)"
                        )
                    } else {
                        form.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
            },
            to: endpoint.service.url + endpoint.urlPrefix,
            method: endpoint.method.alamofireEndpoint,
            headers: HTTPHeaders(concatenateHeaders(for: endpoint))
        )

        // this is correct:
        completionHandler(.success(upload))
    }



    private func download(_ filesUrl: [String], completionHandler: @escaping (URL) -> Void) {
        
        for fileUrl in filesUrl {
            print("ℹ️ url : \(fileUrl)")
            
            guard let fileURL = URL(string: fileUrl) else { continue }
            
            let destination: DownloadRequest.Destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let outputURL = documentsURL.appendingPathComponent("file.pdf")
                return (outputURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            AF.download(
                fileURL,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil,
                to: destination
            )
            .downloadProgress { progress in
                let percent = progress.fractionCompleted * 100
                print("🩷🩷🩷\(percent)")
            }
            .response { response in
                if let httpResponse = response.response,
                   httpResponse.statusCode == 200,
                   let fileUrl = response.fileURL {

                    completionHandler(fileUrl)
                }
            }
        }
    }

    
    func downloadFile(_ filesUrl: [String]) -> Promise<URL> {
          return Promise<URL>(on: .global()) { fulfill, reject in
            //  for file in filesUrl {
                  self.download(filesUrl, completionHandler: { (url) in
                      fulfill(url)
                  })
           //   }
           
          }
    }
    
    func cancelUpload(_ fileVersionType: FileVersionType) {
            if let request = activeRequests[fileVersionType] {
                request.cancel()
                activeRequests[fileVersionType] = nil
            }
        }
    
    private func concatenateHeaders(for endpoint: Endpoint) -> [String: String] {
        var headers = endpoint.headers.filter{$0.value != ""}
        for (key, value) in endpoint.auth.tokenHeader {
            headers.updateValue(value, forKey: key)
            
        }
        for (key, value) in endpoint.auth.clientHeader {
            headers.updateValue(value, forKey: key)
            headers.updateValue("iOS", forKey: "Platform")
            headers.updateValue(AuthManager.shared.tenant?.tenantId ?? "", forKey: "TenantId")
        }
        return headers
    }

    private func uploadFileNotificationCenter(progress: Double,fileVersionType: FileVersionType){
      
        let progressValue: [String: Any] = ["progress": progress,"fileVersionType": fileVersionType]
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inProgress"), object: nil, userInfo: progressValue)
    }
    
    // MARK: - Payload Preparation
    func prepareJsonPayload(from payload: [ProfileSections: Any]) -> [String: Any] {
        var jsonPayload: [String: Any] = Dictionary(
            uniqueKeysWithValues: payload.map { ($0.key.rawValue, $0.value) }
        )
        
        jsonPayload["userId"] = AuthManager.shared.profile.value?.id ?? ""
        
        // Convert profilePicture array -> single object
        if let arr = jsonPayload["profilePicture"] as? [[String: Any]],
           let first = arr.first {
            jsonPayload["profilePicture"] = first
        }
        return jsonPayload
    }

    // MARK: - Parameters
    func prepareParameters(with jsonPayload: [String: Any]) -> [[String: Any]] {
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonPayload, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        if AuthManager.shared.profilePicture.value?.0 != nil {
            return [
                ["key": "data", "value": jsonString, "type": "text"],
                ["key": "profilePicture", "type": "file"]
            ]
        } else {
            return [
                ["key": "data", "value": jsonString, "type": "text"]
            ]
        }
    }

    // MARK: - Multipart Body
    func buildMultipartBody(parameters: [[String: Any]], boundary: String) throws -> Data {
        var body = Data()
        for param in parameters {
            if param["disabled"] != nil { continue }
            guard let paramName = param["key"] as? String else { continue }
            
            body += Data("--\(boundary)\r\n".utf8)
            body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)
            
            if let contentType = param["contentType"] as? String {
                body += Data("\r\nContent-Type: \(contentType)".utf8)
            }
            
            let paramType = param["type"] as! String
            if paramType == "text", let paramValue = param["value"] as? String {
                body += Data("\r\n\r\n\(paramValue)\r\n".utf8)
            } else if paramType == "file",
                      let image = AuthManager.shared.profilePicture.value?.0,
                      let fileContent = image.jpegData(compressionQuality: 1.0) {
                body += Data("; filename=ProfilePicture.jpeg\r\n".utf8)
                body += Data("Content-Type: image/jpeg\r\n\r\n".utf8)
                body += fileContent
                body += Data("\r\n".utf8)
            }
        }
        body += Data("--\(boundary)--\r\n".utf8)
        return body
    }

    // MARK: - Request Builder
    func buildRequest(with body: Data, boundary: String) -> URLRequest {
        var request = URLRequest(url: URL(string: EndpointService.saveProfile.url)!, timeoutInterval: 60)
        request.httpMethod = "PUT"
        request.httpBody = body
        
        request.addValue("application/json, text/plain, */*", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "authorization")
        request.addValue("no-cache", forHTTPHeaderField: "cache-control")
        request.addValue(isArabic() ? "ar" : "en", forHTTPHeaderField: "languagecode")
        request.addValue(AuthManager.shared.tenant?.tenantId ?? "", forHTTPHeaderField: "tenantid")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("iOS", forHTTPHeaderField: "Platform")
        
        return request
    }

    // MARK: - Networking
    func performRequest(_ request: URLRequest, completion: @escaping (BaseError?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.other(title: error.localizedDescription))
                return
            }
            guard let data = data else {
                completion(.decodeResponse)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let success = json["success"] as? Bool, success == false {
                        let message = json["message"] as? String ?? "Unknown error"
                        completion(.other(title: message))
                        return
                    }
                }
                completion(nil) // ✅ No error
            } catch {
                completion(.decodeResponse)
            }
        }
        task.resume()
    }

}

extension EndpointEncoding {
    var alamofireEncoding: ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .query: return URLEncoding.queryString
        }
    }
}

extension EndpointMethod {
    var alamofireEndpoint: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .delete: return .delete
        case .put: return .put
        case .patch: return .patch
        }
    }
}


extension String {
    var containsScriptTag : Bool {
        // Regex pattern to find text enclosed in <>
        let pattern = "<[^>]*>"

        // Create a regex object
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        // Check if there are any matches
        let matches = regex?.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        // Return true if there are matches
        return matches ?? 0 > 0
    }

    var sanitized: String {
           // Regex pattern to find text enclosed in <>
           let pattern = "<[^>]*>"

           // Create a regex object
           let regex = try? NSRegularExpression(pattern: pattern, options: [])

           // Replace all matches with an empty string
           let sanitizedString = regex?.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "") ?? self

           // Return the modified string
           return sanitizedString
       }
}

enum RequestError: Error {
    case invalidParameter(String)
}
