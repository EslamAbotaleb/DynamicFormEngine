//
//  ModelFormCerqel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

public let Service_Name_LeavesCerqel = "Leaves"
public let service_Name_NewEmployeeImprovement_PlanCerqel = "newEmployeeImprovementPlan"
public let Service_Name_newEmployeeStatusCerqel = "newEmployeeStatus"
public let Service_Name_newtransferRequestCerqel = "newtransferRequest"
public let Service_Name_EmployeeInfoCerqel = "EmployeeInfo"


public struct ModelFormCerqel : Codable {
    public let requestForm : RequestFormCerqel?
    public let serviceName : String?

    enum CodingKeys: String, CodingKey {

        case requestForm = "requestForm"
        case serviceName = "serviceName"
    }
}

struct ModelNestedFormValueCerqel : Codable, FormValueCerqel {
    public let val : [ModelControlCerqel]?
    enum CodingKeys: String, CodingKey {

        case val = "val"
    }

}

struct ModelControlCerqel : Codable, FormValueCerqel {
    public var options : [OptionsCerqel]?
    public var id : String?
    public var type : ControlType?
    public var format : String?
    public var index : Int?
    public var formCode : String?
    public var value : [FormValueCerqel?]?
    public var readOnly : Bool?
    public var isVisibleInViewMode : Bool?
    public var isRequired : Bool?
    public var isValueDynamic : Bool?
    public var dataSourceType : String?
    public var dataSourceId : String?
    public var name : String?
    public var translations : String?
    public var label : String?
    public var description : String?
    public var placeHolder : String?
    public var dateFromPlaceholder : String?
    public var dateToPlaceholder : String?
    public var timeFromPlaceholder : String?
    public var timeToPlaceholder : String?
    public var isVisible : Bool?
    public var isMultiSelect : Bool?
    public var roles : [String]?
    public var icon : String?
    public var style : StyleCerqel?
    public var validations : [ValidationsCerqel]?
    public var dependencies : [String]?
    public var conditionalView : ConditionalViewCerqel?
    public var isExpanded: Bool = false
    public var isHidden: Bool = false
    public var isValid = false
    public var notValidType: ValidationName?
    public var contentType: ContentType?
    public var filesNumber : Int?
    
    public let valuePathEn : String?
    public let valuePathAr : String?
    public let dataSourceUrl : String?
    public let isSubmitted : Bool?
    public let calendarType : CalendarTypeCerqel?
    /// in Days
    public let maxDate : Int?
    /// in Days
    public let minDate : Int?
    /// in minutes
    public let maxTime : Int?
    /// in minutes
    public let minTime : Int?
    public let startMin: DateValidationObject?
    public let startMax: DateValidationObject?
    public let endMin: DateValidationObject?
    public let endMax: DateValidationObject?
    public let isMaxMonth: Bool?
    public let isMinMonth: Bool?
    public let datePlaceholder : String?
    public let timePlaceholder : String?
    public var dateFormat : String?
    public let timeFormat : String?
    public let cascadingChildrenIndexes : [Int]?
    public let cascadingParentIndexes : [Int]?
    public let isLovDataSource : Bool?
    public var relationEquation: RelationEquationCerqel?
    public let multipleValue: Bool?

    /// for NestedForm (control -> Table)
    public var controls : [ModelControlCerqel]?
    public var coltrolRow : [[ModelControlCerqel]]?
    
    public var additionalProperty01: AdditionalPropertyCerqel?
    public var additionalProperty02: AdditionalPropertyCerqel?
    public var additionalProperty03: AdditionalPropertyCerqel?
    public var additionalProperty04: AdditionalPropertyCerqel?

    /// to show thumbnail
    public var isImagePreview: Bool?
    
    public var searchChildrenIndexes: [Int]?
    public var searchMappingModel: String?
    public var dataSourceBaseUrl: String?
    /// this is a local value not comming from API
    public var searchResultValue: [SearchControlResultCerqel]?
    /// this is a local value not comming from API
    public var searchedText: String?
    
    public var mappedValue: String?
    
    
    
