//
//  AcknowledgeendPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 05/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct AcknowledgEndPoint: Endpoint {
   
   var urlPrefix: String = ""
   var service: EndpointService = .acknowledge
   var method: EndpointMethod = .patch
   var encoding: EndpointEncoding = .json
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]
    var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
    
    init(fileId: String) {
        urlPrefix  = urlPrefix + "\(fileId)"

    }
}
