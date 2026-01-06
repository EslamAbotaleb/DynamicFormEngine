//
//  UploadRequestEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 08/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

struct UploadEndPoint: Endpoint {
    
    public var urlPrefix: String = ""
    public var service: EndpointService = .upload
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [DynamicFormEngine.MultiPartModel] {
         []
     }
     
    public init(UploadRequest: UploadFileRequest ) {
        parameters = UploadRequest.asDictionary()
        
    }
}

struct UploadUserProfileEndPoint: Endpoint {

    public var urlPrefix: String = ""
    public var service: EndpointService = .uploadUserProfile
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
    
    public init(UploadRequest: Attachment ) {
       parameters = UploadRequest.asDictionary()

   }
}
