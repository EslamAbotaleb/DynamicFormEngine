//
//  NestedFormViewController.swift
//
//
//  Created by Marwan on 30/01/2023.
//  Copyright © 2023 All rights reserved.
//

var editAt = (edit:false,at:0,delete:false)

protocol NestedFormViewDelegate: AnyObject {
    func didTapAdd(tableID: String, itemIndex: Int, children: [FormViewModelItem], cascadingComponent: [Int:[String:[String:String]]]?,isEdit: Bool)
    func didDismiss()
}

public extension UIViewController {
    public func showToastWithError(_ message: String) {
        self.view.makeToast(message, duration: 3.0, position: .center)
    }
}


import UIKit
import EzPopup
public import RxCocoa
internal import RxSwift
import Toast

class NestedFormViewController: FormBaseViewController {
    
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
            addBtn.setSubmitButtonTheme()
            FormManager.shared.handleSubmitButton(vc: self, submitButton: addBtn, enabled: editAt.edit ? true : false)
        }
    }
    @IBOutlet weak var subServicesTitleLbl: UILabel!
    @IBOutlet weak var subServicesValueTF: UITextField!
    @IBOutlet weak var subServicesBgView: UIView!
    @IBOutlet weak var actionsBtnView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var formTableView: UITableView!
    @IBOutlet var tableViewsCollection: [UITableView]!
    @IBOutlet weak var cancelButton: LocalizedButton!{
        didSet {
            cancelButton.setCancelButtonTheme()
        }
    }
    
    
    // MARK: - Variables
    
    var currentCascadingComponent: [Int:[String:[String:String]]]?
    var itemIndex: Int!
    var childControls: [FormViewModelItem] = []
    var singleRowItems: [FormViewModelItem] = []
    var isEdit = false
    var isFromRequestDetails = false
    var currentValue: Any?
    var currentCascadingItemID = ""
    var sectionObjects = [SectionObject]() {
        didSet {
            sectionObjects = formBuilder.sort(sectionObjects, nested: true)
        }
    }
    var formSectionDictionary = [String: [FormViewModelItem]]()
    var selectedMediaUploaderIdx: Int?
    weak var delegate: NestedFormViewDelegate?
    var titleForTable = ""
    var tableControlFieldID = ""
    var isParagrapghDataSet = false
    var tableItem: FormViewModelTableItem?
    var disAppearShouIdCalled = false
    var currentPage = 0 {
        didSet {
            formBuilder.handlePageData(currentPage)
            activeTableView.reloadData()
        }
    }
    var shouldReset = true
    var rowIndices: [Int] = []
    var isEditable = false
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        nestedTtlLbl.text = titleForTable
        setupUI()
        prepareSectionObjects()
        uploadMediadelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        FormManager.shared.reloadFormData(vc: self)
        whenFromRequestDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formBuilder.isNestedForm = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard disAppearShouIdCalled else {
            
            return
        }
        disAppearShouIdCalled = false
        if !(DynamicAuthManager.shared.isCameraOpened ){
            delegate?.didDismiss()
        }
        formBuilder.targetComponents.accept([])
        self.singleRowItems.removeAll()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        formBuilder.isNestedForm = false
    }
    
    // MARK: - Functions
    
    func whenFromRequestDetails() {
        actionsBtnView.isHidden = isFromRequestDetails
        infoView.isHidden = isFromRequestDetails
    }
    func showToastCerqel(msg: String){
        
        var style = ToastStyle()
        style.imageSize = CGSize(width: 20, height: 20)
        style.messageFont = UIFont.bodyLMedium()
        style.messageColor = .white
        style.backgroundColor = .black
        style.fadeDuration = 3
        
        self.view.makeToast(msg, point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140), title: nil, image: nil, style: style, completion: nil)
    }
    
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
        
        formBuilder.targetComponents.subscribe(onNext: { _ in
        }).disposed(by: disposeBag)
        
        formBuilder.cascadingComponentsWithMultiParentsNested.subscribe(onNext: { (component) in
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                guard let component = component else {return}
                self.currentCascadingComponent = customizeMultiParentsComponent(component: component)
                if formBuilder.isPageMode {
                    FormManager.shared.fetchCascadingOptionsListWithMultiParentsWhenPages(vc: self,
                                                                                          sectionObjects: self.sectionObjects, submitButton: self.addBtn,
                                                                                          code: component.keys.first?.values.first ?? "",
                                                                                          parameters: component.values.first ?? [],
                                                                                          row: 0)
                }else {
                    FormManager.shared.fetchCascadingOptionsListWithMultiParents(vc: self,
                                                                                 sectionObjects: self.sectionObjects,
                                                                                 submitButton: self.addBtn,
                                                                                 code: component.keys.first?.values.first ?? "",
                                                                                 parameters: component.values.first ?? [],
                                                                                 row: 0)
                }
            }
        }).disposed(by: disposeBag)
        
        formBuilder.cascadingComponents.subscribe(onNext: { [weak self] (component) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let component = component,
                      let fetchedIndex = component.keys.first,
                      fetchedIndex < self.formBuilder.formViewModel.items.count else {
                    return
                }
                
                self.currentCascadingComponent = component
                var cascadingSection = 0
                
                for (index, sec) in self.sectionObjects.enumerated() {
                    guard let item = sec.items.first else { continue }
                    if fetchedIndex < self.formBuilder.formViewModel.items.count,
                       item.fieldId == self.formBuilder.formViewModel.items[fetchedIndex].fieldId {
                        cascadingSection = index
                        break
                    }
                }
                if let code = component.values.first?.keys.first,
                   let parentValue = component.values.first?.values.first {
                    FormManager.shared.fetchCascadingOptionsList(vc: self,
                                                                 sectionObjects: self.sectionObjects,
                                                                 code: code,
                                                                 parentValue: parentValue,
                                                                 section: cascadingSection,
                                                                 row: 0)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func customizeMultiParentsComponent(component: [[Int:String]:[[String:String]]]) -> [Int:[String:[String:String]]] {
        let itemIndex = component.keys.first?.keys.first ?? 0
        let id = component.keys.first?.values.first ?? ""
        let key = component.values.first?.first?.keys.first ?? ""
        let value = component.values.first?.first?.values.first ?? ""
        return [itemIndex:[id:[key:value]]]
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
                        if item.answer != nil {
                            item.isError = false
                        }else {
                            if (properties.required ?? false) {
                                item.isError =  properties.required == nil ? false :  properties.required
                            }
                        }
                    }
                    if let properties = item.field?.properties as? TextBaseProperties {
                        if item.answer != nil {
                            item.isError = false
                        }else {
                            if (properties.required ?? false) {
                                item.isError =  properties.required == nil ? false :  properties.required
                            }
                        }
                    }
                    if let properties = item.field?.properties as? CheckboxProperties {
                        if item.answer != nil {
                            item.isError = false
                        }else {
                            if (properties.required ?? false) {
                                item.isError =  properties.required == nil ? false :  properties.required
                            }
                        }
                    }
                    if let properties = item.field?.properties as? TextAreaProperties {
                        if (item.answer as? TextAreaAnswer) != nil {
                            item.isError =  false
                        }else{
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? NumberProperties {
                        if item.answer != nil {
                            item.isError =  false
                        }else{
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? TextBoxProperties {
                        if item.answer != nil {
                            item.isError =  false
                        }else{
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? FileUploadProperties {
                        if item.answer != nil {
                            item.isError = false
                        }else {
                            if (properties.required ?? false) {
                                item.isError =  properties.required == nil ? false :  properties.required
                            }
                        }
                    }
                    if let properties = item.field?.properties as? switchProperties {
                        if (item.answer as? SwitchAnswer) != nil {
                            item.isError = false
                        }else {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? DateTimeProperties {
                        if item.answer != nil {
                            item.isError = false
                        }else {
                            item.isError =  properties.required == nil ? false :  properties.required
                        }
                    }
                    if let properties = item.field?.properties as? MCQBaseProperties {
                        if item.answer != nil {
                            item.isError = false
                        }else {
                            if (properties.required ?? false) {
                                item.isError =  properties.required == nil ? false :  properties.required
                            }
                        }
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
    
    
        /// Updating the control with the updated properties in formViewModel before reloading the ui
        /// - Parameters:
        ///   - section: section to be reloaded
        ///   - completion: returning the updated sections
        func updateProperties(section: Int, completion: @escaping (([SectionObject]) -> Void)) {
            guard section < sectionObjects.count, sectionObjects[section].items.count > 0 else {return}
            var sectionObject = sectionObjects[section].items[0]
            let formItems = formBuilder.formViewModel.items
            if let index = formItems.firstIndex(where: { $0.fieldId == sectionObject.fieldId }) {
                sectionObject = formItems[index]
                sectionObjects[section].items[0] = sectionObject
            }
            completion(sectionObjects)
        }
    
    
    func enableAddButton() -> Bool {
        var hasErrors = false
        for sectionIndex in 0..<sectionObjects.count {
            let section = sectionObjects[sectionIndex]
            for rowIndex in 0..<section.items.count {
                let item = section.items[rowIndex]
                let validationResult = FormManager.shared.validateControl(vc: self, item)
                
                if validationResult.isError {
                    hasErrors = true
                }
            }
        }
        return !hasErrors
    }
    
    
    // MARK: - IBActions
    
    /// cancel button tapped
    @IBAction func cancelTapped(_ sender: Any) {
        disAppearShouIdCalled = true
        dismiss(animated: true, completion: nil)
    }
    
    /// exit button tapped
    @IBAction func dismissViewTapped(_ sender: Any) {
        disAppearShouIdCalled = true
        dismiss(animated: true, completion: nil)
    }
    
    /// add button tapped
    @IBAction func addTapped(_ sender: UIButton){
//        guard atLeastOneRowIsFilled() else {
//            showToastCerqel(msg: "Please fill at least one or more fields".localized)
//            return}
        disAppearShouIdCalled = true
        var finalChildren = [FormViewModelItem]()
        for section in sectionObjects {
            let formModelItem = section.items[0]
            finalChildren.append(formModelItem)
        }
        for item in self.singleRowItems {
            // Check if an item with the same row index and field ID already exists
            if let existingIndex = formBuilder.allRowsChildControls.firstIndex(where: { $0.rowIndex == item.rowIndex && $0.fieldId == item.fieldId }) {
                // Update the existing item
                formBuilder.allRowsChildControls[existingIndex] = FormViewModelItemStruct(from: item)
            } else {
                // Append a new item
                let newItem = FormViewModelItemStruct(from: item)
                formBuilder.allRowsChildControls.append(newItem)
            }
        }
        
        if let targetItem = self.formBuilder.sectionObjects.first(where: { $0.id == self.tableControlFieldID }) {
            self.formBuilder.handleItemRules(targetItem.items[0], excludedView: isEditable ? .Edit : .Create, removeAnswer: false)
        }
        
        // Small delay to ensure isRuleViolated has the updated value
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else { return }
            
            if !formBuilder.isRuleViolated {
                delegate?.didTapAdd(tableID: tableControlFieldID, itemIndex: self.itemIndex, children: finalChildren, cascadingComponent: currentCascadingComponent, isEdit: self.isEdit)
                dismiss(animated: true, completion: nil)
                if let targetItem = self.formBuilder.sectionObjects.first(where: { $0.id == self.tableControlFieldID }) {

                    self.formBuilder.handleItemRules(targetItem.items[0], excludedView: isEditable ? .Edit : .Create, removeAnswer: false)
                }
            } else {
                if let item = tableItem {
                    let ruleWarning = isArabic() ? item.field?.properties?.localization?["ar"]?.ruleWarning?.unique : item.field?.properties?.localization?["en"]?.ruleWarning?.unique
                    self.showToastWithError(ruleWarning ?? "Action not allowed due to rule violation.")
                }
            }
        }
    }
}
