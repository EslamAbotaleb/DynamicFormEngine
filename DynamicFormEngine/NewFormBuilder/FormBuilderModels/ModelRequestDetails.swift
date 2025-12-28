//
//  ModelRequestDetails.swift
//
//
//  Created by Abdallah Elmahlawy on 12/30/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
import ObjectMapper

enum ViewFormType: /*Codable,*/ Mappable {
    case viewForm(ViewForm)
    case backwardViewForm([BackwardViewForm])

    // MARK: - Mappable Implementation

    init?(map: Map) {
        if let viewForm: ViewForm = try? map.value("viewForm") {
            self = .viewForm(viewForm)
            return
        }

        if let backwardViewForms: [BackwardViewForm] = try? map.value("backwardViewForm") {
            self = .backwardViewForm(backwardViewForms)
            return
        }

        return nil
    }

    mutating func mapping(map: Map) {
        switch self {
        case .viewForm(var viewForm):
            viewForm <- map["viewForm"]
            self = .viewForm(viewForm)
        case .backwardViewForm(var backwardViewForms):
            backwardViewForms <- map["backwardViewForm"]
            self = .backwardViewForm(backwardViewForms)
        }
    }
}

public struct ModelRequestDetailsData: /*Codable,*/Mappable {
    var id: String?
    var requestSubmissionMobileVisibilityAndroid : Bool?
    var status : Status?
    var isCompleted : Bool?
    var isWithdrawal : Bool?
    var serviceName : String?
    var serviceId : String?
    var previousActions : [PreviousActions]? = []
    var formCode : String?
    var itRequestId : String?
    var modifiedDate : String?
    var hasComments : Bool?
    var requestOrder : String?
    var createdDate : String?
    var employee : Employee?
    var attachments : [ReqDetailsAttachmentValue]? = []
    var isEditable : Bool?
    var isTaskEditable: Bool?
    var viewFromMobile : Bool?
    var displayServiceName : String?
    var requestSubmissionMobileVisibilityIos : Bool?
    var isReopenAllowed : Bool?
    var actions : [Action]? = []
    var bpmTaskId : String?
    var taskId: String?
    var viewForm: ViewForm?
    var actionsMobileVisibility : Bool?
    var serviceImage: String?
    var requestPendingOn: RequestPendingOn?
    var requestPendingOnText: String?
    var attachmentsCount: Int?
    var commentsCount: Int?
    var customerSystemCode: String?
    
    public  init?(map: Map) {}
    
//    init(id: String? = nil, requestSubmissionMobileVisibilityAndroid: Bool? = nil, status: Status? = nil, isCompleted: Bool? = nil, isWithdrawal: Bool? = nil, serviceName: String? = nil, serviceId: String? = nil, previousActions: [PreviousActions]? = nil, formCode: String? = nil, itRequestId: String? = nil, modifiedDate: String? = nil, hasComments: Bool? = nil, requestOrder: String? = nil, createdDate: String? = nil, employee: Employee? = nil, attachments: [ReqDetailsAttachmentValue]? = nil, isEditable: Bool? = nil, isTaskEditable: Bool? = nil, viewFromMobile: Bool? = nil, displayServiceName: String? = nil, requestSubmissionMobileVisibilityIos: Bool? = nil, isReopenAllowed: Bool? = nil, actions: [Action]? = nil, bpmTaskId: String? = nil, taskId: String? = nil, viewForm: ViewFormType? = nil, actionsMobileVisibility: Bool? = nil, serviceImage: String? = nil, requestPendingOn: RequestPendingOn? = nil, requestPendingOnText: String? = nil, attachmentsCount: Int? = nil, commentsCount: Int? = nil, customerSystemCode: String? = nil) {
//        self.id = id
//        self.requestSubmissionMobileVisibilityAndroid = requestSubmissionMobileVisibilityAndroid
//        self.status = status
//        self.isCompleted = isCompleted
//        self.isWithdrawal = isWithdrawal
//        self.serviceName = serviceName
//        self.serviceId = serviceId
//        self.previousActions = previousActions
//        self.formCode = formCode
//        self.itRequestId = itRequestId
//        self.modifiedDate = modifiedDate
//        self.hasComments = hasComments
//        self.requestOrder = requestOrder
//        self.createdDate = createdDate
//        self.employee = employee
//        self.attachments = attachments
//        self.isEditable = isEditable
//        self.isTaskEditable = isTaskEditable
//        self.viewFromMobile = viewFromMobile
//        self.displayServiceName = displayServiceName
//        self.requestSubmissionMobileVisibilityIos = requestSubmissionMobileVisibilityIos
//        self.isReopenAllowed = isReopenAllowed
//        self.actions = actions
//        self.bpmTaskId = bpmTaskId
//        self.taskId = taskId
//        self.viewForm = viewForm
//        self.actionsMobileVisibility = actionsMobileVisibility
//        self.serviceImage = serviceImage
//        self.requestPendingOn = requestPendingOn
//        self.requestPendingOnText = requestPendingOnText
//        self.attachmentsCount = attachmentsCount
//        self.commentsCount = commentsCount
//        self.customerSystemCode = customerSystemCode
//    }

    mutating public func mapping(map: Map) {
        id <- map["id"]
        requestSubmissionMobileVisibilityAndroid <- map["requestSubmissionMobileVisibilityAndroid"]
        status <- map["status"]
        isCompleted <- map["isCompleted"]
        isWithdrawal <- map["isWithdrawal"]
        serviceName <- map["serviceName"]
        serviceId <- map["serviceId"]
        previousActions <- map["previousActions"]
        formCode <- map["formCode"]
        itRequestId <- map["itRequestId"]
        modifiedDate <- map["modifiedDate"]
        hasComments <- map["hasComments"]
        requestOrder <- map["requestOrder"]
        createdDate <- map["createdDate"]
        employee <- map["employee"]
        attachments <- map["attachments"]
        isEditable <- map["isEditable"]
        viewFromMobile <- map["viewFromMobile"]
        displayServiceName <- map["displayServiceName"]
        requestSubmissionMobileVisibilityIos <- map["requestSubmissionMobileVisibilityIos"]
        isReopenAllowed <- map["isReopenAllowed"]
        actions <- map["actions"]
        bpmTaskId <- map["bpmTaskId"]
        viewForm <- map["viewForm"]
        actionsMobileVisibility <- map["actionsMobileVisibility"]
        serviceImage <- map["serviceImage"]
        requestPendingOn <- map["requestPendingOn"]
        requestPendingOnText <- map["requestPendingOnText"]
        attachmentsCount <- map["attachmentsCount"]
        commentsCount <- map["commentsCount"]
        customerSystemCode <- map["customerSystemCode"]
        isTaskEditable <- map["isTaskEditable"]
        taskId <- map["taskId"]
    }
}

//struct RequestPendingOn: Codable {
//    let id : String?
//    let name : String?
//    let pendingOnCode: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, pendingOnCode
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        pendingOnCode = try values.decodeIfPresent(String.self, forKey: .pendingOnCode)
//    }
//}

struct DropdownDefaultAnswerValue : Codable, FormValue {
    let key : String?
    let text : String?
    let selectedKey : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case text = "text"
        case selectedKey = "selectedKey"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        selectedKey = try values.decodeIfPresent(String.self, forKey: .selectedKey)
    }

}

