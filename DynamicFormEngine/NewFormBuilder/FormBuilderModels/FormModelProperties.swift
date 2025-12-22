//
//  FormModelProperties.swift
//  CHECK
//
//  Created by Yasser Osama on 09/05/2022.
//

import ObjectMapper
import ObjectiveC

public typealias BaseLocalization = [String: BasePropertiesLocalization]
public typealias NavigationLocalization = [String: NavigationPropertiesLocalization]
public typealias InteractiveLocalization = [String: InteractivePropertiesLocalization]
public typealias TextBoxLocalization = [String: TextboxPropertiesLocalization]
public typealias ParagraphLocalization = [String: ParagraphPropertiesLocalization]
public typealias MCQLocalization = [String: MCQBasePropertiesLocalization]
protocol UpdatableProperties {
    func updateProperty(propertyName: String, newValue: Any)
}

public class BaseProperties: Mappable, UpdatableProperties {
    public var label: String?
    public var subLabel: String?
    public var labelPosition: String?
    public var tooltip: String?
    public var hidden: Bool?
    public var disabled: Bool?
    public var localization: BaseLocalization?
    public var subType: TextBoxSubType?
    public var isCollapsedSec: Bool?
    public var dataSourcId: String?
    public var dataSource: DataSource?
    public var readonly: Bool?
    public var required: Bool?
    public var hideIfEmptyInDetails: Bool?
    
    required public init?(map: Map) {
        //empty
    }
    
    public func mapping(map: Map) {
        label <- map["label"]
        subLabel <- map["sublabel"]
        labelPosition <- map["labelPosition"]
        tooltip <- map["tooltip"]
        hidden <- map["hidden"]
        disabled <- map["disabled"]
        localization <- map["localization"]
        subType <- map["subType"]
        isCollapsedSec <- map["isCollapsed"]
        dataSourcId <- map["dataSourcId"]
        readonly <- map["readonly"]
        required <- map["required"]
        dataSource <- map["dataSource"]
        hideIfEmptyInDetails <- map["hideIfEmptyInDetails"]
    }
    
    public func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "label":
            if let value = newValue as? String {
                self.label = value
            }
        case "subLabel":
            if let value = newValue as? String {
                self.subLabel = value
            }
        case "labelPosition":
            if let value = newValue as? String {
                self.labelPosition = value
            }
        case "tooltip":
            if let value = newValue as? String {
                self.tooltip = value
            }
        case "hidden":
            if let value = newValue as? Bool {
                self.hidden = value
            }
        case "disabled":
            if let value = newValue as? Bool {
                self.disabled = value
            }
        case "localization":
            if let value = newValue as? BaseLocalization {
                self.localization = value
            }
        case "subType":
            if let value = newValue as? TextBoxSubType {
                self.subType = value
            }
        case "readonly":
            if let value = newValue as? Bool {
                self.readonly = value
            }
        case "required":
            if let value = newValue as? Bool {
                self.required = value
            }
        case "dataSource":
            if let value = newValue as? DataSource {
                self.dataSource = value
            }
//        case "hideIfEmptyInDetails" :
//            if let value = newValue as? Bool {
//                self.hideIfEmptyInDetails = value
//            }
        default:
            print("Unknown property name: \(propertyName)")
        }
    }
}


public class NavigationProperties: BaseProperties {
    var submit: String?
    var next: String?
    var back: String?
    var backVisibility: Bool?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        submit <- map["submit"]
        next <- map["next"]
        back <- map["back"]
        backVisibility <- map["backVisibility"]
        var lLocalization: NavigationLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
    }
}

public class InteractiveProperties: BaseProperties {
    var addAttachment: Bool?
    var addNote: Bool?
    var attachmentExtensions: String?
    var attachmentType: AttachmentFormType?
    var placeholder: String?
//    var required: Bool?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        addAttachment <- map["addAttachment"]
        addNote <- map["addNote"]
        attachmentExtensions <- map["attachmentExtensions"]
        attachmentType <- map["attachmentType"]
        placeholder <- map["placeholder"]
//        required <- map["required"]
        var lLocalization: InteractiveLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "addAttachment":
            if let value = newValue as? Bool {
                self.addAttachment = value
            }
        case "addNote":
            if let value = newValue as? Bool {
                self.addNote = value
            }
        case "attachmentExtensions":
            if let value = newValue as? String {
                self.attachmentExtensions = value
            }
        case "attachmentType":
            if let value = newValue as? AttachmentFormType {
                self.attachmentType = value
            }
        case "placeholder":
            if let value = newValue as? String {
                self.placeholder = value
            }
//        case "required":
//            if let value = newValue as? Bool {
//                self.required = value
//            }
        default:
            print("Unknown property name: \(propertyName)")
        }
    }
}

