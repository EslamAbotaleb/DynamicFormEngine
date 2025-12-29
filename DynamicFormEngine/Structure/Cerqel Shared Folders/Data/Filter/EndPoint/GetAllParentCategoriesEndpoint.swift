//
//  GetAllParentCategoriesEndpoint.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 02/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

public struct GetAllParentCategoriesEndpoint: Endpoint {
    
    public var urlPrefix: String = ""
    public var service: EndpointService = .serviceCategories
    public var method: EndpointMethod = .get
    public var encoding: EndpointEncoding = .query
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [MultiPartModel] {
        []
    }
}
