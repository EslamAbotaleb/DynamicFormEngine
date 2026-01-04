//
//  CerqelBaseViewModel.swift
//  CERQEL
//
//  Created by mac on 6/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
internal import RxCocoa
public import RxSwift

public class CerqelBaseViewModel {
    public var errorsObservable: Observable<Error>!
    public var errorsSubject = PublishSubject<Error>()
    
    private var alertMessage: DynamicObjects<String> = DynamicObjects("")
    
    public var loadingObservable: Observable<BaseLoading>!
    public let loadingSubject = PublishSubject<BaseLoading>()
    // this should be required by all
    public init() {
        self.errorsObservable = errorsSubject.asObservable()
        self.loadingObservable = loadingSubject.asObservable()
    }
    
    public func showSystemAlert(alert: String) {
        alertMessage.value = alert
    }
    
    public func implementAlert(_ listener: @escaping (String) -> Void) {
        alertMessage.bind(listener)
    }
}
