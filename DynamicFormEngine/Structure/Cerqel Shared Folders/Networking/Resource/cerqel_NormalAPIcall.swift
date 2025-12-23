//
//  CodableResponseNormal.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/14/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import RxSwift
internal import Alamofire
internal import MOLH
import UIKit

class cerqel_NormalAPIcall{
    
    struct NetworkingManager {
        
        static let shared: Alamofire.Session = {
              let configuration = URLSessionConfiguration.default
              configuration.timeoutIntervalForRequest = 30
              configuration.timeoutIntervalForResource = 30
              
              let session = Session(configuration: configuration)
              return session
          }()
    }

    
    class func sendRequest(action: cerqel_BasicActionDynamicForm, closure: @escaping ([String: Any]?) -> Void){
        
        let URL1 = action.baseURL + action.path
                
        #if DEBUG
        print("URL:\(URL1)")
        print(action.actionParameters)
        #endif
        

        
        NetworkingManager.shared.request(URL1, method: action.method, parameters: action.actionParameters, encoding: action.encoding, headers: HTTPHeaders(action.authHeader)).responseJSON { response in
            
            #if DEBUG
            print("Response: \(response.value)")
            #endif
            switch response.result{
            case .success(_):
                
                if let res = response.value as? [String: Any]{
                    closure(res)
                }else{
                    closure(nil)
                }
                guard let statusCode = response.response?.statusCode else {return}
//                switch statusCode {
//                case 401,403:
//                    Constants.logout(statusCode: statusCode)
//                case 500 ... 599:
//                    if !multiRequest{
//                        LoadingOverlay.hideOverlay()
//                    }
//                    AlertUtility.showInternalServerAlert()
//                default:
//                    break
//                }
                
            case .failure(_):
                print(response.value)
                
                
//                if let res = response.result.value as? [String: Any]{
//                    closure(res)
//                }else{
//                    closure(nil)
//                }
//                guard let statusCode = response.response?.statusCode else {return}
//                switch statusCode {
//                case 401,403:
//                    Constants.logout(statusCode: statusCode)
//                case 500 ... 599:
//                    if !multiRequest{
//                        LoadingOverlay.hideOverlay()
//                    }
//                    AlertUtility.showInternalServerAlert()
//                default:
//                    break
//                }
            }
            
        }
        
    }
    
    func uploadFile(action: cerqel_BasicActionDynamicForm, photo: UIImage?, fileUrl: URL?, onCompletion: (([String: Any]?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil) {
        let URL1 = action.baseURL + action.path
        
        AF.upload(multipartFormData: { multipartFormData in
            // Append parameters
            for (key, value) in action.actionParameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            // Append image if exists
            if let img = photo, let data = img.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(data, withName: "files", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
            
            // Append file URL if exists
            if let url = fileUrl {
                multipartFormData.append(url, withName: "files")
            }
            
        }, to: URL1, usingThreshold: UInt64.init(), method: action.method, headers: HTTPHeaders(action.authHeader))
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Successfully uploaded")
                onCompletion?(value as? [String: Any])
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
