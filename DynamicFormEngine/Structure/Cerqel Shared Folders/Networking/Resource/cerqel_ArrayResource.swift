//
//  ArrayResource.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
public import RxSwift

public struct cerqel_ArrayResource<T: Codable> {
    public let objectType = T.self
    public let action: cerqel_APIActionDynamicForm
    
    public func parse(_ data: Data) -> Observable<[T]> {
        return Observable.create { observer in
            guard let result = try? JSONDecoder().decode([T].self, from: data) else {
                observer.onError(cerqel_CustomError(value: "Can't map response."))
                return Disposables.create()
            }
            
            observer.onNext(result)
            return Disposables.create()
        }
    }
}

//extension ArrayResource: Cacheable {
//    var cacheKey: String {
//        return "cache".appending(action.baseURL.appending(action.path))
//    }
//}
