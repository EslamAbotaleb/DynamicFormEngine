//
//  FormBuilder.swift
//
//
//  Created by Yasser Osama on 24/10/2021.
//

internal import Alamofire
//import Expression
import Foundation
import ObjectMapper
public import RxCocoa
internal import RxSwift
import UIKit


public class FormBuilder {
    
    // MARK: - Singleton Instance
    static public var shared = FormBuilder()
    
    // MARK: - Flags and States
    var isRuleViolated = false
    var isTableEquation = false
    var currentPropertyTragetName = ""
    public var isNestedForm = false
    public var isCardMode = false
    public var goToSummary = false
    
    // MARK: - Form Data and Configuration
    public var form: FormModel! {
        didSet {
            if let form = form {
                FormBuilder.formLanguage = form.settings?.defaultLanguage ?? "en"
            }
        }
    }
    var requestModel: ModelRequestDetailsData!
    public var fields = [Field]()
    var allFields = [Field]()
    public var formModelItems = [FormViewModelItem]() {
        didSet {
            formModelItems = sort(items: formModelItems)
        }
    }
    var formViewModel: FormViewModel!
    
    var hiddenItemsIDs = [String]() {
        didSet {
            hiddenItemsIDs = Array(Set(hiddenItemsIDs))
        }
    }
    
    // MARK: - Language and Localization
    static private var formLanguage = ""
    static var appCurrentLanguage = "en"
    static var isFormSameLanguage: Bool {
        return appCurrentLanguage == formLanguage
    }
    
    // MARK: - Cascading Components and Dependencies
    var cascadingSourceIDs: [String]?
    var cascadingCurrentItemID: String?
    var cascadingComponentsWithMultiParents: BehaviorRelay<cascadingComponentWithMultiParents> = BehaviorRelay(value: nil)
    var cascadingComponentsWithMultiParentsNested: BehaviorRelay<cascadingComponentWithMultiParents> = BehaviorRelay(value: nil)
    var cascadingComponents: BehaviorRelay<cascadingComponent> = BehaviorRelay(value: nil)
    var searchComponents: BehaviorRelay<searchComponent> = BehaviorRelay(value: nil)
    var targetComponents: BehaviorRelay<[[String: String?]]> = BehaviorRelay(value: [])
    var targetComponentsForAppend = [[String: String?]]()
    var currentNestedRowIdx: String? = "1"
    
    // MARK: - Form Submission and Validation
    var serviceSubmittedResponse: BehaviorRelay<SubmitModel?> = BehaviorRelay(value: nil)
    var uniqueRulePassed: BehaviorRelay<(Bool, String?)> = BehaviorRelay(value: (false, nil))
    
    // MARK: - Sections, Pages, and Tables
    public var sections = [String]()
    public var pages = [String]()
    public var pagesArray = [FormViewModelItem]()
    public var tables = [String]()
    public var formPageDictionary = [String: [FormViewModelItem]]()
    public var formSectionDictionary = [String: [FormViewModelItem]]()
    public var tablesDictionary = [String: [FormViewModelItem]]()
    public var sectionObjects = [SectionObject]() {
        didSet {
            sectionObjects = sort(sectionObjects, nested: false)
        }
    }
    public var tableSectionObjects = [SectionObject]()
    public var summarySectionObjects = [SectionObject]()
    public var nestedSectionObjects = [SectionObject]()
    public var nestedSectionObjectsForTables = [SectionObject]()
    public var enablePageValidation = false
    public var isPageMode = false
    // MARK: - File Upload Handling
    public var fileUploadFieldID: String = ""
    public var fileUploadFieldSection: Int = 0
    public var fileUploadFieldRow: Int = 0
    var summaryPageDataSourceArray: [SectionPagesControl] = []
    var detailsPageDataSourceArray: [SectionPagesControl] = []
    // MARK: - Child Controls and Items
    var itemsDict = [String: (FormViewModelItem, Int)]()
    public var allRowsChildControls: [FormViewModelItemStruct] = []
    
    // MARK: - Reload Handlers
    public var reloadAt: ((Int, Any?, String?) -> Void)?
    public var reloadAtNested: ((Int, Any?) -> Void)?
    
    // MARK: - Service Details
    var serviceId: String = ""
    var serviceName: String?
    var formVersionId: String?
    
    // MARK: - Initialization and Reset
    func resetFormBuilder() {
        FormBuilder.shared = FormBuilder()
    }
    
