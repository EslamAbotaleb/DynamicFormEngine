//
//  CerqelBaseViewModel.swift
//  CERQEL
//
//  Created by mac on 6/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
public import RxCocoa
internal import RxSwift

class CerqelBaseViewModel {
    var errorsObservable: Observable<Error>!
    var errorsSubject = PublishSubject<Error>()
    
    private var alertMessage: DynamicObjects<String> = DynamicObjects("")
    
    var loadingObservable: Observable<BaseLoading>!
    let loadingSubject = PublishSubject<BaseLoading>()
    // this should be required by all
   init() {
        self.errorsObservable = errorsSubject.asObservable()
        self.loadingObservable = loadingSubject.asObservable()
    }
    
    func showSystemAlert(alert: String) {
        alertMessage.value = alert
    }
    
    func implementAlert(_ listener: @escaping (String) -> Void) {
        alertMessage.bind(listener)
    }
}
