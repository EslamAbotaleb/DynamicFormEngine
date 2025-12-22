//
//  CartRepoImpl.swift
//  beauty_user
//
//  Created by Maher on 4/28/21.
//  Copyright © 2021 MahmoudOrganization. All rights reserved.
//

import Promises


class DocumentLibraryRepoImpl: DocumentLibraryRepo,BaseRepo {    
  

    private var network: Network
    
    init(network: Network = NetworkServiceImpl()) {
        self.network = network
    }
    
    func CategoriesWithChildrens() -> Promise<BaseResponse<[ListModel]>> {
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: CategoriesWithChildrensEndpoint())
    }
    
    func categories() -> Promise<BaseResponse<[ListModel]>> {
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: CategoriesEndPoint())
        
    }
    func subCategories(categoryId: String) -> Promise<BaseResponse<[ListModel]>> {
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: SubCategoriesEndPoint(categoryId: categoryId ))
        
    }
    func allFiles(cerqelFilterPayload: CerqelFilterPayload )  -> Promise<BaseResponse<FileDTO>> {
        return self.network.callModel(BaseResponse<FileDTO>.self, endpoint: FilesEndPoint(cerqelFilterPayload: cerqelFilterPayload ))
    }
    
    func recentFiles(cerqelFilterPayload: CerqelFilterPayload)   -> Promise<BaseResponse<FileDTO>> {
        return self.network.callModel(BaseResponse<FileDTO>.self, endpoint: recentFilesEndPoint(cerqelFilterPayload: cerqelFilterPayload ))
    }
    
    func fileTypes() -> Promise<BaseResponse<[ListModel]>> {
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: FileTypesEndPoint())
        
    }
    func generalUpload(fileEntity: FileEntity, fromProfile: Bool, progressCallBack: @escaping(Double,FileVersionType) -> ())  -> Promise<BaseUploadResponse<[UploadResponseModel]>> {
        return self.network.uploadModel(BaseUploadResponse<[UploadResponseModel]>.self, endpoint: GeneralUploadEndPoint(fileEntity: fileEntity, fromProfile: fromProfile), progressCallBack: progressCallBack)
    }
    func upload(upLoadFileRequest: UploadFileRequest)  -> Promise<BaseResponse<EmptyModel>> {
        return self.network.callModel(BaseResponse<EmptyModel>.self, endpoint: UploadEndPoint(UploadRequest: upLoadFileRequest))
    }
    func uploadUserProfile(upLoadUserProfileRequest: Attachment)  -> Promise<BaseResponse<Bool>>{
        return self.network.callModel(BaseResponse<Bool>.self, endpoint: UploadUserProfileEndPoint(UploadRequest: upLoadUserProfileRequest))
    }
    func cancelUpload(_ fileVersionType: FileVersionType)  -> Void {
        self.network.cancelUpload(fileVersionType)
        
    }
    func reportList() -> Promise<BaseResponse<[ListModel]>>{
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: ReportListEndPoint())
    }
    func sendReportList(reportRequest: ReportRequest) -> Promise<BaseResponse<Bool>>{
        return self.network.callModel(BaseResponse<Bool>.self, endpoint: SendReportEndPoint(reportRequest: reportRequest))
    }
    
    func acknowledge(fileId: String) -> Promises.Promise<BaseResponse<FileAcknowledgeResponse>> {
        return self.network.callModel(BaseResponse<FileAcknowledgeResponse>.self, endpoint: AcknowledgEndPoint(fileId: fileId))
    }
    
    func pin(fileId: String) -> Promise<BaseResponse<Bool>>{
        return self.network.callModel(BaseResponse<Bool>.self, endpoint: PinEndPoint(fileId: fileId))
    }
    func view(fileId: String) -> Promise<BaseResponse<EmptyModel>> {
        return self.network.callModel(BaseResponse<EmptyModel>.self, endpoint: ViewFileEndPoint(fileId: fileId))

    }
    
    func download(filesUrl: [String]) -> Promise<URL> {
        return self.network.downloadModel(filesUrl: filesUrl)

    }
   
    
    
    
}
