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

class cerqel_CodableResponseObjectPagination<T: Decodable>: cerqel_CodableResponseObject<T> {
    fileprivate(set) var next:String?
    fileprivate(set) var previous:String?
    fileprivate(set) var count:Int?
    fileprivate(set) var currentPage:String?

    private enum CodingKeys: String, CodingKey {
        case next, previous, count
        case currentPage = "current_page"
    }
    
    required init(from decoder:Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        next = try? values.decode(String.self, forKey: .next)
        previous = try? values.decode(String.self, forKey: .previous)
        count = try? values.decode(Int.self, forKey: .count)
        currentPage = try? values.decode(String.self, forKey: .currentPage)
    }
    
    override init(action: cerqel_APIAction, keyResult: String = "result") {
        super.init(action: action, keyResult: keyResult)
    }
    
    
}
