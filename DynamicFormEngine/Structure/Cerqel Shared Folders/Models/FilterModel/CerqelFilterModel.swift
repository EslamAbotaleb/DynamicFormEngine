//
//  FilterModel.swift
//  CERQEL
//
//  Created by Marwan on 07/12/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation


struct CerqelFilterModelCerqel {
    var orignalDateRangeFilter: CerqelDateRangeFilterCerqel?
    var dateRangeFilter: CerqelDateRangeFilterCerqel?
    var categories: [CerqelFilterCategoryCerqel]? = []
//    var selectedSections: [FilterSection]? = []
}

struct CerqelFilterCategoryCerqel {
    var selectedCategories: [CerqelCategoriesCerqel] = []
    var representation: CerqelCheckBoxRepresentation
    var isAnotherLvl: Bool
//    var filterCategoriesType: CerqelFilterCategoriesSectionEnum
}

struct CerqelCategoriesCerqel: Codable,Equatable {
    var id, name: String?
    var subCategories:[CerqelCategoriesCerqel]?
    var isSelected: Bool = false
    var representation: CerqelCheckBoxRepresentation = .CheckBox
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}


struct CerqelDateRangeFilterCerqel {
    var date1: Date?
    var date2: Date?
}