struct FileUploadDefaultAnswerValue: Codable, FormValue {
        let fileId : String?
        let isSuccess : Bool?
        let isFaild : Bool?
        let fileName : String?
        let attachmentDisplaySize : String?
        let size : String?
        let fileUrl : String?
        let fileExtension : String?
        let isPublic : Bool?
        let url : String?

        enum CodingKeys: String, CodingKey {

            case fileId = "fileId"
            case isSuccess = "isSuccess"
            case isFaild = "isFaild"
            case fileName = "fileName"
            case attachmentDisplaySize = "attachmentDisplaySize"
            case size = "size"
            case fileUrl = "fileUrl"
            case fileExtension = "extension"
            case isPublic = "isPublic"
            case url = "url"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            fileId = try values.decodeIfPresent(String.self, forKey: .fileId)
            isSuccess = try values.decodeIfPresent(Bool.self, forKey: .isSuccess)
            isFaild = try values.decodeIfPresent(Bool.self, forKey: .isFaild)
            fileName = try values.decodeIfPresent(String.self, forKey: .fileName)
            attachmentDisplaySize = try values.decodeIfPresent(String.self, forKey: .attachmentDisplaySize)
            size = try values.decodeIfPresent(String.self, forKey: .size)
            fileUrl = try values.decodeIfPresent(String.self, forKey: .fileUrl)
            fileExtension = try values.decodeIfPresent(String.self, forKey: .fileExtension)
            isPublic = try values.decodeIfPresent(Bool.self, forKey: .isPublic)
            url = try values.decodeIfPresent(String.self, forKey: .url)
        }
}

//struct ViewForm : Codable {
//    let weight : Weight?
//    let rules : Rules?
//    let id : String?
//    let templateQuestionId : String?
//    let type : String?
//    let parentId : String?
//    let order : String?
//    let properties : Properties?
//    let RowIndex: String?
//    var visibilityPermissions: [String]?
//
//    enum CodingKeys: String, CodingKey {
//
//        case weight = "Weight"
//        case rules = "Rules"
//        case id = "Id"
//        case templateQuestionId = "TemplateQuestionId"
//        case type = "Type"
//        case parentId = "ParentId"
//        case order = "Order"
//        case properties = "Properties"
//        case RowIndex
//        case visibilityPermissions = "visibilityPermissions"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        weight = try values.decodeIfPresent(Weight.self, forKey: .weight)
//        rules = try values.decodeIfPresent(Rules.self, forKey: .rules)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        templateQuestionId = try values.decodeIfPresent(String.self, forKey: .templateQuestionId)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        parentId = try values.decodeIfPresent(String.self, forKey: .parentId)
//        order = try values.decodeIfPresent(String.self, forKey: .order)
//        properties = try values.decodeIfPresent(Properties.self, forKey: .properties)
//        RowIndex = try values.decodeIfPresent(String.self, forKey: .RowIndex)
//        visibilityPermissions = try values.decodeIfPresent([String].self, forKey: .visibilityPermissions)
//    }
//
//    init(weight: Weight?, rules: Rules?, id: String?, templateQuestionId: String?, type: String?, parentId: String?, order: String?, properties: Properties?, RowIndex: String?) {
//           self.weight = weight
//           self.rules = rules
//           self.id = id
//           self.templateQuestionId = templateQuestionId
//           self.type = type
//           self.parentId = parentId
//           self.order = order
//           self.properties = properties
//           self.RowIndex = RowIndex
//       }
//
//}


public struct Rules : Codable, Mappable {
    public var effectIn : [String]?
    public var dependOn : [String]?

    enum CodingKeys: String, CodingKey {
        case effectIn = "effectIn"
        case dependOn = "dependOn"
    }

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        effectIn <- map["effectIn"]
        dependOn <- map["dependOn"]
    }

    public init(effectIn: [String]? = nil, dependOn: [String]? = nil) {
        self.effectIn = effectIn
        self.dependOn = dependOn
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        effectIn = try values.decodeIfPresent([String].self, forKey: .effectIn)
        dependOn = try values.decodeIfPresent([String].self, forKey: .dependOn)
    }

}

public struct Weight : Codable, Mappable {
    public var value : Int?
//    var criteria : String?

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        value <- map["value"]
//        criteria <- map["criteria"]
    }

    enum CodingKeys: String, CodingKey {

        case value = "value"
//        case criteria = "criteria"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
//        criteria = try values.decodeIfPresent(String.self, forKey: .criteria)
    }
    
    public init(value: Int?) {
        self.value = value
    }

}


public struct Properties: Codable, Mappable {
    
