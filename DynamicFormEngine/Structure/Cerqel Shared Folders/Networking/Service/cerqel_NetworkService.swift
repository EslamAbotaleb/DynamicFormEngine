//
//  NetworkService.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import RxSwift

protocol cerqel_NetworkService {
    func load<T>(_ resource: T) -> Observable<T> where T : cerqel_CodableResponseProtocol
    func load<T>(_ resource: cerqel_ArrayResource<T>) -> Observable<[T]>
}
