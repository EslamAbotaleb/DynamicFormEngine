//
//  SendBackRecipientsEndPoint.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct SendBackRecipientsEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .SendBackRecipients
    var method: EndpointMethod = .get
    var encoding: EndpointEncoding = .query
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    
    init(id: String) {
        urlPrefix = urlPrefix + "/\(id)"
    }
}