    public var disabledMonths: String?
    public var placeholder: String?
    public var style: Style?
    public var sublabel: String?
    public var icon: String?
    public var defaultDateType: String?
    public var isVisibleInViewMode: Bool?
    public var dateFormat: String?
    public var dateSelectionMode: String?
    public var maximumTime: String?
    public var timeFormat: String?
    public var disabledDays: [Int]?
    public var minimumTime: String?
    public var required: Bool?
    public var maximumDate: String?
    public var defaultTimeType: String?
    public var dateTimeType: String?
    public var minimumDate: String?
    public var unique: String?
    public var localization: Localization?
    public var label: String?
    public var allowedDaysRange: Int?
    public var sendToBPM: Bool?
    public var validationType: String?
    public var disabledDates: [String]?
    public var tooltip: String?
    public var calendarType: String?
    public var defaultAnswer: DefaultAnswer?
    public var firstDayOfWeek: Int?
    public var options : [OptionsInProp]?
    public var isCollapsed: Bool?
    
    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        disabledMonths <- map["disabledMonths"]
        placeholder <- map["placeholder"]
        style <- map["style"]
        sublabel <- map["sublabel"]
        icon <- map["icon"]
        defaultDateType <- map["defaultDateType"]
        isVisibleInViewMode <- map["isVisibleInViewMode"]
        dateFormat <- map["dateFormat"]
        dateSelectionMode <- map["dateSelectionMode"]
        maximumTime <- map["maximumTime"]
        timeFormat <- map["timeFormat"]
        disabledDays <- map["disabledDays"]
        minimumTime <- map["minimumTime"]
        required <- map["required"]
        maximumDate <- map["maximumDate"]
        defaultTimeType <- map["defaultTimeType"]
        dateTimeType <- map["dateTimeType"]
        minimumDate <- map["minimumDate"]
        unique <- map["unique"]
        localization <- map["localization"]
        label <- map["label"]
        allowedDaysRange <- map["allowedDaysRange"]
        sendToBPM <- map["sendToBPM"]
        validationType <- map["validationType"]
        disabledDates <- map["disabledDates"]
        tooltip <- map["tooltip"]
        calendarType <- map["calendarType"]
        defaultAnswer <- map["defaultAnswer"]
        firstDayOfWeek <- map["firstDayOfWeek"]
        options <- map["options"]
        isCollapsed <- map["isCollapsed"]
    }
    
    enum CodingKeys: String, CodingKey {

        case disabledMonths = "disabledMonths"
        case placeholder = "placeholder"
        case style = "style"
        case sublabel = "sublabel"
        case icon = "icon"
        case defaultDateType = "defaultDateType"
        case isVisibleInViewMode = "isVisibleInViewMode"
        case dateFormat = "dateFormat"
        case dateSelectionMode = "dateSelectionMode"
        case maximumTime = "maximumTime"
        case timeFormat = "timeFormat"
        case disabledDays = "disabledDays"
        case minimumTime = "minimumTime"
        case required = "required"
        case maximumDate = "maximumDate"
        case defaultTimeType = "defaultTimeType"
        case dateTimeType = "dateTimeType"
        case minimumDate = "minimumDate"
        case unique = "unique"
        case localization = "localization"
        case label = "label"
        case allowedDaysRange = "allowedDaysRange"
        case sendToBPM = "sendToBPM"
        case isCollapsed = "isCollapsed"
        case validationType = "validationType"
        case disabledDates = "disabledDates"
        case tooltip = "tooltip"
        case calendarType = "calendarType"
        case defaultAnswer = "defaultAnswer"
        case firstDayOfWeek = "firstDayOfWeek"
        case options = "options"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        disabledMonths = try values.decodeIfPresent(String.self, forKey: .disabledMonths)
        placeholder = try values.decodeIfPresent(String.self, forKey: .placeholder)
        style = try values.decodeIfPresent(Style.self, forKey: .style)
        sublabel = try values.decodeIfPresent(String.self, forKey: .sublabel)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        defaultDateType = try values.decodeIfPresent(String.self, forKey: .defaultDateType)
        isVisibleInViewMode = try values.decodeIfPresent(Bool.self, forKey: .isVisibleInViewMode)
        dateFormat = try values.decodeIfPresent(String.self, forKey: .dateFormat)
        dateSelectionMode = try values.decodeIfPresent(String.self, forKey: .dateSelectionMode)
        maximumTime = try values.decodeIfPresent(String.self, forKey: .maximumTime)
        timeFormat = try values.decodeIfPresent(String.self, forKey: .timeFormat)
        disabledDays = try values.decodeIfPresent([Int].self, forKey: .disabledDays)
        minimumTime = try values.decodeIfPresent(String.self, forKey: .minimumTime)
        required = try values.decodeIfPresent(Bool.self, forKey: .required)
        maximumDate = try values.decodeIfPresent(String.self, forKey: .maximumDate)
        defaultTimeType = try values.decodeIfPresent(String.self, forKey: .defaultTimeType)
        dateTimeType = try values.decodeIfPresent(String.self, forKey: .dateTimeType)
        minimumDate = try values.decodeIfPresent(String.self, forKey: .minimumDate)
        unique = try values.decodeIfPresent(String.self, forKey: .unique)
        localization = try values.decodeIfPresent(Localization.self, forKey: .localization)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        allowedDaysRange = try values.decodeIfPresent(Int.self, forKey: .allowedDaysRange)
        sendToBPM = try values.decodeIfPresent(Bool.self, forKey: .sendToBPM)
        isCollapsed = try values.decodeIfPresent(Bool.self, forKey: .isCollapsed)
        validationType = try values.decodeIfPresent(String.self, forKey: .validationType)
        disabledDates = try values.decodeIfPresent([String].self, forKey: .disabledDates)
        tooltip = try values.decodeIfPresent(String.self, forKey: .tooltip)
        calendarType = try values.decodeIfPresent(String.self, forKey: .calendarType)
        defaultAnswer = try values.decodeIfPresent(DefaultAnswer.self, forKey: .defaultAnswer)
        firstDayOfWeek = try values.decodeIfPresent(Int.self, forKey: .firstDayOfWeek)
        options = try values.decodeIfPresent([OptionsInProp].self, forKey: .options)
    }


    init(label: String? = nil,
         disabledMonths: String? = nil,
         placeholder: String? = nil,
         style: Style? = nil,
         sublabel: String? = nil,
         icon: String? = nil,
         defaultDateType: String? = nil,
         isVisibleInViewMode: Bool? = nil,
         dateFormat: String? = nil,
         dateSelectionMode: String? = nil,
         maximumTime: String? = nil,
         timeFormat: String? = nil,
         disabledDays: [Int]? = nil,
         minimumTime: String? = nil,
         required: Bool? = nil,
         maximumDate: String? = nil,
         defaultTimeType: String? = nil,
         dateTimeType: String? = nil,
         minimumDate: String? = nil,
         unique: String? = nil,
         localization: Localization? = nil,
         allowedDaysRange: Int? = nil,
         sendToBPM: Bool? = nil,
         validationType: String? = nil,
         disabledDates: [String]? = nil,
         tooltip: String? = nil,
         calendarType: String? = nil,
         defaultAnswer: DefaultAnswer? = nil,
         firstDayOfWeek: Int? = nil,
         options: [OptionsInProp]? = nil,
         isCollapsed: Bool? = nil
    ) {
        
        self.label = label
        self.disabledMonths = disabledMonths
        self.placeholder = placeholder
        self.style = style
        self.sublabel = sublabel
        self.icon = icon
        self.defaultDateType = defaultDateType
        self.isVisibleInViewMode = isVisibleInViewMode
        self.dateFormat = dateFormat
        self.dateSelectionMode = dateSelectionMode
        self.maximumTime = maximumTime
        self.timeFormat = timeFormat
        self.disabledDays = disabledDays
        self.minimumTime = minimumTime
        self.required = required
        self.maximumDate = maximumDate
        self.defaultTimeType = defaultTimeType
        self.dateTimeType = dateTimeType
        self.minimumDate = minimumDate
        self.unique = unique
        self.localization = localization
        self.allowedDaysRange = allowedDaysRange
        self.sendToBPM = sendToBPM
        self.isCollapsed = isCollapsed
        self.validationType = validationType
        self.disabledDates = disabledDates
        self.tooltip = tooltip
        self.calendarType = calendarType
        self.defaultAnswer = defaultAnswer
        self.firstDayOfWeek = firstDayOfWeek
        self.options = options
    }
}


public struct Localization : Codable, Mappable {
    public var en : En?
    public var ar : Ar?

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        en <- map["en"]
        ar <- map["ar"]
    }
    
    enum CodingKeys: String, CodingKey {

        case en = "en"
        case ar = "ar"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        en = try values.decodeIfPresent(En.self, forKey: .en)
        ar = try values.decodeIfPresent(Ar.self, forKey: .ar)
    }

}


public struct En : Codable, Mappable {
    public var label : String?
    public var placeholder : String?
    public var sublabel : String?
    public var tooltip : String?
    public var fieldWarning : FieldWarning?
    
    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        label <- map["label"]
        placeholder <- map["placeholder"]
        sublabel <- map["sublabel"]
        tooltip <- map["tooltip"]
        fieldWarning <- map["fieldWarning"]
    }


    enum CodingKeys: String, CodingKey {

        case label = "label"
        case placeholder = "placeholder"
        case sublabel = "sublabel"
        case tooltip = "tooltip"
        case fieldWarning = "fieldWarning"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        placeholder = try values.decodeIfPresent(String.self, forKey: .placeholder)
        sublabel = try values.decodeIfPresent(String.self, forKey: .sublabel)
        tooltip = try values.decodeIfPresent(String.self, forKey: .tooltip)
        fieldWarning = try values.decodeIfPresent(FieldWarning.self, forKey: .fieldWarning)
    }

}

