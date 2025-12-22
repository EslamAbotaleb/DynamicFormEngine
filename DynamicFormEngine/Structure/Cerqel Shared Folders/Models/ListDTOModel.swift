//
//  ListDTOModel.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation
struct ListDTOModel: Identifiable {
    let id: Int
    let title: String
    var isSelected: Bool

    init(id: Int, title: String, isSelected: Bool) {
        self.id = id
        self.title = title
        self.isSelected = isSelected

    }

    init() {
        self.id = 0
        self.title = ""
        self.isSelected = false

    }
    

}