public class TextBaseProperties: InteractiveProperties {
   
    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "allowSpellcheck":
            if let value = newValue as? Bool {
                self.allowSpellcheck = value
            }
        case "autocomplete":
            if let value = newValue as? Bool {
                self.autocomplete = value
            }
        case "entryLimit":
            if let value = newValue as? EntryLimit {
                self.entryLimit = value
            }
        case "maximumLength":
            if let value = newValue as? Int {
                self.maximumLength = value
            }
        case "minimumLength":
            if let value = newValue as? Int {
                self.minimumLength = value
            }
        case "textCase":
            if let value = newValue as? TextCase {
                self.textCase = value
            }
        default:
            print("Unknown property name: \(propertyName)")
        }
    }
    
    var allowSpellcheck: Bool?
    var autocomplete: Bool?
    var entryLimit: EntryLimit?
    var maximumLength: Int?
    var minimumLength: Int?
    var textCase: TextCase?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        allowSpellcheck <- map["allowSpellCheck"]
        autocomplete <- map["autocomplete"]
        entryLimit <- map["entryLimit"]
        maximumLength <- map["maximumLength"]
        minimumLength <- map["minimumLength"]
        textCase <- map["textCase"]
    }
}

public class TextBoxProperties: TextBaseProperties {
    var defaultAnswer: DefaultTextboxAnswer?
    var newDefaultAnswer: DefaultTextboxAnswerNewFormat?
    var mask: String?
    var prefix: Prefix?
    var suffix: Suffix?
    var regex: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        defaultAnswer <- map["defaultAnswer"]
        newDefaultAnswer <- map["defaultAnswer"]
        mask <- map["mask"]
        prefix <- map["prefix"]
        suffix <- map["suffix"]
        regex <- map["regex"]
        var lLocalization: TextBoxLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
    }
    
    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "defaultAnswer":
            if let value = newValue as? DefaultTextboxAnswer {
                self.defaultAnswer = value
            }
        case "defaultAnswer":
            if let value = newValue as? DefaultTextboxAnswerNewFormat {
                self.newDefaultAnswer = value
            }
        case "mask":
            if let value = newValue as? String {
                self.mask = value
            }
        case "prefix":
            if let value = newValue as? Prefix {
                self.prefix = value
            }
        case "suffix":
            if let value = newValue as? Suffix {
                self.suffix = value
            }
        case "regex":
            if let value = newValue as? String {
                self.regex = value
            }
        default:
            print("Unknown property name: \(propertyName)")
        }
    }

}

public class TextAreaProperties: TextBaseProperties {
    var autoExpand: Bool?
    var editor: EditorType?
    var fullScreen: Bool?
    var defaultAnswer: DefaultTextAreaAnswer?
    var newDefaultAnswer: DefaultTextAreaAnswerNewFormat?
    var contentType:String?

    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        autoExpand <- map["autoExpand"]
        editor <- map["editor"]
        fullScreen <- map["fullScreen"]
        defaultAnswer <- map["defaultAnswer"]
        newDefaultAnswer <- map["defaultAnswer"]
        contentType <- map["contentType"]
        
    }
    public override func updateProperty(propertyName: String, newValue: Any) {
          switch propertyName {
          case "autoExpand":
              if let value = newValue as? Bool {
                  self.autoExpand = value
              }
          case "editor":
              if let value = newValue as? EditorType {
                  self.editor = value
              }
          case "fullScreen":
              if let value = newValue as? Bool {
                  self.fullScreen = value
              }
          case "defaultAnswer":
              if let value = newValue as? DefaultTextAreaAnswer {
                  self.defaultAnswer = value
              }
          case "contentType":
              if let value = newValue as? String {
                  self.contentType = value
              }
          default:
              print("Unknown property name: \(propertyName)")
          }
      }
}

