//
//  AddToFavouritePayload.swift
//  CERQEL
//
//  Created by Youxel on 31/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public struct AddToFavouritePayload: Codable {
    public var serviceId: String?
    public var isFavorite: Bool?
    public init(serviceId: String? = nil, isFavorite: Bool? = nil) {
        self.serviceId = serviceId
        self.isFavorite = isFavorite
    }
    public init() {}
}