    // MARK: - Typealiases
    typealias cascadingComponentWithMultiParents = [[Int: String]: [[String: String]]]?
    typealias cascadingComponent = [Int: [String: [String: String]]]?
    typealias searchComponent = [String: [String: String]]?
    
    
    func sort(_ sections: [SectionObject], nested: Bool) -> [SectionObject] {
        
        var sortedSections = sections
        sortedSections.sort { section1, section2 in
            if !nested {
                guard section1.items.first?.parentId == nil || section1.items.first?.parentId == "" else {return false}
                guard section2.items.first?.parentId == nil || section2.items.first?.parentId == "" else {return false}
            }
            // Extract the "order" values from the first items in each section
            let order1 = section1.items.first?.order ?? ""
            let order2 = section2.items.first?.order ?? ""
            
            // Handle numeric sorting, if applicable
            if let order1Int = Int(order1), let order2Int = Int(order2) {
                return order1Int < order2Int
            }
            
            // Fallback to lexicographical comparison for non-numeric or invalid orders
            return order1 < order2
        }
        return sortedSections
    }
    
    func sort(items: [FormViewModelItem]) -> [FormViewModelItem] {
        var sortedSections = items
        sortedSections.sort { section1, section2 in
            
            guard section1.parentId == nil || section1.parentId == "" else {return false}
            guard section2.parentId == nil || section2.parentId == "" else {return false}
            
            // Extract the "order" values from the first items in each section
            let order1 = section1.order ?? ""
            let order2 = section2.order ?? ""
            
            // Handle numeric sorting, if applicable
            if let order1Int = Int(order1), let order2Int = Int(order2) {
                return order1Int < order2Int
            }
            
            // Fallback to lexicographical comparison for non-numeric or invalid orders
            return order1 < order2
        }
        return sortedSections
    }
    
    func sort(fields: [Field]) -> [Field] {
        var sortedSections = fields
        sortedSections.sort { section1, section2 in
            
            guard section1.parentId == nil || section1.parentId == "" else {return false}
            guard section2.parentId == nil || section2.parentId == "" else {return false}
            
            // Extract the "order" values from the first items in each section
            let order1 = section1.order ?? ""
            let order2 = section2.order ?? ""
            
            // Handle numeric sorting, if applicable
            if let order1Int = Int(order1), let order2Int = Int(order2) {
                return order1Int < order2Int
            }
            
            // Fallback to lexicographical comparison for non-numeric or invalid orders
            return order1 < order2
        }
        return sortedSections
    }
    
    
    /// intialize form
    public func handleFormJSON(
        _ formJSON: JSON2, completion: @escaping (Bool) -> Void
    ) {
        guard let formModel = FormModel(JSON: formJSON) else {
            completion(false)
            return
        }
        self.form = formModel
        self.allFields = sort(fields: self.form.fields ?? [])
        self.formViewModel = FormViewModel(form: formModel)
        completion(true)
    }
    
    public func handleRequestDetailsJSON(_ formJSON: JSON2, completion: @escaping (Bool) -> Void) {
        guard let requestDetails = ModelRequestDetailsData(JSON: formJSON) else {
            completion(false)
            return
        }
        self.requestModel = requestDetails
        self.form = self.requestModel.viewForm?.schema
        self.allFields = self.requestModel.viewForm?.schema?.fields ?? []
        self.formViewModel = FormViewModel(form: self.requestModel.viewForm?.schema!)
        completion(true)
    }
    
    public func handleFormSchema(_ formSchema: FormModel, completion: @escaping (Bool) -> Void) {
        self.form = formSchema
        self.allFields = self.form.fields ?? []
        self.formViewModel = FormViewModel(form: formSchema)
        completion(true)
    }
    
    /// add form data
    public func populateFormData(isEdit: Bool, excludedView: ExcludedViews) {
        self.populateItemsDict()
        self.applyVisibilityPermissions()
        if !isEdit {
            self.handleItemsRulesWhenFirstInitiateForm(excludedView: excludedView,removeAnswer: true)
        }
        self.formModelItems = sort(items: self.formViewModel.items)
        self.enablePageValidation = form.settings?.enablePageValidation ?? false
        self.handleFormData()
    }
    
    /// adding items into formModelItems
    func handleFormData() {
        if let formFormat = form.settings?.format {
            if formFormat == "Classic" {
                isCardMode = false
                formModelItems = formViewModel.items
                handleClassicFormData()
            } else if formFormat == "Card" {
                isCardMode = true
            }
        }
    }
    
    /// handling classic data
    func handleClassicFormData() {
        for item in formModelItems {
            if let parentId = item.parentId, !parentId.isEmpty,
               let parentItem = formModelItems.first(where: { $0.fieldId == parentId }),
               let type = parentItem.type {
                
                if type == .Page {
                    // Ensure parentItem is not already added and maintain order
                    if !pagesArray.contains(where: { $0.fieldId == parentItem.fieldId }) {
                        pagesArray.append(parentItem)
                    }
                    handlePageDicData(parentId: parentId, item: item)
                } else if type == .Section {  // Handle section control
                    item.isSectionItem = true
                    handleSectionDicData(parentId: parentId, item: item)
                }
            }
            
            // Handle Submit items for the last page
            if item.type == .Submit, let lastPageId = pages.last {
                formPageDictionary[lastPageId]?.append(item)
            }
        }
        
        // Ensure pagesArray is sorted in the same order as formModelItems
        pagesArray = formModelItems.compactMap { item in
            if item.type == .Page {
                return item
            }
            return nil
        }
    }
    