public class NumberProperties: InteractiveProperties {
    var DecimalPlaces: Int?
    var Step: Int?
    var MinimumDigits: Int?
    var MaximumDigits: Int?
    var MinimumValue: Double?
    var MaximumValue: Double?
    var EntryLimit: String?
    var DefaultAnswer: DefaultNumberBoxAnswer?
    var newDefaultAnswerWhenTextBox: DefaultTextboxAnswerNewFormat?
    var newDefaultAnswer: DefaultNumberBoxAnswerNewFormat?

    var Regex: String?

    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        DecimalPlaces <- map["decimalPlaces"]
        Step <- map["Step"]
        MinimumDigits <- map["minimumDigits"]
        MaximumDigits <- map["maximumDigits"]
        MinimumValue <- map["minimumValue"]
        MaximumValue <- map["maximumValue"]
        EntryLimit <- map["entryLimit"]
        DefaultAnswer <- map["defaultAnswer"]
        newDefaultAnswerWhenTextBox <- map["defaultAnswer"]
        newDefaultAnswer <- map["defaultAnswer"]
        Regex <- map["regex"]
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName.lowercased() {
        case "DecimalPlaces".lowercased():
            if let value = newValue as? String {
                self.DecimalPlaces = Int(value)
            }
        case "Step".lowercased():
            if let value = newValue as? String {
                self.Step = Int(value)
            }
        case "MinimumDigits".lowercased():
            if let value = newValue as? String {
                self.MinimumDigits = Int(value)
            }
        case "MaximumDigits".lowercased():
            if let value = newValue as? String {
                self.MaximumDigits = Int(value)
            }
        case "MinimumValue".lowercased():
            if let value = newValue as? String {
                self.MinimumValue = Double(value)
            }
        case "MaximumValue".lowercased():
            if let value = newValue as? String {
                self.MaximumValue = Double(value)
            }
        case "EntryLimit".lowercased():
            if let value = newValue as? String {
                self.EntryLimit = value
            }
        case "DefaultAnswer".lowercased():
            if let value = newValue as? DefaultNumberBoxAnswer {
                self.DefaultAnswer = value
            }
        case "Regex".lowercased():
            if let value = newValue as? String {
                self.Regex = value
            }
        default:
            print("Unknown property name: \(propertyName)")
        }
    }
}

