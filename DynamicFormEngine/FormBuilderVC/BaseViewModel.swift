//
//  BaseViewModel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/27/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import RxCocoa
internal import RxSwift

open class BaseViewModel {
    internal var errorsObservable: Observable<Error>!
    internal var errorsSubject = PublishSubject<Error>()
    
    internal var loadingObservable: Observable<BaseLoading>!
    internal let loadingSubject = PublishSubject<BaseLoading>()
    // this should be required by all
   public init() {
        self.errorsObservable = errorsSubject.asObservable()
        self.loadingObservable = loadingSubject.asObservable()
    }
}
