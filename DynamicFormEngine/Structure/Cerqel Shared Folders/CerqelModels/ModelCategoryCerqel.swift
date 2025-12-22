//
//  ModelCategory.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/22/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation


struct ModelCategoryDataCerqel : Codable {
    let id : String?
    let parentId : String?
    let name : String?
    let imageUrl : String?
    let numberOfServices : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case parentId = "parentId"
        case name = "name"
        case imageUrl = "imageUrl"
        case numberOfServices = "numberOfServices"
    }


}
