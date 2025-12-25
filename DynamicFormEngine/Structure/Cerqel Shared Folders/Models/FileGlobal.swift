//
//  FileGlobal.swift
//  CERQEL
//
//  Created by mac on 10/22/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import DynamicFormEngine

public enum FileVersionType: String {
    case arabic
    case english
}

public enum UploadExtension: String {
    case PDF
    case PNG
}

public enum FileUploadStatus {
    case new
    case failed
    case inProgress
    case removed
    case uploadBegin
    case uploaded
}

public protocol ProfileSectionResponse: Codable { }

// MARK: - Welcome
public struct UploadFileRequest: Codable {
    public var categoryID: String? = nil
    public var subcategoryID: String? = nil
    public var description: String? = nil
    public var attachmentEn: Attachment? = nil
    public var attachmentAr: Attachment? = nil
    public var isPublic: Bool? = false
    public var serviceType: Int? = 1

    public init(categoryID: String? = nil, subcategoryID: String? = nil, description: String? = nil, attachmentEn: Attachment? = nil , attachmentAr: Attachment? = nil, isPublic: Bool? = nil, serviceType: Int? = nil) {
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.description = description
        self.attachmentEn = attachmentEn
        self.attachmentAr = attachmentAr
        self.isPublic = isPublic
        self.serviceType = serviceType
    }
    
    public enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case subcategoryID = "subcategoryId"
        case description, attachmentEn, attachmentAr
        case isPublic, serviceType
    }
}

// MARK: - Attachment
public struct Attachment: Codable,Equatable {
    public var attachmentID, attachmentType, attachmentURL, fileID : String?
    public var storageFileId : String?
    public var attachmentName, attachmentExtension: String?
    public var attachmentSize: Double?
    public var attachmentDisplaySize : String?
    public var fileLange: String?
    public var state: AttachmentState? = .old

    public enum CodingKeys: String, CodingKey {
        case attachmentID, attachmentType, attachmentURL,storageFileId
        case fileID = "fileId"
        case attachmentName, attachmentExtension, attachmentSize, attachmentDisplaySize, fileLange
        case state
    }
    
}

public struct ProfileAttachment: Codable, Equatable {
    public let attachmentDisplaySize : String?
    public let downloadUrl : String?
    public let id : String?
    public let contentType : String?
    public let documentType : String?
    public let isPublic : Bool?
    public let fileSize : Double?
    public let name : String?
    
    public var isDeleted: Bool? = false
    public var state: AttachmentState? = .old
}

public struct EntityDifference {
    public var key: String
    public var oldValue: Any
    public var newValue: Any
    
    public init(key: String, oldValue: Any, newValue: Any) {
        self.key = key
        self.oldValue = oldValue
        self.newValue = newValue
    }
}



public struct Section<T> : ProfileMapper{
    public typealias DTO = Section

    public var id: String?
    public var title: String
    public var isExpanded : Bool = false
    public var entry: T
    public var data: [Entry]

    public init(id: String? = nil,
                 title: String,
                 entry: T,
                 data: [Entry]) {
         self.id = id
         self.title = title
         self.entry = entry
         self.data = data
     }
    
    public init(id: String? = nil,
                 title: String,
                 isExpanded: Bool = false,
                 entry: T,
                 data: [Entry]) {
         self.id = id
         self.title = title
         self.isExpanded = isExpanded
         self.entry = entry
         self.data = data
     }
    
    public func toList() -> [T] {
        return [entry]
    }

    public func isOfType<U>(_ type: U.Type) -> Bool {
        return entry is U
    }

}

extension Section {
    public func toAnySection() -> Section<Any> {
        return Section<Any>(
            id: self.id,
            title: self.title,
            isExpanded: self.isExpanded,
            entry: self.entry as Any,
            data: self.data.map { $0 as Any as! Entry }
        )
    }
}

public protocol ProfileMapper {
    associatedtype DTO: ProfileMapper
    var objectState: Int? { get set }
    var attachments: [ProfileAttachment]? { get set }
    func toDictionary() -> Section<DTO>
    func modifiedFields(comparedTo other: DTO) -> [String: (oldValue: Any, newValue: Any)]
    func modifiedFields(comparedTo other: DTO) -> [EntityDifference]
}


// Default implementations
extension ProfileMapper {

    public func toDictionary() -> Section<DTO> {
        fatalError("toDictionary() has not been implemented")
    }


    public func modifiedFields(comparedTo other: DTO) -> [String: (oldValue: Any, newValue: Any)] {
        fatalError("modifiedFields(comparedTo:) has not been implemented")
    }

