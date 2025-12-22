//
//  ModelFormCerqel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import ObjectMapper

let Service_Name_LeavesCerqel = "Leaves"
let service_Name_NewEmployeeImprovement_PlanCerqel = "newEmployeeImprovementPlan"
let Service_Name_newEmployeeStatusCerqel = "newEmployeeStatus"
let Service_Name_newtransferRequestCerqel = "newtransferRequest"
let Service_Name_EmployeeInfoCerqel = "EmployeeInfo"



struct ModelFormCerqel : Codable {
    let requestForm : RequestFormCerqel?
    let serviceName : String?

    enum CodingKeys: String, CodingKey {

        case requestForm = "requestForm"
        case serviceName = "serviceName"
    }
}

struct ModelNestedFormValueCerqel : Codable, FormValueCerqel {
    let val : [ModelControlCerqel]?
    enum CodingKeys: String, CodingKey {

        case val = "val"
    }

}


protocol FormValueCerqel: Codable {}

extension String: FormValueCerqel {}
extension Bool: FormValueCerqel {}


struct ModelControlCerqel : Codable, FormValueCerqel {
    var options : [OptionsCerqel]?
    var id : String?
    var type : ControlType?
    var format : String?
    var index : Int?
    var formCode : String?
    var value : [FormValueCerqel?]?
    var readOnly : Bool?
    var isVisibleInViewMode : Bool?
    var isRequired : Bool?
    var isValueDynamic : Bool?
    var dataSourceType : String?
    var dataSourceId : String?
    var name : String?
    var translations : String?
    var label : String?
    var description : String?
    var placeHolder : String?
    var dateFromPlaceholder : String?
    var dateToPlaceholder : String?
    var timeFromPlaceholder : String?
    var timeToPlaceholder : String?
    var isVisible : Bool?
    var isMultiSelect : Bool?
    var roles : [String]?
    var icon : String?
    var style : StyleCerqel?
    var validations : [ValidationsCerqel]?
    var dependencies : [String]?
    var conditionalView : ConditionalViewCerqel?
    var isExpanded: Bool = false
    var isHidden: Bool = false
    var isValid = false
    var notValidType: ValidationName?
    var contentType: ContentType?
    var filesNumber : Int?
    
    let valuePathEn : String?
    let valuePathAr : String?
    let dataSourceUrl : String?
    let isSubmitted : Bool?
    let calendarType : CalendarTypeCerqel?
    /// in Days
    let maxDate : Int?
    /// in Days
    let minDate : Int?
    /// in minutes
    let maxTime : Int?
    /// in minutes
    let minTime : Int?
    let startMin: DateValidationObject?
    let startMax: DateValidationObject?
    let endMin: DateValidationObject?
    let endMax: DateValidationObject?
    let isMaxMonth: Bool?
    let isMinMonth: Bool?
    let datePlaceholder : String?
    let timePlaceholder : String?
    var dateFormat : String?
    let timeFormat : String?
    let cascadingChildrenIndexes : [Int]?
    let cascadingParentIndexes : [Int]?
    let isLovDataSource : Bool?
    var relationEquation: RelationEquationCerqel?
    let multipleValue: Bool?

    /// for NestedForm (control -> Table)
    var controls : [ModelControlCerqel]?
    var coltrolRow : [[ModelControlCerqel]]?
    
    var additionalProperty01: AdditionalPropertyCerqel?
    var additionalProperty02: AdditionalPropertyCerqel?
    var additionalProperty03: AdditionalPropertyCerqel?
    var additionalProperty04: AdditionalPropertyCerqel?

    /// to show thumbnail
    var isImagePreview: Bool?
    
    var searchChildrenIndexes: [Int]?
    var searchMappingModel: String?
    var dataSourceBaseUrl: String?
    /// this is a local value not comming from API
    var searchResultValue: [SearchControlResultCerqel]?
    /// this is a local value not comming from API
    var searchedText: String?
    
