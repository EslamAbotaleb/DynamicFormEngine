//
//  ServiceImp.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
public import RxSwift
public import RxAlamofire
import UIKit
public import Alamofire
import CommonCrypto
import JGProgressHUD


public struct cerqel_BasicNetworkServiceImpl: cerqel_NetworkService {


    static public let shared = cerqel_BasicNetworkServiceImpl()

//    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate


    public func load<T>(_ resource: T) -> Observable<T> where T : cerqel_CodableResponseProtocol {
        return
        RxAlamofire
            .request(resource.action)
            .validate(statusCode: 200 ..< 401)
            .responseJSON()
            .do(onError: { err in
                if let val = err as? AFError, val.responseCode == 401
                {
                    guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
                    TokenManager.shared.refreshToken {
                        // Retry the request after token refresh

                        _ = self.load(resource).subscribe(onNext: { result in
                        }, onError: { retryError in

                        })
                    }

                }

            })
            .map { $0.data }
            .filter { $0 != nil }
            .map { $0! }
            .flatMap(resource.parse)
    }
    //
    public func uploadImage<T>(_ resource: cerqel_CodableResponseObject<T>,
                        image: UIImage?,
                        imageParam: String) -> Observable<cerqel_CodableResponseObject<T>> where T: Decodable {
        
        return Observable.create { observer in
            
            let parameters: [String: Any] = resource.action.actionParameters
            
            // Create the upload request
            let request = AF.upload(multipartFormData: { multipartFormData in
                
                // Append image if available
                if let image = image, let imageData = image.jpegData(compressionQuality: 0.4) {
                    multipartFormData.append(imageData,
                                             withName: imageParam,
                                             fileName: "file.jpg",
                                             mimeType: "image/jpg")
                }
                
                // Append other parameters
                for (key, value) in parameters {
                    switch value {
                    case let v as Int:
                        multipartFormData.append("\(v)".data(using: .utf8)!, withName: key)
                    case let v as Double:
                        let data = withUnsafeBytes(of: v) { Data($0) }
                        multipartFormData.append(data, withName: key)
                    case let v as String:
                        multipartFormData.append(v.data(using: .utf8)!, withName: key)
                    default:
                        break
                    }
                }
                
            }, to: resource.action.baseURL.appending(resource.action.path),
               method: .post,
               headers: HTTPHeaders(resource.action.authHeader))
            
            // Handle response
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(cerqel_CodableResponseObject<T>.self, from: data)
                        observer.onNext(decoded)
                        observer.onCompleted()
                    } catch {
                        print("Decoding error: \(error)")
                        observer.onError(BaseError.decodeResponse)
                    }
                    
                case .failure(let error):
                    print("Upload error: \(error)")
                    observer.onError(BaseError.serverError)
                }
            }
            
            return Disposables.create {
                request.cancel() // cancel if disposed
            }
        }
    }

    public func load<T>(_ resource: cerqel_ArrayResource<T>) -> Observable<[T]> where T : Codable {
        return
        RxAlamofire
            .request(resource.action)
            .responseJSON()
            .map { $0.data ?? Data() }
            .flatMap(resource.parse)
    }
}
