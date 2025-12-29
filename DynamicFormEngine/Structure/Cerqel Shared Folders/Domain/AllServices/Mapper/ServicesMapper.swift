//
//  ServicesMapper.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 04/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

class ServicesMapper: EntityMapper {
    
    typealias DTO = AllServicesDTO
    typealias Entity = ServicesEntity
    
    func map(from dto: AllServicesDTO) -> ServicesEntity {
        return ServicesEntity(id: dto.id, name: dto.name, displayName: dto.displayName, listName: dto.listName, businessServiceName: dto.businessServiceName, description: dto.description, owner: dto.owner, subCategory: ServicesSubCategory(id: dto.subCategoryID, name: dto.subCategoryName, category: ServicesCategory(id: dto.categoryID, name: dto.categoryName)), termsAndConditionsAr: dto.termsAndConditionsAr, termsAndConditionsEn: dto.termsAndConditionsEn, imageURL: dto.imageURL, imageURLPNG: dto.imageURLPNG, activeImageURL: dto.activeImageURL, isActive: dto.isActive, isListed: dto.isListed, serviceRequestPrefix: dto.serviceRequestPrefix, requestSubmissionMobileVisibilityWeb: dto.requestSubmissionMobileVisibilityWeb, requestSubmissionMobileVisibilityAndroid: dto.requestSubmissionMobileVisibilityAndroid, requestSubmissionMobileVisibilityIos: dto.requestSubmissionMobileVisibilityIos, submittedFromMobileWeb: dto.submittedFromMobileWeb, submittedFromMobileIos: dto.submittedFromMobileIos, submittedFromMobileAndroid: dto.submittedFromMobileAndroid, hasSubService: dto.hasSubService, viewFromMobile: dto.viewFromMobile, isFavorite: dto.isFavorite, favoriteDate: dto.favoriteDate, parentName: dto.parentName, parentDisplayName: dto.parentDisplayName, mainParentName: dto.mainParentName, mainParentDisplayName: dto.mainParentDisplayName, parentID: dto.parentID, mainParentID: dto.mainParentID, createdDate: dto.createdDate, modifiedDate: dto.modifiedDate, subCategoryCount: dto.subCategoryCount)
    }
    
}
