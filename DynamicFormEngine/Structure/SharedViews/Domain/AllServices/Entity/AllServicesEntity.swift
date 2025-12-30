//
//  AllServicesEntity.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

struct AllServicesDataEntity: Codable {
    var services: [AllServicesDTO]
    let highlightedFilters: HighlightedFilters?

    init(services: [AllServicesDTO], highlightedFilters: HighlightedFilters?) {
        self.services = services
        self.highlightedFilters = highlightedFilters
    }
    
    init() {
        self.services = []
        self.highlightedFilters = nil
    }
}

// MARK: - Owner
struct Owner: Codable {
    let ownerEmail, ownerJobTitleAr, ownerJobTitleEn, ownerNameAr: String?
    let ownerNameEn, photo, ownerDepartmentNameAr, ownerDepartmentNameEn: String?
    
    init() {
        self.ownerEmail = ""
        self.ownerJobTitleAr = ""
        self.ownerJobTitleEn = ""
        self.ownerNameAr = ""
        self.ownerNameEn = ""
        self.photo = ""
        self.ownerDepartmentNameAr = ""
        self.ownerDepartmentNameEn = ""
    }
}
