//
//  TakeActionModel.swift
//  KAFDHUB
//
//  Created by Mohamed Nagi on 04/06/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation


//struct TakeActionResponse: Codable {
//    let callUpdateRequest: Bool?
//    let success: Bool?
//    let takeActionBody: TakeActionBody?
//
//    enum CodingKeys: String, CodingKey {
//        case callUpdateRequest, success
//        case takeActionBody = "body"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        success = try values.decodeIfPresent(Bool.self, forKey: .success)
//        callUpdateRequest = try values.decodeIfPresent(Bool.self, forKey: .callUpdateRequest)
//        takeActionBody = try values.decodeIfPresent(TakeActionBody.self, forKey: .takeActionBody)
//    }
//}

struct TakeActionResponse: Codable {
    let requestId : String?
    let statusCode : String?
    let pendingOn : String?
    let isRequestCompleted : String?
    let bpmProcessId : String?
    let isEditable : String?
    let isWithdrawal : String?
    let messageId : String?
    let itRequestId : String?
    let isReopenAllowed : String?

    enum CodingKeys: String, CodingKey {

        case requestId = "requestId"
        case statusCode = "statusCode"
        case pendingOn = "pendingOn"
        case isRequestCompleted = "isRequestCompleted"
        case bpmProcessId = "bpmProcessId"
        case isEditable = "isEditable"
        case isWithdrawal = "isWithdrawal"
        case messageId = "messageId"
        case itRequestId = "itRequestId"
        case isReopenAllowed = "isReopenAllowed"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
        statusCode = try values.decodeIfPresent(String.self, forKey: .statusCode)
        pendingOn = try values.decodeIfPresent(String.self, forKey: .pendingOn)
        isRequestCompleted = try values.decodeIfPresent(String.self, forKey: .isRequestCompleted)
        bpmProcessId = try values.decodeIfPresent(String.self, forKey: .bpmProcessId)
        isEditable = try values.decodeIfPresent(String.self, forKey: .isEditable)
        isWithdrawal = try values.decodeIfPresent(String.self, forKey: .isWithdrawal)
        messageId = try values.decodeIfPresent(String.self, forKey: .messageId)
        itRequestId = try values.decodeIfPresent(String.self, forKey: .itRequestId)
        isReopenAllowed = try values.decodeIfPresent(String.self, forKey: .isReopenAllowed)
    }

}
