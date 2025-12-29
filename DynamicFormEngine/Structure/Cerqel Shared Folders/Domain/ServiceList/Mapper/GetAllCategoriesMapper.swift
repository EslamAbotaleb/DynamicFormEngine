//
//  GetAllCategoriesMapper.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 26/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

class GetAllCategoriesMapper: EntityMapper {
    typealias DTO = GetAllCategoriesDTO
    typealias Entity = GetAllCategoriesEntity
    func map(from dto: GetAllCategoriesDTO) -> GetAllCategoriesEntity {
        return GetAllCategoriesEntity(id: dto.id, parentID: dto.parentID, name: dto.name, nameEn: dto.nameEn, nameAr: dto.nameAr, imageURL: dto.imageURL, numberOfServices: dto.numberOfServices, numberOfSubCategories: dto.numberOfSubCategories, isDeleted: dto.isDeleted, modifiedByName: dto.modifiedByName, createdByName: dto.createdByName, createdDate: dto.createdDate, createdByID: dto.createdByID, modifiedDate: dto.modifiedDate, modifiedByID: dto.modifiedByID, parentCategory: dto.parentCategory, subCategories: dto.subCategories, isActive: dto.isActive)
    }
    
}
