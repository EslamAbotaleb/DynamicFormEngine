//
//  ModelRequestDetails.swift
//
//
//  Created by Mohamed Nagi on 4/9/24.
//  Copyright © 2020 All rights reserved.
//

import Foundation

struct BackwardModelRequestDetailsData : Codable {
    var id: String?
    var requestSubmissionMobileVisibilityAndroid : Bool?
    var status : Status?
    var isCompleted : Bool?
    var isWithdrawal : Bool?
    var serviceName : String?
    var serviceId : String?
    var formVersion : String?
    var previousActions : [PreviousActions]?
    var formCode : String?
    var itRequestId : String?
    var modifiedDate : String?
    var hasComments : Bool?
    var requestOrder : String?
    var requestId : String?
    var createdDate : String?
    var employee : Employee?
    var attachments : [BackwardReqDetailsAttachmentValue]?
    var isEditable : Bool?
    var viewFromMobile : Bool?
    var displayServiceName : String?
    var requestSubmissionMobileVisibilityIos : Bool?
    var isReopenAllowed : Bool?
    var actions : [Action]?
    var bpmTaskId : String?
    var viewForm : [BackwardViewForm]?
    var actionsMobileVisibility : Bool?
    var serviceImage: String?
    var requestPendingOn: BackwardRequestPendingOn?
    var requestPendingOnText: String?
    var attachmentsCount: Int?
    var commentsCount: Int?
    var customerSystemCode: String?
    var IsEditable: Bool?

    enum CodingKeys: String, CodingKey {
        case commentsCount,attachmentsCount,id
        case requestSubmissionMobileVisibilityAndroid = "requestSubmissionMobileVisibilityAndroid"
        case status = "status"
        case isCompleted = "isCompleted"
        case isWithdrawal = "isWithdrawal"
        case serviceName = "serviceName"
        case serviceId = "serviceId"
        case formVersion = "formVersion"
        case previousActions = "previousActions"
        case formCode = "formCode"
        case itRequestId = "itRequestId"
        case modifiedDate = "modifiedDate"
        case hasComments = "hasComments"
        case requestOrder = "requestOrder"
        case requestId = "requestId"
        case createdDate = "createdDate"
        case employee = "employee"
        case attachments = "attachments"
        case isEditable = "isEditable"
        case viewFromMobile = "viewFromMobile"
        case displayServiceName = "displayServiceName"
        case requestSubmissionMobileVisibilityIos = "requestSubmissionMobileVisibilityIos"
        case isReopenAllowed = "isReopenAllowed"
        case actions = "actions"
        case bpmTaskId = "bpmTaskId"
        case viewForm = "viewForm"
        case actionsMobileVisibility = "actionsMobileVisibility"
        case serviceImage
        case requestPendingOnText
        case requestPendingOn, customerSystemCode, IsEditable
    }

//    init(){}
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestSubmissionMobileVisibilityAndroid = try values.decodeIfPresent(Bool.self, forKey: .requestSubmissionMobileVisibilityAndroid)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        status = try values.decodeIfPresent(Status.self, forKey: .status)
        isCompleted = try values.decodeIfPresent(Bool.self, forKey: .isCompleted)
        isWithdrawal = try values.decodeIfPresent(Bool.self, forKey: .isWithdrawal)
        serviceName = try values.decodeIfPresent(String.self, forKey: .serviceName)
        serviceId = try values.decodeIfPresent(String.self, forKey: .serviceId)
        formVersion = try values.decodeIfPresent(String.self, forKey: .formVersion)
        previousActions = try values.decodeIfPresent([PreviousActions].self, forKey: .previousActions)
        formCode = try values.decodeIfPresent(String.self, forKey: .formCode)
        itRequestId = try values.decodeIfPresent(String.self, forKey: .itRequestId)
        modifiedDate = try values.decodeIfPresent(String.self, forKey: .modifiedDate)
        hasComments = try values.decodeIfPresent(Bool.self, forKey: .hasComments)
        requestOrder = try values.decodeIfPresent(String.self, forKey: .requestOrder)
        requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        employee = try values.decodeIfPresent(Employee.self, forKey: .employee)
        attachments = try values.decodeIfPresent([BackwardReqDetailsAttachmentValue].self, forKey: .attachments)
        isEditable = try values.decodeIfPresent(Bool.self, forKey: .isEditable)
        viewFromMobile = try values.decodeIfPresent(Bool.self, forKey: .viewFromMobile)
        displayServiceName = try values.decodeIfPresent(String.self, forKey: .displayServiceName)
        requestSubmissionMobileVisibilityIos = try values.decodeIfPresent(Bool.self, forKey: .requestSubmissionMobileVisibilityIos)
        isReopenAllowed = try values.decodeIfPresent(Bool.self, forKey: .isReopenAllowed)
        actions = try values.decodeIfPresent([Action].self, forKey: .actions)
        bpmTaskId = try values.decodeIfPresent(String.self, forKey: .bpmTaskId)
        viewForm = try values.decodeIfPresent([BackwardViewForm].self, forKey: .viewForm)
        actionsMobileVisibility = try values.decodeIfPresent(Bool.self, forKey: .actionsMobileVisibility)
        serviceImage = try values.decodeIfPresent(String.self, forKey: .serviceImage)
        requestPendingOnText = try values.decodeIfPresent(String.self, forKey: .requestPendingOnText)
        requestPendingOn = try values.decodeIfPresent(BackwardRequestPendingOn.self, forKey: .requestPendingOn)
        attachmentsCount = try values.decodeIfPresent(Int.self, forKey: .attachmentsCount)
        commentsCount = try values.decodeIfPresent(Int.self, forKey: .commentsCount)
        customerSystemCode = try values.decodeIfPresent(String.self, forKey: .customerSystemCode)
        IsEditable = try values.decodeIfPresent(Bool.self, forKey: .IsEditable)
    }

}