public class DateTimeProperties: InteractiveProperties {
    var dateTimeType: DateTimeType?
    var dateSelectionMode: DateSelectionMode?
    var dateFormat: DateFormat?
    var timeFormat: TimeFormat?
    var firstDayOfWeek: Int?
    var defaultDateType: DefaultDateTime?
    var defaultTimeType: DefaultDateTime?
    var disabledDates: [String]?
    var disabledDays: [Int]? //[Days]?
    var disabledMonths: [Int]?
    var disabledDaysOfMonth: [Int]?
    var validationType: DateValidation?
    var minimumDate: String?
    var openCalendarDaysOffset: Int?
    var maximumDate: String?
    var minimumTime: String?
    var maximumTime: String?
    var isMinMonth: Bool?
    var isMaxMonth: Bool?
    var calendarType: FormCalendarType?
    var defaultAnswer: DefaultDateTimeAnswer?
    var allowedDaysRange: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        dateTimeType <- map["dateTimeType"]
        dateSelectionMode <- map["dateSelectionMode"]
        dateFormat <- map["dateFormat"]
        timeFormat <- map["timeFormat"]
        firstDayOfWeek <- map["firstDayOfWeek"]
        defaultDateType <- map["defaultDateType"]
        defaultTimeType <- map["defaultTimeType"]
        disabledDates <- map["disabledDates"]
        disabledDays <- map["disabledDays"]
        disabledMonths <- map["disabledMonths"]
        disabledDaysOfMonth <- map["disabledDaysOfMonth"]
        validationType <- map["validationType"]
        minimumDate <- map["minimumDate"]
        maximumDate <- map["maximumDate"]
        minimumTime <- map["minimumTime"]
        maximumTime <- map["maximumTime"]
        defaultAnswer <- map["defaultAnswer"]
        isMinMonth <- map["isMinMonth"]
        isMaxMonth <- map["isMaxMonth"]
        calendarType <- map["calendarType"]
        allowedDaysRange <- map["allowedDaysRange"]
        openCalendarDaysOffset <- map["openCalendarDaysOffset"]
    }
    
    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "dateTimeType":
            if let value = newValue as? DateTimeType {
                self.dateTimeType = value
            }
        case "dateSelectionMode":
            if let value = newValue as? DateSelectionMode {
                self.dateSelectionMode = value
            }
        case "dateFormat":
            if let value = newValue as? DateFormat {
                self.dateFormat = value
            }
        case "timeFormat":
            if let value = newValue as? TimeFormat {
                self.timeFormat = value
            }
        case "firstDayOfWeek":
            if let value = newValue as? Int {
                self.firstDayOfWeek = value
            }
        case "defaultDateType":
            if let value = newValue as? DefaultDateTime {
                self.defaultDateType = value
            }
        case "defaultTimeType":
            if let value = newValue as? DefaultDateTime {
                self.defaultTimeType = value
            }
        case "disabledDates":
            if let value = newValue as? [String] {
                self.disabledDates = value
            }
        case "disabledDays":
            if let value = newValue as? [Int] {
                self.disabledDays = value
            }
        case "disabledMonths":
            if let value = newValue as? [Int] {
                self.disabledMonths = value
            }
        case "disabledDaysOfMonth":
            if let value = newValue as? [Int] {
                self.disabledDaysOfMonth = value
            }
        case "validationType":
            if let value = newValue as? DateValidation {
                self.validationType = value
            }
        case "minimumDate":
            if let value = newValue as? String {
                // Split the string by space
                let components = value.split(separator: " ")
                
                // Set the date part
                if components.count >= 1 {
                    self.minimumDate = String(components[0]) // Extract the date part
                }
                
                // Set the time part only if it exists
                if components.count == 2 {
                    self.minimumTime = String(components[1]) // Extract the time part
                }
            }
        case "maximumDate":
            if let value = newValue as? String {
                // Split the string by space
                let components = value.split(separator: " ")
                
                // Set the date part
                if components.count >= 1 {
                    self.maximumDate = String(components[0]) // Extract the date part
                }
                
                // Set the time part only if it exists
                if components.count == 2 {
                    self.maximumTime = String(components[1]) // Extract the time part
                }
            }
        case "minimumTime":
            if let value = newValue as? String {
                self.minimumTime = value
            }
        case "maximumTime":
            if let value = newValue as? String {
                self.maximumTime = value
            }
        case "isMinMonth":
            if let value = newValue as? Bool {
                self.isMinMonth = value
            }
        case "isMaxMonth":
            if let value = newValue as? Bool {
                self.isMaxMonth = value
            }
        case "calendarType":
            if let value = newValue as? FormCalendarType {
                self.calendarType = value
            }
        case "defaultAnswer":
            if let value = newValue as? DefaultDateTimeAnswer {
                self.defaultAnswer = value
            }
        case "allowedDaysRange":
            if let value = newValue as? Int {
                self.allowedDaysRange = value
            }
        case "openCalendarDaysOffset":
            if let value = newValue as? Int {
                self.openCalendarDaysOffset = value
            }
//        case "required":
//            if let value = newValue as? String {
//                let boolValue = (value as NSString).boolValue
//                self.required = boolValue
//            }
        default:
            print("Unknown property name: \(propertyName)")
        }
    }
}

public class ParagraphProperties: BaseProperties {
    var paragraphText: String?
    var paragraphStyle: FormStyle?
    var paragraphSubType: ParagraphSubType?
    var defaultAnswer: ParagraphAnswer?
    var defaultAnswerWithBoolValue: ParagraphAnswerWithBoolValue?
    var defaultAnswerInEdit: DefaultBaseAnswerText?
    var icon: String?
//    var dataSourcId: String?
//    var required: Bool?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        paragraphText <- map["paragraphText"]
        paragraphSubType <- map["paragraphSubType"]
        paragraphStyle <- map["style"]
        icon <- map["icon"]
        defaultAnswer <- map["defaultAnswer"]
        defaultAnswerWithBoolValue <- map["defaultAnswer"]
        defaultAnswerInEdit <- map["defaultAnswer"]
        var lLocalization: ParagraphLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
//        required <- map["required"]
    }
    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "paragraphText":
            if let value = newValue as? String {
                self.paragraphText = value
            }
        case "paragraphStyle":
            if let value = newValue as? FormStyle {
                self.paragraphStyle = value
            }
        case "paragraphSubType":
            if let value = newValue as? ParagraphSubType {
                self.paragraphSubType = value
            }
        case "defaultAnswer":
            if let value = newValue as? ParagraphAnswer {
                self.defaultAnswer = value
            }
        case "defaultAnswerInEdit":
            if let value = newValue as? DefaultBaseAnswerText {
                self.defaultAnswerInEdit = value
            }
        case "icon":
            if let value = newValue as? String {
                self.icon = value
            }
