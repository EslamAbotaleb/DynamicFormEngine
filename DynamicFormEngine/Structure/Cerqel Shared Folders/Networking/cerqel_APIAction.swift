//
//  APIAction.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
public import Alamofire

public enum cerqel_URLType{
    case Content
    case selfService
    case userManager
    case Notification
    case fileManager
    case searchEngine
    case base
    case mocking
    case none
}

public enum UrlBaseEndpoints: String {
    case content = "gw/content/api/"
    case selfService = "gw/selfservices/api/"
    case userManager = "gw/usermanager/api/"
    case notification = "gw/notifications/api/"
    case fileManager = "gw/Storage/api/"
    case mocking = "https:/$()/m6djv.wiremockapi.cloud/"
}

public protocol cerqel_APIActionDynamicForm: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var actionParameters: [String: Any] { get }
    var baseURL: String { get }
    var authHeader: [String: String] { get }
    var encoding: ParameterEncoding { get }
    var isMock: Bool { get }
    var urlType: cerqel_URLType { get }
    var basicAction: cerqel_BasicActionDynamicForm { get }
}

extension cerqel_APIActionDynamicForm {
    public var actionParameters: [String : Any] {
        return [:]
    }
    public var authHeader: [String : String] {
        return  [
//            "Accept-Language": arOrEn(),
//            "app-version":Global.share.version,
            "device-type":"ios",
            "Content-Type" :"application/json; charset=utf-8"
        ]

    }
    
   public var baseURL: String {
        if isMock{
            switch basicAction {
            case .requestDetails(_):
                return AuthManager.shared.newSubmissionRetreiveEnabled ?  "https://demo2590693.mockable.io/requestDetails" /* new structure */ : "https://demo2590693.mockable.io/requestDetails" /* old structure */
    
            case .taskDetails(_):
                return AuthManager.shared.newSubmissionRetreiveEnabled ? "https://demo2590693.mockable.io/requestDetails" /* new structure */ : "https://demo2590693.mockable.io/requestDetails" /* old structure */
            default:
                return ""
            }
//            return "https://24d01c0f-97ba-4f2b-b644-e3332e675c9b.mock.pstmn.io/"
        }
        
        switch urlType {
        case .Content:
            return cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.content.rawValue
        case .selfService:
            return cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.selfService.rawValue
        case .userManager:
            return cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.userManager.rawValue
        case .Notification:
            return cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.notification.rawValue
        case .fileManager:
            return cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.fileManager.rawValue
        case .mocking:
            return UrlBaseEndpoints.mocking.rawValue
        case .none:
            return ""

        default:
            return cerqel_Environment.Api_Base_URL

        }
    }
    var isMock: Bool{
        return false
    }
    
}

extension cerqel_APIActionDynamicForm {
    
    public func asURLRequest() throws -> URLRequest {
        let urlString = baseURL.appending(path)
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded ?? "")
            
        

        let originalRequest = try URLRequest(url: url!,
                                             method: method,
                                             headers: HTTPHeaders(authHeader))
        let encodedRequest = try encoding.encode(originalRequest,
                                                 with: actionParameters)
        
        print("actionParameters")
        print(actionParameters)
        print("httpBodyhttpBody")
        print(encodedRequest.httpBody?.cerqel_prettyPrintedJSONString)
        print("http method")
        print(encodedRequest.httpMethod)
        print(baseURL.appending(path))
        
        return encodedRequest
    }
}

extension Data {
    public var cerqel_prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
