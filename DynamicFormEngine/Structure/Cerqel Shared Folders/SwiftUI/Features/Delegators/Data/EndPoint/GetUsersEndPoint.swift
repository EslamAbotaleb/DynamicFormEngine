//
//  GetUsersEndPoint.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct GetUsersEndPoint: Endpoint {
   var urlPrefix: String = ""
   var service: EndpointService = .getUsers
   var method: EndpointMethod = .post
   var encoding: EndpointEncoding = .json
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]

    init(payload: GetUsersPayload) {
        parameters = payload.asDictionary()
   }
}
