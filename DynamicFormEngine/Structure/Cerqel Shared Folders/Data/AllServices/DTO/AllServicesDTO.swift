//
//  AllServicesDTO.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct AllServicesDataDTO: Codable {
    public let services: [AllServicesDTO]
    public let highlightedFilters: HighlightedFilters?

    public enum CodingKeys: String, CodingKey {
        case services
        case highlightedFilters
    }
}
public struct AllServicesDTO: Codable {
    public let id, name, displayName, listName: String?
    public let businessServiceName, description: String?
    public let owner: Owner?
    public let subCategoryName, categoryName, subCategoryID, categoryID: String?
    public let termsAndConditionsAr, termsAndConditionsEn, imageURL, imageURLPNG: String?
    public let activeImageURL: String?
    public let isActive, isListed: Bool?
    public let serviceRequestPrefix: String?
    public let requestSubmissionMobileVisibilityWeb, requestSubmissionMobileVisibilityAndroid, requestSubmissionMobileVisibilityIos, submittedFromMobileWeb: Bool?
    public let submittedFromMobileIos, submittedFromMobileAndroid, hasSubService, viewFromMobile: Bool?
    public var isFavorite: Bool?
    public let favoriteDate, parentName, parentDisplayName, mainParentName: String?
    public let mainParentDisplayName, parentID, mainParentID, createdDate: String?
    public let modifiedDate: String?
    public let subCategoryCount: Int?

    public enum CodingKeys: String, CodingKey {
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
    
    public init(id: String?, name: String?, displayName: String?, listName: String?, businessServiceName: String?, description: String?, owner: Owner?, subCategoryName: String?, categoryName: String?, subCategoryID: String?, categoryID: String?, termsAndConditionsAr: String?, termsAndConditionsEn: String?, imageURL: String?, imageURLPNG: String?, activeImageURL: String?, isActive: Bool?, isListed: Bool?, serviceRequestPrefix: String?, requestSubmissionMobileVisibilityWeb: Bool?, requestSubmissionMobileVisibilityAndroid: Bool?, requestSubmissionMobileVisibilityIos: Bool?, submittedFromMobileWeb: Bool?, submittedFromMobileIos: Bool?, submittedFromMobileAndroid: Bool?, hasSubService: Bool?, viewFromMobile: Bool?, isFavorite: Bool? = nil, favoriteDate: String?, parentName: String?, parentDisplayName: String?, mainParentName: String?, mainParentDisplayName: String?, parentID: String?, mainParentID: String?, createdDate: String?, modifiedDate: String?, subCategoryCount: Int?) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.listName = listName
        self.businessServiceName = businessServiceName
        self.description = description
        self.owner = owner
        self.subCategoryName = subCategoryName
        self.categoryName = categoryName
        self.subCategoryID = subCategoryID
        self.categoryID = categoryID
        self.termsAndConditionsAr = termsAndConditionsAr
        self.termsAndConditionsEn = termsAndConditionsEn
        self.imageURL = imageURL
        self.imageURLPNG = imageURLPNG
        self.activeImageURL = activeImageURL
        self.isActive = isActive
        self.isListed = isListed
        self.serviceRequestPrefix = serviceRequestPrefix
        self.requestSubmissionMobileVisibilityWeb = requestSubmissionMobileVisibilityWeb
        self.requestSubmissionMobileVisibilityAndroid = requestSubmissionMobileVisibilityAndroid
        self.requestSubmissionMobileVisibilityIos = requestSubmissionMobileVisibilityIos
        self.submittedFromMobileWeb = submittedFromMobileWeb
        self.submittedFromMobileIos = submittedFromMobileIos
        self.submittedFromMobileAndroid = submittedFromMobileAndroid
        self.hasSubService = hasSubService
        self.viewFromMobile = viewFromMobile
        self.isFavorite = isFavorite
        self.favoriteDate = favoriteDate
        self.parentName = parentName
        self.parentDisplayName = parentDisplayName
        self.mainParentName = mainParentName
        self.mainParentDisplayName = mainParentDisplayName
        self.parentID = parentID
        self.mainParentID = mainParentID
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.subCategoryCount = subCategoryCount
    }
}