    public enum CodingKeys: String, CodingKey {

        case options = "options"
        case id = "id"
        case type = "type"
        case format = "format"
        case index = "index"
        case formCode = "formCode"
        case value = "value"
        case readOnly = "readOnly"
        case isVisibleInViewMode = "isVisibleInViewMode"
        case isRequired = "isRequired"
        case isValueDynamic = "isValueDynamic"
        case dataSourceType = "dataSourceType"
        case dataSourceId = "dataSourceId"
        case name = "name"
        case translations = "translations"
        case label = "label"
        case placeHolder = "placeHolder"
        case dateFromPlaceholder = "dateFromPlaceholder"
        case dateToPlaceholder = "dateToPlaceholder"
        case isVisible = "isVisible"
        case isMultiSelect
        case roles = "roles"
        case icon = "icon"
        case style = "style"
        case validations = "validations"
        case dependencies = "dependencies"
        case conditionalView = "conditionalView"
        case contentType = "contentType"
        case filesNumber
        case valuePathEn
        case valuePathAr
        case dataSourceUrl
        case isSubmitted = "isSubmitted"
        case calendarType = "calendarType"
        case maxDate = "maxDate"
        case minDate = "minDate"
        case startMin = "startMin"
        case startMax = "startMax"
        case endMin = "endMin"
        case endMax = "endMax"
        case maxTime = "maxTime"
        case minTime = "minTime"
        case isMaxMonth = "isMaxMonth"
        case isMinMonth = "isMinMonth"
        case datePlaceholder = "datePlaceholder"
        case timePlaceholder = "timePlaceholder"
        case dateFormat = "dateFormat"
        case timeFormat = "timeFormat"
        case cascadingChildrenIndexes = "cascadingChildrenIndexes"
        case cascadingParentIndexes
        case isLovDataSource = "isLovDataSource"
        case description
        case relationEquation
        case timeFromPlaceholder
        case timeToPlaceholder
        case multipleValue
        case controls
        case coltrolRow = "NestedControlValues"
        case additionalProperty01 = "additionalProperty01"
        case additionalProperty02 = "additionalProperty02"
        case additionalProperty03 = "additionalProperty03"
        case additionalProperty04 = "additionalProperty04"
        case isImagePreview = "isImageThumbnail"
        case searchChildrenIndexes
        case searchMappingModel = "mappingModel"
        case dataSourceBaseUrl
        case mappedValue
    }
    
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        options = try values.decodeIfPresent([OptionsCerqel].self, forKey: .options)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(ControlType.self, forKey: .type)
        format = try values.decodeIfPresent(String.self, forKey: .format)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        formCode = try values.decodeIfPresent(String.self, forKey: .formCode)
        readOnly = try values.decodeIfPresent(Bool.self, forKey: .readOnly)
        isVisibleInViewMode = try values.decodeIfPresent(Bool.self, forKey: .isVisibleInViewMode)
        isRequired = try values.decodeIfPresent(Bool.self, forKey: .isRequired)
        isValueDynamic = try values.decodeIfPresent(Bool.self, forKey: .isValueDynamic)
        dataSourceType = try values.decodeIfPresent(String.self, forKey: .dataSourceType)
        dataSourceId = try values.decodeIfPresent(String.self, forKey: .dataSourceId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        translations = try values.decodeIfPresent(String.self, forKey: .translations)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        placeHolder = try values.decodeIfPresent(String.self, forKey: .placeHolder)
        isVisible = try values.decodeIfPresent(Bool.self, forKey: .isVisible)
        isMultiSelect = try values.decodeIfPresent(Bool.self, forKey: .isMultiSelect)
        roles = try values.decodeIfPresent([String].self, forKey: .roles)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        style = try values.decodeIfPresent(StyleCerqel.self, forKey: .style)
        validations = try values.decodeIfPresent([ValidationsCerqel].self, forKey: .validations)
        dependencies = try values.decodeIfPresent([String].self, forKey: .dependencies)
        conditionalView = try values.decodeIfPresent(ConditionalViewCerqel.self, forKey: .conditionalView)
        contentType = try values.decodeIfPresent(ContentType.self, forKey: .contentType)
        if contentType == .multiSelect{
            self.isMultiSelect = true
        }
        filesNumber = try values.decodeIfPresent(Int.self, forKey: .filesNumber)
        valuePathEn = try values.decodeIfPresent(String.self, forKey: .valuePathEn)
        valuePathAr = try values.decodeIfPresent(String.self, forKey: .valuePathAr)
        dataSourceUrl = try values.decodeIfPresent(String.self, forKey: .dataSourceUrl)
        isSubmitted = try values.decodeIfPresent(Bool.self, forKey: .isSubmitted)
        calendarType = try values.decodeIfPresent(CalendarTypeCerqel.self, forKey: .calendarType)
        maxDate = try values.decodeIfPresent(Int.self, forKey: .maxDate)
        minDate = try values.decodeIfPresent(Int.self, forKey: .minDate)
        maxTime = try values.decodeIfPresent(Int.self, forKey: .maxTime)
        minTime = try values.decodeIfPresent(Int.self, forKey: .minTime)
        isMinMonth = try values.decodeIfPresent(Bool.self, forKey: .isMinMonth)
        isMaxMonth = try values.decodeIfPresent(Bool.self, forKey: .isMaxMonth)
        startMin = try values.decodeIfPresent(DateValidationObject.self, forKey: .startMin)
        startMax = try values.decodeIfPresent(DateValidationObject.self, forKey: .startMax)
        endMin = try values.decodeIfPresent(DateValidationObject.self, forKey: .endMin)
        endMax = try values.decodeIfPresent(DateValidationObject.self, forKey: .endMax)
        datePlaceholder = try values.decodeIfPresent(String.self, forKey: .datePlaceholder)
        dateFromPlaceholder = try values.decodeIfPresent(String.self, forKey: .dateFromPlaceholder)
        dateToPlaceholder = try values.decodeIfPresent(String.self, forKey: .dateToPlaceholder)
        timeFromPlaceholder = try values.decodeIfPresent(String.self, forKey: .timeFromPlaceholder)
        timeToPlaceholder = try values.decodeIfPresent(String.self, forKey: .timeToPlaceholder)
        timePlaceholder = try values.decodeIfPresent(String.self, forKey: .timePlaceholder)
        dateFormat = try values.decodeIfPresent(String.self, forKey: .dateFormat)
        timeFormat = try values.decodeIfPresent(String.self, forKey: .timeFormat)
        cascadingChildrenIndexes = try values.decodeIfPresent([Int].self, forKey: .cascadingChildrenIndexes)
        cascadingParentIndexes = try values.decodeIfPresent([Int].self, forKey: .cascadingParentIndexes)
        isLovDataSource = try values.decodeIfPresent(Bool.self, forKey: .isLovDataSource)
        relationEquation = try values.decodeIfPresent(RelationEquationCerqel.self, forKey: .relationEquation)
        multipleValue = try values.decodeIfPresent(Bool.self, forKey: .multipleValue)
        controls = try values.decodeIfPresent([ModelControlCerqel].self, forKey: .controls)
        coltrolRow = try values.decodeIfPresent([[ModelControlCerqel]].self, forKey: .coltrolRow)
        isImagePreview = try values.decodeIfPresent(Bool.self, forKey: .isImagePreview)
        searchChildrenIndexes = try values.decodeIfPresent([Int].self, forKey: .searchChildrenIndexes)
        searchMappingModel = try values.decodeIfPresent(String.self, forKey: .searchMappingModel)
        dataSourceBaseUrl = try values.decodeIfPresent(String.self, forKey: .dataSourceBaseUrl)
        mappedValue = try values.decodeIfPresent(String.self, forKey: .mappedValue)
        
        
        additionalProperty01 = try values.decodeIfPresent(AdditionalPropertyCerqel.self, forKey: .additionalProperty01)
        additionalProperty02 = try values.decodeIfPresent(AdditionalPropertyCerqel.self, forKey: .additionalProperty02)
        additionalProperty03 = try values.decodeIfPresent(AdditionalPropertyCerqel.self, forKey: .additionalProperty03)
        additionalProperty04 = try values.decodeIfPresent(AdditionalPropertyCerqel.self, forKey: .additionalProperty04)


        switch type{
            case .RadioButton, .DropDown:
                if let val = try? values.decodeIfPresent([OptionsCerqel].self, forKey: .value){
                    value = val
                }
            case .TextBox, .TextArea, .Link, .Label, .InfoIndicator, .DatePicker, .DateTimePicker, .DateRangePicker, .TimePicker, .DateTimeRangePicker:
                if let val = try? values.decodeIfPresent([String].self, forKey: .value){
                    value = val
                }
            case .FileUpload:
                if let val = try? values.decodeIfPresent([ReqDetailsAttachmentValueCerqel].self, forKey: .value){
                    value = val
                }
            case .Switch, .CheckBox:
                if let val = try? values.decodeIfPresent([Bool].self, forKey: .value){
                    value = val
                }
            case .table:
                if let val = try? values.decodeIfPresent([ModelControlCerqel].self, forKey: .value){
                    value = val
                }


        case .customComponent:
            if let name = name, name == Service_Name_LeavesCerqel{
                if let val = try? values.decodeIfPresent([LeavesViewValueCerqel].self, forKey: .value){
                    value = val
                }
            }else if let name = name, name == Service_Name_newEmployeeStatusCerqel{
                if let val = try? values.decodeIfPresent([newEmployeeStatusValueCerqel].self, forKey: .value){
                    value = val
                }
            }else if let name = name, name == Service_Name_newtransferRequestCerqel{
                if let val = try? values.decodeIfPresent([newtransferRequestValueCerqel].self, forKey: .value){
                    value = val
                }
            }else if let name = name, name == Service_Name_EmployeeInfoCerqel{
                if let val = try? values.decodeIfPresent([VisitorInfoCerqel].self, forKey: .value){
                    value = val
                }
            }else if let name = name, name == service_Name_NewEmployeeImprovement_PlanCerqel{
                if let val = try? values.decodeIfPresent([ImprovementPlanViewValueCerqel].self, forKey: .value){
                    value = val
                }
            }
            
//            if let val = try? values.decodeIfPresent([LeavesViewValueCerqel].self, forKey: .value){
//                value = val
//            }else if let val = try? values.decodeIfPresent([VisitorInfoCerqel].self, forKey: .value){
//                value = val
//            }else if let val = try? values.decodeIfPresent([newEmployeeStatusValueCerqel].self, forKey: .value){
//                value = val
//            }else if let val = try? values.decodeIfPresent([newtransferRequestValueCerqel].self, forKey: .value){
//                value = val
//            }
            
                
        default:
            value = nil
        }
        if let val = validations, val.count > 0{ }else{
            isValid = true
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }


}

public struct AdditionalPropertyCerqel : Codable {
    public var contentType : String?
    public var isRequired : Bool?
    public var isVisible : Bool?
    public var id : String?
    public var label : String?
    public var name : String?
    public var placeHolder : String?
    public var readOnly : Bool?
    public var translations : String?
    public var type : String?
    public var value : String?
    public var validations : [ValidationsCerqel]?

