//
//  AddToFavouriteEndPoint.swift
//  CERQEL
//
//  Created by Youxel on 31/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

struct AddServiceToFavouriteEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .addServiceToFavourite
    var method: EndpointMethod = .post
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    var multipart: [DynamicFormEngine.MultiPartModel]

    init(addToFavouritePayload: AddToFavouritePayload) {
        parameters = addToFavouritePayload.asDictionary()
        multipart = []
    }
}