public struct Ar: Codable, Mappable {
    public var label : String?
    public var placeholder : String?
    public var sublabel : String?
    public var tooltip : String?
    public var fieldWarning : FieldWarning?

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        label <- map["label"]
        placeholder <- map["placeholder"]
        sublabel <- map["sublabel"]
        tooltip <- map["tooltip"]
        fieldWarning <- map["fieldWarning"]
    }

    enum CodingKeys: String, CodingKey {

        case label = "label"
        case placeholder = "placeholder"
        case sublabel = "sublabel"
        case tooltip = "tooltip"
        case fieldWarning = "fieldWarning"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        placeholder = try values.decodeIfPresent(String.self, forKey: .placeholder)
        sublabel = try values.decodeIfPresent(String.self, forKey: .sublabel)
        tooltip = try values.decodeIfPresent(String.self, forKey: .tooltip)
        fieldWarning = try values.decodeIfPresent(FieldWarning.self, forKey: .fieldWarning)
    }

}


public struct FieldWarning: Codable, Mappable {
    
    public var maximumDate : String?
    public var minimumDate : String?
    public var maximumTime : String?
    public var required : String?
    public var minimumTime : String?
    public var allowedDaysRange : String?
    
    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        maximumDate <- map["maximumDate"]
        minimumDate <- map["minimumDate"]
        maximumTime <- map["maximumTime"]
        required <- map["required"]
        minimumTime <- map["minimumTime"]
        allowedDaysRange <- map["allowedDaysRange"]
    }

    enum CodingKeys: String, CodingKey {

        case maximumDate = "maximumDate"
        case minimumDate = "minimumDate"
        case maximumTime = "maximumTime"
        case required = "required"
        case minimumTime = "minimumTime"
        case allowedDaysRange = "allowedDaysRange"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        maximumDate = try values.decodeIfPresent(String.self, forKey: .maximumDate)
        minimumDate = try values.decodeIfPresent(String.self, forKey: .minimumDate)
        maximumTime = try values.decodeIfPresent(String.self, forKey: .maximumTime)
        required = try values.decodeIfPresent(String.self, forKey: .required)
        minimumTime = try values.decodeIfPresent(String.self, forKey: .minimumTime)
        allowedDaysRange = try values.decodeIfPresent(String.self, forKey: .allowedDaysRange)
    }

}


public struct TaskSubmittedRowDataModel: Codable, Mappable {
    public var id: String?
    public var name: String?
    public var rowIndex: String?
    public var value: ValueType?
    public var subValues: ValueType?
    public var type: String?
    public var label: String?
    public var multipleValue: Bool?
    
    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        value <- map["value"]
        subValues <- map["subValues"]
        type <- map["type"]
        label <- map["label"]
        multipleValue <- map["multipleValue"]
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, rowIndex, value, subValues, type, label, multipleValue
    }
}

public struct DefaultAnswer: Codable, Mappable {
    
    public var id: String?
    public var name: String?
    public var rowIndex: String?
    public var defaultValue: ValueType?
    public var type : String?
    
    public init?(map: Map) {
    }
    
    public init(id: String?, name: String?, rowIndex: String?, defaultValue: ValueType?, type: String?) {
        self.id = id
        self.name = name
        self.rowIndex = rowIndex
        self.defaultValue = defaultValue
        self.type = type
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        rowIndex <- map["rowIndex"]
        defaultValue <- map["value"]
        type <- map["type"]
    
        var val: Any?
        val <- map["value"]
        if let str = val as? String {
            self.defaultValue = .singleString(str)
        } else if let strArr = val as? [String] {
            self.defaultValue = .listOfString(strArr)
        } else if let doubleVal = val as? Double {
            self.defaultValue = .singleDouble(doubleVal)
        } else if let boolVal = val as? Bool {
            self.defaultValue = .singleBool(boolVal)
        } else if let fileVal = val as? [AttachmentForDefault] {
            self.defaultValue = .file(fileVal)
        } else if let dict = val as? [[String : String]] {
            self.defaultValue = .dictionary(dict)
        }
        
    }

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case rowIndex
        case defaultValue = "value"
        case type = "type"
    }
    
}

public struct AttachmentForDefault: Mappable, Codable {
    public var fileId: String?
    public var attachmentDisplaySize: String?
    public var fileName: String?
    public var size: String?
    public var isPublic: Bool?
    public var fileExtension: String?
    public var isSuccess: Bool?
    public var previewUrl: String?{
        return  fileId != nil ? "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Preview/\(fileId!)" : nil
    }
    public var downloadUrl: String?{
        return  fileId != nil ? "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Download/\(fileId!)" : nil
    }
    public var fileUrl: String?{
        return  fileId != nil ? "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Preview/\(fileId!)" : nil
    }
    
    public init?(map: Map) {}
    
    public  init?(id: String, name: String, fileExtension: String) {
        self.fileId = id
        self.fileName = name
        self.fileExtension = fileExtension
    }

    public mutating func mapping(map: Map) {
        fileId <- map["attachmentId"]
        fileName <- map["attachmentName"]
        fileExtension <- map["attachmentExtension"]
        //        url <- map["url"]
        //        downloadUrl <- map["downloadUrl"]
        //        attachmentDisplaySize <- map["attachmentDisplaySize"]
        //        previewUrl <- map["previewUrl"]
        //        size <- map["size"]
        //        isPublic <- map["isPublic"]
        //        fileUrl <- map["fileUrl"]
        //        isSuccess <- map["isSuccess"]
    
    }
    
    enum CodingKeys: String, CodingKey {
        case fileId = "attachmentId"
        case fileName = "attachmentName"
        case fileExtension = "attachmentExtension"
    }

}

public class AttachmentForNewDefault: Mappable, Codable {
    public var attachmentName : String?
    public var attachmentId : String?
    public var attachmentExtension : String?
  
    required public init?(map: Map) {}

    public func mapping(map: Map) {
        attachmentName <- map["attachmentName"]
        attachmentId <- map["attachmentId"]
        attachmentExtension <- map["attachmentExtension"]
    }
    
    enum CodingKeys: String, CodingKey {
      case attachmentName = "attachmentName"
      case attachmentId = "attachmentId"
      case attachmentExtension = "attachmentExtension"

    }
    
}

public struct DDL: Codable, Mappable {
    public var Name: String?
    public var Value: [MCQOption]?
    public var RowIndex: String?
    public var Id: String?
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        Name <- map["name"]
        Value <- map["value"]
        RowIndex <- map["rowIndex"]
        Id <- map["id"]
    }

    enum CodingKeys: String, CodingKey {
        case Name = "name"
        case Value = "value"
        case RowIndex = "rowIndex"
        case Id = "id"
    }
}

public struct BCDDL: Codable, Mappable {
    public var Name: String?
    public var Value: [BCMCQOption]?
    public var RowIndex: String?
    public var Id: String?
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        Name <- map["Name"]
        Value <- map["Value"]
        RowIndex <- map["RowIndex"]
        Id <- map["Id"]
    }

    enum CodingKeys: String, CodingKey {
        case Name = "Name"
        case Value = "Value"
        case RowIndex = "RowIndex"
        case Id = "Id"
    }
}

public struct BCMCQOption: Codable, Mappable, Hashable {
    public var id: String?
    public var name: String?
    public var name_ar: String?
    
    public init?(map: Map) {
        //empty
    }
    
    public init(id: String?,other: Bool, name: String?, name_ar: String?) {
        self.id = id
        self.name = name
        self.name_ar = name_ar
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nameEN"
        case name_ar = "nameAR"
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["nameEN"]
        name_ar <- map["nameAR"]
    }
}


