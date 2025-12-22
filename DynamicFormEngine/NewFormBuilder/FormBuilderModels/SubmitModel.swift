//
//  SubmitModel.swift
//  CERQEL
//
//  Created by hassan elshaer on 03/06/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation

struct SubmitModel: Codable {
    var requestOrder: String
    var id: String
    var isEligableForSurvey: Bool
}
