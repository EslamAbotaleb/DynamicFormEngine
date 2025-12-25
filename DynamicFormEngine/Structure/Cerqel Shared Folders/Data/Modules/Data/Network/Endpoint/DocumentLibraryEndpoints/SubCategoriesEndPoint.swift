//
//  SubCategoriesEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 06/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct SubCategoriesEndPoint: Endpoint {
    
    public var urlPrefix: String = ""
    public var service: EndpointService = .subCategories(categoryId: "")
    public var method: EndpointMethod = .get
    public var encoding: EndpointEncoding = .query
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
    
    public init(categoryId: String) {
        urlPrefix  = urlPrefix + "\(categoryId)"

    }
}
