//
//  Codable+Helpers.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

extension Encodable {
    public func asDictionary() -> [String: Any] {
        let serialized = (try? JSONSerialization.jsonObject(with: self.encode(), options: .allowFragments)) ?? nil
        return serialized as? [String: Any] ?? [String: Any]()
    }
    
    public func encode() -> Data {
        return (try? JSONEncoder().encode(self)) ?? Data()
    }
}

extension Data {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        return (try? JSONDecoder().decode(T.self, from: self))
    }
}
