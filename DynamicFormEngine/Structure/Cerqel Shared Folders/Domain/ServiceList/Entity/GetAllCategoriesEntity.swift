//
//  GetAllCategoriesEntity.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 26/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

struct GetAllCategoriesEntity: Codable {
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
    let subCategories: [GetAllCategoriesDTO]
    let isActive: Bool
    
    var collapsed: Bool? = true
    var isSelected: Bool?
    var collapseImage: String {
        return collapsed ?? true  ? "arrow_down" : "arrow_up"
    }
    
    init(id: String, parentID: String?, name: String, nameEn: String, nameAr: String, imageURL: String?, numberOfServices: Int, numberOfSubCategories: Int, isDeleted: Bool, modifiedByName: String?, createdByName: String?, createdDate: String?, createdByID: String?, modifiedDate: String?, modifiedByID: String?, parentCategory: String?, subCategories: [GetAllCategoriesDTO], isActive: Bool, collapsed: Bool? = nil, isSelected: Bool? = nil) {
        self.id = id
        self.parentID = parentID
        self.name = name
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.imageURL = imageURL
        self.numberOfServices = numberOfServices
        self.numberOfSubCategories = numberOfSubCategories
        self.isDeleted = isDeleted
        self.modifiedByName = modifiedByName
        self.createdByName = createdByName
        self.createdDate = createdDate
        self.createdByID = createdByID
        self.modifiedDate = modifiedDate
        self.modifiedByID = modifiedByID
        self.parentCategory = parentCategory
        self.subCategories = subCategories
        self.isActive = isActive
        self.collapsed = collapsed
        self.isSelected = isSelected
    }
    
    init() {
        self.id = ""
        self.parentID = ""
        self.name = ""
        self.nameEn = ""
        self.nameAr = ""
        self.imageURL = ""
        self.numberOfServices = 0
        self.numberOfSubCategories = 0
        self.isDeleted = false
        self.modifiedByName = ""
        self.createdByName = ""
        self.createdDate = ""
        self.createdByID = ""
        self.modifiedDate = ""
        self.modifiedByID = ""
        self.parentCategory = ""
        self.subCategories = []
        self.isActive = false
        self.collapsed = false
        self.isSelected = false
    }
}
extension GetAllCategoriesEntity {
    
   public func toCerqelCategoriesModel () -> CerqelCategoriesModel {
        return CerqelCategoriesModel(id: id, name: name, isSelected: isSelected ?? false, representation: .CheckBox)
    }
    
}