struct BackwardRequestPendingOn: Codable {
    let id : String?
    let name : String?
    let pendingOnCode: String?

    enum CodingKeys: String, CodingKey {
        case id, name, pendingOnCode
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pendingOnCode = try values.decodeIfPresent(String.self, forKey: .pendingOnCode)
    }
}

struct BackwardDropdownDefaultAnswerValue : Codable, FormValue {
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

struct BackwardFileUploadDefaultAnswerValue: Codable, FormValue {
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

struct BackwardViewForm: Codable, Mappable {
    var weight: BackwardWeight?
    var rules: BackwardRules?
    var id: String?
    var templateQuestionId: String?
    var type: String?
    var parentId: String?
    var order: String?
    var properties: BackwardProperties?
    var rowIndex: String?
    var visibilityPermissions: [String]?
    
    // Computed property for visibility
    var isHidden: Bool {
        return !(visibilityPermissions?.contains("View") ?? true)
    }
    
    // MARK: - Codable Implementation
    
    enum CodingKeys: String, CodingKey {
        case weight = "Weight"
        case rules = "Rules"
        case id = "Id"
        case templateQuestionId = "TemplateQuestionId"
        case type = "Type"
        case parentId = "ParentId"
        case order = "Order"
        case properties = "Properties"
        case rowIndex = "RowIndex"
        case visibilityPermissions = "VisibilityPermissions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weight = try values.decodeIfPresent(BackwardWeight.self, forKey: .weight)
        rules = try values.decodeIfPresent(BackwardRules.self, forKey: .rules)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        templateQuestionId = try values.decodeIfPresent(String.self, forKey: .templateQuestionId)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        parentId = try values.decodeIfPresent(String.self, forKey: .parentId)
        order = try values.decodeIfPresent(String.self, forKey: .order)
        properties = try values.decodeIfPresent(BackwardProperties.self, forKey: .properties)
        rowIndex = try values.decodeIfPresent(String.self, forKey: .rowIndex)
        visibilityPermissions = try values.decodeIfPresent([String].self, forKey: .visibilityPermissions)
    }
    
