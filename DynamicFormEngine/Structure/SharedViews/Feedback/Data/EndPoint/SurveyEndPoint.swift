//
//  SurveyEndPoint.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 21/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

public struct SurveyEndPoint: Endpoint {
    public var urlPrefix: String = ""
    public var service: EndpointService = .survey
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [DynamicFormEngine.MultiPartModel]

    public init(surveyPayload: SurveyPayload) {
        parameters = surveyPayload.asDictionary()
        multipart = []
    }
}


public struct SurveyPayload: Codable {
    public var serviceId: String?
    public var rating: Int?
    public var comment: String?
    
    public init() {}
    public init(serviceId: String? = nil, rating: Int? = nil, comment: String? = nil) {
        self.serviceId = serviceId
        self.rating = rating
        self.comment = comment
    }
}
