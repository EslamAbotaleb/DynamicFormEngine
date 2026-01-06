//
//  UsersDTO.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

struct UserDTO : Codable {
    public let sharedBCID : String?
    public let bcid : String?
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
    public let mobile : String?
    public let name : String?
    public let nameAr : String?
    public let info : String?
    public let samAccountName : String?
    public let sn : String?
    public let jobTitle : String?
    public let jobTitleAr : String?
    public let userPrincipalName : String?
    public let id : String?
    public let photo : String?
    public let managerPath : String?
    public let employeePF : String?
    public let manager : String?
    public let nationalNumber: String?


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
