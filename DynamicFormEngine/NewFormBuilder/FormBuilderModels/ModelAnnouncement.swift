//
//  ModelAnnouncement.swift
// 
//
//  Created by iSlam AbdelAziz on 11/8/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation

public enum ModelImportancelLvl:  String, Codable {
    case low = "3"
    case meduim = "2"
    case high = "1"
}

public struct ModelAnnouncementData : Codable {
    public var id : String?
    public var message : String?
    public var createdByImage : String?
    public var importance : String?
    public var importanceLevel : ModelImportancelLvl?
    public var dateCreated : String?
    public var isBookMarked : Bool?
    public var shareUrl : String?
    public var countOfView : Int?
    public var attachments : [Attachments]?
    public var nextID, previousID: String?
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

    public init() {
        id = nil
    }

}

public struct Attachments : Codable {
    public let attachmentID : String?
    public let attachmentType : String?
    public let attachmentURL : String?
    public let attachmentName : String?
    public let attachmentExtension : String?
    public let attachmentSize : Double?
    public let attachmentDisplaySize : String?

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
