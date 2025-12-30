//
//  UploadViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 17/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import PanModal
import DynamicFormEngine

class UploadFileViewModel: BaseVM {
    
    // Dependencies
    
    private var router:CerqelRouterManager
    private var documentRepo: DocumentLibraryRepo!
    
    
    var fileArabicVersion: DynamicObjects<File> = DynamicObjects(File())
    var fileEnglishVersion:DynamicObjects<File> = DynamicObjects(File())
    var FileVersionType: DynamicObjects<FileVersionType> = DynamicObjects(.english)
    
    var categories: DynamicObjects<[ListModel]> = DynamicObjects([])
    var subCategories: DynamicObjects<[ListModel]> = DynamicObjects([])
    var category: DynamicObjects<ListModel> = DynamicObjects(ListModel())
    var subCategory: DynamicObjects<ListModel> = DynamicObjects(ListModel())
    var description: DynamicObjects<String> = DynamicObjects("")
    var fileToUpload: DynamicObjects<Data> = DynamicObjects(Data())
    var cancelUpload: DynamicObjects<Bool> = DynamicObjects(false)
    
    init( router: CerqelRouterManager) {
        self.router = router
    }
    
    override func hydrate() {
        setupDepencies()
        categoriesEndPoint()
    }
    
    // initial
    
    private func setupDepencies(){
        self.documentRepo = DocumentLibraryRepoImpl()
    }
    
    
    // routes
    
    func dismiss() {
        router.dismiss()
    }
    
    func getCategories() {
        router.presentbottomSheet(fromProfile: false, controller: BaseList.self, viewModel: BaseListBottomSheetViewModel.self, item:
                                    BaseListItem(list: self.categories.value, title: "Select Category".localized, type: .radio,currentSelectedItem: self.category.value,isSingleSelection: true, selectedItem: selectedCategory,multiSelectedItems: multiSelectedItems)
        )
    }
    
    func multiSelectedItems(item: [ListModel]){}
    
    func getSubCategories(){
        guard self.category.value.id != "" else {
            self.showErrorAlert(message: "Please select category first".localized)
            return
        }
        router.presentbottomSheet(fromProfile: false, controller: BaseList.self, viewModel: BaseListBottomSheetViewModel.self, item:
                                    BaseListItem(list: self.subCategories.value, title: "Select Sub-Category".localized, type: .radio,currentSelectedItem: self.subCategory.value,isSingleSelection: true, selectedItem: selectedSubCategory,multiSelectedItems: multiSelectedItems)
        )
    }
    
    //actions
    
    func selectedCategory(item: ListModel){
        guard item.id != category.value.id else {
            return
        }
        self.subCategory.value = ListModel()
        self.category.value = item
        subCategoriesEndPoint()
        
    }
    
    func selectedSubCategory(item: ListModel){
        guard item.id != subCategory.value.id else {
            return
        }
        self.subCategory.value = item
    }
    
    
    func pickFile(url: URL, fromProfile: Bool) {
        switch FileVersionType.value {
        case .english : fileWithEnglishVersionIsPicked(url: url)
        case .arabic :  fileWithArabicIsVersionIsPicked(url: url)
        }
        guard let fileSize = url.fileSize, fileSize < 25 else {
            self.showErrorAlert(message: "The attachment size should be less than 25MB".localized)
            return
        }
        uploadFile(fromProfile: fromProfile)
    }
    
    func removeFile() {
        switch FileVersionType.value {
        case .english : fileWithEnglishVersionIsRemoved()
        case .arabic :  fileWithArabicIsVersionIsRemoved()
        }
        
    }
    
    func cancelFile() {
        switch FileVersionType.value {
        case .english : fileWithEnglishVersionIsCanceled()
        case .arabic :  fileWithArabicIsVersionIsCanceled()
        }
        
    }
    
    private func fileWithArabicIsVersionIsPicked(url: URL) {
        self.fileArabicVersion.value.url = url
        self.fileArabicVersion.value.fileName = url.lastPathComponent
        self.fileArabicVersion.value.attachment?.fileLange = "ar"
        self.fileArabicVersion.value.attachment?.attachmentDisplaySize = "\(url.fileSize)"
        let filename: NSString = self.fileArabicVersion.value.fileName! as NSString
        let pathExtention =  filename.pathExtension
        self.fileArabicVersion.value.fileExtension = pathExtention
    }
    
    
    
    private func fileWithEnglishVersionIsPicked(url: URL) {
        self.fileEnglishVersion.value.url = url
        self.fileEnglishVersion.value.fileName = url.lastPathComponent
        self.fileArabicVersion.value.attachment?.fileLange = "en"
        self.fileArabicVersion.value.attachment?.attachmentDisplaySize = "\(url.fileSize)"
        let filename: NSString = self.fileEnglishVersion.value.fileName! as NSString
        let pathExtention =  filename.pathExtension
        self.fileEnglishVersion.value.fileExtension = pathExtention.lowercased()
    }
    
    private func fileWithArabicIsVersionIsRemoved() {
        self.fileArabicVersion.value = File(fileStatus: .removed)
    }
    private func fileWithEnglishVersionIsRemoved() {
        self.fileEnglishVersion.value = File(fileStatus: .removed)
    }
    