    /// Handle Page Data based on parent id
    /// - Parameters:
    ///   - parentId: control's parent id
    ///   - item: current control
    func handlePageDicData(parentId: String, item: FormViewModelItem) {
        if formPageDictionary[parentId] == nil {
            // Only append the parentId if it's not already in the pages array
            if !pages.contains(parentId) {
                pages.append(parentId)
            }
            formPageDictionary[parentId] = [item]
        } else {
            formPageDictionary[parentId]?.append(item)
        }
        
        // Ensure the `pages` array is sorted in the same order as `formModelItems`
        pages = formModelItems.compactMap { formItem in
            if formItem.type == .Page {
                return formItem.fieldId
            }
            return nil
        }
    }
    
    
    /// Handle Section Data based on parent id
    /// - Parameters:
    ///   - parentId: control's parent id
    ///   - item: current control
    func handleSectionDicData(parentId: String, item: FormViewModelItem) {
        if formSectionDictionary[parentId] == nil {
            sections.append(parentId)
            formSectionDictionary[parentId] = [item]
        } else {
            formSectionDictionary[parentId]?.append(item)
        }
    }
    
    /// Creating sectionObjects for every new service
    public func handlePageData(_ index: Int? = nil) {
        sectionObjects.removeAll()
        detailsPageDataSourceArray.removeAll()
        
        // add tables with it's fields as a dictionary
        handleTableControlFields()
        // remove any field that is a child of table control from the form
        
        // this is for backwardCompatability in pages
        var formItems: [FormViewModelItem] = []
        
        if formModelItems.contains(where: { $0.type == .Page }) {
            // If there are `.Page` items, use `formPageDictionary`
            if let index = index {
                formItems = formPageDictionary[pages[index]] ?? [] //chldern parent id page
            }else {
                formItems = formModelItems
            }
            
            isPageMode = true
        } else {
            // Otherwise, use all items in `formModelItems`
            formItems = formModelItems
            isPageMode = false
        }
        
        for item in formItems {
            if let itemParentID = item.parentId,
               let parent = formModelItems.first(where: {
                   $0.fieldId == itemParentID
               }),
               parent.type == .Table
            {
                formItems.removeAll(where: { $0.fieldId == item.fieldId })
            }
        }
        let items = formItems
        for item in items {
            if let fieldId = item.fieldId, let itemType = item.type {
                // append items related to every single section
                if itemType == .Section {
                    let sectionItems = self.formSectionDictionary[fieldId] ?? []
                    if !self.sectionObjects.contains(where: { $0.id == fieldId }
                    ) {
                        self.sectionObjects.append(
                            SectionObject(
                                id: fieldId, dummy: false, opened: false,
                                items: sectionItems, item: item))
                    }
                }
                else {
                    if let properties = item.field?.properties as? InteractiveProperties {
                        if (properties.required ?? false) {
                            item.isError =  properties.required == nil ? false :  (properties.required ?? false)
                        }
                    }
                    if let properties = item.field?.properties
                        as? TextBaseProperties
                    {
                        if properties.required ?? false {
                            item.isError =
                            properties.required == nil
                            ? false : properties.required
                        }
                    }
                    if let properties = item.field?.properties
                        as? CheckboxProperties
                    {
                        if properties.required ?? false {
                            item.isError =
                            properties.required == nil
                            ? false : properties.required
                        }
                    }
                    if let properties = item.field?.properties
                        as? TextAreaProperties
                    {
                        if properties.required ?? false {
                            item.isError =
                            properties.required == nil
                            ? false : properties.required
                        }
                    }
                    if let properties = item.field?.properties
                        as? NumberProperties
                    {
                        if properties.required ?? false {
                            item.isError =
                            properties.required == nil
                            ? false : properties.required
                        }
                    }
                    if let properties = item.field?.properties
                        as? FileUploadProperties
                    {
                        item.isError =
                        properties.required == nil
                        ? false : properties.required
                    }
                    if let properties = item.field?.properties
                        as? switchProperties
                    {
                        item.isError =
                        properties.required == nil
                        ? false : properties.required
                    }
                    if let properties = item.field?.properties
                        as? DateTimeProperties
                    {
                        item.isError =
                        properties.required == nil
                        ? false : properties.required
                    }
                    if let properties = item.field?.properties
                        as? MCQBaseProperties
                    {
                        item.isError =
                        properties.required == nil
                        ? false : properties.required
                    }
                    if let properties = item.field?.properties
                        as? TableProperties
                    {
                        item.isError =
                        properties.required == nil
                        ? false : properties.required
                    }
                    // append items related to every field not section
                    if !(sectionObjects.isEmpty) {
                        var sectionExists = false
                        for section in sectionObjects {
                            if section.items.contains(where: {
                                $0.fieldId == fieldId
                            }) {
                                sectionExists = true
                                break
                            }
                        }
                        if !sectionExists {
                            sectionObjects.append(
                                SectionObject(
                                    id: fieldId, dummy: true, opened: true,
                                    items: [item]))
                        }
                    } else {
                        sectionObjects.append(
                            SectionObject(
                                id: fieldId, dummy: true, opened: true,
                                items: [item]))
                    }
                }
            }
        }
        
        if self.isPageMode {
            for (idx,page) in pagesArray.enumerated() {
                var pageSectionObjs : [SectionObject]? = []
                
                for section in sectionObjects {
                    if section.item?.parentId == page.fieldId {
                        pageSectionObjs?.append(.init(id: section.id, dummy: true, opened: true, items: section.items.filter({$0.parentId == section.item?.fieldId}),item: section.item))
                    }else {
                        for item in section.items {
                            if item.parentId == page.fieldId {
                                pageSectionObjs?.append(.init(id: item.fieldId, dummy: true, opened: true, items: section.items))
                            }
                        }
                    }
                }
                
                detailsPageDataSourceArray.append(.init(id:page.fieldId,
                                                        title: isArabic() ? page.localization?["ar"]?.label ?? "" : page.localization?["en"]?.label ?? "",
                                                        sectionObjectForSummary: pageSectionObjs,
                                                        isCollapsedSection: idx == 0 ? false : true ))
            }
        }else {
            detailsPageDataSourceArray.append(.init(id:"",title: "",sectionObjectForSummary: sectionObjects))
        }
        
        for items in sectionObjects.map({$0.items}) {
            for item in items {
                for (idx,id) in hiddenItemsIDs.enumerated() {
                    if id == item.fieldId {
                        item.hidden = false
                        if idx > hiddenItemsIDs.count {
                            hiddenItemsIDs.remove(at: idx)
                            print("hiddenItemsIDs after remove = ", hiddenItemsIDs)
                        }
                    }
                }
            }
        }
    }
    
