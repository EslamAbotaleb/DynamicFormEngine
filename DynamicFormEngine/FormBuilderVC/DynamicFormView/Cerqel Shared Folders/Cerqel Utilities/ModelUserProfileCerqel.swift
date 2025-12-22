//
//  ModelUserProfile.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/20/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

struct ModelPerviewUserCerqel : Codable {
    var data : UserProfileInfoADCerqel? = nil
    var arrData : [UserProfileInfoADCerqel]? = []
    var totalCount: Int = 0
    
    enum CodingKeys: String, CodingKey {

        case data = "data"
        case totalCount = "totalCount"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        data = try values.decodeIfPresent(ModelNewsDataCerqel.self, forKey: .data)
        
        do {
            data = try values.decodeIfPresent(UserProfileInfoADCerqel.self, forKey: .data)
        } catch DecodingError.typeMismatch(_, let error){
            
            print(error)
            print(error.underlyingError)
            print("☢️ Item typemismatch error ignored")

            // ignore if not found
            // other types : .dataCorrupted, .keyNotFound, .typeMismatch and .valueNotFound.
        } catch let err{
            if let err = err as? DecodingError {
                print("☢️☢️☢️  ITEM Decoding Error : \(err) ☢️☢️☢️")
            }
        }

        
        
        do {
            arrData = try values.decodeIfPresent([UserProfileInfoADCerqel].self, forKey: .data)
            totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        } catch DecodingError.typeMismatch(_, let err){
            // ignore if not found
            print("⛔️ Items typemismatch error ignored \(err)")
        } catch let err{
            print("⛔️⛔️⛔️  ITEMS Decoding Error : \(err) ⛔️⛔️⛔️")
        }

        
        
    }

}

//struct ModelUserProfileDataCerqel : Codable {
//    let id : String?
//    let employeeId : String?
//    let personId : String?
//    let name : String?
//    let givenName : String?
//    let jobTitle : String?
//    let mail : String?
//    let departmentName : String?
//    let phone : String?
//    let photo : String?
//    let isActive : Bool?
//    let permissions : [String]?
//    var userProfileInfoERP : UserProfileInfoERPCerqel?
//    let userProfileInfoAD : UserProfileInfoADCerqel?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case employeeId = "employeeId"
//        case personId = "personId"
//        case name = "name"
//        case givenName = "givenName"
//        case jobTitle = "jobTitle"
//        case mail = "mail"
//        case departmentName = "departmentName"
//        case phone = "phone"
//        case photo = "photo"
//        case isActive = "isActive"
//        case permissions = "permissions"
//        case userProfileInfoERP = "userProfileInfoERP"
//        case userProfileInfoAD = "userProfileInfoAd"
//    }
//}

struct ModelUserProfileDataCerqel: Codable {
//    var basicInfo : profileBasicInfo?
//    var contactInfo : profileContactInfo?
//    var jobDetails : profileJobDetails?
//    var medicalInsuranceInfo: profileInsuranceInfo?
//    var qrCode: String?
//    var profilePicture: String?
//    var canDeletePicture: Bool
    
    
    // new structure
    let id : String?
    let name : String?
    let jobTitle : String?
    let mail : String?
    let departmentName : String?
    let phone : String?
    let photo : String?
    let managerName: String?

    enum CodingKeys: String, CodingKey {
        
//        case basicInfo = "basicInfo"
//        case contactInfo = "contactInfo"
//        case jobDetails = "jobDetails"
//        case qrCode
//        case medicalInsuranceInfo = "medicalInsuranceInfo"
//        case profilePicture = "profilePicture"
//        case canDeletePicture = "canDeletePicture"
        
        
        case id = "id"
        case name = "name"
        case jobTitle = "jobTitle"
        case mail = "email"
        case departmentName = "departmentName"
        case phone = "phone"
        case photo = "photo"
        case managerName
    }
}

struct profileBasicInfo: Codable {
    var dateOfBirth : String?
    var fullName : String?
    var gender : String?
    var nationality: String?
    var photo: String?

    enum CodingKeys: String, CodingKey {
        
        case dateOfBirth = "dateOfBirth"
        case fullName = "fullName"
        case gender = "gender"
        case nationality = "nationality"
        case photo = "photo"
    }
}

struct profileContactInfo: Codable {
    var email : String?
    var ext : String?
    var mobileNumber : String?
    var phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        
        case email = "email"
        case ext = "ext"
        case mobileNumber = "mobileNumber"
        case phoneNumber = "phoneNumber"
    }
}

struct profileJobDetails: Codable {
    var companyName : String?
    var department : String?
    var jobID : String?
    var jobTitle: String?
    var jobType: String?
    var joiningDate: String?
    var reportsTo: String?

