//
//  SummaryPagesTableViewCell.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 09/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit

protocol UpdateConstraintTableViewDelegate: AnyObject {
    func didUpdateHeight()
}

// MARK: - SummaryPagesTableViewCell
class SummaryPagesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: IntrinsicTableView! {
        didSet {
            configureTableView()
        }
    }
    
    // MARK: - Properties
    var sectionObjects = [SectionObject]()
    var hiddenItemsIDs = Set<String>()
    var updateHiddenItemsIDs: ((Set<String>) -> Void)?
    var reloadExternalTableView: ((Bool) -> Void)?
    var didTapDownloadAttachment: ((String) -> Void)?
    var parentVC: UIViewController = UIViewController()
    var formBuilder = FormBuilder.shared
    var isEditable: Bool = false
    var isMyRequestFlag: Bool = false
    var rowIndices: [Int] = []
    var uniqueIdentifiers = [String]()
    var isFromRequestDetails = false
    var shouldReload = true
    weak var delegate: UpdateConstraintTableViewDelegate?
    var formViewController: ServiceSummaryPagesVC?
    var showEmptyFieldsFlag = false
    var fieldsWithHideRules = [String]()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        registerCells()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    // MARK: - Setup Methods
    
    /// Initializes table view with required data and properties.
    func configure(with data: [SectionObject], parentVC: UIViewController, isEditable: Bool, isFromRequestDetails: Bool, isMyRequestFlag: Bool, showEmptyFieldsFlag: Bool, reloaded: Bool) {
        self.fieldsWithHideRules = []
        self.sectionObjects = data
        self.parentVC = parentVC
        self.isEditable = isEditable
        self.isFromRequestDetails = isFromRequestDetails
        self.isMyRequestFlag = isMyRequestFlag
        self.showEmptyFieldsFlag = showEmptyFieldsFlag
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        updateTableHeight()
        self.reloadExternalTableView?(!reloaded)
    }
    
    /// Registers all necessary table view cells.
    private func registerCells() {
        tableView.tableFooterView = UIView()
        tableView.registerHaederFooterCell(viewType: ExpandedSectionHeader.self)

//        tableView.registerHaederFooterCell(idintifier: ExpandedSectionHeader.cerqel_identifier)
        tableView.register(LabelSheetWithSwitchTVCell.cerqel_nib, forCellReuseIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier)
        tableView.register(NewTextBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewTextBoxTVCell.cerqel_identifier)
        tableView.register(NewTextAreaTVcell.cerqel_nib, forCellReuseIdentifier: NewTextAreaTVcell.cerqel_identifier)
        tableView.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
        tableView.register(NewDatePickerTVCell.cerqel_nib, forCellReuseIdentifier: NewDatePickerTVCell.cerqel_identifier)
        tableView.register(NewLinkControlTVcell.cerqel_nib, forCellReuseIdentifier: NewLinkControlTVcell.cerqel_identifier)
        tableView.register(NewInfoIndicatorTVcell.cerqel_nib, forCellReuseIdentifier: NewInfoIndicatorTVcell.cerqel_identifier)
        tableView.register(NewTableControlTVCell.cerqel_nib, forCellReuseIdentifier: NewTableControlTVCell.cerqel_identifier)
        tableView.register(NewDropDownTVCell.cerqel_nib, forCellReuseIdentifier: NewDropDownTVCell.cerqel_identifier)
        tableView.register(NewCheckBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewCheckBoxTVCell.cerqel_identifier)
        tableView.register(NewUploadMediaTVcell.cerqel_nib, forCellReuseIdentifier: NewUploadMediaTVcell.cerqel_identifier)
        tableView.register(NewSwitchCell.cerqel_nib, forCellReuseIdentifier: NewSwitchCell.cerqel_identifier)
        tableView.register(NewLblTVcell.cerqel_nib, forCellReuseIdentifier: NewLblTVcell.cerqel_identifier)
    }
    
    /// Configures table view properties for automatic dimensions.
    private func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44 // Estimated row height for performance optimization
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 56 // Estimated section header height
    }
    
    // MARK: - Helper Methods
    /// Updates the table height dynamically.
    private func updateTableHeight() {
        tableView.layoutIfNeeded()
        delegate?.didUpdateHeight()
    }
    
    /// Returns the localized section title based on the current language.
    ///
    /// - Parameter item: The form view model item.
    /// - Returns: Localized section title.
    func getSectionTitle(item: FormViewModelItem?) -> String {
        var label = item?.label ?? ""
        let isArabic = isArabicCerqel()
        
        if isArabic {
            if let localizedLabel = item?.localization?["ar"]?.label, !localizedLabel.isEmpty {
                label = localizedLabel
            } else if let subLabel = item?.localization?["ar"]?.sublabel, !subLabel.isEmpty {
                label = subLabel
            }
        } else {
            if let localizedLabel = item?.localization?["en"]?.label, !localizedLabel.isEmpty {
                label = localizedLabel
            } else if let subLabel = item?.localization?["en"]?.sublabel, !subLabel.isEmpty {
                label = subLabel
            }
        }
        return label
    }
    
    /// Returns the current item at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the item.
    /// - Returns: The corresponding `FormViewModelItem`.
    func getCurrentItem(indexPath: IndexPath) -> FormViewModelItem {
        guard sectionObjects.count > indexPath.section,
              sectionObjects[indexPath.section].items.count > indexPath.row else {
            return FormViewModelItem(field: nil)
        }
        
        let item = sectionObjects[indexPath.section].items[indexPath.row]
        if !showEmptyFieldsFlag {  // showEmpty == false
            switch item.type {
            case .Table:
                if let tableItem = item as? FormViewModelTableItem, tableItem.items.isEmpty {
                    hiddenItemsIDs.insert(tableItem.fieldId)
                    tableItem.hidden = true
                }
            case .FileUpload:
                if let fileUploadItem = item as? FormViewModelFileUploadItem, fileUploadItem.attachmentsList.isEmpty {
                    hiddenItemsIDs.insert(fileUploadItem.fieldId)
                    fileUploadItem.hidden = true
                }
            default:
                if let answer = item.answer as? DefaultBaseAnswerTextNewFormat {
                    if answer.value == nil {
                        hiddenItemsIDs.insert(item.fieldId)
                        item.hidden = true
                    }
                }else if item.answer == nil {
                    hiddenItemsIDs.insert(item.fieldId)
                    item.hidden = true
                }
            }
            
//            if !hiddenItemsIDs.isEmpty {
                updateHiddenItemsIDs?(hiddenItemsIDs)
            print("hiddenItemsIDs count is:- \(hiddenItemsIDs.count)")
//            }
        }else { // show all case
            guard !fieldsWithHideRules.contains(item.id) else { return item }
            for hiddenId in hiddenItemsIDs {
                if item.fieldId == hiddenId {
                    if let visibilityPermission = item.field?.visibilityPermissions {
                        print("item label is:- \(item.label)")
                        print("item visibilityPermissions is:- \(item.field?.visibilityPermissions)")
                        print("item hidden is:- \(item.hidden)")
                        if !visibilityPermission.contains("Hide") {
                            item.hidden = false
                        }
                    } else {
                        item.hidden = false
                    }
                    handleItemRules(item)
                }
            }
        }
        
        return item
    }
    
    public func handleItemRules(_ item: FormViewModelItem) {
        for ruleId in item.rules?.dependOn ?? [] {
            if let rule = formBuilder.formViewModel.rules?.first(where: { $0.id == ruleId }) {
                handleRule(rule, item)
            }
        }
    }
    
    func handleRule(_ rule: Rule, _ item: FormViewModelItem?) {
        
        var valid = false
        let ruleOperation = rule.operation ?? .OR
        
        let conditions = rule.ifConditions ?? []
        var validCount = 0
        
        func evaluateCondition(at index: Int) {
            guard index < conditions.count else {
                if ruleOperation == .And {
                    valid = (validCount == conditions.count)
                }
                executeActions(valid: valid, rule: rule)
                return
            }
            
            let condition = conditions[index]
            var linkedItem: FormViewModelItem?
            linkedItem = item
            if let fieldId = condition.fieldId {
                if let item = item, item.fieldId == fieldId {
                    
                }else {
                    linkedItem = formBuilder.itemsDict[fieldId]?.0 ?? item
                }
            } else if let item = item {
                linkedItem = item
            }
            
            if let linkedItem = linkedItem {
                formBuilder.isItemValid(linkedItem, condition: condition) { isValid in
                    if isValid {
                        validCount += 1 // Increment valid condition counter
                    }
                    
                    if ruleOperation == .OR {
                        if isValid {
                            // If operation is OR and one condition is valid, execute with valid = true
                            self.executeActions(valid: true, rule: rule)
                            return
                        }
                    }
                    
                    // Move to the next condition
                    evaluateCondition(at: index + 1)
                }
            } else {
                // If no linkedItem, move to the next condition
                evaluateCondition(at: index + 1)
            }
        }
        
        // Start evaluating conditions from the first one
        evaluateCondition(at: 0)
    }
    
    private func executeActions(valid: Bool, rule: Rule) {
        for action in rule.doActions ?? [] {
            let actionType = action.type ?? .Show
            for id in action.targetFieldsIds ?? [] {  // Dependent fields
                handleShowRuleResult(
                    action: action, (valid, actionType),
                    itemID: id,
                    rule: rule)
            }
        }
    }
    
    func handleShowRuleResult(action: DoAction, _ result: (Bool, ActionType), itemID: String, rule: Rule) {
        switch result.1 {
        case .Show:
            guard !result.0 else { return }
            for (sectionIndex, sectionObject) in sectionObjects.enumerated() {
                for (itemIndex, item) in sectionObject.items.enumerated() {
                    if item.id == itemID {
                        sectionObjects[sectionIndex].items[itemIndex].hidden = true
                        if !fieldsWithHideRules.contains(itemID) { fieldsWithHideRules.append(itemID) }
                    }
                }
            }
            tableView.reloadData()
        case .Hide:
            guard result.0 else { return }
            for (sectionIndex, sectionObject) in sectionObjects.enumerated() {
                for (itemIndex, item) in sectionObject.items.enumerated() {
                    if item.id == itemID {
                        sectionObjects[sectionIndex].items[itemIndex].hidden = true
                        if !fieldsWithHideRules.contains(itemID) { fieldsWithHideRules.append(itemID) }
                    }
                }
            }
            tableView.reloadData()
        default:
            break
        }

    }
}

