//
//  BaseResponse.swift
//  chappme
//
//  Created by Ahmed Maher on 9/6/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

public struct BaseUploadResponse<T: Codable>: Codable {
    public let message: String?
    public let result: T
}

public struct BaseResponse<T: Codable>: Codable {
    public let message: String?
    public let result: Result<T>
    
    public init(message: String?, result: Result<T>) {
         self.message = message
         self.result = result
     }
}

public struct BaseResponseWithoutCodable<T> {
    public let message: String?
    public let result: ResultWithoutCodable<T>
    
    public init(message: String?, result: ResultWithoutCodable<T>) {
        self.message = message
        self.result = result
    }
}

public struct BaseSuccessResponse: Codable {
    public let message: String?
    public let success: Bool?
    public let errorCode: String?
}

// MARK: - Result
public struct Result<T: Codable>: Codable {
    public var totalCount: Int?
    public var data:T
    public var pagesCount: Int?
    
    public init(data: T) {
        self.data = data
    }
    
    public init(totalCount: Int?, data: T, pagesCount: Int?) {
        self.totalCount = totalCount
        self.data = data
        self.pagesCount = pagesCount
    }
}

public struct ResultWithoutCodable<T> {
    public var totalCount: Int?
    public var data:T
    public var pagesCount: Int?
    
    public init(totalCount: Int?, data: T, pagesCount: Int?) {
        self.totalCount = totalCount
        self.data = data
        self.pagesCount = pagesCount
    }
}

public struct GeneralPaginateModel<T:Codable> : Codable{
    public var totalCount: Int?
    public var data:T
    public var pagesCount: Int?
}

public struct EmptyModel: Codable {
   
}
