//
//  BaseError.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

enum BaseError: Error {
    
    case authLogin
    case authMobileNumber
    case authCodeError
    case authEmptyName
    case authNameCount
    case authMailCount
    case authProduct
    case decodeResponse
    case timeOut
    case serverError
    case NoInternet
    case SelectionRequired

    case locationSaveError
    
    case orderError
    case YouMustSelectBusinessType
    
    case none
    case other(title:String)
    
    case UserNameRequiredError
    case PasswordRequiredError
    case userPassRequiredError
    case notValidateURL
}

extension BaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .authProduct:
            return "LoginToFavorite".localized
        case .authMobileNumber:
            return "Invalid Mobile Number".localized
        case .authLogin:
            return "".localized
        case .orderError:
            return "OrderError".localized
        case .none:
            return ""
        case .other(let title):
            return title
        case .decodeResponse:
            return "Receiving unknown response from server .".localized
        case .authEmptyName:
            return "AuthEmptyName".localized
        case .authNameCount:
            return "AuthNameCount".localized
        case .authMailCount:
            return "AuthMailCount".localized
        case .authCodeError:
            return "AuthWrongCode".localized
        case .timeOut:
            return  "The request was slow and timed out. ".localized
        case .serverError:
            return "Internal server error. No information available.".localized
        case .NoInternet:
            return "NoInternet".localized
        case .locationSaveError:
            return "Error in saving location"
        case .SelectionRequired:
            return "You Must Select One".localized
        case .YouMustSelectBusinessType:
            return "You Must Select Business Type".localized
        case .UserNameRequiredError:
            return "Please enter your user name".localized
        case .PasswordRequiredError:
            return "Please enter Password".localized
        case .userPassRequiredError:
            return "please enter the username and password".localized
        case .notValidateURL:
            return "Can't open this url".localized
        }
    }
}
