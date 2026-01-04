//
//  ModelForm.swift
//
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
internal import ObjectMapper

public let Service_Name_Leaves = "Leaves"
public let service_Name_NewEmployeeImprovement_Plan = "newEmployeeImprovementPlan"
public let Service_Name_newEmployeeStatus = "newEmployeeStatus"
public let Service_Name_newtransferRequest = "newtransferRequest"
public let Service_Name_EmployeeInfo = "EmployeeInfo"


struct ModelForm : Codable {
    public let requestForm : RequestForm?
    public let serviceName : String?
    public let formVersion: String?

    enum CodingKeys: String, CodingKey {

        case requestForm = "requestForm"
        case serviceName = "serviceName"
        case formVersion = "formVersionId"
    }
}

struct ModelNestedFormValue {
    public let val : [FormViewModelItem]? //[ModelControl]?
//    enum CodingKeys: String, CodingKey {
//
//        case val = "val"
//    }

}


public protocol FormValue: Codable {}

extension String: FormValue {}
extension Bool: FormValue {}

public typealias dic = [String:String]
extension dic: FormValue {}



struct ModelControl : Codable, FormValue {
    var options : [Options]?
    public var id : String?
    public var type : ControlType?
    public var format : String?
    public var index : Int?
    public var formCode : String?
    public var value : [FormValue?]?
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
    public var style : Style?
    public var validations : [Validations]?
    public var dependencies : [String]?
    public var conditionalView : ConditionalView?
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
    public let calendarType : CalendarType?
    /// in Days
    public let maxDate : Int?
    /// in Days
    public let minDate : Int?
    /// in minutes
    public let maxTime : Int?
    /// in minutes
    let minTime : Int?
    let startMin: DateValidationObject?
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
    public var relationEquation: RelationEquation?
    public let multipleValue: Bool?

    /// for NestedForm (control -> Table)
    public var controls : [ModelControl]?
    public var coltrolRow : [[ModelControl]]?
    
    public var additionalProperty01: AdditionalProperty?
    public var additionalProperty02: AdditionalProperty?
    public var additionalProperty03: AdditionalProperty?
    public var additionalProperty04: AdditionalProperty?

    /// to show thumbnail
    public var isImagePreview: Bool?
    
    public var searchChildrenIndexes: [Int]?
    public var searchMappingModel: String?
    public var dataSourceBaseUrl: String?
    /// this is a local value not comming from API
    public var searchResultValue: [SearchControlResult]?
    /// this is a local value not comming from API
    public var searchedText: String?
    
    public var mappedValue: String?
    
    
    
    enum CodingKeys: String, CodingKey {

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
        options = try values.decodeIfPresent([Options].self, forKey: .options)
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
        style = try values.decodeIfPresent(Style.self, forKey: .style)
        validations = try values.decodeIfPresent([Validations].self, forKey: .validations)
        dependencies = try values.decodeIfPresent([String].self, forKey: .dependencies)
        conditionalView = try values.decodeIfPresent(ConditionalView.self, forKey: .conditionalView)
        contentType = try values.decodeIfPresent(ContentType.self, forKey: .contentType)
        if contentType == .multiSelect{
            self.isMultiSelect = true
        }
        filesNumber = try values.decodeIfPresent(Int.self, forKey: .filesNumber)
        valuePathEn = try values.decodeIfPresent(String.self, forKey: .valuePathEn)
        valuePathAr = try values.decodeIfPresent(String.self, forKey: .valuePathAr)
        dataSourceUrl = try values.decodeIfPresent(String.self, forKey: .dataSourceUrl)
        isSubmitted = try values.decodeIfPresent(Bool.self, forKey: .isSubmitted)
        calendarType = try values.decodeIfPresent(CalendarType.self, forKey: .calendarType)
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
        relationEquation = try values.decodeIfPresent(RelationEquation.self, forKey: .relationEquation)
        multipleValue = try values.decodeIfPresent(Bool.self, forKey: .multipleValue)
        controls = try values.decodeIfPresent([ModelControl].self, forKey: .controls)
        coltrolRow = try values.decodeIfPresent([[ModelControl]].self, forKey: .coltrolRow)
        isImagePreview = try values.decodeIfPresent(Bool.self, forKey: .isImagePreview)
        searchChildrenIndexes = try values.decodeIfPresent([Int].self, forKey: .searchChildrenIndexes)
        searchMappingModel = try values.decodeIfPresent(String.self, forKey: .searchMappingModel)
        dataSourceBaseUrl = try values.decodeIfPresent(String.self, forKey: .dataSourceBaseUrl)
        mappedValue = try values.decodeIfPresent(String.self, forKey: .mappedValue)
        
        
        additionalProperty01 = try values.decodeIfPresent(AdditionalProperty.self, forKey: .additionalProperty01)
        additionalProperty02 = try values.decodeIfPresent(AdditionalProperty.self, forKey: .additionalProperty02)
        additionalProperty03 = try values.decodeIfPresent(AdditionalProperty.self, forKey: .additionalProperty03)
        additionalProperty04 = try values.decodeIfPresent(AdditionalProperty.self, forKey: .additionalProperty04)


