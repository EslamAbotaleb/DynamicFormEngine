//
//  GetAllCategoriesEndPoint.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 26/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

struct GetServicesCategoriesEndPoint: Endpoint {

    var urlPrefix: String = ""
    var service: EndpointService = .getAllServicesCategories
    var method: EndpointMethod = .get
    var encoding: EndpointEncoding = .query
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
}
