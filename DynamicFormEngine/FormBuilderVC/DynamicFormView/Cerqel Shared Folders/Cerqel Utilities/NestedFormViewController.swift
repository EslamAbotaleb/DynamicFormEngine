//
//  NestedFormViewController.swift
//
//
//  Created by Marwan on 30/01/2023.
//  Copyright © 2023 All rights reserved.
//

var editAt = (edit:false,at:0,delete:false)

protocol NestedFormViewDelegate: AnyObject {
    func didTapAdd(tableID: String, itemIndex: Int, children: [FormViewModelItem], cascadingComponent: [Int:[String:[String:String]]]?)
    func didDismiss()
}

import UIKit
import FittedSheets
import EzPopup
import RxCocoa
import RxSwift

class NestedFormViewController: BottomSheetVCCerqel {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var bgTopView: UIView!
    @IBOutlet weak var bgBottomView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var errorMsgLbl: UILabel!
    
    @IBOutlet weak var nestedTtlLbl: UILabel!
    
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var successStackView: UIStackView!
    
    @IBOutlet weak var successInfoLbl: UILabel!
    
    @IBOutlet weak var addBtn: LocalizedButton! {
        didSet {
            handleSubmitButton(enabled: editAt.edit ? true : false)
        }
    }
    @IBOutlet weak var subServicesTitleLbl: UILabel!
    @IBOutlet weak var subServicesValueTF: UITextField!
    @IBOutlet weak var subServicesBgView: UIView!
    
    
    @IBOutlet weak var formTableView: UITableView!
    @IBOutlet var tableViewsCollection: [UITableView]!
    
    
        // MARK: - Variables
    