//        case "dataSourcId":
//            if let value = newValue as? String {
//                self.dataSourcId = value
//            }
//        case "required":
//            if let value = newValue as? Bool {
//                self.required = value
//            }
        default:
            super.updateProperty(propertyName: propertyName, newValue: newValue)
        }
    }
}

public class MapProperties: BaseProperties {
    var showPostalCode: Bool?
    var place: Place?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        showPostalCode <- map["showPostalCode"]
        place <- map["place"]
    }
}

public class SliderProperties: InteractiveProperties {
    var defaultAnswer: SliderAnswer?
    var start: Int?
    var end: Int?
    var selectionMode: SliderSelectionMode?
    var step: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        defaultAnswer <- map["defaultAnswer"]
        start <- map["start"]
        end <- map["end"]
        selectionMode <- map["selectionMode"]
        step <- map["step"]
    }
}

public class NpsProperties: InteractiveProperties {
    var defaultAnswer: BaseAnswerText?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        defaultAnswer <- map["defaultAnswer"]
    }
}

public class RateProperties: InteractiveProperties {
    var rateType: RateType?
    var scale: Int?
    var rateColor: String?
    var defaultAnswer: BaseAnswerText?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        rateType <- map["rateType"]
        scale <- map["scale"]
        rateColor <- map["rateColor"]
        defaultAnswer <- map["defaultAnswer"]
    }
}

public class FaceRateProperties: InteractiveProperties {
    var defaultAnswer: BaseAnswerText?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        defaultAnswer <- map["defaultAnswer"]
    }
}

public class MCQBaseProperties: InteractiveProperties {
    var options: [MCQOption]?
    var isCascade: Bool?
//    var dataSourcId: String?
    var defaultAnswer: BaseAnswerMCQ?
    var newDefaultAnswer: BaseAnswerMCQGUID?
    var predefinedOptions: String?
    var shuffleOptions: Bool?
    var otherOption: Bool?
    var otherOptionText: String?
    var naOption: Bool?
    var naOptionText: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        options <- map["options"]
//        dataSourcId <- map["dataSourcId"]
        isCascade <- map["isCascade"]
        defaultAnswer <- map["defaultAnswer"]
        newDefaultAnswer <- map["defaultAnswer"]
        predefinedOptions <- map["predefinedOptions"]
        shuffleOptions <- map["shuffleOptions"]
        otherOption <- map["otherOption"]
        otherOptionText <- map["otherOptionText"]
        naOption <- map["naOption"]
        naOptionText <- map["naOptionText"]
        var lLocalization: MCQLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "options":
            if let value = newValue as? [MCQOption] {
                self.options = value
            }
        case "isCascade":
            if let value = newValue as? Bool {
                self.isCascade = value
            }
//        case "dataSourcId":
//            if let value = newValue as? String {
//                self.dataSourcId = value
//            }
        case "defaultAnswer":
            if let value = newValue as? BaseAnswerMCQ {
                self.defaultAnswer = value
            }
        case "defaultAnswer":
            if let value = newValue as? BaseAnswerMCQGUID {
                self.newDefaultAnswer = value
            }
        case "predefinedOptions":
            if let value = newValue as? String {
                self.predefinedOptions = value
            }
        case "shuffleOptions":
            if let value = newValue as? Bool {
                self.shuffleOptions = value
            }
        case "otherOption":
            if let value = newValue as? Bool {
                self.otherOption = value
            }
        case "otherOptionText":
            if let value = newValue as? String {
                self.otherOptionText = value
            }
        case "naOption":
            if let value = newValue as? Bool {
                self.naOption = value
            }
        case "naOptionText":
            if let value = newValue as? String {
                self.naOptionText = value
            }
        default:
            super.updateProperty(propertyName: propertyName, newValue: newValue)
        }
    }
}

public class CheckboxProperties: MCQBaseProperties {
    var minNumberOfSelectedOptions: Int?
    var maxNumberOfSelectedOptions: Int?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        minNumberOfSelectedOptions <- map["minNumberOfSelectedOptions"]
        maxNumberOfSelectedOptions <- map["maxNumberOfSelectedOptions"]
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "minNumberOfSelectedOptions":
            if let value = newValue as? Int {
                self.minNumberOfSelectedOptions = value
            }
        case "maxNumberOfSelectedOptions":
            if let value = newValue as? Int {
                self.maxNumberOfSelectedOptions = value
            }
        default:
            super.updateProperty(propertyName: propertyName, newValue: newValue)
        }
    }
}

