//
//  ModelAnnouncement.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 11/8/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

enum ModelImportancelLvlCerqel:  String, Codable {
    case low = "3"
    case meduim = "2"
    case high = "1"
}

protocol ModuleResponse: Codable {
    var isBookmarked: Bool? { set get }
}


struct ModelAnnouncementDataCerqel : Codable, ModuleResponse {
    var isBookmarked: Bool? = false
        
    var id : String?
    var message : String?
    var createdByImage : String?
    var importance : String?
    var importanceLevel : ModelImportancelLvlCerqel?
    var dateCreated : String?
    var dateModified: String?
    var shareUrl : String?
    var countOfView : Int?
    var attachments : [AttachmentsCerqel]?
    var nextID, previousID: String?
    var title: String?
    var isNew: Bool?
    
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


struct AttachmentsCerqel : Codable {
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
