//
//  FileModel.swift
//  CERQEL
//
//  Created by ahmed maher on 10/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public enum FileViewLayout: String {
    case defaultLayout
    case gridLayout
}

public enum FileStatus: String {
    case acknowledged
    case needAcknowledge
}

public struct FileAcknowledgeStatus {
    public var title: String
    public var color: String
    public var isAcknowledge: Bool = false
    public var isAcknowledged: Bool = false
    public init(title: String, color: String, isAcknowledge: Bool, isAcknowledged: Bool) {
        self.title = title
        self.color = color
        self.isAcknowledge = isAcknowledge
        self.isAcknowledged = isAcknowledged
    }
    
    public init(title: String, color: String) {
        self.title = title
        self.color = color
    }
}

// MARK: - DataClass
public struct FileAcknowledgeResponse: Codable {
    public let fileID, acknowledgeColor, acknowledgeTitle: String
    
    public enum CodingKeys: String, CodingKey {
        case fileID = "fileId"
        case acknowledgeColor, acknowledgeTitle
    }
}

public enum FileType:  String {
    case doc
    case DOC
    case docx
    case DOCX
    case pdf
    case PDF
    case ppt
    case PPT
    case pptx
    case PPTX
    case xls
    case XLS
    case xlsx
    case XLSX
    case jpg
    case svg
    case mp4
    case png
    case MP4
    case PNG
    case jpeg
}



public struct FileModel {
    public var id: String
    public var title: String
    public var versionType: String
    public var versionId: Int
    public var fileSize: String
    public var fileExtension: String
    public var fileCreatedDate: String
    public var isPinned: Bool
    public var localFileUrl: URL?
    public var fileURl: String
    public var fileType: FileType
    public var subCategory: SubCategoryModel
    public var fileAcknowledgeStatus: FileAcknowledgeStatus
    public var fileCheckbox: FileCheckBox
    public var fileUrlAr: String
    public var fileUrlEn: String
    
    public init(id: String, title: String, versionType: String, versionId: Int, fileSize: String, fileExtension: String, fileCreatedDate: String, isPinned: Bool, localFileUrl: URL? = nil, fileURl: String, fileType: FileType, subCategory: SubCategoryModel, fileAcknowledgeStatus: FileAcknowledgeStatus, fileCheckbox: FileCheckBox, fileUrlAr: String, fileUrlEn: String) {
        self.id = id
        self.title = title
        self.versionType = versionType
        self.versionId = versionId
        self.fileSize = fileSize
        self.fileExtension = fileExtension
        self.fileCreatedDate = fileCreatedDate
        self.isPinned = isPinned
        self.localFileUrl = localFileUrl
        self.fileURl = fileURl
        self.fileType = fileType
        self.subCategory = subCategory
        self.fileAcknowledgeStatus = fileAcknowledgeStatus
        self.fileCheckbox = fileCheckbox
        self.fileUrlAr = fileUrlAr
        self.fileUrlEn = fileUrlEn
    }
    
    public init (id: String = "",fileURl: String, name : String = "", fileExtension : String = "") {
        self.id = id
        self.title = name
        self.versionType = ""
        self.versionId = 1
        self.fileSize = ""
        self.fileExtension = fileExtension
        self.fileCreatedDate = ""
        self.isPinned = false
        self.localFileUrl = nil
        self.fileURl = fileURl
        self.fileType = .pdf
        self.subCategory = SubCategoryModel(id: "", name: "", category: CategoryModel())
        self.fileAcknowledgeStatus = FileAcknowledgeStatus(title: "", color: "")
        self.fileCheckbox = FileCheckBox()
        self.fileUrlAr = ""
        self.fileUrlEn = ""
    }
    
}

public struct FileCheckBox {
    public var isSelected: Bool = false
    public var isAppear: Bool = false
    
    public init() {}
    
    public init(isSelected: Bool, isAppear: Bool) {
        self.isSelected = isSelected
        self.isAppear = isAppear
    }
}

public struct File {
    
    public var fileName: String?
    public var fileExtension: String?
    public var url: URL?
    public var fileInformation:FileInformation?
    public var data:Data?
    public var progress:Double?
    public var fileStatus: FileUploadStatus
    public var attachment: Attachment?
    public var profileAttachment: ProfilePicture?
    
