//
//  UsersUseCase.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import Promises

public protocol UserUseCase {
    func getUsersList(payload: GetUsersPayload) -> Promise<BaseResponse<[UserEntity]>>
}


public class UserUseCaseImpl: UserUseCase {
    
    private let repository: UsersRepo
    private let mapper: any EntityMapper

    public init(repository: UsersRepo = UsersRepoImp(), mapper: any EntityMapper = UsersListMapper()) {
        self.repository = repository
        self.mapper = mapper
    }

    public func getUsersList(payload: GetUsersPayload) -> Promise<BaseResponse<[UserEntity]>>{
        return Promise<BaseResponse<[UserEntity]>> { fulfill, reject in
            self.repository.getUsersList(payload: payload).then { response in
                let data = response.result.data
                let mappedEntities = self.map(list: data)
                let result = Result(totalCount: response.result.totalCount, data: mappedEntities, pagesCount: response.result.pagesCount)
                let baseResponse = BaseResponse(message: response.message, result: result)
                fulfill(baseResponse)
            }.catch { error in
             
            }
        }
    }
    
    public func map(list: [UserDTO]) -> [UserEntity] {
        return list.compactMap { item in
            if let entityMapper = mapper as? UsersListMapper {
                  return entityMapper.map(from: item)
              } else {
                  return nil
              }
        }

    }
}
