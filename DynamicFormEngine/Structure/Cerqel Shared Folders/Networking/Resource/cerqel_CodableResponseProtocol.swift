//
//  CodableResponseObject.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
public import RxSwift
public import Alamofire

public protocol cerqel_CodableResponseProtocol: Decodable {
    func parse<T: Decodable>(_ data: Data) -> Observable<T>
    var action: cerqel_APIActionDynamicForm { get }
}
