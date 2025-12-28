//
//  FormViewModel.swift
//  CHECK
//
//  Created by Yasser Osama on 24/10/2021.
//

import Foundation
public import RxCocoa
internal import RxSwift
import Lottie

class FormViewModel: BaseViewModel {
    
    private let service: cerqel_NetworkServiceDynamicForm
    private let disposeBag = DisposeBag()
    var serviceSubmittedResponse: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    public var items = [FormViewModelItem]() {
        didSet {
            items = FormBuilder.shared.sort(items: items)
        }
    }
    var rules: [Rule]?
    var warnings: Warning?
    
    
    /// Dependency Injection
    /// - Parameter form: DynamicForm
    init(form: FormModel?) {
        service = cerqel_BasicNetworkServiceDynamicFormImpl.shared
        for field in form?.fields ?? [] {
            switch field.type {
            case .Page:
                let item = FormViewModelPageItem(field: field)
                items.append(item)
            case .Section:
                let item = FormViewModelSectionItem(field: field)
                items.append(item)
            case .TextBox:
                let item = FormViewModelTextBoxItem(field: field)
                items.append(item)
            case .TextArea:
                let item = FormViewModelTextAreaItem(field: field)
                items.append(item)
            case .Numerical:
                let item = FormViewModelNumericItem(field: field)
                items.append(item)
            case .Paragraph:
                let item = FormViewModelParagraphItem(field: field)
                items.append(item)
            case .Date:
                let item = FormViewModelDateItem(field: field)
                items.append(item)
            case .Map:
                let item = FormViewModelMapItem(field: field)
                items.append(item)
            case .Location:
                let item = FormViewModelLocationItem(field: field)
                items.append(item)
            case .Slider:
                let item = FormViewModelSliderItem(field: field)
                items.append(item)
            case .NPS:
                let item = FormViewModelNPSItem(field: field)
                items.append(item)
            case .Rate:
                let item = FormViewModelRateItem(field: field)
                items.append(item)
            case .FaceRate:
                let item = FormViewModelFaceRateItem(field: field)
                items.append(item)
            case .Checkbox:
                let item = FormViewModelCheckboxItem(field: field)
                items.append(item)
            case .Radio:
                let item = FormViewModelRadioItem(field: field)
                items.append(item)
            case .Dropdown:
                let item = FormViewModelDropdownItem(field: field)
                items.append(item)
            case .Table:
                let item = FormViewModelTableItem(field: field)
                items.append(item)
            case .FileUpload:
                let item = FormViewModelFileUploadItem(field: field)
                items.append(item)
            case .switchControl:
                let item = FormViewModelSwitchItem(field: field)
                items.append(item)
            default:
                break
            }
        }
        self.rules = form?.rules
        self.warnings = form?.warnings
    }
    
