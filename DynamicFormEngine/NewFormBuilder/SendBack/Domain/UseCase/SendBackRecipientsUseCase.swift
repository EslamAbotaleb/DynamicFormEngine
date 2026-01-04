//
//  SendBackRecipientsUseCase.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Promises

protocol SendBackRecipientsUseCase {
    func excute(requestId: String) -> Promise<BaseResponse<[ListModel]>>
}


class SendBackRecipientsUseCaseImpl: SendBackRecipientsUseCase {
    
    private let repository: SendBackRecipientsRepo
    private let mapper: any EntityMapper
    
    init(repository: SendBackRecipientsRepo = SendBackRecipientsRepoImp(), mapper: any EntityMapper = SendBackRecipientsMapper()) {
        self.repository = repository
        self.mapper = mapper
    }
    
    func excute(requestId: String) -> Promise<BaseResponse<[ListModel]>> {
        return Promise<BaseResponse<[ListModel]>> { fulfill, reject in
            self.repository.excute(requestId: requestId).then { response in
                let res = response.result.data
                let mappedEntities = self.map(dto: res)
                let result = Result(totalCount: response.result.totalCount, data: mappedEntities, pagesCount: response.result.pagesCount)
                let baseResponse = BaseResponse(message: response.message, result: result)
                fulfill(baseResponse)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    func map(dto: [SendBackRecipientsDTO]) -> [ListModel] {
        return dto.compactMap { data in
            if let entityMapper = mapper as? SendBackRecipientsMapper {
                return entityMapper.map(from: data)
            } else {
                return nil
            }
        }
        
    }
    
    
}
