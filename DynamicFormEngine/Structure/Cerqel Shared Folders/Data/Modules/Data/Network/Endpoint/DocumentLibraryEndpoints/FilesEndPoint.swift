//
//  FilesEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 23/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct FilesEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .allFiles
    var method: EndpointMethod = .post
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    
    init(cerqelFilterPayload: CerqelFilterPayload ) {
        parameters = cerqelFilterPayload.asDictionary()
        
    }
}


struct EndPointFilterRequest: Codable {
    var pageNumber: Int
    var pageSize: Int
    
}

struct CerqelFilterPayload: Codable {
    var pageNumber: Int?
    var pageSize: Int?
    var filter: Filter?
    var SearchKeyword: String?
    var from : String?
    var to: String?
    var isAcknowledgement: Bool?
    var isPinned: Bool?
    var categoriesIds: [String]?
    var subCategoriesIds: [String]?
    var fileTypesIds: [String]?
    var toggles: [[String:Bool]]?
    var orderByValue: [OrderByValue]?
    var orderBy: Int?
}

// MARK: - Filter

struct Filter: Codable {
    var searchKeyword: String?
    var categoryID: [String]?
    var subCategoryID: [String]?
    var fileType: [String]?
    var isAcknowledgement: Bool?
    var isRecent: Bool?
    var isPinned: Bool?
    var isGrouped : Bool?
    var isFavorite : Bool?
    var from: String?
    var to: String?
    var updatedDateFrom: String?
    var updatedDateTo: String?
    var categoryId: String?
    var isActive: Bool?
}


struct SuggestionPayload: Codable {
    var searchKeyword: String
}


// MARK: - OrderByValue
struct OrderByValue: Codable {
    let colID, sort: String?
    
    enum CodingKeys: String, CodingKey {
        case colID = "colId"
        case sort
    }
}

// MARK: - OrderBy

enum OrderBy: Int {
    case Newest = 1
    case Oldest = 2
    case A_Z = 3
    case Z_A = 4

}
