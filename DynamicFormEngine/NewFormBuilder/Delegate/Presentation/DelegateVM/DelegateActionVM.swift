//
//  DelegateActionVM.swift
//  CERQEL
//
//  Created by Youxel on 08/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift

class DelegateActionViewModel : BaseVM {
    var router: CerqelRouterManager
    var excuteActionUseCase: ExcuteActionUseCase
    
    var selectedUser: DynamicObjects<UserEntity?> = DynamicObjects(nil)
    var payload: DynamicObjects<ExcuteActionPayload> = DynamicObjects(ExcuteActionPayload())
    var view: UIViewController
    var successCallBack: SuccessCallBack
    
    init(view: UIViewController, router: CerqelRouterManager,excuteActionUseCase: ExcuteActionUseCase,successCallBack: @escaping SuccessCallBack) {
        self.view = view
        self.router = router
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
    func  navigateToDelegateBottomSheet() {
        if (payload.value.actionId != nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.presentDelegateBottomSheet()
            }
        }
    }
    
    private func presentDelegateBottomSheet() {
        let bottomSheetView = DelegatorNames(isSingleSelection: true, popupTitle: "Delegator Names".localized, selectedItemResult: { user in
            if let user = user {
                self.selectedUser.value = user
                self.payload.value.pendingOnEmail = self.selectedUser.value?.mail
            }
        },currentSelectedUsers: selectedUser.value != nil ? [selectedUser.value!] : nil)
        
        // Embed the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: bottomSheetView)
        
        // Set the modal presentation style to custom for a bottom sheet effect
        hostingController.modalPresentationStyle = .pageSheet
        if let sheet = hostingController.sheetPresentationController {
            sheet.detents = [.medium(), .large()] // Use .medium() or .large() for the height of the sheet
        }
        
        // Present the hosting controller
        view.present(hostingController, animated: true, completion: nil)
    }
    
    
    
    //Open Success BottomSheet After Delegation
    func successBottomSheet () {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBackFunc, "Delegated Successfully".localized, "\("The task has been delegated to".localized) \(selectedUser.value?.name ?? "_") \("successfully".localized)"))
    }
    
    private func successCallBackFunc() {
        self.router.dismiss()
        self.router.popBack()
        self.successCallBack()
    }
    
    
    /// Execute action in task details EndPoint
    func executeAction() {
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
