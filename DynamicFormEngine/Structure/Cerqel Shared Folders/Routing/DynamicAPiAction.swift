//
//  DynamicAPiAction.swift
//  CERQEL
//
//  Created by hassan elshaer on 18/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
public import Alamofire

public enum Dynamic_BasicAction: cerqel_APIActionDynamicForm {
    public var basicAction: cerqel_BasicActionDynamicForm{return .none}
    
    case submitService(Id: String, payload: [String: Any])
    case requestDetails(id: String)
    case taskDetails(id: String)
    case fetchRequestChat(id: String)
    case addChatComment(payload: [String: Any])
    case uploadFile(isPublic: Bool, isAuthorize: Bool? = true, serviceType: Int?)
    case executeAction(payload: [String: Any])
    case updateRequest(payload: [String: Any])
    case reopenRequest(payload: [String: Any])
    case withdrawRequest(payload: [String: Any])
    case searchEmployees(email: String)
    case searchServices(text: String)
    case fetchCascadingOptions(code: String, parentValue: [String:String], targetComponents: [[String:String?]])
    case fetchCascadingOptionsWithMultiParents(code: String, parameters: [[String:String]], targetComponents: [[String:String?]])
    case fetchDataSourceOptions(code: String, parameters: [[String:String]], targetComponents: [[String:String?]])
    case fetchDDLOptions(code: String, targetComponents: [[String:String?]])
    case fetchSearchOptions(code: String,keyword: String, parameters: [String:String]?, targetComponents: [[String:String?]])
    case fetchAwaitingRequests
    case performSearchFromSearchControlInFormBuilder(url: String)
    case getServicesList(categoryId: String)
    case getCategorieswithServices
//    case getRequestsList(payload: RequestSubmitModel,isTasks: Bool)
    case addServiceToFavourite(id: String, isFav: Bool)
    case getFavoriteServices
    case getRecentServices
    case submitEditRequestService(Id: String, payload: [String: Any])
    case none

    public var actionParameters: [String : Any]{
        switch self {
    
            
        case .submitService(_, let payload):
            return payload
        case .submitEditRequestService(_, let payload):
            return payload
            
        case .addChatComment(let payload):
            return payload
        case .executeAction(let payload):
            return payload
        case .updateRequest(let payload):
            return payload
        case .reopenRequest(let payload):
            return payload
        case .withdrawRequest(let payload):
            return payload
            
        case .uploadFile:
            return [
                "Content-Disposition": "form-data",
                "name": "files",
                "Content-Type": "application/json"
            ]
            
        case .searchEmployees(let email):
            return [
                "SearchKeyword": email
            ]
            
        case .searchServices:
            return [
                "pageNumber": 1,
                "pageSize": 1000
            ]
            
            
        case .fetchCascadingOptionsWithMultiParents(let code, let parameters, let targetComponents):
            if parameters.count > 0 {
                return [
                    "code": code,
                    "parameters": parameters,
                    "targetComponents": targetComponents
                ]
            }else {
                return [
                    "code": code,
                    "parameters": [],
                    "targetComponents": targetComponents
                ]
            }
            
        case .fetchCascadingOptions(let code, let parentValue, let targetComponents):
            var params = [[String:String]]()
            params.append(parentValue)
            if params.count > 0 {
                return [
                    "code": code,
                    "parameters": params,
                    "targetComponents": targetComponents
                ]
            }else {
                return [
                    "code": code,
                    "targetComponents": targetComponents
                ]
            }
            
        case .fetchDataSourceOptions(let code, let parameters, let targetComponents):
            if parameters.count > 0 {
                return [
                    "code": code,
                    "parameters": parameters,
                    "targetComponents": targetComponents
                ]
            }else {
                return [
                    "code": code,
                    "targetComponents": targetComponents
                ]
            }
            
        case .fetchDDLOptions(let code, let targetComponents):
            return [
                "code": code,
                "targetComponents": targetComponents
            ]
            
        case .fetchSearchOptions(let code,let keyword, let parameters, let targetComponents):
            var params = [[String:String]]()
            if keyword != "" {
                params.append(["SearchBy": keyword])
            }
            if let pVal = parameters, pVal.first?.key != "" {
                params.append(pVal)
            }
            return [
                "code": code,
                "parameters": params,
                "targetComponents": targetComponents
            ]
//        case .getRequestsList(payload: let payload, let isTask):
//            let  json: [String: Any] =   payload.toJSON()
//            return json
        case .addServiceToFavourite(let id, let isFav):
            return [
                "serviceId" : "\(id)",
                "isFavorite" : isFav
            ]
            
      
        default:
            return [:]
        }
    }

