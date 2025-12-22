//
//  RequestSummaryVC.swift
//  CERQEL
//
//  Created by hassan elshaer on 25/03/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown
import MOLH
import Photos
import FittedSheets

class RequestSummaryVC: BaseWireFrame<RequestDetailsViewModel> {
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var bgTopView: UIView!
    //    @IBOutlet weak var bgBottomView: UIView!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: LocalizedButton!
    

    
    // MARK: - Variables
    
    let dropDown = DropDown()
    
    var currentRow = 1
    var id = ""
    var isMyRequestFlag = false
    var isFromNotifications = false
    var actionCommentText = ""
    var dataSourceTableArray: [dataSoruceTableModel] = []
    var sectionDataSourceArray: [sectionDataSourceModel] = []
    var newFormWithTable: [Field]?
    var allFormData: [Field] = []
    var formBuilder = FormBuilder.shared
    var buttonId: String?
    var delegate: HandlePayloadMethods?
    var actionId: String?
    var isEditable: Bool? = false
    var isApproverForm: Bool? = false
    var formTableItemsSections: [[Field]] = []
    var hiddenItemsIDs = [String]()
    var sectionDetailsIndices: [Int] {
        return viewModel.arrOfSectionsForSummary.enumerated().compactMap { index, type in
            type == .sectionDetails ? index : nil
        }
    }
    var DetailsWithOutSectionIndices: [Int] {
        return viewModel.arrOfSectionsForSummary.enumerated().compactMap { index, type in
            type == .oldActions_Dicussion ? index : nil
        }
    }
    
    var uniqueIdentifiers = [String]()
    
    var rowIndices: [Int] = []
    var currentPage = 0 {
        didSet {
            formBuilder.handlePageData(currentPage)
            itemsTV.reloadData()
        }
    }

