////
////  ModelServiceSubCategory.swift
////  GAZT
////
////  Created by iSlam AbdelAziz on 12/22/20.
////  Copyright © 2020 Youxel. All rights reserved.
////
//
import Foundation

public struct ModelServicesCerqel : Codable {
    public let id : String?
    public let name : String?
    public let displayName : String?
    public let listName : String?
    public let businessServiceName : String?
    public let description : String?
    public let owner : OwnerCerqel?
    public let categoryName : String?
    public let termsAndConditionsAr : String?
    public let termsAndConditionsEn : String?
    public let imageUrl : String?
    public let isListed : Bool?
    public var isFavorite : Bool?
    public let hasSubService: Bool?
    public var isSelected: Bool = false
    public var subServicesList: [ModelServicesCerqel]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case businessServiceName = "businessServiceName"
        case description = "description"
        case owner = "owner"
        case categoryName = "categoryName"
        case termsAndConditionsAr = "termsAndConditionsAr"
        case termsAndConditionsEn = "termsAndConditionsEn"
        case imageUrl = "imageUrl"
        case isListed = "isListed"
        case isFavorite = "isFavorite"
        case hasSubService
        case displayName
        case listName
    }
}

public struct OwnerCerqel : Codable {
    public let ownerEmail : String?
    public let ownerJobTitleAr : String?
    public let ownerJobTitleEn : String?
    public let ownerNameAr : String?
    public let ownerNameEn : String?
    public let photo : String?
    public let ownerDepartmentNameAr : String?
    public let ownerDepartmentNameEN : String?

    enum CodingKeys: String, CodingKey {

        case ownerEmail = "ownerEmail"
        case ownerJobTitleAr = "ownerJobTitleAr"
        case ownerJobTitleEn = "ownerJobTitleEn"
        case ownerNameAr = "ownerNameAr"
        case ownerNameEn = "ownerNameEn"
        case photo = "photo"
        case ownerDepartmentNameAr = "ownerDepartmentNameAr"
        case ownerDepartmentNameEN = "ownerDepartmentNameEN"
    }
}
