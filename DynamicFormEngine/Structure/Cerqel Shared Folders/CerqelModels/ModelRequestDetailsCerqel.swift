//
//  ModelRequestDetails.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 12/30/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import ObjectMapper

struct ModelRequestDetailsDataCerqel : Codable {
    var requestId : String?
    var requestOrder : String?
    var bpmTaskId : String?
    var formCode : String?
    var formVersion : Int?
    var viewForm : ViewFormCerqel?
    var isCompleted : Bool?
    var hasAttachment : Bool?
    var hasComments : Bool?
    var viewFromMobile : Bool?
    var itRequestId : String?
    var createdDate : String?
    var employee : EmployeeCerqel?
    var serviceName : String?
    var requestSubmissionMobileVisibilityAndroid : Bool?
    var requestSubmissionMobileVisibilityIos : Bool?
    var actionsMobileVisibility : Bool?
    var actions : [ActionCerqel]?
    var attachments : [String]?
    var previousActions : [PreviousActionsCerqel]?
    var isReopenAllowed: Bool?
    var isWithdrawal: Bool?
    
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
    let id : String?
    let name : String?
    let label : String?
    let actionTakenLabel : String?
    let styleCode : String?
    let buttonStyleCode : String?
    let actionCode : String?
    let isCommentRequired : Bool?
    let isAttachmentRequired : Bool?
    let isFormValidateBeforeExecuteActionRequired : Bool?

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

public struct PreviousActionsCerqel : Codable {
    let id : String?
    let bpmTaskId : String?
    let taskOnUserName : String?
    let taskOnUserJobTitle : String?
    let taskOnUserDepartmentName : String?
    let taskOnUserPhoto : String?
    let taskOnUserEmail : String?
    let createdDate : String?
    let completionDate : String?
    let comment : String?
    let isCompleted : Bool?
    let takenAction : TakenActionCerqel?
    let attachments : [PreviousActionsAttachments]?
    var isExpanded = false
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
    var fileId : String?
    var fileName : String?
    var url : String?
    var attExtension : String?
    var size : Double?

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
    let formCode : String?
    let name : String?
    let version : Int?
    let controls : [ModelControlCerqel]?

    enum CodingKeys: String, CodingKey {

        case formCode = "formCode"
        case name = "name"
        case version = "version"
        case controls = "controls"
    }


}

public struct ReqDetailsAttachmentValueCerqel : Codable, FormValueCerqel {
    let url : String?
    let attachmentName : String?
    let attachmentExtension : String?
    let attachmentDisplaySize : String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case attachmentName = "attachmentName"
        case attachmentExtension = "attachmentExtension"
        case attachmentDisplaySize = "attachmentDisplaySize"
    }


}


public struct ActionCerqel : Codable {
    let id : String?
    let name : String?
    let label : String?
    let actionTakenLabel : String?
    let styleCode : String?
    let buttonStyleCode : String?
    let actionCode : String?
    let isCommentRequired : Bool?
    let isFormValidateBeforeExecuteActionRequired : Bool?
    let isAttachmentRequired : Bool?
    
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