    func serializeDataStructureToJSON(data: [AnyHashable: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error serializing data structure to JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /// Submit Service
    /// - Parameters:
    ///   - payload: service's payload
    ///   - id: service id
    ///   - completion: returns response
    func submit(payload: [String : Any], id: String,completion: @escaping((Bool?,String?,String?,Bool)->())) {
        var payloadJSON = [String : Any]()
        if let items = payload["payload"] as? [[String: Any]] {
            let filteredItems = items.filter { item in
                if let itemType = item["type"] as? String, itemType == "Table" {
                    return false // Exclude items of type "Table"
                }
                return true
            }
            payloadJSON["payload"] = filteredItems
            payloadJSON["formVersion"] = payload["formVersion"]
            payloadJSON["createdForUsername"] = payload["createdForUsername"]
        }
        
          service.load(cerqel_CodableResponseObjectDynamicForm<ServiceSuccessDataClass>(action: Dynamic_BasicActionDynamicForm.submitService(Id: id, payload: payloadJSON))).subscribe(onNext: {
              (response) in
              if let item = response.item?.data{
                  completion(true,item.requestOrder,item.id, item.isEligableForSurvey ?? false)
              }else {
                  completion(false,response.error?.localizedDescription,nil, false)
              }
          }, onError: { (error) in
              self.errorsSubject.onNext(BaseError.other(title: error.localizedDescription))
              completion(nil,nil,nil, false)
          }).disposed(by: self.disposeBag)
      }
    
    /// Submit Service
    /// - Parameters:
    ///   - payload: service's payload
    ///   - id: service id
    ///   - completion: returns response
    func submitEditRequest(payload: [String : Any], id: String,completion: @escaping((Bool?,String?,String?,Bool)->())) {
          service.load(cerqel_CodableResponseObjectDynamicForm<ServiceSuccessDataClass>(action: Dynamic_BasicActionDynamicForm.submitEditRequestService(Id: id, payload: payload))).subscribe(onNext: {
              (response) in
              if (response.success ?? false) {
                  completion(true,"","", false)
              }else {
                  completion(false,response.error?.localizedDescription,nil, false)
              }
          }, onError: { (error) in
              self.errorsSubject.onNext(BaseError.other(title: error.localizedDescription))
              completion(nil,nil,nil, false)
          }).disposed(by: self.disposeBag)
      }

}

public struct FormViewModelItemStruct {
    var rowIndex: String?
    var field: Field?
    var type: FieldType!
    var paragraphSubType: ParagraphSubType?
    var paragraphStyle: FormStyle?
    var icon: String?
    var fieldId: String!
    var label: String!
    var parentId: String?
    var index: Int!
    var answer: Any?
    var isError: Bool!
    var rules: FieldRule?
    var hidden: Bool! = false
    var disabled: Bool = false
    var isRequired: Bool = false
    var isUpdated: Bool! = false
    var localization: BaseLocalization?
    var isCollapsedSection: Bool? = false
    var attachmentsList: [UploadMediaUIModel] = []
    var isSectionControl: Bool! = false
    var isValid: Bool = false
    
    init(from item: FormViewModelItem?) {
        if let item = item {
            self.rowIndex = item.rowIndex
            self.field = item.field
            self.type = item.type
            self.paragraphSubType = item.paragraphSubType
            self.paragraphStyle = item.paragraphStyle
            self.icon = item.icon
            self.fieldId = item.fieldId
            self.label = item.label
            self.parentId = item.parentId
            self.index = item.index
            self.answer = item.answer
            self.isError = item.isError
            self.rules = item.rules
            self.hidden = item.hidden
            self.disabled = item.disabled
            self.isRequired = item.isRequired
            self.isSectionControl = item.isSectionControl
            self.isUpdated = item.isUpdated
            self.localization = item.localization
            self.isValid = item.isValid
            self.isCollapsedSection = item.isCollapsedSection ?? false
            if item.type == .FileUpload {
                self.attachmentsList = (item as? FormViewModelFileUploadItem)?.attachmentsList ?? []
            }
        }
    }
}


public class FormViewModelItem:  ObservableObject, Identifiable {
    public var id: String {fieldId}
    public var rowIndex: String?
    public var isSectionItem: Bool? = false
    public var field: Field?
    public var type: FieldType? = .TextBox
    public var paragraphSubType:ParagraphSubType?
    public var paragraphStyle:FormStyle?
    public var icon:String?
    public var fieldId: String!
    public var label: String!
    public var parentId: String?
    public var index: Int!
    public var answer: Any?
    public var defualtSummaryAnswer: Any?
    public var defualtTabldItemsSummaryAnswer: Any?
    public var isError: Bool!
    public var rules: FieldRule?
    public var hidden: Bool! = false
    public var disabled: Bool = false
    public var isRequired: Bool = true
    public var isUpdated: Bool! = false
    public var localization: BaseLocalization?
    public var isCollapsedSection: Bool? = false
    public var isValid: Bool = false
    public var order: String?
    public var inLineError: Bool = false
    public var errorMessageInline: String = ""
    @Published  var isActive: Bool = false
    public var isSectionControl: Bool! = false

    init(field: Field?) {
        if let field = field {
            self.field = field
            type = field.type
            fieldId = field.id
            parentId = field.parentId
            rowIndex = field.rowIndex
            label = field.properties?.label
            answer = field.answer
            defualtSummaryAnswer = field.defualtSummaryAnswer
            defualtTabldItemsSummaryAnswer = field.defualtTabldItemsSummaryAnswer
            order = field.order
            isError = false
            rules = field.fieldRules
            hidden = false
            isSectionControl = false
            localization = field.properties?.localization
            paragraphSubType = field.paragraphSubType
            paragraphStyle = field.paragraphStyle
            icon = field.icon
            disabled = false
            isRequired = false
            isActive = false
            isCollapsedSection = field.properties?.isCollapsedSec

        }
    }
    
    init(from item: FormViewModelItemStruct) {
        self.rowIndex = item.rowIndex
        self.field = item.field
        self.type = item.type
        self.paragraphSubType = item.paragraphSubType
        self.paragraphStyle = item.paragraphStyle
        self.icon = item.icon
        self.fieldId = item.fieldId
        self.label = item.label
        self.parentId = item.parentId
        self.index = item.index
        self.answer = item.answer
        self.isError = item.isError
        self.rules = item.rules
        self.hidden = item.hidden
        self.isSectionControl = item.isSectionControl
        self.disabled = item.disabled
        self.isRequired = item.isRequired
        self.isUpdated = item.isUpdated
        self.localization = item.localization
        self.isValid = item.isValid
        self.isCollapsedSection = item.isCollapsedSection
    }
    
    public func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        return nil
    }
    
    public func getAnswerString() -> String {
        return ""
    }
}

public class FormViewModelInteractiveItem: FormViewModelItem {
    public var required = false
    public var placeHolder: String! = ""
    public var note: String?
    public var attachmentImages: [Any]?
    public var attachmentFiles: [Any]?
    public var sublabel: String?
    public var tooltip: String?
    public var addNote: Bool! = false
    public var addAttachment: Bool! = false
    public var attachmentType: AttachmentFormType! = .Image
    public var attachmentExtensions: String! = ""
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? InteractiveProperties {
            required = properties.required ?? false
            placeHolder = properties.placeholder
            sublabel = properties.subLabel
            tooltip = properties.tooltip
            if let localization = properties.localization as? InteractiveLocalization {
                self.localization = localization
            }
            addNote = properties.addNote ?? false
            addAttachment = properties.addAttachment ?? false
            attachmentType = properties.attachmentType ?? .Both
            attachmentExtensions = properties.attachmentExtensions ?? ""
        }
        attachmentImages = []
        attachmentFiles = []
        note = ""
    }
    
