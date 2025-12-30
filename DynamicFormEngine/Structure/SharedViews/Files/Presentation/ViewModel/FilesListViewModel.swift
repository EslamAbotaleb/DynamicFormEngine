//
//  SubCategoriesListViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 09/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit
import DynamicFormEngine

class FilesListViewModel: BaseVM {
    
    // Dependencies
    private var userAuthoriationHandler: AuthorizationHandler = UserAuthoriationHandler()
    private var router:CerqelRouterManager
    private var documentRepo: DocumentLibraryRepo!
    private var localNotification: LocalNotificationProtocol!
    private var localData: LocalData
    private var delegate: ActionsProtocol
    
    static var fiterPreviousView : PreviousView = .document
    var filesList: DynamicObjects<[FileModel]> = DynamicObjects([])
    var fileLayout: DynamicObjects<FileViewLayout> = DynamicObjects(.defaultLayout)
    var selectedFilesCount: DynamicObjects<Int> = DynamicObjects(1)
    var allFilesSelected: DynamicObjects<Bool> = DynamicObjects(false)
    var selectionMode: DynamicObjects<SelectionMode> = DynamicObjects(.hidden)
    var pullToRefresh: DynamicObjects<Bool> = DynamicObjects(false)
    var currentPage: DynamicObjects<Int> = DynamicObjects(1)
    var totalPages: DynamicObjects<Int> = DynamicObjects(1)
    var allFilesCount: DynamicObjects<Int> = DynamicObjects(0)
    var isSortApplied: DynamicObjects<Bool> = DynamicObjects( false)
    var selectedSort: DynamicObjects<String> = DynamicObjects( "Newest")
    var fileItem: DynamicObjects<FileFilterItem> = DynamicObjects(FileFilterItem())
    var sortRequestModel: DynamicObjects<[OrderByValue]> = DynamicObjects( [])
    var fiterPreviousView : PreviousView = .document
    var initialSortData: DynamicObjects<[sortModelCerqel]> = DynamicObjects( [])
    var endPointFilterRequest : CerqelFilterPayload!
    var filterModel: CerqelFilterCallBack? = CerqelFilterCallBack()
    var cerqelFilterPayload : CerqelFilterPayload!
    var filterViewModel: FilterViewModel =  FilterViewModel()
    private var gsFileListUseCase: GSFileListUseCase?

    init(fileItem: FileFilterItem, localData: LocalData = LocalDataImpl(), router: CerqelRouterManager,delegate: ActionsProtocol,gsFileListUseCase: GSFileListUseCase) {
        self.fileItem.value = fileItem
        self.localData = localData
        self.router = router
        self.delegate = delegate
        self.gsFileListUseCase = gsFileListUseCase
    }
    
    override func hydrate() {
        setupDepencies()
        setSortData()
    }
    
    private func setupDepencies(){
        self.documentRepo = DocumentLibraryRepoImpl()
        self.localNotification = LocalNotificationManager.shared
    }
    
    // initial
    func setSortData() {
        initialSortData.value = [sortModelCerqel(sortName: "Newest"), sortModelCerqel(sortName: "Oldest"), sortModelCerqel(sortName: "Alphabetical A-Z"), sortModelCerqel(sortName: "Alphabetical Z-A")]
        //        sortRequestModel.value =  [OrderByValue(colID: "dateModified", sort: "desc")]
    }
    
    func handleSortPayload(){
        switch selectedSort.value {
        case  "Newest":
            sortRequestModel.value =  [OrderByValue(colID: "dateModified", sort: "desc")]
        case  "Oldest":
            sortRequestModel.value =  [OrderByValue(colID: "dateModified", sort: "asc")]
        case  "Alphabetical A-Z":
            sortRequestModel.value =  [OrderByValue(colID: "name", sort: "asc")]
        case  "Alphabetical Z-A":
            sortRequestModel.value =  [OrderByValue(colID: "name", sort: "desc")]
        case  "Low Priority":
            sortRequestModel.value =  [OrderByValue(colID: "dateModified", sort: "asc")]
        case  "High Priority":
            sortRequestModel.value =  [OrderByValue(colID: "dateModified", sort: "asc")]
        default: break
        }
        reloadAllFiles()
    }
    
    // routes
    func popBack(){
        router.popBack()
    }
    
