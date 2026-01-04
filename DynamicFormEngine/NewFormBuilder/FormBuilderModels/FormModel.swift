//
//  FormModel.swift
//  CHECK
//
//  Created by Yasser Osama on 24/10/2021.
//

import Foundation
internal import ObjectMapper

struct FormModel: Mappable {
    public var id: String?
    public var title: String?
    var score: Int?
    var templateId: String?
    var themeId: String?
    var settings: Settings?
    var properties: FormProperties?
    var fields: [Field]? {
        didSet {
            fields = FormBuilder.shared.sort(fields: fields ?? [])
        }
    }
    var rules: [Rule]?
    var warnings: Warning?
    var formCode : String?
    
    public init?(map: Map) {
        //empty
    }
        
    mutating public func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        score <- map["score"]
        templateId <- map["templateId"]
        themeId <- map["themeId"]
        settings <- map["settings"]
        properties <- map["properties"]
        fields <- map["fields"]
        rules <- map["rules"]
        warnings <- map["warnings"]
        formCode <- map["formCode"]
    }
}

struct Settings: Mappable, Codable {
    var format: String?
    var enableScoreCalculation: Bool?
    var defaultLanguage: String?
    var languages: [String]?
    var enablePageValidation: Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case format = "format"
        case enableScoreCalculation = "enableScoreCalculation"
        case defaultLanguage = "defaultLanguage"
        case languages = "languages"
        case enablePageValidation = "enablePageValidation"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format)
        enableScoreCalculation = try values.decodeIfPresent(Bool.self, forKey: .enableScoreCalculation)
        defaultLanguage = try values.decodeIfPresent(String.self, forKey: .defaultLanguage)
        languages = try values.decodeIfPresent([String].self, forKey: .languages)
        enablePageValidation = try values.decodeIfPresent(Bool.self, forKey: .enablePageValidation)
    }

    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        format <- map["format"]
        enableScoreCalculation <- map["enableScoreCalculation"]
        defaultLanguage <- map["defaultLanguage"]
        languages <- map["languages"]
        enablePageValidation <- map["enablePageValidation"]
    }
}

struct FormLanguage: Mappable {
    var name: String?
    var code: String?
    var rTL: Bool?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
        rTL <- map["RTL"]
    }
}

struct FormProperties: Mappable {
    var themeId: String?
    var campaign: Campaign?
    var navigationProperties: NavigationProperties?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        themeId <- map["themeId"]
        campaign <- map["campaign"]
        navigationProperties <- map["navigationProperties"]
    }
}

struct Campaign: Mappable, Codable {
    var header: CampaignObject?
    var footer: CampaignObject?
    var welcome: CampaignObject?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        header <- map["header"]
        footer <- map["footer"]
        welcome <- map["welcome"]
    }
    
    enum CodingKeys: String, CodingKey {
        
        case header = "header"
        case footer = "footer"
        case welcome = "welcome"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        header = try values.decodeIfPresent(CampaignObject.self, forKey: .header)
        footer = try values.decodeIfPresent(CampaignObject.self, forKey: .footer)
        welcome = try values.decodeIfPresent(CampaignObject.self, forKey: .welcome)
    }
}

struct CampaignObject: Mappable, Codable {
    var logo: String?
    var title: String?
    var description: String?
    var showQuestionCount: Bool?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        logo <- map["logo"]
        title <- map["title"]
        description <- map["description"]
        showQuestionCount <- map["showQuestionCount"]
    }
    
    enum CodingKeys: String, CodingKey {
        
        case logo = "logo"
        case title = "title"
        case description = "description"
        case showQuestionCount = "showQuestionCount"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        showQuestionCount = try values.decodeIfPresent(Bool.self, forKey: .showQuestionCount)
    }

}

struct Field: Mappable {
    var id: String?
    var type: FieldType?
    var subType: TextBoxSubType?
    var paragraphSubType: ParagraphSubType?
    var paragraphStyle: FormStyle?
    var icon:String?
    var parentId: String?
    var rowIndex: String?
    var order: String?
    var templateQuestionId: String?
    var properties: BaseProperties?
    var answer: Any?
    var defualtSummaryAnswer: Any?
    var defualtTabldItemsSummaryAnswer: Any?

    var fieldRules: FieldRule?
    var visibilityPermissions: [String]?
    
    public init?(map: Map) {
        //empty
    }
    