    public func isAnswered() -> Bool {
        return false
    }
}

public class FormViewModelPageItem: FormViewModelItem {
    var backText: String?
    var nextText: String?
    var submitText: String?
    var backVisibility: Bool?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? NavigationProperties {
            backText = properties.back
            nextText = properties.next
            submitText = properties.submit
            backVisibility = properties.backVisibility
            if let localization = properties.localization as? NavigationLocalization {
                self.localization = localization
                backText = isArabic() ? localization["ar"]?.back : localization["en"]?.back
                nextText = isArabic() ? localization["ar"]?.next : localization["en"]?.next
                submitText = isArabic() ? localization["ar"]?.submit : localization["en"]?.submit
            }
        }
    }
}

public class FormViewModelSectionItem: FormViewModelItem {
    override init(field: Field?) {
        super.init(field: field)
    }
}

public class FormViewModelTextBaseItem: FormViewModelInteractiveItem {
    public var allowSpellCheck: Bool?
    public var maximumLength: Int?
    public var minimumLength: Int?
    public var entryLimit: EntryLimit?

    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? TextBaseProperties {
            allowSpellCheck = properties.allowSpellcheck
            maximumLength = properties.maximumLength
            minimumLength = properties.minimumLength
            entryLimit = properties.entryLimit
        }
    }
    
    public override func isAnswered() -> Bool {
        if let textValue = (answer as? BaseAnswerText)?.value, !textValue.isEmpty {
            return true
        }
        return false
    }
}

public class FormViewModelNumberBaseItem: FormViewModelInteractiveItem {
    
