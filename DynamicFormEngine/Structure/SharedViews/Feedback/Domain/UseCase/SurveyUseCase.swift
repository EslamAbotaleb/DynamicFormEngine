//
//  SurveyUseCase.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 21/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Promises

protocol SurveyUseCase {
    func execute(surveyPayload: SurveyPayload) -> Promise<BaseSuccessResponse>
}


class SurveyUseCaseImpl: SurveyUseCase {
    
    private let repository: SurveyRepo

    init(repository: SurveyRepo = SurveyRepoImpl()) {
        self.repository = repository
    }
    
    func execute(surveyPayload: SurveyPayload) -> Promise<BaseSuccessResponse> {
        return Promise<BaseSuccessResponse> { fulfill, reject in
            self.repository.survey(surveyPayload: surveyPayload).then { response in
                fulfill(response)
            }.catch { error in
                reject(error)
            }
        }
    }
}
