//
//  ModelUserProfile.swift
// 
//
//  Created by iSlam AbdelAziz on 12/20/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
public import ObjectMapper

struct ModelPerviewUser : Codable {
    var data : UserProfileInfoAD? = nil
    var arrData : [UserProfileInfoAD]? = []
    var totalCount: Int = 0
    
    enum CodingKeys: String, CodingKey {

        case data = "data"
        case totalCount = "totalCount"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            data = try values.decodeIfPresent(UserProfileInfoAD.self, forKey: .data)
        } catch {}

        
        
        do {
            arrData = try values.decodeIfPresent([UserProfileInfoAD].self, forKey: .data)
            totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        }catch {}

        
        
    }

}

struct ModelUserProfileData : Codable {
    let id : String?
    let employeeId : String?
    let personId : String?
    let name : String?
    let givenName : String?
    let jobTitle : String?
    let mail : String?
    let departmentName : String?
    let phone : String?
    let photo : String?
    let imageURL : String?
    let isActive : Bool?
    let permissions : [String]?
    var userProfileInfoERP : UserProfileInfoERP?
    let userProfileInfoAD : UserProfileInfoAD?
    let tiktokUser: String?
    let instagramUser: String?
    let linkedInUser: String?
    let facebookUser: String?
    let twitterUser: String?
    let bcid: String?
    let nameEn: String?
    let hasAttendanceAccess: Bool?
    let displayNameERP: String?
    let mailNickname: String?
    let checkUserDetails: CheckUserDetail?
    let trimvoUserDetails: TrimvoUserDetails?
    
    
    enum CodingKeys: String, CodingKey {
        case imageURL
        case id = "id"
        case employeeId = "employeeId"
        case personId = "personId"
        case name = "name"
        case givenName = "givenName"
        case jobTitle = "jobTitle"
        case mail = "mail"
        case departmentName = "departmentName"
        case phone = "phone"
        case photo = "photo"
        case isActive = "isActive"
        case permissions = "permissions"
        case userProfileInfoERP = "userProfileInfoERP"
        case userProfileInfoAD = "userProfileInfoAd"
        case tiktokUser,instagramUser,linkedInUser,facebookUser,twitterUser
        case bcid , nameEn, hasAttendanceAccess, displayNameERP, mailNickname, checkUserDetails, trimvoUserDetails
    }


}

// MARK: - CheckUserDetail
struct CheckUserDetail: Codable {
    let roleID: Int?
    let roleNameAr, roleNameEn: String?
    let isEndUser, isUnitMember, enableLiveInspection: Bool?
    let permissions: [CheckPermission]?

    enum CodingKeys: String, CodingKey {
        case roleID = "roleId"
        case roleNameAr, roleNameEn, isEndUser, isUnitMember, enableLiveInspection, permissions
    }
}

// MARK: - Permission
struct CheckPermission: Codable {
    let moduleID: Int?
    let accessType: String?
    let viewPermission, createPermission, updatePermission: Bool?
    let viewPriority: String?

    enum CodingKeys: String, CodingKey {
        case moduleID = "moduleId"
        case accessType, viewPermission, createPermission, updatePermission, viewPriority
    }
}

// MARK: - TrimvoUserDetails
struct TrimvoUserDetails: Codable {
    let email, userID, userName, fullName: String?
    let userSource, departmentID: Int?
    let departmentName, departmentNameAr: String?
    let positionID: Int?
    let positionName, positionNameAr: String?
    let status, userRole, recievedPoints, givenPoints: Int?
    let profilePicture: String?
    let facebook, mobileNumber, phoneNumber, twitter: String?
    let topTags: [TopTag]?
    let receivingState, sendingState: Int?

    enum CodingKeys: String, CodingKey {
        case email
        case userID = "userId"
        case userName, fullName, userSource
        case departmentID = "departmentId"
        case departmentName
        case departmentNameAr = "departmentName_Ar"
        case positionID = "positionId"
        case positionName
        case positionNameAr = "positionName_Ar"
        case status, userRole, recievedPoints, givenPoints, profilePicture, facebook, mobileNumber, phoneNumber, twitter, topTags, receivingState, sendingState
    }
}