    enum CodingKeys: String, CodingKey {
        
        case companyName = "companyName"
        case department = "department"
        case jobID = "jobID"
        case jobTitle = "jobTitle"
        case jobType = "jobType"
        case joiningDate = "joiningDate"
        case reportsTo = "reportsTo"
    }
}

struct profileInsuranceInfo: Codable {
    var hasMedicalInsurance : Bool?
    var insuranceCompanyName : String?
    var insuranceTier : String?

    enum CodingKeys: String, CodingKey {
        
        case hasMedicalInsurance = "hasMedicalInsurance"
        case insuranceCompanyName = "insuranceCompanyName"
        case insuranceTier = "insuranceTier"
    }
}

struct UserProfileInfoERPCerqel : Codable {
    let header : HeaderCerqel?
    let data : ProfileInfoDataCerqel?

    enum CodingKeys: String, CodingKey {

        case header = "header"
        case data = "data"
    }

}

struct PersonalInfoCerqel : Codable {
    let userId : String?
    let name : NameCerqel?
    let nameArabic : NameArabicCerqel?
    let username : String?
    let nationalId : String?
    let salutation : SalutationCerqel?
    let maritalStatus : MaritalStatusCerqel?
    let nationality : NationalityCerqel?
    let gender : String?
    let secondNationality : SecondNationalityCerqel?
    let nativePreferredLang : NativePreferredLangCerqel?
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

struct ContactInfoCerqel : Codable {
    let email : String?
    let mailType : String?
    let mobile : String?

    enum CodingKeys: String, CodingKey {

        case email = "email"
        case mailType = "mailType"
        case mobile = "mobile"
    }
}

struct JobInfoCerqel : Codable {
    let employeeClass : String?
    let contactInfo : ContactInfoCerqel?
    let hireDate : String?
    let locale : String?
    let isFulltimeEmployee : Bool?
    let employeeStatus : EmployeeStatusCerqel?
    let location : LocationCerqel?
    let position : PositionCerqel?
    let payScaleLevel : String?
    let department : DepartmentCerqel?
    let division : DivisionCerqel?
    let businessUnit : BusinessUnitCerqel?
    let section : DepartmentCerqel?

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

struct StatusCerqel : Codable {
    let id : Int?
    let name : String?
    let statusCode : String?
    let statusColor : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case statusCode = "statusCode"
        case statusColor = "statusColor"
    }
}

struct PositionCerqel : Codable {
    let name : String?
    let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}

struct NativePreferredLangCerqel : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct ProfileInfoDataCerqel : Codable {
    let genericProfile : GenericProfileCerqel?
    let personalInfoBriefDetailsDto : String?

    enum CodingKeys: String, CodingKey {

        case genericProfile = "genericProfile"
        case personalInfoBriefDetailsDto = "personalInfoBriefDetailsDto"
    }
}

struct EmployeeStatusCerqel : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct NameArabicCerqel : Codable {
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

struct DivisionCerqel : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct ManagerInfoCerqel : Codable {
    let userId : String?
    let name : String?
    let email : String?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case name = "name"
        case email = "email"
    }
}

struct BusinessUnitCerqel : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct SecondNationalityCerqel : Codable {
    let country : String?
    let code : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case code = "code"
    }
}

struct ManagerCerqel : Codable {
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


struct HeaderCerqel: Codable {
    let requestID : String?
    let status : StatusCerqel?

    enum CodingKeys: String, CodingKey {

        case requestID = "requestID"
        case status = "status"
    }
}

struct LocationCerqel : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct GenericProfileCerqel : Codable {
    let personalInfo : PersonalInfoCerqel?
    let jobInfo : JobInfoCerqel?
    let managerInfo : ManagerInfoCerqel?

    enum CodingKeys: String, CodingKey {

        case personalInfo = "personalInfo"
        case jobInfo = "jobInfo"
        case managerInfo = "managerInfo"
    }
}

struct UserProfileInfoADCerqel : Codable {
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
    let manager : ManagerCerqel?

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


struct MaritalStatusCerqel : Codable {
    let name : String?
    let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}

struct DepartmentCerqel : Codable {
    let code : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case name = "name"
    }
}

struct NameCerqel : Codable {
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

struct NationalityCerqel : Codable {
    let country : String?
    let code : String?

    enum CodingKeys: String, CodingKey {

        case country = "country"
        case code = "code"
    }
}

struct SalutationCerqel : Codable {
    let name : String?
    let nameArabic : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case nameArabic = "nameArabic"
    }
}
