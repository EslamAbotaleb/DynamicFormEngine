//
//  AllServicesEndPoint.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

struct AllServicesEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .allServices
    var method: EndpointMethod = .post
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    var multipart: [DynamicFormEngine.MultiPartModel]

    init(cerqelFilterPayload: CerqelFilterPayload ) {
        parameters = cerqelFilterPayload.asDictionary()
        multipart = []
    }
}