public class RadioProperties: MCQBaseProperties {
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

public class DropdownProperties: MCQBaseProperties {
    var multiSelect: Bool?
    var selectAllBox: Bool?
    var minNumberOfSelectedOptions: Int?
    var maxNumberOfSelectedOptions: Int?
    var ddlType: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        multiSelect <- map["multiSelect"]
        selectAllBox <- map["selectAllBox"]
        minNumberOfSelectedOptions <- map["minNumberOfSelectedOptions"]
        maxNumberOfSelectedOptions <- map["maxNumberOfSelectedOptions"]
        ddlType <- map["subType"]
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "multiSelect":
            if let value = newValue as? Bool {
                self.multiSelect = value
            }
        case "selectAllBox":
            if let value = newValue as? Bool {
                self.selectAllBox = value
            }
        case "minNumberOfSelectedOptions":
            if let value = newValue as? Int {
                self.minNumberOfSelectedOptions = value
            }
        case "maxNumberOfSelectedOptions":
            if let value = newValue as? Int {
                self.maxNumberOfSelectedOptions = value
            }
        case "ddlType":
            if let value = newValue as? String {
                self.ddlType = value
            }
        default:
            super.updateProperty(propertyName: propertyName, newValue: newValue)
        }
    }
}

public class TableProperties: InteractiveProperties {
    var minRows: Int?
    var maxRows: Int?
    var showTotals: Bool?
    var totalFields: Int?
    var allowDeleteRows: Bool?
    var allowEditRows: Bool?
    var allowAddRows: Bool?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        minRows <- map["minRows"]
        maxRows <- map["maxRows"]
        showTotals <- map["showTotals"]
        totalFields <- map["totalFields"]
        allowDeleteRows <- map["allowDeleteRows"]
        allowEditRows <- map["allowEditRows"]
        allowAddRows <- map["allowAddRows"]
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "minRows":
            if let value = newValue as? Int {
                self.minRows = value
            }else if let value = newValue as? String {
                self.minRows = Int(value)
            }
        case "maxRows":
            if let value = newValue as? Int {
                self.maxRows = value
            }else if let value = newValue as? String {
                self.maxRows = Int(value)
            }
        case "showTotals":
            if let value = newValue as? Bool {
                self.showTotals = value
            }
        case "totalFields":
            if let value = newValue as? Int {
                self.totalFields = value
            }
        case "allowDeleteRows":
            if let value = newValue as? Bool {
                self.allowDeleteRows = value
            }
        case "allowEditRows":
            if let value = newValue as? Bool {
                self.allowEditRows = value
            }
        case "allowAddRows":
            if let value = newValue as? Bool {
                self.allowAddRows = value
            }
        default:
            super.updateProperty(propertyName: propertyName, newValue: newValue)
        }
    }
}

public class FileUploadProperties: InteractiveProperties {
    var defaultAnswer: DefaultFileUploadAnswer?
    var maxAttachmentsSize: Int?
    var maxAttachmentsNumber: Int?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        defaultAnswer <- map["defaultAnswer"]
        maxAttachmentsSize <- map["maxAttachmentsSize"]
        maxAttachmentsNumber <- map["maxAttachmentsNumber"]
        var lLocalization: InteractiveLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
    }

    public override func updateProperty(propertyName: String, newValue: Any) {
        switch propertyName {
        case "defaultAnswer":
            if let value = newValue as? DefaultFileUploadAnswer {
                self.defaultAnswer = value
            }
        case "maxAttachmentsSize":
            if let value = newValue as? Int {
                self.maxAttachmentsSize = value
            }
        case "maxAttachmentsNumber":
            if let value = newValue as? Int {
                self.maxAttachmentsNumber = value
            }
        default:
            super.updateProperty(propertyName: propertyName, newValue: newValue)
        }
    }
}


public class switchProperties: InteractiveProperties {
    var defaultAnswer: SwitchAnswer?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        defaultAnswer <- map["defaultAnswer"]
        var lLocalization: InteractiveLocalization?
        lLocalization <- map["localization"]
        localization = lLocalization
    }
}

