//
//  SendBackDTO.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct SendBackRecipientsDTO : Codable {
    let key : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case value = "value"
    }
}
