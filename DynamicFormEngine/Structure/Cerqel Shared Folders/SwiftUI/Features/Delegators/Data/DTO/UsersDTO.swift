//
//  UsersDTO.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct UserDTO : Codable {
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
    let nameAr : String?
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
    let manager : String?
    let nationalNumber: String?


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
        case nameAr = "nameAr"
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
        case nationalNumber
    }

}
