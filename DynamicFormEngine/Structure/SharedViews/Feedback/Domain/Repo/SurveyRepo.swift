//
//  SurveyRepo.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 21/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Promises

protocol SurveyRepo {
    func survey(surveyPayload: SurveyPayload) -> Promise<BaseSuccessResponse>
}
