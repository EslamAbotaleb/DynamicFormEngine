//
//  ViewController.swift
//  FormBuilderSample
//
//  Created by Yasser Osama on 17/01/2023.
//

import UIKit
import EzPopup
import FittedSheets
import Expression
import SwiftMessages
import RxCocoa
import RxSwift
import SwiftUI
import JGProgressHUD
import Photos
/*
class FormVC: BottomSheetVC {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var bgTopView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var exitButtonContainerView: UIView!
    @IBOutlet weak var topColoredView: UIView!
    @IBOutlet weak var topColoredViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFormConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgBottomView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var errorMsgLbl: UILabel!
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var successStackView: UIStackView!
    @IBOutlet weak var successInfoLbl: UILabel!
    @IBOutlet weak var subServicesTitleLbl: UILabel!
    @IBOutlet weak var subServicesValueTF: UITextField!
    @IBOutlet weak var subServicesBgView: UIView!
    @IBOutlet weak var formTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            handleSubmitButton(enabled: false) // init submit button to be disabled at the beginning
            submitButton.setTitle("Next".localized, for: .normal)
        }
    }
    @IBOutlet var tableViewsCollection: [UITableView]!
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var emptyErrorLbl: UILabel!
    
    
    // MARK: - Variables
    
    var delegate: HandlePayloadMethods?
    var formBuilder = FormBuilder.shared
    var reloadDropDown:(() ->())?
    private let disposeBag = DisposeBag()
    var formId = ""
    var selectedMediaUploaderIdx: Int?
    var  ValidationSectionArray: [SectionObject] = []
    var currentPage = 0 {
        didSet {
            formBuilder.handlePageData()
            activeTableView.reloadData()
        }
    }
    var activeTableView: UITableView!
    var shouldReset = true
    var didPressDismissGesture: (()->())?
    var actionId: String?
    var detailsSchema: JSON2?
    var buttonId: String?
    var uniqueIdentifiers = [String]()
    var serviceId = ""
    var rowIndices: [Int] = []
    var singleRowItems: [FormViewModelItem] = []
    var isEditable = false
    var isApproverForm = false
    var isParagrapghDataSet = false
    var requestIdForApprover = ""
    var serviceIdFromDetails = ""
    
    var maxAttachmentsSize: Int?

    // MARK: - LifeCycle
    
    func dictionariesAreEqual(_ lhs: [String: Any], _ rhs: [String: Any]) -> Bool {
        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            formTableView.isPrefetchingEnabled = false
        }
        formBuilder.cascadingComponents.accept([:]) // Nov 5
        formBuilder.cascadingComponentsWithMultiParents.accept([:])
        formBuilder.sectionObjects.removeAll()
        activeTableView = nil
        
        if let schema = detailsSchema {
            self.getForm(schema: schema)
        } else if let id = actionId { // if form rendered from task details (dynamicAction)
            getActionsFormData(id: id)
        } else { // form rendered from specific service (dynamicForm) & edit Request
            getFormData(id: serviceId, isEdit: isEditable, isApproverForm: isApproverForm )
        }
        config()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        editAt = (edit: false, at: 0,delete: false)
        if serviceIdFromDetails != "" {
            formBuilder.serviceId = serviceIdFromDetails
        } else {
            formBuilder.serviceId = serviceId
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !(DFAuthManager.shared.isCameraOpened) && !formBuilder.goToSummary {
            formBuilder.serviceSubmittedResponse.accept(nil)
            formBuilder.resetFormBuilder()
            // Check if formBuilder is not nil and its properties are not empty before performing operations
            if !formBuilder.sectionObjects.isEmpty {
                formBuilder.sectionObjects = []
            }
            
            if !formBuilder.tableSectionObjects.isEmpty {
                formBuilder.tableSectionObjects = []
            }
            
            //            if !formBuilder.formViewModel.items.isEmpty {
            //                formBuilder.formViewModel.items = []
            //            }
            
            if !formBuilder.formModelItems.isEmpty {
                formBuilder.formModelItems = []
            }
            
            if !formBuilder.tablesDictionary.isEmpty {
                formBuilder.tablesDictionary = [:]
            }
            if !formBuilder.formSectionDictionary.isEmpty {
                formBuilder.formSectionDictionary = [:]
            }
            
            if !formBuilder.tables.isEmpty {
                formBuilder.tables = []
            }
            if !formBuilder.targetComponents.value.isEmpty {
                formBuilder.targetComponents.accept([])
            }
            
            // Check if formBuilder.allRowsChildControls is not nil and not empty before removing all elements
            if !formBuilder.allRowsChildControls.isEmpty {
                formBuilder.allRowsChildControls.removeAll()
            }
        }
    }
    
    
    
    // MARK: - Funcstions
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    /// Handle UI
    func setupUI() {
        //        self.navigationController?.removeBackButtonTitle()
        //        self.navigationController?.navigationBar.tintColor = .black
        setupBackButton()
        if let _ = actionId {
            exitButtonContainerView.isHidden = false
            topColoredView.backgroundColor = .clear
            topColoredViewHeightConstraint.constant = 0
            topFormConstraint.constant = 0
            view.backgroundColor = .clear
            [view,bgBottomView].forEach {
                $0?.layer.cornerRadius = 16
                $0?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }else {
            exitButtonContainerView.isHidden = true
        }
        setupTableView()
    }
    
    
    
    /// Config listeners
    func config() {
        
        formBuilder.targetComponents.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        
        formBuilder.cascadingComponentsWithMultiParents.subscribe(onNext: {[weak self] (component) in
            guard let `self` = self else {return}
            guard let _ = component else {return}
            DispatchQueue.main.async {
                self.fetchCascadingOptionsListWithMultiParents(code: component?.keys.first?.values.first ?? "",
                                                               parameters: component?.values.first ?? [],
                                                               row: 0)
            }
        }).disposed(by: disposeBag)
        
        
        formBuilder.cascadingComponents.subscribe(onNext: {[weak self] (component) in
            guard let `self` = self else {return}
            guard let component = component else {return}
            let params = component.values.first?.values.first
            DispatchQueue.main.async {
                self.fetchCascadingOptionsList(code: component.values.first?.keys.first ?? "",
                                               parentValue: params,
                                               section: component.keys.first ?? 0,
                                               row: 0)
            }
        }).disposed(by: disposeBag)
        // un hash this if you want to preview success view from formViewController  #(summary)
        //        formBuilder.serviceSubmittedResponse.subscribe(onNext: { [unowned self]  (item) in
        //            if let item = item{
        //                self.cerqel_hideLoading()
        //                self.showSuccessResponse(item: item)
        //            }
        //        }).disposed(by: self.disposeBag)
    }
    
    
    /// Handle submit button state
    /// - Parameter enabled: should it to be enabled or not
    func handleSubmitButton(enabled: Bool) {
        print("button is \(enabled)")
        submitButton.isUserInteractionEnabled = enabled
        submitButton.backgroundColor = !enabled ? UIColor.init(hexCerqel: "#BDBDBD") : primaryMain
    }
    
    
    
    /// Present success popup
    /// - Parameter serviceId: current submitted service id
    private func showSuccessResponse(serviceId: String) {
//        let reqId = serviceId
//        let successData = successRequestData(service: self.formBuilder.form.title ?? "", title:  "Your request Submitted successfully".localized, description: "\("Please wait for a response from management Your request ID:#".localized)\(reqId)", isRequest: true)
//        SubmittedSuccessRequestBottomSheet.delegate = self
//        SubmittedSuccessRequestBottomSheet.navigateToRequests = { [weak self] isRequest,requestId in
//            guard let self = self else {return}
//            self.navigationController?.popViewController(animated: true)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                if isRequest {
//                    DFAuthManager.shared.isTasks = false
//                } else {
//                    DFAuthManager.shared.isTasks = true
//                }
//                DFAuthManager.shared.isPopUpFromFormBuilder?(requestId)
//            }
//        }
//        SubmittedSuccessRequestBottomSheet.open(presenter: self,data: successData, fromDetails: false)
    }
    
    
    /// Setting up table's cells
    func setupTableView() {
        let nibBundle = FormVC.self
        for tableView in tableViewsCollection {
            tableView.tableFooterView = UIView()
            tableView.register(ExpandedSectionHeader.nib(bundleForClass: nibBundle),
                                      forHeaderFooterViewReuseIdentifier:  ExpandedSectionHeader.cerqel_identifier)
            tableView.register(LabelSheetWithSwitchTVCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier)
            tableView.register(NewTextBoxTVCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewTextBoxTVCell.cerqel_identifier)
            tableView.register(NewTextAreaTVcell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewTextAreaTVcell.cerqel_identifier)
            tableView.register(SectionTableViewCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: SectionTableViewCell.cerqel_identifier)
            tableView.register(EmptyTVcell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
            tableView.register(NewDatePickerTVCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewDatePickerTVCell.cerqel_identifier)
            tableView.register(NewLinkControlTVcell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewLinkControlTVcell.cerqel_identifier)
            tableView.register(NewInfoIndicatorTVcell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewInfoIndicatorTVcell.cerqel_identifier)
            tableView.register(NewTableControlTVCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewTableControlTVCell.cerqel_identifier)
            tableView.register(NewDropDownTVCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewDropDownTVCell.cerqel_identifier)
            tableView.register(NewCheckBoxTVCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewCheckBoxTVCell.cerqel_identifier)
            tableView.register(NewUploadMediaTVcell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewUploadMediaTVcell.cerqel_identifier)
            tableView.register(NewSwitchCell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewSwitchCell.cerqel_identifier)
            tableView.register(NewLblTVcell.nib(bundleForClass: nibBundle), forCellReuseIdentifier: NewLblTVcell.cerqel_identifier)
        }
    }
    
    
    
    /// Select option from DDL
    /// - Parameters:
    ///   - options: DDL options
    ///   - title: DDL title
    ///   - selectedValues: DDL selected options
    ///   - multiSelect: is it multiSelect or not
    ///   - section: current section number
    ///   - row: current row number
    func selectOption(options: [MCQOption], title: String?, selectedValues: [MCQOption], multiSelect: Bool, section: Int, row: Int) {
        let dropDownVC = DynamicSharedRouter.goTo(viewName: .newFormBuilderDropDown) as! NewDropDownViewController
        var height = (options.count * 50) + 70 + 80 + 20
        if height > Int(self.view.frame.size.height / 2) {
            height = Int(self.view.frame.size.height / 2)
        }
        let popupVC = PopupViewController(contentController: dropDownVC, position: .bottom(0), popupWidth: self.view.frame.width, popupHeight: CGFloat(height))
        dropDownVC.questionTitle = title ?? ""
        dropDownVC.allOptions = options
        dropDownVC.selectedValues = selectedValues
        dropDownVC.representation = multiSelect ? .CheckBox : .Radio
        dropDownVC.multiSelect = multiSelect
        
        popupVC.delegate = self
        
        popupVC.backgroundAlpha = 0.5
        popupVC.cornerRadius = 8
        
        
        // user selected options
        dropDownVC.selectOption = { [weak self] options, otherVal in
            
            self?.dismiss(animated: false,completion: {
                let val = BaseAnswerMCQ(val: options, otherAnswer: otherVal)
                self?.fieldValueChangedAt(section, row: row, value: val)
                if let item = self?.formBuilder.sectionObjects[section].items[row] as? FormViewModelDropdownItem {
                    if let properties = item.field?.properties as? DropdownProperties {
                        let result = self?.formBuilder.handleDropDownError(optionsCount: (val.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: item , row: item.fieldId)
                        self?.fieldValidationChangedAt(section, row: row, isValid: !(result?.isError ?? false))
                    }
                }
            })
            
        }
        
        // bottom sheet dismissed
        dropDownVC.dismiss = {
            self.dismiss(animated: false,completion: {
                
            })
        }
        
        self.present(popupVC, animated:true)
        
    }
    
    
    /// Select option from Search
    /// - Parameters:
    ///   - code: payload id
    ///   - options: search options
    ///   - title: search control's title
    ///   - placeHolder: search bar placeHolder
    ///   - selectedValues: search control selected options
    ///   - multiSelect: is it multiSelect or not
    ///   - section: current section
    ///   - row: current row
    func selectOptionFromSearch(code: String,options: [MCQOption], title: String?,placeHolder: String?, selectedValues: [MCQOption], multiSelect: Bool, section: Int, row: Int) {
        let dropDownVC = DynamicSharedRouter.goTo(viewName: .newFormBuilderSearch(code: code)) as! NewSearchVC
        
        let height = Int(self.view.frame.size.height * 0.75)
        let popupVC = PopupViewController(contentController: dropDownVC, position: .bottom(0), popupWidth: self.view.frame.width, popupHeight: CGFloat(height))
        popupVC.canTapOutsideToDismiss = false
        dropDownVC.questionTitle = title ?? ""
        dropDownVC.searchBarPlaceHolder = placeHolder ?? ""
        dropDownVC.allOptions.accept(options)
        dropDownVC.localSearch = !options.isEmpty
        dropDownVC.selectedValues = selectedValues
        dropDownVC.representation = multiSelect ? .CheckBox : .Radio
        dropDownVC.multiSelect = multiSelect
        
        popupVC.delegate = self
        
        popupVC.backgroundAlpha = 0.5
        popupVC.cornerRadius = 8
        
        // user typed a word more than 3 chars
        dropDownVC.getSearchUrl = {[weak self] (code,keyword) in
            guard let `self` = self else {return}
            self.fetchSearchOptions(code: code,
                                    keyword: keyword,
                                    params: self.formBuilder.searchComponents.value?.values.first,
                                    section: section,
                                    row: row) { [weak self] opts in
                guard let _ = self else {return}
                dropDownVC.allOptions.accept(opts)
            }
        }
        
        // user selected options
        dropDownVC.selectOption = { [weak self] options, otherVal in
            guard let `self` = self else {return}
            self.dismiss(animated: false,completion: {[weak self] in
                guard let `self` = self else {return}
                let val = BaseAnswerMCQ(val: options, otherAnswer: otherVal)
                self.fieldValueChangedAt(section, row: row, value: val)
                if let item = self.formBuilder.sectionObjects[section].items[row] as? FormViewModelDropdownItem {
                    if let properties = item.field?.properties as? DropdownProperties {
                        let result = self.formBuilder.handleDropDownError(optionsCount: (val.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: item , row: item.fieldId)
                        self.fieldValidationChangedAt(section, row: row, isValid: !(result.isError ))
                    }
                }
            })
            
        }
        
        // user dismissed the search bottom sheet
        dropDownVC.dismiss = { [weak self] options, otherVal in
            guard let `self` = self else {return}
            self.dismiss(animated: false,completion: {[weak self] in
                //                guard let `self` = self else {return}
                //                let val = BaseAnswerMCQ(val: options, otherAnswer: otherVal)
                //                self.fieldValueChangedAt(section, row: row, value: val)
                //                if let item = self.formBuilder.sectionObjects[section].items[row] as? FormViewModelDropdownItem {
                //                    if let properties = item.field?.properties as? DropdownProperties {
                //                        let result = self.formBuilder.handleDropDownError(optionsCount: (val.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: item , row: item.fieldId)
                //                        self.fieldValidationChangedAt(section, row: row, isValid: !(result.isError ))
                //                    }
                //                }
            })
            
        }
        
        
        self.present(popupVC, animated:true)
        
    }
    
    
    /// Fetch search results
    /// - Parameters:
    ///   - code: payload id
    ///   - keyword: user's searched keyword
    ///   - params: [key from payload : value from payload]
    ///   - section: current section number
    ///   - row: current row number
    ///   - completion: returned results to be control's options
    func fetchSearchOptions(code: String,keyword: String, params: [String:String]?, section: Int, row: Int, completion: @escaping (([MCQOption]) ->Void)) {
        cerqel_HUD.showHUD()
        let targetComps = getTargetComponents(for: code, row: row)
        let timeout: TimeInterval = 4.0 // Adjust the timeout duration as needed
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            self?.cerqel_HUD.stopHUD()
        }
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: cerqel_BasicAction.fetchSearchOptions(code: code,
                                                                                                                                                   keyword: keyword,
                                                                                                                                                   parameters: params, targetComponents: targetComps))).subscribe(onNext: {
            [weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            let item = self.formBuilder.sectionObjects[section].items[row]
                            if let dropDownItem = item as? FormViewModelDropdownItem {
                                var opts = [MCQOption]()
                                guard !values.isEmpty else {
                                    dropDownItem.options = []
                                    self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                    self.saveChanges(section: section, row: row)
                                    completion([])
                                    return
                                }
                                for val in values {
                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                    opts.append(object)
                                    dropDownItem.options = opts
                                    self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                    self.saveChanges(section: section, row: row)
                                    completion(opts)
                                }
                            }
                        }
                    }
                }
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            completion([])
        }).disposed(by: self.disposeBag)
    }
    
    func routerToSurvey() {
//        router.presentbottomSheet(controller: FeedbackBottomSheetView.self, viewModel: FeedbackViewModel.self, item: SurveyItem(dismissPage,serviceId: "", requestOrder: ""))
    }
    
    func dismissPage(){
        self.dismiss(animated: true)
        popToAllServices()
    }
    
    func popToAllServices() {
//        router.popToViewController(ofClass: AllServicesViewController.self, animated: true)
    }
    
    /// Fetch options for cascading rule with multi parents
    /// - Parameters:
    ///   - code: id from rule's payload
    ///   - parameters: [[key from payload : value from payload]]
    ///   - section: current section number
    ///   - row: current row number
    func fetchCascadingOptionsListWithMultiParents(code:String, parameters:[[String:String]], row: Int) {
        cerqel_HUD.showHUD()
        let targetComps =  getTargetComponents(for: code, row: row)
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: cerqel_BasicAction.fetchCascadingOptionsWithMultiParents(code: code, parameters: parameters, targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            var sectionIndex = 0
            var isFromTable = false
            var isCascadeInsideTable = false
            //            var formSectionObjects = self.formBuilder.sectionObjects
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            if component.rowIndex != nil {
                                // if its row you need to return components with rowIndex
                                // else you need to return components with null rowIndex
                                if components.count >= formBuilder.tableSectionObjects.count {
                                    isFromTable = true
                                    isCascadeInsideTable = false
                                }else {
                                    isCascadeInsideTable = true
                                }
                                sectionIndex = self.formBuilder.tableSectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                self.updateFieldsValues(sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
                            } else if component.parentId != nil && component.rowIndex == nil {

                                isCascadeInsideTable = true
                                isFromTable = false

                                sectionIndex = self.formBuilder.tableSectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                self.updateFieldsValues(sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
                            }
                            else {
                                guard let sectionIndex = self.formBuilder.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) else {return}
                                guard row < self.formBuilder.sectionObjects[sectionIndex].items.count else {return}
                                let item = self.formBuilder.sectionObjects[sectionIndex].items[row]
                                if let dropDownItem = item as? FormViewModelDropdownItem {
                                    let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
                                    let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
                                    if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                        dropDownItem.answer = nil
                                    }
                                    var opts = [MCQOption]()
                                    guard !values.isEmpty else {
                                        dropDownItem.options = []
                                        if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                            self.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(section: sectionIndex, row: row)
                                        return
                                    }
                                    for val in values {
                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                        opts.append(object)
                                    }
                                    if data.cascadeTargetType == 0 { //options
                                        dropDownItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                            self.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(section: sectionIndex, row: row)
                                    } else if data.cascadeTargetType == 1 { //value
                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                        dropDownItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                            self.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(section: sectionIndex, row: row)
                                    }else {
                                        dropDownItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                            self.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(section: sectionIndex, row: row)
                                    }
                                }else if let dateItem = item as? FormViewModelDateItem {
                                    var sortedValues = [String]()
                                    for val in values {
                                        if let key = val.key, key.lowercased() == "from" { // dateRange
                                            sortedValues.insert(val.name ?? "", at: 0)
                                        }else if let key = val.key, key.lowercased() == "to" { // dateRange
                                            sortedValues.insert(val.name ?? "", at: 1)
                                        }else {
                                            sortedValues = values.map({$0.name ?? ""}) // date/time/datetime (not range)
                                        }
                                        
                                    }
                                    let ans = DateTimeAnswer(val: sortedValues/*values.map({$0.name ?? ""})*/,
                                                             timeValues: sortedValues/*values.map({$0.name ?? ""})*/,
                                                             lNote: nil,
                                                             lAttachments: nil,
                                                             type: .Gregorian)
                                    dateItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                        self.formBuilder.sectionObjects[sectionIndex].items[row] = dateItem
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(section: sectionIndex, row: row)
                                }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                    let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                    paragraphItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                        self.formBuilder.sectionObjects[sectionIndex].items[row] = paragraphItem
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(section: sectionIndex, row: row)
                                }else if let numericItem = item as? FormViewModelNumericItem {
                                    let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                    numericItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                        self.formBuilder.sectionObjects[sectionIndex].items[row] = numericItem
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(section: sectionIndex, row: row)
                                }else if let textItem = item as? FormViewModelTextBoxItem {
                                    let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                    textItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                        self.formBuilder.sectionObjects[sectionIndex].items[row] = textItem
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(section: sectionIndex, row: row)
                                }else if let switchItem = item as? FormViewModelSwitchItem {
                                    let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                                           lNote: nil,
                                                           lAttachments: nil)
                                    switchItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < self.formBuilder.sectionObjects.count {
                                        self.formBuilder.sectionObjects[sectionIndex].items[row] = switchItem
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.fieldValidationChangedWhenMultiCascade(formSectionObjects: &self.formBuilder.sectionObjects)
                                    self.saveChanges(section: sectionIndex, row: row)
                                }
                            }
                        }
                    }
                    if isCascadeInsideTable {
                        for (tableSectionIndex, tableSectionObject) in self.formBuilder.tableSectionObjects.enumerated() {
                            for (_, tableItem) in tableSectionObject.items.enumerated() {
                                // Check the fieldId and update
                                for sectionIndex in formBuilder.sectionObjects.indices {
                                    // Get the section object
                                    var section = formBuilder.sectionObjects[sectionIndex]
                                    
                                    // Check the first item in the section
                                    if let sectionItem = (section.items[0] as? FormViewModelTableItem) {
                                        // Check if the sectionItem's fieldId matches the tableItem's parentId
                                        if sectionItem.fieldId == tableItem.parentId {
                                            for (childControlIndex, childControl) in sectionItem.childControls.enumerated() {
                                                // If the childControl's fieldId matches the tableItem's fieldId, update it
                                                if childControl.fieldId == tableItem.fieldId {
                                                    // Update the childControl with tableItem
                                                    sectionItem.childControls[childControlIndex] = tableItem
                                                    
                                                    // Update the section in formBuilder.sectionObjects
                                                    formBuilder.sectionObjects[sectionIndex].items[0] = sectionItem
                                                    
                                                    // Trigger reload or any necessary update logic
                                                    // Your update/reload logic here
                                                    
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    if isFromTable {
                        // Create a dictionary to hold grouped items based on rowIndex
                        var groupedItems: [String: [FormViewModelItem]] = [:]
                        // Iterate through tableSectionObjects to populate the groupedItems dictionary
                        for sectionObject in self.formBuilder.tableSectionObjects {
                            for var item in sectionObject.items {
                                if let rowIndex = item.rowIndex {
                                    // Find the index of the existing item based on specific properties
                                    if let existingIndex = self.formBuilder.allRowsChildControls.firstIndex(where: { existingItem in
                                        return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
                                    }) {
                                        // Replace the existing item with the new one
                                        self.formBuilder.allRowsChildControls[existingIndex] = FormViewModelItemStruct(from: item)
                                    } else {
                                        // If the item doesn't exist, append it to allRowsChildControls
                                        self.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
                                    }
                                    self.formBuilder.handleItemRules(&item)
                                    // Handle groupedItems
                                    if groupedItems[rowIndex] == nil {
                                        groupedItems[rowIndex] = [item]
                                    } else {
                                        groupedItems[rowIndex]?.append(item)
                                    }
                                }
                            }
                        }
                        rowIndices = formBuilder.allRowsChildControls
                           .compactMap { Int($0.rowIndex ?? "0") }
                           .sorted()
                        let tables: [FormViewModelItem] = formBuilder.formModelItems.filter({$0.type == .Table})
                        // Convert keys to integers and sort the dictionary
                        let sortedItems = groupedItems.sorted { (entry1, entry2) in
                            guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
                                return false // Handle non-integer keys
                            }
                            return num1 < num2
                        }
                        var tableId = ""
                        for groupItem in sortedItems {
                            for formItem in groupItem.value {
                                tableId = formItem.parentId ?? ""
                            }
                        }

                        // Now sortedGroupedItems contains the sorted dictionary

                        for table in tables {
                            if let item = table as? FormViewModelTableItem, item.fieldId == tableId  {
                                for groupItem in sortedItems {
                                    // Custom check to determine if groupItem.value exists in item.items
                                    var exists = false
                                    for existingItems in item.items {
                                        if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
                                            existingItems[0].answer = groupItem.value[0].answer
                                            exists = true
                                            break
                                        }
                                    }
                                    // If groupItem.value doesn't exist, append it to item.items
                                    if !exists {
                                        item.items.append(groupItem.value)
                                        item.cascadingComponent = nil
                                    }
                                }
                            }
                        }
                        
                        formBuilder.reloadAt = { [unowned self] (section, _) in
                            DispatchQueue.main.async {
                                if section < self.formBuilder.sectionObjects.count {
                                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//                                    self.handleRequiredItems(section: section)
                                } else {
                                    print("Attempt to reload a non-existent section")
                                }
                            }
                        }
                        
                        self.formTableView.reloadData()
                    }
                }
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
    }

    func updateFieldsValues(sectionIndex: Int, row: Int, values: [SearchValues], component: ComponentsModel,isTableFields: Bool) {
        guard sectionIndex <  self.formBuilder.tableSectionObjects.count else {
            return
        }
        guard row <  self.formBuilder.tableSectionObjects[sectionIndex].items.count else {return}
        let item =  self.formBuilder.tableSectionObjects[sectionIndex].items[row]
        if let dropDownItem = item as? FormViewModelDropdownItem {
            let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
            let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
            if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                dropDownItem.answer = nil
            }
            var opts = [MCQOption]()
            guard !values.isEmpty else {
                dropDownItem.options = []
                self.formBuilder.tableSectionObjects[sectionIndex].items[row] = dropDownItem
                if !isTableFields {
                    self.saveChanges(section: sectionIndex, row: row)
                }
                return
            }
            for val in values {
                let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                opts.append(object)
            }
            dropDownItem.options = opts
            if dropDownItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = dropDownItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dropDownItem.rowIndex != component.rowIndex &&  dropDownItem.rowIndex != nil{
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelDropdownItem(field: dropDownItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.options = opts
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let dateItem = item as? FormViewModelDateItem {
            var sortedValues = [String]()
            for val in values {
                if let key = val.key, key.lowercased() == "from" { // dateRange
                    sortedValues.insert(val.name ?? "", at: 0)
                }else if let key = val.key, key.lowercased() == "to" { // dateRange
                    sortedValues.insert(val.name ?? "", at: 1)
                }else {
                    sortedValues = values.map({$0.name ?? ""}) // date/time/datetime (not range)
                }
                
            }
            let ans = DateTimeAnswer(val: sortedValues/*values.map({$0.name ?? ""})*/,
                                     timeValues: sortedValues/*values.map({$0.name ?? ""})*/,
                                     lNote: nil,
                                     lAttachments: nil,
                                     type: .Gregorian)
            dateItem.answer = ans
            if dateItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = dateItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dateItem.rowIndex != component.rowIndex && dateItem.rowIndex != nil {
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelDateItem(field: dateItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let paragraphItem = item as? FormViewModelParagraphItem {
            let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
            paragraphItem.answer = ans
            if paragraphItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = paragraphItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if paragraphItem.rowIndex != component.rowIndex && paragraphItem.rowIndex != nil {
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelParagraphItem(field: paragraphItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
                
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let numericItem = item as? FormViewModelNumericItem {
            let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
            numericItem.answer = ans
            if numericItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = numericItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if numericItem.rowIndex != component.rowIndex  && numericItem.rowIndex != nil{
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelNumericItem(field: numericItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
                
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let textItem = item as? FormViewModelTextBoxItem {
            let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
            textItem.answer = ans
            if textItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = textItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if textItem.rowIndex != component.rowIndex && textItem.rowIndex != nil{
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelTextBoxItem(field: textItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let switchItem = item as? FormViewModelSwitchItem {
            let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                   lNote: nil,
                                   lAttachments: nil)
            switchItem.answer = ans
            if switchItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = switchItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if switchItem.rowIndex != component.rowIndex && switchItem.rowIndex != nil {
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelSwitchItem(field: switchItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getTargetComponents(for code: String, row: Int) -> [[String: String?]] {
        var targetComponents = [[String: String?]]()
        var uniqueIds = Set<String>() // To keep track of unique ids
        
        // Iterate through all target components
        for targetComponent in formBuilder.targetComponents.value {
            if targetComponent["code"] as? String == code {
                let id = targetComponent["id"] as? String ?? ""
                
                // Check if the id is unique before adding to targetComponents
                if !uniqueIds.contains(id) {
                    uniqueIds.insert(id) // Mark the id as added
                    
                    if let _ = targetComponent["parentId"] as? String {
                        let component: [String: String?] = [
                            "id": id,
                            "name": targetComponent["name"] as? String ?? "",
                            "type": targetComponent["type"] as? String ?? "",
                            "parentId": targetComponent["parentId"] as? String ?? "",
                            "rowIndex": targetComponent["rowIndex"] as? String ?? ""
                        ]
                        //                        if row != 0 {
                        targetComponents.append(component)
                        //                        }
                    } else {
                        let component: [String: String?] = [
                            "id": id,
                            "name": targetComponent["name"] as? String ?? "",
                            "type": targetComponent["type"] as? String ?? ""
                        ]
                        targetComponents.append(component)
                    }
                }
            }
        }
        
        // If no matching components found, print a message
        if targetComponents.isEmpty {
            print("No matching component found for code: \(code)")
        }
        
        return targetComponents
    }
    /// Fetch options for cascading rule
    /// - Parameters:
    ///   - code: id from rule's payload
    ///   - parentValue: [key from payload : value from payload]
    ///   - section: current section number
    ///   - row: current row number
    func fetchCascadingOptionsList(code: String,parentValue: [String:String]?, section: Int, row: Int) {
        cerqel_HUD.showHUD()
        let targetComps =  getTargetComponents(for: code, row: row)
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: cerqel_BasicAction.fetchCascadingOptions(code: code, parentValue: parentValue ?? [:], targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        
                        if let values = component.values {
                            guard self.formBuilder.sectionObjects.count > section else {return}
                            let items = self.formBuilder.sectionObjects[section].items
                            guard items.count > row else {return}
                            let item = items[row]
                            if let dropDownItem = item as? FormViewModelDropdownItem {
                                let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
                                let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
                                if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                    dropDownItem.answer = nil
                                }
                                var opts = [MCQOption]()
                                guard !values.isEmpty else {
                                    dropDownItem.options = []
                                    self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                    self.saveChanges(section: section, row: row)
                                    return
                                }
                                for val in values {
                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                    opts.append(object)
                                    dropDownItem.options = opts
                                    self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                    self.saveChanges(section: section, row: row)
                                }
                            }
                            if let paragraphItem = item as? FormViewModelParagraphItem { // Nov 5
                                let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                paragraphItem.answer = ans
                                self.formBuilder.sectionObjects[section].items[row] = paragraphItem
                                self.saveChanges(section: section, row: row)
                            }
                        }
                    }
                }
                
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
    }
    
    
    /// Fetching options list
    /// - Parameters:
    ///   - code: contro's data source id
    ///   - section: current section number
    ///   - row: current row number
    func fetchOptionsList(code: String, section: Int, row: Int, isLoadCell: Bool = false, completion: (([MCQOption]) -> Void)? = nil) {
        if !isLoadCell {
            DispatchQueue.main.async {
                self.cerqel_HUD.showHUD()
            }
        }
        
        let timeout: TimeInterval = 30.0
        var disposable: Disposable?
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let timeoutWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.cerqel_HUD.stopHUD()
                    // disposable?.dispose()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
            
            disposable = cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: cerqel_BasicAction.fetchDDLOptions(code: code, targetComponents: self.formBuilder.targetComponents.value)))
                .subscribe(onNext: { [weak self] (response) in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        timeoutWorkItem.cancel() // Cancel the timeout work item
                        self.cerqel_HUD.stopHUD()
                        
                        if let data = response.item?.data {
                            if let components = data.components {
                                for component in components {
                                    if let values = component.values, !values.isEmpty, section >= 0, section < self.formBuilder.sectionObjects.count {
                                        let item = self.formBuilder.sectionObjects[section].items[row]
                                        var opts = [MCQOption]()
                                        
                                        if let dropDownItem = item as? FormViewModelDropdownItem {
                                            guard !values.isEmpty else {
                                                if data.cascadeTargetType == 0 { //options
                                                    dropDownItem.options = []
                                                } else if data.cascadeTargetType == 1 { //value
                                                    dropDownItem.answer = nil
                                                }else {
                                                    dropDownItem.options = []
                                                }
                                                self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                                self.saveChanges(section: section, row: row)
                                                return
                                            }
                                            
                                            if data.cascadeTargetType == 0 { //options
                                                for val in values {
                                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                                    opts.append(object)
                                                }
                                                dropDownItem.options = opts
                                                self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                                self.saveChanges(section: section, row: row)
                                                completion?(opts)
                                            } else if data.cascadeTargetType == 1 { //value
                                                for val in values {
                                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                                    opts.append(object)
                                                }
                                                let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                                self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                                self.saveChanges(section: section, row: row)
                                                completion?(opts)
                                            }else { //options
                                                for val in values {
                                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                                    opts.append(object)
                                                }
                                                dropDownItem.options = opts
                                                self.formBuilder.sectionObjects[section].items[row] = dropDownItem
                                                self.saveChanges(section: section, row: row)
                                                completion?(opts)
                                            }
                                            
                                            if opts.isEmpty {
                                                dropDownItem.isCascadeValuesEmpty = true
                                            } else {
                                                dropDownItem.isCascadeValuesEmpty = false
                                            }
                                            // Call completion when changes are saved
                                        } else if let paragraphItem = item as? FormViewModelParagraphItem {
                                            let ans = ParagraphAnswer(val: "false", htmlValue: values.map({ $0.name ?? "" }).first, lNote: nil, lAttachments: nil)
                                            paragraphItem.answer = ans
                                            self.formBuilder.sectionObjects[section].items[row] = paragraphItem
                                            self.saveChanges(reload: false, section: section, row: row)
                                        }else if let numericItem = item as? FormViewModelNumericItem {
                                            let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                            numericItem.answer = ans
                                            numericItem.isError = false
                                            self.formBuilder.sectionObjects[section].items[row] = numericItem
                                            self.saveChanges(section: section, row: row)
                                        }else if let textItem = item as? FormViewModelTextBoxItem {
                                            let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                            textItem.answer = ans
                                            textItem.isError = false
                                            self.formBuilder.sectionObjects[section].items[row] = textItem
                                            self.saveChanges(section: section, row: row)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }, onError: { [weak self] (error) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.cerqel_HUD.stopHUD()
                    }
                })
            
            self.disposeBag.insert(disposable!)
        }
    }
    
    /// Getting DynamicActions Form
    /// - Parameter id: current action id to be rendered
    func getActionsFormData(id: String) {
        self.cerqel_showLoading()
        Services.shared.getActionForm(actionId: id)  {[weak self] serviceName , responseJSON , errorMsg in
            guard let `self` = self else {return}
            self.formBuilder.serviceName = serviceName
            guard let responseJSON = responseJSON else {
                self.cerqel_hideLoading()
                DispatchQueue.main.async {
                    self.emptyState.isHidden = false
                    self.formStackView.isHidden = true
                    self.emptyErrorLbl.text = errorMsg
                }
                return
            }
            self.formBuilder.handleFormJSON(responseJSON) {[weak self] success in
                guard let `self` = self else {return}
                if !success {
                    DispatchQueue.main.async {
                        self.emptyState.isHidden = false
                        self.formStackView.isHidden = true
                        self.emptyErrorLbl.text = errorMsg
                    }
                    self.cerqel_hideLoading()
                    return
                }
                self.cerqel_hideLoading()
                DispatchQueue.main.async {
                    self.emptyState.isHidden = true
                    self.formStackView.isHidden = false
                }
                self.formBuilder.populateFormData(isEdit: isEditable)
                //                if let formName = self.formBuilder.form.serviceName {
                DispatchQueue.main.async {
                    self.navigationItem.title = self.formBuilder.serviceName ?? self.formBuilder.form.title
                }
                DispatchQueue.main.async {
                    self.formBuilder.handlePageData()
                    self.formBuilder.handleTableControlChildren()
                    self.activeTableView = self.formTableView
                    self.activeTableView.reloadData()
                    self.ValidationSectionArray = self.formBuilder.sectionObjects
                }
                
                
                
            }
        }
        formBuilder.reloadAt = { [unowned self] (section, _) in
            DispatchQueue.main.async {
                if section < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//                    self.handleRequiredItems(section: section)
                } else {
                    print("Attempt to reload a non-existent section")
                }
            }
        }
    }
    
    func getForm(schema: JSON2) {
        
        self.formBuilder.handleFormJSON(schema) {[weak self] success in
            guard let `self` = self else {return}
            if !success {
                DispatchQueue.main.async {
                    self.emptyState.isHidden = false
                    self.formStackView.isHidden = true
                    self.emptyErrorLbl.text = "Error"
                }
                self.cerqel_hideLoading()
                return
            }
            self.cerqel_hideLoading()
            DispatchQueue.main.async {
                self.emptyState.isHidden = true
                self.formStackView.isHidden = false
            }
            self.formBuilder.populateFormData(isEdit: isEditable)
            //                if let formName = self.formBuilder.form.serviceName {
            DispatchQueue.main.async {
                self.navigationItem.title = self.formBuilder.serviceName ?? self.formBuilder.form.title
            }
            DispatchQueue.main.async {
                self.formBuilder.handlePageData()
                self.formBuilder.handleTableControlChildren()
                self.activeTableView = self.formTableView
                self.activeTableView.reloadData()
                self.ValidationSectionArray = self.formBuilder.sectionObjects
                self.fieldValidationChangedWhenEditRequest()
            }
            
            
            
        }
        
        formBuilder.reloadAt = { [unowned self] (section, _) in
            DispatchQueue.main.async {
                if section < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//                    self.handleRequiredItems(section: section)
                } else {
                    print("Attempt to reload a non-existent section")
                }
            }
        }
        
    }
    
    /// Getting DynamicForm Fields
    /// - Parameter id: current service id to be rendered
    func getFormData(id: String, isEdit: Bool?, isApproverForm: Bool?) {
        self.cerqel_showLoading()
        Services.shared.getForm(serviceId: id, isEdit: isEdit ?? false, isApproverForm: isApproverForm ?? false)  {[weak self] serviceName , formViersionId, responseJSON , errorMsg in
            guard let `self` = self else {return}
            self.formBuilder.serviceName = serviceName
            self.formBuilder.formVersionId = formViersionId
            guard let responseJSON = responseJSON else {
                self.cerqel_hideLoading()
                DispatchQueue.main.async {
                    self.emptyState.isHidden = false
                    self.formStackView.isHidden = true
                    self.emptyErrorLbl.text = errorMsg
                }
                return
            }
            self.formBuilder.handleFormJSON(responseJSON) {[weak self] success in
                guard let `self` = self else {return}
                if !success {
                    DispatchQueue.main.async {
                        self.emptyState.isHidden = false
                        self.formStackView.isHidden = true
                        self.emptyErrorLbl.text = errorMsg
                    }
                    self.cerqel_hideLoading()
                    return
                }
                self.cerqel_hideLoading()
                DispatchQueue.main.async {
                    self.emptyState.isHidden = true
                    self.formStackView.isHidden = false
                }
                self.formBuilder.populateFormData(isEdit: isEditable)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.formBuilder.serviceName ?? self.formBuilder.form.title
                }
                DispatchQueue.main.async {
                    self.formBuilder.handlePageData()
                    self.formBuilder.handleTableControlChildren()
                    self.activeTableView = self.formTableView
                    self.activeTableView.reloadData()
                    self.ValidationSectionArray = self.formBuilder.sectionObjects
                    //                    if self.isEditable {
                    self.fieldValidationChangedWhenEditRequest()
                    //                    }
                }
            }
        }
        formBuilder.reloadAt = { [unowned self] (section, _) in
            DispatchQueue.main.async {
                if section < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//                    self.handleRequiredItems(section: section)
                } else {
                    print("Attempt to reload a non-existent section")
                }
            }
        }
    }
    
    func handleRequiredItems(section: Int) {
        let item = formBuilder.sectionObjects[section].items[0]
        var isRequired: Bool?
        
        isRequired = item.isRequired
        if item.answer == nil && (isRequired ?? false) {
            self.fieldValidationChangedAt(section, row: 0, isValid: false)
        } else {
            //            self.fieldValidationChangedAt(section, row: 0, isValid: true)
            
            if let properties = item.field?.properties as? FormViewModelTextBoxItem {
                isRequired = properties.required
            } else if let properties = item.field?.properties as? TextAreaProperties {
                isRequired = properties.required ?? false
            }else if let properties = item.field?.properties as? NumberProperties {
                isRequired = properties.required ?? false
            }else if let properties = item.field?.properties as? DateTimeProperties {
                isRequired = properties.required ?? false
            } else if let properties = item.field?.properties as? switchProperties {
                isRequired = properties.required ?? false
            } else if let properties = item.field?.properties as? CheckboxProperties {
                isRequired = properties.required ?? false
            } else if let properties = item.field?.properties as? RadioProperties {
                isRequired = properties.required ?? false
            } else if let properties = item.field?.properties as? DropdownProperties {
                isRequired = properties.required ?? false
            } else if let properties = item.field?.properties as? FileUploadProperties {
                isRequired = properties.required ?? false
            } else if let properties = item.field?.properties as? TableProperties {
                isRequired = properties.required ?? false
            }
            if item.answer == nil && (isRequired ?? false) {
                self.fieldValidationChangedAt(section, row: 0, isValid: false)
            }else{
                self.fieldValidationChangedAt(section, row: 0, isValid: true)
            }
        }
    }
    
    func getSectionTitle(item: FormViewModelItem?) -> String {
        var lbl = ""
        lbl = item?.label ?? ""
        if !isArabicCerqel() {
            if let localizedLabel = item?.localization?["en"]?.label, !localizedLabel.isEmpty {
                lbl = localizedLabel
            } else if let locLbl = item?.localization?["en"]?.sublabel, !locLbl.isEmpty {
                lbl = locLbl
            }
        } else {
            if let localizedLabel = item?.localization?["ar"]?.label, !localizedLabel.isEmpty {
                lbl = localizedLabel
            } else if let locLbl = item?.localization?["ar"]?.sublabel, !locLbl.isEmpty {
                lbl = locLbl
            }
        }
        return lbl
    }

    /// Getting current control
    /// - Parameter indexPath: control's indexPath
    /// - Returns: rendered control
    func getCurrentItem(indexPath: IndexPath) -> FormViewModelItem {
        var item: FormViewModelItem!
        if formBuilder.sectionObjects.count > indexPath.section {
            item = formBuilder.sectionObjects[indexPath.section].items[indexPath.row]
            return item
        }
        return FormViewModelItem(field: nil)
    }
    
    //    func checkIfAllFieldsHidden (indexPath: IndexPath) -> Bool {
    //          let allFields = formBuilder.sectionObjects[indexPath.section].items
    //        if allFields.count > 0 {
    //            for item in allFields {
    //                if(item.disabled == false){
    //                    return false
    //                }
    //            }
    //            return true
    //        }
    //        return false
    //    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func submitBtnTapped(){
        cerqel_HUD.showHUD()
        // make formBuilder.createPayload as   formBuilder.createPayloadForSummaryPage when not use summary page within your project #(summary)
        formBuilder.createPayload(actionId: actionId, fromSummary: false,isApproverForm: isApproverForm,reqIdApprover: self.requestIdForApprover, sections: formBuilder.sectionObjects) {[weak self] payload in
            guard let `self` = self else {return}
            if let pload = payload {
                if pload.first?.keys.first == "error" {
                    self.showError(error: BaseError.other(title: pload.first?.values.first as? String ?? "error not found"))
                }else if let id = self.buttonId {
                    self.dismiss(animated: true) {
                        self.delegate?.handleActionPayload(actionId: id, payload: pload)
                    }
                }
            }
            self.cerqel_HUD.stopHUD()
        }
        // hash code here if you not want to navigate to request summary screen and submit from form view controller #(summary)
        formBuilder.goToSummary = true
        navigationController?.pushViewController(DynamicSharedRouter.goTo(viewName: .requestSummary(buttonId: self.buttonId ?? nil, actionId: self.buttonId ?? nil, isEditable: isEditable, isApproverForm: isApproverForm, requestIdForApprover: self.requestIdForApprover, view: self)), animated: true)
    }
    
    
    @IBAction func cancelBtnTapped(){
        if let _ = actionId {
            dismiss(animated: true,completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func exitBtnTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewmyRequestsbtnTapped(){
    }
    
    @IBAction func didTapSubserviceDropDown(){
        
    }
}


extension FormVC: Popup {
    func popup() {
        navigationController?.popViewController(animated: true)
    }
}

extension FormVC: NestedFormViewDelegate {
    
    func getSectionNumber(for tableItem: FormViewModelTableItem) -> Int? {
        return self.formBuilder.sectionObjects.firstIndex(where: { section in
            return section.items.contains(where: { item in
                if let itemTable = item as? FormViewModelTableItem {
                    return itemTable.fieldId == tableItem.fieldId
                }
                return false
            })
        })
    }
    
    
    /// Added row into table control Delegate Method
    /// - Parameters:
    ///   - tableID: current table id
    ///   - itemIndex: current row index
    ///   - children: table's children controls
    ///   - cascadingComponent: [itemIndex : [id from payload : [key from payload : value from payload]]
    func didTapAdd(tableID: String, itemIndex: Int, children: [FormViewModelItem], cascadingComponent: [Int:[String:[String:String]]]?,isEdit: Bool) {
        let tables: [FormViewModelItem] = formBuilder.formModelItems.filter({$0.type == .Table})
        var sectionIdx = 0
        for table in tables { // if case you have more than one table in the form
            if let item = table as? FormViewModelTableItem, item.fieldId == tableID {
                sectionIdx = getSectionNumber(for: item) ?? 0
                if isEdit {
                    item.items[itemIndex - 1] = children
                    item.cascadingComponent?[itemIndex - 1] = cascadingComponent
                } else {
                    item.items.append(children)
                    item.cascadingComponent?.append(cascadingComponent)
                }
                
                self.activeTableView.reloadData()
                
                formBuilder.reloadAt = { [unowned self] (section, _) in
                    DispatchQueue.main.async {
                        if section < self.formBuilder.sectionObjects.count {
                            self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//                            self.handleRequiredItems(section: section)
                        } else {
                            print("Attempt to reload a non-existent section")
                        }
                    }
                }
            }
        }
        if isEdit {
            self.formBuilder.handleItemRules(&self.formBuilder.sectionObjects[sectionIdx].items[0])
        }
    }
    
    
    /// User dismissed table's bottom sheet
    func didDismiss() {
        formBuilder.reloadAt = { [unowned self] (section, ans) in
            DispatchQueue.main.async {
                guard section < self.formBuilder.sectionObjects.count else {return}
                self.updateControlValue(section: section, ans: ans)
            }
        }
    }
    
    
    
    /// Updating control value after dismiss
    /// - Parameters:
    ///   - section: current section
    ///   - ans: current ans
    func updateControlValue(section: Int, ans: Any?) {
        guard section < formBuilder.sectionObjects.count else {return}
        guard !formBuilder.sectionObjects[section].items.isEmpty else {return}
        formBuilder.sectionObjects[section].items[0].answer = ans
        if section < self.formBuilder.sectionObjects.count {
            self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//            self.handleRequiredItems(section: section)
        } else {
            print("Attempt to reload a non-existent section")
        }
    }
    
    
}

extension FormVC: PopupViewControllerDelegate {
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController) {
    }
}

extension FormVC: PopViewControllerDelegate {
    func handlePopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension FormVC: UITableViewDataSource, UITableViewDelegate {
    fileprivate func validation(_ item: FormViewModelItem, _ section: Int, _ row: Int) {
        if let item = item as? FormViewModelFileUploadItem {
            if (!(item.attachmentsList.isEmpty)) && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            } else if (item.attachmentsList.isEmpty) && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: false)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return formBuilder.sectionObjects.count
    }
    
    // This function returns the number of rows in a given section of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the current section object from the formBuilder's sectionObjects array
        let currentSection = formBuilder.sectionObjects[section].item
        
        // Check if the current section type is .Section
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) {
            // If the section is collapsed, return 0 (no rows)
            // Otherwise, return the count of items in the section
            return (currentSection?.isCollapsedSection ?? false) ? 0 : formBuilder.sectionObjects[section].items.count
        } else {
            // If the current section type is not .Section, return 1 (single row)
            return 1
        }
    }
    // This function returns a view to be used as the header for a given section of the table view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Get the current section object from the formBuilder's sectionObjects array
        let currentSection = formBuilder.sectionObjects[section].item
        // Check if the current section type is .Section
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) {
            // Dequeue a reusable header view of type ExpandedSectionHeader
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandedSectionHeader.cerqel_identifier) as! ExpandedSectionHeader
            // Configure the header with the section title and expansion state
            header.configure(sectionTitle: self.getSectionTitle(item: currentSection), isExpanded: !(currentSection?.isCollapsedSection ?? false), isEditMode: true)

            // Define a closure to handle the collapsed state toggling
            header.collapsed = {
                self.toggleSection(section)
            }
            
            // Return the configured header view
            return header
        } else {
            // If the current section type is not .Section, return nil (no header view)
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = formBuilder.sectionObjects[section].item
        
        return (currentSection?.type == .Section && !(currentSection?.hidden ?? false)) ? 56.0 : 0.0 // Adjust as needed
    }
    
    private func toggleSection(_ section: Int) {
        formBuilder.sectionObjects[section].item?.isCollapsedSection?.toggle()
        formTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let sectionType =  formBuilder.sectionObjects[section].item
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
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
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
                    formBuilder.setSelfControlCascadingForSameControl(item: textBoxItem)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textBoxItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textBoxItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            self.fetchOptionsList(code: dataSource, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
               // Check and call the closure if needed
            if let dataSourceId = item.field?.properties?.dataSourcId, cell.textFieldValue.isEmpty {
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
            guard let item = item as? FormViewModelTextAreaItem else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextAreaTVcell.cerqel_identifier, for: indexPath) as! NewTextAreaTVcell
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
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
            cell.tag = section
            return cell
        case .Paragraph:
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
                    return cell
                }
                if subType == .Link {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLinkControlTVcell.cerqel_identifier, for: indexPath) as! NewLinkControlTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    return cell
                }
                if subType == .InfoIndcator {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewInfoIndicatorTVcell.cerqel_identifier, for: indexPath) as! NewInfoIndicatorTVcell
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
//                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    return cell
                }
                if subType == .LabelSheetWithToggle {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
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
                    
                    if cell.dataSourceId != "" && item.answer == nil  {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            formBuilder.setSelfControlCascadingForSameControl(item: item)
                            self.fetchOptionsList(code: cell.dataSourceId, section: section, row: row)
                        }
                    }
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        //                        let vc = CERQEL_Router.goTo(viewName: .labelBottomSheetVC(item: item))
                        //                        self.navigationController?.present(vc, animated: true)
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
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
                    return cell
                }
                if subType == .LabelSheetWithCheckBox {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheetWithCheckBox = true
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
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
                    
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            formBuilder.setSelfControlCascadingForSameControl(item: item)
                            self.fetchOptionsList(code: cell.dataSourceId, section: section, row: row)
                        }
                    }
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        //                        let vc = CERQEL_Router.goTo(viewName: .labelBottomSheetVC(item: item))
                        //                        self.navigationController?.present(vc, animated: true)
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
                    cell.isLabelSheet = true
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    if item.answer != nil && ((item.answer as? Bool) == true) && ((item.field?.properties as? ParagraphProperties)?.required ?? false) {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    if let required = (item.field?.properties as? ParagraphProperties)?.required, required == true {
                        self.fieldValidationChangedAt(section, row: row, isValid: false)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                    
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            formBuilder.setSelfControlCascadingForSameControl(item: item)
                            self.fetchOptionsList(code: cell.dataSourceId, section: section, row: row)
                        }
                    }
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        //                        let vc = CERQEL_Router.goTo(viewName: .labelBottomSheetVC(item: item))
                        //                        self.navigationController?.present(vc, animated: true)
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
            cell.valueChanged = { [unowned self] value, isError in
                if item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value, isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            if item.answer == nil &&  !((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            return cell
            
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewSwitchCell.cerqel_identifier, for: indexPath) as! NewSwitchCell
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.tag = section
            if item.answer != nil && ((item.answer as? SwitchAnswer)?.value == true) && ((item as? FormViewModelSwitchItem)?.required == true ) {
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
            cell.valueChangedCheckBox = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    self.fieldValueChangedAt(section, row: row, value: value,isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? CheckboxProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            return cell
        case .Radio:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.valueChangedRadio = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId{
                    self.fieldValueChangedAt(section, row: row, value: value,isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? RadioProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            return cell
        case .Dropdown:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDropDownTVCell.cerqel_identifier, for: indexPath) as! NewDropDownTVCell
            
            cell.dataSourceFetchingInDDL = {[weak self] dataSource in
                guard let `self` = self else {return}
                DispatchQueue.global(qos: .background).async {[weak self] in
                    guard let `self` = self else {return}
                    formBuilder.setSelfControlCascadingForSameControl(item: item)
                    self.fetchOptionsList(code: dataSource, section: section, row: row, isLoadCell: true)
                }
            }
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            if !((item.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) && ((item.field?.properties as? DropdownProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.dropDownPressed = { [weak self] options, title, placeHolder, selectedValues, multiSelect, ddlSubType in
                guard let `self` = self else {return}
                if ddlSubType == "Search" {
                    if !options.isEmpty {
                        
                        //                        self.fieldValueChangedAt(section, row: row, value: selectedValues, isError: !((item.field?.properties as? DropdownProperties)?.required ?? false))
                        self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                        self.selectOptionFromSearch(code: self.formBuilder.searchComponents.value?.keys.first ?? "" ,
                                                    options: options,
                                                    title: title,
                                                    placeHolder: placeHolder,
                                                    selectedValues: selectedValues,
                                                    multiSelect: multiSelect,
                                                    section: section,
                                                    row: row)
                    } else {
                        if let dropDownitem = item as? FormViewModelDropdownItem {
                            DispatchQueue.main.async {
                                self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                self.fetchOptionsList(code: dropDownitem.dataSourcId ?? "", section: section, row: row) { opts in
                                    self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                    self.selectOptionFromSearch(code: self.formBuilder.searchComponents.value?.keys.first ?? "" ,
                                                                options: opts,
                                                                title: title,
                                                                placeHolder: placeHolder,
                                                                selectedValues: selectedValues,
                                                                multiSelect: multiSelect,
                                                                section: section,
                                                                row: row)
                                }
                                
                            }
                        }
                    }
                }else {
                    guard !options.isEmpty else {
                        if let dropDownitem = item as? FormViewModelDropdownItem {
                            DispatchQueue.main.async {
                                self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                self.fetchOptionsList(code: dropDownitem.dataSourcId ?? "", section: section, row: row) { opts in
                                    self.selectOption(options: opts, title: title, selectedValues: selectedValues, multiSelect: multiSelect, section: section, row: row)
                                }
                            }
                        }
                        return}
                    self.selectOption(options: options, title: title, selectedValues: selectedValues, multiSelect: multiSelect, section: section, row: row)
                }
            }
            
            cell.validationChanged = { [unowned self] valid in
                if let _ = item as? FormViewModelDropdownItem {
                    formBuilder.sectionObjects[section].items[row].isError = !valid
                }
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
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            validation(item, section, row)
            self.maxAttachmentsSize = cell.maxAttachmentsSize
            if item.answer != nil && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.didTapAddAttachment = {[weak self] in
                guard let `self` = self else {return}
                self.formBuilder.fileUploadFieldID = item.fieldId
                self.formBuilder.fileUploadFieldRow = row
                self.formBuilder.fileUploadFieldSection = section
                if let arr = item as? FormViewModelFileUploadItem{
                    arr.syncPropertiesFromFileUploadProperties()
                    if arr.attachmentsList.count < arr.maxAttachmentsNumber ?? 0 || arr.maxAttachmentsNumber == nil  {
                        self.selectedMediaUploaderIdx = indexPath.row
                        self.openMFileMenu(attachmentExtensions: arr.attachmentExtensions)
                    }
                }
            }
            
            cell.didRemoveAttachment = { attachmentID in
                guard let item = item as? FormViewModelFileUploadItem else { return }
                guard let newAnswer = item.answer as? FileUploadAnswer else { return }
                let indexToDelete = item.attachmentsList.firstIndex(where: { $0.id == attachmentID })
                newAnswer.value?.remove(at: indexToDelete ?? 0)
                item.answer = newAnswer
                item.attachmentsList.remove(at: indexToDelete ?? 0)
                //                item.attachmentsList.removeAll(where: { $0.id == attachmentID })
//                self.fieldValueChangedAt(section, row: row, value: item.attachmentsList)
                tableView.reloadSections(IndexSet(integer: section), with: .none)
            }
            
            cell.validationChanged = { [unowned self] valid in
                if let item = item as? FormViewModelFileUploadItem, !item.required {
                    fieldValidationChangedAt(section, row: row, isValid: true)
                }else {
                    validation(item, section, row)
                }
            }
            return cell
            
        case .Table:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTableControlTVCell.cerqel_identifier, for: indexPath) as! NewTableControlTVCell
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            
            cell.isEditable = self.isEditable
            if let table = item as? FormViewModelTableItem {
                if table.items.count < table.minRows ?? 0 || table.items.count > table.maxRows ?? 0{
                    self.fieldValidationChangedAt(section, row: row, isValid: false)
                }else {
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                }
            }
            
            if let table = item as? FormViewModelTableItem {
                validateTableItems(table.items, in: cell, section: indexPath.section, row: indexPath.row)
            }
            
            cell.validationChanged = {[weak self] valid, updateRules in
                guard let `self` = self else {return}
//                if self.serviceId != "b99d5add-5995-4830-be24-f6b72af15ead" {
                    if updateRules {
                        self.formBuilder.handleItemRules(&self.formBuilder.sectionObjects[section].items[row])
                    }
//                }
                self.fieldValidationChangedAt(section, row: row, isValid: valid)
            }
            
            cell.didTapAdd = { completion in
                // Perform the "add" logic here.
                self.formBuilder.handleItemRules(&self.formBuilder.sectionObjects[section].items[row])
                completion()
            }
            
            cell.didDeleteTableItem = { [weak self] idx in
                guard let self = self else { return }
                
                // Iterate through each item and update rowIndex
                
                // Filter out the deleted item
                // Assuming idx is the index of the row to be deleted
                let deletedRowIndex = idx + 1
                
                if (rowIndices.isEmpty ?? false ){
                    rowIndices = formBuilder.allRowsChildControls
                        .compactMap { Int($0.rowIndex ?? "0") }
                        .sorted()
                }
                
                // Find the index of the deleted row
                var indexToRemove = rowIndices.firstIndex(of: deletedRowIndex)
                
                while let index = indexToRemove {
                    rowIndices.remove(at: index)
                    indexToRemove = rowIndices.firstIndex(of: deletedRowIndex)
                }
                
                var updatedRowIndices: [Int] = []
                
                for (index, rowIndex) in rowIndices.enumerated() {
                    if rowIndex > deletedRowIndex {
                        updatedRowIndices.append(rowIndex - 1)
                    } else {
                        updatedRowIndices.append(rowIndex)
                    }
                }
                
                // Assign the updatedRowIndices to rowIndices
                rowIndices = updatedRowIndices
                
                
                // Update the rowIndex for each item in allRowsChildControls
                for var item in formBuilder.allRowsChildControls {
                    if let rowIndexString = item.rowIndex, let oldIndex = Int(rowIndexString) {
                        if let newIndex = rowIndices.firstIndex(of: oldIndex + 1) {
                            item.rowIndex = String(rowIndices[newIndex])
                        }
                    }
                }
                if let tableComponent = item as? FormViewModelTableItem {
                    if !tableComponent.childControls.isEmpty {
                        for child in tableComponent.childControls {
                            child.answer = nil
                        }
                    }
                }
                let sortedArr = formBuilder.allRowsChildControls.sorted {
                    // Use optional chaining to safely unwrap and compare rowIndex values
                    let index1 = $0.rowIndex ?? ""
                    let index2 = $1.rowIndex ?? ""
                    return index1 < index2
                }
                formBuilder.allRowsChildControls = sortedArr
                if formBuilder.allRowsChildControls.count > rowIndices.count {
                    let excessItemCount = formBuilder.allRowsChildControls.count - rowIndices.count
                    formBuilder.allRowsChildControls = formBuilder.allRowsChildControls.filter { Int($0.rowIndex ?? "0") != (idx + 1) }
                    
                    for i in 0 ..< min(formBuilder.allRowsChildControls.count, rowIndices.count) {
                        let rowIndex = rowIndices[i] // Get the corresponding index from rowIndices
                        formBuilder.allRowsChildControls[i].rowIndex = "\(rowIndex)"
                    }
                    
                }
                
                if let table = item as? FormViewModelTableItem {
                    if table.items.count < table.minRows ?? 0 || table.items.count > table.maxRows ?? 0{
                        self.fieldValidationChangedAt(section, row: row, isValid: false)
                    }else {
                        self.fieldValidationChangedAt(section, row: row, isValid: true)
                    }
                }
                
//                tableView.reloadData()
                tableView.reloadSections(IndexSet(integer: section), with: .none)
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
        return UITableViewAutomaticDimension
    }
    
}

extension FormVC {
    
    
    /// Check validation of every control
    /// - Parameters:
    ///   - section: current section
    ///   - row: current row
    ///   - isValid: is current control valid or not
    
    func fieldValidationChangedAt(_ section: Int, row: Int, isValid: Bool) {
        guard section < formBuilder.sectionObjects.count else {
            // Section index is out of range
            return
        }
        guard row < formBuilder.sectionObjects[section].items.count else {
            // Row index is out of range
            return
        }
        
        formBuilder.sectionObjects[section].items[row].isError = !isValid
        formBuilder.sectionObjects[section].items[row].isValid = isValid
        var isDimmed = false
        for section in formBuilder.sectionObjects {
            for item in section.items {
                // Check if the item is required and its answer is nil
                var isRequired: Bool
                if let switchItem = item as? FormViewModelSwitchItem {
                    isRequired = switchItem.required
                    if (switchItem.answer as? SwitchAnswer)?.value == nil || (switchItem.answer as? SwitchAnswer)?.value == false {
                        item.answer = nil
                    }
                } else if let dropdownItem = item as? FormViewModelDropdownItem {
                    isRequired = dropdownItem.required
                    if (dropdownItem.answer as? BaseAnswerMCQ)?.value == nil || ((dropdownItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let checkboxItem = item as? FormViewModelCheckboxItem {
                    isRequired = checkboxItem.required
                    if (checkboxItem.answer as? BaseAnswerMCQ)?.value == nil || ((checkboxItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                }
//                else if let switchItem = item as? FormViewModelSwitchItem {
//                    isRequired = switchItem.required
//                    if (switchItem.answer as? SwitchAnswer)?.value == nil || ((switchItem.answer as? SwitchAnswer)?.value?.isEmpty ?? false) {
//                        item.answer = nil
//                    }
//                }
                else if let radioItem = item as? FormViewModelRadioItem {
                    isRequired = radioItem.required
                    if (radioItem.answer as? BaseAnswerMCQ)?.value == nil || ((radioItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let dateItem = item as? FormViewModelDateItem {
                    isRequired = dateItem.required
                    if (dateItem.answer as? DateTimeAnswer)?.value == nil && (dateItem.answer as? DateTimeAnswer)?.timeValues == nil || ((dateItem.answer as? DateTimeAnswer)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if item is FormViewModelParagraphItem {
                    isRequired = false // Assuming paragraph items are never required
                    if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle {
                        let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                        let answer = item.answer as? ParagraphAnswer
                        if answer?.value == "false" && !item.hidden && requiredItem == true {
                            isRequired = true
                        } else {
                            isRequired = false
                        }
                    }
                } else if let numericItem = item as? FormViewModelNumericItem {
                    if item.type == .Numerical {
                        isRequired = (numericItem.field?.properties as? NumberProperties)?.required ?? false
                        if (numericItem.answer.value as? BaseAnswerText) == nil || ((numericItem.answer as? BaseAnswerText)?.value?.isEmpty ?? false)  {
                            item.answer = nil
                        }
                    } else {
                        isRequired = (numericItem.field?.properties as? TextBoxProperties)?.required ?? false
                        if (numericItem.answer as? TextboxAnswer).value == nil || ((numericItem.answer as? TextboxAnswer)?.value?.isEmpty ?? false) {
                            item.answer = nil
                        }
                    }
                } else if let textBoxItem = item as? FormViewModelTextBoxItem {
                    isRequired = (textBoxItem.field?.properties as? TextBoxProperties)?.required ?? false
                    if (textBoxItem.answer as? TextboxAnswer).value == nil || ((textBoxItem.answer as? TextboxAnswer)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let fileUploadItem = item as? FormViewModelFileUploadItem {
                    isRequired = (fileUploadItem.field?.properties as? FileUploadProperties)?.required ?? false
                    if fileUploadItem.attachmentsList.isEmpty {
                        item.answer = nil
                    }
                }else if let textAreaItem = item as? FormViewModelTextAreaItem {
                    isRequired = textAreaItem.required
                    if (textAreaItem.answer as? TextAreaAnswer).value == nil || ((textAreaItem.answer as? BaseAnswerText)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                }else if let table = item as? FormViewModelTableItem {
                    if table.items.count < (table.minRows ?? 0) || table.items.count > (table.maxRows ?? 0){
                        item.answer = nil
                        isRequired = true
                    }else {
                        isRequired = false
                    }
                    
                    if table.isValid {
                        isRequired = false
                    }else {
                        isRequired = true
                    }
                }
                else {
                    isRequired = false
                }
                
                if let fileUploadItem = item as? FormViewModelFileUploadItem {
                    if isRequired && fileUploadItem.attachmentsList.isEmpty && !fileUploadItem.hidden && !fileUploadItem.disabled {
                        print("Attachments Required component without answer: \(item.label ?? "")")
                        isDimmed = true
                        break
                    }
                    
                }else {
                    if isRequired && item.answer == nil && !item.hidden && !item.disabled {
                        print("Required component without answer: \(item.label ?? "")")
                        isDimmed = true
                        break
                    } else if isRequired && item.isError && !item.hidden && !item.disabled {
                        print("Required component without answer: \(item.label ?? "")")
                        isDimmed = true
                        break
                    } else if item.answer != nil && item.isError && !item.hidden && !item.disabled {
                        print("Not valid component: \(item.label ?? "")")
                        isDimmed = true
                        break
                    }else if isRequired && item.answer.value == nil && !item.hidden && !item.disabled {
                        isDimmed = true
                        break
                    }else if isRequired && ((item.answer as? ParagraphAnswer)?.value.value == "false") && !item.hidden && !item.disabled {
                        isDimmed = true
                        break
                    }
                }
            }
            
            if isDimmed {
                break
            }
        }
        
        // handle submit button state
        handleSubmitButton(enabled: !isDimmed)
    }
    
    func formatDate(from dateString: String, dateFormatters: [DateFormatter]) -> String? {
        for dateFormatter in dateFormatters {
            if let date = dateFormatter.date(from: dateString) {
                return dateFormatter.string(from: date)
            }
        }
        return nil
    }
    
    func fieldValidationChangedWhenEditRequestForTableFields() {
        var isDimmed = false
        if !formBuilder.tableSectionObjects.isEmpty {
            
            for i in 0 ... formBuilder.tableSectionObjects.count - 1 {
                let sectionObject = formBuilder.tableSectionObjects[i]
                for item in sectionObject.items  {
                    if let switchItem = item as? FormViewModelSwitchItem {
                        let requiredItem = (item.field?.properties as? switchProperties)?.required
                        let defaultAnswer = (item.field?.properties as? switchProperties)?.defaultAnswer
                        self.fieldValueChangedAtTableFields(i, row: 0, value: defaultAnswer, isError: false, reload: false)
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if let checkBoxItem = item as? FormViewModelCheckboxItem {
                        let requiredItem = checkBoxItem.required
                        let defaultAnswer = checkBoxItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? []{
                            //                            if let selectedOption = checkBoxItem.options?.first(where: { $0.id == val }) {
                            // Set selectedValues to contain the matched option
                            selectedValues.append(val)
                            //                            }
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAtTableFields(i, row: 0, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if let dropDownItem = item as? FormViewModelDropdownItem {
                        let requiredItem = (item.field?.properties as? DropdownProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DropdownProperties)?.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? []{
                            //                            if let selectedOption = dropDownItem.options?.first(where: { $0.id == val }) {
                            // Set selectedValues to contain the matched option
                            selectedValues.append(val)
                            //                            }
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAtTableFields(i, row: 0, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if let radioItem = item as? FormViewModelRadioItem {
                        let requiredItem = radioItem.required
                        let defaultAnswer = radioItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? []{
                            //                            if let selectedOption = radioItem.options?.first(where: { $0.id == val }) {
                            // Set selectedValues to contain the matched option
                            selectedValues.append(val)
                            //                            }
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAtTableFields(i, row: 0, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    if let item = item as? FormViewModelDateItem {
                        if let defualtAnswer = item.defaultAnswer {
                            var sortedValues = [String]()
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                            for val in defualtAnswer.value ?? [] {
                                if let from = val.from, let to = val.to { // If it's a dateRange
                                    sortedValues.append(dateFormatter.string(from: from))
                                    sortedValues.append(dateFormatter.string(from: to))
                                } else {
                                    if let from = val.from { // If it's a date from
                                        sortedValues.append(dateFormatter.string(from: from))
                                    }
                                }
                            }
                            if !(sortedValues.isEmpty) {
                                let ans = DateTimeAnswer(val: sortedValues, // Assuming this is what you need
                                                         timeValues: [], // Assuming this is what you need
                                                         lNote: nil,
                                                         lAttachments: nil,
                                                         type: .Gregorian)
                                
                                self.fieldValueChangedAtTableFields(i, row: 0, value: ans, isError: false, reload: false)
                            }
                        }
                        let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DateTimeProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if item is FormViewModelParagraphItem {
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .Text{
                            let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let ans = ParagraphAnswer(val: defaultAnswer?.value)
                            self.fieldValueChangedAtTableFields(i, row: 0, value: ans, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
                            }
                        }
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle{
                            let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let boolAns = defaultAnswer?.value?.lowercased() == "true"
                            let ans = ParagraphAnswer(val: String(boolAns))
                            self.fieldValueChangedAtTableFields(i, row: 0, value: ans, isError: false, reload: false)
                            if defaultAnswer?.value  == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelNumericItem {
                        if DFAuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value ?? 0.0)", lNote: nil)
                                    self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                            let answer = BaseAnswerText(val: "\(defaultAnswer?.value ?? 0.0)", lNote: "")
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }else {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value?.first ?? "0.0")", lNote: nil)
                                    self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }

                    }
                    
                    if item is FormViewModelTextBoxItem {
                        if DFAuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer
                            if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                                isDimmed = true
                            }
                        } else {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value?.first ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelTextAreaItem {
                        if DFAuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value ?? "", htmlVal: defualtAnswer.htmlValue ?? "", lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                                isDimmed = true
                            }
                        } else {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value?.first ?? "", htmlVal: defualtAnswer.value?.first ?? "")
                                self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            self.fieldValueChangedAtTableFields(i, row: 0, value: defaultAnswer, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelFileUploadItem {
                        let mediaItem = item as? FormViewModelFileUploadItem
                        var defaultAttchs = [ModelUploadedMedia]()
                        if let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer {
                            for attach in defaultAnswer.value ?? [] {
                                if let uploadedMedia = DFAuthManager.shared.convertToUploadMediaUIModel(from: attach).uploadedMedia {
                                    defaultAttchs.append(uploadedMedia)
                                }
                                mediaItem?.attachmentsList.append(DFAuthManager.shared.convertToUploadMediaUIModel(from: attach))
                            }
                            //                            formBuilder.sectionObjects[i].items[0] = mediaItem!
                            let answer = FileUploadAnswer(val: defaultAttchs, lNote: nil, lAttachments: nil)
                            self.fieldValueChangedAtTableFields(i, row: 0, value: answer, isError: false, reload: false)
                        }
                        let requiredItem = (item.field?.properties as? FileUploadProperties)?.required
                        let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    if isDimmed {
                        break
                    }
                }
            }
            
            if isEditable || isApproverForm {
                
                // Create a dictionary to hold grouped items based on rowIndex
                var groupedItems: [String: [FormViewModelItem]] = [:]
                // Iterate through tableSectionObjects to populate the groupedItems dictionary
                for sectionObject in self.formBuilder.tableSectionObjects {
                    for item in sectionObject.items {
                        if let rowIndex = item.rowIndex , item.answer != nil  {
                            let itemExists = self.formBuilder.allRowsChildControls.contains { existingItem in
                                // Compare based on specific properties of FormViewModelItemStruct
                                // For example, compare based on identifier property
                                return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
                            }
                            
                            // If the item doesn't exist, append it to allRowsChildControls
                            if !itemExists {
                                self.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
                            }
                            if groupedItems[rowIndex] == nil {
                                groupedItems[rowIndex] = [item]
                            } else {
                                groupedItems[rowIndex]?.append(item)
                            }
                        }
                    }
                }
                rowIndices = formBuilder.allRowsChildControls
                    .compactMap { Int($0.rowIndex ?? "0") }
                    .sorted()
                let tables: [FormViewModelItem] = formBuilder.formModelItems.filter({$0.type == .Table})
                // Convert keys to integers and sort the dictionary
                let sortedItems = groupedItems.sorted { (entry1, entry2) in
                    guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
                        return false // Handle non-integer keys
                    }
                    return num1 < num2
                }
                
                // Now sortedGroupedItems contains the sorted dictionary
                
                for table in tables {
                    if let item = table as? FormViewModelTableItem {
                        for groupItem in sortedItems {
                            // Custom check to determine if groupItem.value exists in item.items
                            var exists = false
                            for existingItems in item.items {
                                if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
                                    existingItems[0].answer = groupItem.value[0].answer
                                    exists = true
                                    break
                                }
                            }
                            // If groupItem.value doesn't exist, append it to item.items
                            if !exists {
                                item.items.append(groupItem.value)
                                item.cascadingComponent = nil
                            }
                        }
                    }
                    for var section in formBuilder.sectionObjects {
                        if section.items[0].fieldId == table.fieldId {
                            formBuilder.handleItemRules(&section.items[0])
                        }
                    }
                }
            }
            self.formTableView.reloadData()
            
            formBuilder.reloadAt = { [unowned self] (section, _) in
                DispatchQueue.main.async {
                    guard section < self.formBuilder.sectionObjects.count else {return}
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
//                    self.handleRequiredItems(section: section)
                }
            }
            //            handleSubmitButton(enabled: !isDimmed)
        }
    }
    
    func fieldValidationChangedWhenEditRequest() {
        fieldValidationChangedWhenEditRequestForTableFields()
        var isDimmed = false
        if !formBuilder.sectionObjects.isEmpty {
            
            for i in 0 ... formBuilder.sectionObjects.count - 1 {
                let sectionObject = formBuilder.sectionObjects[i]
                for (index, item) in sectionObject.items.enumerated() {
                    let row = index  // Use the index as the row value
                    
                    if let switchItem = item as? FormViewModelSwitchItem {
                        let requiredItem = switchItem.required
                        let defaultAnswer = switchItem.defaultAnswer
                        self.fieldValueChangedAt(i, row: row, value: defaultAnswer, isError: false, reload: false)
                        if defaultAnswer == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
//                            break
                        }
                        self.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if let dropDownItem = item as? FormViewModelDropdownItem {
                        let requiredItem = dropDownItem.required
                        let defaultAnswer = dropDownItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? [] {
                            //                            if let selectedOption = dropDownItem.options?.first(where: { $0.id == val }) {
                            selectedValues.append(val)
                            //                            }
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAt(i, row: row, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
//                            break
                        }
                        self.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if let checkBoxItem = item as? FormViewModelCheckboxItem {
                        let requiredItem = checkBoxItem.required
                        let defaultAnswer = checkBoxItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? [] {
                            //                            if let selectedOption = checkBoxItem.options?.first(where: { $0.id == val }) {
                            selectedValues.append(val)
                            //                            }
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAt(i, row: row, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
//                            break
                        }
                        
                        self.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if let radioItem = item as? FormViewModelRadioItem {
                        let requiredItem = radioItem.required
                        let defaultAnswer = radioItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? [] {
                            //                            if let selectedOption = radioItem.options?.first(where: { $0.id == val }) {
                            selectedValues.append(val)
                            //                            }
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAt(i, row: row, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
//                            break
                        }
                        self.formTableView.reloadSections(IndexSet(integer: i), with: .none)

                    }
                    
                    if let item = item as? FormViewModelDateItem {
                        if let defualtAnswer = item.defaultAnswer {
                            var sortedValues = [String]()
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                            for val in defualtAnswer.value ?? [] {
                                if let from = val.from, let to = val.to { // If it's a dateRange
                                    sortedValues.append(dateFormatter.string(from: from))
                                    sortedValues.append(dateFormatter.string(from: to))
                                } else {
                                    if let from = val.from { // If it's a date from
                                        sortedValues.append(dateFormatter.string(from: from))
                                    }
                                }
                            }
                            if !(sortedValues.isEmpty) {
                                let ans = DateTimeAnswer(val: sortedValues, timeValues: [], lNote: nil, lAttachments: nil, type: .Gregorian)
                                self.fieldValueChangedAt(i, row: row, value: ans, isError: false, reload: false)
                            }
                        }
                        let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DateTimeProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
//                            break
                        }
                        
                        self.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if item is FormViewModelParagraphItem {
                        
                        let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .Text {
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let ans = ParagraphAnswer(val: defaultAnswer?.value)
                            self.fieldValueChangedAt(i, row: row, value: ans, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
//                                break
                            }
                        }
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle {
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let boolAns = defaultAnswer?.value?.lowercased() == "true"
                            let ans = ParagraphAnswer(val: String(boolAns))
                            self.fieldValueChangedAt(i, row: row, value: ans, isError: false, reload: false)
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
//                                break
                            }
                        }
                    }
                    
                    if item is FormViewModelNumericItem {
                        if DFAuthManager.shared.newSubmissionRetreiveEnabled {
                            
                            
                            if item.type == .TextBox {
                                if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswerWhenTextBox {
                                    let answer = TextboxAnswer(val: defualtAnswer.value ?? "", lPrefix: defualtAnswer.prefix, lSuffix: defualtAnswer.suffix, lNote: nil, lAttachments: nil)
                                    self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: true)
                                }
                                let requiredItem = (item.field?.properties as? NumberProperties)?.required
                                let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswerWhenTextBox
                                if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                                    isDimmed = true
//                                    break
                                }
                            } else {
                                if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer {
                                    if defualtAnswer.value != nil {
                                        let answer = BaseAnswerText(val: "\(defualtAnswer.value ?? 0.0)", lNote: nil)
                                        self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: true)
                                    }
                                }
                                let requiredItem = (item.field?.properties as? NumberProperties)?.required
                                let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                                if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                    isDimmed = true
//                                    break
                                }
                            }
                        } else {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value?.first ?? "0.0")", lNote: nil)
                                    self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: false)
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
//                                break
                            }
                        }
                    }
                    
                    if item is FormViewModelTextBoxItem {
                        if DFAuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
//                                break
                            }
                            
                            self.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                        } else {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value?.first ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
//                                break
                            }
                        }
                    }
                    
                    if item is FormViewModelTextAreaItem {
                        if DFAuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value ?? "", htmlVal: defualtAnswer.value ?? "")
                                self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer
                            self.fieldValueChangedAt(i, row: row, value: defaultAnswer, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
//                                break
                            }
                            self.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                        } else {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value?.first ?? "", htmlVal: defualtAnswer.value?.first ?? "")
                                self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            self.fieldValueChangedAt(i, row: row, value: defaultAnswer, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
//                                break
                            }
                        }
                    }
                    
                    if item is FormViewModelFileUploadItem {
                        let mediaItem = item as? FormViewModelFileUploadItem
                        var defaultAttchs = [ModelUploadedMedia]()
                        if let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer {
                            for attach in defaultAnswer.value ?? [] {
                                if let uploadedMedia = DFAuthManager.shared.convertToUploadMediaUIModel(from: attach).uploadedMedia {
                                    defaultAttchs.append(uploadedMedia)
                                }
                                mediaItem?.attachmentsList.append(DFAuthManager.shared.convertToUploadMediaUIModel(from: attach))
                            }
                            if !(defaultAttchs.isEmpty) {
                                let answer = FileUploadAnswer(val: defaultAttchs, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAt(i, row: row, value: answer, isError: false, reload: false)
                            }
                        }
                        let requiredItem = (item.field?.properties as? FileUploadProperties)?.required
                        let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
//                            break
                        }
                    }
                    if isDimmed && !item.hidden {
//                        break
                    }
                }
            }
//            handleSubmitButton(enabled: !isDimmed)
        }
    }
    
    
    func fieldValidationChangedWhenMultiCascade( formSectionObjects: inout [SectionObject]) {
        var isDimmed = false
        
        for section in formSectionObjects {
            for item in section.items  {
                if let switchItem = item as? FormViewModelSwitchItem {
                    let requiredItem = (item.field?.properties as? switchProperties)?.required
                    if item.answer != nil && !item.hidden && ((item.answer as? SwitchAnswer)?.value == false) && requiredItem == true  {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelDateItem{
                    let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true  {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelParagraphItem {
                    let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true    {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelNumericItem {
                    let requiredItem = (item.field?.properties as? NumberProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelTextBoxItem {
                    let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true  {
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
    
   
    func validateTableItems(_ tableItems: [[FormViewModelItem]], in cell: NewTableControlTVCell, section: Int, row: Int) {
        for tableItem in tableItems {
            for currentControl in tableItem {
                if let numControl = currentControl.field?.properties as? NumberProperties {
                    if let answerText = currentControl.answer as? BaseAnswerText {
                        let isRequired = numControl.required ?? false
                        let isEmptyValue = answerText.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let textBoxControl = currentControl.field?.properties as? FormViewModelTextBoxItem {
                    if let answerText = currentControl.answer as? TextboxAnswer {
                        let isRequired = textBoxControl.required
                        let isEmptyValue = answerText.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }

                } else if let textAreaControl = currentControl.field?.properties as? TextAreaProperties {
                    if let answerText = currentControl.answer as? TextAreaAnswer {
                        let isRequired = textAreaControl.required ?? false
                        let isEmptyValue = answerText.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let dateTimeControl = currentControl.field?.properties as? DateTimeProperties {
                    if let dateAnswer = currentControl.answer as? DateTimeAnswer {
                        let isRequired = dateTimeControl.required ?? false
                        let isEmptyValue = dateAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let switchControl = currentControl.field?.properties as? switchProperties {
                    if let switchAnswer = currentControl.answer as? SwitchAnswer {
                        let isRequired = switchControl.required ?? false
                        let isEmptyValue = !switchAnswer.value
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let checkboxControl = currentControl.field?.properties as? CheckboxProperties {
                    if let checkBoxAnswer = currentControl.answer as? BaseAnswerMCQ {
                        let isRequired = checkboxControl.required ?? false
                        let isEmptyValue = checkBoxAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let radioControl = currentControl.field?.properties as? RadioProperties {
                    if let  radioAnswer = currentControl.answer as? BaseAnswerMCQ {
                        let isRequired = radioControl.required ?? false
                        let isEmptyValue = radioAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let dropdownControl = currentControl.field?.properties as? DropdownProperties {
                    if let  dropdownAnswer = currentControl.answer as? BaseAnswerMCQ {
                        let isRequired =  dropdownControl.required ?? false
                        let isEmptyValue = dropdownAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let fileUploadControl = currentControl.field?.properties as? FileUploadProperties {
                    if let  fileAnswer = currentControl.answer as? FileUploadAnswer {
                        let isRequired =  fileUploadControl.required ?? false
                        let isEmptyValue = fileAnswer.value?.isEmpty ?? true
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            self.fieldValidationChangedAt(section, row: row, isValid: false)
                        }
                    }
                } else if let paragraphControl = currentControl.field?.properties as? ParagraphProperties {
                    if paragraphControl.paragraphSubType == .LabelSheetWithToggle {
                        if let paragraphAnswer = currentControl.answer as? ParagraphAnswer {
                            let isRequired = paragraphControl.required ?? false
                            let isEmptyValue = !(paragraphAnswer.value == "true")
                            
                            if isRequired && isEmptyValue && !currentControl.hidden {
                                cell.handleValidation(updateRules: false, requiredChild: true)
                                self.fieldValidationChangedAt(section, row: row, isValid: false)
                            }
                        }
                    }
                    
                    // Handle TableProperties validation if required logic exists
                }
            }
        }
    }
    
    /// Updating every control after it's value changed
    /// - Parameters:
    ///   - section: current section number
    ///   - row: current row number
    ///   - value: current control's answer
    ///   - isError: is control has error or not
    ///   - reload: should tableView reload or not
    func fieldValueChangedAt(_ section: Int, row: Int, value: Any?, isError: Bool = false, reload: Bool = true) {
        if formBuilder.isCardMode {
            if formBuilder.formModelItems.indices.contains(currentPage) {
                formBuilder.formModelItems[currentPage].isError = isError
                formBuilder.formModelItems[currentPage].answer = value
            }
        } else {
            if formBuilder.sectionObjects.indices.contains(section) && formBuilder.sectionObjects[section].items.indices.contains(row) {
                formBuilder.sectionObjects[section].items[row].isError = isError
                formBuilder.sectionObjects[section].items[row].answer = value
                formBuilder.sectionObjects[section].items[row].isValid = !isError
            }
        }
        saveChanges(reload: reload, section: section, row: row)
        if formBuilder.sectionObjects.indices.contains(section) && formBuilder.sectionObjects[section].items.indices.contains(row) {
            formBuilder.handleItemRules(&formBuilder.sectionObjects[section].items[row])
        }
        DFAuthManager.shared.isCameraOpened = false
        fieldValidationChangedAt(section, row: row, isValid: !isError)
    }
    
    func fieldValueChangedAtTableFields(_ section: Int, row: Int, value: Any?, isError: Bool = false, reload: Bool = true) {
        if formBuilder.isCardMode {
            if formBuilder.formModelItems.indices.contains(currentPage) {
                formBuilder.formModelItems[currentPage].isError = isError
                formBuilder.formModelItems[currentPage].answer = value
            }
        } else {
            if formBuilder.tableSectionObjects.indices.contains(section) && formBuilder.tableSectionObjects[section].items.indices.contains(row) {
                formBuilder.tableSectionObjects[section].items[row].isError = isError
                formBuilder.tableSectionObjects[section].items[row].answer = value
                formBuilder.tableSectionObjects[section].items[row].isValid = !isError
            }
        }
        saveChanges(reload: reload, section: section, row: row)
        DFAuthManager.shared.isCameraOpened = false
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

extension FormVC: UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        self.present(documentPicker, animated: true, completion: nil)

    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let fileName = URL(fileURLWithPath: url.path).lastPathComponent
        var fileSize : Double = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = attr[FileAttributeKey.size] as! Double

        } catch {
        }
        
        if ((fileSize) / 1024 / 1024) > 5{
            return

        }
        self.formBuilder.uploadMedia(fieldID: formBuilder.fileUploadFieldID, photo: nil, fileUrl: url, fileName: fileName) {[weak self] val in
            guard let `self` = self else {return}
            self.fieldValueChangedAt(self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
        }
    }
        
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
}


extension FormVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var fileName = "photo.jpeg"
        if let asset = info[UIImagePickerControllerPHAsset] as? PHAsset {
            if let name = (asset.value(forKey: "filename")) as? String {
                fileName = name
            }
        }
        
        self.dismiss(animated: true) {[weak self]  in
            guard let `self` = self else {return}
            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage{
                let imgData = NSData(data: UIImageJPEGRepresentation(photo, CGFloat(0.5))!)
                let imageSize: Int = imgData.count / 1024 / 1024

                if imageSize > 5{
                    return
                }
                self.formBuilder.uploadMedia(fieldID: self.formBuilder.fileUploadFieldID, photo: photo, fileUrl: nil, fileName: fileName) {[weak self] val in
                    guard let `self` = self else {return}
                    self.fieldValueChangedAt(self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
                }
            }

        }
    }
}
*/
