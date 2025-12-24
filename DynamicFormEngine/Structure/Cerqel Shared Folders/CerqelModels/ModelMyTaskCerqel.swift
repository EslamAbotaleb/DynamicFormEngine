//
//  ModelMyTask.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

public struct ModelMyTaskDataCerqel : Codable {
    let id : String?
    let requestId : String?
    let employee : EmployeeCerqel?
    let serviceName : String?
    let serviceImage : String?
    let isCompleted : Bool?
    let status : StatusCerqel?
    let daysRequested : Int?
    let requestPendingOn : RequestPendingOnCerqel?
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

public struct StatusCerqel: Codable {
    let id : String?

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
    }
}

public struct EmployeeCerqel : Codable {
    let id : String?
    let personId : String?
    let name : String?
    let photo : String?
    let email : String?
    let department : String?
    let position : String?

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

public struct RequestPendingOnCerqel : Codable {
    let id : String?
    let name : String?
    let pendingOnCode : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case pendingOnCode = "pendingOnCode"
    }
}
