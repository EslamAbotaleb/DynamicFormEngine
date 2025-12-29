//
//  LocalDataManager.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

public enum CachingKey: String {
    case userId
    case userLoggedIn
    case fileLayout
    case userModel
    case watchedIntro
    case localCities
    case localCountries
    case providerTypes
    case deviceToken
    case recentSearch
    case recentLocationSearch
    case docRecentSearch
    case faqRecentSearch
    case knowledgeRecentSearch
    case servicesRecentSearch
    case globalSearchRecentSearch
    case employeeRecentSearch
    case tenantList
}

public class LocalDataImpl: LocalData {
    public init() {}
    
    public func objectFor(key: CachingKey) -> Any? {
         return UserDefaults.standard.object(forKey: key.rawValue)
    }
    

    // set primitive data type
    public func set(_ value: Any?, key: CachingKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    // set non primitive data type
    public func set<T>(object: T, key: CachingKey) where T: Encodable {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(object) {
            defaults.set(encoded, forKey: key.rawValue)
            defaults.synchronize()
        }
    }

    // get primitive data type
    public func get(key: CachingKey) -> Any? {
        if validate(key: key) {
            return UserDefaults.standard.value(forKey: key.rawValue)!
        }
        return nil
    }

    // get non primitive data type
    public func get<T>(object: T.Type, key: CachingKey) -> T? where T: Decodable {
        if validate(key: key) {
            if let objectData = UserDefaults.standard.data(forKey: key.rawValue),
                let value = try? JSONDecoder().decode(object.self, from: objectData) {
                return value
            }
        }
        return nil
    }

    public func setDeviceToken( key: CachingKey) {
        var fcm_token :String {
            return ""
//            return Messaging.messaging().fcmToken != nil ? Messaging.messaging().fcmToken! : ""
        }
        UserDefaults.standard.set(fcm_token, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    public func removeObject(key: CachingKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    private func validate(key: CachingKey) -> Bool {
        if UserDefaults.standard.value(forKey: key.rawValue) != nil {
            return true
        }
        return false
    }
}

