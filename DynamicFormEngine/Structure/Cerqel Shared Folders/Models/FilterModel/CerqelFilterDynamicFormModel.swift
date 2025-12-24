//
//  FilterModel.swift
//  CERQEL
//
//  Created by Marwan on 07/12/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation

public struct CerqelFilterModelCerqelDynamicForm {
    var orignalDateRangeFilter: CerqelDateRangeFilterCerqel?
    var dateRangeFilter: CerqelDateRangeFilterCerqel?
    var categories: [CerqelFilterCategoryCerqelDynamicForm]? = []
//    var selectedSections: [FilterSection]? = []
}

public struct CerqelFilterCategoryCerqelDynamicForm {
    var selectedCategories: [CerqelCategoriesCerqelDynamicForm] = []
    var representation: CerqelCheckBoxRepresentation
    var isAnotherLvl: Bool
//    var filterCategoriesType: CerqelFilterCategoriesSectionEnum
}

public struct CerqelCategoriesCerqelDynamicForm: Codable,Equatable {
    var id, name: String?
    var subCategories:[CerqelCategoriesCerqelDynamicForm]?
    var isSelected: Bool = false
    var representation: CerqelCheckBoxRepresentation = .CheckBox
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

public struct CerqelDateRangeFilterCerqel {
    public var date1: Date?
    public var date2: Date?
    public init() {}
    public init(date1: Date?, date2: Date?) {
        self.date1 = date1
        self.date2 = date2
    }
}
