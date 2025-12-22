//
//  ModelUploadedMedia.swift
// 
//
//  Created by iSlam AbdelAziz on 2/20/21.
//  Copyright © 2021 All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

public struct ModelUploadedMedia : Mappable, Codable, FormValue {

    var downloadUrl: String?
    var previewUrl: String?
    var viewImage: UIImage?
    var contentType: String?
    var documentType: String?
    var fileSize: String?
    var id: String?
    var isPublic: Bool?
    var name: String?
    var isStillUploading: Bool = false
    var additionalProperty01: AdditionalProperty?
    var additionalProperty02: AdditionalProperty?
    var additionalProperty03: AdditionalProperty?
    var additionalProperty04: AdditionalProperty?
    
    enum CodingKeys: String, CodingKey {
        case contentType
        case documentType
        case fileSize
        case id
        case isPublic
        case name
        case additionalProperty01
        case additionalProperty02
        case additionalProperty03
        case additionalProperty04
        case downloadUrl
        case previewUrl
    }
    
    init(downloadUrl: String? = nil,
         previewUrl: String? = nil,
         viewImage: UIImage? = nil,
         contentType: String? = nil,
         documentType: String? = nil,
         fileSize: String? = nil,
         id: String? = nil,
         isPublic: Bool? = nil,
         name: String? = nil,
         isStillUploading: Bool = false,
         additionalProperty01: AdditionalProperty? = nil,
         additionalProperty02: AdditionalProperty? = nil,
         additionalProperty03: AdditionalProperty? = nil,
         additionalProperty04: AdditionalProperty? = nil) {
        
        self.downloadUrl = downloadUrl
        self.previewUrl = previewUrl
        self.viewImage = viewImage
        self.contentType = contentType
        self.documentType = documentType
        self.fileSize = fileSize
        self.id = id
        self.isPublic = isPublic
        self.name = name
        self.isStillUploading = isStillUploading
        self.additionalProperty01 = additionalProperty01
        self.additionalProperty02 = additionalProperty02
        self.additionalProperty03 = additionalProperty03
        self.additionalProperty04 = additionalProperty04
    }
    
    // Implementations for Mappable protocol
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        contentType <- map["contentType"]
        documentType <- map["documentType"]
        fileSize <- map["fileSize"]
        id <- map["id"]
        isPublic <- map["isPublic"]
        name <- map["name"]
        additionalProperty01 <- map["additionalProperty01"]
        additionalProperty02 <- map["additionalProperty02"]
        additionalProperty03 <- map["additionalProperty03"]
        additionalProperty04 <- map["additionalProperty04"]
        downloadUrl <- map["downloadUrl"]
        previewUrl <- map["previewUrl"]
    }
}



struct ModelUploadedMediaFormPayload : Mappable, Codable, FormValue {
//    var rowIndex : String?
//    var parentId : String?
    var downloadUrl : String?
    var previewUrl : String?
    var fileId : String?
    var isPublic : Bool?
    var isSuccess : Bool?
    var fileName: String?
    var size: String?
    var url: String?
    var fileUrl: String?
    var fileExt: String?
    var attachmentDisplaySize: String?
    var additionalProperty01: String?
    var additionalProperty02: String?
    var additionalProperty03: String?
    var additionalProperty04: String?

    enum CodingKeys: String, CodingKey {
//        case /*rowIndex,*/ parentId
        case fileId
        case isPublic
        case isSuccess
        case fileName
        case size
        case url
        case fileUrl
        case fileExt = "extension"
        case attachmentDisplaySize
        case additionalProperty01
        case additionalProperty02
        case additionalProperty03
        case additionalProperty04
        case downloadUrl, previewUrl
    }


    init(){}
    
    public init(item: ModelUploadedMedia/*, parentId: String, rowIndex: String?*/){
//        self.rowIndex = rowIndex
//        self.parentId = parentId
        fileId = item.id
        isPublic = item.isPublic
        isSuccess = true
        fileName = item.name
        size = item.fileSize
        fileExt = item.documentType
        attachmentDisplaySize = ""
        url = "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Preview/\(item.id!)"
        fileUrl = "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Preview/\(item.id!)"
        additionalProperty01 = item.additionalProperty01?.value
        additionalProperty02 = item.additionalProperty02?.value
        additionalProperty03 = item.additionalProperty03?.value
        additionalProperty04 = item.additionalProperty04?.value
        downloadUrl = item.downloadUrl
        previewUrl = item.previewUrl
        
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        fileId <- map["attachmentId"]
        fileName <- map["attachmentName"]
        fileExt <- map["attachmentExtension"]
        
        isPublic <- map["isPublic"]
        isSuccess <- map["isSuccess"]
        size <- map["size"]
        url <- map["url"]
        fileUrl <- map["fileUrl"]
        attachmentDisplaySize <- map["attachmentDisplaySize"]
        additionalProperty01 <- map["additionalProperty01"]
        additionalProperty02 <- map["additionalProperty02"]
        additionalProperty03 <- map["additionalProperty03"]
        additionalProperty04 <- map["additionalProperty04"]
        downloadUrl <- map["downloadUrl"]
        previewUrl <- map["previewUrl"]
        
//        rowIndex <- map["rowIndex"]
//        parentId <- map["parentId"]
    }
}

struct ModelUploadedMediaFormPayloadForSummary : Mappable, Codable, FormValue {
    var fileId : String?
    var fileName: String?
    var fileExt: String?

    enum CodingKeys: String, CodingKey {
        case fileId
        case fileName
        case fileExt = "extension"
    }


    init(){}
    
    public init(item: ModelUploadedMedia){
        fileId = item.id
        fileName = item.name
        fileExt = item.documentType
    }
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        fileId <- map["attachmentId"]
        fileName <- map["attachmentName"]
        fileExt <- map["attachmentExtension"]
    }
}
