//
//  BasicAction.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import Alamofire


enum cerqel_BasicAction: cerqel_APIAction {
    
//    case newsDetails(id: String, payload: BasePayloadCerqel)
    case newsList(pageNumber: Int, pageSize: Int)
//    case newsListNew(payload: BasePayloadCerqel)
    case pinnedNews
    case newsBookmarkList(pageNumber: Int, pageSize: Int)
    case addNewsToFavourite(id: String)
//    case announcementsList(payload:BasePayloadCerqel)
    case announcementsFavList(pageNumber: Int, pageSize: Int)
//    case announcementDetails(id: String,payload:BasePayloadCerqel)
    case addAnnounceToFavourite(id: String)
    case internalNewsList(pageNumber: Int, pageSize: Int)
    case myTasksStatistics
    case myRequestsStatistics
    case internalNewsFavList(pageNumber: Int, pageSize: Int)
    case internalNewsDetails(id: String)
    case addinternalNewsToFavourite(id: String)
//    case eventsList(payload:BasePayloadCerqel)
    case eventList(pageNumber: Int, pageSize: Int, fromDate: String, toDate: String?)
    case eventDetails(id: String)
//    case offersList(payload: DealsPromotionsSubmitModelCerqel)
    case offersCategoryList
//    case offerDetails(id: String,payload:BasePayloadCerqel)
    case addOfferToFavourite(id: String)
    case login(username: String, Password: String)
    case token(accessToken: String, otp: String)
    case fetchProfile
    
    case CategoryList
    case subCategory(catId: String)
    