    // Custom init method
    init(weight: BackwardWeight?, rules: BackwardRules?, id: String?, templateQuestionId: String?, type: String?, parentId: String?, order: String?, properties: BackwardProperties?, rowIndex: String?) {
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
    
    // MARK: - Mappable Implementation
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        weight               <- map["Weight"]
        rules                <- map["Rules"]
        id                   <- map["Id"]
        templateQuestionId    <- map["TemplateQuestionId"]
        type                 <- map["Type"]
        parentId             <- map["ParentId"]
        order                <- map["Order"]
        properties           <- map["Properties"]
        rowIndex             <- map["RowIndex"]
        visibilityPermissions <- map["VisibilityPermissions"]
    }
}

extension BackwardViewForm {
    func toFields() -> Fields {
        return Fields(
            weight: self.weight?.toWeight(),  // Convert BackwardWeight to Weight
            rules: self.rules?.toRules(),     // Convert BackwardRules to Rules
            id: self.id,
            templateQuestionId: self.templateQuestionId,
            type: self.type,
            parentId: self.parentId,
            order: self.order,
            properties: self.properties?.toProperties(),  // Convert BackwardProperties to Properties
            rowIndex: self.rowIndex
        )
    }
    
//    func toField() -> Field {
////        return Field(
////            id = self.id,
////            type = self.type,
////            subType = self.subType,
////            paragraphSubType = self.paragraphSubType,
//////            paragraphStyle = self.paragraphStyle,
//////            icon = self.icon,
////            parentId = self.parentId,
////            rowIndex = self.rowIndex,
////            order = self.order,
////            templateQuestionId = self.templateQuestionId,
////            properties =  self.properties,
//////            answer = self.answer
////            defualtSummaryAnswer = self.defualtSummaryAnswer,
////            defualtTabldItemsSummaryAnswer = self.defualtTabldItemsSummaryAnswer,
////            fieldRules = self.fieldRules,
////            visibilityPermissions = self.visibilityPermissions,
////        )
//    }
}

extension Array where Element == BackwardViewForm {
    func toFieldsArray() -> [Fields] {
        return self.map { $0.toFields() }
    }
    
//    func toFieldsArray() -> [Fields] {
//        return self.map { $0.toFields() }
//    }
}

struct BackwardRules: Codable, Mappable {
    var effectIn: [String]?
    var dependOn: [String]?
    
    // MARK: - Codable Implementation
    
    enum CodingKeys: String, CodingKey {
        case effectIn = "EffectIn"
        case dependOn = "DependOn"
    }
    
    init(effectIn: [String]? = nil, dependOn: [String]? = nil) {
        self.effectIn = effectIn
        self.dependOn = dependOn
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        effectIn = try values.decodeIfPresent([String].self, forKey: .effectIn)
        dependOn = try values.decodeIfPresent([String].self, forKey: .dependOn)
    }
    
    // MARK: - Mappable Implementation
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        effectIn  <- map["EffectIn"]
        dependOn  <- map["DependOn"]
    }
}

extension BackwardRules {
    func toRules() -> Rules {
        return Rules(
            effectIn: self.effectIn,
            dependOn: self.dependOn
        )
    }
}

import ObjectMapper

struct BackwardWeight: Codable, Mappable {
    var value: Int?
    var criteria: String?
    
    // MARK: - Codable Implementation
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case criteria = "Criteria"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        criteria = try values.decodeIfPresent(String.self, forKey: .criteria)
    }
    
    // MARK: - Mappable Implementation
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        value      <- map["Value"]
        criteria   <- map["Criteria"]
    }
    
    // Custom initializer for convenience
    init(value: Int?, criteria: String?) {
        self.value = value
        self.criteria = criteria
    }
}

extension BackwardWeight {
    func toWeight() -> Weight {
        return Weight(value: self.value)
    }
}