public struct Filee: Codable, Mappable {
    
    public var fileId: String?
    public var previewUrl: String?
    public var downloadUrl: String?
    public var isSuccess: Bool?
    public var fileName: String?
    public var attachmentDisplaySize: String?
    public var fileUrl: String?
    public var fileExtension: String?
    public var isPublic: Bool?
    public var url: String?
    
    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        fileId <- map["fileId"]
        previewUrl <- map["previewUrl"]
        downloadUrl <- map["downloadUrl"]
        isSuccess <- map["isSuccess"]
        fileName <- map["fileName"]
        attachmentDisplaySize <- map["attachmentDisplaySize"]
        fileUrl <- map["fileUrl"]
        fileExtension <- map["extension"]
        isPublic <- map["isPublic"]
        url <- map["url"]
    }

    enum CodingKeys: String, CodingKey {
        case downloadUrl
        case previewUrl
        case fileId
        case isSuccess
        case fileName
        case attachmentDisplaySize
        case fileUrl
        case fileExtension = "extension"
        case isPublic
        case url
    }
}

public enum ValueType: Codable, Mappable {
    
    case singleDouble(Double)
    case double([Double])
    case singleString(String)
    case listOfString([String])
    case dictionary([[String: String?]])
    case file([AttachmentForDefault])
    case empty
    case ddl(DDL)
    case bcDDL(BCDDL)
    case bool([Bool])
    case singleBool(Bool)
    
    // Codable initializer
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let singleString = try? container.decode(String.self) {
            self = .singleString(singleString)
        } else if let singleDouble = try? container.decode(Double.self) {
            self = .singleDouble(singleDouble)
        } else if let double = try? container.decode([Double].self) {
            self = .double(double)
        } else if let string = try? container.decode([String].self) {
            self = .listOfString(string)
        } else if let nestedString = try? container.decode([[String]].self) {
            let flattenedString = nestedString.flatMap { $0 }.joined(separator: ", ")
            self = .singleString(flattenedString)
        } else if let bcDdl = try? container.decode(BCDDL.self) {
            self = .bcDDL(bcDdl)
        } else if let ddl = try? container.decode(DDL.self) {
            self = .ddl(ddl)
        } else if let dict = try? container.decode([[String: String?]].self) {
            self = .dictionary(dict)
        } else if let file = try? container.decode([AttachmentForDefault].self) {
            self = .file(file)
        } else if let dict = try? container.decode([[String: String]].self) {
            self = .dictionary(dict)
        } else if let bool = try? container.decode([Bool].self) {
            self = .bool(bool)
        } else if let singleBool = try? container.decode(Bool.self) {
            self = .singleBool(singleBool)
        } else {
            self = .empty
        }
    }
    
    // Codable encoder
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .singleDouble(let singleDouble):
            try container.encode(singleDouble)
        case .double(let double):
            try container.encode(double)
        case .singleString(let singleString):
            try container.encode(singleString)
        case .listOfString(let string):
            try container.encode(string)
        case .bcDDL(let bcDDL):
            try container.encode(bcDDL)
        case .dictionary(let dict):
            try container.encode(dict)
        case .file(let file):
            try container.encode(file)
        case .ddl(let ddl):
            try container.encode(ddl)
        case .bool(let bool):
            try container.encode(bool)
        case .singleBool(let singleBool):
            try container.encode(singleBool)
        case .empty:
            return
        }
    }
    
    // Mappable initializer
    public init?(map: Map) {
        self = .empty
    }
    
    // Mappable mapping function
    public mutating func mapping(map: Map) {
        var singleString: String?
        var singleDouble: Double?
        var double: [Double]?
        var string: [String]?
        var dict: [[String: String?]]?
        var file: [AttachmentForDefault]?
        var bool: [Bool]?
        var singleBool: Bool?
        var bcDdl: BCDDL?
        var ddl: DDL?
        
        singleString <- map["Value"]
        singleDouble <- map["Value"]
        double <- map["Value"]
        string <- map["Value"]
        dict <- map["Value"]
        file <- map["Value"]
        bool <- map["Value"]
        singleBool <- map["Value"]
        bcDdl <- map["Value"]
        ddl <- map["Value"]
        
        if let value = singleString {
            self = .singleString(value)
        } else if let value = singleDouble {
            self = .singleDouble(value)
        } else if let value = double {
            self = .double(value)
        } else if let value = string {
            self = .listOfString(value)
        } else if let value = dict {
            self = .dictionary(value)
        } else if let value = file {
            self = .file(value)
        } else if let value = bool {
            self = .bool(value)
        } else if let value = singleBool {
            self = .singleBool(value)
        } else if let value = bcDdl {
            self = .bcDDL(value)
        } else if let value = ddl {
            self = .ddl(value)
        } else {
            self = .empty
        }
    }
}

struct MyValue: Codable {
    let arrRes: [String]
    let objRes: [[String:String]]

        // Where we determine what type the value is
        init(from decoder: Decoder) throws {
            let container =  try decoder.singleValueContainer()

            // Check for a boolean
            do {
                arrRes = try container.decode([String].self)
                objRes = [["":""]]
            } catch {
                // Check for an integer
                objRes = try container.decode([[String:String]].self)
                arrRes = [""]
            }
        }

        // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
        func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try arrRes ? container.encode(objRes) : container.encode([""])
        }
}


struct TakenAction : Codable, Mappable {
    var id : String?
    var name : String?
    var label : String?
    var actionTakenLabel : String?
    var styleCode : String?
    var buttonStyleCode : String?
    var actionCode : String?
    var isCommentRequired : Bool?
    var isAttachmentRequired : Bool?
    var isFormValidateBeforeExecuteActionRequired : Bool?

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        label <- map["label"]
        actionTakenLabel <- map["actionTakenLabel"]
        styleCode <- map["styleCode"]
        buttonStyleCode <- map["buttonStyleCode"]
        actionCode <- map["actionCode"]
        isCommentRequired <- map["isCommentRequired"]
        isAttachmentRequired <- map["isAttachmentRequired"]
        isFormValidateBeforeExecuteActionRequired <- map["isFormValidateBeforeExecuteActionRequired"]
    }
    
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

struct PreviousActions : Codable, Mappable {
    var id : String?
    var bpmTaskId : String?
    var taskOnUserName : String?
    var taskOnUserJobTitle : String?
    var taskOnUserDepartmentName : String?
    var taskOnUserPhoto : String?
    var taskOnUserEmail : String?
    var createdDate : String?
    var completionDate : String?
    var comment : String?
    var isCompleted : Bool?
    var takenAction : TakenAction?
    var attachments : [PreviousActionsAttachments]?
    var isExpanded = false
    var taskSubmittedRowDataJson: String?
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        bpmTaskId <- map["bpmTaskId"]
        taskOnUserName <- map["taskOnUserName"]
        taskOnUserJobTitle <- map["taskOnUserJobTitle"]
        taskOnUserDepartmentName <- map["taskOnUserDepartmentName"]
        taskOnUserPhoto <- map["taskOnUserPhoto"]
        taskOnUserEmail <- map["taskOnUserEmail"]
        createdDate <- map["createdDate"]
        completionDate <- map["completionDate"]
        comment <- map["comment"]
        isCompleted <- map["isCompleted"]
        takenAction <- map["takenAction"]
        attachments <- map["attachments"]
        taskSubmittedRowDataJson <- map["taskSubmittedRowDataJson"]
    }
    
    init?(map: Map) {}
    
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
        case taskSubmittedRowDataJson
    }
}

