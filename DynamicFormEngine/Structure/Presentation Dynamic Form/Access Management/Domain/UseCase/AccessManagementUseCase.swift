//
//  AccessManagementUseCase.swift
//  CERQEL
//
//  Created by Youxel on 15/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import Promises
protocol AccessManagementUseCase {
    func getTenantList() -> Promise<BaseResponse<[TenantListEntity]>>
}

class AccessManagementUseCaseImpl: AccessManagementUseCase {

    private let repository: AccessManagmentRepo
    private let mapper: any EntityMapper




    init(repository: AccessManagmentRepo = AccessManagmentRepoImpl(), mapper: any EntityMapper = TenantListMapper()) {
        self.repository = repository
        self.mapper = mapper
    }
    
    func getTenantList() -> Promise<BaseResponse<[TenantListEntity]>>{
        return Promise<BaseResponse<[TenantListEntity]>> { fulfill, reject in
            self.repository.getTenantList().then { response in
                let data = response.result.data
                let mappedEntities = self.map(list: data)
                let result = Result(totalCount: response.result.totalCount, data: mappedEntities, pagesCount: response.result.pagesCount)
                let baseResponse = BaseResponse(message: response.message, result: result)
                fulfill(baseResponse)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    func map(list: [TenantListDTO]) -> [TenantListEntity] {
        return list.compactMap { item in
            if let entityMapper = mapper as? TenantListMapper {
                  return entityMapper.map(from: item)
              } else {
                  return nil
              }
        }

    }



}