// MARK: - TopTag
struct TopTag: Codable {
    let tagID: Int?
    let name, nameAr, color: String?
    let count: Int?
    let imageName: String?
    enum CodingKeys: String, CodingKey {
        case tagID = "tagId"
        case imageName = "image"
        case name, nameAr, color, count
    }
}

struct UserProfileInfoERP : Codable {
    let header : Header?
    let data : ProfileInfoData?

    enum CodingKeys: String, CodingKey {

        case header = "header"
        case data = "data"
    }

}

struct PersonalInfo : Codable {
    let userId : String?
    let name : Name?
    let nameArabic : NameArabic?
    let username : String?
    let nationalId : String?
    let salutation : Salutation?
    let maritalStatus : MaritalStatus?
    let nationality : Nationality?
    let gender : String?
    let secondNationality : SecondNationality?
    let nativePreferredLang : NativePreferredLang?
    let effectiveDate: String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case name = "name"
        case nameArabic = "nameArabic"
        case username = "username"
        case nationalId = "nationalId"
        case salutation = "salutation"
        case maritalStatus = "maritalStatus"
        case nationality = "nationality"
        case gender = "gender"
        case secondNationality = "secondNationality"
        case nativePreferredLang = "nativePreferredLang"
        case effectiveDate
    }

}

struct ContactInfo : Codable {
    let email : String?
    let mailType : String?
    let mobile : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case mailType = "mailType"
        case mobile = "mobile"
    }
}

struct JobInfo : Codable {
    let employeeClass : String?
    let contactInfo : ContactInfo?
    let hireDate : String?
    let locale : String?
    let isFulltimeEmployee : Bool?
    let employeeStatus : EmployeeStatus?
    let location : Location?
    let position : Position?
    let payScaleLevel : String?
    let department : Department?
    let division : Division?
    let businessUnit : BusinessUnit?
    let section : Department?

    enum CodingKeys: String, CodingKey {

        case employeeClass = "employeeClass"
        case contactInfo = "contactInfo"
        case hireDate = "hireDate"
        case locale = "locale"
        case isFulltimeEmployee = "isFulltimeEmployee"
        case employeeStatus = "employeeStatus"
        case location = "location"
        case position = "position"
        case payScaleLevel = "payScaleLevel"
        case department = "department"
        case division = "division"
        case businessUnit = "businessUnit"
        case section
    }
}

struct Status: Codable, Mappable {
    var id: Int?
    var name: String?
    var statusCode: String?
    var statusColor: String?
    
    // ObjectMapper's Mappable init
    init?(map: Map) {}
    
    // Mapping for ObjectMapper
    mutating func mapping(map: Map) {
        id           <- map["id"]
        name         <- map["name"]
        statusCode   <- map["statusCode"]
        statusColor  <- map["statusColor"]
    }
    
    // Codable initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        statusCode = try container.decodeIfPresent(String.self, forKey: .statusCode)
        statusColor = try container.decodeIfPresent(String.self, forKey: .statusColor)
    }
    
    // Codable method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(statusCode, forKey: .statusCode)
        try container.encodeIfPresent(statusColor, forKey: .statusColor)
    }
    
    // ObjectMapper's keys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case statusCode = "statusCode"
        case statusColor = "statusColor"
    }
}

struct Position : Codable {
    let name : String?
    let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}

struct NativePreferredLang : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct ProfileInfoData : Codable {
    let genericProfile : GenericProfile?
    let personalInfoBriefDetailsDto : String?

    enum CodingKeys: String, CodingKey {

        case genericProfile = "genericProfile"
        case personalInfoBriefDetailsDto = "personalInfoBriefDetailsDto"
    }
}

struct EmployeeStatus : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct NameArabic : Codable {
    let middle : String?
    let last : String?
    let fullName : String?
    let third : String?
    let first : String?

    enum CodingKeys: String, CodingKey {

        case middle = "middle"
        case last = "last"
        case fullName = "fullName"
        case third = "third"
        case first = "first"
    }
}

struct Division : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct ManagerInfo : Codable {
    let userId : String?
    let name : String?
    let email : String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case name = "name"
        case email = "email"
    }
}