    enum CodingKeys: String, CodingKey {

        case contentType = "contentType"
        case isRequired = "isRequired"
        case isVisible = "isVisible"
        case id = "id"
        case label = "label"
        case name = "name"
        case placeHolder = "placeHolder"
        case readOnly = "readOnly"
        case translations = "translations"
        case type = "type"
        case value = "value"
        case validations = "validations"
        
    }


}

public struct RequestFormCerqel : Codable {
    public var id : String?
    public var name : String?
    var controls : [ModelControlCerqel]?
    public var formCode : String?
    public var version : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case controls = "controls"
        case formCode = "formCode"
        case version = "version"
    }
}

/*
public struct OptionsCerqel : Codable, PublicMappable, FormValueCerqel {
    public var key : String?
    public var text : String?
    public var icon : String?
    public var selectedKey : String?
    
    public var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        
        case key = "key"
        case text = "text"
        case icon = "icon"
        case selectedKey
    }
    
    public func encode(to encoder: Encoder) throws {}
    
    public init(){}
        //    public init?(map: Map) {}
        //
        //    mutating public func mapping(map: Map) {
        ////        key <- map["key"]
        ////        text <- map["text"]
        //
        //    }
    public init?(map: [String: Any]) {
        
    }
    
    public func mapping() -> [String: Any] {
        [:]
    }
    
}

internal struct OptionsCerqelAdapter: Mappable {
    var wrapped: OptionsCerqel

    init?(map: Map) {
        self.wrapped = OptionsCerqel()
        self.mapping(map: map)
    }

    mutating func mapping(map: Map) {
        var key = wrapped.key
        var text = wrapped.text
        var icon = wrapped.icon
        var selectedKey = wrapped.selectedKey

        key      <- map["key"]
        text    <- map["text"]
        icon <- map["icon"]
        selectedKey <- map["selectedKey"]
        
        wrapped.key = key
        wrapped.text = text
        wrapped.icon = icon
        wrapped.selectedKey = selectedKey
    }

    // Helper to convert back to public struct
    func toPublic() -> OptionsCerqel {
        return wrapped
    }
}
public extension Array where Element == OptionsCerqel {
    func toJSON() -> [[String: Any]] {
        return self.map { $0.mapping() }
    }
}
*/
struct OptionsCerqel : Codable, Mappable, FormValueCerqel {
    var key : String?
    var text : String?
    var icon : String?
    var selectedKey : String?
    
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case text = "text"
        case icon = "icon"
        case selectedKey
    }
    
    func encode(to encoder: Encoder) throws {}

    init(){}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