    public init(fileName: String = "",fileExtension: String = "" ,url: URL? = nil, fileInformation: FileInformation? = nil, data: Data? = nil, progress: Double? = nil, fileStatus: FileUploadStatus, attachment: Attachment? = nil, profileAttachment: ProfilePicture? = nil) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.url = url
        self.fileInformation = fileInformation
        self.data = data
        self.progress = progress
        self.fileStatus = fileStatus
        self.attachment = attachment
        self.profileAttachment = profileAttachment
    }

    public init() {
        self.fileName = ""
        self.fileExtension = ""
        self.url = URL(fileURLWithPath: "")
        self.data = Data()
        self.progress = 0.0
        self.fileStatus = .new
        self.attachment = nil
        self.fileInformation = nil
        self.profileAttachment = nil
    }
}
public struct FileInformation {
    public var fileName: String?
    public var fileExtension: FileType?
    public var fileVersionType: FileVersionType
    
    public init(fileName: String? = nil, fileExtension: FileType? = nil, fileVersionType: FileVersionType) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.fileVersionType = fileVersionType
    }
    
    public init() {
        self.fileName = ""
        self.fileExtension = .pdf
        self.fileVersionType = .english
    }
}
// MARK: - Datum
public struct FileDTO : Codable {
    public let files: [FileResponse]
    public let highlightedFilters: HighlightedFilters?
}

public struct HighlightedFilters: Codable {
    public let highlightedCategories, highlightedTypes: [Highlighted]?
}

public struct Highlighted: Codable {
    public let value: String
    public let highlightedSubcategories: [HighlightedValue]?
}

public struct HighlightedValue: Codable {
    public let value: String
}

public struct FileResponse: Codable {
    
    public let attachmentEn: Attachment
    public let dateCreated: String
    
    public var isPinned: Bool
    public var isAcknowledged: Bool
    public var isAcknowledgement: Bool
    public var acknowledgementColor: String
    public var acknowledgementTitle: String
    public let viewDate: String?
    public let dateModified, categoryName, categoryID: String
    public let version, subCategoryID, name: String
    public let subCategoryName, id: String
    public let versionId: Int
    public let attachmentAr: Attachment
    
    enum CodingKeys: String, CodingKey {
        case isAcknowledgement,isAcknowledged, attachmentEn, dateCreated, isPinned, dateModified, categoryName,acknowledgementColor,acknowledgementTitle
        case categoryID = "categoryId"
        case version,viewDate
        case subCategoryID = "subCategoryId"
        case  name, subCategoryName, id, attachmentAr,versionId
    }
    
    private func fileVersion()-> String {
        return version
    }
    
    private func getDate()-> String {
        return viewDate != nil ? viewDate ?? "" : dateModified
    }
  
    public func toFileModel() -> FileModel {
        return  isArabicCerqel() ? FileModel(id: id, title: attachmentAr.attachmentName ?? "", versionType: fileVersion(), versionId: versionId,fileSize: attachmentAr.attachmentDisplaySize ?? "", fileExtension: attachmentAr.attachmentExtension ?? "", fileCreatedDate: getDate(), isPinned: isPinned, fileURl: attachmentAr.attachmentURL ?? "", fileType: FileType(rawValue:attachmentAr.attachmentExtension ?? "") ?? .pdf, subCategory: SubCategoryModel(id: subCategoryID, name: subCategoryName, category: CategoryModel(id: categoryID, name: categoryName)), fileAcknowledgeStatus: FileAcknowledgeStatus(title: acknowledgementTitle, color: acknowledgementColor, isAcknowledge: isAcknowledgement,isAcknowledged: isAcknowledged) , fileCheckbox: FileCheckBox(),fileUrlAr:attachmentAr.attachmentURL ?? "",fileUrlEn: attachmentEn.attachmentURL ?? "")
        :
        FileModel(id: id, title: attachmentEn.attachmentName ?? "", versionType: fileVersion(), versionId: versionId,fileSize: attachmentEn.attachmentDisplaySize ?? "", fileExtension: attachmentEn.attachmentExtension ?? "", fileCreatedDate: getDate(), isPinned: isPinned, fileURl: attachmentEn.attachmentURL ?? "", fileType: FileType(rawValue:attachmentEn.attachmentExtension ?? "") ?? .pdf, subCategory: SubCategoryModel(id: subCategoryID, name: subCategoryName, category: CategoryModel(id: categoryID, name: categoryName)), fileAcknowledgeStatus:  FileAcknowledgeStatus(title: acknowledgementTitle, color: acknowledgementColor, isAcknowledge: isAcknowledgement,isAcknowledged: isAcknowledged), fileCheckbox: FileCheckBox(),fileUrlAr:attachmentAr.attachmentURL ?? "",fileUrlEn: attachmentEn.attachmentURL ?? "")
    }
}
