//
//  AcknowledgeVM.swift
//  CERQEL
//
//  Created by Maher on 17/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//


import Foundation
import DynamicFormEngine

class AcknowledgeViewModel: BaseVM {
    
    
    private var router:CerqelRouterManager
    private var documentRepo: DocumentLibraryRepo!
    
    

    var fileId: DynamicObjects<String> = DynamicObjects("")


    
    
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

    }
    
    
    //router
    
    func popBack () {
        router.popBack()
    }
    
    func  successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBack, "The file has been acknowledged successfully".localized))
    }
    
    func successCallBack() {
        self.popBack()
    }
    
    func  fireObserve (acknowledge: FileAcknowledgeResponse) {
        let fileValue: [String: Any] = [ "fileActionType": FileActionType.acknowledge, "fileId": self.fileId.value, "acknowledge": acknowledge ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fileAction"), object: nil, userInfo: fileValue)
    }
    
    
    //endPoint
    
    func acknowledgementEndPoint( ) {
        self.showHudLoading()
        documentRepo.acknowledge(fileId: fileId.value).then { (response) in
            self.successBottomSheet()
            self.fireObserve(acknowledge: response.result.data)
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
}

