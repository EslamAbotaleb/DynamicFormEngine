//
//  ExcuteActionInterface.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Promises


protocol ExcuteActionRepo {
    func excute(payload: ExcuteActionPayload)  -> Promise<BaseSuccessResponse>
}
