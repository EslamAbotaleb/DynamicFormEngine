//
//  ListModel.swift
//  CERQEL
//
//  Created by mac on 8/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct ListModel: Codable {
    var id: String? = ""
    var name: String?
    var items: [ListModel]?
    var collapsed: Bool? = true
    var isSelected: Bool? = false
    var nameEn: String?
    var nameAr: String?
    var icon: String?
    var logo: String?
    var actionCode: String?
    var actionFormId: String?
    var isCommentRequired : Bool?
    var isDimmed: Bool?
    var isEditable: Bool?
    var isWithdrawal: Bool?
    var action: [Action]?
   func getName() -> String? {
        return isArabic() ? nameAr  ?? nameEn : nameEn
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.icon = ""
        self.logo = ""
        self.actionCode = ""
        self.actionFormId = ""
        self.isCommentRequired = false
        self.items = []
        self.isSelected = false
        self.isDimmed = false
        self.isEditable =  nil
        self.isWithdrawal = nil
        self.action = []
    }
    
    init(id: String?, name: String? = "", nameEn: String? = "", nameAr: String? = "", items: [ListModel]? = [], isSelected: Bool? = nil , icon : String = "", logo: String = "", actionCode: String? = "", actionFormId: String? = "", isCommentRequired : Bool? = false, isDimmed: Bool = false, isEditable: Bool? = nil, isWithdrawal: Bool? = nil, action: [Action]? = [])  {
        self.id = id
        self.nameAr = nameAr
        self.nameEn = nameEn
        self.items = items
        self.isSelected = isSelected
        self.name = name
        self.icon = icon
        self.logo = logo
        self.actionCode = actionCode
        self.actionFormId = actionFormId
        self.isCommentRequired = isCommentRequired
        self.isDimmed = isDimmed
        self.action = action
        self.isEditable = isEditable
        self.isWithdrawal = isWithdrawal
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id,name,collapsed,icon
        case items = "children"
        case logo = "appLogo"
        case isSelected
        case nameEn, nameAr

    }
    
    var collapseImage : String {
        return collapsed ?? true  ? "arrow_down" : "arrow_up"
    }
    
}
//extension ListModel {
//    
//    func toCerqelCategoriesModel () -> CerqelCategoriesModel {
//        return CerqelCategoriesModel(id: id, name: name, isSelected: isSelected ?? false, representation: .CheckBox)
//    }
//    
//}
