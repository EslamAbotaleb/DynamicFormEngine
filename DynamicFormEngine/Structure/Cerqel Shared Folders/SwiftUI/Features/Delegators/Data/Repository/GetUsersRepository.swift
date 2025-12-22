//
//  GetUsersRepository.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import Promises

class UsersRepoImp: UsersRepo {
    private var network: Network

    init(network: Network = NetworkServiceImpl()) {
        self.network = network
    }

    
    func getUsersList(payload: GetUsersPayload) -> Promise<BaseResponse<[UserDTO]>> {
        return self.network.callModel(BaseResponse<[UserDTO]>.self, endpoint: GetUsersEndPoint(payload: payload))
    }
    
}
