//
//  UserAuthoriationHandler.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//


import Foundation
import KeychainSwift
import Promises



class UserAuthoriationHandler: AuthorizationHandler {
    
    private let keychainKey = "CustomerAuthorizationHandler"
    private let clientKey = "clientAuthoriztionHeader"
    private let uidKey = "uidAuthoriztionHeader"
    private let faceIdPhoneKey = "faceIdPhone"
    private let keychain = KeychainSwift()
    
    init() {
    }
  
    
    var clientHeader: [String: String] {
        return ["LanguageCode": isArabicCerqel() ? "Ar" : "En"]
    }
    
    var uidHeader: [String: String] {
        return ["uid":  (keychain.get(self.uidKey) ?? "")]
    }
    
    var tokenHeader: [String: String] {

        return ["Authorization": "Bearer " + AuthManager.shared.token ]
    }
    var faceIdPhone: String {
        keychain.get(self.faceIdPhoneKey) ?? ""
    }
    
    func setAuthManually(authToken: String) {
        self.keychain.set(authToken, forKey: self.keychainKey)
    }
    
    func setPhoneForFaceId(phone: String){
        self.keychain.set(phone, forKey: self.faceIdPhoneKey)
    }
    
    func setClientManually(clientType: String) {
        self.keychain.set(clientType, forKey: self.clientKey)
    }
    
    func setUidManually(uid: String) {
        self.keychain.set(uid, forKey: self.uidKey)
    }
    func removeLang(lang: String) {
        self.keychain.set("", forKey: self.keychainKey)
    }
    
    
    func removeAuthManually(authToken: String) {
        self.keychain.set("", forKey: self.keychainKey)
    }
    
    func removeClientManually(client: String) {
        self.keychain.set("", forKey: self.clientKey)
    }
    
    func removeUidManually(uid: String) {
        self.keychain.set("", forKey: self.uidKey)
    }
    
}