    func dismiss(){
        router.dismiss()
    }
    func  presentFileAction (file: FileModel) {
        router.presentbottomSheet(fromProfile: false, controller: FileActionsView.self, viewModel: FileActionsViewModel.self, item: FileActionItem(file: file, router: router, delegate: self.delegate))
    }
    
    func routeToFilter(){
        
        router.presentFullScreen(controller: FilterView.self, viewModel: FilterViewModel.self, item:
                                    FilterItem(categoryId:self.filterModel?.categoryId,sections: [
                                        CerqelFilterSection(id: 1, sectionTitle: "By Category".localized, sectionType: .categories(.multi),filterCategoriesType: .categories, endPoint: .categories
                                                           ),
                                        
                                        CerqelFilterSection(id: 2, sectionTitle: "File Type".localized, sectionType: .categories(.single),filterCategoriesType: .fileTypes,endPoint: .fileTypes),
                                        
                                        CerqelFilterSection(id: 3, sectionTitle: "Date".localized, sectionType: .dateRangeFilter, items: []),
                                        CerqelFilterSection(id: 4, sectionTitle: "Acknowledgement".localized, sectionType: .categories(.single),filterCategoriesType: .acknowledgement, items:
                                                                [
                                                                    CerqelCategoriesModel(id: "1",name: "All".localized,representation: .Radio, isSelected: true),
                                                                    CerqelCategoriesModel(id: "2",name: "Acknowledgment".localized,representation: .Radio),
                                                                    CerqelCategoriesModel(id: "3",name: "None Acknowledgment".localized,representation: .Radio),
                                                                ]),
                                    ],
                                               filterItem: filterModel!, repo: DocumentLibraryRepoImpl(),filterModelCallBack: filterModelCallBack
                                              ))
        
        
    }
    
