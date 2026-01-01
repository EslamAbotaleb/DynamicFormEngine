//
//  ExcuteActionRepoImp.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
public import Promises


class ExcuteActionRepoImp: ExcuteActionRepo {
  
    private var network: Network
    
    init(network: Network = NetworkServiceImpl()) {
        self.network = network
    }
    
    func excute(payload: ExcuteActionPayload)  -> Promise<BaseSuccessResponse> {
        return self.network.callModel(BaseSuccessResponse.self, endpoint: ExcuteActionEndPoint(payload: payload))
    }
}
