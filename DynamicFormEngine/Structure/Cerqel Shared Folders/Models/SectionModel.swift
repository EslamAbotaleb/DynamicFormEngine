//
//  SectionModel.swift
//  CERQEL
//
//  Created by ahmed maher on 24/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
//
//public struct SectionModel {
//    public var name: String
//    public var items: [SubCategoryModel]
//    public var collapsed: Bool
//  
//    public init(name: String, items: [SubCategoryModel], collapsed: Bool = false) {
//        self.name = name
//        self.items = items
//        self.collapsed = collapsed
//    }
//    
//    public var collapseImage: String {
//        return collapsed ? "arrow_down" : "arrow_up"
//    }
//}

public struct CategoryModel {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    public init(){
        self.id = ""
        self.name = ""
    }
  
}

public struct SubCategoryModel: Hashable {
    public var id: String
    public var name: String
    public var category: CategoryModel
    
    public init(id: String, name: String, category: CategoryModel) {
        self.id = id
        self.name = name
        self.category = category
    }
    
    // Implementing Hashable and Equatable conformance
    public func hash(into hasher: inout Hasher) {
         hasher.combine(id)
         hasher.combine(name)
     }
     
     static public func == (lhs: SubCategoryModel, rhs: SubCategoryModel) -> Bool {
         return lhs.id == rhs.id && lhs.name == rhs.name
     }
}
