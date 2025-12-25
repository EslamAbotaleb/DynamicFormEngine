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
    public init(
        pageNumber: Int? = nil,
        pageSize: Int? = nil,
        filter: Filter? = nil,
        SearchKeyword: String? = nil,
        from: String? = nil,
        to: String? = nil,
        isAcknowledgement: Bool? = nil,
        isPinned: Bool? = nil,
        categoriesIds: [String]? = nil,
        subCategoriesIds: [String]? = nil,
        fileTypesIds: [String]? = nil,
        toggles: [[String: Bool]]? = nil,
        orderByValue: [OrderByValue]? = nil,
        orderBy: Int? = nil) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.filter = filter
        self.SearchKeyword = SearchKeyword
        self.from = from
        self.to = to
        self.isAcknowledgement = isAcknowledgement
        self.isPinned = isPinned
        self.categoriesIds = categoriesIds
        self.subCategoriesIds = subCategoriesIds
        self.fileTypesIds = fileTypesIds
        self.toggles = toggles
        self.orderByValue = orderByValue
        self.orderBy = orderBy
    }
    public init(
        pageNumber: Int? = nil,
        pageSize: Int? = nil,
        filter: Filter? = nil,
        SearchKeyword: String? = nil,
        from: String? = nil,
        to: String? = nil,
        isAcknowledgement: Bool? = nil,
//        isPinned: Bool? = nil,
        categoriesIds: [String]? = nil,
        subCategoriesIds: [String]? = nil,
        fileTypesIds: [String]? = nil,
        toggles: [[String: Bool]]? = nil,
        orderByValue: [OrderByValue]? = nil,
        orderBy: Int? = nil) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.filter = filter
        self.SearchKeyword = SearchKeyword
        self.from = from
        self.to = to
        self.isAcknowledgement = isAcknowledgement
//        self.isPinned = isPinned
        self.categoriesIds = categoriesIds
        self.subCategoriesIds = subCategoriesIds
        self.fileTypesIds = fileTypesIds
        self.toggles = toggles
        self.orderByValue = orderByValue
        self.orderBy = orderBy
    }
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
    
    public init(searchKeyword: String?,from: String?,to: String?) {
        self.searchKeyword = searchKeyword
        self.from = from
        self.to = to
    }
  
    
    public init(isPinned: Bool?) {
        self.isPinned = isPinned
    }
    
    public init(subCategoryID: [String]?) {
        self.subCategoryID = subCategoryID
    }
    
    public init(
          searchKeyword: String?,
          categoryID: [String]?,
          subCategoryID: [String]?,
          fileType: [String]?,
          isAcknowledgement: Bool?,
          isPinned: Bool?,
          isFavorite: Bool?,
          updatedDateFrom: String?,
          updatedDateTo: String?
      ) {
          self.searchKeyword = searchKeyword
          self.categoryID = categoryID
          self.subCategoryID = subCategoryID
          self.fileType = fileType
          self.isAcknowledgement = isAcknowledgement
          self.isPinned = isPinned
          self.isFavorite = isFavorite
          self.updatedDateFrom = updatedDateFrom
          self.updatedDateTo = updatedDateTo
      }
    
    public init(
          searchKeyword: String?,
          categoryID: [String]?,
          subCategoryID: [String]?,
          fileType: [String]?,
          isAcknowledgement: Bool?,
          isPinned: Bool?,
          updatedDateFrom: String?,
          updatedDateTo: String?
      ) {
          self.searchKeyword = searchKeyword
          self.categoryID = categoryID
          self.subCategoryID = subCategoryID
          self.fileType = fileType
          self.isAcknowledgement = isAcknowledgement
          self.isPinned = isPinned
          self.updatedDateFrom = updatedDateFrom
          self.updatedDateTo = updatedDateTo
      }
    public init(
          searchKeyword: String?,
          categoryID: [String]?,
          subCategoryID: [String]?,
          fileType: [String]?,
          isAcknowledgement: Bool?,
          isFavorite: Bool?,
          updatedDateFrom: String?,
          updatedDateTo: String?
      ) {
          self.searchKeyword = searchKeyword
          self.categoryID = categoryID
          self.subCategoryID = subCategoryID
          self.fileType = fileType
          self.isAcknowledgement = isAcknowledgement
          self.isFavorite = isFavorite
          self.updatedDateFrom = updatedDateFrom
          self.updatedDateTo = updatedDateTo
      }
    
    public init(
          searchKeyword: String?,
          categoryID: [String]?,
          subCategoryID: [String]?,
          fileType: [String]?,
          isAcknowledgement: Bool?,
          updatedDateFrom: String?,
          updatedDateTo: String?
      ) {
          self.searchKeyword = searchKeyword
          self.categoryID = categoryID
          self.subCategoryID = subCategoryID
          self.fileType = fileType
          self.isAcknowledgement = isAcknowledgement
          self.updatedDateFrom = updatedDateFrom
          self.updatedDateTo = updatedDateTo
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
    
    public init(colID: String?, sort: String?) {
        self.colID = colID
        self.sort = sort
    }
}

// MARK: - OrderBy

public enum OrderBy: Int {
    case Newest = 1
    case Oldest = 2
    case A_Z = 3
    case Z_A = 4

}
