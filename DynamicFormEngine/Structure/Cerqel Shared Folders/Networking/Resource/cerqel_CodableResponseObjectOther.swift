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

public class cerqel_CodableResponseObjectOther<T: Decodable, X: Decodable>: cerqel_CodableResponseObjectDynamicForm<T> {
    // x = Other
    fileprivate(set) public var other:X?


    private enum CodingKeys: String, CodingKey {

        case other
    }
    
    required public init(from decoder:Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        other = try? values.decode(X.self, forKey: .other)
    }
    
    override public init(action: cerqel_APIActionDynamicForm, keyResult: String = "result") {
        super.init(action: action, keyResult: keyResult)
    }
    
    
}
