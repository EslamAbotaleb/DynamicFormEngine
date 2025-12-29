//
//  GetSubCategoryByParentIdEndPoint.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 02/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

// swiftlint:disable all
public struct GetSubCategoryByParentIdEndPoint: Endpoint {

    public var urlPrefix: String = ""
    public var service: EndpointService = .serviceSubCategories
    public var method: EndpointMethod = .get
    public var encoding: EndpointEncoding = .query
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [MultiPartModel]

    public init(parentCategoryId: String) {
        urlPrefix  = urlPrefix + "?parentCategoryId=\(parentCategoryId)"
        multipart = []
    }
}
// swiftlint:enable all
