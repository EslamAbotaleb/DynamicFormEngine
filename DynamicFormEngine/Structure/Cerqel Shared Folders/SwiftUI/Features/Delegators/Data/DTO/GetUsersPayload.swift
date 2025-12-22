//
//  GetUsersPayload.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
    struct GetUsersPayload : Codable {
        var filter : UserFilterModel?
        let searchOptions : String?
        var pageSize : Int?
        var pageNumber: Int?

        enum CodingKeys: String, CodingKey {
            case filter = "filter"
            case searchOptions = "searchOptions"
            case pageSize = "pageSize"
            case pageNumber = "pageNumber"
        }

    }
