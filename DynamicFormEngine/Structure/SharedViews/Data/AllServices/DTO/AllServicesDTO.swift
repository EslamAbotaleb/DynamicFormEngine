//
//  AllServicesDTO.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

struct AllServicesDataDTO: Codable {
    let services: [AllServicesDTO]
    let highlightedFilters: HighlightedFilters?

    enum CodingKeys: String, CodingKey {
        case services
        case highlightedFilters
    }
}
struct AllServicesDTO: Codable {
    let id, name, displayName, listName: String?
    let businessServiceName, description: String?
    let owner: Owner?
    let subCategoryName, categoryName, subCategoryID, categoryID: String?
    let termsAndConditionsAr, termsAndConditionsEn, imageURL, imageURLPNG: String?
    let activeImageURL: String?
    let isActive, isListed: Bool?
    let serviceRequestPrefix: String?
    let requestSubmissionMobileVisibilityWeb, requestSubmissionMobileVisibilityAndroid, requestSubmissionMobileVisibilityIos, submittedFromMobileWeb: Bool?
    let submittedFromMobileIos, submittedFromMobileAndroid, hasSubService, viewFromMobile: Bool?
    var isFavorite: Bool?
    let favoriteDate, parentName, parentDisplayName, mainParentName: String?
    let mainParentDisplayName, parentID, mainParentID, createdDate: String?
    let modifiedDate: String?
    let subCategoryCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, displayName, listName, businessServiceName, description, owner
        case termsAndConditionsAr, termsAndConditionsEn
        case imageURL = "imageUrl"
        case imageURLPNG = "imageUrlPng"
        case activeImageURL = "activeImageUrl"
        case isActive, isListed, serviceRequestPrefix, requestSubmissionMobileVisibilityWeb, requestSubmissionMobileVisibilityAndroid, requestSubmissionMobileVisibilityIos, submittedFromMobileWeb, submittedFromMobileIos, submittedFromMobileAndroid, hasSubService, viewFromMobile, isFavorite, favoriteDate, parentName, parentDisplayName, mainParentName, mainParentDisplayName
        case parentID = "parentId"
        case mainParentID = "mainParentId"
        case subCategoryName = "categoryName"
        case subCategoryID = "categoryId"
        case categoryName = "parentCategoryName"
        case categoryID = "parentCategoryId"

        case createdDate, modifiedDate, subCategoryCount
    }
}

