//
//  SingleItemResource.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import RxSwift

struct cerqel_SingleItemResource<T: Codable> {
    let objectType = T.self
    let action: cerqel_APIActionDynamicForm
    
    func parse(_ data: Data) -> Observable<cerqel_CodableResponseObject<T>> {
        return Observable.create { observer in
            guard let result = try? JSONDecoder().decode(cerqel_CodableResponseObject<T>.self, from: data) else {
                observer.onError(cerqel_CustomError(value: "Can't map response."))
                return Disposables.create()
            }
            observer.onNext(result)
            return Disposables.create()
        }
    }
}

