//
//  ColorCustomizationModel.swift
//  CERQEL
//
//  Created by mac on 4/5/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation


//struct ColorsDataModel: Codable {
//    var primary: ColorCustomizationModel?
//    var secondary: ColorCustomizationModel?
//
//    enum CodingKeys: String, CodingKey {
//        case primary
//        case secondary
//    }
//
//}

struct ColorCustomizationModelCerqel: Codable {
    
    var red: Double?
    var green: Double?
    var blue: Double?
    var alpha: Double?
    
    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
        case alpha
    }
    
}
