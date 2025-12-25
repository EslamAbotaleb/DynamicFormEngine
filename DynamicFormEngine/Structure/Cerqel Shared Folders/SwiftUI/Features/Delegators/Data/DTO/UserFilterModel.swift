//
//  UserFilterModel.swift
//  CERQEL
//
//  Created by Marwan Osama on 22/09/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

public struct UserFilterModel: Codable {

    public var searchString: String?

    public init(searchString: String? = nil) {
        self.searchString = searchString
    }

    enum CodingKeys: String, CodingKey {
        case searchString = "SearchKeyword"
    }
}
