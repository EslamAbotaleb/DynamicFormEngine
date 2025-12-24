//
//  Endpoint.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

public protocol Endpoint {
    var service: EndpointService {get set}
    var urlPrefix: String {get set}
    // var endpointVersion: Versions {get set}
    var method: EndpointMethod {get set}
    var auth: AuthorizationHandler {get set}
    var parameters: [String: Any] {get set}
    var encoding: EndpointEncoding {get set}
    var headers: [String: String] {get set}
    var multipart: [MultiPartModel] {get }
}

public enum EndpointEncoding {
    case json
    case query
}



public enum EndpointMethod: String {
    case get
    case post
    case put
    case delete
    case patch
}

public enum EndpointService {

    // document library
    case categories
    case categoriesWithChildrens
    case subCategories (categoryId: String)
    case allFiles
    case recentFiles
    case fileTypes
    case upload
    case uploadUserProfile
    case generalUploadFile
    case addProfileEducation
    case addProfileEmergency
    case addProfileDependant
    case addProfileCertificateAndCourse
    case addProfileSocialMedia
    case addWorkExperienceMedia
    case editProfileEmergency(id: String)
    case editProfileSocialMedia(id: String)
    case editProfileDependant(id: String)
    case editProfileEducation(id: String)
    case editWorkExperienceMedia(id: String)
    case editProfileCertificateAndCourse(id: String)
    case saveProfile
    case fetchDegreeLvlList
    case fetchRelationList
    case fetchLinksList
    case uploadWorkExperienceCV
    case deleteWorkExperienceCV
    case fetchWorkExperienceCV
    case reportList
    case sendReport
    case acknowledge
    case pin
    case view
    case deleteProfilePhoto

    // FAQ
    case faqs
    case faqsCategories

    case filterStatus
    
    // Events
    case eventsList
    case addEventToCalendar

    //My Apps
    case myApps
    case addAppToHistory

    // announcements
    case announcements
    case AddAnnouncementToFavorite

    //
    case offers
    case mediaLibrary
    case knowledgeBase
    case knowledgeBaseCategories
    case addOfferToFavourite
    case newsList
    case addNewsToFavourite
    
    case requests
    case services
    case tasks

    //Employee
    case employeeList
    
    //Weather
    case hourlyForecast
    case DailyForecast
    case WeatherDetails
    case Prayer
    case LocationList
    

    case addSugesstion

    //Media library details
    case mediaDetails

    // sevices
    case getAllServicesCategories
    case allServices
    case addServiceToFavourite
    case serviceCategories
    case serviceSubCategories

    // Home
    case vipHomeMainWidgets
    //Profile
    case myProfile
    case profileList
    case profileSocialMedia
    case lookUps
    case citiesByCountry
    case workExperience
    case CertificateList
    //global search
    case globalSearchDetails
    case globalSearchAllResults
    case globalSearchSummary
    case suggetionSearch
    
    case educationList
    case dependentsList
    case privateWorkList
    case relativesList
    case emergencyContactsList
    case personalInfo

    //My Apps
    case appsList
    case recentApp
    case addToRecent
    case getUsers
    case survey
    case orgStructure

    case aboutUs
    case orgStructureForUser
    case socialMediaList

    case jobDetailsLookups
    case medicalInsurance
    case unOpenedNotificationCount
    
    case excuteAction
    case SendBackRecipients

    // Access Management
      case ThemeWithConfigurationEndPoint
      case TenantListEndPoint