    // MARK: - Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadAllFormData()
        self.cerqel_hideLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.removeBackButtonTitle()
        registerCells()
        navigationItem.title = "Request Summary".localized
        updateUI()
    }
    /// Configure listeners
    /// - Parameter viewModel: request details' viewModel
    override func configure(with viewModel: RequestDetailsViewModel) {
        
        formBuilder.serviceSubmittedResponse.subscribe(onNext: { [unowned self]  (item) in
            if let item = item{
                DispatchQueue.main.async {
                    self.cerqel_hideLoading()
                    self.showSuccessResponse(item: item)
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for items in formBuilder.sectionObjects.map({$0.items}) {
            for item in items {
                if hiddenItemsIDs.contains(item.fieldId) {
                    item.hidden = false
                }
            }
        }
        
        hiddenItemsIDs.removeAll()
        formBuilder.goToSummary = false
    }
    
    
    /// Updating UI
    private func updateUI(){
        cancelButton.setCancelButtonTheme()
        submitButton.setSubmitButtonTheme()
    }

    func loadSectionObjectsDataSource(sectionObject: SectionObject) {
        if sectionObject.item != nil {
            var sectionFormData = [Field]()
            let relatedItems = sectionObject.items
            for item in relatedItems {
                let rules = Rules(effectIn: item.rules?.effectIn, dependOn: item.rules?.dependOn)
                // Assuming item.answer is of type [String: Any]? and defaultValue in DefaultAnswer is of type ValueType?
                
                // First, unwrap item.answer safely
                var answerDict: [String : Any]? = [:]
                if  (item.parentId != nil) &&  (item.rowIndex != nil) {
                    answerDict = item.defualtTabldItemsSummaryAnswer as? [String: Any]
                } else {
                    answerDict = item.defualtSummaryAnswer as? [String: Any]
                }
                
                // Extract values from the dictionary
                let id = answerDict?["id"] as? String
                let name = answerDict?["name"] as? String
                let rowIndex = answerDict?["rowIndex"] as? String
                let defaultValueDict = answerDict?["value"]  as? NSArray
                
                // Parse defaultValueDict into a ValueType
                let defaultValue: ValueType? = {
                    guard let defaultValueDict = defaultValueDict else { return nil }
                    let decoder = JSONDecoder()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: defaultValueDict, options: [])
                        // Print JSON data
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("JSON Data: \(jsonString)")
                        }
                        let defaultValue = try decoder.decode(ValueType.self, from: jsonData)
                        return defaultValue
                    } catch {
                        print("Error parsing defaultValue: \(error)")
                        return nil
                    }
                }()
                
                // Create an instance of DefaultAnswer
                let defaultAnswer = DefaultAnswer(id: id, name: name, rowIndex: rowIndex, defaultValue: defaultValue, type: nil)
                
                // Now you have your defaultAnswer instance ready to use
                
                let properties: Properties = Properties(label: self.getSectionTitle(item: item), disabledMonths: "", placeholder: "", style: nil, sublabel: "", icon: "", defaultDateType: "", isVisibleInViewMode: true, dateFormat: "", dateSelectionMode: "", maximumTime: "", timeFormat: "", disabledDays: [], minimumTime: "", required: true, maximumDate: "", defaultTimeType: "", dateTimeType: "", minimumDate: "", unique: "", localization: nil, allowedDaysRange: nil, sendToBPM: false, validationType: "", disabledDates: [], tooltip: "", calendarType: "", defaultAnswer: defaultAnswer, firstDayOfWeek: 0)
                let formFieldItem = Fields(weight: nil, rules: rules, id: item.fieldId ?? "", templateQuestionId: item.field?.templateQuestionId ?? "", type: item.type?.rawValue , parentId: item.parentId ?? nil, order: "\(item.field?.order ?? "0")", properties: properties, rowIndex: item.rowIndex ?? nil)
//                if (formFieldItem.properties?.defaultAnswer?.defaultValue) != nil {
//                    if formFieldItem.rowIndex == nil {
//                        sectionFormData.append(formFieldItem)
//                        
//                    } else if !sectionFormData.contains(where: { $0.rowIndex == formFieldItem.rowIndex }) {
//                        sectionFormData.append(formFieldItem)
//                    }
//                }
            }
            if !sectionFormData.isEmpty {
                let element = sectionDataSourceModel(id: sectionObject.item?.fieldId, order: sectionObject.item?.field?.order, relatedItems: sectionFormData, title: self.getSectionTitle(item: sectionObject.item), expanded: !(sectionObject.item?.isCollapsedSection ?? false))
                self.sectionDataSourceArray.append(element)
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

    /// Present success popup
    /// - Parameter serviceId: current submitted service id
    private func showSuccessResponse(item: SubmitModel) {
        if item.isEligableForSurvey == true {
            self.viewModel.routerToSurvey(serviceId: formBuilder.serviceId, requestOrder: item.requestOrder)
            FormBuilder.shared.resetFormBuilder()
        }else {
            let reqId = formBuilder.serviceId
            let successData = successRequestData(service: self.formBuilder.serviceName ?? "", title:  "Your request".localized + " \"\(item.requestOrder)\" " + "Submitted successfully".localized, description: "\("Please wait for a response from management Your request ID:#".localized)\(item.requestOrder)", isRequest: true, reqId: item.id)
            SubmittedSuccessRequestBottomSheet.delegate = self
            SubmittedSuccessRequestBottomSheet.navigateToRequests = { [weak self] isRequest,requestId in
                guard let self = self else {return}
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if isRequest {
                        AuthManager.shared.isTasks = false
                    } else {
                        AuthManager.shared.isTasks = true
                    }
                    AuthManager.shared.isPopUpFromFormBuilder?(requestId)
                }
            }
            self.viewModel.successBottomSheetServices(title: successData.title)
            FormBuilder.shared.resetFormBuilder()
        }
    }
        
    /// Registering tableView's cells
    private func registerCells(){
        itemsTV.tableFooterView = UIView()
        itemsTV.registerHaederFooterCell(idintifier: ExpandedSectionHeader.cerqel_identifier)

        itemsTV.register(LabelSheetWithSwitchTVCell.cerqel_nib, forCellReuseIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier)
        itemsTV.register(NewTextBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewTextBoxTVCell.cerqel_identifier)
        itemsTV.register(NewTextAreaTVcell.cerqel_nib, forCellReuseIdentifier: NewTextAreaTVcell.cerqel_identifier)
        itemsTV.register(RichTextAreaTableViewCell.cerqel_nib, forCellReuseIdentifier: RichTextAreaTableViewCell.cerqel_identifier)
        itemsTV.register(SectionTableViewCell.cerqel_nib, forCellReuseIdentifier: SectionTableViewCell.cerqel_identifier)
        itemsTV.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
        itemsTV.register(ParagraphTableViewCell.cerqel_nib, forCellReuseIdentifier: ParagraphTableViewCell.cerqel_identifier)
        itemsTV.register(NewDatePickerTVCell.cerqel_nib, forCellReuseIdentifier: NewDatePickerTVCell.cerqel_identifier)
        itemsTV.register(NewLinkControlTVcell.cerqel_nib, forCellReuseIdentifier: NewLinkControlTVcell.cerqel_identifier)
        itemsTV.register(NewInfoIndicatorTVcell.cerqel_nib, forCellReuseIdentifier: NewInfoIndicatorTVcell.cerqel_identifier)
        itemsTV.register(DateTableViewCell.cerqel_nib, forCellReuseIdentifier: DateTableViewCell.cerqel_identifier)
        itemsTV.register(SubmitTableViewCell.cerqel_nib, forCellReuseIdentifier: SubmitTableViewCell.cerqel_identifier)
        itemsTV.register(MapTableViewCell.cerqel_nib, forCellReuseIdentifier: MapTableViewCell.cerqel_identifier)
        itemsTV.register(LocationTableViewCell.cerqel_nib, forCellReuseIdentifier: LocationTableViewCell.cerqel_identifier)
        itemsTV.register(SliderTableViewCell.cerqel_nib, forCellReuseIdentifier: SliderTableViewCell.cerqel_identifier)
        itemsTV.register(NPSTableViewCell.cerqel_nib, forCellReuseIdentifier: NPSTableViewCell.cerqel_identifier)
        itemsTV.register(RateTableViewCell.cerqel_nib, forCellReuseIdentifier: RateTableViewCell.cerqel_identifier)
        itemsTV.register(FaceRateTableViewCell.cerqel_nib, forCellReuseIdentifier: FaceRateTableViewCell.cerqel_identifier)
        itemsTV.register(MCQTableViewCell.cerqel_nib, forCellReuseIdentifier: MCQTableViewCell.cerqel_identifier)
        itemsTV.register(DropDownTableViewCell.cerqel_nib, forCellReuseIdentifier: DropDownTableViewCell.cerqel_identifier)
        itemsTV.register(NewTableControlTVCell.cerqel_nib, forCellReuseIdentifier: NewTableControlTVCell.cerqel_identifier)
        itemsTV.register(NewDropDownTVCell.cerqel_nib, forCellReuseIdentifier: NewDropDownTVCell.cerqel_identifier)
        itemsTV.register(NewCheckBoxTVCell.cerqel_nib, forCellReuseIdentifier: NewCheckBoxTVCell.cerqel_identifier)
        itemsTV.register(NewUploadMediaTVcell.cerqel_nib, forCellReuseIdentifier: NewUploadMediaTVcell.cerqel_identifier)
        itemsTV.register(NewSwitchCell.cerqel_nib, forCellReuseIdentifier: NewSwitchCell.cerqel_identifier)
        itemsTV.register(NewLblTVcell.cerqel_nib, forCellReuseIdentifier: NewLblTVcell.cerqel_identifier)

    }
    
    
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        cerqel_HUD.showHUD()
        if AuthManager.shared.newSubmissionRetreiveEnabled {
            formBuilder.createPayloadForSummaryPage(actionId: actionId, fromSummary: true,isEditable: isEditable, isApproverForm: isApproverForm, reqIdApprover: viewModel.reqIdForApprover ,sections: formBuilder.sectionObjects) {[weak self] payload in
                guard let `self` = self else {return}
                if let pload = payload {
                    if pload.first?.keys.first == "error" {
                        let viewColor = #colorLiteral(red: 0.9176470588, green: 0.9607843137, blue: 0.9921568627, alpha: 1)
                        let err =  pload.first?.values.first as? String ?? "error not found"
                        ToastManager.showToast(withText: err, containerBg: viewColor, containerBorderColor:.toastInfo, image: UIImageView(image: UIImage(named: "toastInfo")), closeBtnColor: .toastInfo, txtColor: .toastInfo)
                    }else if let id = self.buttonId {
                        self.dismiss(animated: true) {
                            self.delegate?.handleActionPayload(actionId: id, payload: pload)
                        }
                    }
                }
                self.cerqel_HUD.stopHUD()
            }
        } else {
            formBuilder.createPayload(actionId: actionId, fromSummary: true,isEditable: isEditable, isApproverForm: isApproverForm, reqIdApprover: viewModel.reqIdForApprover ,sections: formBuilder.sectionObjects) {[weak self] payload in
                guard let `self` = self else {return}
                if let pload = payload {
                    if pload.first?.keys.first == "error" {
                        let viewColor = #colorLiteral(red: 0.9176470588, green: 0.9607843137, blue: 0.9921568627, alpha: 1)
                        let err =  pload.first?.values.first as? String ?? "error not found"
                        ToastManager.showToast(withText: err, containerBg: viewColor, containerBorderColor:.toastInfo, image: UIImageView(image: UIImage(named: "toastInfo")), closeBtnColor: .toastInfo, txtColor: .toastInfo)
                    }else if let id = self.buttonId {
                        self.dismiss(animated: true) {
                            self.delegate?.handleActionPayload(actionId: id, payload: pload)
                        }
                    }
                }
                self.cerqel_HUD.stopHUD()
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        if let _ = actionId {
            dismiss(animated: true,completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}

extension RequestSummaryVC: Popup {
    func popup() {
        navigationController?.popToRootViewController(animated: true)
    }
}
extension RequestSummaryVC: UITableViewDelegate, UITableViewDataSource{
    
    func createSections(from formItems: [Field]) {
        formTableItemsSections = formItems.map { [$0] }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Add space between sections by setting a footer height
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
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) && !HelperFunctions.isHiddenSection(items: formBuilder.sectionObjects[section].items){
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
           
        return (currentSection?.type == .Section && !(currentSection?.hidden ?? false) && !HelperFunctions.isHiddenSection(items: viewModel.formBuilder.sectionObjects[section].items)) ? 56.0 : 0.0 // Adjust as needed
       }
       
       private func toggleSection(_ section: Int) {
           formBuilder.sectionObjects[section].item?.isCollapsedSection?.toggle()
           itemsTV.reloadSections(IndexSet(integer: section), with: .automatic)
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
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextBoxTVCell.cerqel_identifier, for: indexPath) as! NewTextBoxTVCell
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.handleDisabledText(disabled: true)
            if (item.answer as? TextboxAnswer) != nil && ((item.field?.properties as? TextBoxProperties)?.required ?? false) && item.isError == false  {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            if (item.answer as? BaseAnswerText) != nil && ((item.field?.properties as? NumberProperties)?.required ?? false) && item.isError == false  {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.dataSourceFetchingInTextNumberControl = { [weak self] dataSource, textBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    
                    formBuilder.setSelfControlCascadingForSameControl(item: textBoxItem)
                }
            }
               
               // Check and call the closure if needed
            if let dataSourceId = item.field?.properties?.dataSourcId, cell.textFieldValue.isEmpty {
                cell.dataSourceFetchingInTextNumberControl?(dataSourceId, item)
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
            cell.isSectionItem = sectionType?.type == .Section
            
            cell.item = item
            if (item.answer as? TextAreaAnswer) != nil && ((item.field?.properties as? TextAreaProperties)?.required ?? false){
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.tag = section
            cell.handleDisabledText(disabled: true)
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
                    
                    if cell.dataSourceId != "" && item.answer == nil  {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            viewModel.formBuilder.setSelfControlCascadingForSameControl(item: item)
                        }
                    }
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
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
                    
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            viewModel.formBuilder.setSelfControlCascadingForSameControl(item: item)
                        }
                    }
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
                    
                    if cell.dataSourceId != "" {
                        DispatchQueue.global(qos: .background).async {[weak self] in
                            guard let `self` = self else {return}
                            viewModel.formBuilder.setSelfControlCascadingForSameControl(item: item)
                        }
                    }
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
//            item.disabled = true
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            if item.answer == nil &&  !((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.handleDisabledDateControl(disabled: true)
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
            if item.answer != nil && ((item.answer as? SwitchAnswer)?.value == true) && ((item as? FormViewModelSwitchItem)?.required == true ) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.handleDisabledData(isDisable: true)
            return cell
        case .Checkbox:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? CheckboxProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.isFromRequest = true
            cell.handleDissabledControl(isFromRequest: true, item: item as? FormViewModelMCQBaseItem)
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
            if item.answer != nil && ((item.field?.properties as? RadioProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.isFromRequest = true
            cell.handleDissabledControl(isFromRequest: true, item: item as? FormViewModelMCQBaseItem)
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
                    formBuilder.setSelfControlCascadingForSameControl(item: item)
                }
            }
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
//            item.disabled = true
            cell.item = item
            if !((item.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) && ((item.field?.properties as? DropdownProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            cell.disableDropDown()
            return cell
            
        case .FileUpload:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewUploadMediaTVcell.cerqel_identifier, for: indexPath) as! NewUploadMediaTVcell
            cell.tag = section
            cell.isRequest = true
            cell.isSummary = true
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            if item.answer != nil && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            }
            
            cell.setupDetailsView()

            cell.didTapDownloadAttachment = { downloadUrl in
                let url = downloadUrl
                self.viewModel.downloadMedia(url: url) {[weak self] (imageDownloaded) in
                    guard let `self` = self else {return}
                    if !imageDownloaded {
                        self.viewModel.downloadVideo(url: url) {[weak self] videoDownloaded in
                            guard let `self` = self else {return}
                            if !videoDownloaded {
                                self.viewModel.downloadFile(url: url)
                            }else {
                                DispatchQueue.main.async {[weak self] in
                                    guard let `self` = self else {return}
                                    self.viewModel.showToast(message: "Downloaded Successfully".localized, seconds: 3)
                                }
                            }
                        }
                    }else {
                        DispatchQueue.main.async {[weak self] in
                            guard let `self` = self else {return}
                            self.viewModel.showToast(message: "Downloaded Successfully".localized, seconds: 3)
                        }
                    }
                }
            }
            
            return cell
            
        case .Table:
//            guard !HelperFunctions.returnEmptyCell(item: item) else{
//                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//                return cell
//            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTableControlTVCell.cerqel_identifier, for: indexPath) as! NewTableControlTVCell
            cell.isSectionItem = sectionType?.type == .Section
            
            cell.item = item
            cell.isEditable = true
            if let table = item as? FormViewModelTableItem {
                if table.items.count < table.minRows ?? 0 || table.items.count > table.maxRows ?? 0{
                    self.fieldValidationChangedAt(section, row: row, isValid: false)
                }else {
                    self.fieldValidationChangedAt(section, row: row, isValid: true)
                }
            }
            
            cell.handleHiddenViews(item: item as? FormViewModelTableItem,isRequest: 2)
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
    
    func getCurrentItem(indexPath: IndexPath) -> FormViewModelItem {
        var item: FormViewModelItem!
        if formBuilder.sectionObjects.count > indexPath.section {
            item = formBuilder.sectionObjects[indexPath.section].items[indexPath.row]
            if item.type == .Table {
                if let tableItem = item as? FormViewModelTableItem, tableItem.items.count == 0 {
                    hiddenItemsIDs.append(tableItem.fieldId)
                    tableItem.hidden = true
                }
            }else {
                if item.answer == nil {
                    hiddenItemsIDs.append(item.fieldId)
                    item.hidden = true
                }
            }
            return item
        }
        return FormViewModelItem(field: nil)
    }
}
extension RequestSummaryVC: PopViewControllerDelegate {
    func handlePopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
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
                } else if let radioItem = item as? FormViewModelRadioItem {
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
                    isRequired = fileUploadItem.required
                    if (fileUploadItem.answer as? FileUploadAnswer)?.value?.isEmpty ?? true {
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
            
            if isDimmed {
                break
            }
        }
    }

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
                formBuilder.sectionObjects[section].items[row].isUpdated = true
            }
        }
        saveChanges(reload: reload, section: section, row: row)
        if formBuilder.sectionObjects.indices.contains(section) && formBuilder.sectionObjects[section].items.indices.contains(row) {

            formBuilder.handleItemRules(formBuilder.sectionObjects[section].items[row], excludedView: isEditable ?? false ? .Edit : .Create, removeAnswer: true)
        }
        
        DynamicAuthManager.shared.isCameraOpened = false
        fieldValidationChangedAt(section, row: row, isValid: !isError)
    }

    func saveChanges(reload: Bool = true, section: Int, row: Int) {
        guard section >= 0 && row >= 0 && section < itemsTV.numberOfSections && row < itemsTV.numberOfRows(inSection: section) else {
            // section or row value is invalid, so exit the function
            return
        }
        if reload {
            itemsTV.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }
    }
}


extension RequestSummaryVC: NestedFormViewDelegate {
    
    func getSectionNumber(for tableItem: FormViewModelTableItem) -> Int? {
        return self.viewModel.formBuilder.sectionObjects.firstIndex(where: { section in
            return section.items.contains(where: { item in
                if let itemTable = item as? FormViewModelTableItem {
                    return itemTable.fieldId == tableItem.fieldId
                }
                return false
            })
        })
    }
    
    func didTapAdd(tableID: String, itemIndex: Int, children: [FormViewModelItem], cascadingComponent: [Int:[String:[String:String]]]?,isEdit: Bool) {
        let tables: [FormViewModelItem] = viewModel.formBuilder.formModelItems.filter({$0.type == .Table})
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
                
                self.itemsTV.reloadData()
            }
        }
        if isEdit {

            self.viewModel.formBuilder.handleItemRules(self.viewModel.formBuilder.sectionObjects[sectionIdx].items[0],
                                                       excludedView: isEditable ?? false ? .Edit : .Create, removeAnswer: false)
        }
    }
    
    
    /// User dismissed table's bottom sheet
    func didDismiss() {
        
    }
    
    func updateControlValue(section: Int, ans: Any?) {
        guard section < viewModel.formBuilder.sectionObjects.count else {return}
        guard !viewModel.formBuilder.sectionObjects[section].items.isEmpty else {return}
        viewModel.formBuilder.sectionObjects[section].items[0].answer = ans
        if section < self.viewModel.formBuilder.sectionObjects.count {
            self.itemsTV.reloadSections(IndexSet(integer: section), with: .none)
        } else {
            print("Attempt to reload a non-existent section")
        }
    }

}
