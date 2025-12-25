//
//  UsersMapper.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

public class UsersListMapper: EntityMapper{

    public typealias DTO = UserDTO
    public typealias Entity = UserEntity

    public init() {}
    
    public func map(from dto: UserDTO) -> UserEntity {
        return UserEntity(sharedBCID: dto.sharedBCID, bcid: dto.bcid, cn: dto.cn, company: dto.company, mail: dto.mail, businessPhone: dto.businessPhone, department: dto.department, departmentAr: dto.departmentAr, description: dto.description, displayName: dto.displayName, displayNameAr: dto.displayNameAr, employeeId: dto.employeeId, userType: dto.userType, givenName: dto.givenName, lastLogon: dto.lastLogon, mailNickname: dto.mailNickname, phone: dto.phone, mobile: dto.mobile, name: dto.name, nameAr: dto.nameAr, info: dto.info, samAccountName: dto.samAccountName, sn: dto.sn, jobTitle: dto.jobTitle, jobTitleAr: dto.jobTitleAr, userPrincipalName: dto.userPrincipalName, id: dto.id, photo: dto.photo, managerPath: dto.managerPath, employeePF: dto.employeePF, manager: dto.manager, nationalNumber: dto.nationalNumber)
    }
}
