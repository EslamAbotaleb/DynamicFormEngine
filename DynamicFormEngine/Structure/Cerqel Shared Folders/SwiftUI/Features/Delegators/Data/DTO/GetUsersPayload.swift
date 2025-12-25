//
//  GetUsersPayload.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

public struct GetUsersPayload: Codable {
    public var filter: UserFilterModel?
    public let searchOptions: String?
    public var pageSize: Int?
    public var pageNumber: Int?

    public init(
        filter: UserFilterModel?,
        searchOptions: String? = nil,
        pageSize: Int? = nil,
        pageNumber: Int? = nil) {
        self.filter = filter
        self.searchOptions = searchOptions
        self.pageSize = pageSize
        self.pageNumber = pageNumber
    }

    enum CodingKeys: String, CodingKey {
        case filter
        case searchOptions
        case pageSize
        case pageNumber
    }
}
