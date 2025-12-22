//
//  BaseViewModel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/27/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public class BaseViewModel {
    var errorsObservable: Observable<Error>!
    var errorsSubject = PublishSubject<Error>()
    
    var loadingObservable: Observable<BaseLoading>!
    let loadingSubject = PublishSubject<BaseLoading>()
    // this should be required by all
   init() {
        self.errorsObservable = errorsSubject.asObservable()
        self.loadingObservable = loadingSubject.asObservable()
    }
    
}
