//
//  UploadRequestEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 08/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation



 struct UploadEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .upload
    var method: EndpointMethod = .post
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
     var multipart: [DynamicFormEngine.MultiPartModel] {
         []
     }
     
    init(UploadRequest: UploadFileRequest ) {
        parameters = UploadRequest.asDictionary()
        
    }
}

struct UploadUserProfileEndPoint: Endpoint {

   var urlPrefix: String = ""
   var service: EndpointService = .uploadUserProfile
   var method: EndpointMethod = .post
   var encoding: EndpointEncoding = .json
   var auth: AuthorizationHandler = UserAuthoriationHandler()
   var parameters: [String: Any] = [:]
   var headers: [String: String] = [:]
    var multipart: [DynamicFormEngine.MultiPartModel] {
        []
    }
    
   init(UploadRequest: Attachment ) {
       parameters = UploadRequest.asDictionary()

   }
}