//        key <- map["key"]
//        text <- map["text"]

    }
    

}
public struct ConditionalViewCerqel : Codable {
    public var validConditions : Int?
    public var conditions : [ModelconditionCerqel]?
    public var minimumAcceptableConditionsNumber: Int?

    enum CodingKeys: String, CodingKey {

        case validConditions = "validConditions"
        case conditions = "conditions"
        case minimumAcceptableConditionsNumber
    }
}

public struct StyleCerqel : Codable {
    public var border : String?
    public var borderType : String?
    public var borderColor : String?
    public var backgroundColor : String?
    public var textColor : String?
    public var textAlign : String?
    public var font : String?
    public var fontSize : String?

    enum CodingKeys: String, CodingKey {

        case border = "border"
        case borderType = "borderType"
        case borderColor = "borderColor"
        case backgroundColor = "backgroundColor"
        case textColor = "textColor"
        case textAlign = "textAlign"
        case font = "font"
        case fontSize = "fontSize"
    }
}

public struct ValidationsCerqel : Codable {
    public var name : ValidationName?
    public var value : String?
    public var message : String?
    public var isValid: Bool = false

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
        case message = "message"
    }
    
    public init() {}
    
}

public struct ModelconditionCerqel : Codable {
    public var parentFieldId : String?
    public var parentFieldIndex : Int?
    public var validationName : ValidationName?
    public var value : String?
    public var validityStatus : Bool?