    var formBuilder = FormBuilder.shared
    let disposeBag = DisposeBag()
    var currentCascadingComponent: [Int:[String:[String:String]]]?
    var itemIndex: Int!
    var childControls: [FormViewModelItem] = []
                        
//    var currentAnswer: [[String:Any?]]?  // [[id: value]]
    
//    var currentOptions = [MCQOption]()
    var currentValue: Any?
    var currentCascadingItemID = ""
    var sectionObjects = [SectionObject]()
    var formSectionDictionary = [String: [FormViewModelItem]]()
    var selectedMediaUploaderIdx: Int?
    weak var delegate: NestedFormViewDelegate?
    var titleForTable = ""
    var tableControlFieldID = ""
    var currentPage = 0 {
        didSet {
            formBuilder.handlePageData()
            activeTableView.reloadData()
        }
    }
    var activeTableView: UITableView!
    var shouldReset = true
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        nestedTtlLbl.text = titleForTable
        setupUI()
        reloadFormData()
        prepareSectionObjects()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !(DynamicAuthManager.shared.isCameraOpened ){
            delegate?.didDismiss()
        }
    }
    
    
        // MARK: - Functions
    
    static func instance() -> NestedFormViewController{
        if let vc = UIStoryboard(name: "NestedFormViewController", bundle: nil).instantiateInitialViewController() as? NestedFormViewController {
            vc.cerqel_sheetHeight = 800
            return vc
        }
        return UIViewController() as! NestedFormViewController
    }
    
    /// Setup UI & Table's cells
    func setupUI() {
        setupTableView()
    }
    
    /// init listeners
    func config() {
        
        formBuilder.targetComponents.subscribe(onNext: {[weak self] (targets) in
            guard let `self` = self else {return}
            print("targets = ",targets)
            print("itemIndex = ", self.itemIndex)
        }).disposed(by: disposeBag)
        
        formBuilder.cascadingComponentsWithMultiParents.subscribe(onNext: { (component) in
            DispatchQueue.main.async {[weak self] in
            guard let `self` = self else {return}
            guard let component = component else {return}
                self.currentCascadingComponent = self.customizeMultiParentsComponent(component: component)
            self.fetchCascadingOptionsListWithMultiParents(code: component.keys.first?.values.first ?? "",
                                                           parameters: component.values.first ?? [],
                                                           row: 0)
        }
        }).disposed(by: disposeBag)
        
        formBuilder.cascadingComponents.subscribe(onNext: { (component) in
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                guard let component = component else {return}
                self.currentCascadingComponent = component
                var cascadingSection = 0
                let fetchedIndex = component.keys.first ?? 0
                for (index,sec) in self.sectionObjects.enumerated() {
                    guard let item = sec.items.first else {return}
                    if item.fieldId == self.formBuilder.formViewModel.items[fetchedIndex].fieldId {
                        cascadingSection = index
                    }
                }
                
                
                self.fetchCascadingOptionsList(code: component.values.first?.keys.first ?? "",
                                               parentValue: component.values.first?.values.first ?? ["":""],
                                               section: cascadingSection,
                                               row: 0)
            }
        }).disposed(by: disposeBag)
    }
    
    func customizeMultiParentsComponent(component: [[Int:String]:[[String:String]]]) -> [Int:[String:[String:String]]] {
        //cascadingComponents.accept([itemIndex:[id:[key:val]]])
        //multiAnswers.insert([key:val], at: index)
        //cascadingComponentsWithMultiParents.accept([[itemIndex:id]:multiAnswers])
        let itemIndex = component.keys.first?.keys.first ?? 0
        let id = component.keys.first?.values.first ?? ""
        let key = component.values.first?.first?.keys.first ?? ""
        let value = component.values.first?.first?.values.first ?? ""
        return [itemIndex:[id:[key:value]]]
    }
    
    /// Handle submit button state
    /// - Parameter enabled: should it to be enabled or not
    func handleSubmitButton(enabled: Bool) {
        addBtn.isUserInteractionEnabled = enabled //enabled
        addBtn.backgroundColor = !enabled ? .alertClosed : .blue
    }
    
    
    /// Setting up table's cells
    func setupTableView() {
        for tableView in tableViewsCollection {
            tableView.tableFooterView = UIView()
            tableView.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
            tableView.register(LabelSheetWithSwitchTVCell.cerqel_nib, forCellReuseIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier)
            tableView.register(TextBoxTableViewCell.cerqel_nib, forCellReuseIdentifier: TextBoxTableViewCell.cerqel_identifier)
            tableView.register(NewTextBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewTextBoxTVCell.cerqel_identifier)
            tableView.register(NewTextAreaTVcell.cerqel_nib, forCellReuseIdentifier: NewTextAreaTVcell.cerqel_identifier)
            tableView.register(RichTextAreaTableViewCell.cerqel_nib, forCellReuseIdentifier: RichTextAreaTableViewCell.cerqel_identifier)
            tableView.register(SectionTableViewCell.cerqel_nib, forCellReuseIdentifier: SectionTableViewCell.cerqel_identifier)
            tableView.register(EmptyTableViewCell.cerqel_nib, forCellReuseIdentifier: EmptyTableViewCell.cerqel_identifier)
            tableView.register(ParagraphTableViewCell.cerqel_nib, forCellReuseIdentifier: ParagraphTableViewCell.cerqel_identifier)
            tableView.register(NewDatePickerTVCell.cerqel_nib, forCellReuseIdentifier: NewDatePickerTVCell.cerqel_identifier)
            tableView.register(NewLinkControlTVcell.cerqel_nib, forCellReuseIdentifier: NewLinkControlTVcell.cerqel_identifier)
            tableView.register(NewInfoIndicatorTVcell.cerqel_nib, forCellReuseIdentifier: NewInfoIndicatorTVcell.cerqel_identifier)
            tableView.register(DateTableViewCell.cerqel_nib, forCellReuseIdentifier: DateTableViewCell.cerqel_identifier)
            tableView.register(SubmitTableViewCell.cerqel_nib, forCellReuseIdentifier: SubmitTableViewCell.cerqel_identifier)
            tableView.register(MapTableViewCell.cerqel_nib, forCellReuseIdentifier: MapTableViewCell.cerqel_identifier)
            tableView.register(LocationTableViewCell.cerqel_nib, forCellReuseIdentifier: LocationTableViewCell.cerqel_identifier)
            tableView.register(SliderTableViewCell.cerqel_nib, forCellReuseIdentifier: SliderTableViewCell.cerqel_identifier)
            tableView.register(NPSTableViewCell.cerqel_nib, forCellReuseIdentifier: NPSTableViewCell.cerqel_identifier)
            tableView.register(RateTableViewCell.cerqel_nib, forCellReuseIdentifier: RateTableViewCell.cerqel_identifier)
            tableView.register(FaceRateTableViewCell.cerqel_nib, forCellReuseIdentifier: FaceRateTableViewCell.cerqel_identifier)
            tableView.register(MCQTableViewCell.cerqel_nib, forCellReuseIdentifier: MCQTableViewCell.cerqel_identifier)
            tableView.register(DropDownTableViewCell.cerqel_nib, forCellReuseIdentifier: DropDownTableViewCell.cerqel_identifier)
            tableView.register(NewTableControlTVCell.cerqel_nib, forCellReuseIdentifier: NewTableControlTVCell.cerqel_identifier)
            tableView.register(NewDropDownTVCell.cerqel_nib, forCellReuseIdentifier: NewDropDownTVCell.cerqel_identifier)
            tableView.register(NewCheckBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewCheckBoxTVCell.cerqel_identifier)
            tableView.register(NewUploadMediaTVcell.cerqel_nib, forCellReuseIdentifier: NewUploadMediaTVcell.cerqel_identifier)
            tableView.register(NewSwitchCell.cerqel_nib, forCellReuseIdentifier: NewSwitchCell.cerqel_identifier)
            tableView.register(NewLblTVcell.cerqel_nib, forCellReuseIdentifier: NewLblTVcell.cerqel_identifier)
            
        }
    }
    
    
    /// Render table's children
    func prepareSectionObjects() {
        for item in childControls {
            if let fieldId = item.fieldId, let itemType = item.type {
                if itemType == .Section {
                    let sectionItems = self.formSectionDictionary[fieldId] ?? []
                    self.sectionObjects.append(SectionObject(id: fieldId, dummy: false, opened: false, items: sectionItems, item: item))
                    self.formBuilder.nestedSectionObjects =  self.sectionObjects
                } else {
                    if let properties = item.field?.properties as? InteractiveProperties {
                        if (properties.required ?? false) {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? TextBaseProperties {
                        if (properties.required ?? false) {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? CheckboxProperties {
                        if (properties.required ?? false) {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? TextAreaProperties {
                        if (properties.required ?? false) {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? NumberProperties {
                        if (properties.required ?? false) {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? FileUploadProperties {
                        item.isError =  properties.required == nil ? false :  properties.required
                    }
                    if let properties = item.field?.properties as? switchProperties {
                        item.isError =  properties.required == nil ? false :  properties.required
                    }
                    if let properties = item.field?.properties as? DateTimeProperties {
                        item.isError =  properties.required == nil ? false :  properties.required
                    }
                    if let properties = item.field?.properties as? MCQBaseProperties {
                        item.isError =  properties.required == nil ? false :  properties.required
                    }
                    if let properties = item.field?.properties as? TableProperties {
                        item.isError =  properties.required == nil ? false :  properties.required
                    }
                    self.sectionObjects.append(SectionObject(id: fieldId, dummy: true, opened: true, items: [item]))
                    self.formBuilder.nestedSectionObjects =  self.sectionObjects
                }
            }
        }
        self.activeTableView = self.formTableView
        self.activeTableView.reloadData()
    }
    
    
    /// Getting current control
    /// - Parameter indexPath: control's indexPath
    /// - Returns: rendered control
    func getCurrentItem(indexPath: IndexPath) -> FormViewModelItem {
        var item: FormViewModelItem!
        item = sectionObjects[indexPath.section].items[indexPath.row]
        return item
    }
    
    
    
    // MARK: - IBActions
    
    /// cancel button tapped
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// exit button tapped
    @IBAction func dismissViewTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /// add button tapped
    @IBAction func addTapped(_ sender: UIButton) {
        var finalChildren = [FormViewModelItem]()
        for section in sectionObjects {
            let formModelItem = section.items[0]
            finalChildren.append(formModelItem)
        }
        
        delegate?.didTapAdd(tableID: tableControlFieldID, itemIndex: self.itemIndex, children: finalChildren, cascadingComponent: currentCascadingComponent)
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension NestedFormViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let item = getCurrentItem(indexPath: indexPath)
        if item.hidden {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
            return cell
        }
        switch item.type {
        case .TextBox, .Numerical:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextBoxTVCell.cerqel_identifier, for: indexPath) as! NewTextBoxTVCell
            cell.tag = section
            
            cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.valueChanged = { [unowned self] text, isError in
                if (item.answer as? TextboxAnswer)?.value as? String != (text as? TextboxAnswer)?.value as? String , item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: text, isError: isError, reload: false)
                }
            }
            cell.validationChanged = { [unowned self] valid in
                    self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            cell.numberValueChanged = { [unowned self] numberValue, isError in
                if item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: numberValue, isError: isError, reload: false)
                }
            }
            return cell
        case .TextArea:
            guard let item = item as? FormViewModelTextAreaItem else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextAreaTVcell.cerqel_identifier, for: indexPath) as! NewTextAreaTVcell
            cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.textViewEndEditing = { [unowned self] text, isError in
                let textAnswer = (item.answer as? TextAreaAnswer)?.htmlValue?.lowercased()
                let newTextAnswer = text?.htmlValue?.lowercased()
                if textAnswer != newTextAnswer , cell.item.fieldId == item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: text, isError: isError,reload: false)
                }
            }
            cell.validationChanged = { [unowned self] valid in
                    fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            cell.tag = section
            return cell
        case .Paragraph:
            if item is FormViewModelParagraphItem {
                let subType = item.paragraphSubType
                if subType == .Text {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLblTVcell.cerqel_identifier, for: indexPath) as! NewLblTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    let ans = item.answer.value as? ParagraphAnswer
                    self.fieldValueChangedAt(section, row: row, value: ans.value, reload: false)
                    cell.item = item
                    cell.tag = section
                    return cell
                }
                if subType == .Link {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLinkControlTVcell.cerqel_identifier, for: indexPath) as! NewLinkControlTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    cell.item = item
                    cell.tag = section
                    return cell
                }
                if subType == .InfoIndcator {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewInfoIndicatorTVcell.cerqel_identifier, for: indexPath) as! NewInfoIndicatorTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    cell.item = item
                    cell.tag = section
                    return cell
                }
                if subType == .LabelSheetWithToggle {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    let ans = item.answer.value as? ParagraphAnswer
                    cell.item = item
                    cell.tag = section
                    if item.answer != nil && (item.answer as? Bool) == true {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        let ans = item.answer.value as? ParagraphAnswer
                        let booleanAnswer = Bool(ans?.value ?? "false") ?? false
                        self.fieldValidationChangedAt(section, row: row, isValid: booleanAnswer)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            self.fetchOptionsList(code: cell.dataSourceId, section: section, row: row)
                        }
                    }
                    
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
                    }
                    
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                            self.fieldValidationChangedAt(section, row: row, isValid: ans)
                        }else {
                            self.fieldValidationChangedAt(section, row: row, isValid: true)
                        }
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        self.fieldValueChangedAt(section, row: row, value: paragraphAnswer, reload: false)
                    }
                    return cell
                }
                
                if subType == .LabelSheetWithCheckBox {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    let ans = item.answer.value as? ParagraphAnswer
                    cell.isLabelSheetWithCheckBox = true
                    cell.item = item
                    cell.tag = section
                    if item.answer != nil && (item.answer as? Bool) == true  {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        let ans = item.answer.value as? ParagraphAnswer
                        let booleanAnswer = Bool(ans?.value ?? "false") ?? false
                        self.fieldValidationChangedAt(section, row: row, isValid: booleanAnswer)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            self.fetchOptionsList(code: cell.dataSourceId, section: section, row: row)
                        }
                    }
                    
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
                    }
                    
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                            self.fieldValidationChangedAt(section, row: row, isValid: ans)
                        }else {
                            self.fieldValidationChangedAt(section, row: row, isValid: true)
                        }
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        self.fieldValueChangedAt(section, row: row, value: paragraphAnswer, reload: false)
                    }
                    return cell
                }
                
                if subType == .LabelSheet {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    let ans = item.answer.value as? ParagraphAnswer
                    cell.isLabelSheet = true 
                    cell.item = item
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        self.fieldValidationChangedAt(section, row: row, isValid: false)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if item.answer != nil {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            self.fetchOptionsList(code: cell.dataSourceId, section: section, row: row)
                        }
                    }
                    
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
                    }
                    
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                            self.fieldValidationChangedAt(section, row: row, isValid: ans)
                        }else {
                            self.fieldValidationChangedAt(section, row: row, isValid: true)
                        }
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        self.fieldValueChangedAt(section, row: row, value: paragraphAnswer, reload: false)
                    }
                    return cell
                }
            }
            return UITableViewCell()
            
        case .Date:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDatePickerTVCell.cerqel_identifier, for: indexPath) as! NewDatePickerTVCell
            cell.tag = section
            cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.valueChanged = { [unowned self] value, isError in
                if item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value, isError: isError, reload: false)
                }
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                    self.fieldValidationChangedAt(section, row: row, isValid: valid)
                
            }
            return cell
            
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewSwitchCell.cerqel_identifier, for: indexPath) as! NewSwitchCell
            cell.item = item
            cell.tag = section
            if item.answer != nil && (item.answer as? SwitchAnswer)?.value == true {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                if let item = item as? FormViewModelSwitchItem, !item.required {
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                }else {
                    self.fieldValidationChangedAt(section, row: row, isValid: valid)
                }
            }
            cell.valueChanged = { [unowned self] value, isError in
                if (item.answer as? SwitchAnswer)?.value as? Bool != value?.value as? Bool, item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value, isError: isError, reload: false)
                }
            }
            return cell
        case .Checkbox:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                    self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            cell.valueChanged = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value,isError: isError, reload: false)
                }
            }
            return cell
        case .Radio:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                    self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            cell.valueChanged = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId{
                    self.fieldValueChangedAt(section, row: row, value: value,isError: isError, reload: false)
                }
            }
            return cell
        case .Dropdown:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDropDownTVCell.cerqel_identifier, for: indexPath) as! NewDropDownTVCell
            
            cell.dataSourceFetchingInDDL = {[weak self] dataSource in
                guard let `self` = self else {return}
                DispatchQueue.global(qos: .background).async {[weak self] in
                    guard let `self` = self else {return}
                    self.fetchOptionsList(code: dataSource, section: section, row: row)
                }
            }
            cell.tag = section
            cell.parentCascadingItemID = formBuilder.cascadingSourceIDs?.first
                cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.dropDownPressed = { [weak self] options, title, placeHolder, selectedValues, multiSelect, ddlSubType in
                guard let `self` = self else {return}
                
                if ddlSubType == "Search" {
                    self.fieldValueChangedAt(section,
                                             row: row,
                                             value: "myvalue")
                    
                    self.selectOptionFromSearch(code: self.formBuilder.searchComponents.value?.keys.first ?? "" ,
                                                options: options,
                                                title: title,
                                                placeHolder: placeHolder,
                                                selectedValues: selectedValues,
                                                multiSelect: multiSelect,
                                                section: section,
                                                row: row)
                    
                }else {
                    guard !options.isEmpty else {return}
                    self.selectOption(options: options, title: title, selectedValues: selectedValues, multiSelect: multiSelect, section: section, row: row)
                }
            }
            cell.validationChanged = { [unowned self] valid in
                formBuilder.sectionObjects[section].items[row].isError = !valid
            }
            cell.valueChanged = {[weak self] value, isError in
                guard let `self` = self else {return}
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value,isError: isError, reload: false)
                }
            }
            return cell
            
        case .FileUpload:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewUploadMediaTVcell.cerqel_identifier, for: indexPath) as! NewUploadMediaTVcell
            cell.tag = section
            cell.item = item
            if item.answer != nil {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.didTapAddAttachment = {[weak self] in
                guard let `self` = self else {return}
                self.formBuilder.fileUploadFieldID = item.fieldId
                self.formBuilder.fileUploadFieldRow = row
                self.formBuilder.fileUploadFieldSection = section
                if let arr = item as? FormViewModelFileUploadItem {
                    if arr.attachmentsList.count < arr.maxAttachmentsNumber ?? 0 || arr.maxAttachmentsNumber == nil {
                        self.selectedMediaUploaderIdx = indexPath.row
                        self.openMFileMenu(attachmentExtensions: arr.attachmentExtensions)
                    }
                }
            }
            
            cell.didRemoveAttachment = { attachmentID in
                guard let item = item as? FormViewModelFileUploadItem else { return }
                item.attachmentsList.removeAll(where: { $0.id == attachmentID })
                tableView.reloadSections(IndexSet(integer: section), with: .none)
            }
            
            cell.validationChanged = { [unowned self] valid in
                if let item = item as? FormViewModelFileUploadItem, !item.required {
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                }else {
                    self.fieldValidationChangedAt(section, row: row, isValid: valid)
                }
            }
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

extension NestedFormViewController {
    
    /// Check validation of every control
    /// - Parameters:
    ///   - section: current section
    ///   - row: current row
    ///   - isValid: is current control valid or not
    func fieldValidationChangedAt(_ section: Int, row: Int, isValid: Bool) {
        guard section < self.sectionObjects.count else {
            // Section index is out of range
            return
        }
        guard row < self.sectionObjects[section].items.count else {
            // Row index is out of range
            return
        }

        self.sectionObjects[section].items[row].isError = !isValid
        var isDimmed = false
        for section in self.sectionObjects {
            for item in section.items {
                if item.isError && !item.hidden {
                    print("Not valid component: \(item.label ?? "")")
                    isDimmed = true
                    break
                }
            }
            if isDimmed {
                break
            }
        }
        handleSubmitButton(enabled: !isDimmed)
    }
    
    func fieldValidationChangedWhenMultiCascade() {
        var isDimmed = false
        
        for section in self.sectionObjects {
            for item in section.items  {
                if let switchItem = item as? FormViewModelSwitchItem {
                    if item.answer != nil && !item.hidden && ((item.answer as? SwitchAnswer)?.value == false)  {
                        isDimmed = true
                        break
                    }
                }
              
                if item is FormViewModelDateItem{
                    if item.answer == nil && !item.hidden  {
                        isDimmed = true
                        break
                    }
                }

                if item is FormViewModelParagraphItem {
                    if item.answer == nil && !item.hidden   {
                        isDimmed = true
                        break
                    }
                }

                if item is FormViewModelNumericItem {
                    if item.answer == nil && !item.hidden  {
                        isDimmed = true
                        break
                    }
                }

                if item is FormViewModelTextBoxItem {
                    if item.answer == nil && !item.hidden  {
                        isDimmed = true
                        break
                    }
                }
                if isDimmed {
                    break
                }
            }
        }
        
        handleSubmitButton(enabled: !isDimmed)
    }

    
    
    /// Updating every control after it's value changed
    /// - Parameters:
    ///   - section: current section number
    ///   - row: current row number
    ///   - value: current control's answer
    ///   - isError: is control has error or not
    ///   - reload: should tableView reload or not
    func fieldValueChangedAt(_ section: Int, row: Int, value: Any?, isError: Bool = false, reload: Bool = true) {
        sectionObjects[section].items[row].isError = isError
        sectionObjects[section].items[row].isValid = !isError
        sectionObjects[section].items[row].answer = value
        saveChanges(reload: reload, section: section, row: row)
        saveObjectsIntoFormBuilder(section,row)
        DynamicAuthManager.shared.isCameraOpened = false
    }
    
    
    
    /// Saving table children into the main form then fire thier rules
    /// - Parameters:
    ///   - section: current section number
    ///   - row: current row number
    func saveObjectsIntoFormBuilder(_ section: Int, _ row: Int) {
        if let rowIndex = formBuilder.sectionObjects.firstIndex(where: {$0.id == tableControlFieldID}) {
            guard !formBuilder.sectionObjects[rowIndex].items.isEmpty else {return}
            guard let allComponent = formBuilder.sectionObjects[rowIndex].items[0] as? FormViewModelTableItem else {return}
            let children = allComponent.childControls
            guard section < sectionObjects.count else {return}
            guard !sectionObjects[section].items.isEmpty else {return}
            let childIndex = children.firstIndex(where: {$0.fieldId == sectionObjects[section].items[row].fieldId}) ?? 0
            
            
            allComponent.childControls[childIndex] =  sectionObjects[section].items[row]
            
            formBuilder.sectionObjects[rowIndex].items[0] = allComponent
            for (index,item) in formBuilder.formViewModel.items.enumerated() {
                for (innerChildIndex,child) in allComponent.childControls.enumerated() {
                    if item.fieldId == child.fieldId {
                        if childIndex == innerChildIndex {
                            formBuilder.formViewModel.items[index] = allComponent.childControls[childIndex]
                        }else {
                            for sectionObject in sectionObjects {
                                if sectionObject.items[row].fieldId == formBuilder.formViewModel.items[index].fieldId {
                                    formBuilder.formViewModel.items[index] = sectionObject.items[row]
                                }
                            }
                        }
                    }
                }
            }
            formBuilder.populateItemsDict()
            formBuilder.handleItemRules(&sectionObjects[section].items[row])
        }
    }
    
    
    /// Reload tableView after saving new answers
    /// - Parameters:
    ///   - reload: should tableView reload or not
    ///   - section: current section number
    ///   - row: current row number
    func saveChanges(reload: Bool = true, section: Int, row: Int) {
        guard let _ = activeTableView else {return}
        guard section >= 0 && row >= 0 && section < activeTableView.numberOfSections && row < activeTableView.numberOfRows(inSection: section) else {
            // section or row value is invalid, so exit the function
            return
        }
        if reload {
            activeTableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }
    }
}
