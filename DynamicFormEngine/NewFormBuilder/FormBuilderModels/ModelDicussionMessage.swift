//
//  ModelDicussionMessage.swift
// 
//
//  Created by iSlam AbdelAziz on 1/27/21.
//  Copyright © 2021 All rights reserved.
//

import Foundation

struct ModelDicussionMessageData : Codable {
    let id : String?
    let requestId : String?
    let comment : String?
    let daysRequested : Int?
    let createdDate : String?
    let employee : Employee?
    let attachments : [dicussionAttachemnt]?

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


struct dicussionAttachemnt : Codable {
    let id : String?
    let fileId : String?
    let fileName : String?
    let url : String?
    let attExtension : String?
    let size : Double?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fileId = "fileId"
        case fileName = "fileName"
        case url = "url"
        case attExtension = "extension"
        case size = "size"
    }

}
