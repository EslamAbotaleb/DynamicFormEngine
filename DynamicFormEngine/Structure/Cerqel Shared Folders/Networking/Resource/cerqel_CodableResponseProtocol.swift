//
//  CodableResponseObject.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import RxSwift
internal import Alamofire

protocol cerqel_CodableResponseDynamicFormProtocol: Decodable {
    func parse<T: Decodable>(_ data: Data) -> Observable<T>
    var action: cerqel_APIActionDynamicForm { get }
}