struct BackwardProperties: Codable, Mappable {
    var disabledMonths: String?
    var placeholder: String?
    var style: Style?
    var sublabel: String?
    var icon: String?
    var defaultDateType: String?
    var isVisibleInViewMode: Bool?
    var dateFormat: String?
    var dateSelectionMode: String?
    var maximumTime: String?
    var timeFormat: String?
    var disabledDays: [Int]?
    var minimumTime: String?
    var required: Bool?
    var maximumDate: String?
    var defaultTimeType: String?
    var dateTimeType: String?
    var minimumDate: String?
    var unique: String?
    var localization: Localization?
    var label: String?
    var allowedDaysRange: Int?
    var sendToBPM: Bool?
    var validationType: String?
    var disabledDates: [String]?
    var tooltip: String?
    var calendarType: String?
    var defaultAnswer: BackwardDefaultAnswer?
    var firstDayOfWeek: Int?
    var isCollapsed: Bool? = true
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case disabledMonths = "DisabledMonths"
        case placeholder = "Placeholder"
        case style = "Style"
        case sublabel = "Sublabel"
        case icon = "Icon"
        case defaultDateType = "DefaultDateType"
        case isVisibleInViewMode = "IsVisibleInViewMode"
        case dateFormat = "DateFormat"
        case dateSelectionMode = "DateSelectionMode"
        case maximumTime = "MaximumTime"
        case timeFormat = "TimeFormat"
        case disabledDays = "DisabledDays"
        case minimumTime = "MinimumTime"
        case required = "Required"
        case maximumDate = "MaximumDate"
        case defaultTimeType = "DefaultTimeType"
        case dateTimeType = "DateTimeType"
        case minimumDate = "MinimumDate"
        case unique = "Unique"
        case localization = "Localization"
        case label = "Label"
        case allowedDaysRange = "AllowedDaysRange"
        case sendToBPM = "SendToBPM"
        case validationType = "ValidationType"
        case disabledDates = "DisabledDates"
        case tooltip = "Tooltip"
        case calendarType = "CalendarType"
        case defaultAnswer = "DefaultAnswer"
        case firstDayOfWeek = "FirstDayOfWeek"
    }
    
    init(from decoder: Decoder) throws {
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
        validationType = try values.decodeIfPresent(String.self, forKey: .validationType)
        disabledDates = try values.decodeIfPresent([String].self, forKey: .disabledDates)
        tooltip = try values.decodeIfPresent(String.self, forKey: .tooltip)
        calendarType = try values.decodeIfPresent(String.self, forKey: .calendarType)
        defaultAnswer = try values.decodeIfPresent(BackwardDefaultAnswer.self, forKey: .defaultAnswer)
        firstDayOfWeek = try values.decodeIfPresent(Int.self, forKey: .firstDayOfWeek)
    }
    
    // MARK: - Mappable Implementation
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        disabledMonths      <- map["DisabledMonths"]
        placeholder         <- map["Placeholder"]
        style               <- map["Style"]
        sublabel            <- map["Sublabel"]
        icon                <- map["Icon"]
        defaultDateType     <- map["DefaultDateType"]
        isVisibleInViewMode <- map["IsVisibleInViewMode"]
        dateFormat          <- map["DateFormat"]
        dateSelectionMode   <- map["DateSelectionMode"]
        maximumTime         <- map["MaximumTime"]
        timeFormat          <- map["TimeFormat"]
        disabledDays        <- map["DisabledDays"]
        minimumTime         <- map["MinimumTime"]
        required            <- map["Required"]
        maximumDate         <- map["MaximumDate"]
        defaultTimeType     <- map["DefaultTimeType"]
        dateTimeType        <- map["DateTimeType"]
        minimumDate         <- map["MinimumDate"]
        unique              <- map["Unique"]
        localization        <- map["Localization"]
        label               <- map["Label"]
        allowedDaysRange    <- map["AllowedDaysRange"]
        sendToBPM           <- map["SendToBPM"]
        validationType      <- map["ValidationType"]
        disabledDates       <- map["DisabledDates"]
        tooltip             <- map["Tooltip"]
        calendarType        <- map["CalendarType"]
        defaultAnswer       <- map["DefaultAnswer"]
        firstDayOfWeek      <- map["FirstDayOfWeek"]
    }
}