    public func modifiedFields(comparedTo other: DTO) -> [EntityDifference] {
        fatalError("modifiedFields(comparedTo:) has not been implemented")
    }

    public var objectState: Int?{
        get {return nil}
        set{}
    }

    public  var attachments: [ProfileAttachment]? {

        get {return nil}
        set{}
    }

}

public enum SummaryState: Int, Codable {
    case old = 0
    case updated = 2
    case added = 1
    case deleted = 3
    case subHeader = 4
}

public struct Entry {
    public var headerTitle: String? = nil
    public var title: String
    public var value: Any
    public var valueForSummary: Any? = nil
    public var state: SummaryState = .old
    
    public init(headerTitle: String? = nil, title: String, value: Any, valueForSummary: Any? = nil, state: SummaryState) {
        self.headerTitle = headerTitle
        self.title = title
        self.value = value
        self.valueForSummary = valueForSummary
        self.state = state
    }
    
    public init(headerTitle: String? = nil, title: String, value: Any) {
        self.headerTitle = headerTitle
        self.title = title
        self.value = value
    }
    
    public init(title: String, value: Any, valueForSummary: Any? = nil) {
        self.title = title
        self.value = value
        self.valueForSummary = valueForSummary
    }
    
    public init(title: String, value: Any) {
        self.title = title
        self.value = value
    }
}

public struct UploadedCVEntity: ProfileMapper, Codable, Equatable {
    public var id: String?
    public var name: String = ""
    public var isPublic: Bool = true
    public var documentType: String = ""
    public var contentType: String = ""
    public var downloadUrl: String = ""
    public var previewUrl: String = ""
    public var fileSize: String = ""
    public var objectState: Int? = 0
    
    public func toDictionary() -> Section<UploadedCVEntity> {
        return Section(id: nil, title: name, entry: UploadedCVEntity(id: id, name: name, isPublic: isPublic, documentType: documentType, contentType: contentType, downloadUrl: downloadUrl, previewUrl: previewUrl, fileSize: fileSize, objectState: objectState), data: [
            Entry(title: "Uploaded CV".localized, value: self)
        ])
    }
    
    public init(id: String? = nil, name: String, isPublic: Bool, documentType: String, contentType: String, downloadUrl: String, previewUrl: String, fileSize: String, objectState: Int? = nil) {
        self.id = id
        self.name = name
        self.isPublic = isPublic
        self.documentType = documentType
        self.contentType = contentType
        self.downloadUrl = downloadUrl
        self.previewUrl = previewUrl
        self.fileSize = fileSize
        self.objectState = objectState
    }
    
    public func modifiedFields(comparedTo other: UploadedCVEntity) -> [String: (oldValue: Any, newValue: Any)] {
        var changes = [String: (oldValue: Any, newValue: Any)]()
        
        
        if self.id != other.id {
            changes["Uploaded CV".localized] = (self.id , other.id )
        }
        return changes
    }
}

public struct ProfilePicture : Codable, Equatable {
    public var mediaId : String? = ""
    public var fileName : String? = ""
    public var base64File : String? = ""
    public var contentType : String? = ""
    public var documentType : String? = ""
    public var downloadUrl : String? = ""
    public var fileSize : String? = ""
    public var previewUrl : String? = ""
    public var localUrl: URL?
    public var disableDeleteIcon : Bool? = false
    public var url: String? = ""
    public var isDeleted: Bool? = false
    public var fromRequest: Bool? = false
    public var state: AttachmentState? = .old

    public var currentUrl: String? {
        return (fromRequest ?? false) ? self.url ?? localUrl?.absoluteString : base64File
    }
    
    public enum CodingKeys: String, CodingKey {
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
    
    public func map(from data: ProfilePicture) -> UploadedCVEntity {
        return UploadedCVEntity(id: data.mediaId,
                                name: data.fileName ?? "",
                                isPublic: true,
                                documentType: data.documentType ?? "",
                                contentType: data.contentType ?? "",
                                downloadUrl: data.downloadUrl ?? "",
                                previewUrl: data.previewUrl ?? "",
                                fileSize: data.fileSize ?? "",
                                objectState: 1)
    }
    
    public func convertToAttachmentsForm(data: [ProfilePicture]) -> [ProfileAttachment] {
        return data.map { self.mapToAttachment(from: $0) }
    }
    
    public func mapToAttachment(from data: ProfilePicture) -> ProfileAttachment {
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
    
    public var isBlockingLoad: Bool {
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
