//
//  ServiceSuccessModel.swift
//  CERQEL
//
//  Created by hassan elshaer on 02/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ServiceSuccessModel: Codable {
    let message: String?
    let success: Bool?
    let result: ServiceSuccessResult?
}

// MARK: - Result
struct ServiceSuccessResult: Codable {
    let data: ServiceSuccessDataClass?
}

// MARK: - DataClass
struct ServiceSuccessDataClass: Codable {
    let id, requestOrder: String?
    let isEligableForSurvey: Bool?
}
