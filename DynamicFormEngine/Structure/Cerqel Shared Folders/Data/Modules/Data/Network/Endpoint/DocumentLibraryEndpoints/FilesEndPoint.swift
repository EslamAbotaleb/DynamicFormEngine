//
//  FilesEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 23/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct FilesEndPoint: Endpoint {
    
    public var urlPrefix: String = ""
    public var service: EndpointService = .allFiles
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    
    public var multipart: [MultiPartModel] {
        []
    }
    
    public init(cerqelFilterPayload: CerqelFilterPayload ) {
        parameters = cerqelFilterPayload.asDictionary()
        
    }
}


public struct EndPointFilterRequest: Codable {
    var pageNumber: Int
    var pageSize: Int
    
}

public struct CerqelFilterPayload: Codable {
    public var pageNumber: Int?
    public var pageSize: Int?
    public var filter: Filter?
    public var SearchKeyword: String?
    public var from : String?
    public var to: String?
    public var isAcknowledgement: Bool?
    public var isPinned: Bool?
    public var categoriesIds: [String]?
    public var subCategoriesIds: [String]?
    public var fileTypesIds: [String]?
    public var toggles: [[String:Bool]]?
    public var orderByValue: [OrderByValue]?
    public var orderBy: Int?
    public init() {}
}

// MARK: - Filter

public struct Filter: Codable {
    public var searchKeyword: String?
    public var categoryID: [String]?
    public var subCategoryID: [String]?
    public var fileType: [String]?
    public var isAcknowledgement: Bool?
    public var isRecent: Bool?
    public var isPinned: Bool?
    public var isGrouped : Bool?
    public var isFavorite : Bool?
    public var from: String?
    public var to: String?
    public var updatedDateFrom: String?
    public var updatedDateTo: String?
    public var categoryId: String?
    public var isActive: Bool?
    
    public init() {}
    
    init(searchKeyword: String?,from: String?,to: String?) {
        self.searchKeyword = searchKeyword
        self.from = from
        self.to = to
    }
}


public struct SuggestionPayload: Codable {
    var searchKeyword: String
}


// MARK: - OrderByValue
public struct OrderByValue: Codable {
    public let colID, sort: String?
    
    enum CodingKeys: String, CodingKey {
        case colID = "colId"
        case sort
    }
    
    public init() {
        self.colID = nil
        self.sort = nil
    }
}

// MARK: - OrderBy

public enum OrderBy: Int {
    case Newest = 1
    case Oldest = 2
    case A_Z = 3
    case Z_A = 4

}
