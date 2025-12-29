//
//  ServicesSubCategoriesDTO.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 02/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct ServicesSubCategoriesDTO: Codable {
    let services: [AllServicesDTO]
    let id, parentID, name, nameEn: String
    let nameAr, parentCategoryName: String
    let imageURL, modifiedByName, createdByName, createdDate: String?
    let createdByID, modifiedDate, modifiedByID: String?

    enum CodingKeys: String, CodingKey {
        case services, id
        case parentID = "parentId"
        case name, nameEn, nameAr, parentCategoryName
        case imageURL = "imageUrl"
        case modifiedByName, createdByName, createdDate
        case createdByID = "createdById"
        case modifiedDate
        case modifiedByID = "modifiedById"
    }
}
