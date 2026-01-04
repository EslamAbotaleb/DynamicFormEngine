//
//  ModelRequestDetails.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 12/30/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

public struct ReqDetailsAttachmentValueCerqel : Codable, FormValueCerqel {
    public let url : String?
    public let attachmentName : String?
    public let attachmentExtension : String?
    public let attachmentDisplaySize : String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case attachmentName = "attachmentName"
        case attachmentExtension = "attachmentExtension"
        case attachmentDisplaySize = "attachmentDisplaySize"
    }
}
