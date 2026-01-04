//
//  ModelUserProfile.swift
// 
//
//  Created by iSlam AbdelAziz on 12/20/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
internal import ObjectMapper

public struct ModelPerviewUser : Codable {
    public var data : UserProfileInfoAD? = nil
    public var arrData : [UserProfileInfoAD]? = []
    public var totalCount: Int = 0
    
    enum CodingKeys: String, CodingKey {

        case data = "data"
        case totalCount = "totalCount"
    }

    
    public  init(from decoder: Decoder) throws {
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
    public let id : String?
    public let employeeId : String?
    public let personId : String?
    public let name : String?
    public let givenName : String?
    public let jobTitle : String?
    public let mail : String?
    public let departmentName : String?
    public let phone : String?
    public let photo : String?
    public let imageURL : String?
    public let isActive : Bool?
    public let permissions : [String]?
    public var userProfileInfoERP : UserProfileInfoERP?
    public let userProfileInfoAD : UserProfileInfoAD?
    public let tiktokUser: String?
    public let instagramUser: String?
    public let linkedInUser: String?
    public let facebookUser: String?
    public let twitterUser: String?
    public let bcid: String?
    public let nameEn: String?
    public let hasAttendanceAccess: Bool?
    public let displayNameERP: String?
    public let mailNickname: String?
    public let checkUserDetails: CheckUserDetail?
    public let trimvoUserDetails: TrimvoUserDetails?
    
    
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
public struct CheckUserDetail: Codable {
    public let roleID: Int?
    public let roleNameAr, roleNameEn: String?
    public let isEndUser, isUnitMember, enableLiveInspection: Bool?
    public let permissions: [CheckPermission]?

    enum CodingKeys: String, CodingKey {
        case roleID = "roleId"
        case roleNameAr, roleNameEn, isEndUser, isUnitMember, enableLiveInspection, permissions
    }
}

// MARK: - Permission
public struct CheckPermission: Codable {
    public let moduleID: Int?
    public let accessType: String?
    public let viewPermission, createPermission, updatePermission: Bool?
    public let viewPriority: String?

    enum CodingKeys: String, CodingKey {
        case moduleID = "moduleId"
        case accessType, viewPermission, createPermission, updatePermission, viewPriority
    }
}

// MARK: - TrimvoUserDetails
public struct TrimvoUserDetails: Codable {
    public let email, userID, userName, fullName: String?
    public let userSource, departmentID: Int?
    public let departmentName, departmentNameAr: String?
    public let positionID: Int?
    public let positionName, positionNameAr: String?
    public let status, userRole, recievedPoints, givenPoints: Int?
    public let profilePicture: String?
    public let facebook, mobileNumber, phoneNumber, twitter: String?
    public let topTags: [TopTag]?
    public let receivingState, sendingState: Int?

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
public struct TopTag: Codable {
    public let tagID: Int?
    public let name, nameAr, color: String?
    public let count: Int?
    public let imageName: String?
    enum CodingKeys: String, CodingKey {
        case tagID = "tagId"
        case imageName = "image"
        case name, nameAr, color, count
    }
}

struct UserProfileInfoERP : Codable {
    public let header : Header?
    public let data : ProfileInfoData?

    enum CodingKeys: String, CodingKey {

        case header = "header"
        case data = "data"
    }

}

public struct PersonalInfo : Codable {
    public let userId : String?
    public let name : Name?
    public let nameArabic : NameArabic?
    public let username : String?
    public let nationalId : String?
    public let salutation : Salutation?
    public let maritalStatus : MaritalStatus?
    public let nationality : Nationality?
    public let gender : String?
    public let secondNationality : SecondNationality?
    public let nativePreferredLang : NativePreferredLang?
    public let effectiveDate: String?

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

public struct ContactInfo : Codable {
    public let email : String?
    public let mailType : String?
    public let mobile : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case mailType = "mailType"
        case mobile = "mobile"
    }
}

public struct JobInfo : Codable {
    public let employeeClass : String?
    public let contactInfo : ContactInfo?
    public let hireDate : String?
    public let locale : String?
    public let isFulltimeEmployee : Bool?
    public let employeeStatus : EmployeeStatus?
    public let location : Location?
    public let position : Position?
    public let payScaleLevel : String?
    public let department : Department?
    public let division : Division?
    public let businessUnit : BusinessUnit?
    public let section : Department?

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

internal struct Status: Codable, Mappable {
    public var id: Int?
    public var name: String?
    public var statusCode: String?
    public var statusColor: String?
    
    // ObjectMapper's Mappable init
    public init?(map: Map) {}
    
    // Mapping for ObjectMapper
    mutating public func mapping(map: Map) {
        id           <- map["id"]
        name         <- map["name"]
        statusCode   <- map["statusCode"]
        statusColor  <- map["statusColor"]
    }
    
    // Codable initializer for decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        statusCode = try container.decodeIfPresent(String.self, forKey: .statusCode)
        statusColor = try container.decodeIfPresent(String.self, forKey: .statusColor)
    }
    
    // Codable method for encoding
    public func encode(to encoder: Encoder) throws {
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

public struct Position : Codable {
    public let name : String?
    public let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}

public struct NativePreferredLang : Codable {
    public let code : String?
    public let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

public struct ProfileInfoData : Codable {
    public let genericProfile : GenericProfile?
    public let personalInfoBriefDetailsDto : String?

    enum CodingKeys: String, CodingKey {

        case genericProfile = "genericProfile"
        case personalInfoBriefDetailsDto = "personalInfoBriefDetailsDto"
    }
}

public struct EmployeeStatus : Codable {
    public let code : String?
    public let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

public struct NameArabic : Codable {
    public let middle : String?
    public let last : String?
    public let fullName : String?
    public let third : String?
    public let first : String?

    enum CodingKeys: String, CodingKey {

        case middle = "middle"
        case last = "last"
        case fullName = "fullName"
        case third = "third"
        case first = "first"
    }
}

public struct Division : Codable {
    public let code : String?
    public let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

public struct ManagerInfo : Codable {
    public let userId : String?
    public let name : String?
    public let email : String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case name = "name"
        case email = "email"
    }
}

public struct BusinessUnit : Codable {
    public let code : String?
    public let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

public struct SecondNationality : Codable {
    public let country : String?
    public let code : String?

    enum CodingKeys: String, CodingKey {
        case country = "country"
        case code = "code"
    }
}

public struct Manager : Codable {
    public let cn : String?
    public let company : String?
    public let mail : String?
    public let businessPhone : String?
    public let department : String?
    public let departmentAr : String?
    public let description : String?
    public let displayName : String?
    public let displayNameAr : String?
    public let employeeId : String?
    public let userType : String?
    public let givenName : String?
    public let lastLogon : String?
    public let mailNickname : String?
    public let phone : String?
    public let name : String?
    public let info : String?
    public let samAccountName : String?
    public let sn : String?
    public let jobTitle : String?
    public let jobTitleAr : String?
    public let userPrincipalName : String?
    public let id : String?
    public let photo : String?
    public let managerPath : String?
    public let manager : String?

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

internal struct Header : Codable {
    public let requestID : String?
    public let status : Status?

    enum CodingKeys: String, CodingKey {

        case requestID = "requestID"
        case status = "status"
    }
}

public struct Location : Codable {
    public let code : String?
    public let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

public struct GenericProfile : Codable {
    public let personalInfo : PersonalInfo?
    public let jobInfo : JobInfo?
    public let managerInfo : ManagerInfo?

    enum CodingKeys: String, CodingKey {

        case personalInfo = "personalInfo"
        case jobInfo = "jobInfo"
        case managerInfo = "managerInfo"
    }
}

public struct UserProfileInfoAD : Codable {
    public let cn : String?
    public let company : String?
    public let mail : String?
    public let businessPhone : String?
    public let department : String?
    public let departmentAr : String?
    public let description : String?
    public let displayName : String?
    public let displayNameAr : String?
    public let employeeId : String?
    public let userType : String?
    public let givenName : String?
    public let lastLogon : String?
    public let mailNickname : String?
    public let phone : String?
    public let name : String?
    public let info : String?
    public let samAccountName : String?
    public let sn : String?
    public let jobTitle : String?
    public let jobTitleAr : String?
    public let userPrincipalName : String?
    public let id : String?
    public let photo : String?
    public let managerPath : String?
    public let manager : Manager?

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


public struct MaritalStatus : Codable {
    public let name : String?
    public let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}

public struct Department : Codable {
    public let code : String?
    public let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

public struct Name : Codable {
    public let first : String?
    public let middle : String?
    public let last : String?
    public let third : String?
    public let fullName : String?

    enum CodingKeys: String, CodingKey {

        case first = "first"
        case middle = "middle"
        case last = "last"
        case third = "third"
        case fullName = "fullName"
    }
}

public struct Nationality : Codable {
    public let country : String?
    public let code : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case code = "code"
    }
}

public struct Salutation : Codable {
    public  let name : String?
    public  let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}
