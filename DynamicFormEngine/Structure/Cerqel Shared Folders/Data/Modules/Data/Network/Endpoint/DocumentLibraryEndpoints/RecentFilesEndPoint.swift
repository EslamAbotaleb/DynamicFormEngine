//
//  RecentFilesEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 27/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct recentFilesEndPoint: Endpoint {
   
    public var urlPrefix: String = ""
    public var service: EndpointService = .recentFiles
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public  var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
    
    public init(cerqelFilterPayload: CerqelFilterPayload ) {
       parameters = cerqelFilterPayload.asDictionary()
       
   }
}
 
