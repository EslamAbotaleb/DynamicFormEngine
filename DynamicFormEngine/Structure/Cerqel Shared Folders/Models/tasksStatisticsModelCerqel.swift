//
//  tasksStatisticsModelCerqel.swift
// 
//
//  Created by Hassan elshair on 15/11/2022.
//  Copyright © 2022 All rights reserved.
//

import Foundation

// MARK: - Welcome
public struct tasksStatisticsModelCerqel: Codable {
    public let message: String?
    public let success: Bool?
    public let result: tasksStatisticsResultCerqel?
}

// MARK: - Result
public struct tasksStatisticsResultCerqel: Codable {
    public let data: tasksStatisticsDataClassCerqel?
}

// MARK: - DataClass
public struct tasksStatisticsDataClassCerqel: Codable {
    public let totalCount: Int?
    public let statusDto: [StatusDtoCerqel]?
}

// MARK: - StatusDto
public struct StatusDtoCerqel: Codable {
    public let statusName, statusCode, statusColor: String?
    public let persentage: Double?
    public let count: Int?
    
    public init(statusName: String?, statusCode: String?, statusColor: String?, persentage: Double?, count: Int?) {
        self.statusName = statusName
        self.statusCode = statusCode
        self.statusColor = statusColor
        self.persentage = persentage
        self.count = count
    }
}

public struct ModelUserProfileDataCerqel: Codable {
    // new structure
    public let id : String?
    public let name : String?
    public let jobTitle : String?
    public let mail : String?
    public let departmentName : String?
    public let phone : String?
    public let photo : String?
    public let managerName: String?

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
