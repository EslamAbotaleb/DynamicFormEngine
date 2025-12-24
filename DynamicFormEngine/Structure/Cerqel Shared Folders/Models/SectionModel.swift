//
//  SectionModel.swift
//  CERQEL
//
//  Created by ahmed maher on 24/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

//struct SectionModel {
//    var name: String
//    var items: [SubCategoryModel]
//    var collapsed: Bool
//  
//    
//    init(name: String, items: [SubCategoryModel], collapsed: Bool = false) {
//        self.name = name
//        self.items = items
//        self.collapsed = collapsed
//    
//    }
//    
//    var collapseImage : String {
//        return collapsed ? "arrow_down" : "arrow_up"
//    }
//}


public struct CategoryModel {
    var id: String
    var name: String
    
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
    var id: String
    var name: String
    var category: CategoryModel
    
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
