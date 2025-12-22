//
//  FileModel.swift
//  CERQEL
//
//  Created by ahmed maher on 10/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

enum FileViewLayout: String {
    case defaultLayout
    case gridLayout
}

enum FileStatus: String {
    case acknowledged
    case needAcknowledge
}

struct FileAcknowledgeStatus {
    var title: String
    var color: String
    var isAcknowledge: Bool = false
    var isAcknowledged: Bool = false
}

// MARK: - DataClass
struct FileAcknowledgeResponse: Codable {
    let fileID, acknowledgeColor, acknowledgeTitle: String
    
    enum CodingKeys: String, CodingKey {
        case fileID = "fileId"
        case acknowledgeColor, acknowledgeTitle
    }
}

enum FileType:  String {
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



struct FileModel {
    var id: String
    var title: String
    var versionType: String
    var versionId: Int
    var fileSize: String
    var fileExtension: String
    var fileCreatedDate: String
    var isPinned: Bool
    var localFileUrl: URL?
    var fileURl: String
    var fileType: FileType
    var subCategory: SubCategoryModel
    var fileAcknowledgeStatus: FileAcknowledgeStatus
    var fileCheckbox: FileCheckBox
    var fileUrlAr: String
    var fileUrlEn: String
    
    init(id: String, title: String, versionType: String, versionId: Int, fileSize: String, fileExtension: String, fileCreatedDate: String, isPinned: Bool, localFileUrl: URL? = nil, fileURl: String, fileType: FileType, subCategory: SubCategoryModel, fileAcknowledgeStatus: FileAcknowledgeStatus, fileCheckbox: FileCheckBox, fileUrlAr: String, fileUrlEn: String) {
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
    
    init (id: String = "",fileURl: String, name : String = "", fileExtension : String = "") {
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

struct FileCheckBox {
    var isSelected: Bool = false
    var isAppear: Bool = false
}

struct File {
    
    var fileName: String?
    var fileExtension: String?
    var url: URL?
    var fileInformation:FileInformation?
    var data:Data?
    var progress:Double?
    var fileStatus: FileUploadStatus
    var attachment: Attachment?
    var profileAttachment: ProfilePicture?
    
    init(fileName: String = "",fileExtension: String = "" ,url: URL? = nil, fileInformation: FileInformation? = nil, data: Data? = nil, progress: Double? = nil, fileStatus: FileUploadStatus, attachment: Attachment? = nil, profileAttachment: ProfilePicture? = nil) {
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

    init() {
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
struct FileInformation {
    var fileName: String?
    var fileExtension: FileType?
    var fileVersionType: FileVersionType
    
    init(fileName: String? = nil, fileExtension: FileType? = nil, fileVersionType: FileVersionType) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.fileVersionType = fileVersionType
    }
    
    init() {
        self.fileName = ""
        self.fileExtension = .pdf
        self.fileVersionType = .english
    }
}
// MARK: - Datum
struct FileDTO : Codable {
    let files: [FileResponse]
    let highlightedFilters: HighlightedFilters?
}

struct HighlightedFilters: Codable {
    let highlightedCategories, highlightedTypes: [Highlighted]?
}

struct Highlighted: Codable {
    let value: String
    let highlightedSubcategories: [HighlightedValue]?
}

struct HighlightedValue: Codable {
    let value: String
}

struct FileResponse: Codable {
    
    let attachmentEn: Attachment
    let dateCreated: String
    
    var isPinned: Bool
    var isAcknowledged: Bool
    var isAcknowledgement: Bool
    var acknowledgementColor: String
    var acknowledgementTitle: String
    let viewDate: String?
    let dateModified, categoryName, categoryID: String
    let version, subCategoryID, name: String
    let subCategoryName, id: String
    let versionId: Int
    let attachmentAr: Attachment
    
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
    
    
    
    
    func toFileModel() -> FileModel {
        return  isArabicCerqel() ? FileModel(id: id, title: attachmentAr.attachmentName ?? "", versionType: fileVersion(), versionId: versionId,fileSize: attachmentAr.attachmentDisplaySize ?? "", fileExtension: attachmentAr.attachmentExtension ?? "", fileCreatedDate: getDate(), isPinned: isPinned, fileURl: attachmentAr.attachmentURL ?? "", fileType: FileType(rawValue:attachmentAr.attachmentExtension ?? "") ?? .pdf, subCategory: SubCategoryModel(id: subCategoryID, name: subCategoryName, category: CategoryModel(id: categoryID, name: categoryName)), fileAcknowledgeStatus: FileAcknowledgeStatus(title: acknowledgementTitle, color: acknowledgementColor, isAcknowledge: isAcknowledgement,isAcknowledged: isAcknowledged) , fileCheckbox: FileCheckBox(),fileUrlAr:attachmentAr.attachmentURL ?? "",fileUrlEn: attachmentEn.attachmentURL ?? "")
        :
        FileModel(id: id, title: attachmentEn.attachmentName ?? "", versionType: fileVersion(), versionId: versionId,fileSize: attachmentEn.attachmentDisplaySize ?? "", fileExtension: attachmentEn.attachmentExtension ?? "", fileCreatedDate: getDate(), isPinned: isPinned, fileURl: attachmentEn.attachmentURL ?? "", fileType: FileType(rawValue:attachmentEn.attachmentExtension ?? "") ?? .pdf, subCategory: SubCategoryModel(id: subCategoryID, name: subCategoryName, category: CategoryModel(id: categoryID, name: categoryName)), fileAcknowledgeStatus:  FileAcknowledgeStatus(title: acknowledgementTitle, color: acknowledgementColor, isAcknowledge: isAcknowledgement,isAcknowledged: isAcknowledged), fileCheckbox: FileCheckBox(),fileUrlAr:attachmentAr.attachmentURL ?? "",fileUrlEn: attachmentEn.attachmentURL ?? "")
    }
}