    private func fileWithArabicIsVersionIsCanceled() {
        self.fileArabicVersion.value = File(fileStatus: .removed)
        cancelUploadEndPoint()
        
    }
    private func fileWithEnglishVersionIsCanceled() {
        self.fileEnglishVersion.value = File(fileStatus: .removed)
        cancelUploadEndPoint()
    }
    
    
    private func convertFileToData(fromProfile: Bool) {
        do {
            switch FileVersionType.value {
            case .english :
                let accessGranted = fileEnglishVersion.value.url!.startAccessingSecurityScopedResource()
                if accessGranted {
                    self.fileEnglishVersion.value.data = try Data(contentsOf: fileEnglishVersion.value.url!)
                }
                fileEnglishVersion.value.url!.stopAccessingSecurityScopedResource()
            case .arabic :
                let accessGranted = fileArabicVersion.value.url!.startAccessingSecurityScopedResource()
                if accessGranted {
                    self.fileArabicVersion.value.data = try Data(contentsOf: fileArabicVersion.value.url!)
                }
                fileArabicVersion.value.url!.stopAccessingSecurityScopedResource()
            }
            uploadFileEndPoint(fromProfile: fromProfile)
        } catch {
            print("\(error)")
        }
    }    
    
    func updateFileProgressStatus(_ fileVersion: FileVersionType, progress: Double){
        switch fileVersion {
        case .english :
            self.fileEnglishVersion.value.fileInformation = FileInformation(fileVersionType: fileVersion)
            self.fileEnglishVersion.value.progress = progress
            self.fileEnglishVersion.value.fileStatus = .inProgress
            
        case .arabic :
            
            
            self.fileArabicVersion.value.fileInformation = FileInformation(fileVersionType: fileVersion)
            self.fileArabicVersion.value.progress = progress
            self.fileArabicVersion.value.fileStatus = .inProgress
            
            
        }
    }
    
    func updateFileUploadStatus(_ fileVersion: FileVersionType, _ attachment: Attachment){
        switch fileVersion {
        case .english :
            
            self.fileEnglishVersion.value.fileInformation = FileInformation(fileVersionType: fileVersion)
            self.fileEnglishVersion.value.attachment = attachment
            self.fileEnglishVersion.value.fileStatus = .uploaded
            
        case .arabic :
            
            self.fileArabicVersion.value.fileInformation = FileInformation(fileVersionType: fileVersion)
            self.fileArabicVersion.value.attachment = attachment
            self.fileArabicVersion.value.fileStatus = .uploaded
            
        }
        
    }
    
    func updateFileFailedStatus(_ fileVersion: FileVersionType){
        
        switch fileVersion {
        case .english :
            guard  self.fileEnglishVersion.value.fileStatus != .removed else {
                return
            }
            self.fileEnglishVersion.value.fileStatus = .failed
            
        case .arabic :
            
            guard  self.fileArabicVersion.value.fileStatus != .removed else {
                return
            }
            self.fileArabicVersion.value.fileStatus = .failed
            
        }
    }
    
    
    
    private func uploadFile(fromProfile: Bool) {
        convertFileToData(fromProfile: fromProfile)
        switch FileVersionType.value {
        case .english : fileEnglishVersion.value.fileStatus = .uploadBegin
        case .arabic :  fileArabicVersion.value.fileStatus = .uploadBegin
        }
        
    }
    
    func  successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBack, "Your Request has been submitted Successfully".localized))
    }
    func successCallBack() {
        self.dismiss()
    }
    
    
    func categoriesEndPoint() {
        showHudLoading()
        documentRepo.categories().then { (response) in
            self.categories.value = response.result.data
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    func subCategoriesEndPoint() {
        showHudLoading()
        documentRepo.subCategories(categoryId: self.category.value.id! ).then { (response) in
            self.subCategories.value = response.result.data
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    func uploadFileEndPoint(fromProfile: Bool) {
        var fileVersion: FileVersionType?
        let fileType = FileType(rawValue: fileEnglishVersion.value.fileExtension ?? "") ?? .pdf
        var fileName: String?
        switch self.FileVersionType.value {
        case .english :
            self.fileToUpload.value = fileEnglishVersion.value.data ?? Data()
            fileName = fileEnglishVersion.value.fileName
        case .arabic :
            self.fileToUpload.value = fileArabicVersion.value.data ?? Data()
            fileName = fileArabicVersion.value.fileName
        }
        
        documentRepo.generalUpload(fileEntity: FileEntity(uploadExtension: fileType, file: FileRequest(date: self.fileToUpload.value, fileName: fileName ?? "", extenstion: fileType), FileType: FileVersionType.value, isPublic: false, serviceType: 1), fromProfile: fromProfile){ Progress,fileVersionType  in
            fileVersion = fileVersionType
            self.updateFileProgressStatus(fileVersion ?? .english, progress: Progress)
        }.then { (response) in
            self.updateFileUploadStatus(fileVersion ?? .english, response.result[0].toAttachment())
        }.catch { (error) in
            self.updateFileFailedStatus(fileVersion ?? .english)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    func uploadEndPoint() {
        self.showHudLoading()
        var uploadRequest : UploadFileRequest!
        let catID = category.value.id == "" ? nil : category.value.id
        let subCatID = subCategory.value.id == "" ? nil : subCategory.value.id
        let attachmentAr = fileArabicVersion.value.attachment == nil ? nil : fileArabicVersion.value.attachment!
        let attachmentEn = fileEnglishVersion.value.attachment == nil ? nil : fileEnglishVersion.value.attachment!
        
        uploadRequest = UploadFileRequest(categoryID: catID, subcategoryID: subCatID, description: description.value, attachmentEn: attachmentEn, attachmentAr: attachmentAr)
        
        documentRepo.upload(upLoadFileRequest: uploadRequest).then { (response) in
            self.successBottomSheet()
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    func cancelUploadEndPoint() {
        documentRepo.cancelUpload(FileVersionType.value)
        
    }
    
    
}
