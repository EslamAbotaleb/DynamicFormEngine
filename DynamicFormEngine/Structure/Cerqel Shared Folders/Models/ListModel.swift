//
//  ListModel.swift
//  CERQEL
//
//  Created by mac on 8/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct ListModel: Codable {
    public var id: String? = ""
    public var name: String?
    public var items: [ListModel]?
    public var collapsed: Bool? = true
    public var isSelected: Bool? = false
    public var nameEn: String?
    public var nameAr: String?
    public var icon: String?
    public var logo: String?
    public var actionCode: String?
    public var actionFormId: String?
    public var isCommentRequired : Bool?
    public var isDimmed: Bool?
    public var isEditable: Bool?
    public var isWithdrawal: Bool?
    public var action: [Action]?
    
    public func getName() -> String? {
        return isArabic() ? nameAr  ?? nameEn : nameEn
    }
    
   public init() {
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
    
    public init(id: String?, name: String? = "", nameEn: String? = "", nameAr: String? = "", items: [ListModel]? = [], isSelected: Bool? = nil , icon : String = "", logo: String = "", actionCode: String? = "", actionFormId: String? = "", isCommentRequired : Bool? = false, isDimmed: Bool = false, isEditable: Bool? = nil, isWithdrawal: Bool? = nil, action: [Action]? = [])  {
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
    
    public var collapseImage : String {
        return collapsed ?? true  ? "arrow_down" : "arrow_up"
    }
    
}

extension ListModel {
    func toCerqelCategoriesModel () -> CerqelCategoriesModel {
        return CerqelCategoriesModel(id: id, name: name, representation: .CheckBox, isSelected: isSelected ?? false)
    }
}