extension BackwardProperties {
    func toProperties() -> Properties {
        return Properties(
            label: self.label,
            disabledMonths: self.disabledMonths,
            placeholder: self.placeholder,
            style: self.style,
            sublabel: self.sublabel,
            icon: self.icon,
            defaultDateType: self.defaultDateType,
            isVisibleInViewMode: self.isVisibleInViewMode,
            dateFormat: self.dateFormat,
            dateSelectionMode: self.dateSelectionMode,
            maximumTime: self.maximumTime,
            timeFormat: self.timeFormat,
            disabledDays: self.disabledDays,
            minimumTime: self.minimumTime,
            required: self.required,
            maximumDate: self.maximumDate,
            defaultTimeType: self.defaultTimeType,
            dateTimeType: self.dateTimeType,
            minimumDate: self.minimumDate,
            unique: self.unique,
            localization: self.localization,
            allowedDaysRange: self.allowedDaysRange,
            sendToBPM: self.sendToBPM,
            validationType: self.validationType,
            disabledDates: self.disabledDates,
            tooltip: self.tooltip,
            calendarType: self.calendarType,
            defaultAnswer: self.defaultAnswer?.toDefaultAnswer(), // If necessary, map DefaultAnswer conversion here
            firstDayOfWeek: self.firstDayOfWeek,
            options: nil, // Assuming BackwardProperties doesn't have options; adjust if needed
            isCollapsed: self.isCollapsed // Assuming BackwardProperties doesn't have isCollapsed; adjust if needed
        )
    }
}


//struct BackwardLocalization : Codable {
//    let en : En?
//    let ar : BackwardAr?
//
//    enum CodingKeys: String, CodingKey {
//
//        case en = "en"
//        case ar = "ar"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        en = try values.decodeIfPresent(BackwardEn.self, forKey: .en)
//        ar = try values.decodeIfPresent(BackwardAr.self, forKey: .ar)
//    }
//
//}


//struct BackwardEn : Codable {
//    let label : String?
//    let placeholder : String?
//    let sublabel : String?
//    let tooltip : String?
//    let fieldWarning : BackwardFieldWarning?
//
//    enum CodingKeys: String, CodingKey {
//
//        case label = "Label"
//        case placeholder = "Placeholder"
//        case sublabel = "Sublabel"
//        case tooltip = "Tooltip"
//        case fieldWarning = "FieldWarning"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        label = try values.decodeIfPresent(String.self, forKey: .label)
//        placeholder = try values.decodeIfPresent(String.self, forKey: .placeholder)
//        sublabel = try values.decodeIfPresent(String.self, forKey: .sublabel)
//        tooltip = try values.decodeIfPresent(String.self, forKey: .tooltip)
//        fieldWarning = try values.decodeIfPresent(BackwardFieldWarning.self, forKey: .fieldWarning)
//    }
//
//}

//struct BackwardAr : Codable {
//    let label : String?
//    let placeholder : String?
//    let sublabel : String?
//    let tooltip : String?
//    let fieldWarning : BackwardFieldWarning?
//
//    enum CodingKeys: String, CodingKey {
//
//        case label = "Label"
//        case placeholder = "Placeholder"
//        case sublabel = "Sublabel"
//        case tooltip = "Tooltip"
//        case fieldWarning = "FieldWarning"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        label = try values.decodeIfPresent(String.self, forKey: .label)
//        placeholder = try values.decodeIfPresent(String.self, forKey: .placeholder)
//        sublabel = try values.decodeIfPresent(String.self, forKey: .sublabel)
//        tooltip = try values.decodeIfPresent(String.self, forKey: .tooltip)
//        fieldWarning = try values.decodeIfPresent(BackwardFieldWarning.self, forKey: .fieldWarning)
//    }
//
//}