struct BusinessUnit : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct SecondNationality : Codable {
    let country : String?
    let code : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case code = "code"
    }
}

struct Manager : Codable {
    let cn : String?
    let company : String?
    let mail : String?
    let businessPhone : String?
    let department : String?
    let departmentAr : String?
    let description : String?
    let displayName : String?
    let displayNameAr : String?
    let employeeId : String?
    let userType : String?
    let givenName : String?
    let lastLogon : String?
    let mailNickname : String?
    let phone : String?
    let name : String?
    let info : String?
    let samAccountName : String?
    let sn : String?
    let jobTitle : String?
    let jobTitleAr : String?
    let userPrincipalName : String?
    let id : String?
    let photo : String?
    let managerPath : String?
    let manager : String?

    enum CodingKeys: String, CodingKey {

        case cn = "cn"
        case company = "company"
        case mail = "mail"
        case businessPhone = "businessPhone"
        case department = "department"
        case departmentAr = "departmentAr"
        case description = "description"
        case displayName = "displayName"
        case displayNameAr = "displayNameAr"
        case employeeId = "employeeId"
        case userType = "userType"
        case givenName = "givenName"
        case lastLogon = "lastLogon"
        case mailNickname = "mailNickname"
        case phone = "phone"
        case name = "name"
        case info = "info"
        case samAccountName = "samAccountName"
        case sn = "sn"
        case jobTitle = "jobTitle"
        case jobTitleAr = "jobTitleAr"
        case userPrincipalName = "userPrincipalName"
        case id = "id"
        case photo = "photo"
        case managerPath = "managerPath"
        case manager = "manager"
    }


}


struct Header : Codable {
    let requestID : String?
    let status : Status?

    enum CodingKeys: String, CodingKey {

        case requestID = "requestID"
        case status = "status"
    }
}

struct Location : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct GenericProfile : Codable {
    let personalInfo : PersonalInfo?
    let jobInfo : JobInfo?
    let managerInfo : ManagerInfo?

    enum CodingKeys: String, CodingKey {

        case personalInfo = "personalInfo"
        case jobInfo = "jobInfo"
        case managerInfo = "managerInfo"
    }
}

struct UserProfileInfoAD : Codable {
    let cn : String?
    let company : String?
    let mail : String?
    let businessPhone : String?
    let department : String?
    let departmentAr : String?
    let description : String?
    let displayName : String?
    let displayNameAr : String?
    let employeeId : String?
    let userType : String?
    let givenName : String?
    let lastLogon : String?
    let mailNickname : String?
    let phone : String?
    let name : String?
    let info : String?
    let samAccountName : String?
    let sn : String?
    let jobTitle : String?
    let jobTitleAr : String?
    let userPrincipalName : String?
    let id : String?
    let photo : String?
    let managerPath : String?
    let manager : Manager?

    enum CodingKeys: String, CodingKey {

        case cn = "cn"
        case company = "company"
        case mail = "mail"
        case businessPhone = "businessPhone"
        case department = "department"
        case departmentAr = "departmentAr"
        case description = "description"
        case displayName = "displayName"
        case displayNameAr = "displayNameAr"
        case employeeId = "employeeId"
        case userType = "userType"
        case givenName = "givenName"
        case lastLogon = "lastLogon"
        case mailNickname = "mailNickname"
        case phone = "phone"
        case name = "name"
        case info = "info"
        case samAccountName = "samAccountName"
        case sn = "sn"
        case jobTitle = "jobTitle"
        case jobTitleAr = "jobTitleAr"
        case userPrincipalName = "userPrincipalName"
        case id = "id"
        case photo = "photo"
        case managerPath = "managerPath"
        case manager = "manager"
    }

}


struct MaritalStatus : Codable {
    let name : String?
    let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}

struct Department : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct Name : Codable {
    let first : String?
    let middle : String?
    let last : String?
    let third : String?
    let fullName : String?

    enum CodingKeys: String, CodingKey {

        case first = "first"
        case middle = "middle"
        case last = "last"
        case third = "third"
        case fullName = "fullName"
    }
}

struct Nationality : Codable {
    let country : String?
    let code : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case code = "code"
    }
}

struct Salutation : Codable {
    let name : String?
    let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}