    var mappedValue: String?
    
    
    
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
    
    
     init(from decoder: Decoder) throws {
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
//        case .RadioButton, .DropDown:
//            value = try? values.decodeIfPresent([OptionsCerqel].self, forKey: .value)
//        case .TextBox, .TextArea, .Link, .Label, .InfoIndicator, .DatePicker, .DateTimePicker, .DateRangePicker, .TimePicker, .DateTimeRangePicker:
//            value = try? values.decodeIfPresent([String].self, forKey: .value)
//        case .FileUpload:
//            value = try? values.decodeIfPresent([ReqDetailsAttachmentValueCerqel].self, forKey: .value)
//        case .Switch, .CheckBox:
//            value = try? values.decodeIfPresent([Bool].self, forKey: .value)
//        case .table:
//            value = try? values.decodeIfPresent([ModelControlCerqel].self, forKey: .value)
//
//
//        case .customComponent:
//            if let name = name, name == Service_Name_LeavesCerqel{
//                value = try? values.decodeIfPresent([LeavesViewValueCerqel].self, forKey: .value)
//            }else if let name = name, name == Service_Name_newEmployeeStatusCerqel{
//                value = try? values.decodeIfPresent([newEmployeeStatusValueCerqel].self, forKey: .value)
//            }else if let name = name, name == Service_Name_newtransferRequestCerqel{
//                value = try? values.decodeIfPresent([newtransferRequestValueCerqel].self, forKey: .value)
//            }else if let name = name, name == Service_Name_EmployeeInfoCerqel{
//                value = try? values.decodeIfPresent([VisitorInfoCerqel].self, forKey: .value)
//            }else if let name = name, name == service_Name_NewEmployeeImprovement_PlanCerqel{
//                value = try? values.decodeIfPresent([ImprovementPlanViewValueCerqel].self, forKey: .value)
//            }
//            
            
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
    
    func encode(to encoder: Encoder) throws {
        
    }


}

struct AdditionalPropertyCerqel : Codable {
    var contentType : String?
    var isRequired : Bool?
    var isVisible : Bool?
    var id : String?
    var label : String?
    var name : String?
    var placeHolder : String?
    var readOnly : Bool?
    var translations : String?
    var type : String?
    var value : String?
    var validations : [ValidationsCerqel]?

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

struct RequestFormCerqel : Codable {
    var id : String?
    var name : String?
    var controls : [ModelControlCerqel]?
    var formCode : String?
    var version : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case controls = "controls"
        case formCode = "formCode"
        case version = "version"
    }
}


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

struct ConditionalViewCerqel : Codable {
    var validConditions : Int?
    var conditions : [ModelconditionCerqel]?
    var minimumAcceptableConditionsNumber: Int?

    enum CodingKeys: String, CodingKey {

        case validConditions = "validConditions"
        case conditions = "conditions"
        case minimumAcceptableConditionsNumber
    }
}

struct StyleCerqel : Codable {
    var border : String?
    var borderType : String?
    var borderColor : String?
    var backgroundColor : String?
    var textColor : String?
    var textAlign : String?
    var font : String?
    var fontSize : String?

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

struct ValidationsCerqel : Codable {
    var name : ValidationName?
    var value : String?
    var message : String?
    var isValid: Bool = false

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
        case message = "message"
    }
}

struct ModelconditionCerqel : Codable {
    var parentFieldId : String?
    var parentFieldIndex : Int?
    var validationName : ValidationName?
    var value : String?
    var validityStatus : Bool?

    enum CodingKeys: String, CodingKey {

        case parentFieldId = "parentFieldId"
        case parentFieldIndex = "parentFieldIndex"
        case validationName = "validationName"
        case value = "value"
        case validityStatus = "validityStatus"
    }
}


enum CalendarTypeCerqel: String, Codable{
    case Gregorian
    case Hijri
    case Gregorian_Hijri = "Gregorian/Hijri"
}


struct LeavesViewValueCerqel : Codable, FormValueCerqel {
    let actionType : String?
    let externalCode : String?
    let startDate : String?
    let endDate : String?
    let startTime : String?
    let endTime : String?
    let leaveType : ViewLeaves_NameKeyCerqel?
    let replacementUser : ReplacementUserCerqel?
    let compassionateRelation : ViewLeaves_NameKeyCerqel?
    let accompanyingRelation : ViewLeaves_NameKeyCerqel?
    let businessPermissionPurpose : ViewLeaves_NameKeyCerqel?
    let attachmentId : String?
    let AttachmentName : String?
    let attachmentUrl : String?
    let isFileManager : Bool?
    let attachments: leaveAttttValueCerqel?
    let requestingDays: Int?
    let requestingHours: Int?

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

