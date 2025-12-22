//
//  ReportListEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 04/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct ReportListEndPoint: Endpoint {
   
   var urlPrefix: String = ""
   var service: EndpointService = .reportList
   var method: EndpointMethod = .get
   var encoding: EndpointEncoding = .query
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]
   
 
}
 
