//
//  ModelUsersList.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 23/05/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct ModelUsersList : Codable {
    let sharedBCID : String?
    let bcid : String?
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
    let mobile : String?
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
    let employeePF : String?
    let manager : UserProfileInfoAD?
    
    enum CodingKeys: String, CodingKey {
        
        case sharedBCID = "sharedBCID"
        case bcid = "bcid"
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
        case mobile = "mobile"
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
        case employeePF = "employeePF"
        case manager = "manager"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sharedBCID = try values.decodeIfPresent(String.self, forKey: .sharedBCID)
        bcid = try values.decodeIfPresent(String.self, forKey: .bcid)
        cn = try values.decodeIfPresent(String.self, forKey: .cn)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        mail = try values.decodeIfPresent(String.self, forKey: .mail)
        businessPhone = try values.decodeIfPresent(String.self, forKey: .businessPhone)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        departmentAr = try values.decodeIfPresent(String.self, forKey: .departmentAr)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        displayNameAr = try values.decodeIfPresent(String.self, forKey: .displayNameAr)
        employeeId = try values.decodeIfPresent(String.self, forKey: .employeeId)
        userType = try values.decodeIfPresent(String.self, forKey: .userType)
        givenName = try values.decodeIfPresent(String.self, forKey: .givenName)
        lastLogon = try values.decodeIfPresent(String.self, forKey: .lastLogon)
        mailNickname = try values.decodeIfPresent(String.self, forKey: .mailNickname)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        info = try values.decodeIfPresent(String.self, forKey: .info)
        samAccountName = try values.decodeIfPresent(String.self, forKey: .samAccountName)
        sn = try values.decodeIfPresent(String.self, forKey: .sn)
        jobTitle = try values.decodeIfPresent(String.self, forKey: .jobTitle)
        jobTitleAr = try values.decodeIfPresent(String.self, forKey: .jobTitleAr)
        userPrincipalName = try values.decodeIfPresent(String.self, forKey: .userPrincipalName)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        managerPath = try values.decodeIfPresent(String.self, forKey: .managerPath)
        employeePF = try values.decodeIfPresent(String.self, forKey: .employeePF)
        manager = try values.decodeIfPresent(UserProfileInfoAD.self, forKey: .manager)
    }
}

