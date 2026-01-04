//
//  ModelRequestDetails.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 12/30/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
internal import ObjectMapper

struct ModelRequestDetailsDataCerqel : Codable {
    public var requestId : String?
    public var requestOrder : String?
    public var bpmTaskId : String?
    public var formCode : String?
    public var formVersion : Int?
    public var viewForm : ViewFormCerqel?
    public var isCompleted : Bool?
    public var hasAttachment : Bool?
    public var hasComments : Bool?
    public var viewFromMobile : Bool?
    public var itRequestId : String?
    public var createdDate : String?
    public var employee : EmployeeCerqel?
    public var serviceName : String?
    public var requestSubmissionMobileVisibilityAndroid : Bool?
    public var requestSubmissionMobileVisibilityIos : Bool?
    public var actionsMobileVisibility : Bool?
    public var actions : [ActionCerqel]?
    public var attachments : [String]?
    public var previousActions : [PreviousActionsCerqel]?
    public var isReopenAllowed: Bool?
    public var isWithdrawal: Bool?
    
    enum CodingKeys: String, CodingKey {

        case requestId = "requestId"
        case requestOrder = "requestOrder"
        case bpmTaskId = "bpmTaskId"
        case formCode = "formCode"
        case formVersion = "formVersion"
        case viewForm = "viewForm"
        case isCompleted = "isCompleted"
        case hasAttachment = "hasAttachment"
        case hasComments = "hasComments"
        case viewFromMobile = "viewFromMobile"
        case itRequestId = "itRequestId"
        case createdDate = "createdDate"
        case employee = "employee"
        case serviceName = "serviceName"
        case requestSubmissionMobileVisibilityAndroid = "requestSubmissionMobileVisibilityAndroid"
        case requestSubmissionMobileVisibilityIos = "requestSubmissionMobileVisibilityIos"
        case actionsMobileVisibility = "actionsMobileVisibility"
        case actions = "actions"
        case attachments = "attachments"
        case previousActions = "previousActions"
        case isReopenAllowed = "isReopenAllowed"
        case isWithdrawal = "isWithdrawal"
    }
    
    public init() {
    }
}

public struct TakenActionCerqel : Codable {
    public let id : String?
    public let name : String?
    public let label : String?
    public let actionTakenLabel : String?
    public let styleCode : String?
    public let buttonStyleCode : String?
    public let actionCode : String?
    public let isCommentRequired : Bool?
    public let isAttachmentRequired : Bool?
    public let isFormValidateBeforeExecuteActionRequired : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case label = "label"
        case actionTakenLabel = "actionTakenLabel"
        case styleCode = "styleCode"
        case buttonStyleCode = "buttonStyleCode"
        case actionCode = "actionCode"
        case isCommentRequired = "isCommentRequired"
        case isAttachmentRequired = "isAttachmentRequired"
        case isFormValidateBeforeExecuteActionRequired = "isFormValidateBeforeExecuteActionRequired"
    }
}

struct PreviousActionsCerqel : Codable {
    public let id : String?
    public let bpmTaskId : String?
    public let taskOnUserName : String?
    public let taskOnUserJobTitle : String?
    public let taskOnUserDepartmentName : String?
    public let taskOnUserPhoto : String?
    public let taskOnUserEmail : String?
    public let createdDate : String?
    public let completionDate : String?
    public let comment : String?
    public let isCompleted : Bool?
    public let takenAction : TakenActionCerqel?
    public let attachments : [PreviousActionsAttachments]?
    public var isExpanded = false
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case bpmTaskId = "bpmTaskId"
        case taskOnUserName = "taskOnUserName"
        case taskOnUserJobTitle = "taskOnUserJobTitle"
        case taskOnUserDepartmentName = "taskOnUserDepartmentName"
        case taskOnUserPhoto = "taskOnUserPhoto"
        case taskOnUserEmail = "taskOnUserEmail"
        case createdDate = "createdDate"
        case completionDate = "completionDate"
        case comment = "comment"
        case isCompleted = "isCompleted"
        case takenAction = "takenAction"
        case attachments = "attachments"
    }

}

public struct PreviousActionsAttachmentsCerqel : Codable {
    public var fileId : String?
    public var fileName : String?
    public var url : String?
    public var attExtension : String?
    public var size : Double?

    enum CodingKeys: String, CodingKey {

        case fileId = "fileId"
        case fileName = "fileName"
        case url = "url"
        case attExtension = "extension"
        case size = "size"
    }
    public init() {
        
    }

    
}
public struct ViewFormCerqel : Codable {
    public let formCode : String?
    public let name : String?
    public let version : Int?
    public let controls : [ModelControlCerqel]?

    enum CodingKeys: String, CodingKey {

        case formCode = "formCode"
        case name = "name"
        case version = "version"
        case controls = "controls"
    }


}

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


public struct ActionCerqel : Codable {
    public let id : String?
    public let name : String?
    public let label : String?
    public let actionTakenLabel : String?
    public let styleCode : String?
    public let buttonStyleCode : String?
    public let actionCode : String?
    public let isCommentRequired : Bool?
    public let isFormValidateBeforeExecuteActionRequired : Bool?
    public let isAttachmentRequired : Bool?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case label = "label"
        case actionTakenLabel = "actionTakenLabel"
        case styleCode = "styleCode"
        case buttonStyleCode = "buttonStyleCode"
        case actionCode = "actionCode"
        case isCommentRequired = "isCommentRequired"
        case isFormValidateBeforeExecuteActionRequired = "isFormValidateBeforeExecuteActionRequired"
        case isAttachmentRequired = "isAttachmentRequired"
    }
}
