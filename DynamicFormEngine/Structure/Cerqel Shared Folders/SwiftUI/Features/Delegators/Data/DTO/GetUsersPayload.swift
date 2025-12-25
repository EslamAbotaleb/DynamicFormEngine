//
//  GetUsersPayload.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
public struct GetUsersPayload : Codable {
    public var filter : UserFilterModel?
    public let searchOptions : String?
    public var pageSize : Int?
    public var pageNumber: Int?

    enum CodingKeys: String, CodingKey {
        case filter = "filter"
        case searchOptions = "searchOptions"
        case pageSize = "pageSize"
        case pageNumber = "pageNumber"
    }

}