    func routeToSearch(){
        router.presentFullScreen(controller: SearchView.self, viewModel: FilterViewModel.self, item: SearchItem(filterModelCallBack: filterModelCallBack )
        )
    }
    
    
    func  successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: BaseItem())
    }
    
    func filterModelCallBack(filterModel:CerqelFilterCallBack){
        
        
    }
    
    func routeToReport(fileId: String) {
        router.pushTo(controller: ReportView.self, viewModel: ReportViewModel.self, item: FileItem(fileId: fileId))
    }
    func routeToAcknowledge(fileId: String) {
        router.pushTo(controller: AcknowledgeVC.self, viewModel: AcknowledgeViewModel.self, item: FileItem(fileId: fileId))
    }
    // actions
    func handleFileLayout (_ fileLayout: FileViewLayout) {
        self.fileLayout.value = fileLayout
        SubCategoriesBaseView.shared.fileLayout = fileLayout
    }
    
    func selectionMode (_ mode: SelectionMode) {
        self.selectionMode.value = mode
    }
    
    func checkFileLayout () {
        let Layout =  SubCategoriesBaseView.shared.fileLayout
        guard fileItem.value.fileFrom != .globalSearch else {
            fileLayout.value = .gridLayout
            return
        }
        fileLayout.value = Layout ?? .defaultLayout
    }
    
    func showSelectionMode(fileIndex: Int){
        selectFile(fileIndex: fileIndex)
        self.filesList.value =  self.filesList.value.map{var file = $0; file.fileCheckbox.isAppear = true; return file;}
    }
    
    func unSelectionFiles(){
        self.filesList.value =  self.filesList.value.map{var file = $0; file.fileCheckbox.isAppear = true;
            file.fileCheckbox.isSelected = false;
            return file;}
        self.allFilesSelected.value =  checkIfAllFilesSelected()
        getSelectedFilesCount()
        
    }
    
    func cancelSelectionMode(){
        
        self.filesList.value =  self.filesList.value.map{var file = $0; file.fileCheckbox = FileCheckBox()
            return file;}
    }
    
    func selectFile(fileIndex: Int){
        let selectStatus = self.filesList.value[fileIndex].fileCheckbox.isSelected
        self.filesList.value[fileIndex].fileCheckbox.isSelected = !selectStatus
        self.allFilesSelected.value =  checkIfAllFilesSelected()
        getSelectedFilesCount()
        
    }
    private func getSelectedFilesCount(){
        selectedFilesCount.value =  self.filesList.value.filter{$0.fileCheckbox.isSelected == true}.count
    }
    
    
    
    func selectAllFile(){
        self.filesList.value =  self.filesList.value.map{var file = $0; file.fileCheckbox.isAppear = true;
            file.fileCheckbox.isSelected = true;
            return file;}
        self.allFilesSelected.value = true
        selectedFilesCount.value = self.filesList.value.count
        
    }
    
    private func checkIfAllFilesSelected() -> Bool{
        let selectedFilesCount =  self.filesList.value.filter{$0.fileCheckbox.isSelected == true}.count
        return selectedFilesCount == self.filesList.value.count
    }
    
    func checkForSelectionModelForPagination (_ nextFiles: [FileModel]) -> [FileModel] {
        switch selectionMode.value {
        case .appear :
            return  nextFiles.map{var file = $0; file.fileCheckbox.isAppear = true;
                file.fileCheckbox.isSelected = allFilesSelected.value;
                return file;}
        case .hidden :
            return  nextFiles.map{var file = $0; file.fileCheckbox.isAppear = false; return file;}
        }
        
    }
    
    func recieveFileAction(fileId: String,Acknowledge: FileAcknowledgeResponse){
        if let selectedFileIndex = self.filesList.value.firstIndex(where: {$0.id == fileId}) {
            self.filesList.value[selectedFileIndex].fileAcknowledgeStatus = FileAcknowledgeStatus(title: Acknowledge.acknowledgeTitle, color: Acknowledge.acknowledgeColor, isAcknowledge: true,isAcknowledged: true)
        }
    }
    
    func showDownloadMessage(){
        showSystemAlert(alert: "Starting downloading the file".localized)
    }
    
    
    func HandleFilePinnedAction(fileId: String){
        let fileIndex = self.filesList.value.firstIndex(where: {$0.id == fileId}) ?? 0
        self.filesList.value[fileIndex].isPinned.toggle()
        let destination: [String: Any] = [ "destination":fileItem.value.fileFrom ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pinnedFile"), object: nil, userInfo: destination)
        guard fileItem.value.fileFrom == .pinned else {
            return
        }
        self.filesList.value.remove(at: fileIndex)
        self.allFilesCount.value = self.filesList.value.count
        
    }
    
    
    func reloadAllFiles(){
        pullToRefresh.value = true
        selectionMode(.hidden)
        currentPage.value = 1
        totalPages.value = 1
        getFiles()
    }
    
    func reloadPage(){
        currentPage.value = 1
        totalPages.value = 1
        self.filesList.value = []
        getFiles()
    }
    
    func loadNextFiles(){
        currentPage.value += 1
        getFiles()
    }
    
    func setNextFilesFromPagination(files: [FileModel]){
        filesList.value.append(contentsOf: checkForSelectionModelForPagination(files))
        self.allFilesSelected.value =  checkIfAllFilesSelected()
        getSelectedFilesCount()
        
    }
    
    func  checkForfilterPreviousView(){
        switch fileItem.value.fileFrom {
        case .pinned :
            FilesListViewModel.fiterPreviousView = .pinned
        case .recent :
            FilesListViewModel.fiterPreviousView = .recent
        default :
            FilesListViewModel.fiterPreviousView = .document
            
        }
    }
    
    func getFiles(){
        switch fileItem.value.fileFrom {
        case .allFiles :
            endPointFilterRequest = CerqelFilterPayload(pageNumber: currentPage.value, pageSize: 10,orderByValue: sortRequestModel.value)
            filesEndPoint(endPointFilterRequest: endPointFilterRequest)
        case.recent:
            endPointFilterRequest = CerqelFilterPayload(pageNumber: currentPage.value, pageSize: 10,orderByValue: sortRequestModel.value)
            recentFilesEndPoint(endPointFilterRequest: endPointFilterRequest)
        case.pinned:
            endPointFilterRequest = CerqelFilterPayload(pageNumber: currentPage.value, pageSize: 10,filter: Filter(isPinned: true),orderByValue: sortRequestModel.value)
            filesEndPoint(endPointFilterRequest: endPointFilterRequest)
        case .subCategory:
            endPointFilterRequest = CerqelFilterPayload(pageNumber: currentPage.value, pageSize: 10,filter: Filter(subCategoryID: [fileItem.value.subcategory?.id ?? ""]),orderByValue: sortRequestModel.value)
            filesEndPoint(endPointFilterRequest: endPointFilterRequest)
        case .globalSearch :
            gsFilesEndPoint(endPointFilterRequest:fileItem.value.filterPayload!)
        }
    }
    
    //endPoint
    
    func gsFilesEndPoint(endPointFilterRequest:CerqelFilterPayload) {
        pullToRefresh.value || (currentPage.value > 1) ? self.hideLoadingCerqel() : self.showLoadingCerqel()
        var payload = endPointFilterRequest
        payload.pageNumber =  currentPage.value
        payload.pageSize =  10
        gsFileListUseCase?.execute(cerqelFilterPayload: payload).then { (response) in
            let files = response.result.data.files.map{$0.toFileModel()}
            self.allFilesCount.value = response.result.totalCount ?? 0
            if (self.pullToRefresh.value){
                self.filesList.value = files
            }
            else {
                self.setNextFilesFromPagination(files: files)
            }
            
            self.totalPages.value = response.result.pagesCount ?? 1
            
            
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
            self.pullToRefresh.value = false
        }
    }
    
    
    func filesEndPoint(endPointFilterRequest:CerqelFilterPayload ) {
        pullToRefresh.value || (currentPage.value > 1) ? self.hideLoadingCerqel() : self.showLoadingCerqel()
        documentRepo.allFiles(cerqelFilterPayload: endPointFilterRequest).then { (response) in
            let files = response.result.data.files.map{$0.toFileModel()}
            self.allFilesCount.value = response.result.totalCount ?? 0
            if (self.pullToRefresh.value){
                self.filesList.value = files
            }
            else {
                self.setNextFilesFromPagination(files: files)
            }
            
            self.totalPages.value = response.result.pagesCount ?? 1
            
            
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
            self.pullToRefresh.value = false
        }
    }
    
    func recentFilesEndPoint(endPointFilterRequest:CerqelFilterPayload) {
        pullToRefresh.value || (currentPage.value > 1) ? self.hideLoadingCerqel() : self.showLoadingCerqel()
        documentRepo.recentFiles(cerqelFilterPayload: endPointFilterRequest).then { (response) in
            
            let files = response.result.data.files.map{$0.toFileModel()}
            self.allFilesCount.value = response.result.totalCount ?? 0
            if (self.pullToRefresh.value){
                self.filesList.value = files
            }
            else {
                self.setNextFilesFromPagination(files: files)
            }
            
            self.totalPages.value = response.result.pagesCount ?? 1
            
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.pullToRefresh.value = false
            self.hideLoadingCerqel()
        }
    }
    
    
    func downloadMultibleFile() {
        showSystemAlert(alert: "Starting downloading the files".localized)
        let filesToDownloaded = self.filesList.value.filter{$0.fileCheckbox.isSelected == true}
        self.selectionMode.value = .hidden
        DownloadManager.shared.downloadFiles(from: filesToDownloaded) { (file, error) in
            if let fileDownloaded = file {
                self.localNotification.scheduleLocalNotification(file: fileDownloaded)
            } else if let error = error {
                print("Download error: \(error)")
            }
        }
    }
    
    func viewFileEndPoint(fileId: String ) {
        documentRepo.view(fileId: fileId).then { (response) in
            
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    
    func downloadFileForPreview(file: FileModel, completion: @escaping (FileModel?) -> Void) {
        DownloadManager.shared.downloadFiles(from: [file]) { (fileDownloaded, error) in
            if let fileDownloaded = fileDownloaded {
                completion(fileDownloaded)
            } else if let error = error {
                self.downloadModifiedFile(file: file, completion: completion)
            }
        }
    }
    
    private func downloadModifiedFile(file: FileModel, completion: @escaping (FileModel?) -> Void) {
        var fileModified = file
        fileModified.fileURl = fileModified.fileURl.replacingOccurrences(of: "gw/", with: "")
        DownloadManager.shared.downloadFiles(from: [fileModified]) { (fileDownloaded, error) in
            if let fileDownloaded = fileDownloaded {
                completion(fileDownloaded)
            } else if let error = error {
                completion(nil)
                self.showErrorAlert(message: "Unable to view attachment, Server error".localized)
            }
        }
    }
}