    public var method: HTTPMethod {
        switch self {
   
        case .submitService, .addChatComment, .uploadFile, .executeAction, .updateRequest, .reopenRequest, .withdrawRequest,.submitEditRequestService:
            return .post
        case .addServiceToFavourite, .searchEmployees, .searchServices:
            return.post
        case .fetchSearchOptions, .fetchDDLOptions, .fetchDataSourceOptions, .fetchCascadingOptions, .fetchCascadingOptionsWithMultiParents:
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

        case .submitService(let id, _):
            return "Request/InitiateRequest/\(id)"
        case .submitEditRequestService(let id, _):
            return "Request/EditRequest/\(id)"
        case .requestDetails(id: let id):
            return "Request/GetById/\(id)"
        case .taskDetails(id: let id):
            return "Tasks/GetById/\(id)"
        case .fetchRequestChat(let id):
            return "RequestComments/GetByRequestId/\(id)"
        case .addChatComment:
            return "RequestComments/Add"
        case .executeAction:
            return "Tasks/ExecuteAction"
        case .updateRequest:
            return "Request/UpdateRequest"
        case .reopenRequest:
            return "Request/ReopenRequest"
        case .withdrawRequest:
            return "Request/WithdrawRequest"
        case .uploadFile(let isPublic, let isauth, let serviceType):
            if let serviceType = serviceType {
                return "FileManager/UploadFiles/0?isPublic=\(isPublic)&serviceType=\(serviceType)"
            } else {
                return "FileManager/UploadFiles/0?isPublic=\(isPublic)"
            }
       
        case .searchEmployees:
            return "Users/GetAll"
        case .searchServices(let text):
            return "SelfServices/Search?keyword=\(text)"
            
        case .fetchSearchOptions:  return "ListOfValues/api/List/GetListByCode"
        case .fetchCascadingOptions:  return "ListOfValues/api/List/GetListByCode"
        case .fetchDDLOptions:  return "ListOfValues/api/List/GetListByCode"
        case .fetchDataSourceOptions: return "ListOfValues/api/List/GetListByCode"
        case .fetchCascadingOptionsWithMultiParents:
            return"ListOfValues/api/List/GetListByCode"
        case .fetchAwaitingRequests:
            return "Tasks/GetUserTasksAsync"

        case .performSearchFromSearchControlInFormBuilder(let url):
            return url
        case .getServicesList(let categoryId):
            return "SelfServices/GetAllByCategoryId/\(categoryId)"
        case .getCategorieswithServices:
            return "Categories/GetCategoriesWithServices"
       
        case .addServiceToFavourite:
            return "UserServices/Add"
        case .getFavoriteServices:
            return "SelfServices/GetUserFavoriteServices"
        case .getRecentServices:
            return "SelfServices/GetRecentServices"
        case .none:
            return ""
        }
        

    }

    
    public  var authHeader: [String : String]{
        switch self {
        default:
            let head = [
                "Authorization": "Bearer " + AuthManager.shared.token,
                "TenantId": AuthManager.shared.tenant?.tenantId ?? "",
                "LanguageCode": isArabicCerqel() ? "Ar" : "En",
                "Platform":"IOS",
                "Content-Type":"application/json",
                "charset" : "utf-8"
            ]
            
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
    
    
    public   var isMock: Bool{
        switch self {
        default:
            return false
        }
    }
    
    public  var urlType: cerqel_URLType{
        switch self {
        case .submitService, .getServicesList, .getCategorieswithServices, .addServiceToFavourite, .getFavoriteServices, .getRecentServices,.submitEditRequestService:
            return .selfService
            
        case .fetchRequestChat, .addChatComment, .executeAction, .updateRequest, .reopenRequest, .searchServices, .withdrawRequest, .fetchAwaitingRequests:
            return .selfService
        
            
        case .uploadFile:
            return .fileManager
//        case .fetchCascadingOptionsWithMultiParents:
//            return .none
            
        case .performSearchFromSearchControlInFormBuilder:
            return .none
        default:
            return .base
        }
    }
    
    
}
