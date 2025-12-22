//
//  ModelQuoteCerqel.swift
//  CERQEL
//
//  Created by mac on 9/25/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct ModelQuoteCerqel: Codable {
    
    var text: String?
        
    enum CodingKeys: String, CodingKey {
        case text
    }
    
}
