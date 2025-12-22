//
//  CategoriesWithChildrenEndpoint.swift
//  CERQEL
//
//  Created by ahmed maher on 23/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
struct CategoriesWithChildrensEndpoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .categoriesWithChildrens
    var method: EndpointMethod = .get
    var encoding: EndpointEncoding = .query
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
}
