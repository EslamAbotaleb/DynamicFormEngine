//
//  FilterSectionCerqelModel.swift
//  CERQEL
//
//  Created by ahmed maher on 13/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import Promises

struct CerqelFilterCallBack {
    var searchText: String?
    var categoryId: String?
    var HighlightedFilters : HighlightedFilters?
    var dateRangeFilter: CerqelDateRangeFilterCerqel?
    var selectedSections: [CerqelFilterSection]? = []
}

struct CerqelFilterSection: Equatable,Hashable {
    var id: Int
    var sectionTitle: String
    var sectionType: CerqelFilterSectionsType
    var filterCategoriesType: CerqelFilterCategoriesType?
    var items: [CerqelCategoriesModel]?
    var collapsed: Bool? = true
//    var endPoint: Promise<BaseResponse<[ListModel]>>?
    var endPoint: EndpointService?
    
    
    init(id: Int, sectionTitle: String, sectionType: CerqelFilterSectionsType, filterCategoriesType: CerqelFilterCategoriesType? = nil, items: [CerqelCategoriesModel]? = nil, collapsed: Bool = true, endPoint: EndpointService = .pin) {
        self.id = id
        self.sectionTitle = sectionTitle
        self.sectionType = sectionType
        self.filterCategoriesType = filterCategoriesType
        self.items = items
        self.collapsed = collapsed
        self.endPoint = endPoint
    }
    
    
    init() {
        self.id = 0
        self.sectionTitle = ""
        self.sectionType = .categories(.single)
        self.items = []

        self.endPoint = .categories
        self.filterCategoriesType = .type
        self.collapsed = true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CerqelFilterSection, rhs: CerqelFilterSection) -> Bool {
        return lhs.id == rhs.id
    }
    
}

enum CategoryLevel {
    case multi
    case single
}

enum ToggleValue {
    case on
    case off
    
    init(_ value: Bool) {
           self = value ? .on : .off
       }
}

enum CerqelFilterSectionsType: Equatable{
    
    case dateRangeFilter
    case categories(CategoryLevel)
    case toggle (ToggleValue)
    
}


enum CerqelFilterCategoriesType: CaseIterable {
    case offersCategories
    case categories
    case subCategories
    case acknowledgement
    case type
    case fileTypes
}

//enum CerqelFilterPathEnum: String {
//    case offersCategories = "Lookups/Categories/offers"
//}

public enum CerqelRepresentationType {
    case CheckBox
    case Radio
}

public enum CerqelCheckBoxRepresentation {
    case CheckBox
    case Radio
}

struct CerqelCategoriesModel: Codable,Equatable {
    var id, name: String?
    var subCategories:[CerqelCategoriesModel]?
    var isSelected: Bool = false
    var isHighlighted: Bool = false
    var representation: CerqelCheckBoxRepresentation = .CheckBox
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
