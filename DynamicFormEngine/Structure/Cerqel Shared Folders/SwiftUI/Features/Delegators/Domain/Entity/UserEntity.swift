//
//  UserEntity.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct UserEntity : Codable,Identifiable {
    var sharedBCID : String? = ""
    var bcid : String? = ""
    var cn : String? = ""
    var company : String? = ""
    var mail : String? = ""
    var businessPhone : String? = ""
    var department : String? = ""
    var departmentAr : String? = ""
    var description : String? = ""
    var displayName : String? = ""
    var displayNameAr : String? = ""
    var employeeId : String? = ""
    var userType : String? = ""
    var givenName : String? = ""
    var lastLogon : String? = ""
    var mailNickname : String? = ""
    var phone : String? = ""
    var mobile : String? = ""
    var name : String? = ""
    var nameAr : String? = ""
    var info : String? = ""
    var samAccountName : String? = ""
    var sn : String? = ""
    var jobTitle : String? = ""
    var jobTitleAr : String? = ""
    var userPrincipalName : String? = ""
    var id : String? = ""
    var photo : String? = ""
    var managerPath : String? = ""
    var employeePF : String? = ""
    var manager : String? = ""
    var isSelected: Bool = false
    var nationalNumber: String? = ""
    init(sharedBCID: String? = "",
         bcid: String? = "",
         cn: String? = "",
         company: String? = "",
         mail: String? = "",
         businessPhone: String? = "",
         department: String? = "",
         departmentAr: String? = "",
         description: String? = "",
         displayName: String? = "",
         displayNameAr: String? = "",
         employeeId: String? = "",
         userType: String? = "",
         givenName: String? = "",
         lastLogon: String? = "",
         mailNickname: String? = "",
         phone: String? = "",
         mobile: String? = "",
         name: String? = "",
         nameAr: String? = "",
         info: String? = "",
         samAccountName: String? = "",
         sn: String? = "",
         jobTitle: String? = "",
         jobTitleAr: String? = "",
         userPrincipalName: String? = "",
         id: String? = "",
         photo: String? = "",
         managerPath: String? = "",
         employeePF: String? = "",
         manager: String? = "",
         isSelected: Bool = false,
         nationalNumber: String? = "") {
        self.sharedBCID = sharedBCID
        self.bcid = bcid
        self.cn = cn
        self.company = company
        self.mail = mail
        self.businessPhone = businessPhone
        self.department = department
        self.departmentAr = departmentAr
        self.description = description
        self.displayName = displayName
        self.displayNameAr = displayNameAr
        self.employeeId = employeeId
        self.userType = userType
        self.givenName = givenName
        self.lastLogon = lastLogon
        self.mailNickname = mailNickname
        self.phone = phone
        self.mobile = mobile
        self.name = name
        self.nameAr = nameAr
        self.info = info
        self.samAccountName = samAccountName
        self.sn = sn
        self.jobTitle = jobTitle
        self.jobTitleAr = jobTitleAr
        self.userPrincipalName = userPrincipalName
        self.id = id
        self.photo = photo
        self.managerPath = managerPath
        self.employeePF = employeePF
        self.manager = manager
        self.isSelected = isSelected
        self.nationalNumber = nationalNumber
    }
}
