//
//  RecentFilesEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 27/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct recentFilesEndPoint: Endpoint {
   
   var urlPrefix: String = ""
   var service: EndpointService = .recentFiles
   var method: EndpointMethod = .post
   var encoding: EndpointEncoding = .json
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]
   
    init(cerqelFilterPayload: CerqelFilterPayload ) {
       parameters = cerqelFilterPayload.asDictionary()
       
   }
}
 