public class Prefix: Mappable {
    public var display: String?
    public var value: String?
    
    required public init?(map: Map) {
        //empty
    }
    
    public func mapping(map: Map) {
        display <- map["display"]
        value <- map["value"]
    }
}

public class Suffix: Prefix {
    required init?(map: Map) {
        super.init(map: map)
    }
}

public enum EntryLimit: String {
    case Character = "Character"
    case Word = "Word"
    case Digit = "Digit"
}

public enum TextCase: String {
    case LowerCase = "Lowercase"
    case UpperCase = "Uppercase"
    case Mixed = "Mixed"
}

public enum EditorType: String {
    case PlainText = "PlainText"
    case RichText = "RichText"
}

public enum DateFormat: String {
    case DMY = "DMY"
    case MDY = "MDY"
    case YMD = "YMD"
    
    public var swiftFormat: String {
        switch self {
        case .DMY:
            return "dd-MM-yyyy'T'HH:mm:ss"
        case .MDY:
            return "MM-dd-yyyy'T'HH:mm:ss"
        case .YMD:
            return "yyyy-MM-dd'T'HH:mm:ss"
        }
    }
    
    public var presentedSwiftFormat: String {
        switch self {
        case .DMY:
            return "dd-MM-yyyy"
        case .MDY:
            return "MM-dd-yyyy"
        case .YMD:
            return "yyyy-MM-dd"
        }
    }
}

public enum DateSelectionMode: String {
    case Single = "SingleDate"
    case Multiple = "MultipleDates"
    case Range = "DateRange"
}

public enum DateTimeType: String {
    case Date = "Date"
    case Time = "Time"
    case Both = "Both"
}

public enum DateValidation: String {
    case Future = "Future"
    case Past = "Past"
    case Custom = "Custom"
}

public enum DefaultDateTime: String {
    case None = "None"
    case Current = "Current"
    case Custom = "Custom"
}

public enum TimeFormat: String {
    case FullDay = "FullDay"
    case HalfDay = "HalfDay"
    
    public var swiftFormat: String {
        switch self {
        case .FullDay:
            return "yyyy-MM-dd'T'HH:mm:ss"//"HH:mm"
        case .HalfDay:
            return "yyyy-MM-dd'T'hh:mm:ss a"//"hh:mm a"
        }
    }
    
    public var presentedSwiftFormat: String {
        switch self {
        case .FullDay:
            return "HH:mm"
        case .HalfDay:
            return "hh:mm a"
        }
    }
}

public enum FormCalendarType: String {
    case Gregorian
    case Hijri
    case Gregorian_Hijri = "Gregorian/Hijri"
}

protocol DayStr {
    var description: String { get }
}

public enum Days: Int, DayStr {
    case Sun = 0, Mon, Tue, Wed, Thu, Fri, Sat
    
    var description: String {
        switch self {
        case .Sun:
            return "Sun"
        case .Mon:
            return "Mon"
        case .Tue:
            return "Tue"
        case .Wed:
            return "Wed"
        case .Thu:
            return "Thu"
        case .Fri:
            return "Fri"
        case .Sat:
            return "Sat"
        }
    }
}

public enum SliderSelectionMode: String {
    case Single = "SingleSelection"
    case Range = "RangeSelection"
}

public enum RateType: String {
    case Star = "Star"
    case Heart = "Heart"
    case Thumb = "Thumb"
}

public struct FormStyle : Mappable {
    var border : String?
    var borderType : String?
    var borderColor : String?
    var backgroundColor : String?
    var textColor : String?
    var textAlign : String?
    var font : String?
    var fontSize : String?

    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        border <- map["border"]
        borderType <- map["borderType"]
        borderColor <- map["borderColor"]
        backgroundColor <- map["backgroundColor"]
        textColor <- map["textColor"]
        textAlign <- map["textAlign"]
        font <- map["font"]
        fontSize <- map["fontSize"]
    }
    
    public init(border: String?, borderType: String?, borderColor: String?, backgroundColor: String?, textColor: String?, textAlign: String?, font: String?, fontSize: String?) {
        self.border = border
        self.borderType = borderType
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textAlign = textAlign
        self.font = font
        self.fontSize = fontSize

    }
}


public struct Place: Mappable {
    public var zoom: Int?
    public var lat: Double?
    public var lng: Double?
    public var address: String?
    public var postalCode: String?
    public var latDelta: Double?
    public var lngDelta: Double?
    