    enum CodingKeys: String, CodingKey {

        case parentFieldId = "parentFieldId"
        case parentFieldIndex = "parentFieldIndex"
        case validationName = "validationName"
        case value = "value"
        case validityStatus = "validityStatus"
    }
}


public enum CalendarTypeCerqel: String, Codable{
    case Gregorian
    case Hijri
    case Gregorian_Hijri = "Gregorian/Hijri"
}


public struct LeavesViewValueCerqel : Codable, FormValueCerqel {
    public let actionType : String?
    public let externalCode : String?
    public let startDate : String?
    public let endDate : String?
    public let startTime : String?
    public let endTime : String?
    public let leaveType : ViewLeaves_NameKeyCerqel?
    public let replacementUser : ReplacementUserCerqel?
    public let compassionateRelation : ViewLeaves_NameKeyCerqel?
    public let accompanyingRelation : ViewLeaves_NameKeyCerqel?
    public let businessPermissionPurpose : ViewLeaves_NameKeyCerqel?
    public let attachmentId : String?
    public let AttachmentName : String?
    public let attachmentUrl : String?
    public let isFileManager : Bool?
    public let attachments: leaveAttttValueCerqel?
    public let requestingDays: Int?
    public let requestingHours: Int?

    enum CodingKeys: String, CodingKey {

