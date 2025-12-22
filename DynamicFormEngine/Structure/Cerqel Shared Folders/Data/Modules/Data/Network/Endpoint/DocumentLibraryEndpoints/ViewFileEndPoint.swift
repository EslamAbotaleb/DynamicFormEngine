//
//  ViewFileEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 20/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
struct ViewFileEndPoint: Endpoint {
   var urlPrefix: String = ""
   var service: EndpointService = .view
   var method: EndpointMethod = .get
   var encoding: EndpointEncoding = .query
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]
   
    init(fileId: String) {
        urlPrefix  = urlPrefix + "\(fileId)"

    }
}
