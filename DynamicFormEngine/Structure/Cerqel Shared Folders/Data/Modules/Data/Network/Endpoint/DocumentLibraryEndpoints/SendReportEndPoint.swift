//
//  SendReportEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 04/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct SendReportEndPoint: Endpoint {
   
    public var urlPrefix: String = ""
    public var service: EndpointService = .sendReport
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [MultiPartModel] {
        []
    }
    
    public init(reportRequest: ReportRequest ) {
        urlPrefix  = urlPrefix + "/\(reportRequest.fileId)"
        parameters["reason"] = reportRequest.reason.asDictionary()
       
   }
}


public struct ReportRequest: Codable {
    public var fileId: String
    public var reason: ReasonRequest
    public init(fileId: String, reason: ReasonRequest) {
        self.fileId = fileId
        self.reason = reason
    }
 
}
public struct ReasonRequest: Codable {
    public var id: String
    public var reasonMessage: String
    public init(id: String, reasonMessage: String) {
        self.id = id
        self.reasonMessage = reasonMessage
    }
}
