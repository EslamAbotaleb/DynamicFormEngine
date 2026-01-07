//
//  ModelAnnouncement.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 11/8/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

public enum ModelImportancelLvlCerqel:  String, Codable {
    case low = "3"
    case meduim = "2"
    case high = "1"
}

public protocol ModuleResponse: Codable {
    var isBookmarked: Bool? { set get }
}


public struct ModelAnnouncementDataCerqel : Codable, ModuleResponse {
    public var isBookmarked: Bool? = false
        
    public var id : String?
    public var message : String?
    public var createdByImage : String?
    public var importance : String?
    public var importanceLevel : ModelImportancelLvlCerqel?
    public var dateCreated : String?
    public var dateModified: String?
    public var shareUrl : String?
    public var countOfView : Int?
    public var attachments : [AttachmentsCerqel]?
    public var nextID, previousID: String?
    public var title: String?
    public var isNew: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case message = "message"
        case createdByImage = "createdByImage"
        case importance = "importance"
        case importanceLevel = "importanceLevel"
        case dateCreated = "dateCreated"
        case dateModified = "dateModified"
        case isBookmarked = "isBookMarked"
        case shareUrl = "shareUrl"
        case countOfView = "countOfView"
        case attachments = "attachments"
        case nextID = "nextID"
        case previousID = "previousID"
        case title = "title"
        case isNew = "isNew"
    }

}


public struct AttachmentsCerqel : Codable {
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
    
    public init(attachmentID: String?, attachmentType: String?, attachmentURL: String?, attachmentName: String?, attachmentExtension: String?, attachmentSize: Double?, attachmentDisplaySize: String?) {
        self.attachmentID = attachmentID
        self.attachmentType = attachmentType
        self.attachmentURL = attachmentURL
        self.attachmentName = attachmentName
        self.attachmentExtension = attachmentExtension
        self.attachmentSize = attachmentSize
        self.attachmentDisplaySize = attachmentDisplaySize
    }
}
