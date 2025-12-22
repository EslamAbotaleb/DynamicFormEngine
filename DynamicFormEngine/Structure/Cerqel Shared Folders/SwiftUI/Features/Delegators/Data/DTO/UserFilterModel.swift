//
//  UserFilterModel.swift
//  CERQEL
//
//  Created by Marwan Osama on 22/09/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation

struct UserFilterModel: Codable {
    var searchString : String?
    
    enum CodingKeys: String, CodingKey {
        case searchString = "SearchKeyword"
    }
}