    public init?(map: Map) {
        //empty
    }
    
    mutating public func mapping(map: Map) {
        zoom <- map["zoom"]
        lat <- map["lat"]
        lng <- map["lng"]
        address <- map["address"]
        postalCode <- map["postalCode"]
        latDelta <- map["latDelta"]
        lngDelta <- map["lngDelta"]
    }
    
    public init(lat: Double?, lng: Double?, address: String?, postalCode: String?, latDelta: Double?, lngDelta: Double?) {
        self.zoom = nil
        self.lat = lat
        self.lng = lng
        self.address = address
        self.postalCode = postalCode
        self.latDelta = latDelta
        self.lngDelta = lngDelta
    }
}

public struct MCQOption: Codable, Mappable, Hashable {
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
    
    mutating public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
    }
}

public class MCQDataSource: Mappable {
    public var url: String?
    public var parameters: [String]?
    
    required public init?(map: Map) {
        //empty
    }
    
    public func mapping(map: Map) {
        url <- map["url"]
        parameters <- map["parameters"]
    }
}

public class BasePropertiesLocalization: Mappable {
    public var label: String?
    public var sublabel: String?
    public var tooltip: String?
    var fieldWarning: InternalFieldValidation?
    var ruleWarning: InternalRuleValidation?
    
    required public init?(map: Map) {
        // empty
    }
    
    public func mapping(map: Map) {
        label <- map["label"]
        sublabel <- map["sublabel"]
        tooltip <- map["tooltip"]
        fieldWarning <- map["fieldWarning"]
        ruleWarning <- map["ruleWarning"]
    }
}

public class NavigationPropertiesLocalization: BasePropertiesLocalization {
    public var back: String?
    public var next: String?
    public var submit: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        back <- map["back"]
        next <- map["next"]
        submit <- map["submit"]
    }
}

public class InteractivePropertiesLocalization: BasePropertiesLocalization {
    public var placeholder: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        placeholder <- map["placeholder"]
    }
}

public class TextboxPropertiesLocalization: InteractivePropertiesLocalization {
    public var prefix: Prefix?
    public var suffix: Suffix?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        prefix <- map["prefix"]
        suffix <- map["suffix"]
    }
}

public class ParagraphPropertiesLocalization: BasePropertiesLocalization {
    public var paragraphText: String?
    public var paragraphSubType:ParagraphSubType?
    public var paragraphStyle:FormStyle?
    public var icon:String?
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        paragraphSubType <- map["paragraphSubType"]
        paragraphText <- map["paragraphText"]
        paragraphStyle <- map["style"]
        icon <- map["icon"]
    }
}

public class MCQBasePropertiesLocalization: InteractivePropertiesLocalization {
    public var options: [MCQOption]?
    public var otherOptionText: String?
    public var naOptionText: String?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        options <- map["options"]
        otherOptionText <- map["otherOptionText"]
        naOptionText <- map["naOptionText"]
    }
}

public struct DataSource: Mappable {
    public var excludedViews: [ExcludedViews]?
    public var parameters: [String]?
    
    public init?(map: Map) {
        //empty
    }
    
    public init(excludedViews: [ExcludedViews]?,parameters: [String]?) {
        self.excludedViews = excludedViews
        self.parameters = parameters
    }
    
    mutating public func mapping(map: Map) {
        excludedViews <- map["excludedViews"]
        parameters <- map["parameters"]
    }
}

public enum ExcludedViews: String, Codable {
    case Create,TaskDetails,RequestDetails,Edit
}

public enum TextBoxSubType: String {
    case AnySubType = "Any"
    case Email = "Email"
    case URL = "URL"
    case Numeric = "Numeric"
    case Alphabetic = "Alphabetic"
    case Alphanumeric = "Alphanumeric"
    case Custom = "Custom"
    case password = "password"
}

public enum ParagraphSubType: String {
    case Text = "Text"
    case Link = "Link"
    case InfoIndcator = "InfoIndcator"
    case LabelSheet = "LabelSheet"
    case LabelSheetWithToggle = "LabelSheetWithToggle"
    case LabelSheetWithCheckBox = "LabelSheetWithCheckBox"
}

public enum AttachmentFormType: String {
    case Image = "Image"
    case File = "File"
    case Both = "Both"
}