    public var allowSpellCheck: Bool?
    public var maximumLength: Int?
    public var minimumLength: Int?
    public var entryLimit: EntryLimit?

    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? TextBaseProperties {
            allowSpellCheck = properties.allowSpellcheck
            maximumLength = properties.maximumLength
            minimumLength = properties.minimumLength
            entryLimit = properties.entryLimit
        }
    }
    
    public override func isAnswered() -> Bool {
        if let _ = (answer as? BaseAnswerText)?.value {
            return true
        }
        return false
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return BaseAnswerText(JSON: valueObject)
        }
        return nil
    }
}

public class FormViewModelTextBoxItem: FormViewModelTextBaseItem, NSCopying {
    public var regex: String?
    public var prefix: PrefixViewModel?
    public var suffix: PrefixViewModel?
    public var mask: String?
    public var defaultAnswer: DefaultTextboxAnswer?
    public var newDefaultAnswer: DefaultTextboxAnswerNewFormat?
    public var subType: TextBoxSubType?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? TextBoxProperties {
            prefix = PrefixViewModel(prefix: properties.prefix)
            suffix = PrefixViewModel(prefix: properties.suffix)
            regex = properties.regex
            mask = properties.mask
            defaultAnswer = properties.defaultAnswer
            newDefaultAnswer = properties.newDefaultAnswer
            if let localization = properties.localization as? TextBoxLocalization {
                self.localization = localization
            }
            sublabel = properties.subLabel
            subType = properties.subType
            
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelTextBoxItem(field: self.field)
        copy.answer = nil
        copy.defaultAnswer = nil
        copy.newDefaultAnswer = nil
        return copy
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return TextboxAnswer(JSON: valueObject)
        }
        return nil
    }
    
    public override func getAnswerString() -> String {
        guard let answerValue = (answer as? TextboxAnswer)?.value else {
            return ""
        }
        return answerValue
    }
}

public class FormViewModelTextAreaItem: FormViewModelTextBaseItem, NSCopying {
    public var fullScreen: Bool?
    public var autoExpand: Bool?
    public var editorType: EditorType!
    public var defaultAnswer: DefaultTextAreaAnswer?
    public var newDefaultAnswer: DefaultTextAreaAnswerNewFormat?
    public var contentType: String?
    public var subType: TextBoxSubType?

    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? TextAreaProperties {
            fullScreen = properties.fullScreen
            autoExpand = properties.autoExpand
            editorType = properties.editor
            defaultAnswer = properties.defaultAnswer
            newDefaultAnswer =  properties.newDefaultAnswer
            contentType = properties.contentType
            subType = properties.subType
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelTextAreaItem(field: self.field)
        copy.answer = nil
        copy.newDefaultAnswer = nil
        copy.defaultAnswer = nil
        return copy
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return TextAreaAnswer(JSON: valueObject)
        }
        return nil
    }
    
    public override func getAnswerString() -> String {
        guard let answerValue = (answer as? TextAreaAnswer)?.value else {
            return ""
        }
        return answerValue
    }
}

public class FormViewModelNumericItem: FormViewModelNumberBaseItem, NSCopying {
    public var minValue: Double?
    public var maxValue: Double?
    public var decimal: Int!
    public var minDigit: Int?
    public var maxDigit: Int?
    public var defaultAnswer: DefaultNumberBoxAnswer?
    public var newDefaultAnswerWhenTextBox: DefaultTextboxAnswerNewFormat?
    public var newDefaultAnswer: DefaultNumberBoxAnswerNewFormat?
    public var regex: String?
    public var subType: TextBoxSubType?

    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? NumberProperties {
            if let lMin = properties.MinimumValue {
                minValue = lMin
            }
            if let lMax = properties.MaximumValue {
                maxValue = lMax
            }
            decimal = properties.DecimalPlaces ?? 0
            if let lMinD = properties.MinimumDigits {
                minDigit = lMinD
            }
            if let lMaxD = properties.MaximumDigits {
                maxDigit = lMaxD
            }
            defaultAnswer = properties.DefaultAnswer
            newDefaultAnswer =  properties.newDefaultAnswer
            newDefaultAnswerWhenTextBox = properties.newDefaultAnswerWhenTextBox
            regex = properties.Regex
            subType = properties.subType
        }
    }
    
    func syncPropertiesFromNumberProperties() {
          guard let properties = field?.properties as? NumberProperties else {
              return
          }
          
          minValue = properties.MinimumValue
          maxValue = properties.MaximumValue
          decimal = properties.DecimalPlaces ?? 0
          minDigit = properties.MinimumDigits
          maxDigit = properties.MaximumDigits
          defaultAnswer = properties.DefaultAnswer
          regex = properties.Regex
          subType = properties.subType
      }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelNumericItem(field: self.field)
        copy.answer = nil
        copy.newDefaultAnswer = nil
        copy.defaultAnswer = nil
        return copy
    }
    
    public override func getAnswerString() -> String {
        guard let answerValue = (answer as? BaseAnswerText)?.value else {
            return ""
        }
        return "\(answerValue)"
    }
}

