//
//  GuestAuthorization.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//


import Foundation
internal import Promises

class NoneAuthorizationHandler: AuthorizationHandler {
    public func setClientManually(clientType: String) {}
    public func setUidManually(uid: String) {}
    public func setAuthManually(authToken: String) {}
    public func setPhoneForFaceId(phone: String){}
    public var tokenHeader: [String: String] = [:]
    public var clientHeader: [String: String] = [:]
    public var uidHeader: [String: String] = [:]
    public var faceIdPhone: String = ""
    public func removeAuthManually(authToken: String){}
    public func removeClientManually(client: String){}
    public func removeUidManually(uid: String){}
}
