//
//  UserEntity.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

struct UserEntity : Codable,Identifiable {
   public var sharedBCID : String? = ""
   public var bcid : String? = ""
   public var cn : String? = ""
   public var company : String? = ""
   public var mail : String? = ""
   public var businessPhone : String? = ""
   public var department : String? = ""
   public var departmentAr : String? = ""
   public var description : String? = ""
   public var displayName : String? = ""
   public var displayNameAr : String? = ""
   public var employeeId : String? = ""
   public var userType : String? = ""
   public var givenName : String? = ""
   public var lastLogon : String? = ""
   public var mailNickname : String? = ""
   public var phone : String? = ""
   public var mobile : String? = ""
   public var name : String? = ""
   public var nameAr : String? = ""
   public var info : String? = ""
   public var samAccountName : String? = ""
   public var sn : String? = ""
   public var jobTitle : String? = ""
   public var jobTitleAr : String? = ""
   public var userPrincipalName : String? = ""
   public var id : String? = ""
   public var photo : String? = ""
   public var managerPath : String? = ""
   public var employeePF : String? = ""
   public var manager : String? = ""
   public var isSelected: Bool = false
   public var nationalNumber: String? = ""
   public init(sharedBCID: String? = "",
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
