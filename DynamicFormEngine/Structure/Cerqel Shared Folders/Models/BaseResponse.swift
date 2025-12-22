//
//  BaseResponse.swift
//  chappme
//
//  Created by Ahmed Maher on 9/6/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

struct BaseUploadResponse<T: Codable>: Codable {
    let message: String?
    let result: T
    
}

struct BaseResponse<T: Codable>: Codable {
    let message: String?
    let result: Result<T>
    
}

struct BaseResponseWithoutCodable<T> {
    let message: String?
    let result: ResultWithoutCodable<T>
    
}

struct BaseSuccessResponse: Codable {
    let message: String?
    let success: Bool?
    let errorCode: String?
}

// MARK: - Result
struct Result<T: Codable>: Codable {
    var totalCount: Int?
    var data:T
    var pagesCount: Int?
  
}

struct ResultWithoutCodable<T> {
    var totalCount: Int?
    var data:T
    var pagesCount: Int?
  
}

struct GeneralPaginateModel<T:Codable> : Codable{
    var totalCount: Int?
    var data:T
    var pagesCount: Int?
}
struct EmptyModel: Codable {
   
}
