//
//  BasicAction.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
public import Alamofire

public enum cerqel_BasicActionDynamicForm: cerqel_APIAction {
    case fetchService(Id: String)
    case fetchSubServicesByParent(parentId: String)
    case submitService(Id: String, payload: [String: Any])
    case requestDetails(id: String)
    case taskDetails(id: String)
    case fetchAllService
    case fetchRequestChat(id: String)
    case addChatComment(payload: [String: Any])
    case uploadFile(isPublic: Bool, serviceType: Int? = nil)
    case executeAction(payload: [String: Any])
    case reopenRequest(payload: [String: Any])
    case withdrawRequest(requestId: String)
    case fetchSubServices(serviceId: String)
    case fetchAwaitingRequests
    case performSearchFromSearchControlInFormBuilder(url: String)
    case searchList(payload:SearchPayload)
    case none

    public var actionParameters: [String : Any]{
        switch self {
        case .submitService(_, let payload):
            return payload
            
        case .addChatComment(let payload):
            return payload
        case .executeAction(let payload):
            return payload
        case .reopenRequest(let payload):
            return payload
            //        case .withdrawRequest(let payload):
            //            return payload
      
        case .uploadFile:
            return [
                "Content-Disposition": "form-data",
                "name": "files",
                //                "type":"application/pdf",
                //                "filename":"CertificateTest1.pdf",
                "Content-Type": "application/json"
            ]
            
        case .searchList(let payload):
            let  json: [String: Any] = payload.toJSON()
            return json
            
        default:
            return [:]
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .searchList:
            return .post
        case .submitService, .addChatComment, .uploadFile, .executeAction, .reopenRequest, .withdrawRequest:
            return .post
        default:
            return .get
        }
    }
    
    var sendLocation: Bool {
        switch self {
            
        default:
            return false
        }
    }
    
    public var path: String {
        switch self {
        case .fetchService(let id):
            return "SelfServices/RequestService/\(id)"
        case .fetchSubServicesByParent(let parentId):
            return "SelfServices/GetSubServicesByServiceId/\(parentId)"
        case .submitService(let id, _):
            return "Request/InitiateRequest/\(id)"
        case .requestDetails(id: let id):
            return isMock ? "" : "Request/GetById/\(id)"
        case .taskDetails(id: let id):
            return isMock ? "" : "Tasks/GetById/\(id)"
            
        case .fetchAllService:
            return "SelfServices/GetAll"
        case .fetchRequestChat(let id):
            return "RequestComments/GetByRequestId/\(id)"
        case .addChatComment:
            return "RequestComments/Add"
        case .executeAction:
            return "Tasks/ExecuteAction"
        case .reopenRequest:
            return "Request/ReopenRequest"
        case .withdrawRequest(let id):
            return "Request/Withdraw/\(id)"
        case .uploadFile(let isPublic, let serviceType):
            if let serviceType = serviceType {
                return "FileManager/UploadFiles/0?isPublic=\(isPublic)&serviceType=\(serviceType)"
            } else {
                return "FileManager/UploadFiles/0?isPublic=\(isPublic)"
            }
       
        case .none:
            return ""
    
        case .fetchSubServices(let serviceId):
            return "SelfServices/GetSubServicesByServiceId/\(serviceId)"
            
        case .fetchAwaitingRequests:
            return "Tasks/GetUserTasksAsync"
    
        case .performSearchFromSearchControlInFormBuilder(let url):
            return url
      
        case .searchList:
            return "Engine/Autocomplete"
        }
    }
    
    
    public var authHeader: [String : String]{
        switch self {
        default:
            var head = [
                "Authorization": "Bearer " + AuthManager.shared.token ,
                "TenantId": AuthManager.shared.tenant?.tenantId ?? "",
                "LanguageCode": isArabicCerqel() ? "Ar" : "En",
                "Platform":"IOS",
                "Content-Type":"application/json",
                "charset" : "utf-8",
                "TimeZone": TimeZone.current.identifier
            ]
            print(head)
            return head
        }
    }
    
    public var encoding: ParameterEncoding {
        switch method {
        case .post, .put, .delete, .patch :
            return JSONEncoding.default
        default :
            return URLEncoding.default
        }
    }
    
    
    public  var isMock: Bool{
        switch self {
        case .requestDetails, .taskDetails:
            return false
        default:
            return false
        }
    }
    
    public var urlType: cerqel_URLType{
        switch self {
        case .requestDetails, .taskDetails, .fetchSubServices:
            return .selfService
            
        case .fetchService, .submitService, .fetchAllService, .fetchSubServicesByParent:
            return .selfService
            
        case .fetchRequestChat, .addChatComment, .executeAction, .reopenRequest, .withdrawRequest:
            return .selfService
            
        case .uploadFile:
            return .fileManager
       
        case .performSearchFromSearchControlInFormBuilder:
            return .none
        case .searchList:
            return .userManager
    
        default:
            return .base
        }
    }
    
    public var basicAction: cerqel_BasicActionDynamicForm {
        switch self {
        case .requestDetails(_):
            return .requestDetails(id: "")
        case .taskDetails(_):
            return .taskDetails(id: "")
        default: return .none
        }
    }
}
