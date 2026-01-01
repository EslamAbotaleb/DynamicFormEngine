//
//  SendBackRecipientsRepo.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
public import Promises


protocol SendBackRecipientsRepo {
    func excute(requestId: String) -> Promise<BaseResponse<[SendBackRecipientsDTO]>>
}

