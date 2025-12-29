//
//  ServicesCategoriesDTO.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 02/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct ServicesCategoriesDTO: Codable {
    let id: String
    let parentID: String?
    let name, nameEn, nameAr: String
    let imageURL: String?
    let numberOfServices, numberOfSubCategories: Int
    let isDeleted: Bool
    let modifiedByName, createdByName, createdDate: String?
    let createdByID: String?
    let modifiedDate, modifiedByID: String?
    let parentCategory: String?
    let subCategories: [String]? = []
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parentId"
        case name, nameEn, nameAr
        case imageURL = "imageUrl"
        case numberOfServices, numberOfSubCategories, isDeleted, modifiedByName, createdByName, createdDate
        case createdByID = "createdById"
        case modifiedDate
        case modifiedByID = "modifiedById"
        case parentCategory, subCategories, isActive
    }
}
