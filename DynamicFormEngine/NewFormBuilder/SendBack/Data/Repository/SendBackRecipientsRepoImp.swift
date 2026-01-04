//
//  SendBackRecipientsRepoImp.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Promises


class SendBackRecipientsRepoImp: SendBackRecipientsRepo {

    private var network: Network
    
    init(network: Network = NetworkServiceImpl()) {
        self.network = network
    }
    
    func excute(requestId: String) -> Promise<BaseResponse<[SendBackRecipientsDTO]>> {
        return self.network.callModel(BaseResponse<[SendBackRecipientsDTO]>.self, endpoint: SendBackRecipientsEndPoint(id: requestId))
    }

    
}