public struct PreviousActionsAttachments : Codable, Mappable {
    public var fileId : String?
    public var fileName : String?
    public var url : String?
    public var attExtension : String?
    public var size : Double?

    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        fileId <- map["fileId"]
        fileName <- map["fileName"]
        url <- map["url"]
        attExtension <- map["extension"]
        size <- map["size"]
    }

    enum CodingKeys: String, CodingKey {

        case fileId = "fileId"
        case fileName = "fileName"
        case url = "url"
        case attExtension = "extension"
        case size = "size"
    }

}

public struct ReqDetailsAttachmentValue : Codable, FormValue, Mappable {
    public var url : String?
    public var attachmentName : String?
    public var attachmentExtension : String?
    public var attachmentDisplaySize : String?
    public var fileId : String?
    public var size : String?

    public init?(map: Map) {}
    
    public init(url: String?, attachmentName: String?, attachmentExtension: String?, attachmentDisplaySize: String?, fileId: String?, size: String) {
        self.url = url
        self.attachmentName = attachmentName
        self.attachmentExtension = attachmentExtension
        self.attachmentDisplaySize = attachmentDisplaySize
        self.fileId = fileId
        self.size = size
    }

     mutating public func mapping(map: Map) {
        url <- map["url"]
        attachmentName <- map["fileName"]
        attachmentExtension <- map["extension"]
        attachmentDisplaySize <- map["attachmentDisplaySize"]
        fileId <- map["fileId"]
        size <- map["size"]
    }

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case attachmentName = "fileName"
        case attachmentExtension = "extension"
        case attachmentDisplaySize = "attachmentDisplaySize"
        case fileId
        case size
    }
}

public struct Action : Codable, Mappable {
    public var id : String?
    public var name : String?
    public var label : String?
    public var actionTakenLabel : String?
    public var styleCode : String?
    public var buttonStyleCode : String?
    public var actionCode : String?
    public var isCommentRequired : Bool?
    public var isFormValidateBeforeExecuteActionRequired : Bool?
    public var isAttachmentRequired : Bool?
    public var actionFormId: String?
    public var actionOrder: Int?
    public var buttonStyle : ButtonStyle?
    
    public init?(map: Map) {}

    public init(id: String?, name: String?, label: String?, actionTakenLabel: String?, styleCode: String?, buttonStyleCode: String?, actionCode: String?, isCommentRequired: Bool?, isFormValidateBeforeExecuteActionRequired: Bool?, isAttachmentRequired: Bool?, actionFormId: String?, actionOrder: Int?, buttonStyle : ButtonStyle?) {
        self.id = id
        self.name = name
        self.label = label
        self.actionTakenLabel = actionTakenLabel
        self.styleCode = styleCode
        self.buttonStyleCode = buttonStyleCode
        self.actionCode = actionCode
        self.isCommentRequired = isCommentRequired
        self.isFormValidateBeforeExecuteActionRequired = isFormValidateBeforeExecuteActionRequired
        self.isAttachmentRequired = isAttachmentRequired
        self.actionFormId = actionFormId
        self.actionOrder = actionOrder
        self.buttonStyle = buttonStyle
    }
    init() {
        self.id = ""
        self.name = ""
        self.label = ""
        self.actionTakenLabel = ""
        self.styleCode = ""
        self.buttonStyleCode = ""
        self.actionCode = ""
        self.isCommentRequired = false
        self.isFormValidateBeforeExecuteActionRequired = false
        self.isAttachmentRequired = false
        self.actionFormId = ""
        self.actionOrder = 0
        self.buttonStyle = ButtonStyle()
    }
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
        case actionFormId, actionOrder
        case buttonStyle
    }
    
    public mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        label <- map["label"]
        actionTakenLabel <- map["actionTakenLabel"]
        styleCode <- map["styleCode"]
        buttonStyleCode <- map["buttonStyleCode"]
        actionCode <- map["actionCode"]
        isCommentRequired <- map["isCommentRequired"]
        isFormValidateBeforeExecuteActionRequired <- map["isFormValidateBeforeExecuteActionRequired"]
        isAttachmentRequired <- map["isAttachmentRequired"]
        actionFormId <- map["actionFormId"]
        actionOrder <- map["actionOrder"]
        buttonStyle <- map["buttonStyle"]
    }
}

public struct ButtonStyle: Codable, Mappable {
    public var backgroundColor: String?
    public var borderColor: String?
    public var textColor: String?
    public var opacity: Float?
    
    public init() {
        self.backgroundColor = ""
        self.borderColor = ""
        self.textColor = ""
        self.opacity = 0.0
    
    }
    
    public init?(map: Map) {}

    public mutating func mapping(map: Map) {
        backgroundColor <- map["backgroundColor"]
        borderColor <- map["borderColor"]
        textColor <- map["textColor"]
        opacity <- map["opacity"]
    }
}

public struct FormWarningg: Codable, Mappable {
    var fieldValidation: FieldValidationn?
    var formValidation: FormValidationn?

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        fieldValidation <- map["fieldValidation"]
        formValidation <- map["formValidation"]
    }

    enum CodingKeys: String, CodingKey {
        case fieldValidation = "fieldValidation"
        case formValidation = "formValidation"
    }
}

struct Number: Codable, Mappable {
    var minimumDigits: String?
    var minimumValue: String?
    var maximumValue: String?
    var maximumDigits: String?
    var required: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        minimumDigits <- map["minimumDigits"]
        minimumValue <- map["minimumValue"]
        maximumValue <- map["maximumValue"]
        maximumDigits <- map["maximumDigits"]
        required <- map["required"]
    }

    enum CodingKeys: String, CodingKey {
        case minimumDigits = "minimumDigits"
        case minimumValue = "minimumValue"
        case maximumValue = "maximumValue"
        case maximumDigits = "maximumDigits"
        case required = "required"
    }
}

struct Input: Codable, Mappable {
    var url: String?
    var maximumWordLength: String?
    var alphabetic: String?
    var minimumCharacterLength: String?
    var alphanumeric: String?
    var custom: String?
    var maximumCharacterLength: String?
    var email: String?
    var numeric: String?
    var required: String?
    var minimumWordLength: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        url <- map["url"]
        maximumWordLength <- map["maximumWordLength"]
        alphabetic <- map["alphabetic"]
        minimumCharacterLength <- map["minimumCharacterLength"]
        alphanumeric <- map["alphanumeric"]
        custom <- map["custom"]
        maximumCharacterLength <- map["maximumCharacterLength"]
        email <- map["email"]
        numeric <- map["numeric"]
        required <- map["required"]
        minimumWordLength <- map["minimumWordLength"]
    }

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case maximumWordLength = "maximumWordLength"
        case alphabetic = "alphabetic"
        case minimumCharacterLength = "minimumCharacterLength"
        case alphanumeric = "alphanumeric"
        case custom = "custom"
        case maximumCharacterLength = "maximumCharacterLength"
        case email = "email"
        case numeric = "numeric"
        case required = "required"
        case minimumWordLength = "minimumWordLength"
    }
}

