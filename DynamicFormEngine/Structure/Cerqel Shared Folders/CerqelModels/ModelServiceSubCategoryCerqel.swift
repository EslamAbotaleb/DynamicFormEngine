//
//  ModelServiceSubCategory.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/22/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation


public struct ModelServiceResponseCerqel : Codable {
    public var data : ModelServicesCerqel? = nil
    public var arrData : [ModelServicesCerqel]? = []
    public var totalCount: Int = 0
    
    enum CodingKeys: String, CodingKey {

        case data = "data"
        case totalCount = "totalCount"
    }

    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        data = try values.decodeIfPresent(ModelNewsDataCerqel.self, forKey: .data)
        
        do {
            data = try values.decodeIfPresent(ModelServicesCerqel.self, forKey: .data)
        } catch DecodingError.typeMismatch(_, let error){
            
            print(error)
            print(error.underlyingError)
            print("☢️ Item typemismatch error ignored")

            // ignore if not found
            // other types : .dataCorrupted, .keyNotFound, .typeMismatch and .valueNotFound.
        } catch let err{
            if let err = err as? DecodingError {
                print("☢️☢️☢️  ITEM Decoding Error : \(err) ☢️☢️☢️")
            }
        }

        
        
        do {
            arrData = try values.decodeIfPresent([ModelServicesCerqel].self, forKey: .data)
            totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        } catch DecodingError.typeMismatch(_, let err){
            // ignore if not found
            print("⛔️ Items typemismatch error ignored \(err)")
        } catch let err{
            print("⛔️⛔️⛔️  ITEMS Decoding Error : \(err) ⛔️⛔️⛔️")
        }

        
        
    }

}

public struct ModelServiceSubCategoryDataCerqel : Codable {
    public var services : [ModelServicesCerqel]?
    public let id : String?
    public let parentId : String?
    public let parentCategoryName : String?
    public let name : String?
    public let imageUrl : String?

    enum CodingKeys: String, CodingKey {

        case services = "services"
        case id = "id"
        case parentId = "parentId"
        case name = "name"
        case imageUrl = "imageUrl"
        case parentCategoryName
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
