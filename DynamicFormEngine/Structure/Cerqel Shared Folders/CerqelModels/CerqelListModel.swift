//
//  CerqelListModel.swift
//  CERQEL
//
//  Created by mac on 9/6/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct CerqelListModel: Codable {
    var id: String?
    var collapsed: Bool? = true
    var isSelected: Bool?
    var nameEn: String?
    var nameAr: String?
    
    public init()  {
        self.isSelected = false
    }
    
    enum CodingKeys: String, CodingKey {
        case id,collapsed
        case isSelected
        case nameEn, nameAr
    }
    
    var collapseImage : String {
        return collapsed ?? true  ? "arrow_down" : "arrow_up"
    }
    
}
