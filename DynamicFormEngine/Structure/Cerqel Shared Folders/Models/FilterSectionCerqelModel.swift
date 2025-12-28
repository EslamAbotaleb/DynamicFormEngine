//
//  FilterSectionCerqelModel.swift
//  CERQEL
//
//  Created by ahmed maher on 13/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import Promises

public struct CerqelFilterCallBack {
    public var searchText: String?
    public var categoryId: String?
    public var HighlightedFilters : HighlightedFilters?
    public var dateRangeFilter: CerqelDateRangeFilterCerqel?
    public var selectedSections: [CerqelFilterSection]? = []
    public init() {}
}

public struct CerqelFilterSection: Equatable,Hashable {
    public var id: Int
    public var sectionTitle: String
    public var sectionType: CerqelFilterSectionsType
    public var filterCategoriesType: CerqelFilterCategoriesType?
    public var items: [CerqelCategoriesModel]?
    public var collapsed: Bool? = true
//    var endPoint: Promise<BaseResponse<[ListModel]>>?
    public var endPoint: EndpointService?
    
    
    public init(id: Int, sectionTitle: String, sectionType: CerqelFilterSectionsType, filterCategoriesType: CerqelFilterCategoriesType? = nil, items: [CerqelCategoriesModel]? = nil, collapsed: Bool = true, endPoint: EndpointService = .pin) {
        self.id = id
        self.sectionTitle = sectionTitle
        self.sectionType = sectionType
        self.filterCategoriesType = filterCategoriesType
        self.items = items
        self.collapsed = collapsed
        self.endPoint = endPoint
    }
    
    
    public init() {
        self.id = 0
        self.sectionTitle = ""
        self.sectionType = .categories(.single)
        self.items = []

        self.endPoint = .categories
        self.filterCategoriesType = .type
        self.collapsed = true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static public func == (lhs: CerqelFilterSection, rhs: CerqelFilterSection) -> Bool {
        return lhs.id == rhs.id
    }
    
}

public enum CerqelFilterSectionsEnum: Equatable{
    
    case dateRangeFilter
    case categories(CategoryLevel)
    
    public init() {
        self = .categories(.single)
        
    }
}

public enum CategoryLevel {
    case multi
    case single
}

public enum ToggleValue {
    case on
    case off
    
    public init(_ value: Bool) {
           self = value ? .on : .off
       }
}

public enum CerqelFilterSectionsType: Equatable{
    case dateRangeFilter
    case categories(CategoryLevel)
    case toggle (ToggleValue)
    
}

public enum CerqelFilterSectionEnum: CaseIterable {
    
    case dateRangeFilter
    case categories
}

public enum CerqelFilterCategoriesSectionEnum: CaseIterable {
    case offersCategories
    case documentLibraryCategories
    case type
}


public enum CerqelFilterCategoriesType: CaseIterable {
    case offersCategories
    case categories
    case subCategories
    case acknowledgement
    case type
    case fileTypes
}

public enum CerqelFilterPathEnum: String {
    case offersCategories = "Lookups/Categories/offers"
}

public enum CerqelRepresentationType {
    case CheckBox
    case Radio
}

public enum CerqelCheckBoxRepresentation {
    case CheckBox
    case Radio
}

public struct CerqelCategoriesModel: Codable,Equatable {
    public var id, name: String?
    public var subCategories:[CerqelCategoriesModel]?
    public var isSelected: Bool = false
    public var isHighlighted: Bool = false
    public var representation: CerqelCheckBoxRepresentation = .CheckBox
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    public init() {}
    
    public init(id: String? = nil,
                name: String? = nil,
                representation: CerqelCheckBoxRepresentation = .CheckBox,
                subCategories: [CerqelCategoriesModel]? = nil,
                isSelected: Bool = false,
                isHighlighted: Bool = false) {
        self.id = id
        self.name = name
        self.representation = representation
        self.subCategories = subCategories
        self.isSelected = isSelected
        self.isHighlighted = isHighlighted
    }
    
    public init(id: String? = nil,
                name: String? = nil,
                isSelected: Bool = false,
                representation: CerqelCheckBoxRepresentation = .CheckBox) {
        self.id = id
        self.name = name
        self.representation = representation
        self.isSelected = isSelected
    }
}