struct FileUpload: Codable, Mappable {
    var minAttachmentsDimentionWidth: String?
    var minAttachmentsDimentionHeigth: String?
    var maxAttachmentNumber: String?
    var attachmentExtensions: String?
    var required: String?
    var attachmentType: String?
    var maxAttachmentSize: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        minAttachmentsDimentionWidth <- map["minAttachmentsDimentionWidth"]
        minAttachmentsDimentionHeigth <- map["minAttachmentsDimentionHeigth"]
        maxAttachmentNumber <- map["maxAttachmentNumber"]
        attachmentExtensions <- map["attachmentExtensions"]
        required <- map["required"]
        attachmentType <- map["attachmentType"]
        maxAttachmentSize <- map["maxAttachmentSize"]
    }

    enum CodingKeys: String, CodingKey {
        case minAttachmentsDimentionWidth = "minAttachmentsDimentionWidth"
        case minAttachmentsDimentionHeigth = "minAttachmentsDimentionHeigth"
        case maxAttachmentNumber = "maxAttachmentNumber"
        case attachmentExtensions = "attachmentExtensions"
        case required = "required"
        case attachmentType = "attachmentType"
        case maxAttachmentSize = "maxAttachmentSize"
    }
}

struct Table: Codable, Mappable {
    var minRows: String?
    var maxRows: String?
    var required: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        minRows <- map["minRows"]
        maxRows <- map["maxRows"]
        required <- map["required"]
    }

    enum CodingKeys: String, CodingKey {
        case minRows = "minRows"
        case maxRows = "maxRows"
        case required = "required"
    }
}

struct MCQ: Codable, Mappable {
    var minimumNumberOfSelectedOptions: String?
    var maximumNumberOfSelectedOptions: String?
    var required: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        minimumNumberOfSelectedOptions <- map["minimumNumberOfSelectedOptions"]
        maximumNumberOfSelectedOptions <- map["maximumNumberOfSelectedOptions"]
        required <- map["required"]
    }

    enum CodingKeys: String, CodingKey {
        case minimumNumberOfSelectedOptions = "minimumNumberOfSelectedOptions"
        case maximumNumberOfSelectedOptions = "maximumNumberOfSelectedOptions"
        case required = "required"
    }
}

struct DateTime: Codable, Mappable {
    var maximumDate: String?
    var minimumDate: String?
    var maximumTime: String?
    var minimumTime: String?
    var allowedDaysRange: String?
    var required: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        maximumDate <- map["maximumDate"]
        minimumDate <- map["minimumDate"]
        maximumTime <- map["maximumTime"]
        minimumTime <- map["minimumTime"]
        allowedDaysRange <- map["allowedDaysRange"]
        required <- map["required"]
    }

    enum CodingKeys: String, CodingKey {
        case maximumDate = "maximumDate"
        case minimumDate = "minimumDate"
        case maximumTime = "maximumTime"
        case minimumTime = "minimumTime"
        case allowedDaysRange = "allowedDaysRange"
        case required = "required"
    }
}

struct Localizationn: Codable, Mappable {
    var en: LocalizationLanguage?
    var ar: LocalizationLanguage?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        en <- map["en"]
        ar <- map["ar"]
    }

    enum CodingKeys: String, CodingKey {
        case en = "en"
        case ar = "ar"
    }
}

struct LocalizationLanguage: Codable, Mappable {
    var fieldValidation: FieldValidationn?
    var formValidation: FormValidationn?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        fieldValidation <- map["fieldValidation"]
        formValidation <- map["formValidation"]
    }

    enum CodingKeys: String, CodingKey {
        case fieldValidation = "fieldValidation"
        case formValidation = "formValidation"
    }
}


struct Warningss: Codable, Mappable {
    var formWarning: FormWarningg?
    var localization: Localization?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        formWarning <- map["formWarning"]
        localization <- map["localization"]
    }

    enum CodingKeys: String, CodingKey {
        case formWarning = "formWarning"
        case localization = "localization"
    }
}

struct FieldValidationn: Codable, Mappable {
    var number: Number?
    var input: Input?
    var fileUpload: FileUpload?
    var table: Table?
    var mcq: MCQ?
    var required: String?
    var dateTime: DateTime?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        number <- map["number"]
        input <- map["input"]
        fileUpload <- map["fileUpload"]
        table <- map["table"]
        mcq <- map["mcq"]
        required <- map["required"]
        dateTime <- map["dateTime"]
    }

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case input = "input"
        case fileUpload = "fileUpload"
        case table = "table"
        case mcq = "mcq"
        case required = "required"
        case dateTime = "dateTime"
    }
}

struct FormValidationn: Codable, Mappable {
    var expired: String?
    var notAvailable: String?
    var multipleSubmission: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        expired <- map["expired"]
        notAvailable <- map["notAvailable"]
        multipleSubmission <- map["multipleSubmission"]
    }

    enum CodingKeys: String, CodingKey {
        case expired = "expired"
        case notAvailable = "notAvailable"
        case multipleSubmission = "multipleSubmission"
    }
}

struct RDRule: Codable, Mappable {
    var id: String?
    var disabled: Bool?
    var operation: RDRuleOperation?
    var ifConditions: [RDIfCondition]?
    var doActions: [RDDoAction]?
    var actionsCategory: String?
    var excludedViews: [ExcludedViews]?
    var isValid: Bool?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        disabled <- map["disabled"]
        operation <- map["operation"]
        ifConditions <- map["ifConditions"]
        doActions <- map["doActions"]
        actionsCategory <- map["actionsCategory"]
        excludedViews <- map["excludedViews"]
        isValid <- map["isValid"]
    }
    
    // Custom initializer for Decodable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        disabled = try container.decodeIfPresent(Bool.self, forKey: .disabled)
        operation = try container.decodeIfPresent(RDRuleOperation.self, forKey: .operation)
        ifConditions = try container.decodeIfPresent([RDIfCondition].self, forKey: .ifConditions)
        doActions = try container.decodeIfPresent([RDDoAction].self, forKey: .doActions)
        actionsCategory = try container.decodeIfPresent(String.self, forKey: .actionsCategory)
        excludedViews = try container.decodeIfPresent([ExcludedViews].self, forKey: .excludedViews)
        isValid = try container.decodeIfPresent(Bool.self, forKey: .isValid)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, disabled, operation, ifConditions, doActions, actionsCategory, isValid, excludedViews
    }
}

struct RDIfCondition: Codable, Mappable {
    var fieldId: String?
    var fieldState: RDFieldState?
    var target: String?
    var value: String?
    var quota: Int?
    
    init?(map: Map) {
        // empty
    }
    
    mutating func mapping(map: Map) {
        fieldId <- map["fieldId"]
        fieldState <- map["fieldState"]
        target <- map["target"]
        value <- map["value"]
        quota <- map["quota"]
    }
    
    // Custom initializer for Decodable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fieldId = try container.decodeIfPresent(String.self, forKey: .fieldId)
        fieldState = try container.decodeIfPresent(RDFieldState.self, forKey: .fieldState)
        target = try container.decodeIfPresent(String.self, forKey: .target)
        value = try container.decodeIfPresent(String.self, forKey: .value)
        quota = try container.decodeIfPresent(Int.self, forKey: .quota)
    }
    
    enum CodingKeys: String, CodingKey {
        case fieldId, fieldState, target, value, quota
    }
}

