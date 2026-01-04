//
//  UserAuthoriationHandler.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
internal import KeychainSwift
internal import Promises

class UserAuthoriationHandler: AuthorizationHandler {
    
    private let keychainKey = "CustomerAuthorizationHandler"
    private let clientKey = "clientAuthoriztionHeader"
    private let uidKey = "uidAuthoriztionHeader"
    private let faceIdPhoneKey = "faceIdPhone"
    private let keychain = KeychainSwift()
    
    public init() {
    }
  
    
    public var clientHeader: [String: String] {
        return ["LanguageCode": isArabicCerqel() ? "Ar" : "En"]
    }
    
    public var uidHeader: [String: String] {
        return ["uid":  (keychain.get(self.uidKey) ?? "")]
    }
    
    public var tokenHeader: [String: String] {

        return ["Authorization": "Bearer " + AuthManagerDynamicForm.shared.token ]
    }
    public  var faceIdPhone: String {
        keychain.get(self.faceIdPhoneKey) ?? ""
    }
    
    public func setAuthManually(authToken: String) {
        self.keychain.set(authToken, forKey: self.keychainKey)
    }
    
    public func setPhoneForFaceId(phone: String){
        self.keychain.set(phone, forKey: self.faceIdPhoneKey)
    }
    
    public func setClientManually(clientType: String) {
        self.keychain.set(clientType, forKey: self.clientKey)
    }
    
    public  func setUidManually(uid: String) {
        self.keychain.set(uid, forKey: self.uidKey)
    }
    public func removeLang(lang: String) {
        self.keychain.set("", forKey: self.keychainKey)
    }
    
    
    public func removeAuthManually(authToken: String) {
        self.keychain.set("", forKey: self.keychainKey)
    }
    
    public func removeClientManually(client: String) {
        self.keychain.set("", forKey: self.clientKey)
    }
    
    public func removeUidManually(uid: String) {
        self.keychain.set("", forKey: self.uidKey)
    }
    
}
