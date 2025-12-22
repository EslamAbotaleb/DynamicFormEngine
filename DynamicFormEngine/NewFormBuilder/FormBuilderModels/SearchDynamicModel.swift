//
//  SearchModel.swift
//  KAFDHUB
//
//  Created by Mohamed Nagi on 10/05/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct SearchDynamicModel: Codable {
    let id : String?
    let code : String?
    let isActive : Bool?
    let parentId : String?
    let name : String?
    let nameEn : String?
    let nameAr : String?
    let valuesCount : Int?
    let createdByUserId : String?
    let modifiedByUserId : String?
    let creationDate : String?
    let modificationDate : String?
//    let searchValues : [SearchValues]?
    let components: [ComponentsModel]?
    let createdByName : String?
    let modifiedByName : String?
    let cascadeTargetType: Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case code = "code"
        case isActive = "isActive"
        case parentId = "parentId"
        case name = "name"
        case nameEn = "nameEn"
        case nameAr = "nameAr"
        case valuesCount = "valuesCount"
        case createdByUserId = "createdByUserId"
        case modifiedByUserId = "modifiedByUserId"
        case creationDate = "creationDate"
        case modificationDate = "modificationDate"
//        case searchValues = "values"
        case createdByName = "createdByName"
        case modifiedByName = "modifiedByName"
        case components
        case cascadeTargetType = "cascadeTargetType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        parentId = try values.decodeIfPresent(String.self, forKey: .parentId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        nameEn = try values.decodeIfPresent(String.self, forKey: .nameEn)
        nameAr = try values.decodeIfPresent(String.self, forKey: .nameAr)
        valuesCount = try values.decodeIfPresent(Int.self, forKey: .valuesCount)
        createdByUserId = try values.decodeIfPresent(String.self, forKey: .createdByUserId)
        modifiedByUserId = try values.decodeIfPresent(String.self, forKey: .modifiedByUserId)
        creationDate = try values.decodeIfPresent(String.self, forKey: .creationDate)
        modificationDate = try values.decodeIfPresent(String.self, forKey: .modificationDate)
//        searchValues = try values.decodeIfPresent([SearchValues].self, forKey: .searchValues)
        createdByName = try values.decodeIfPresent(String.self, forKey: .createdByName)
        modifiedByName = try values.decodeIfPresent(String.self, forKey: .modifiedByName)
        components = try values.decodeIfPresent([ComponentsModel].self, forKey: .components)
        cascadeTargetType = try values.decodeIfPresent(Int.self, forKey: .cascadeTargetType)
    }
}


struct SearchValues : Codable {
    let id : String?
    let code : String?
    let listGroupId : String?
    let name : String?
    let nameEN : String?
    let nameAR : String?
    let icon : String?
    let createdByUserId : String?
    let modifiedByUserId : String?
    let createdByName : String?
    let modifiedByName : String?
    let creationDate : String?
    let modificationDate : String?
    let key: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case code = "code"
        case listGroupId = "listGroupId"
        case name = "name"
        case nameEN = "nameEN"
        case nameAR = "nameAR"
        case icon = "icon"
        case createdByUserId = "createdByUserId"
        case modifiedByUserId = "modifiedByUserId"
        case createdByName = "createdByName"
        case modifiedByName = "modifiedByName"
        case creationDate = "creationDate"
        case modificationDate = "modificationDate"
        case key
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        listGroupId = try values.decodeIfPresent(String.self, forKey: .listGroupId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
//        if let bool = try? values.decode(Bool.self, forKey: .name) {
//            name = DataType.bool(bool)
//        } else {
//            let string = try values.decode(String.self, forKey: .name)
//            name = DataType.string(string)
//        }
        nameEN = try values.decodeIfPresent(String.self, forKey: .nameEN)
        nameAR = try values.decodeIfPresent(String.self, forKey: .nameAR)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        createdByUserId = try values.decodeIfPresent(String.self, forKey: .createdByUserId)
        modifiedByUserId = try values.decodeIfPresent(String.self, forKey: .modifiedByUserId)
        createdByName = try values.decodeIfPresent(String.self, forKey: .createdByName)
        modifiedByName = try values.decodeIfPresent(String.self, forKey: .modifiedByName)
        creationDate = try values.decodeIfPresent(String.self, forKey: .creationDate)
        modificationDate = try values.decodeIfPresent(String.self, forKey: .modificationDate)
        key = try values.decodeIfPresent(String.self, forKey: .key)
    }

}

struct ComponentsModel: Codable {
    let id: String?
    let name: String?
    let type: String?
    let parentId: String?
    let rowIndex: String?
    let values: [SearchValues]?
    
    init(from decoder: Decoder) throws {
        let _values = try decoder.container(keyedBy: CodingKeys.self)
        id = try _values.decodeIfPresent(String.self, forKey: .id)
        name = try _values.decodeIfPresent(String.self, forKey: .name)
        type = try _values.decodeIfPresent(String.self, forKey: .type)
        parentId = try _values.decodeIfPresent(String.self, forKey: .parentId)
        rowIndex = try _values.decodeIfPresent(String.self, forKey: .rowIndex)
        values = try _values.decodeIfPresent([SearchValues].self, forKey: .values)
    }
}