    init(from decoder: Decoder) throws {
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

struct ImprovementPlanViewValueCerqel : Codable, FormValueCerqel {
    let businessUnitName : String?
    let departmentName : String?
    let effectiveDateFrom : String?
    let employeeId : String?
    let employeeName : String?
    let positionName : String?
    let reasonsJustifications : String?
    let requestType : ModelKeyTextCerqel?

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

    init(from decoder: Decoder) throws {
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



struct leaveAttttValueCerqel : Codable {
    let value : [AttachmentsCerqel]?

    enum CodingKeys: String, CodingKey {

        case value = "value"
    }
}

struct ViewLeaves_NameKeyCerqel : Codable {
    let key : String?
    let nameAr : String?
    let nameEn : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case nameAr = "NameAr"
        case nameEn = "NameEn"
    }
}

struct ReplacementUserCerqel : Codable {
    let nKey : String?
    let name : String?
    let email : String?

    enum CodingKeys: String, CodingKey {

        case nKey = "key"
        case name = "Name"
        case email = "Email"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nKey = try values.decodeIfPresent(String.self, forKey: .nKey)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }

}



struct RelationEquationCerqel : Codable {
    let paramsIndexes : [Int]?
    let resultIndexes : [Int]?
    let equation : String?
    let totalNumberOfAffectedControls : Int?

    enum CodingKeys: String, CodingKey {

        case paramsIndexes = "paramsIndexes"
        case resultIndexes = "resultIndexes"
        case equation = "equation"
        case totalNumberOfAffectedControls = "totalNumberOfAffectedControls"
    }


}



struct VisitorInfoCerqel : Codable, Mappable, FormValueCerqel {
    var name : String?
    var mobileNumber : String?
    var nationalPassport : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case mobileNumber = "mobileNumber"
        case nationalPassport = "nationalPassport"
    }
    
    func encode(to encoder: Encoder) throws {}

    
    init(){}
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        mobileNumber <- map["mobileNumber"]
        nationalPassport <- map["nationalPassport"]

    }

    func validate()-> Bool{
        if let _ = name, let _ = nationalPassport, let _ = mobileNumber{
            return true
        }
        return false
    }
}


struct newEmployeeStatusValueCerqel: Codable, FormValueCerqel {
    let requestType : ModelKeyTextCerqel?
    let effectiveDateFrom : String?
    let employeeId : String?
    let employeeName : String?
    let businessUnitName : String?
    let departmentName : String?
    let positionName : String?
    let reasonsJustifications : String?

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

    init(from decoder: Decoder) throws {
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

struct ModelKeyTextCerqel : Codable {
    let key : String?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case text = "text"
    }


}


struct newtransferRequestValueCerqel: Codable, FormValueCerqel {
    let requestType : ModelKeyTextCerqel?
    let effectiveDatefrom : String?
    let lastUpdatedDate : String?
    let employeeId : String?
    let hireDate : [String]?
    let employeeName : [String]?
    let businessUnitName : [String]?
    let departmentName : [String]?
    let managerId : [String]?
    let positionCode : [String]?
    let newBusinessUnitName : ModelKeyTextCerqel?
    let newDepartmentName : ModelKeyTextCerqel?
    let newManagerId : String?
    let newJobCode : String?
    let notes : String?

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


protocol SearchControlResultCerqel: FormValueCerqel {
    var isSelected: Bool { set get}
    var presentedText: String { set get}
}


struct SearchControlResult_EmployeeModelCerqel : Codable, Mappable, SearchControlResultCerqel {
    
    var name : String?
    var arabicName : String?
    var email : String?
    var department : String?
    var phone : String?
    var employeePF : String?
    var isSelected: Bool = false
    var presentedText: String = ""


    enum CodingKeys: String, CodingKey {

        case name = "name"
        case email = "email"
        case department = "department"
        case phone = "phone"
        case employeePF = "employeePF"
        case arabicName
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        arabicName <- map["arabicName"]
        email <- map["email"]
        department <- map["department"]
        phone <- map["phone"]
        employeePF <- map["employeePF"]

    }
    

    static func DTO(data: [[String: Any]]) -> [SearchControlResult_EmployeeModelCerqel]{
        var arr = Mapper<SearchControlResult_EmployeeModelCerqel>().mapArray(JSONArray: data)
        if arr.count > 0{
            for i in 0 ... arr.count - 1{
                arr[i].presentedText = arr[i].arabicName ?? ""
            }

        }
        return arr
    }

}


enum SearchControlResultTypesCerqel: String{
    case EmployeeModel
}