    /// Handle table fields
    func handleTableControlFields() {
        self.tableSectionObjects.removeAll()
        for item in formModelItems {
            if let parentId = item.parentId, !parentId.isEmpty,
               let parentItem = formModelItems.filter({
                   $0.fieldId == parentId
               }).first, parentItem.type == .Table
            {
                if tablesDictionary[parentId] == nil {
                    tables.append(parentId)
                    tablesDictionary[parentId] = [item]
                    self.tableSectionObjects = [
                        SectionObject(
                            id: item.fieldId, dummy: true, opened: true,
                            items: [item])
                    ]
                } else {
                    tablesDictionary[parentId]?.append(item)
                    self.tableSectionObjects.append(
                        SectionObject(
                            id: item.fieldId, dummy: true, opened: true,
                            items: [item]))
                }
            }
            continue
        }
    }
    
    // set child controls to parent table view model item
    public func handleTableControlChildren() {
        for item in formModelItems {
            if item.type == .Table,
               let childs = tablesDictionary[item.fieldId],
               !childs.isEmpty,
               let table = item as? FormViewModelTableItem
            {
                table.childControls = childs
            }
        }
    }
    
    /// assigning controls with their field id
    func populateItemsDict() {
        for (i, item) in formViewModel.items.enumerated() {
            itemsDict[item.fieldId] = (item, i)
        }
    }
    
    func applyVisibilityPermissions() {
        for item in formViewModel.items {
            if let visibility = item.field?.visibilityPermissions {
                if visibility.contains("Hide") {
                    item.hidden = true
                } else if !visibility.contains("Edit") {
                    item.disabled = true
                }
            }
        }
    }
    
    /// reseting values
    public func resetValues() {
        form = nil
        allFields.removeAll()
        formViewModel = nil
        formModelItems.removeAll()
        sections.removeAll()
        pages.removeAll()
        pagesArray.removeAll()
        formPageDictionary.removeAll()
        formSectionDictionary.removeAll()
        sectionObjects.removeAll()
        isCardMode = false
        itemsDict.removeAll()
        tablesDictionary = [:]
    }
    
    public func filterByFieldId(_ specificFieldId: String) -> [FormViewModelItemStruct] {
        return allRowsChildControls.filter { $0.parentId == specificFieldId }
    }
}