public class FormViewModelFileUploadItem: FormViewModelInteractiveItem, NSCopying {
    public var defaultAnswer: DefaultFileUploadAnswer?
    public var maxAttachmentsSize: Int?
    public var maxAttachmentsNumber:Int?
    var attachmentsList: [UploadMediaUIModel] = []
    var defaultattachmentsList: [AttachmentForDefault] = []

    
    override init(field: Field?) {
        super.init(field: field)
        attachmentsList = []
        if let properties = field?.properties as? FileUploadProperties {
            defaultAnswer = properties.defaultAnswer
            maxAttachmentsSize = properties.maxAttachmentsSize
            maxAttachmentsNumber = properties.maxAttachmentsNumber
            defaultattachmentsList = (properties.defaultAnswer?.value as? [AttachmentForDefault]) ?? []
        }
    }
    
    init(from item: FormViewModelItemStruct) {
            super.init(field: item.field)
            self.rowIndex = item.rowIndex
            self.field = item.field
            self.type = item.type
            self.paragraphSubType = item.paragraphSubType
            self.paragraphStyle = item.paragraphStyle
            self.icon = item.icon
            self.fieldId = item.fieldId
            self.label = item.label
            self.parentId = item.parentId
            self.index = item.index
            self.answer = item.answer
            self.isError = item.isError
            self.rules = item.rules
            self.hidden = item.hidden
            self.disabled = item.disabled
            self.isRequired = item.isRequired
            self.isUpdated = item.isUpdated
            self.localization = item.localization
            self.isValid = item.isValid
            self.isCollapsedSection = item.isCollapsedSection
            self.attachmentsList = item.attachmentsList
        }
    
    func syncPropertiesFromFileUploadProperties() {
        guard let properties = field?.properties as? FileUploadProperties else {
            return
        }
        defaultAnswer = properties.defaultAnswer
        maxAttachmentsSize = properties.maxAttachmentsSize
        maxAttachmentsNumber = properties.maxAttachmentsNumber
        defaultattachmentsList = (properties.defaultAnswer?.value as? [AttachmentForDefault]) ?? []
    }

    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelFileUploadItem(field: self.field)
        copy.attachmentsList = []
        return copy
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return BaseAnswerMCQ(JSON: valueObject)
        }
        return nil
    }
    
    public override func isAnswered() -> Bool {
        if let answerValue = (answer as? BaseAnswerMCQ)?.value?.first, !(answerValue.name?.isEmpty ?? true) {
            return true
        }
        return false
    }
    }


public class FormViewModelSwitchItem: FormViewModelInteractiveItem, NSCopying {
    public var defaultAnswer: SwitchAnswer?
    
    override init(field: Field?) {
        super.init(field: field)
        if let properties = field?.properties as? switchProperties {
            defaultAnswer = properties.defaultAnswer
            if let localization = properties.localization as? MCQLocalization {
                self.localization = localization
            }
        }
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return SwitchAnswer(JSON: valueObject)
        }
        return nil
    }
    
    public override func isAnswered() -> Bool {
        if ((answer as? SwitchAnswer)?.value) != nil {
            return true
        }
        return false
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelSwitchItem(field: field)
        copy.answer = nil
        copy.defaultAnswer = nil
        return copy
    }
    
}

