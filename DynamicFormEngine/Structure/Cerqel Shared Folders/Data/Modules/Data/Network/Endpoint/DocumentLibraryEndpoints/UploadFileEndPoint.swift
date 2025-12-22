//
//  UploadFileEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 07/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation


struct GeneralUploadEndPoint: Endpoint {
    
    var urlPrefix: String = ""
    var service: EndpointService = .generalUploadFile
    var method: EndpointMethod = .post
    var encoding: EndpointEncoding = .json
    var auth: AuthorizationHandler = UserAuthoriationHandler()
    var parameters: [String: Any] = [:]
    var headers: [String: String] = [:]
    

    init(fileEntity: FileEntity, fromProfile: Bool) {
        if let serviceType = fileEntity.serviceType, !fromProfile {
            urlPrefix = urlPrefix + "0?isPublic=false&serviceType=\(serviceType)"
        } else {
            urlPrefix = urlPrefix + "0?isPublic=true"
        }
        parameters["extension"] = fileEntity.uploadExtension
        parameters["files"] = fileEntity.file
        parameters["fileVersion"] = fileEntity.FileType
    }
}

enum FileVersion: String{
    case arabic = "arabic"
    case english = "english"
}

struct FileRequest {
    var date: Data
    var fileName: String
    var extenstion : FileType
}

struct FileEntity {
    var uploadExtension: FileType
    var file: FileRequest
    var FileType: FileVersionType
    var isPublic: Bool
    var serviceType: Int?
}