//struct BackwardFieldWarning : Codable {
//    let maximumDate : String?
//    let minimumDate : String?
//    let maximumTime : String?
//    let required : String?
//    let minimumTime : String?
//    let allowedDaysRange : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case maximumDate = "MaximumDate"
//        case minimumDate = "MinimumDate"
//        case maximumTime = "MaximumTime"
//        case required = "Required"
//        case minimumTime = "MinimumTime"
//        case allowedDaysRange = "AllowedDaysRange"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        maximumDate = try values.decodeIfPresent(String.self, forKey: .maximumDate)
//        minimumDate = try values.decodeIfPresent(String.self, forKey: .minimumDate)
//        maximumTime = try values.decodeIfPresent(String.self, forKey: .maximumTime)
//        required = try values.decodeIfPresent(String.self, forKey: .required)
//        minimumTime = try values.decodeIfPresent(String.self, forKey: .minimumTime)
//        allowedDaysRange = try values.decodeIfPresent(String.self, forKey: .allowedDaysRange)
//    }
//
//}


struct BackwardTaskSubmittedRowDataModel: Codable {
    let id: String?
    let name: String?
    let rowIndex: String?
    let value: ValueType?
    let subValues: ValueType?
    let type: String?
    let label: String?
    let multipleValue: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, rowIndex, value, subValues, type, label, multipleValue
    }
}

struct BackwardDefaultAnswer: Codable, Mappable {
    
    var id: String?
    var name: String?
    var rowIndex: String?
    var defaultValue: ValueType?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case rowIndex = "RowIndex"
        case defaultValue = "Value"
    }
    
    // Codable initializer
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        rowIndex = try values.decodeIfPresent(String.self, forKey: .rowIndex)
        defaultValue = try values.decodeIfPresent(ValueType.self, forKey: .defaultValue)
    }
    
    // Mappable initializer
    init?(map: Map) {
        id = nil
        name = nil
        rowIndex = nil
        defaultValue = nil
    }
    
    // Mappable mapping function
    mutating func mapping(map: Map) {
        id <- map["Id"]
        name <- map["Name"]
        rowIndex <- map["RowIndex"]
        defaultValue <- map["Value"]
    }
}


extension BackwardDefaultAnswer {
    func toDefaultAnswer() -> DefaultAnswer {
        return DefaultAnswer(
            id: self.id,
            name: self.name,
            rowIndex: self.rowIndex, // Map RowIndex to rowIndex
            defaultValue: self.defaultValue, // Assuming ValueType is the same in both
            type: nil // Set nil if BackwardDefaultAnswer doesn't have a type field
        )
    }
}


public class BackwardAttachmentForDefault: Mappable {
    var fileId: String?
    var url: String?
    var downloadUrl: String?
    var attachmentDisplaySize: String?
    var fileName: String?
    var previewUrl: String?
    var size: String?
    var isPublic: Bool?
    var fileUrl: String?
    var fileExtension: String?
    var isSuccess: Bool?

    required public init?(map: Map) {}

    public func mapping(map: Map) {
        fileId <- map["fileId"]
        url <- map["url"]
        downloadUrl <- map["downloadUrl"]
        attachmentDisplaySize <- map["attachmentDisplaySize"]
        fileName <- map["fileName"]
        previewUrl <- map["previewUrl"]
        size <- map["size"]
        isPublic <- map["isPublic"]
        fileUrl <- map["fileUrl"]
        fileExtension <- map["extension"]
        isSuccess <- map["isSuccess"]
    }
}