public class FormViewModelParagraphItem: FormViewModelInteractiveItem, NSCopying {
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? ParagraphProperties, let localization = properties.localization as? ParagraphLocalization {
            self.localization = localization
            self.paragraphSubType = properties.paragraphSubType
            self.paragraphStyle = properties.paragraphStyle
            self.icon = properties.icon
            self.answer = properties.defaultAnswer
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelParagraphItem(field: self.field)
        copy.answer = nil
        (copy.field?.properties as? ParagraphProperties)?.defaultAnswer = nil
        return copy
    }
}

public class FormViewModelDateItem: FormViewModelInteractiveItem, NSCopying {
    public var dateTimeType: DateTimeType?
    public var disabledDates: [String]?
    public var disabledDays: [String]?
    public var disabledMonths: [Int]?
    public var selectionMode: DateSelectionMode?
    public var dateFormat: DateFormat?
    public var firstDayOfWeek: Int?
    public var dateSelectionMode: DateSelectionMode?
    public var timeFormat: TimeFormat?
    public var defaultAnswer: DefaultDateTimeAnswer?
    public var defaultDateType: DefaultDateTime?
    public var defaultTimeType: DefaultDateTime?
    public var dateProperties: DateTimeProperties?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? DateTimeProperties {
            dateTimeType = properties.dateTimeType
            disabledDates = properties.disabledDates
            disabledDays = properties.disabledDays?.map({$0.description})
            disabledMonths = properties.disabledMonths
            selectionMode = properties.dateSelectionMode
            dateFormat = properties.dateFormat
            firstDayOfWeek = properties.firstDayOfWeek
            dateSelectionMode = properties.dateSelectionMode
            timeFormat = properties.timeFormat
            defaultAnswer = properties.defaultAnswer
            defaultDateType = properties.defaultDateType
            defaultTimeType = properties.defaultTimeType
            dateProperties = properties
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelDateItem(field: self.field)
        copy.answer = nil
        copy.defaultAnswer = nil
        return copy
    }
    
    public override func isAnswered() -> Bool {
        if let dateValue = (answer as? DateTimeAnswer)?.value?.first, !dateValue.isEmpty {
            return true
        }
        return false
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return DateTimeAnswer(JSON: valueObject)
        }
        return nil
    }
}

public class FormViewModelSubmitItem: FormViewModelItem {
    override public init(field: Field?) {
        super.init(field: nil)
        
        type = .Submit
        fieldId = "submit"
    }
}

public class FormViewModelMapItem: FormViewModelItem {
    public var showPostalCode: Bool?
    public var zoom: Int?
    public var lat: Double?
    public var lng: Double?
    public var address: String?
    public var postalCode: String?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? MapProperties {
            showPostalCode = properties.showPostalCode
            zoom = properties.place?.zoom
            lat = properties.place?.lat
            lng = properties.place?.lng
            address = properties.place?.address
            postalCode = properties.place?.postalCode
        }
    }
}

public class FormViewModelLocationItem: FormViewModelInteractiveItem {
    public var allShown: Bool!
    
    override init(field: Field?) {
        super.init(field: field)
        
        allShown = false
    }
    
    public override func isAnswered() -> Bool {
        if let locationValue = (answer as? LocationAnswer)?.value, locationValue.count > 0 {
            return true
        }
        return false
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return LocationAnswer(JSON: valueObject)
        }
        return nil
    }
}

public class FormViewModelSliderItem: FormViewModelInteractiveItem {
    public var start: Int?
    public var end: Int?
    public var step: Int?
    public var selectionMode: SliderSelectionMode?
    public var defaultAnswer: SliderAnswer?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? SliderProperties {
            start = properties.start
            end = properties.end
            step = properties.step
            selectionMode = properties.selectionMode
            defaultAnswer = properties.defaultAnswer
        }
    }
    
    public override func isAnswered() -> Bool {
        if let sliderValue = (answer as? SliderAnswer)?.value, sliderValue
            .count > 0 {
            return true
        }
        return false
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return SliderAnswer(JSON: valueObject)
        }
        return nil
    }
    
    public override func getAnswerString() -> String {
        guard let answerValue = (answer as? SliderAnswer)?.value else {
            return ""
        }
        let stringValues = answerValue.map { "\($0)" }
        return stringValues.joined(separator: ", ")
    }
}

