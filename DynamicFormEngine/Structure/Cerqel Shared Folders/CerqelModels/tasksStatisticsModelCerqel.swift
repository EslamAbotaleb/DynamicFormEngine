//
//  tasksStatisticsModelCerqel.swift
// 
//
//  Created by Hassan elshair on 15/11/2022.
//  Copyright © 2022 All rights reserved.
//

import Foundation

// MARK: - Welcome
struct tasksStatisticsModelCerqel: Codable {
    let message: String?
    let success: Bool?
    let result: tasksStatisticsResultCerqel?
}

// MARK: - Result
struct tasksStatisticsResultCerqel: Codable {
    let data: tasksStatisticsDataClassCerqel?
}

// MARK: - DataClass
struct tasksStatisticsDataClassCerqel: Codable {
    let totalCount: Int?
    let statusDto: [StatusDtoCerqel]?
}

// MARK: - StatusDto
struct StatusDtoCerqel: Codable {
    let statusName, statusCode, statusColor: String?
    let persentage: Double?
    let count: Int?
}

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
