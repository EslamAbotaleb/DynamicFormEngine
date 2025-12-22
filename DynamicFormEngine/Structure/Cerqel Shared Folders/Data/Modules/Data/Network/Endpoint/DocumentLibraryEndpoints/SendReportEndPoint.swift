//
//  SendReportEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 04/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct SendReportEndPoint: Endpoint {
   
   var urlPrefix: String = ""
   var service: EndpointService = .sendReport
   var method: EndpointMethod = .post
   var encoding: EndpointEncoding = .json
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]
   
    init(reportRequest: ReportRequest ) {
        urlPrefix  = urlPrefix + "/\(reportRequest.fileId)" 
        parameters["reason"] = reportRequest.reason.asDictionary()
       
   }
}


struct ReportRequest: Codable {
    var fileId: String
    var reason: ReasonRequest
 
}
struct ReasonRequest: Codable {
    var id: String
    var reasonMessage: String
 
}