public class FormViewModelNPSItem: FormViewModelNumberBaseItem {
    public var defaultAnswer: BaseAnswerText?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? NpsProperties {
            defaultAnswer = properties.defaultAnswer
        }
    }
}

public class FormViewModelRateItem: FormViewModelNumberBaseItem {
    public var rateType: RateType?
    public var scale: Int?
    public var rateColor: String?
    public var defaultAnswer: BaseAnswerText?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? RateProperties {
            rateType = properties.rateType
            scale = properties.scale
            rateColor = properties.rateColor
            defaultAnswer = properties.defaultAnswer
        }
    }
}

public class FormViewModelFaceRateItem: FormViewModelNumberBaseItem {
    public var defaultAnswer: BaseAnswerText?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? FaceRateProperties {
            defaultAnswer = properties.defaultAnswer
        }
    }
}

public class FormViewModelMCQBaseItem: FormViewModelInteractiveItem {
    public var options: [MCQOption]?
    public var defaultAnswer: BaseAnswerMCQ?
    public var newDefAnswer: BaseAnswerMCQGUID?
    public var predefinedOptions: String?
    public var shuffleOptions: Bool = false
    public var otherOption: Bool = false
    public var otherOptionText: String?
    public var naOption: Bool = false
    public var naOptionText: String?
    public var allShown: Bool!
    public var isCascade: Bool?
    public var dataSourcId: String?
    public var dataSource: DataSource?
    public var isCascadeValuesEmpty: Bool?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? MCQBaseProperties {
            options = properties.options
            isCascade = properties.isCascade
            dataSourcId = properties.dataSourcId
            dataSource = properties.dataSource
            defaultAnswer = properties.defaultAnswer
            newDefAnswer = properties.newDefaultAnswer
            predefinedOptions = properties.predefinedOptions
            shuffleOptions = properties.shuffleOptions ?? false
            otherOption = properties.otherOption ?? false
            otherOptionText = properties.otherOptionText
            naOption = properties.naOption ?? false
            naOptionText = properties.naOptionText
            if let localization = properties.localization as? MCQLocalization {
                self.localization = localization
            }
        }
        allShown = false
    }
    
    public override func isAnswered() -> Bool {
        if let mcqValue = (answer as? BaseAnswerMCQ)?.value?.first, !(mcqValue.name?.isEmpty ?? true) {
            return true
        }
        return false
    }
    
    public override func handleSavedAnswer(_ sAnswer: Any?) -> BaseAnswer? {
        if let valueObject = sAnswer as? JSON2 {
            return BaseAnswerMCQ(JSON: valueObject)
        }
        return nil
    }
    
    public override func getAnswerString() -> String {
        var values = [String]()
        if let answer = answer as? BaseAnswerMCQ, let answerValues = answer.value {
            for answerValue in answerValues {
                values.append(getMCQLocalizedOption(answerValue.name ?? "", answer: answer) ?? "")
            }
        }
        return values.joined(separator: ", ")
    }
    
    func getMCQLocalizedOption(_ id: String, answer: BaseAnswerMCQ) -> String? {
        if id.isMCQOtherID {
            return answer.otherAnswer
        } else if id.isMCQNAID {
            if !FormBuilder.isFormSameLanguage, let localizedNAOption = (localization as? MCQLocalization)?[FormBuilder.appCurrentLanguage]?.naOptionText, !localizedNAOption.isEmpty {
                return localizedNAOption
            } else {
                return naOptionText
            }
        } else {
            if !FormBuilder.isFormSameLanguage, let localizedOption = (localization as? MCQLocalization)?[FormBuilder.appCurrentLanguage]?.options?.first(where: {$0.id == id})?.name, !localizedOption.isEmpty {
                return localizedOption
            } else {
                return options?.first(where: {$0.id == id})?.name
            }
        }
    }
}