    var url: String {
        switch self {
        case .categories :
            return "\(baseUrl)DocumentLibrary/api/Lookups/Categories"
        case .categoriesWithChildrens :
            return "\(baseUrl)DocumentLibrary/api/Lookups/CategoriesWithSubcategories"
        case .subCategories (let categoryId):
            return "\(baseUrl)DocumentLibrary/api/Lookups/Subcategories/\(categoryId)"
        case .allFiles :
            return "\(baseUrl)DocumentLibrary/api/Files/v2/GetFilesList"
        case .recentFiles :
            return "\(baseUrl)DocumentLibrary/api/Files/v2/getRecentFiles"
        case .fileTypes :
            return "\(baseUrl)DocumentLibrary/api/Lookups/FilesTypes"
        case .upload :
            return "\(baseUrl)DocumentLibrary/api/Requests/UploadRequest"
        case .uploadUserProfile :
            return "\(baseUrl)usermanager/api/UserProfile/User/uploadPicture"
        case .generalUploadFile:
            return "\(baseUrl)storage/api/FileManager/UploadFiles/"
        case .addProfileEducation:
            return "\(baseUrl)usermanager/api/Education/AddEducation"
        case .addProfileEmergency:
            return "\(baseUrl)usermanager/api/EmergencyContacts/AddEmergencyContact"
        case .fetchDegreeLvlList:
            return "\(baseUrl)usermanager/api/Lookups/DegreeLevels"
        case .fetchRelationList:
            return "\(baseUrl)usermanager/api/Lookups/Relations"
        case .fetchLinksList:
            return "\(baseUrl)usermanager/api/Lookups/SocialMediaApps"
        case .addProfileDependant:
            return "\(baseUrl)usermanager/api/Dependents/AddDependent"
        case .addProfileCertificateAndCourse:
            return "\(baseUrl)usermanager/api/CertificateAndCourse/AddCertificateOrCourse"
        case .addProfileSocialMedia:
            return "\(baseUrl)usermanager/api/SocialMedia/AddSocialMedia"
        case .addWorkExperienceMedia:
            return "\(baseUrl)usermanager/api/WorkExperiences/AddWorkExperience"
        case .reportList :
            return "\(baseUrl)DocumentLibrary/api/Lookups/ReportReasons"
        case .sendReport :
            return "\(baseUrl)DocumentLibrary/api/Requests/ReportRequest"
        case .acknowledge  :
            return "\(baseUrl)DocumentLibrary/api/Files/acknowledge/"
        case .pin  :
            return "\(baseUrl)DocumentLibrary/api/Files/pin/"
        case .view  :
            return "\(baseUrl)DocumentLibrary/api/Files/"
        case .saveProfile  :
            return "\(baseUrl)usermanager/api/UserProfile/user/requestupdate"
        case .deleteProfilePhoto  :
            return "\(baseUrl)usermanager/api/UserProfile/User/DeletePicture"

        case .editProfileEducation(let id):
            return "\(baseUrl)usermanager/api/Education/\(id)"
        case .editProfileEmergency(let id):
            return "\(baseUrl)usermanager/api/EmergencyContacts/\(id)"
        case .editProfileDependant(let id):
            return "\(baseUrl)usermanager/api/Dependents/\(id)"
        case .editProfileCertificateAndCourse(let id):
            return "\(baseUrl)usermanager/api/CertificateAndCourse/\(id)"
        case .editProfileSocialMedia(let id):
            return "\(baseUrl)usermanager/api/SocialMedia/EditSocialMedia/\(id)"
        case .editWorkExperienceMedia(let id):
            return "\(baseUrl)usermanager/api/WorkExperiences/\(id)"
        case .uploadWorkExperienceCV:
            return "\(baseUrl)usermanager/api/UserCV/UploadCV"
        case .fetchWorkExperienceCV:
            return "\(baseUrl)usermanager/api/UserCV/GetCV"
        case .deleteWorkExperienceCV:
            return "\(baseUrl)usermanager/api/UserCV/DeleteCV"
        case .faqs:
            return "\(baseUrl)content/api/FAQ/Portal/GetAll"
        case .faqsCategories:
            return "\(baseUrl)content/api/Lookups/Categories/FAQ"
        case .offers:
            return "\(baseUrl)content/api/Offers/HomeOffersList"
        case .mediaLibrary:
            return "\(baseUrl)content/api/Studio/Portal"
        case .knowledgeBase:
            return "\(baseUrl)content/api/KnowledgeBase/Portal/GetAll"
        case .addOfferToFavourite:
            return "\(baseUrl)content/api/Offers/BookmarkOffer/"
            
            // Events
        case .eventsList:
            return "\(baseUrl)content/api/Event/Search"
        case .addEventToCalendar:
            return "\(baseUrl)content/api/Event/addtocalendar"

            // my apps
        case .myApps:
            return "\(baseUrl)content/api/Applications/Portal"
        case .addAppToHistory:
            return "\(baseUrl)content/api/Applications/AddToHistory"
            
        case .announcements:
            return "\(baseUrl)content/api/Announcement/Filter"
        case .AddAnnouncementToFavorite:
            return "\(baseUrl)content/api/Announcement/BookmarkAnnouncement/"
        case .newsList:
            return "\(baseUrl)content/api/News/Portal/Filter"
        case .addNewsToFavourite:
            return "\(baseUrl)content/api/News/BookmarkNews/"
            // Employee

        case .employeeList:
            return "\(baseUrl)"
        case .addSugesstion:
            return "\(baseUrl)content/api/Inquiry/SendInquiry"
        case .mediaDetails:
            return "\(baseUrl)content/api/Studio/"

            // sevices
        case .getAllServicesCategories :
            return "\(baseUrl)selfservices/api/Categories/GetAll"
        case .allServices:
            return "\(baseUrl)selfservices/api/selfservices/getserviceslist"
        case .addServiceToFavourite :
            return "\(baseUrl)selfservices/Api/UserServices/Add"
        case .serviceCategories:
            return "\(baseUrl)selfservices/api/Categories/GetAllParentCategories"
        case .serviceSubCategories:
            return "\(baseUrl)selfservices/api/Categories/GetSubCategoryByParentId"
            // Home
        case .vipHomeMainWidgets:
            return "\(baseUrl)content/api/CustomizeWidgets/widgets"
        case .hourlyForecast:
            return "\(baseUrl)weatherprayer/api/Weather/hourly"
        case .DailyForecast:
            return "\(baseUrl)weatherprayer/api/Weather/daily"
        case .WeatherDetails:
            return "\(baseUrl)weatherprayer/api/Weather/current"
        case .Prayer:
            return "\(baseUrl)weatherprayer/api/Prayer"
        case .LocationList:
            return "\(baseUrl)weatherprayer/api/Location/search"
            
        case .myProfile:
            return "\(baseUrl)usermanager/api/UserProfile/User/me"
        case .profileList:
            return "\(baseUrl)usermanager/api/"
        case .profileSocialMedia:
            return "\(baseUrl)SocialMedia"
        case .educationList:
            return "\(baseUrl)usermanager/api/education"
        case .workExperience:
            return "\(baseUrl)usermanager/api/WorkExperiences/WorkExperiencesList"
        case .CertificateList:
            return "\(baseUrl)usermanager/api/CertificateAndCourse/GetCertificatesAndCoursesList"
        case .socialMediaList:
            return "\(baseUrl)usermanager/api/SocialMedia"
        case .medicalInsurance:
            return "\(baseUrl)usermanager/api/MedicalInsurance/GetMedicalInsurancesList"

        case .dependentsList:
            return "\(baseUrl)usermanager/api/dependents"

        case .privateWorkList:
            return "\(baseUrl)usermanager/api/privatework"


        case .relativesList:
            return "\(baseUrl)usermanager/api/relatives"

        case .requests:
            return "\(baseUrl)selfservices/api/Request/GetAllPaged"
        case .tasks:
            return "\(baseUrl)selfservices/api/Tasks/GetAllPaged"
        case .services:
            return "\(baseUrl)selfservices/api/SelfServices/GetAllByCategoryId/"
        case .globalSearchDetails:
            return "\(baseUrl)searchengine/api/GlobalSearch/search/details/"
        case .globalSearchAllResults:
            return "\(baseUrl)searchengine/api/GlobalSearch/search"
        case .globalSearchSummary:
            return "\(baseUrl)searchengine/api/GlobalSearch/search/summary"
        case .suggetionSearch:
            return "\(baseUrl)searchengine/api/GlobalSearch/search/suggestions"
        case .appsList:
            return "\(baseUrl)content/api/Applications/Portal"
        case .recentApp:
            return "\(baseUrl)content/api/Applications/RecentlyUsed"
        case .addToRecent:
            return "\(baseUrl)content/api/Applications/AddToHistory/"

        case .emergencyContactsList:
            return "\(baseUrl)usermanager/api/EmergencyContacts"
        case .personalInfo:
            return "\(baseUrl)usermanager/api/PersonalInformation"
        case .lookUps:
            return "\(baseUrl)usermanager/api/Lookups/"
        case .citiesByCountry:
            return "\(baseUrl)usermanager/api/Lookups/CitiesByCountry/"
        case .getUsers:
            return "\(baseUrl)api/Users/GetAll"
        case .survey:
            return "\(baseUrl)selfservices/Api/BasicSurveys/submit"
        case .orgStructure:
           return "\(baseUrl)usermanager/api/Organization"
        case .orgStructureForUser:
           return "\(baseUrl)usermanager/api/Organization/User"

        case .aboutUs:
            return "\(baseUrl)content/api/AboutUs/GetAboutPortal"
        case .jobDetailsLookups:
            return "\(baseUrl)usermanager/api/Lookups/"
            
        case .unOpenedNotificationCount:
            return "\(baseUrl)notifications/api/InAppNotification/UnOpendNotificationCount"
        case .excuteAction:
            return "\(baseUrl)selfservices/Api/Tasks/ExecuteAction"
        case .SendBackRecipients:
            return "\(baseUrl)selfservices/Api/Request/RetrieveSendbackRecipients"
        case .knowledgeBaseCategories:
            return "\(baseUrl)content/api/Lookups/Categories/KnowledgeBase"
            // Access Management
        case .ThemeWithConfigurationEndPoint :
            return "\(baseUrl)configuration/api/Themes/GetAppliedTheme"
        case .TenantListEndPoint :
            return "\(baseUrl)api/Tenant"
        case .filterStatus:
            return "\(baseUrl)selfservices/Api/Lookups/GetAllStatuses"

        }
    }
}

extension Endpoint {
    public var multipart: [MultiPartModel] {
        return []
    }

}

extension EndpointService {

    public var baseUrl: String{
        return cerqel_Environment.Api_Base_URL + "gw/"
    }
}

public func generateURLWithParams(params: [String: Any]?) -> String {
    if (params != nil && !(params!.isEmpty)) {
        var api = "?"

        params?.forEach { key, value in
            if let val = value as? CustomStringConvertible {
                api += "\(key)=\(val)&"
            }
        }

        if api.contains("&") {
            api = String(api.dropLast())
        }

        return api
    }
    else {
        return ""
    }
}
public func convertModelToDictionary<T>(model: T) -> [String: Any] {
    let mirror = Mirror(reflecting: model)
    var dictionary = [String: Any]()
    
    for case let (label?, value) in mirror.children {
        dictionary[label] = value
    }

    return dictionary
}

