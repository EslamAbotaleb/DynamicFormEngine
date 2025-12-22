//
//  ModelMyTask.swift
// 
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
import ObjectMapper

struct ModelMyTaskData : Codable {
    let id : String?
    let requestId : String?
    let employee : Employee?
    let serviceName : String?
    let serviceImage : String?
    let isCompleted : Bool?
    let status : Status?
    let daysRequested : Int?
    let requestPendingOn : RequestPendingOn?
    let requestDate : String?
    let createdDate: String?
    let modifiedDate: String?
    let itRequestId: String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case requestId = "requestId"
        case employee = "employee"
        case serviceName = "serviceName"
        case serviceImage = "serviceImage"
        case isCompleted = "isCompleted"
        case status = "status"
        case daysRequested = "daysRequested"
        case requestPendingOn = "requestPendingOn"
        case requestDate = "requestDate"
        case itRequestId = "itRequestId"
        case createdDate
        case modifiedDate
    }
}

struct Employee: Codable, Mappable {
    var id: String?
    var personId: String?
    var name: String?
    var photo: String?
    var email: String?
    var department: String?
    var position: String?
    
    // ObjectMapper's Mappable init
    init?(map: Map) {}
    
    // Mapping for ObjectMapper
    mutating func mapping(map: Map) {
        id          <- map["id"]
        personId    <- map["personId"]
        name        <- map["name"]
        photo       <- map["photo"]
        email       <- map["email"]
        department  <- map["department"]
        position    <- map["position"]
    }
    
    // Codable initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        personId = try container.decodeIfPresent(String.self, forKey: .personId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        photo = try container.decodeIfPresent(String.self, forKey: .photo)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        department = try container.decodeIfPresent(String.self, forKey: .department)
        position = try container.decodeIfPresent(String.self, forKey: .position)
    }
    
    // Codable method for encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(personId, forKey: .personId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(photo, forKey: .photo)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(department, forKey: .department)
        try container.encodeIfPresent(position, forKey: .position)
    }
    
    // ObjectMapper's keys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case personId = "personId"
        case name = "name"
        case photo = "photo"
        case email = "email"
        case department = "department"
        case position = "position"
    }
}

struct RequestPendingOn: Codable, Mappable {
    var id: String?
    var name: String?
    var pendingOnCode: String?
    var isGroup: Bool?
    var groupNames: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case pendingOnCode = "pendingOnCode"
        case isGroup
        case groupNames
    }
    
    // Codable initializer
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pendingOnCode = try values.decodeIfPresent(String.self, forKey: .pendingOnCode)
        isGroup = try values.decodeIfPresent(Bool.self, forKey: .isGroup)
        groupNames = try values.decodeIfPresent([String].self, forKey: .groupNames)
    }
    
    // Mappable initializer
    init?(map: Map) {
        id = nil
        name = nil
        pendingOnCode = nil
        isGroup = nil
        groupNames = nil
    }
    
    // Mappable mapping function
    mutating func mapping(map: Map) {
        id <- map[CodingKeys.id.rawValue]
        name <- map[CodingKeys.name.rawValue]
        pendingOnCode <- map[CodingKeys.pendingOnCode.rawValue]
        isGroup <- map[CodingKeys.isGroup.rawValue]
        groupNames <- map[CodingKeys.name.rawValue]
    }
}

