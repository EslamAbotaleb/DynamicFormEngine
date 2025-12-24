//
//  ExcuteActionEndPoint.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct ExcuteActionEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .excuteAction
    var method: EndpointMethod = .post
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
    
    init(payload: ExcuteActionPayload) {
        parameters = payload.asDictionary()
    }
}
