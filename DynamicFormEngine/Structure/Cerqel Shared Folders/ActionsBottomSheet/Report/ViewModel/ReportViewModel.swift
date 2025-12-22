//
//  ReportVM.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

enum FileActionType {
    case acknowledge
    case report
    case pin
}

class ReportViewModel: BaseVM {
    
    
    private var router:CerqelRouterManager
    private var documentRepo: DocumentLibraryRepo!
    
    
    var pullToRefresh: DynamicObjects<Bool> = DynamicObjects(false)
    var fileId: DynamicObjects<String> = DynamicObjects("")
    var selectedItemId: DynamicObjects<String> = DynamicObjects("")
    var otherReason: DynamicObjects<String> = DynamicObjects("")
    var reportList: DynamicObjects<[ListModel]> = DynamicObjects( [])
    
    
    init( router: CerqelRouterManager, fileId: String) {
        self.router = router
        self.fileId.value = fileId

    }
    
    
    override func hydrate() {
        setupDepencies()
        
    }
    
    private func setupDepencies(){
        self.documentRepo = DocumentLibraryRepoImpl()
    }
    
    // Action
    
    func selectItem (index: Int) {
        unSelectAll()
        self.selectedItemId.value = self.reportList.value[index].id!
        self.reportList.value[index].isSelected = true
    }
    
    
    func unSelectAll () {
        self.reportList.value =  self.reportList.value.map{var file = $0; file.isSelected = false; return file;}
    }
    
    
  
    //router
    
    func popBack () {
        router.popBack()
    }
    
    func successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBack, "The file has been reported successfully".localized))
    }
    
    func successCallBack() {
        self.popBack()
    }
    
    func  fireObserve () {
        let fileValue: [String: Any] = [ "fileActionType": FileActionType.report, "fileId": self.fileId.value]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileAction"), object: nil, userInfo: fileValue)
    }
    
    //endPoint
    func reportListEndPoint() {
        pullToRefresh.value ? self.hideLoadingCerqel() : self.showLoadingCerqel()
        
        documentRepo.reportList().then { (response) in
            
            self.reportList.value = response.result.data
            
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.pullToRefresh.value = false
            self.hideLoadingCerqel()
        }
    }
    
    func sendReportEndPoint() {
        self.showHudLoading()
        let reportRequest = ReportRequest(fileId: fileId.value, reason: ReasonRequest(id: selectedItemId.value, reasonMessage: otherReason.value))
        documentRepo.sendReportList(reportRequest: reportRequest ).then { (response) in
            self.successBottomSheet()
            self.fireObserve()

        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.pullToRefresh.value = false
            self.hideLoadingCerqel()
        }
    }
}

