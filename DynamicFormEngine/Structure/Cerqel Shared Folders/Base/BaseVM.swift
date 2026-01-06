//
//  BasePresenter.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit

internal class BaseVM: BaseViewModel, ObservableObject{
    
    override public init() {
        super.init()
        self.hydrate()
    }
    
    public func hydrate() {}
    
    private var errorMessage: DynamicObjects<String> = DynamicObjects("")
    private var alertMessage: DynamicObjects<String> = DynamicObjects("")
    public var isLoading: DynamicObjects<Bool> = DynamicObjects(false)
    public var hudLoading: DynamicObjects<Bool> = DynamicObjects(false)
    
    public func showSystemError(error: Error) {
        errorMessage.value = error.localizedDescription
    }
    
    public func showErrorAlert(message: String) {
        errorMessage.value = message
    }
    
    public func showSystemAlert(alert: String) {
        alertMessage.value = alert
    }
    
    public func implementErrorMessage(_ listener: @escaping (String) -> Void) {
        errorMessage.bind(listener)
    }
    
    public func implementAlert(_ listener: @escaping (String) -> Void) {
        alertMessage.bind(listener)
    }
    
    public func showHudLoading() {
        hudLoading.value = true
    }
    public func hideHudLoading() {
        hudLoading.value = false
    }
    public func showLoadingCerqel() {
        isLoading.value = true
    }
    
    public func hideLoadingCerqel() {
        isLoading.value = false
    }
    
    
}