        case actionType = "actionType"
        case externalCode = "externalCode"
        case startDate = "startDate"
        case endDate = "endDate"
        case startTime = "startTime"
        case endTime = "endTime"
        case leaveType = "leaveType"
        case replacementUser = "replacementUser"
        case compassionateRelation = "compassionateRelation"
        case accompanyingRelation = "accompanyingRelation"
        case businessPermissionPurpose = "businessPermissionPurpose"
        case attachmentId = "AttachmentId"
        case AttachmentName
        case isFileManager = "isFileManager"
        case attachmentUrl
        case attachments
        case requestingDays
        case requestingHours
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actionType = try values.decodeIfPresent(String.self, forKey: .actionType)
        externalCode = try values.decodeIfPresent(String.self, forKey: .externalCode)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
        leaveType = try values.decodeIfPresent(ViewLeaves_NameKeyCerqel.self, forKey: .leaveType)
        replacementUser = try values.decodeIfPresent(ReplacementUserCerqel.self, forKey: .replacementUser)
        compassionateRelation = try values.decodeIfPresent(ViewLeaves_NameKeyCerqel.self, forKey: .compassionateRelation)
        accompanyingRelation = try values.decodeIfPresent(ViewLeaves_NameKeyCerqel.self, forKey: .accompanyingRelation)
        businessPermissionPurpose = try values.decodeIfPresent(ViewLeaves_NameKeyCerqel.self, forKey: .businessPermissionPurpose)
        attachmentId = try values.decodeIfPresent(String.self, forKey: .attachmentId)
        AttachmentName = try values.decodeIfPresent(String.self, forKey: .AttachmentName)
        attachmentUrl = try values.decodeIfPresent(String.self, forKey: .attachmentUrl)
        isFileManager = try values.decodeIfPresent(Bool.self, forKey: .isFileManager)
        attachments = try values.decodeIfPresent(leaveAttttValueCerqel.self, forKey: .attachments)
        requestingDays = try values.decodeIfPresent(Int.self, forKey: .requestingDays)
        requestingHours = try values.decodeIfPresent(Int.self, forKey: .requestingHours)
        
    }

}

public struct ImprovementPlanViewValueCerqel : Codable, FormValueCerqel {
    public let businessUnitName : String?
    public let departmentName : String?
    public let effectiveDateFrom : String?
    public let employeeId : String?
    public let employeeName : String?
    public let positionName : String?
    public let reasonsJustifications : String?
    public let requestType : ModelKeyTextCerqel?

    enum CodingKeys: String, CodingKey {

        case businessUnitName = "businessUnitName"
        case departmentName = "departmentName"
        case effectiveDateFrom = "effectiveDateFrom"
        case employeeId = "employeeId"
        case employeeName = "employeeName"
        case positionName = "positionName"
        case reasonsJustifications = "reasonsJustifications"
        case requestType = "requestType"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        businessUnitName = try values.decodeIfPresent(String.self, forKey: .businessUnitName)
        departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
        effectiveDateFrom = try values.decodeIfPresent(String.self, forKey: .effectiveDateFrom)
        employeeId = try values.decodeIfPresent(String.self, forKey: .employeeId)
        employeeName = try values.decodeIfPresent(String.self, forKey: .employeeName)
        positionName = try values.decodeIfPresent(String.self, forKey: .positionName)
        reasonsJustifications = try values.decodeIfPresent(String.self, forKey: .reasonsJustifications)
        requestType = try values.decodeIfPresent(ModelKeyTextCerqel.self, forKey: .requestType)
    }

}



public struct leaveAttttValueCerqel : Codable {
    public  let value : [AttachmentsCerqel]?

    enum CodingKeys: String, CodingKey {

        case value = "value"
    }
}