struct RDDoActionPayload: Codable {
    let id: String?
    let parameters: [String]?
}

struct RDDoAction: Mappable {
    var type: ActionType?
    var sourceFieldsIds: [String]?
    var targetFieldsIds: [String]?
    var expression: String?
    var actionImpact: String?
//    var payload: RDDoActionPayload?
    
    init?(map: Map) {
        // empty
    }
    
    mutating func mapping(map: Map) {
        type <- map["type"]
        sourceFieldsIds <- map["sourceFieldsIds"]
        targetFieldsIds <- map["targetFieldsIds"]
        expression <- map["expression"]
        actionImpact <- map["actionImpact"]
//        payload <- map["payload"]
    }
}


extension RDDoAction: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(ActionType.self, forKey: .type)
        sourceFieldsIds = try container.decodeIfPresent([String].self, forKey: .sourceFieldsIds)
        targetFieldsIds = try container.decodeIfPresent([String].self, forKey: .targetFieldsIds)
        expression = try container.decodeIfPresent(String.self, forKey: .expression)
        actionImpact = try container.decodeIfPresent(String.self, forKey: .actionImpact)
        
        // Custom decoding for payload
        // Implement custom decoding logic for different types of payload if necessary
//        payload = try container.decodeIfPresent(RDDoActionPayload.self, forKey: .payload)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(sourceFieldsIds, forKey: .sourceFieldsIds)
        try container.encodeIfPresent(targetFieldsIds, forKey: .targetFieldsIds)
        try container.encodeIfPresent(expression, forKey: .expression)
        try container.encodeIfPresent(actionImpact, forKey: .actionImpact)

        // Custom encoding for payload
        // Implement custom encoding logic for different types of payload if necessary
//        if let payload = payload as? String {
//            try container.encode(payload, forKey: .payload)
//        }
    }
    
    enum CodingKeys: String, CodingKey {
        case type, sourceFieldsIds, targetFieldsIds, expression, actionImpact, payload
    }
}

enum RDRuleOperation: String, Codable {
    case OR = "Any"
    case And = "All"
}

enum RDFieldState: String, Codable {
    case Filled = "Filled"
    case Empty = "Empty"
    case Equal = "Equal"
    case NotEqual = "NotEqual"
    case Contains = "Contains"
    case NotContain = "NotContain"
    case StartsWith = "StartsWith"
    case NotStartWith = "NotStartWith"
    case EndsWith = "EndsWith"
    case NotEndWith = "NotEndWith"
    case LessThan = "LessThan"
    case GreaterThan = "GreaterThan"
    case After = "After"
    case Before = "Before"
    case EqualToDate = "EqualToDate"
    case NotEqualToDate = "NotEqualToDate"
    case EqualToTime = "EqualToTime"
    case NotEqualToTime = "NotEqualToTime"
    case EqualToDay = "EqualToDay"
    case NotEqualToDay = "NotEqualToDay"
    case Include = "Include"
    case NotInclude = "NotInclude"
}

struct Schema: Codable, Mappable {
    var status : String?
    var fields : [Fields]?
    var templateId : String?
    var id : String?
    var campaign : Campaign?
    var title : String?
    var warnings : Warning?
    var properties : Properties?
    var settings : Settings?
    var rules : [RDRule]?//Rules?
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        status <- map["status"]
        fields <- map["fields"]
        templateId <- map["templateId"]
        id <- map["id"]
        title <- map["title"]
        properties <- map["properties"]
        rules <- map["rules"]
        warnings <- map["warnings"]
        settings <- map["settings"]
    }
    
    enum CodingKeys: String, CodingKey {

        case status = "status"
        case fields = "fields"
        case templateId = "templateId"
        case id = "id"
        case campaign = "campaign"
        case title = "title"
        case warnings = "warnings"
        case properties = "properties"
        case settings = "settings"
        case rules = "rules"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        fields = try values.decodeIfPresent([Fields].self, forKey: .fields)
        templateId = try values.decodeIfPresent(String.self, forKey: .templateId)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        campaign = try values.decodeIfPresent(Campaign.self, forKey: .campaign)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        warnings = try values.decodeIfPresent(Warning.self, forKey: .warnings)
        properties = try values.decodeIfPresent(Properties.self, forKey: .properties)
        settings = try values.decodeIfPresent(Settings.self, forKey: .settings)
        rules = try values.decodeIfPresent([RDRule].self, forKey: .rules)
    }

}

struct ViewForm : /*Codable,*/ Mappable {
    var schema : FormModel?
    var versionId : String?

//    enum CodingKeys: String, CodingKey {
//
//        case schema = "schema"
//        case versionId = "versionId"
//    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        schema <- map["schema"]
        versionId <- map["versionId"]
    }

//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        schema = try values.decodeIfPresent(FormModel.self, forKey: .schema)
//        versionId = try values.decodeIfPresent(String.self, forKey: .versionId)
//    }

}

public struct Fields : Codable, Mappable {
    public var weight : Weight?
    public var rules : Rules?
    public var id : String?
    public var templateQuestionId : String?
    public var type : String?
    public var parentId : String?
    public var order : String?
    public var properties : Properties?
    public var rowIndex: String?
    public var visibilityPermissions: [String]?
    public var isHidden: Bool {
        return !(visibilityPermissions?.contains("View") ?? true)
    }
    public var isInsideSection: Bool? = false
    public  init?(map: Map) {}

    mutating public func mapping(map: Map) {
        weight <- map["weight"]
        rules <- map["rules"]
        id <- map["id"]
        templateQuestionId <- map["templateQuestionId"]
        type <- map["type"]
        parentId <- map["parentId"]
        order <- map["order"]
        properties <- map["properties"]
        rowIndex <- map["rowIndex"]
        visibilityPermissions <- map["visibilityPermissions"]
    }
    
    
    enum CodingKeys: String, CodingKey {
        
        case weight = "weight"
        case rules = "rules"
        case id = "id"
        case templateQuestionId = "templateQuestionId"
        case type = "type"
        case parentId = "parentId"
        case order = "order"
        case properties = "properties"
        case rowIndex
        case visibilityPermissions = "visibilityPermissions"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weight = try values.decodeIfPresent(Weight.self, forKey: .weight)
        rules = try values.decodeIfPresent(Rules.self, forKey: .rules)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        templateQuestionId = try values.decodeIfPresent(String.self, forKey: .templateQuestionId)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        parentId = try values.decodeIfPresent(String.self, forKey: .parentId)
        order = try values.decodeIfPresent(String.self, forKey: .order)
        properties = try values.decodeIfPresent(Properties.self, forKey: .properties)
        rowIndex = try values.decodeIfPresent(String.self, forKey: .rowIndex)
        visibilityPermissions = try values.decodeIfPresent([String].self, forKey: .visibilityPermissions)
    }
    
    public init(weight: Weight?, rules: Rules?, id: String?, templateQuestionId: String?, type: String?, parentId: String?, order: String?, properties: Properties?, rowIndex: String?) {
        self.weight = weight
        self.rules = rules
        self.id = id
        self.templateQuestionId = templateQuestionId
        self.type = type
        self.parentId = parentId
        self.order = order
        self.properties = properties
        self.rowIndex = rowIndex
    }
    
}
