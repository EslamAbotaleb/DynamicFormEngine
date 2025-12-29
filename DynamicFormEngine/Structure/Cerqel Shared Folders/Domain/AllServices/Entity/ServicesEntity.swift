//
//  ServicesEntity.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 04/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

struct ServicesEntity {
    
    let id, name, displayName, listName: String?
    let businessServiceName, description: String?
    let owner: Owner?
    let subCategory: ServicesSubCategory?
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
    
}

struct ServicesSubCategory {
    var id: String?
    var name: String?
    var category: ServicesCategory?
    
    init(id: String?, name: String?, category: ServicesCategory?) {
        self.id = id
        self.name = name
        self.category = category
    }
    
    init(){
        self.id = ""
        self.name = ""
        self.category = nil
    }
}

struct ServicesCategory {
    var id: String?
    var name: String?
    
    init(id: String?, name: String?) {
        self.id = id
        self.name = name
    }
    
    init(){
        self.id = ""
        self.name = ""
    }
}
