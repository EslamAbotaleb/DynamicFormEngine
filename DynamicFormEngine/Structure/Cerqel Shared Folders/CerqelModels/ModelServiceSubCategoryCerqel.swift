//
//  ModelServiceSubCategory.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/22/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation


struct ModelServiceResponseCerqel : Codable {
    var data : ModelServicesCerqel? = nil
    var arrData : [ModelServicesCerqel]? = []
    var totalCount: Int = 0
    
    enum CodingKeys: String, CodingKey {

        case data = "data"
        case totalCount = "totalCount"
    }

    
    init(from decoder: Decoder) throws {
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

struct ModelServiceSubCategoryDataCerqel : Codable {
    var services : [ModelServicesCerqel]?
    let id : String?
    let parentId : String?
    let parentCategoryName : String?
    let name : String?
    let imageUrl : String?

    enum CodingKeys: String, CodingKey {

        case services = "services"
        case id = "id"
        case parentId = "parentId"
        case name = "name"
        case imageUrl = "imageUrl"
        case parentCategoryName
    }


}

struct OwnerCerqel : Codable {
    let ownerEmail : String?
    let ownerJobTitleAr : String?
    let ownerJobTitleEn : String?
    let ownerNameAr : String?
    let ownerNameEn : String?
    let photo : String?
    let ownerDepartmentNameAr : String?
    let ownerDepartmentNameEN : String?

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

struct ModelServicesCerqel : Codable {
    let id : String?
    let name : String?
    let displayName : String?
    let listName : String?
    let businessServiceName : String?
    let description : String?
    let owner : OwnerCerqel?
    let categoryName : String?
    let termsAndConditionsAr : String?
    let termsAndConditionsEn : String?
    let imageUrl : String?
    let isListed : Bool?
    var isFavorite : Bool?
    let hasSubService: Bool?
    var isSelected: Bool = false
    var subServicesList: [ModelServicesCerqel]?

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
