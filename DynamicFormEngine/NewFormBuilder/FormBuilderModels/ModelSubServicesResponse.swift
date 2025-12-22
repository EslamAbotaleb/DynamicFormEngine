//
//  ModelSubServicesResponse.swift
// 
//
//  Created by Abdallah Elmahlawy on 5/19/21.
//  Copyright © 2021 All rights reserved.
//

import Foundation

struct ModelSubServiceData : Codable {
    let parentService : ParentService?
    let subServices : [ModelServicesCerqel]?

    enum CodingKeys: String, CodingKey {

        case parentService = "parentService"
        case subServices = "subServices"
    }
}

struct ParentService : Codable {
    let displayName : String?
    let listName : String?
    let hasSubServices : Bool?

    enum CodingKeys: String, CodingKey {

        case displayName = "displayName"
        case listName = "listName"
        case hasSubServices = "hasSubServices"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        listName = try values.decodeIfPresent(String.self, forKey: .listName)
        hasSubServices = try values.decodeIfPresent(Bool.self, forKey: .hasSubServices)
    }
}
