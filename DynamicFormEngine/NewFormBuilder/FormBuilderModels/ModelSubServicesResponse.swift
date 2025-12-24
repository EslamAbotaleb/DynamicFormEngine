//
//  ModelSubServicesResponse.swift
// 
//
//  Created by Abdallah Elmahlawy on 5/19/21.
//  Copyright © 2021 All rights reserved.
//

import Foundation

public struct ModelSubServiceData : Codable {
    public let parentService : ParentService?
    public let subServices : [ModelServicesCerqel]?

    enum CodingKeys: String, CodingKey {

        case parentService = "parentService"
        case subServices = "subServices"
    }
}

public struct ParentService : Codable {
    public let displayName : String?
    public let listName : String?
    public let hasSubServices : Bool?

    enum CodingKeys: String, CodingKey {

        case displayName = "displayName"
        case listName = "listName"
        case hasSubServices = "hasSubServices"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        listName = try values.decodeIfPresent(String.self, forKey: .listName)
        hasSubServices = try values.decodeIfPresent(Bool.self, forKey: .hasSubServices)
    }
}