    case taskList(pageNumber: Int, pageSize: Int, filter: [String:Any])
    case requestList(pageNumber: Int, pageSize: Int, filter: [String:Any])
    
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
    // case withdrawRequest(payload: [String: Any])
    case withdrawRequest(requestId: String)
//    case notificationList(payload: NotificationSubmitModelCerqel)
    case SetNotificationAsOpen(notId: String)
    case unOpenedNotificationCount
    case getEmergncyContacts
    case getPayrollInfo
    case getContactAddress
    case dependents
    case getCourses
    case getEmploymentInfo
    case getEducations
    case getWorkExperience
    case getFavoriteServices
    case addServiceToFavourite(id: String, isFav: Bool)
    case getUserProfileByEmail(email: String)
    case searchEmployees(email: String)
    case searchServices(text: String)
    case fetchCascadingOptions(endPoint: String)
    case fetchSubServices(serviceId: String)
    case fetchAwaitingRequests
    case pushNotification_Register(fcmToken: String ,deviceId: String)
    case pushNotification_UnRegister(regId: String)
    case fetchGlobalSearch(keyword: String, categories: [String], pageNumber: Int, pageSize: Int)
    case RSA_login(username: String, password: String, pin: String)
    case RSA_verify(userId: String, authnAttemptId: String, inResponseTo: String, methodId: String, oda: String)
    case whatsNew
    case whatsNewSearchPortal
    case doNotShowAgain(id: String, status: Bool)
    case performSearchFromSearchControlInFormBuilder(url: String)
//    case mediaList(payload: BasePayloadCerqel)
//    case mediaDetails(id: String, payload: BasePayloadCerqel)
    case invitePeople(searchTxt:String)
    case suggestedPeopleList
    case getEventDetails(id:String)
//    case addEvent(payload:AddEventSubmitModelCerqel)
//    case editEvent(payload:AddEventSubmitModelCerqel, id: String)
    case deleteEvent(id: String)
    case calendarHomeList
    case calendarEvents(fromDate: String, toDate: String)
//    case fetchFAQList(payload: FAQSubmitModelCerqel)
    case fetchFAQCategories
//    case fetchKnowledgeBaseList(payload: KnowledgeBaseSubmitModelCerqel)
    case fetchKnowledgeBaseCategories
//    case fetchMyApps(payload: MyAppSubmitModelCerqel)
    case fetchRecentlyUsedApps
    case addAppToHistory(appId: String)
    case getColorsCustomization
    case getFilterCategories(path: String)
    case getUsserInfoByBCID(id: String)
    case getOrganizationStruc(personId: String)
    case searchList(payload:SearchPayload)
    case none
    case myRequestsChart
    case myTasksChart

    
    var actionParameters: [String : Any]{
        switch self {
        case .login(let username, let Password):
            return [
                //                "grant_type" : "password",
                "username" : username,
                "password" : Password
                //                "scope" : "OTP",
                //                "client_id" : Environment.loginClientId,
                //                "client_secret" : Environment.loginClientSecret,
                //                "realm" : "provider/ldap",
                //                "iv" : Environment.loginIV
            ]
            
        case .token(let accessToken, let otp):
            return [
                "access_token" : accessToken,
                "otp" : otp,
                "scope" : "diwan"
            ]
            
        case .fetchGlobalSearch(let keyword, let categories, let pageNumber, let pageSize):
            return [
                "keyword": keyword,
                "categories": categories,
                "pagination": [
                    "pageNumber": pageNumber,
                    "pageSize": pageSize
                ]
            ]
            
        case .taskList(let pageNumber, let pageSize, let filter):
            var dic = [String:String]()
            dic["colId"] = "createdDate"
            dic["sort"] = "desc"
            var arr = [[String:String]]()
            arr.append(dic)
            return [
                "pageNumber" : "\(pageNumber)",
                "pageSize" : "\(pageSize)"
                ,"orderByValue": arr
                ,"filter": filter
            ]
        case .requestList(let pageNumber, let pageSize, let filter):
            var dic = [String:String]()
            dic["colId"] = "createdDate"
            dic["sort"] = "desc"
            var arr = [[String:String]]()
            arr.append(dic)
            return [
                "pageNumber" : "\(pageNumber)",
                "pageSize" : "\(pageSize)"
                ,"orderByValue": arr
                ,"filter": filter
            ]
            
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
        case .addServiceToFavourite(let id, let isFav):
            return [
                "serviceId" : "\(id)",
                "isFavorite" : isFav
            ]
            
        case .uploadFile:
            return [
                "Content-Disposition": "form-data",
                "name": "files",
                //                "type":"application/pdf",
                //                "filename":"CertificateTest1.pdf",
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
            
        case .doNotShowAgain(_ , let status):
            return [
                "status": status
            ]
            
        case .RSA_login(let username, let Password, let pin):
            return [
                "userName" : username,
                "password" : Password,
                "pin" : pin
            ]
            
        case .RSA_verify(let userId, let authnAttemptId, let inResponseTo, let methodId, let oda):
            return [
                "userId": userId,
                "authnAttemptId": authnAttemptId,
                "inResponseTo": inResponseTo,
                "methodId": methodId,
                "oda": oda
            ]
            
        case .whatsNewSearchPortal:
            return [
                "filter": [
                    "query": nil
                ],
                "orderByValue" : [
                    [
                        "colId": "publishDate",
                        "sort": "desc"
                    ]
                ],
                "pageNumber": 1,
                "pageSize":  50
            ]
            
            
      
            
        case .searchList(let payload):
            let  json: [String: Any] = payload.toJSON()
            return json
        case .getUsserInfoByBCID (let id):
            return [
                "bcid": id
            ] 
        case .invitePeople(let searchText) :
            return  ["searchString": searchText]
            
        case .suggestedPeopleList:
            return ["searchString": ""]
            
        default:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsserInfoByBCID, .searchList, .invitePeople, .suggestedPeopleList:
            return .post
        case .deleteEvent:
            return .post
        case .addOfferToFavourite:
            return .post
            case .addNewsToFavourite:
            return .post
        case .addAppToHistory:
            return .post
        case .addAnnounceToFavourite:
            return .post
        case .addinternalNewsToFavourite:
            return .post
        case .login, .token, .RSA_login, .RSA_verify:
            return .post
        case .taskList:
            return .post
        case .requestList, .SetNotificationAsOpen, .unOpenedNotificationCount:
            return .post
        case .submitService, .addChatComment, .uploadFile, .executeAction, .reopenRequest, .withdrawRequest:
            return .post
        case .addServiceToFavourite, .searchEmployees, .searchServices,.fetchGlobalSearch:
            return.post
        case .pushNotification_Register, .pushNotification_UnRegister:
            return .post
        case .doNotShowAgain, .whatsNewSearchPortal:
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
    
    var path: String {
        switch self {
        case .fetchGlobalSearch:
            return "Engine/SearchWithCount"
      
        case .newsList(let pageNumber,let pageSize):
            return "News?PageNumber=\(pageNumber)&PageSize=\(pageSize)"
       
        case .newsBookmarkList(let pageNumber,let pageSize):
            return "News/GetBookmarkedNews?PageNumber=\(pageNumber)&PageSize=\(pageSize)"
        case .pinnedNews:
            return "News/FeaturedNews"
        case .addNewsToFavourite(let id):
            return "News/BookmarkNews/\(id)"
     
        case .addAnnounceToFavourite(let id):
            return "Announcement/BookmarkAnnouncement/\(id)"
       
        case .announcementsFavList(let pageNumber,let pageSize):
            return "Announcement/GetBookmarkedAnnouncment?PageNumber=\(pageNumber)&PageSize=\(pageSize)"
        case .internalNewsDetails(let id):
            return "InternalNews/\(id)"
        case .addinternalNewsToFavourite(let id):
            return "InternalNews/BookmarkNews/\(id)"
        case .internalNewsList(let pageNumber,let pageSize):
            return "InternalNews?PageNumber=\(pageNumber)&PageSize=\(pageSize)"
        case .myTasksStatistics:
            return "CamundaTasks/MyTasksStatistics"
        case .myRequestsStatistics:
            return "CamundaRequest/MyRequestsStatistics"
        case .internalNewsFavList(let pageNumber,let pageSize):
            return "InternalNews/GetBookmarkedNews?PageNumber=\(pageNumber)&PageSize=\(pageSize)"
        case .eventList(let pageNumber,let pageSize, let fromDate, let ToDate):
            if let to = ToDate{
                return
                "Event/GetEventGrid?From=\(fromDate)&To=\(to)&PageNumber=\(pageNumber)&PageSize=\(pageSize)"
            }
            return
            "Event/GetEventGrid?From=\(fromDate)&PageNumber=\(pageNumber)&PageSize=\(pageSize)"
        case .eventDetails(let id):
            return "Event/Get/\(id)"
            
       
        case .addOfferToFavourite(let id):
            return "Offers/BookmarkOffer/\(id)"
            
            //        case .offersList(let pageNumber, let pageSize, let catId, let isNewest):
            //            if let id = catId{
            //                return "Offers/HomeOffersList?categoryId=\(id)&PageNumber=\(pageNumber)&PageSize=\(pageSize)&isNew=\(isNewest)"
            //            }
            //            return "Offers/HomeOffersList?PageNumber=\(pageNumber)&PageSize=\(pageSize)&isNew=\(isNewest)"
        case .offersCategoryList:
            return "Offers/HomeOfferCategories"
      
        case .login:
            return "token/api/v3/Token/Login"
        case .token:
            return "auth/token"
        case .fetchProfile:
            return "UserProfile/User/me"
            
        case .CategoryList:
            return "Categories/GetAll"
        case .subCategory(let id):
            return "Categories/GetBySubCategory?parentCategoryId=\(id)"
            
        case .taskList:
            //            if let bulk = isBulk{
            //                return "Tasks/GetAllPaged?pageNumber=\(pgNum)&pageSize=\(pgSize)isBulk=\(bulk)"
            //            }
            return "Tasks/GetAllPaged"
        case .requestList:
            //            if let bulk = isBulk{
            //                return "Tasks/GetAllPaged?pageNumber=\(pgNum)&pageSize=\(pgSize)isBulk=\(bulk)"
            //            }
            return "Request/GetAllPaged"
            
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
        case .SetNotificationAsOpen(let notId):
            return "InAppNotification/SetNotificationAsOpen/\(notId)"
            
        case .unOpenedNotificationCount:
            return "InAppNotification/UnOpendNotificationCount"
            
        case .getEmergncyContacts:
            return "UserProfileDetails/GetEmergencyContact"
            
        case .getPayrollInfo:
            return "UserProfileDetails/GetPayrollInfo"
        case .dependents:
            return "UserProfileDetails/GetDependents"
        case .getContactAddress:
            return "UserProfileDetails/GetContactAndAddress"
        case .getCourses:
            return "UserProfileDetails/GetCertificates"
        case .getEmploymentInfo:
            return "UserProfileDetails/EmploymentDetails"
        case .none:
            return ""
            
        case .getEducations:
            return "UserProfileDetails/GetEducationHistory"
        case .getWorkExperience:
            return "UserProfileDetails/GetWorkExperience"
        case .getFavoriteServices:
            return "SelfServices/GetUserFavoriteServices"
        case .addServiceToFavourite(let id,let isFav):
            return "UserServices/Add"
            //            return "SelfServices/UserServices/Add?serviceId=\(id)&isFavorite=\(isFav)"
        case .getUserProfileByEmail(let email):
            return "UserProfile/User/GetUserProfileFromAd/\(email)"
        case .searchEmployees:
            return "Users/GetAll"
        case .searchServices(let text):
            return "SelfServices/Search?keyword=\(text)"
            
        case .fetchCascadingOptions(let endPoint):
            return "ListOfValues/api/\(endPoint)"
            
        case .fetchSubServices(let serviceId):
            return "SelfServices/GetSubServicesByServiceId/\(serviceId)"
            
        case .fetchAwaitingRequests:
            return "Tasks/GetUserTasksAsync"
            
        case .pushNotification_Register(let fcmToken,let deviceId):
            return "NotificationRegister/register-device?pns=apns&DeviceId=\(fcmToken)&deviceIMEI=\(deviceId)"

        case .pushNotification_UnRegister(let regId):
            return "NotificationRegister/unregister-device?RegistrationId=\(regId)"
            
        case .RSA_login:
            return "Token/api/Rsa/user-login"
        case .RSA_verify:
            return "Token/api/Rsa/verify"
        case .whatsNew:
            return "WhatIsNew/Notices"
            
        case .whatsNewSearchPortal:
            return "WhatIsNew/Search-Portal"
            
        case .doNotShowAgain(let id, _):
            return "WhatIsNew/DoNot-Show-Again/\(id)"
            
        case .performSearchFromSearchControlInFormBuilder(let url):
            return url
     
        case .invitePeople(let searchTxt):
            return "Users/GetUsers"
        case .suggestedPeopleList:
            return "Users/GetUsers"
        case .getEventDetails(let id):
            return "Calendar/\(id)"
        case .deleteEvent(let id) :
            return "Calendar/DeleteEvent?id=\(id)"
        case .calendarHomeList:
            return "Calendar/UpComing"
        case .calendarEvents(let fromDate, let toDate):
            return "Calendar?dateFrom=\(fromDate)&dateTo=\(toDate)"
        case .fetchFAQCategories:
            return "Lookups/Categories/FAQ"
        case .fetchKnowledgeBaseCategories:
            return "Lookups/Categories/KnowledgeBase"
        case .fetchRecentlyUsedApps:
            return "Applications/RecentlyUsed"
        case .addAppToHistory(appId: let id):
            return "Applications/AddToHistory/?applicationId=\(id)"
        case .getColorsCustomization:
            //            return "colors.json?key=592ae690"
            return "configuration/api/Themes/GetAppliedTheme"
        case .getFilterCategories(path: let path):
            return "\(path)"
        case .getUsserInfoByBCID:
            return "UserProfile/User/GetUserProfileFromAd"
        case .getOrganizationStruc(let id):
            return "OrganizationStructure?userId=\(id)"
        case .searchList:
            return "Engine/Autocomplete"
        case .myRequestsChart:
            return "Statistics/GetRequestStatistics"
        case .myTasksChart:
            return "Statistics/GetTasksStatistics"
        }
    }
    
    
    var authHeader: [String : String]{
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
    
    var encoding: ParameterEncoding {
        switch method {
        case .post, .put, .delete, .patch :
            return JSONEncoding.default
        default :
            return URLEncoding.default
        }
    }
    
    
    var isMock: Bool{
        switch self {
        case .requestDetails, .taskDetails:
            return false
        default:
            return false
        }
    }
    
    var urlType: cerqel_URLType{
        switch self {
            //        case .getColorsCustomization:
            //            return .mocking
        case .fetchGlobalSearch:
            return .searchEngine
        case .newsList, .addNewsToFavourite, .newsBookmarkList, .pinnedNews, .fetchFAQCategories, .fetchKnowledgeBaseCategories,.getEventDetails,.deleteEvent,.calendarEvents,.getOrganizationStruc:
            return .Content
        case .suggestedPeopleList, .invitePeople:
            return .userManager
        case .fetchRecentlyUsedApps, .addAppToHistory:
            return .Content
        case .internalNewsList, .internalNewsDetails, .addinternalNewsToFavourite, .internalNewsFavList:
            return .Content
        case .myTasksStatistics,.myRequestsStatistics:
            return .selfService
        case .announcementsFavList, .addAnnounceToFavourite:
            return .Content
        case .offersCategoryList, .addOfferToFavourite:
            return .Content
        case  .eventDetails, .calendarHomeList:
            return .Content
            
        case .whatsNew, .doNotShowAgain, .whatsNewSearchPortal:
            return .Content
            
        case .CategoryList, .subCategory, .taskList, .requestList, .requestDetails, .taskDetails, .fetchSubServices:
            return .selfService
            
        case .fetchService, .submitService, .fetchAllService, .getFavoriteServices, .addServiceToFavourite, .fetchSubServicesByParent:
            return .selfService
            
        case .fetchRequestChat, .addChatComment, .executeAction, .reopenRequest, .searchServices, .withdrawRequest, .fetchAwaitingRequests:
            return .selfService
            
        case .getFilterCategories:
            return .Content
            
        case .fetchProfile, .getEmergncyContacts, .getPayrollInfo, .dependents, .getContactAddress, .getWorkExperience, .getEducations:
            return .userManager
            
        case .getCourses, .getEmploymentInfo, .getUserProfileByEmail:
            return .userManager
            
        case .SetNotificationAsOpen, .unOpenedNotificationCount:
            return .Notification
            
        case .uploadFile:
            return .fileManager
            
        case .pushNotification_Register, .pushNotification_UnRegister:
            return .userManager
            
        case .performSearchFromSearchControlInFormBuilder:
            return .none
        case .searchList :
            return .userManager
        case .getUsserInfoByBCID:
            return .userManager
        case .myRequestsChart,.myTasksChart:
            return .selfService
            
        default:
            return .base
        }
    }
    
    var basicAction: cerqel_BasicAction {
        switch self {
        case .requestDetails(_):
            return .requestDetails(id: "")
        case .taskDetails(_):
            return .taskDetails(id: "")
        default: return .none
        }
    }
    
}
