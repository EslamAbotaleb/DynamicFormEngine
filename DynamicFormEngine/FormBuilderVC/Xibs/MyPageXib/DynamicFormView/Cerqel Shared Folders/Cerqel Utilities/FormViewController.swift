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

class FormViewController: BottomSheetVCCerqel {
    
    
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
    var buttonId: String?
    var serviceId = "" {
        didSet {
            formBuilder.serviceId = serviceId
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            formTableView.isPrefetchingEnabled = false
        }
        formBuilder.cascadingComponents.accept([:]) // Nov 5
        formBuilder.cascadingComponentsWithMultiParents.accept([:])
        formBuilder.sectionObjects.removeAll()
        activeTableView = nil
        
        if let id = actionId { // if form rendered from task details (dynamicAction)
            getActionsFormData(id: id)
        }else { // form rendered from specific service (dynamicForm)
            getFormData(id: serviceId)
        }
        config()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        editAt = (edit: false, at: 0,delete: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !(DynamicAuthManager.shared.isCameraOpened ){
            formBuilder.sectionObjects.removeAll()
            activeTableView = nil
        }
        formBuilder.serviceSubmittedResponse.accept(nil)
    }
    
    
    // MARK: - Funcstions
    
    
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
            self.fetchCascadingOptionsListWithMultiParents(code: component?.keys.first?.values.first ?? "",
                                                           parameters: component?.values.first ?? [],
                                                           row: 0)
        }).disposed(by: disposeBag)
        
        
        formBuilder.cascadingComponents.subscribe(onNext: {[weak self] (component) in
            guard let `self` = self else {return}
            guard let component = component else {return}
            let params = component.values.first?.values.first
            self.fetchCascadingOptionsList(code: component.values.first?.keys.first ?? "",
                                           parentValue: params,
                                           section: component.keys.first ?? 0,
                                           row: 0)
        }).disposed(by: disposeBag)
        
        formBuilder.serviceSubmittedResponse.subscribe(onNext: { [unowned self]  (item) in
            if let item = item{
                self.showSuccessResponse(serviceId: item)
            }
        }).disposed(by: self.disposeBag)
    }
    
    
    /// Handle submit button state
    /// - Parameter enabled: should it to be enabled or not
    func handleSubmitButton(enabled: Bool) {
        submitButton.isUserInteractionEnabled = enabled
        submitButton.backgroundColor = !enabled ? .alertClosed : .blue
    }
    
    
    
    /// Present success popup
    /// - Parameter serviceId: current submitted service id
    private func showSuccessResponse(serviceId: String) {
        let reqId = serviceId.extractNumbers().map(String.init).joined(separator: "")
        let successData = successRequestData(service: self.formBuilder.form.title ?? "", title:  "Your request Submitted successfully".localized, description: "\("Please wait for a response from management Your request ID:#".localized)\(reqId)", isRequest: true)
        SubmittedSuccessRequestBottomSheet.delegate = self
        SubmittedSuccessRequestBottomSheet.navigateToRequests = { [weak self] isRequest in
            guard let self = self else {return}
            self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if isRequest {
                    DynamicAuthManager.shared.isTasks = false
                } else {
                    DynamicAuthManager.shared.isTasks = true
                }
                DynamicAuthManager.shared.isPopUpFromFormBuilder?()
            }
        }
        SubmittedSuccessRequestBottomSheet.open(presenter: self,data: successData, fromDetails: false)
    }
    
    
    /// Setting up table's cells
    func setupTableView() {
        for tableView in tableViewsCollection {
            tableView.tableFooterView = UIView()
            tableView.register(LabelSheetWithSwitchTVCell.cerqel_nib, forCellReuseIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier)
            tableView.register(NewTextBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewTextBoxTVCell.cerqel_identifier)
            tableView.register(NewTextAreaTVcell.cerqel_nib, forCellReuseIdentifier: NewTextAreaTVcell.cerqel_identifier)
            tableView.register(RichTextAreaTableViewCell.cerqel_nib, forCellReuseIdentifier: RichTextAreaTableViewCell.cerqel_identifier)
            tableView.register(SectionTableViewCell.cerqel_nib, forCellReuseIdentifier: SectionTableViewCell.cerqel_identifier)
            tableView.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
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
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: Dynamic_BasicAction.fetchSearchOptions(code: code,
                                                                                                                                                   keyword: keyword,
                                                                                                                                                   parameters: params, targetComponents: self.formBuilder.targetComponents.value))).subscribe(onNext: {
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
    
    
    /// Fetch options for cascading rule with multi parents
    /// - Parameters:
    ///   - code: id from rule's payload
    ///   - parameters: [[key from payload : value from payload]]
    ///   - section: current section number
    ///   - row: current row number
    func fetchCascadingOptionsListWithMultiParents(code:String, parameters:[[String:String]], row: Int) {
        cerqel_HUD.showHUD()
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: Dynamic_BasicAction.fetchCascadingOptionsWithMultiParents(code: code, parameters: parameters, targetComponents: formBuilder.targetComponents.value))).subscribe(onNext: {[weak self] (response) in
             guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            
                            guard let sectionIndex = self.formBuilder.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) else {return}
                            guard row < self.formBuilder.sectionObjects[sectionIndex].items.count else {return}
                            let item = self.formBuilder.sectionObjects[sectionIndex].items[row]
                            if let dropDownItem = item as? FormViewModelDropdownItem {
                                var opts = [MCQOption]()
                                guard !values.isEmpty else {
                                    dropDownItem.options = []
                                    self.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                                    self.saveChanges(section: sectionIndex, row: row)
                                    return
                                }
                                for val in values {
                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                    opts.append(object)
                                }
                                dropDownItem.options = opts
                                self.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                                self.saveChanges(section: sectionIndex, row: row)
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
                                self.formBuilder.sectionObjects[sectionIndex].items[row] = dateItem
                                self.saveChanges(section: sectionIndex, row: row)
                            }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                paragraphItem.answer = ans
                                self.formBuilder.sectionObjects[sectionIndex].items[row] = paragraphItem
                                self.saveChanges(section: sectionIndex, row: row)
                            }else if let numericItem = item as? FormViewModelNumericItem {
                                let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                numericItem.answer = ans
                                self.formBuilder.sectionObjects[sectionIndex].items[row] = numericItem
                                self.saveChanges(section: sectionIndex, row: row)
                            }else if let textItem = item as? FormViewModelTextBoxItem {
                                let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                textItem.answer = ans
                                self.formBuilder.sectionObjects[sectionIndex].items[row] = textItem
                                self.saveChanges(section: sectionIndex, row: row)
                            }else if let switchItem = item as? FormViewModelSwitchItem {
                                let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                                       lNote: nil,
                                                       lAttachments: nil)
                                switchItem.answer = ans
                                self.formBuilder.sectionObjects[sectionIndex].items[row] = switchItem
                                self.fieldValidationChangedWhenMultiCascade()
                                self.saveChanges(section: sectionIndex, row: row)
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
    
    
    /// Fetch options for cascading rule
    /// - Parameters:
    ///   - code: id from rule's payload
    ///   - parentValue: [key from payload : value from payload]
    ///   - section: current section number
    ///   - row: current row number
    func fetchCascadingOptionsList(code: String,parentValue: [String:String]?, section: Int, row: Int) {
        cerqel_HUD.showHUD()
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: Dynamic_BasicAction.fetchCascadingOptions(code: code, parentValue: parentValue ?? [:], targetComponents: formBuilder.targetComponents.value))).subscribe(onNext: {[weak self] (response) in
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
    func fetchOptionsList(code: String, section: Int, row: Int) {
        cerqel_HUD.showHUD()
        cerqel_BasicNetworkServiceImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: Dynamic_BasicAction.fetchDDLOptions(code: code, targetComponents: self.formBuilder.targetComponents.value))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            let item = self.formBuilder.sectionObjects[section].items[row]
                            var opts = [MCQOption]()
                            if let dropDownItem = item as? FormViewModelDropdownItem {
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
                            }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                if let val = values.first {
                                    (paragraphItem.answer as? ParagraphAnswer)?.htmlValue = isArabic() ? val.nameAR : val.name
                                }
                                self.formBuilder.sectionObjects[section].items[row] = paragraphItem
                                self.saveChanges(reload: false, section: section, row: row)
                            }
                        }
                    }
                }
            }
        }, onError: {[weak self] (error) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
        
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
                self.formBuilder.populateFormData()
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
                self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
            }
        }
    }
    
    
    /// Getting DynamicForm Fields
    /// - Parameter id: current service id to be rendered
    func getFormData(id: String) {
        self.cerqel_showLoading()
        Services.shared.getForm(serviceId: id)  {[weak self] serviceName , formViersionId, responseJSON , errorMsg in
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
                self.formBuilder.populateFormData()
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
                self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
            }
        }
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
    
    
    
    // MARK: - IBActions
    
    @IBAction func submitBtnTapped(){
        cerqel_HUD.showHUD()
        formBuilder.createPayload(actionId: actionId, sections: formBuilder.sectionObjects) {[weak self] payload in
            guard let `self` = self else {return}
            if let pload = payload, let id = self.buttonId {
                self.dismiss(animated: true) {
                    self.delegate?.handleActionPayload(actionId: id, payload: pload)
                }
            }
            self.cerqel_HUD.stopHUD()
        }
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


extension FormViewController: Popup {
    func popup() {
        navigationController?.popViewController(animated: true)
    }
}

extension FormViewController: NestedFormViewDelegate {
    
    
    /// Added row into table control Delegate Method
    /// - Parameters:
    ///   - tableID: current table id
    ///   - itemIndex: current row index
    ///   - children: table's children controls
    ///   - cascadingComponent: [itemIndex : [id from payload : [key from payload : value from payload]]
    func didTapAdd(tableID: String, itemIndex: Int, children: [FormViewModelItem], cascadingComponent: [Int:[String:[String:String]]]?) {
        
        let tables: [FormViewModelItem] = formBuilder.formModelItems.filter({$0.type == .Table})
        
        for table in tables { // if case you have more than one table in the form
            if let item = table as? FormViewModelTableItem, item.fieldId == tableID {
                if item.items.count > itemIndex {
                    item.items[itemIndex] = children
                    item.cascadingComponent[itemIndex] = cascadingComponent
                } else {
                    item.items.append(children)
                    item.cascadingComponent.append(cascadingComponent)
                }
                
                self.activeTableView.reloadData()
                
                formBuilder.reloadAt = { [unowned self] (section, _) in
                    DispatchQueue.main.async {
                        self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                    }
                }
            }
        }
    }
    
    
    /// User dismissed table's bottom sheet
    func didDismiss() {
        formBuilder.reloadAt = { [unowned self] (section, ans) in
            DispatchQueue.main.async {
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
        self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
    }
    
    
}

extension FormViewController: PopupViewControllerDelegate {
    func popupViewControllerDidDismissByTapGesture(_ sender: PopupViewController) {
    }
}

