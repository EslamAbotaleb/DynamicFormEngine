//
//  ReportVM.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public enum FileActionType {
    case acknowledge
    case report
    case pin
}

public class ReportViewModel: BaseVM {
    
    private var router:CerqelRouterManager
    private var documentRepo: DocumentLibraryRepo!
    
    
    public var pullToRefresh: DynamicObjects<Bool> = DynamicObjects(false)
    public var fileId: DynamicObjects<String> = DynamicObjects("")
    public var selectedItemId: DynamicObjects<String> = DynamicObjects("")
    public var otherReason: DynamicObjects<String> = DynamicObjects("")
    public var reportList: DynamicObjects<[ListModel]> = DynamicObjects( [])
    
    
    public init( router: CerqelRouterManager, fileId: String) {
        self.router = router
        self.fileId.value = fileId

    }
    
    
    override public func hydrate() {
        setupDepencies()
        
    }
    
    private func setupDepencies(){
        self.documentRepo = DocumentLibraryRepoImpl()
    }
    
    // Action
    
    public func selectItem (index: Int) {
        unSelectAll()
        self.selectedItemId.value = self.reportList.value[index].id!
        self.reportList.value[index].isSelected = true
    }
    
    
    public func unSelectAll () {
        self.reportList.value =  self.reportList.value.map{var file = $0; file.isSelected = false; return file;}
    }
    
    
  
    //router
    
    public func popBack () {
        router.popBack()
    }
    
    public func successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBack, "The file has been reported successfully".localized))
    }
    
    func successCallBack() {
        self.popBack()
    }
    
    public func  fireObserve () {
        let fileValue: [String: Any] = [ "fileActionType": FileActionType.report, "fileId": self.fileId.value]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileAction"), object: nil, userInfo: fileValue)
    }
    
    //endPoint
    public func reportListEndPoint() {
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
    
    public func sendReportEndPoint() {
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