public class FormViewModelCheckboxItem: FormViewModelMCQBaseItem, NSCopying {
    public var representation: CheckBoxRepresentation! = .CheckBox
    public var minNumberOfSelectedOptions: Int?
    public var maxNumberOfSelectedOptions: Int?
    public var isChecked: Bool? = false

    
    override init(field: Field?) {
        super.init(field: field)
        
        representation = .CheckBox
        if let properties = field?.properties as? CheckboxProperties {
            minNumberOfSelectedOptions = properties.minNumberOfSelectedOptions
            maxNumberOfSelectedOptions = properties.maxNumberOfSelectedOptions
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelCheckboxItem(field: self.field)
        copy.answer = nil
        copy.newDefAnswer = nil
        copy.defaultAnswer = nil
        return copy
    }
}

public class FormViewModelRadioItem: FormViewModelMCQBaseItem, NSCopying {
    public var representation: CheckBoxRepresentation! = .Radio
    public var minNumberOfSelectedOptions: Int?
    public var maxNumberOfSelectedOptions: Int?

    override init(field: Field?) {
        super.init(field: field)
        
        representation = .Radio
        if let properties = field?.properties as? CheckboxProperties {
            minNumberOfSelectedOptions = properties.minNumberOfSelectedOptions
            maxNumberOfSelectedOptions = properties.maxNumberOfSelectedOptions
        }

    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelRadioItem(field: self.field)
        copy.answer = nil
        copy.newDefAnswer = nil
        copy.defaultAnswer = nil
        return copy
    }
}

public class FormViewModelDropdownItem: FormViewModelMCQBaseItem, NSCopying {
    public var multiSelect: Bool = false
    public var selectAllBox: Bool = false
    public var minNumberOfSelectedOptions: Int?
    public var maxNumberOfSelectedOptions: Int?
    public var ddlSubType: String?
    
    override init(field: Field?) {
        super.init(field: field)
        
        if let properties = field?.properties as? DropdownProperties {
            multiSelect = properties.multiSelect ?? false
            selectAllBox = properties.selectAllBox ?? false
            minNumberOfSelectedOptions = properties.minNumberOfSelectedOptions
            maxNumberOfSelectedOptions = properties.maxNumberOfSelectedOptions
            dataSource = properties.dataSource
            ddlSubType = properties.ddlType
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = FormViewModelDropdownItem(field: self.field)
        copy.answer = nil
        copy.defaultAnswer = nil
        copy.newDefAnswer = nil
        return copy
    }
}

public class FormViewModelTableItem: FormViewModelInteractiveItem {
    public var minRows: Int?
    public var maxRows: Int?
    public var showTotals: Bool?
    public var totalFields: Int?
    public var allowDeleteRows: Bool?
    public var allowEditRows: Bool?
    public var allowAddRows: Bool?

    
    // local variable contains added items in the table control
    public var items: [[FormViewModelItem]] = []
    
    // local variable contains child fields related to this table
    public var childControls: [FormViewModelItem] = []
    public var cascadingComponent: [[Int: [String: [String: String]]]?]? = []
    
    override init(field: Field?) {
        super.init(field: field)
        if let properties = field?.properties as? TableProperties {
            minRows = properties.minRows
            maxRows = properties.maxRows
            showTotals = properties.showTotals
            totalFields = properties.totalFields
            allowDeleteRows = properties.allowDeleteRows
            allowEditRows =  properties.allowEditRows
            allowAddRows =  properties.allowAddRows
            
        }
    }
}

public struct SectionObject: Equatable{
    public static func == (lhs: SectionObject, rhs: SectionObject) -> Bool {
        return true
    }
    
    public var id: String
    public var dummy: Bool
    public var opened: Bool
    public var items: [FormViewModelItem]
    public var item: FormViewModelItem? = nil
}

public struct SectionObjectForSummary {
    public var id: String
    public var dummy: Bool
    public var opened: Bool
    public var items: [FormViewModelItemStruct]
    public var item: FormViewModelItemStruct? = nil
}

public class PrefixViewModel {
    public var display: PrefixDisplay?
    public var value: [String]?
    
    init(prefix: Prefix?) {
        display = PrefixDisplay(rawValue: prefix?.display ?? "")
        value = prefix?.value?.components(separatedBy: ",")
    }
    
    public enum PrefixDisplay: String {
        case TextBox = "TextBox"
        case DropDown = "DropDown"
    }
}

public enum CheckBoxRepresentation {
    case CheckBox
    case Radio
}