        switch type{
        case .RadioButton, .DropDown:
            value = try values.decodeIfPresent([Options].self, forKey: .value)
        case .TextBox, .TextArea, .Link, .Label, .InfoIndicator, .DatePicker, .DateTimePicker, .DateRangePicker, .TimePicker, .DateTimeRangePicker:
            value = try values.decodeIfPresent([String].self, forKey: .value)
        case .FileUpload:
            value = try values.decodeIfPresent([ReqDetailsAttachmentValue].self, forKey: .value)
        case .Switch, .CheckBox:
            value = try values.decodeIfPresent([Bool].self, forKey: .value)
        case .table:
            value = try values.decodeIfPresent([ModelControl].self, forKey: .value)


        case .customComponent:
            if let name = name, name == Service_Name_Leaves{
                value = try values.decodeIfPresent([LeavesViewValue].self, forKey: .value)
            }else if let name = name, name == Service_Name_newEmployeeStatus{
                value = try values.decodeIfPresent([newEmployeeStatusValue].self, forKey: .value)
            }else if let name = name, name == Service_Name_newtransferRequest{
                value = try values.decodeIfPresent([newtransferRequestValue].self, forKey: .value)
            }else if let name = name, name == Service_Name_EmployeeInfo{
                value = try values.decodeIfPresent([VisitorInfo].self, forKey: .value)
            }else if let name = name, name == service_Name_NewEmployeeImprovement_Plan{
                value = try values.decodeIfPresent([ImprovementPlanViewValue].self, forKey: .value)
            }
                
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

public struct AdditionalProperty : Codable {
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
    public var validations : [Validations]?

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

struct RequestForm : Codable {
    public var id : String?
    public var name : String?
    public var controls : [ModelControl]?
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

struct OptionsInProp : Codable, Mappable {
    public var id : String?
    public var name : String?
    public var name_ar : String?

    public init?(map: Map) {}

    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
    }

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case name_ar = "name_ar"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        name_ar = try values.decodeIfPresent(String.self, forKey: .name_ar)
    }

}

struct Options : Codable, Mappable, FormValue {
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
    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
    }
    

}

public struct ConditionalView : Codable {
    public var validConditions : Int?
    public var conditions : [Modelcondition]?
    public var minimumAcceptableConditionsNumber: Int?

    enum CodingKeys: String, CodingKey {

        case validConditions = "validConditions"
        case conditions = "conditions"
        case minimumAcceptableConditionsNumber
    }
}

public struct Style : Codable {
    public var border : String?
    public var borderType : String?
    public var borderColor : String?
    public var backgroundColor : String?
    public var textColor : String?
    public var textAlign : String?
    public var font : String?
    public var fontSize : String?

    enum CodingKeys: String, CodingKey {

