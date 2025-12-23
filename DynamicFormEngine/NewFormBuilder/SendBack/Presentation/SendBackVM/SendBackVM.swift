//
//  SendBackVM.swift
//  CERQEL
//
//  Created by Youxel on 11/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
import DynamicFormEngine

class SendBackViewModel : BaseVM {
    var router: CerqelRouterManager
    var sendBackRecipientsUseCase: SendBackRecipientsUseCase
    var excuteActionUseCase: ExcuteActionUseCase
    
    var payload: DynamicObjects<ExcuteActionPayload> = DynamicObjects(ExcuteActionPayload())
    var comment: DynamicObjects<String> = DynamicObjects("")
    var sendBackLevels: DynamicObjects<[ListModel]> = DynamicObjects([ListModel()])
    var selectedlevel: DynamicObjects<ListModel> = DynamicObjects(ListModel())
    var sendBackId: String?
    var successCallBack: SuccessCallBack
    
    init(router: CerqelRouterManager,sendBackRecipientsUseCase: SendBackRecipientsUseCase,excuteActionUseCase: ExcuteActionUseCase,successCallBack: @escaping SuccessCallBack) {
        self.router = router
        self.sendBackRecipientsUseCase = sendBackRecipientsUseCase
        self.excuteActionUseCase = excuteActionUseCase
        self.successCallBack = successCallBack
    }
    
    func showLeaveConfirmationBottomSheet() {
        router.presentbottomSheet(fromProfile: false, controller: ConfirmationBottomSheetVC.self, viewModel: BottomSheetBaseViewModel.self, item: ConfirmationItem(confirmationCallBack: leavePage.self, confirmationTitle: nil, confirmationMessage: nil, confirmationBtnTitle: nil, confirmationImageName: nil))
    }
    
    private func leavePage(){
        self.router.dismiss()
        self.router.popBack()
    }
    
    // open Delegators Selection Sheet
    func  navigateToSendBackLevelsBottomSheet() {
        if (self.payload.value.actionId != nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.getSendBackLevels()
            }
        }
    }
    
    func selectLevel(item: ListModel){
        self.selectedlevel.value = item
        self.payload.value.pendingOnEmail = item.id
    }
    
    func multiSelectedItems(item: [ListModel]){}
    
    private func getSendBackLevels(){
        router.presentbottomSheet(fromProfile: false, controller: BaseList.self, viewModel: BaseListBottomSheetViewModel.self, item:
                                    BaseListItem(list: self.sendBackLevels.value, title: "Send back Levels".localized, type: .radio, currentSelectedItem: self.selectedlevel.value,isSingleSelection: true, selectedItem: selectLevel,multiSelectedItems: multiSelectedItems)
        )
        
    }
    
    
    //Open Success BottomSheet After Delegation
    private  func successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBackFunc, "Sent Back Successfully".localized, "Your task has been Sent back successfully".localized))
    }
    
    private func successCallBackFunc() {
        self.router.dismiss()
        self.router.popBack()
        self.successCallBack()
    }
    
    
    //requestId for test "f05bc8ee-b0f2-4e90-93ac-34db44c56c3e"
    // Endpoints
    func sendBackLevelsEndPoint() {
        self.showLoadingCerqel()
        sendBackRecipientsUseCase.excute(requestId: self.sendBackId ?? "").then{ (response) in
            self.sendBackLevels.value = response.result.data
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }
    
    /// Execute action in task details EndPoint
    func executeActionSendBack() {
        showLoadingCerqel()
        self.excuteActionUseCase.excute(payload: payload.value).then {
            (response) in
            self.hideLoadingCerqel()
            if (response.success ?? false){
                self.successBottomSheet()
            }
            else {
                self.showErrorAlert(message: response.message ?? "")
            }
            
        }.catch { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }.always {
            self.hideLoadingCerqel()
            
        }
        
    }
}