    public init(id: String? = nil, type: FieldType? = nil, subType: TextBoxSubType? = nil, paragraphSubType: ParagraphSubType? = nil, paragraphStyle: FormStyle? = nil, icon: String? = nil, parentId: String? = nil, rowIndex: String? = nil, order: String? = nil, templateQuestionId: String? = nil, properties: BaseProperties? = nil, answer: Any? = nil, defualtSummaryAnswer: Any? = nil, defualtTabldItemsSummaryAnswer: Any? = nil, fieldRules: FieldRule? = nil, visibilityPermissions: [String]? = nil) {
        self.id = id
        self.type = type
        self.subType = subType
        self.paragraphSubType = paragraphSubType
        self.paragraphStyle = paragraphStyle
        self.icon = icon
        self.parentId = parentId
        self.rowIndex = rowIndex
        self.order = order
        self.templateQuestionId = templateQuestionId
        self.properties = properties
        self.answer = answer
        self.defualtSummaryAnswer = defualtSummaryAnswer
        self.defualtTabldItemsSummaryAnswer = defualtTabldItemsSummaryAnswer
        self.fieldRules = fieldRules
        self.visibilityPermissions = visibilityPermissions
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        subType <- map["subType"]
        paragraphSubType <- map["paragraphSubType"]
        icon <- map["icon"]
        paragraphStyle <- map["style"]
        parentId <- map["parentId"]
        rowIndex <- map["rowIndex"]
        order <- map["order"]
        templateQuestionId <- map["templateQuestionId"]
        answer <- map["value"]
        defualtSummaryAnswer <- map["value"]
        defualtTabldItemsSummaryAnswer <- map["value"]
        visibilityPermissions <- map["visibilityPermissions"]
        properties <- map["properties"]
        
        switch type {
        case .Page:
            var lProperties: NavigationProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .TextBox:
            var lProperties: TextBoxProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .TextArea:
            var lProperties: TextAreaProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Numerical:
            var lProperties: NumberProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Paragraph:
            var lProperties: ParagraphProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Date:
            var lProperties: DateTimeProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Map:
            var lProperties: MapProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Slider:
            var lProperties: SliderProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .NPS:
            var lProperties: NpsProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Rate:
            var lProperties: RateProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .FaceRate:
            var lProperties: FaceRateProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Checkbox:
            var lProperties: CheckboxProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Radio:
            var lProperties: CheckboxProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Dropdown:
            var lProperties: DropdownProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Location:
            var lProperties: InteractiveProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .Table:
            var lProperties: TableProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .FileUpload:
            var lProperties: FileUploadProperties?
            lProperties <- map["properties"]
            properties = lProperties
        case .switchControl:
            var lProperties: switchProperties?
            lProperties <- map["properties"]
            properties = lProperties
        default:
            properties <- map["properties"]
        }
        fieldRules <- map["rules"]
    }
}

public enum FieldType: String, Codable {
    case Page = "Page"
    case Section = "Section"
    case Label = "Label"
    case TextBox = "TextBox"
    case TextArea = "TextArea"
    case Numerical = "Number"
    case Paragraph = "Paragraph"
    case Date = "DateTime"
    case Submit = "Submit"
    case Map = "Map"
    case Location = "Location"
    case Slider = "Slider"
    case NPS = "NPS"
    case Rate = "Rate"
    case FaceRate = "FaceRate"
    case Checkbox = "Checkbox"
    case Radio = "Radio"
    case Dropdown = "Dropdown"
    case Table = "Table"
    case FileUpload = "FileUpload"
    case switchControl = "Switch"
}

struct Rule: Mappable {
    var id: String?
    var disabled: Bool?
    var operation: RuleOperation?
    var ifConditions: [IfCondition]?
    var doActions: [DoAction]?
    var actionsCategory: String?
    var excludedViews: [ExcludedViews]?
    var isValid: Bool?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        disabled <- map["disabled"]
        operation <- map["operation"]
        ifConditions <- map["ifConditions"]
        doActions <- map["doActions"]
        actionsCategory <- map["actionsCategory"]
        excludedViews <- map["excludedViews"]
        isValid <- map["isValid"]
    }
}

struct IfCondition: Mappable {
    var fieldId: String?
    var fieldState: FieldState?
    var target: String?
    var value: String?
    var quota: Int?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        fieldId <- map["fieldId"]
        fieldState <- map["fieldState"]
        target <- map["target"]
        value <- map["value"]
        quota <- map["quota"]
    }
}

public struct SetPropertyPayload {
    var IsExternal: Bool?
    var targetPropertyName: String?
    var id: String?
    var parameters: String?
}

public struct Payload {
    var id: String?
    var parameters: [String]?
}

struct DoAction: Mappable {
    var type: ActionType?
    var sourceFieldsIds: [String]?
    var targetFieldsIds: [String]?
    var expression: String?
    var actionImpact: String?
    var payload: AnyObject? //Payload?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        type <- map["type"]
        sourceFieldsIds <- map["sourceFieldsIds"]
        targetFieldsIds <- map["targetFieldsIds"]
        expression <- map["expression"]
        actionImpact <- map["actionImpact"]
        payload <- map["payload"]
    }
}

struct FieldRule: Mappable {
    var effectIn: [String]?
    var dependOn: [String]?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        effectIn <- map["effectIn"]
        dependOn <- map["dependOn"]
    }
}

public enum RuleOperation: String, Codable {
    case OR = "Any"
    case And = "All"
}

public enum FieldState: String, Codable {
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

public enum ActionType: String, Codable {
    case Show = "Show"
    case Enable = "Enable"
    case Hide = "Hide"
    case Disable = "Disable"
    case Require = "Require"
    case UnRequire = "UnRequire"
    case Calculate = "Calculate"
    case Copy = "Copy"
    case SkipToPage = "SkipToPage"
    case Cascade = "Cascade"
    case RangeIncluded = "RangeIncluded"
    case SetProperty = "SetProperty"
    case Validation = "Validation"
}