//public enum ValueType: Codable {
//    case singleDouble(Double)
//    case double([Double])
//    case singleString(String)
//    case string([String])
//    case dictionary([[String: String]])
//    case file([File])
//    case empty
//    case ddl(DDL)
//    case bool([Bool])
//    
//    public struct DDL: Codable {
//        let Name: String?
//        let Value: [MCQOption]?
//        let RowIndex: String?
//        let Id: String?
//        enum CodingKeys: String, CodingKey {
//            case Name, Value, RowIndex, Id
//        }
//    }
//    
//    public struct File: Codable {
//        let fileId: String?
//        let previewUrl: String?
//        let downloadUrl: String?
//        let isSuccess: Bool?
//        let fileName: String?
//        let attachmentDisplaySize: String?
//        let fileUrl: String?
//        let fileExtension: String?
//        let isPublic: Bool?
//        let url: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case downloadUrl
//            case previewUrl
//            case fileId
//            case isSuccess
//            case fileName
//            case attachmentDisplaySize
//            case fileUrl
//            case fileExtension = "extension"
//            case isPublic
//            case url
//        }
//    }
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        
//        if let singleString = try? container.decode(String.self) {
//            self = .singleString(singleString)
//        } else if let singleDouble = try? container.decode(Double.self) {
//            self = .singleDouble(singleDouble)
//        } else if let double = try? container.decode([Double].self) {
//            self = .double(double)
//        } else if let string = try? container.decode([String].self) {
//            self = .string(string)
//        }  else if let nestedString = try? container.decode([[String]].self) {
//            let flattenedString = nestedString.flatMap { $0 }.joined(separator: ", ")
//            self = .singleString(flattenedString)
//        } else if let dict = try? container.decode([[String: String]].self) {
//            self = .dictionary(dict)
//        } else if let file = try? container.decode([File].self) {
//            self = .file(file)
//        } else if let ddl = try? container.decode(DDL.self) {
//            self = .ddl(ddl)
//        } else if let bool = try? container.decode([Bool].self) {
//            self = .bool(bool)
//        } else {
//            self = .empty
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        
//        switch self {
//        case .singleDouble(let singleDouble):
//            try container.encode(singleDouble)
//        case .double(let double):
//            try container.encode(double)
//        case .singleString(let singleString):
//            try container.encode(singleString)
//        case .string(let string):
//            try container.encode(string)
//        case .dictionary(let dict):
//            try container.encode(dict)
//        case .file(let file):
//            try container.encode(file)
//        case .ddl(let ddl):
//            try container.encode(ddl)
//        case .bool(let bool):
//            try container.encode(bool)
//        case .empty:
//            return
//        }
//    }
//}

struct BackwardMyValue: Codable {
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


//struct BackwardTakenAction : Codable {
//    let id : String?
//    let name : String?
//    let label : String?
//    let actionTakenLabel : String?
//    let styleCode : String?
//    let buttonStyleCode : String?
//    let actionCode : String?
//    let isCommentRequired : Bool?
//    let isAttachmentRequired : Bool?
//    let isFormValidateBeforeExecuteActionRequired : Bool?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case label = "label"
//        case actionTakenLabel = "actionTakenLabel"
//        case styleCode = "styleCode"
//        case buttonStyleCode = "buttonStyleCode"
//        case actionCode = "actionCode"
//        case isCommentRequired = "isCommentRequired"
//        case isAttachmentRequired = "isAttachmentRequired"
//        case isFormValidateBeforeExecuteActionRequired = "isFormValidateBeforeExecuteActionRequired"
//    }
//}

//struct PreviousActions : Codable {
//    let id : String?
//    let bpmTaskId : String?
//    let taskOnUserName : String?
//    let taskOnUserJobTitle : String?
//    let taskOnUserDepartmentName : String?
//    let taskOnUserPhoto : String?
//    let taskOnUserEmail : String?
//    let createdDate : String?
//    let completionDate : String?
//    let comment : String?
//    let isCompleted : Bool?
//    let takenAction : TakenAction?
//    let attachments : [PreviousActionsAttachments]?
//    var isExpanded = false
//    var taskSubmittedRowDataJson: String?
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case bpmTaskId = "bpmTaskId"
//        case taskOnUserName = "taskOnUserName"
//        case taskOnUserJobTitle = "taskOnUserJobTitle"
//        case taskOnUserDepartmentName = "taskOnUserDepartmentName"
//        case taskOnUserPhoto = "taskOnUserPhoto"
//        case taskOnUserEmail = "taskOnUserEmail"
//        case createdDate = "createdDate"
//        case completionDate = "completionDate"
//        case comment = "comment"
//        case isCompleted = "isCompleted"
//        case takenAction = "takenAction"
//        case attachments = "attachments"
//        case taskSubmittedRowDataJson
//    }
//
//}

//struct BackwardPreviousActionsAttachments : Codable {
//    var fileId : String?
//    var fileName : String?
//    var url : String?
//    var attExtension : String?
//    var size : Double?
//
//    enum CodingKeys: String, CodingKey {
//
//        case fileId = "fileId"
//        case fileName = "fileName"
//        case url = "url"
//        case attExtension = "extension"
//        case size = "size"
//    }
//
//}

struct BackwardReqDetailsAttachmentValue : Codable, FormValue {
    let url : String?
    let attachmentName : String?
    let attachmentExtension : String?
    let attachmentDisplaySize : String?
    let fileId : String?
    let size : String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case attachmentName = "fileName"
        case attachmentExtension = "extension"
        case attachmentDisplaySize = "attachmentDisplaySize"
        case fileId
        case size
    }


}


