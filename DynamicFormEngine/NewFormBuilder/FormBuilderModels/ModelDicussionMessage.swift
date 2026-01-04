//
//  ModelDicussionMessage.swift
// 
//
//  Created by iSlam AbdelAziz on 1/27/21.
//  Copyright © 2021 All rights reserved.
//

import Foundation

public struct ModelDicussionMessageData : Codable {
    public let id : String?
    public let requestId : String?
    public let comment : String?
    public let daysRequested : Int?
    public let createdDate : String?
    let employee : Employee?
    public let attachments : [dicussionAttachemnt]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case requestId = "requestId"
        case comment = "comment"
        case daysRequested = "daysRequested"
        case createdDate = "createdDate"
        case employee = "employee"
        case attachments = "attachments"
    }


}


public struct dicussionAttachemnt : Codable {
    public let id : String?
    public let fileId : String?
    public let fileName : String?
    public let url : String?
    public let attExtension : String?
    public let size : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fileId = "fileId"
        case fileName = "fileName"
        case url = "url"
        case attExtension = "extension"
        case size = "size"
    }

}