extension SummaryPagesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0 // Add space between sections by setting a footer height
    }
    
    func checkFieldsAnswers() {
        for section in sectionObjects {
            for item in section.items {
                switch item.type {
                case .Table:
                    if let tableItem = item as? FormViewModelTableItem, tableItem.items.isEmpty {
                        hiddenItemsIDs.insert(tableItem.fieldId)
                        tableItem.hidden = true
                    }
                case .FileUpload:
                    if let fileUploadItem = item as? FormViewModelFileUploadItem, fileUploadItem.attachmentsList.isEmpty {
                        hiddenItemsIDs.insert(fileUploadItem.fieldId)
                        fileUploadItem.hidden = true
                    }
                default:
                    if let answer = item.answer as? DefaultBaseAnswerTextNewFormat {
                        if answer.value == nil {
                            hiddenItemsIDs.insert(item.fieldId)
                            item.hidden = true
                        }
                    }else if item.answer == nil {
                        hiddenItemsIDs.insert(item.fieldId)
                        item.hidden = true
                    }
                }
            }
        }
    }
    
    func shouldSectionHide(section: Int) -> Bool {
        let sectionChildren = sectionObjects[section].items
        if !showEmptyFieldsFlag {
            checkFieldsAnswers()
        }
        for child in sectionChildren {
            if !child.hidden {
                return false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            guard let `self` = self else {return}
            if self.shouldReload {
                self.shouldReload = false
                self.tableView.reloadData()
                self.updateTableHeight()
            }
        }
        return true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionObjects.count
    }

    
    // This function returns the number of rows in a given section of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the current section object from the formBuilder's sectionObjects array
        let currentSection = sectionObjects[section].item
        
        // Check if the current section type is .Section
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) {
            // If the section is collapsed, return 0 (no rows)1
            // Otherwise, return the count of items in the section
            return (currentSection?.isCollapsedSection ?? false) ? 0 : sectionObjects[section].items.count
        } else {
            // If the current section type is not .Section, return 1 (single row)
            return 1
        }
    }
    // This function returns a view to be used as the header for a given section of the table view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if shouldSectionHide(section: section) {
            return UIView()
        }
        
        
        // Get the current section object from the formBuilder's sectionObjects array
        let currentSection = sectionObjects[section].item
        // Check if the current section type is .Section
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) /*&& !HelperFunctions.isHiddenSection(items: sectionObjects[section].items)*/{
            // Dequeue a reusable header view of type ExpandedSectionHeader
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandedSectionHeader.cerqel_identifier) as! ExpandedSectionHeader
            // Configure the header with the section title and expansion state
            header.configure(sectionTitle: self.getSectionTitle(item: currentSection), isExpanded: !(currentSection?.isCollapsedSection ?? false), isEditMode: true)
            header.headerView.backgroundColor = UIColor(hexCerqel: "#F2F8FF")
            // Define a closure to handle the collapsed state toggling
            header.collapsed = {
                self.toggleSection(section)
            }
            
            // Return the configured header view
            return header
        } else {
            // If the current section type is not .Section, return nil (no header view)
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if shouldSectionHide(section: section) {
            return 0.0
        }
        
        let currentSection = sectionObjects[section].item
        return (currentSection?.type == .Section && !(currentSection?.hidden ?? false) /*&& !HelperFunctions.isHiddenSection(items: sectionObjects[section].items)*/) ? 56 : 0.0
    }
    
    private func toggleSection(_ section: Int) {
        sectionObjects[section].item?.isCollapsedSection?.toggle()
        tableView.reloadData()
        self.updateTableHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let sectionType =  sectionObjects[section].item
        let row = indexPath.row
        let item = getCurrentItem(indexPath: indexPath)
        if item.hidden {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
            return cell
        }
        switch item.type {
        case .TextBox, .Numerical:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextBoxTVCell.cerqel_identifier, for: indexPath) as! NewTextBoxTVCell
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.formViewController = self.formViewController
            cell.handleDisabledText(disabled: true)
            if (item.answer as? TextboxAnswer) != nil && ((item.field?.properties as? TextBoxProperties)?.required ?? false) && item.isError == false  {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            if (item.answer as? BaseAnswerText) != nil && ((item.field?.properties as? NumberProperties)?.required ?? false) && item.isError == false  {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.valueChanged = { [unowned self] text, isError in
                if (item.answer as? TextboxAnswer)?.value as? String != (text)?.value as? String , item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: text, isError: isError, reload: false)
                }
            }
            
            cell.dataSourceFetchingInTextNumberControl = { [weak self] dataSource, textBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    
                    
                    formBuilder.setSelfControlCascadingForSameControl(item: textBoxItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textBoxItem.fieldId })
                    }) {
                        if let rowIndex =  sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textBoxItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            
            // Check and call the closure if needed
            if let dataSourceId = item.field?.properties?.dataSourcId/*, cell.textFieldValue.isEmpty*/ {
                cell.dataSourceFetchingInTextNumberControl?(dataSourceId, item)
            }
            cell.validationChanged = { [unowned self] valid in
                self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            
            cell.numberValueChanged = { [unowned self] numberValue, isError in
                if (item.answer as? BaseAnswerText)?.value as? String != (numberValue as? BaseAnswerText)?.value as? String , item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: numberValue, isError: isError, reload: false)
                }
            }
            return cell
        case .TextArea:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            guard let item = item as? FormViewModelTextAreaItem else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextAreaTVcell.cerqel_identifier, for: indexPath) as! NewTextAreaTVcell
            cell.formViewController = self.formViewController
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.handleDisabledText(disabled: true)
            if (item.answer as? TextAreaAnswer) != nil && ((item.field?.properties as? TextAreaProperties)?.required ?? false){
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.textViewEndEditing = { [unowned self] text, isError in
                let textAnswer = (item.answer as? TextAreaAnswer)?.htmlValue?.lowercased()
                let newTextAnswer = text?.htmlValue?.lowercased()
                if textAnswer != newTextAnswer, cell.item.fieldId == item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: text, isError: isError,reload: false)
                }
            }
            cell.validationChanged = { [unowned self] valid in
                fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, textAreaItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: textAreaItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textAreaItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textAreaItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId, parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            
            cell.tag = section
            return cell
        case .Paragraph:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            if item is FormViewModelParagraphItem {
                
                let subType = item.paragraphSubType
                if subType == .Text {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLblTVcell.cerqel_identifier, for: indexPath) as! NewLblTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    cell.valueChanged = {[weak self] value in
                        guard let `self` = self else {return}
                        if value.value != (item.answer as? ParagraphAnswer)?.value ,item.fieldId == cell.item.fieldId {
                            self.fieldValueChangedAt(section, row: row, value: value, reload: false)
                        }
                    }
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    cell.handleDisabledText(disabled: true)
                    cell.formViewController = self.formViewController
                    return cell
                }
                if subType == .Link {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLinkControlTVcell.cerqel_identifier, for: indexPath) as! NewLinkControlTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    cell.formViewController = self.formViewController
                    return cell
                }
                if subType == .InfoIndcator {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewInfoIndicatorTVcell.cerqel_identifier, for: indexPath) as! NewInfoIndicatorTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    return cell
                }
                if subType == .LabelSheetWithToggle {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.handleDisableControl(item: item as? FormViewModelParagraphItem, isRequest: true)
                    if item.answer != nil && ((item.answer as? Bool) == true) && ((item.field?.properties as? ParagraphProperties)?.required ?? false) {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        let ans = item.answer.value as? ParagraphAnswer
                        let booleanAnswer = Bool(ans?.value ?? "false") ?? false
                        self.fieldValidationChangedAt(section, row: row, isValid: booleanAnswer)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            
                            if self.isMyRequestFlag {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                                    return
                                }
                            }
                            
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                                    self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: parentVC, sender: nil)
                    }
                    
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        self.fieldValueChangedAt(section, row: row, value: paragraphAnswer, isError: !ans , reload: false)
                        if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                            self.fieldValidationChangedAt(section, row: row, isValid: ans)
                        }else {
                            self.fieldValidationChangedAt(section, row: row, isValid: true)
                        }
                    }
                    cell.formViewController = self.formViewController
                    return cell
                }
                if subType == .LabelSheetWithCheckBox {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheetWithCheckBox = true
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.handleDisableControl(item: item as? FormViewModelParagraphItem, isRequest: true)
                    if item.answer != nil && ((item.answer as? Bool) == true) && ((item.answer as? Bool) == true) && ((item.field?.properties as? ParagraphProperties)?.required ?? false) {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        let ans = item.answer.value as? ParagraphAnswer
                        let booleanAnswer = Bool(ans?.value ?? "false") ?? false
                        self.fieldValidationChangedAt(section, row: row, isValid: booleanAnswer)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            if self.isMyRequestFlag {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                                    return
                                }
                            }
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                                    self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    cell.formViewController = self.formViewController
                    return cell
                }
                
                if subType == .LabelSheet {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheet = true
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.handleDisabledData(isDisabled: true)
                    if item.answer != nil && ((item.answer as? Bool) == true) && ((item.field?.properties as? ParagraphProperties)?.required ?? false) {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        self.fieldValidationChangedAt(section, row: row, isValid: false)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            if self.isMyRequestFlag {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                                    return
                                }
                            }
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                                    self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    cell.formViewController = self.formViewController
                    return cell
                }
            }
            return UITableViewCell()
            
        case .Date:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDatePickerTVCell.cerqel_identifier, for: indexPath) as! NewDatePickerTVCell
            cell.tag = section
            cell.valueChanged = { [unowned self] value, isError in
                if item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value, isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.handleDisabledDateControl(disabled: true)
            if item.answer != nil && ((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            if item.answer == nil &&  !((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, dateItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: dateItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == dateItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "", currentId: item.fieldId,  parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.formViewController = self.formViewController
            return cell
            
        case .switchControl:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewSwitchCell.cerqel_identifier, for: indexPath) as! NewSwitchCell
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.tag = section
            cell.handleDisableControl(item: item as? FormViewModelSwitchItem, isRequest: true)
            if item.answer != nil && ((item.answer as? SwitchAnswer)?.value == true) && ((item as? FormViewModelSwitchItem)?.required == true ) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.dataSourceFetching = { [weak self] dataSource, switchItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: switchItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == switchItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId, parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.formViewController = self.formViewController
            return cell
        case .Checkbox:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.isFromRequest = true
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? CheckboxProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, checkBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: checkBoxItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == checkBoxItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkBoxItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.formViewController = self.formViewController
            return cell
        case .Radio:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.isFromRequest = true
            cell.handleDissabledData(isDisabled: true)
            if item.answer != nil && ((item.field?.properties as? RadioProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.dataSourceFetching = { [weak self] dataSource, radioItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    
                    formBuilder.setSelfControlCascadingForSameControl(item: radioItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == radioItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.formViewController = self.formViewController
            return cell
        case .Dropdown:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDropDownTVCell.cerqel_identifier, for: indexPath) as! NewDropDownTVCell
            
            cell.dataSourceFetchingInDDL = {[weak self] dataSource, ddlItem in
                guard let `self` = self else {return}
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: ddlItem)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == ddlItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == ddlItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.disableDropDown()
            if !((item.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) && ((item.field?.properties as? DropdownProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.formViewController = self.formViewController
            return cell
            
        case .FileUpload:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewUploadMediaTVcell.cerqel_identifier, for: indexPath) as! NewUploadMediaTVcell
            cell.tag = section
            cell.isRequest = isFromRequestDetails
            cell.isSummary = true
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            validation(item, section, row)
            if item.answer != nil && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.setupDetailsView()
            
            cell.didTapDownloadAttachment = { attachmentID in
                self.didTapDownloadAttachment?(attachmentID)
            }
            cell.formViewController = self.formViewController
            return cell
            
        case .Table:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTableControlTVCell.cerqel_identifier, for: indexPath) as! NewTableControlTVCell
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.isRequest = isFromRequestDetails ? 1 : 0
            cell.isEditable = true
            if let table = item as? FormViewModelTableItem {
                if table.items.count < table.minRows ?? 0 || table.items.count > table.maxRows ?? 0{
                    self.fieldValidationChangedAt(section, row: row, isValid: false)
                }else {
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                }
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, tableItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if self.isMyRequestFlag {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.RequestDetails]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.TaskDetails]) {
                            return
                        }
                    }
                    
                    formBuilder.setSelfControlCascadingForSameControl(item: tableItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == tableItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == tableItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",currentId: item.fieldId,parameters: item.field?.properties?.dataSource?.parameters)
                            self.fetchDataSourceOptionsList(code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.formViewController = self.formViewController
            cell.handleHiddenViews(item: item as? FormViewModelTableItem, isRequest: isFromRequestDetails ? 1 : 2)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = getCurrentItem(indexPath: indexPath)
        if item.hidden {
            return 0
        }
        return UITableView.automaticDimension
    }
}
