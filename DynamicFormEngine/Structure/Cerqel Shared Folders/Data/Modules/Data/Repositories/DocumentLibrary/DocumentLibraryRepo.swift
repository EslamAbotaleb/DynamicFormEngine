//
//  CartRepo.swift
//
//  Created by Maher on 4/28/21.
//  Copyright © 2021 MahmoudOrganization. All rights reserved.
//

import Foundation
import Promises
//
//typealias SelectedCallBack =  ((ListModel)->())
//typealias MultiSelectedCallBack =  (([ListModel])->())
//typealias CerqelSelectedCallBack =  ((CerqelListModel)->())
//
//class BottomSheetItem: BaseItem,Equatable {
//
//    var repo: BaseRepo
//    var endPoint: EndPointServiceCerqel
//    var type: BottomSheetType
//    var isSingleSelection: Bool?
//    var selectedItem: SelectedCallBack
//    var multiSelectedItems : MultiSelectedCallBack
//    
//    init(repo: BaseRepo,endPoint:EndPointServiceCerqel,type: BottomSheetType,isSingleSelection: Bool? = false, selectedItem: @escaping SelectedCallBack, multiSelectedItems : @escaping MultiSelectedCallBack) {
//        self.type = type
//        self.repo = repo
//        self.endPoint = endPoint
//        self.isSingleSelection = isSingleSelection
//        self.selectedItem = selectedItem
//        self.multiSelectedItems = multiSelectedItems
//    }
//
//    static func == (lhs: BottomSheetItem, rhs: BottomSheetItem) -> Bool {
//        return true
//
//    }
//
//}

protocol DocumentLibraryRepo {
    func CategoriesWithChildrens() -> Promise<BaseResponse<[ListModel]>>
    func categories() -> Promise<BaseResponse<[ListModel]>>
    func subCategories(categoryId: String)  -> Promise<BaseResponse<[ListModel]>>
    func allFiles(cerqelFilterPayload: CerqelFilterPayload )  -> Promise<BaseResponse<FileDTO>>
    func recentFiles(cerqelFilterPayload: CerqelFilterPayload)   -> Promise<BaseResponse<FileDTO>>
    func fileTypes() -> Promise<BaseResponse<[ListModel]>>
    func generalUpload(fileEntity: FileEntity, fromProfile: Bool, progressCallBack: @escaping UploadProgrssCallBack)  -> Promise<BaseUploadResponse<[UploadResponseModel]>>
    func upload(upLoadFileRequest: UploadFileRequest)  -> Promise<BaseResponse<EmptyModel>>
    func uploadUserProfile(upLoadUserProfileRequest: Attachment)  -> Promise<BaseResponse<Bool>>
    func cancelUpload(_ fileVersionType: FileVersionType)  -> Void
    func reportList() -> Promise<BaseResponse<[ListModel]>>
    func sendReportList(reportRequest: ReportRequest) -> Promise<BaseResponse<Bool>>
    func pin(fileId: String) -> Promise<BaseResponse<Bool>>
    func view(fileId: String) -> Promise<BaseResponse<EmptyModel>>
    func acknowledge(fileId: String) -> Promise<BaseResponse<FileAcknowledgeResponse>>
    func download(filesUrl: [String]) -> Promise<URL>

}

struct UploadResponseModel: Codable {
    let name, id, fileSize: String?
    let previewURL, downloadURL: String?
    let contentType, documentType: String?
    var url: String? = ""
    let isPublic: Bool?

    enum CodingKeys: String, CodingKey {
        case name, id, fileSize
        case previewURL = "previewUrl"
        case downloadURL = "downloadUrl"
        case contentType, documentType, isPublic
        case url
    }
}
extension UploadResponseModel {
    func toAttachment() -> Attachment {
        return Attachment(
            attachmentID: id ?? "",
            attachmentType: contentType ?? "",
            attachmentURL: downloadURL ?? "",
            fileID: id ?? "",
            storageFileId: id ?? "",
            attachmentName: name ?? "",
            attachmentExtension: documentType ?? "",
            attachmentSize: Double(fileSize ?? "0") ?? 0 ,
            attachmentDisplaySize: "", // Set this based on your logic
            fileLange: "" // Set this based on your logic
        )
    }
    
    func toProfilePicture() -> ProfilePicture {
        let mediaId = id ?? ""
        let fileName = name ?? ""
        let contentType = contentType ?? ""
        let documentType = documentType ?? ""
        let downloadUrl = downloadURL ?? ""
        let fileSize = fileSize ?? "0"
        let previewUrl = downloadURL ?? ""
        
        return ProfilePicture(
            mediaId: mediaId,
            fileName: fileName,
            base64File: "",
            contentType: contentType,
            documentType: documentType,
            downloadUrl: downloadUrl,
            fileSize: fileSize,
            previewUrl: previewUrl,
            disableDeleteIcon: false,
            url: url,
            state: .new
        )
    }
}


