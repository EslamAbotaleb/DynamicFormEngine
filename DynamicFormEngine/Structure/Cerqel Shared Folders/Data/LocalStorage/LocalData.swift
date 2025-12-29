//
//  LocalData.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

public protocol LocalData {
    func get(key: CachingKey) -> Any?
    func get<T>(object: T.Type, key: CachingKey) -> T? where T: Decodable
    func objectFor(key: CachingKey) -> Any?
    func set(_ value: Any?, key: CachingKey)
    func set<T>(object: T, key: CachingKey) where T: Encodable
    func setDeviceToken( key: CachingKey)
    func removeObject(key: CachingKey)
}
