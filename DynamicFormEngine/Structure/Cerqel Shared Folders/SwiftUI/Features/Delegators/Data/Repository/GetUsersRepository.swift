//
//  GetUsersRepository.swift
//  CERQEL
//
//  Created by Youxel on 13/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import Promises

public class UsersRepoImp: UsersRepo {
    private var network: Network

    public init(network: Network = NetworkServiceImpl()) {
        self.network = network
    }

    
    public func getUsersList(payload: GetUsersPayload) -> Promise<BaseResponse<[UserDTO]>> {
        return self.network.callModel(BaseResponse<[UserDTO]>.self, endpoint: GetUsersEndPoint(payload: payload))
    }
    
}
