//
//  CodableResponseObject.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class cerqel_CodableResponseObjectOther<T: Decodable, X: Decodable>: cerqel_CodableResponseObject<T> {
    // x = Other
    fileprivate(set) var other:X?


    private enum CodingKeys: String, CodingKey {

        case other
    }
    
    required init(from decoder:Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        other = try? values.decode(X.self, forKey: .other)
    }
    
    override init(action: cerqel_APIAction, keyResult: String = "result") {
        super.init(action: action, keyResult: keyResult)
    }
    
    
}
