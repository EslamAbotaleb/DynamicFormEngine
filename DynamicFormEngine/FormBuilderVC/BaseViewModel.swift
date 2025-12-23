//
//  BaseViewModel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/27/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import RxCocoa
public import RxSwift

open class BaseViewModel {
    public var errorsObservable: Observable<Error>!
    public var errorsSubject = PublishSubject<Error>()
    
    public var loadingObservable: Observable<BaseLoading>!
    public let loadingSubject = PublishSubject<BaseLoading>()
    // this should be required by all
   public init() {
        self.errorsObservable = errorsSubject.asObservable()
        self.loadingObservable = loadingSubject.asObservable()
    }
}