//struct BackwardAction : Codable {
//    let id : String?
//    let name : String?
//    let label : String?
//    let actionTakenLabel : String?
//    let styleCode : String?
//    let buttonStyleCode : String?
//    let actionCode : String?
//    let isCommentRequired : Bool?
//    let isFormValidateBeforeExecuteActionRequired : Bool?
//    let isAttachmentRequired : Bool?
//    let actionFormId: String?
//    let actionOrder: Int?
//    let buttonStyle : BackwardButtonStyle?
//    
//    init(id: String?, name: String?, label: String?, actionTakenLabel: String?, styleCode: String?, buttonStyleCode: String?, actionCode: String?, isCommentRequired: Bool?, isFormValidateBeforeExecuteActionRequired: Bool?, isAttachmentRequired: Bool?, actionFormId: String?, actionOrder: Int?, buttonStyle : BackwardButtonStyle?) {
//        self.id = id
//        self.name = name
//        self.label = label
//        self.actionTakenLabel = actionTakenLabel
//        self.styleCode = styleCode
//        self.buttonStyleCode = buttonStyleCode
//        self.actionCode = actionCode
//        self.isCommentRequired = isCommentRequired
//        self.isFormValidateBeforeExecuteActionRequired = isFormValidateBeforeExecuteActionRequired
//        self.isAttachmentRequired = isAttachmentRequired
//        self.actionFormId = actionFormId
//        self.actionOrder = actionOrder
//        self.buttonStyle = buttonStyle
//    }
//    init() {
//        self.id = ""
//        self.name = ""
//        self.label = ""
//        self.actionTakenLabel = ""
//        self.styleCode = ""
//        self.buttonStyleCode = ""
//        self.actionCode = ""
//        self.isCommentRequired = false
//        self.isFormValidateBeforeExecuteActionRequired = false
//        self.isAttachmentRequired = false
//        self.actionFormId = ""
//        self.actionOrder = 0
//        self.buttonStyle = BackwardButtonStyle()
//    }
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case name = "name"
//        case label = "label"
//        case actionTakenLabel = "actionTakenLabel"
//        case styleCode = "styleCode"
//        case buttonStyleCode = "buttonStyleCode"
//        case actionCode = "actionCode"
//        case isCommentRequired = "isCommentRequired"
//        case isFormValidateBeforeExecuteActionRequired = "isFormValidateBeforeExecuteActionRequired"
//        case isAttachmentRequired = "isAttachmentRequired"
//        case actionFormId, actionOrder
//        case buttonStyle
//    }
//}
//struct BackwardButtonStyle: Codable {
//    let backgroundColor: String?
//    let borderColor: String?
//    let textColor: String?
//    let opacity: Float?
//    init() {
//        self.backgroundColor = ""
//        self.borderColor = ""
//        self.textColor = ""
//        self.opacity = 0.0
//    
//    }
//}

