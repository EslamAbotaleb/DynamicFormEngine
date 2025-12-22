//
//  NetworkErrorHandling.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

struct ServerError: Codable, Error, LocalizedError {
  
    var error: ErrorValue?
    var message: String? = ""
    var status: Int?

    init(message: String = "Something went wrong, please try again later".localized,status: Int = 200) {
        self.message = message
        self.status = status
    }

    struct ErrorValue : Codable {
        var errorAsString : String?
        var errorAsList : [String]?
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let x = try? container.decode(String.self){
                self.errorAsString = x
                return
            }else if let x = try? container.decode([String].self){
                self.errorAsList = x
                return
            }
            throw DecodingError.typeMismatch(ErrorValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "wrong"))
        }
    }
    
    public var errorDescription: String? {
        if error?.errorAsString ?? "" != "" {
            return error?.errorAsString ?? ""
        }
        guard error?.errorAsList?.count ?? 0 > 0 else {
            return message
        }
        return error?.errorAsList?[0]
    }

}

struct NoInternetConnectionError: Error, LocalizedError {
    public var errorDescription: String? {
        return "Please check your internet connection"
    }
}

struct FailToCallNetworkError: Error, LocalizedError {
    public var errorDescription: String? {
        return "Something went wrong, please try again later".localized
    }
}

struct FailToMapResponseError: Error, LocalizedError {
    init(data: Data) {
        print("😱😱 FailToMapResponse: ", String(describing: String(data: data, encoding: String.Encoding.utf8)))
    }
    public var errorDescription: String? {
        return "Something went wrong, please try again later".localized
    }
}