public struct ViewLeaves_NameKeyCerqel : Codable {
    public let key : String?
    public let nameAr : String?
    public let nameEn : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case nameAr = "NameAr"
        case nameEn = "NameEn"
    }
}

public struct ReplacementUserCerqel : Codable {
    public let nKey : String?
    public let name : String?
    public let email : String?

    enum CodingKeys: String, CodingKey {

        case nKey = "key"
        case name = "Name"
        case email = "Email"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nKey = try values.decodeIfPresent(String.self, forKey: .nKey)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }

}


public struct RelationEquationCerqel : Codable {
    public let paramsIndexes : [Int]?
    public let resultIndexes : [Int]?
    public let equation : String?
    public let totalNumberOfAffectedControls : Int?

    enum CodingKeys: String, CodingKey {

        case paramsIndexes = "paramsIndexes"
        case resultIndexes = "resultIndexes"
        case equation = "equation"
        case totalNumberOfAffectedControls = "totalNumberOfAffectedControls"
    }


}

public struct VisitorInfoCerqel : Codable, Mappable, FormValueCerqel {
    public var name : String?
    public var mobileNumber : String?
    public var nationalPassport : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case mobileNumber = "mobileNumber"
        case nationalPassport = "nationalPassport"
    }
    
    public func encode(to encoder: Encoder) throws {}

    
    public init(){}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        mobileNumber <- map["mobileNumber"]
        nationalPassport <- map["nationalPassport"]

    }

    public func validate()-> Bool{
        if let _ = name, let _ = nationalPassport, let _ = mobileNumber{
            return true
        }
        return false
    }
}


public struct newEmployeeStatusValueCerqel: Codable, FormValueCerqel {
    public let requestType : ModelKeyTextCerqel?
    public let effectiveDateFrom : String?
    public let employeeId : String?
    public let employeeName : String?
    public let businessUnitName : String?
    public let departmentName : String?
    public let positionName : String?
    public let reasonsJustifications : String?

    enum CodingKeys: String, CodingKey {

        case requestType = "requestType"
        case effectiveDateFrom = "effectiveDateFrom"
        case employeeId = "employeeId"
        case employeeName = "employeeName"
        case businessUnitName = "businessUnitName"
        case departmentName = "departmentName"
        case positionName = "positionName"
        case reasonsJustifications = "reasonsJustifications"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestType = try values.decodeIfPresent(ModelKeyTextCerqel.self, forKey: .requestType)
        effectiveDateFrom = try values.decodeIfPresent(String.self, forKey: .effectiveDateFrom)
        employeeId = try values.decodeIfPresent(String.self, forKey: .employeeId)
        employeeName = try values.decodeIfPresent(String.self, forKey: .employeeName)
        businessUnitName = try values.decodeIfPresent(String.self, forKey: .businessUnitName)
        departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
        positionName = try values.decodeIfPresent(String.self, forKey: .positionName)
        reasonsJustifications = try values.decodeIfPresent(String.self, forKey: .reasonsJustifications)
    }

}

public struct ModelKeyTextCerqel : Codable {
    public let key : String?
    public let text : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case text = "text"
    }


}


public struct newtransferRequestValueCerqel: Codable, FormValueCerqel {
    public let requestType : ModelKeyTextCerqel?
    public let effectiveDatefrom : String?
    public let lastUpdatedDate : String?
    public let employeeId : String?
    public let hireDate : [String]?
    public let employeeName : [String]?
    public let businessUnitName : [String]?
    public let departmentName : [String]?
    public let managerId : [String]?
    public let positionCode : [String]?
    public let newBusinessUnitName : ModelKeyTextCerqel?
    public let newDepartmentName : ModelKeyTextCerqel?
    public let newManagerId : String?
    public let newJobCode : String?
    public let notes : String?

    enum CodingKeys: String, CodingKey {