        case border = "Border"
        case borderType = "BorderType"
        case borderColor = "BorderColor"
        case backgroundColor = "BackgroundColor"
        case textColor = "TextColor"
        case textAlign = "TextAlign"
        case font = "Font"
        case fontSize = "FontSize"
    }
}

public struct Validations : Codable {
    public var name : ValidationName?
    public var value : String?
    public var message : String?
    public var isValid: Bool = false

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
        case message = "message"
    }
}

public struct Modelcondition : Codable {
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


public enum CalendarType: String, Codable{
    case Gregorian
    case Hijri
    case Gregorian_Hijri = "Gregorian/Hijri"
}


public struct LeavesViewValue : Codable, FormValue {
    let actionType : String?
    let externalCode : String?
    let startDate : String?
    public let endDate : String?
    public let startTime : String?
    public let endTime : String?
    public let leaveType : ViewLeaves_NameKey?
    public let replacementUser : ReplacementUser?
    public let compassionateRelation : ViewLeaves_NameKey?
    public let accompanyingRelation : ViewLeaves_NameKey?
    public let businessPermissionPurpose : ViewLeaves_NameKey?
    public let attachmentId : String?
    public let AttachmentName : String?
    public let attachmentUrl : String?
    public let isFileManager : Bool?
    public let attachments: leaveAttttValue?
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
        leaveType = try values.decodeIfPresent(ViewLeaves_NameKey.self, forKey: .leaveType)
        replacementUser = try values.decodeIfPresent(ReplacementUser.self, forKey: .replacementUser)
        compassionateRelation = try values.decodeIfPresent(ViewLeaves_NameKey.self, forKey: .compassionateRelation)
        accompanyingRelation = try values.decodeIfPresent(ViewLeaves_NameKey.self, forKey: .accompanyingRelation)
        businessPermissionPurpose = try values.decodeIfPresent(ViewLeaves_NameKey.self, forKey: .businessPermissionPurpose)
        attachmentId = try values.decodeIfPresent(String.self, forKey: .attachmentId)
        AttachmentName = try values.decodeIfPresent(String.self, forKey: .AttachmentName)
        attachmentUrl = try values.decodeIfPresent(String.self, forKey: .attachmentUrl)
        isFileManager = try values.decodeIfPresent(Bool.self, forKey: .isFileManager)
        attachments = try values.decodeIfPresent(leaveAttttValue.self, forKey: .attachments)
        requestingDays = try values.decodeIfPresent(Int.self, forKey: .requestingDays)
        requestingHours = try values.decodeIfPresent(Int.self, forKey: .requestingHours)
        
    }

}

public struct ImprovementPlanViewValue : Codable, FormValue {
    public let businessUnitName : String?
    public let departmentName : String?
    public let effectiveDateFrom : String?
    public let employeeId : String?
    public let employeeName : String?
    public let positionName : String?
    public let reasonsJustifications : String?
    public let requestType : ModelKeyText?

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
        requestType = try values.decodeIfPresent(ModelKeyText.self, forKey: .requestType)
    }

}



public struct leaveAttttValue : Codable {
    public let value : [Attachments]?

    enum CodingKeys: String, CodingKey {

        case value = "value"
    }
}

public struct ViewLeaves_NameKey : Codable {
    public let key : String?
    public let nameAr : String?
    public let nameEn : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case nameAr = "NameAr"
        case nameEn = "NameEn"
    }
}

public struct ReplacementUser : Codable {
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



public struct RelationEquation : Codable {
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



struct VisitorInfo : Codable, Mappable, FormValue {
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
    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        name <- map["name"]
        mobileNumber <- map["mobileNumber"]
        nationalPassport <- map["nationalPassport"]

    }

    public  func validate()-> Bool{
        if let _ = name, let _ = nationalPassport, let _ = mobileNumber{
            return true
        }
        return false
    }
}


public struct newEmployeeStatusValue: Codable, FormValue {
    public let requestType : ModelKeyText?
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
        requestType = try values.decodeIfPresent(ModelKeyText.self, forKey: .requestType)
        effectiveDateFrom = try values.decodeIfPresent(String.self, forKey: .effectiveDateFrom)
        employeeId = try values.decodeIfPresent(String.self, forKey: .employeeId)
        employeeName = try values.decodeIfPresent(String.self, forKey: .employeeName)
        businessUnitName = try values.decodeIfPresent(String.self, forKey: .businessUnitName)
        departmentName = try values.decodeIfPresent(String.self, forKey: .departmentName)
        positionName = try values.decodeIfPresent(String.self, forKey: .positionName)
        reasonsJustifications = try values.decodeIfPresent(String.self, forKey: .reasonsJustifications)
    }

}

public struct ModelKeyText : Codable {
    public let key : String?
    public let text : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case text = "text"
    }


}


public struct newtransferRequestValue: Codable, FormValue {
    public let requestType : ModelKeyText?
    public let effectiveDatefrom : String?
    public let lastUpdatedDate : String?
    public let employeeId : String?
    public let hireDate : [String]?
    public let employeeName : [String]?
    public let businessUnitName : [String]?
    public let departmentName : [String]?
    public let managerId : [String]?
    public let positionCode : [String]?
    public let newBusinessUnitName : ModelKeyText?
    public let newDepartmentName : ModelKeyText?
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


public protocol SearchControlResult: FormValue {
    var isSelected: Bool { set get}
    var presentedText: String { set get}
}


struct SearchControlResult_EmployeeModel : Codable, Mappable, SearchControlResult {
    
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
    

    static public func DTO(data: [[String: Any]]) -> [SearchControlResult_EmployeeModel]{
        var arr = Mapper<SearchControlResult_EmployeeModel>().mapArray(JSONArray: data)
        if arr.count > 0{
            for i in 0 ... arr.count - 1{
                arr[i].presentedText = arr[i].arabicName ?? ""
            }

        }
        return arr
    }

}


enum SearchControlResultTypes: String{
    case EmployeeModel
}
