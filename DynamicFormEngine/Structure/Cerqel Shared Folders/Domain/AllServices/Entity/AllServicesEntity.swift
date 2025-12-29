//
//  AllServicesEntity.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct AllServicesDataEntity: Codable {
    public var services: [AllServicesDTO]
    public let highlightedFilters: HighlightedFilters?

    public init(services: [AllServicesDTO], highlightedFilters: HighlightedFilters?) {
        self.services = services
        self.highlightedFilters = highlightedFilters
    }
    
    public init() {
        self.services = []
        self.highlightedFilters = nil
    }
}

// MARK: - Owner
public struct Owner: Codable {
    public let ownerEmail, ownerJobTitleAr, ownerJobTitleEn, ownerNameAr: String?
    public let ownerNameEn, photo, ownerDepartmentNameAr, ownerDepartmentNameEn: String?
    
    public init() {
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