        case requestType = "requestType"
        case effectiveDatefrom = "effectiveDatefrom"
        case lastUpdatedDate = "lastUpdatedDate"
        case employeeId = "employeeId"
        case hireDate = "hireDate"
        case employeeName = "employeeName"
        case businessUnitName = "businessUnitName"
        case departmentName = "departmentName"
        case managerId = "managerId"
        case positionCode = "positionCode"
        case newBusinessUnitName = "newBusinessUnitName"
        case newDepartmentName = "newDepartmentName"
        case newManagerId = "newManagerId"
        case newJobCode = "newJobCode"
        case notes = "notes"
    }

}


public protocol SearchControlResultCerqel: FormValueCerqel {
    var isSelected: Bool { set get}
    var presentedText: String { set get}
}

/*
internal struct SearchControlResult_EmployeeModelCerqel : Codable, Mappable, SearchControlResultCerqel {
    
    public var name : String?
    public var arabicName : String?
    public var email : String?
    public var department : String?
    public var phone : String?
    public var employeePF : String?
    public var isSelected: Bool = false
    public var presentedText: String = ""


    enum CodingKeys: String, CodingKey {

        case name = "name"
        case email = "email"
        case department = "department"
        case phone = "phone"
        case employeePF = "employeePF"
        case arabicName
    }
    
    public init?(map: Map) {
        
    }
    
    mutating public func mapping(map: Map) {
        name <- map["name"]
        arabicName <- map["arabicName"]
        email <- map["email"]
        department <- map["department"]
        phone <- map["phone"]
        employeePF <- map["employeePF"]

    }
    

    static public func DTO(data: [[String: Any]]) -> [SearchControlResult_EmployeeModelCerqel]{
        var arr = Mapper<SearchControlResult_EmployeeModelCerqel>().mapArray(JSONArray: data)
        if arr.count > 0{
            for i in 0 ... arr.count - 1{
                arr[i].presentedText = arr[i].arabicName ?? ""
            }

        }
        return arr
    }

}
*/
public struct SearchControlResult_EmployeeModelCerqel: Codable, Hashable {
    public var name: String?
    public var arabicName: String?
    public var email: String?
    public var department: String?
    public var phone: String?
    public var employeePF: String?
    public var isSelected: Bool = false
    public var presentedText: String = ""

    public init() {}

    // Host-project-friendly initializer
    public init?(map: [String: Any]) {
        self.name = map["name"] as? String
        self.arabicName = map["arabicName"] as? String
        self.email = map["email"] as? String
        self.department = map["department"] as? String
        self.phone = map["phone"] as? String
        self.employeePF = map["employeePF"] as? String
        self.presentedText = self.arabicName ?? ""
    }

    public func toJSON() -> [String: Any] {
        [
            "name": name as Any,
            "arabicName": arabicName as Any,
            "email": email as Any,
            "department": department as Any,
            "phone": phone as Any,
            "employeePF": employeePF as Any
        ]
    }
}

internal struct SearchEmployeeAdapter: Mappable {

    var wrapped: SearchControlResult_EmployeeModelCerqel

    init?(map: Map) {
        self.wrapped = SearchControlResult_EmployeeModelCerqel()
        self.mapping(map: map)
    }

    mutating func mapping(map: Map) {
        var name: String?
        var arabicName: String?
        var email: String?
        var department: String?
        var phone: String?
        var employeePF: String?

        name        <- map["name"]
        arabicName  <- map["arabicName"]
        email       <- map["email"]
        department  <- map["department"]
        phone       <- map["phone"]
        employeePF  <- map["employeePF"]

        wrapped.name = name
        wrapped.arabicName = arabicName
        wrapped.email = email
        wrapped.department = department
        wrapped.phone = phone
        wrapped.employeePF = employeePF
        wrapped.presentedText = arabicName ?? ""
    }

    func toPublic() -> SearchControlResult_EmployeeModelCerqel {
        wrapped
    }
}

public extension SearchControlResult_EmployeeModelCerqel {

    static func DTO(data: [[String: Any]]) -> [SearchControlResult_EmployeeModelCerqel] {
        let adapters = Mapper<SearchEmployeeAdapter>()
            .mapArray(JSONArray: data)

        return adapters.map { $0.toPublic() }
    }
}

public enum SearchControlResultTypesCerqel: String{
    case EmployeeModel
}
