//
//  ExcuteActionUseCase.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Promises


protocol ExcuteActionUseCase {
    func excute(payload: ExcuteActionPayload)  -> Promise<BaseSuccessResponse>
}

class ExcuteActionUseCaseImpl: ExcuteActionUseCase {
    
    private let repository: ExcuteActionRepo
    
    init(repository: ExcuteActionRepo = ExcuteActionRepoImp()) {
        self.repository = repository
    }
    
    func excute(payload: ExcuteActionPayload) -> Promise<BaseSuccessResponse> {
            return Promise<BaseSuccessResponse> { fulfill, reject in
                self.repository.excute(payload: payload).then { response in
                    fulfill(response)
                }.catch { error in
                    reject(error)
                }
        }
    }
    
}
