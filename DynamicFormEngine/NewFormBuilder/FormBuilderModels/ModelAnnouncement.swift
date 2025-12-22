//
//  ModelAnnouncement.swift
// 
//
//  Created by iSlam AbdelAziz on 11/8/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation

enum ModelImportancelLvl:  String, Codable {
    case low = "3"
    case meduim = "2"
    case high = "1"
}

struct ModelAnnouncementData : Codable {
    var id : String?
    var message : String?
    var createdByImage : String?
    var importance : String?
    var importanceLevel : ModelImportancelLvl?
    var dateCreated : String?
    var isBookMarked : Bool?
    var shareUrl : String?
    var countOfView : Int?
    var attachments : [Attachments]?
    var nextID, previousID: String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case message = "message"
        case createdByImage = "createdByImage"
        case importance = "importance"
        case importanceLevel = "importanceLevel"
        case dateCreated = "dateCreated"
        case isBookMarked = "isBookMarked"
        case shareUrl = "shareUrl"
        case countOfView = "countOfView"
        case attachments = "attachments"
        case nextID = "nextID"
        case  previousID = "previousID"
    }

    init() {
        id = nil
    }

}

struct Attachments : Codable {
    let attachmentID : String?
    let attachmentType : String?
    let attachmentURL : String?
    let attachmentName : String?
    let attachmentExtension : String?
    let attachmentSize : Double?
    let attachmentDisplaySize : String?

    enum CodingKeys: String, CodingKey {

        case attachmentID = "attachmentID"
        case attachmentType = "attachmentType"
        case attachmentURL = "attachmentURL"
        case attachmentName = "attachmentName"
        case attachmentExtension = "attachmentExtension"
        case attachmentSize = "attachmentSize"
        case attachmentDisplaySize = "attachmentDisplaySize"
    }


}
