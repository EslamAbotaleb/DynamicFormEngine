//
//  FileGlobal.swift
//  CERQEL
//
//  Created by mac on 10/22/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

enum FileVersionType: String {
    case arabic
    case english
}

enum UploadExtension: String {
    case PDF
    case PNG
}

enum FileUploadStatus {
    case new
    case failed
    case inProgress
    case removed
    case uploadBegin
    case uploaded
}

protocol ProfileSectionResponse: Codable { }

// MARK: - Welcome
struct UploadFileRequest: Codable {
    var categoryID: String? = nil
    var subcategoryID: String? = nil
    var description: String? = nil
    var attachmentEn: Attachment? = nil
    var attachmentAr: Attachment? = nil
    var isPublic: Bool? = false
    var serviceType: Int? = 1

    init(categoryID: String? = nil, subcategoryID: String? = nil, description: String? = nil, attachmentEn: Attachment? = nil , attachmentAr: Attachment? = nil, isPublic: Bool? = nil, serviceType: Int? = nil) {
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.description = description
        self.attachmentEn = attachmentEn
        self.attachmentAr = attachmentAr
        self.isPublic = isPublic
        self.serviceType = serviceType
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case subcategoryID = "subcategoryId"
        case description, attachmentEn, attachmentAr
        case isPublic, serviceType
    }
}

// MARK: - Attachment
struct Attachment: Codable,Equatable {
    var attachmentID, attachmentType, attachmentURL, fileID : String?
    var storageFileId : String?
    var attachmentName, attachmentExtension: String?
    var attachmentSize: Double?
    var attachmentDisplaySize : String?
    var fileLange: String?
    var state: AttachmentState? = .old

    enum CodingKeys: String, CodingKey {
        case attachmentID, attachmentType, attachmentURL,storageFileId
        case fileID = "fileId"
        case attachmentName, attachmentExtension, attachmentSize, attachmentDisplaySize, fileLange
        case state
    }
    
}

struct ProfileAttachment: Codable, Equatable {
    let attachmentDisplaySize : String?
    let downloadUrl : String?
    let id : String?
    let contentType : String?
    let documentType : String?
    let isPublic : Bool?
    let fileSize : Double?
    let name : String?
    
    var isDeleted: Bool? = false
    var state: AttachmentState? = .old
}

struct ProfilePicture : Codable, Equatable {
    var mediaId : String? = ""
    var fileName : String? = ""
    var base64File : String? = ""
    var contentType : String? = ""
    var documentType : String? = ""
    var downloadUrl : String? = ""
    var fileSize : String? = ""
    var previewUrl : String? = ""
    var localUrl: URL?
    var disableDeleteIcon : Bool? = false
    var url: String? = ""
    var isDeleted: Bool? = false
    var fromRequest: Bool? = false
    var state: AttachmentState? = .old

    var currentUrl: String? {
        return (fromRequest ?? false) ? self.url ?? localUrl?.absoluteString : base64File
    }
    
    enum CodingKeys: String, CodingKey {
        case isDeleted
        case url
        case fromRequest
        case localUrl
        case mediaId = "mediaId"
        case fileName = "fileName"
        case base64File = "base64File"
        case contentType = "contentType"
        case documentType = "documentType"
        case downloadUrl = "downloadUrl"
        case fileSize = "fileSize"
        case previewUrl = "previewUrl"
        case disableDeleteIcon = "disableDeleteIcon"
    }
    
//    func map(from data: ProfilePicture) -> UploadedCVEntity {
//        return UploadedCVEntity(id: data.mediaId,
//                                name: data.fileName ?? "",
//                                isPublic: true,
//                                documentType: data.documentType ?? "",
//                                contentType: data.contentType ?? "",
//                                downloadUrl: data.downloadUrl ?? "",
//                                previewUrl: data.previewUrl ?? "",
//                                fileSize: data.fileSize ?? "",
//                                objectState: 1)
//    }
    
    public func convertToAttachmentsForm(data: [ProfilePicture]) -> [ProfileAttachment] {
        return data.map { self.mapToAttachment(from: $0) }
    }
    
    func mapToAttachment(from data: ProfilePicture) -> ProfileAttachment {
        return ProfileAttachment(attachmentDisplaySize: data.fileSize,
                                 downloadUrl: data.currentUrl,
                                 id: data.mediaId,
                                 contentType: data.contentType,
                                 documentType: data.documentType,
                                 isPublic: true,
                                 fileSize: Double(data.fileSize ?? "0"),
                                 name: data.fileName,
                                 isDeleted: data.isDeleted,
                                 state: data.state)
    }
}


public enum BottomSheetType : String {
    case radio
    case checkBox
    case action
    case profilePhoneTypes
}

public enum AppState {
    case initial
    case Loading
    case LoadingPagination
    case LoadingRefresh
    case fetched
    case empty
    case error
    case noMoreData
    
    var isBlockingLoad: Bool {
        switch self {
        case .Loading, .LoadingPagination, .noMoreData, .initial:
            return true
        default:
            return false
        }
    }
}

public enum AttachmentState: Codable {
    case old
    case new
}
