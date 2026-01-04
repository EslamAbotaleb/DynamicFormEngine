//
//  UploadFileEndPoint.swift
//  CERQEL
//
//  Created by ahmed maher on 07/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct GeneralUploadEndPoint: Endpoint {
    
    public var urlPrefix: String = ""
    public var service: EndpointService = .generalUploadFile
    public var method: EndpointMethod = .post
    public var encoding: EndpointEncoding = .json
    public var auth: AuthorizationHandler = UserAuthoriationHandler()
    public var parameters: [String: Any] = [:]
    public var headers: [String: String] = [:]
    public var multipart: [MultiPartModel] {
        []
    }

    public init(fileEntity: FileEntity, fromProfile: Bool) {
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

public enum FileVersion: String{
    case arabic = "arabic"
    case english = "english"
}

public struct FileRequest {
    public var date: Data
    public var fileName: String
    public var extenstion : FileType
    
    public init(date: Data, fileName: String, extenstion: FileType) {
        self.date = date
        self.fileName = fileName
        self.extenstion = extenstion
    }
}

public struct FileEntity {
    public var uploadExtension: FileType
    public var file: FileRequest
    public var FileType: FileVersionType
    public var isPublic: Bool
    public var serviceType: Int?
 
    public init(uploadExtension: FileType, file: FileRequest, FileType: FileVersionType, isPublic: Bool, serviceType: Int? = nil) {
        self.uploadExtension = uploadExtension
        self.file = file
        self.FileType = FileType
        self.isPublic = isPublic
        self.serviceType = serviceType
    }
}
