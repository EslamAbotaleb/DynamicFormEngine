//
//  ViewController.swift
//  FormBuilderSample
//
//  Created by Yasser Osama on 17/01/2023.
//

import UIKit
internal import EzPopup
internal import Expression
//import SwiftMessages
internal import RxCocoa
internal import RxSwift
import SwiftUI
internal import JGProgressHUD

public protocol PopViewControllerDelegate: AnyObject {
    func handlePopViewController()
}

class FormViewController: FormBaseViewController {
    
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
            submitButton.setTitle("Next".localized, for: .normal)
            submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet var tableViewsCollection: [UITableView]!
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var emptyErrorLbl: UILabel!
    @IBOutlet weak var cancelBtn: LocalizedButton! {
        didSet {
            cancelBtn.setTitleColor(primaryMain, for: .normal)
        }
    }
    @IBOutlet weak var prevBtn: LocalizedButton!{
        didSet {
            prevBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            prevBtn.setTitleColor(primaryMain, for: .normal)
        }
    }
    
    @IBOutlet weak var nextContainerView: UIView! {
        didSet {
            nextContainerView.backgroundColor = primaryMain
        }
    }
    @IBOutlet weak var cancelButtonContainer: UIView! {
        didSet {
            cancelButtonContainer.backgroundColor = .white
            cancelButtonContainer.layer.cornerRadius = 8
            cancelButtonContainer.layer.borderWidth = 1
            cancelButtonContainer.layer.borderColor = primaryMain.cgColor
        }
    }
    @IBOutlet weak var prevContentView: UIView! {
        didSet {
            prevContentView.backgroundColor = .white
            prevContentView.layer.cornerRadius = 8
            prevContentView.layer.borderWidth = 1
            prevContentView.layer.borderColor = primaryMain.cgColor

        }
    }
    @IBOutlet weak var prevContainterView: UIView! {
        didSet {
            prevContainterView.isHidden = currentPage == 0

        }
    }
    @IBOutlet weak var prevArrowIcon: UIImageView! {
        didSet {
            prevArrowIcon.tintColor = primaryMain
        }
    }
    @IBOutlet weak var nextDisableButton: UIButton!
    @IBOutlet weak var prevDisableButton: UIButton!
    @IBOutlet weak var stepperView: UIView!
    
    
    // MARK: - Variables
    public var router: CerqelRouterManager = CerqelRouterManagerDynamicFormImpl()
    public var delegate: HandlePayloadMethods?
    public var reloadDropDown:(() ->())?
    public var formId = ""
    public var selectedMediaUploaderIdx: Int?
    public var ValidationSectionArray: [SectionObject] = []
    public var currentPage = 0 {
        didSet {
            formBuilder.handlePageData(currentPage)
            activeTableView.reloadData()
            FormManager.shared.fieldValidationChangedWhenEditRequest(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: self.submitButton)
        }
    }
    
    public var shouldReset = true
    public var didPressDismissGesture: (()->())?
    public var actionId: String?
    public var detailsSchema: JSON2?
    public var buttonId: String?
    public var serviceId = ""
    public var singleRowItems: [FormViewModelItem] = []
    public var isApproverForm = false
    public var isParagrapghDataSet = false
    public var requestIdForApprover = ""
    public var serviceIdFromDetails = ""
    public var disAppearShouIdCalled = false
    public var stepProgressViewModel: StepProgressViewModel!
    
    
    // MARK: - LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            formTableView.isPrefetchingEnabled = false
        }
        self.formBuilder.resetValues()
        formBuilder.sectionObjects.removeAll()
        formBuilder.cascadingComponents.accept([:])
        formBuilder.cascadingComponentsWithMultiParents.accept([:])
        activeTableView = nil
        uploadMediadelegate = self
        if let schema = detailsSchema {
            self.getForm(schema: schema)
        } else if let id = actionId { // if form rendered from task details (dynamicAction)
            getActionsFormData(id: id)
        } else { // form rendered from specific service (dynamicForm) & edit Request
            getFormData(id: serviceId, isEdit: FormManager.shared.isEditable, isApproverForm: isApproverForm )
        }
        config()
        setupUI()
        
        outsideTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissToolTip))
        outsideTapGesture?.cancelsTouchesInView = false
        outsideTapGesture?.isEnabled = false // Start with it disabled
        view.addGestureRecognizer(outsideTapGesture!)
        
        // Create the SwiftUI view
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        editAt = (edit: false, at: 0,delete: false)
        if serviceIdFromDetails != "" {
            formBuilder.serviceId = serviceIdFromDetails
        } else {
            formBuilder.serviceId = serviceId
        }
        formTableView.reloadData()
        if let _ = activeTableView {
            activeTableView.reloadData()
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissToolTip()
        guard disAppearShouIdCalled else {
            
            return
        }
        disAppearShouIdCalled = false
        if let viewControllers = self.navigationController?.viewControllers
        {
            if !viewControllers.contains(where: {
                return $0 is FormViewController
            })
            {
                if !(DynamicAuthManager.shared.isCameraOpened) && !formBuilder.goToSummary {
                    formBuilder.serviceSubmittedResponse.accept(nil)
                    formBuilder.resetFormBuilder()
                    // Check if formBuilder is not nil and its properties are not empty before performing operations
                    if !formBuilder.sectionObjects.isEmpty {
                        formBuilder.sectionObjects = []
                    }
                    
                    if !formBuilder.tableSectionObjects.isEmpty {
                        formBuilder.tableSectionObjects = []
                    }
                    
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
                    
                    self.formBuilder.resetValues()
                }
            }
        }
    }
    
    
    // MARK: - Funcstions
    
    /// showing stepper from SwiftUI
    private func addChildHostingController(_ hostingController: UIHostingController<StepProgressView>) {
        guard let containerView = stepperView else { return }
        hostingController.view.frame = stepperView.bounds
        containerView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    
    /// Handle UI
    func setupUI() {
        formTableView.backgroundColor = .white
        formTableView.showsVerticalScrollIndicator = false
        view.backgroundColor = bg
        stepperView.isHidden = true
        setupBackButton()
        if let _ = actionId {
            exitButtonContainerView.isHidden = false
            topColoredView.backgroundColor = .clear
            topColoredViewHeightConstraint.constant = 0
            topFormConstraint.constant = 0
            [view,bgBottomView].forEach {
                $0?.layer.cornerRadius = 16
                $0?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }else {
            exitButtonContainerView.isHidden = true
        }
        setupTableView()
    }
    
    override public func goBack() {
        disAppearShouIdCalled = true
        navigationController?.popViewController(animated: true)
    }
    
    /// Config listeners
    public func config() {
        
        formBuilder.targetComponents.subscribe(onNext: { _ in
            
        }).disposed(by: disposeBag)
        
        formBuilder.cascadingComponentsWithMultiParents.subscribe(onNext: {[weak self] (component) in
            guard let `self` = self else {return}
            guard let _ = component else {return}
            DispatchQueue.main.async {
                if self.formBuilder.isPageMode {
                    FormManager.shared.fetchCascadingOptionsListWithMultiParentsWhenPages(vc: self,
                                                                                          sectionObjects: self.formBuilder.sectionObjects,
                                                                                          submitButton: self.submitButton,
                                                                                          code: component?.keys.first?.values.first ?? "",
                                                                                          parameters: component?.values.first ?? [],
                                                                                          row: 0)
                } else {
                    FormManager.shared.fetchCascadingOptionsListWithMultiParents(vc: self,
                                                                                 sectionObjects: self.formBuilder.sectionObjects,
                                                                                 submitButton: self.submitButton,
                                                                                 code: component?.keys.first?.values.first ?? "",
                                                                                 parameters: component?.values.first ?? [],
                                                                                 row: 0)
                }
            }
        }).disposed(by: disposeBag)
        
        
        formBuilder.cascadingComponents.subscribe(onNext: {[weak self] (component) in
            guard let `self` = self else {return}
            guard let component = component else {return}
            let params = component.values.first?.values.first
            DispatchQueue.main.async {
                FormManager.shared.fetchCascadingOptionsList(vc: self,
                                                             sectionObjects: self.formBuilder.sectionObjects,
                                                             code: component.values.first?.keys.first ?? "",
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
    
    /// Setting up table's cells
    public func setupTableView() {
        for tableView in tableViewsCollection {
            tableView.tableFooterView = UIView()
//            tableView.registerHaederFooterCell(idintifier: ExpandedSectionHeader.cerqel_identifier)
            tableView.registerHaederFooterCell(viewType: ExpandedSectionHeader.self)

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
    
    /// navigate to survey screen
    public func routerToSurvey() {
        router.presentbottomSheet(fromProfile: false, controller: FeedbackBottomSheetView.self, viewModel: FeedbackViewModel.self, item: SurveyItem(dismissPage,serviceId: "", requestOrder: ""))
    }
    
    /// dismiss page
    public func dismissPage(){
        self.router.dismiss()
        popToAllServices()
    }
    
    /// pop to all services view
    public func popToAllServices() {
        NotificationCenter.default.post(name: .didPopAllServices, object: nil)
//        router.popToViewController(ofClass: AllServicesViewController.self, animated: true)
    }

    /// Getting DynamicActions Form
    /// - Parameter id: current action id to be rendered
    public func getActionsFormData(id: String) {
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
                    
                    self.formBuilder.populateFormData(isEdit: FormManager.shared.isEditable, excludedView: FormManager.shared.isEditable ? .Edit : .Create)
                }
                self.formBuilder.populateFormData(isEdit: FormManager.shared.isEditable, excludedView: FormManager.shared.isEditable ? .Edit : .Create)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.formBuilder.serviceName ?? self.formBuilder.form.title
                }
                DispatchQueue.main.async {
                    self.formBuilder.handlePageData(self.currentPage)
                    self.formBuilder.handleTableControlChildren()
                    self.activeTableView = self.formTableView
                    self.activeTableView.reloadData()
                    self.ValidationSectionArray = self.formBuilder.sectionObjects
                }
            }
        }
        formBuilder.reloadAt = { [unowned self] (section, _, _) in
            DispatchQueue.main.async {
                if section < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                } else {
                    print("Attempt to reload a non-existent section")
                }
            }
        }
    }
    
    /// getting details form from schema
    public func getForm(schema: JSON2) {
        
        self.formBuilder.handleFormJSON(schema) {[weak self] success in
            guard let `self` = self else {return}
            if !success {
                DispatchQueue.main.async {[weak self] in
                    guard let `self` = self else {return}
                    self.emptyState.isHidden = false
                    self.formStackView.isHidden = true
                    self.emptyErrorLbl.text = "Error"
                }
                self.cerqel_hideLoading()
                return
            }
            self.cerqel_hideLoading()
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                self.emptyState.isHidden = true
                self.formStackView.isHidden = false
            }
            self.formBuilder.populateFormData(isEdit: FormManager.shared.isEditable, excludedView: FormManager.shared.isEditable ? .Edit : .Create)
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                self.navigationItem.title = self.formBuilder.serviceName ?? self.formBuilder.form.title
            }
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                self.formBuilder.handlePageData(self.currentPage)
                self.formBuilder.handleTableControlChildren()
                self.activeTableView = self.formTableView
                self.activeTableView.reloadData()
                self.ValidationSectionArray = self.formBuilder.sectionObjects
                FormManager.shared.fieldValidationChangedWhenEditRequest(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: self.submitButton)
            }
        }
        
        formBuilder.reloadAt = { [unowned self] (section, _, _) in
            DispatchQueue.main.async {
                if section < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                } else {
                    print("Attempt to reload a non-existent section")
                }
            }
        }
        
    }
    
    /// Getting DynamicForm Fields
    /// - Parameter id: current service id to be rendered
    public  func getFormData(id: String, isEdit: Bool?, isApproverForm: Bool?) {
        self.cerqel_showLoading()
        Services.shared.getForm(serviceId: id, isEdit: isEdit ?? false, isApproverForm: isApproverForm ?? false)  {[weak self] serviceName , formViersionId, responseJSON , errorMsg in
            guard let `self` = self else {return}
            self.formBuilder.serviceName = serviceName
            self.formBuilder.formVersionId = formViersionId
            guard let responseJSON = responseJSON else {
                self.cerqel_hideLoading()
                DispatchQueue.main.async {
                    self.formTableView.setNoDataPlaceholderWithButton(
                        title: "No Form Fields available".localized,
                        buttonTitle: "View All Services".localized,
                        buttonAction: {
                            NotificationCenter.default.post(name: .didPopAllServices, object: nil)
//                            self.navigationController?.popToSpecialViewController(ofClass: AllServicesViewController.self, animated: true)
                        },
                        messageImage: UIImage(named: "empty_services") ?? UIImage(),
                        showImage: true
                    )
                }
                return
            }
            self.formBuilder.handleFormJSON(responseJSON) {[weak self] success in
                guard let `self` = self else {return}
                if !success {
                    DispatchQueue.main.async {[weak self] in
                        guard let `self` = self else {return}
                        self.emptyState.isHidden = false
                        self.formStackView.isHidden = true
                        self.emptyErrorLbl.text = errorMsg
                    }
                    self.cerqel_hideLoading()
                    return
                }
                self.cerqel_hideLoading()
                DispatchQueue.main.async {[weak self] in
                    guard let `self` = self else {return}
                    self.emptyState.isHidden = true
                    self.formStackView.isHidden = false
                }
                self.formBuilder.populateFormData(isEdit: FormManager.shared.isEditable, excludedView: FormManager.shared.isEditable ? .Edit : .Create)
                DispatchQueue.main.async {[weak self] in
                    guard let `self` = self else {return}
                    self.navigationItem.title = self.formBuilder.serviceName ?? self.formBuilder.form.title
                }
                DispatchQueue.main.async {
                    self.formBuilder.handlePageData(self.currentPage)
                    self.formBuilder.handleTableControlChildren()
                    self.activeTableView = self.formTableView
                    self.activeTableView.reloadData()
                    if !(self.formBuilder.pagesArray.isEmpty ) && self.formBuilder.isPageMode {
                        self.stepperView.isHidden = false
                        self.stepProgressViewModel =  StepProgressViewModel(pages: self.formBuilder.pagesArray, currentPage: self.currentPage, enablePageValidation: self.formBuilder.enablePageValidation)
                        let swiftUIView = StepProgressView(viewModel: self.stepProgressViewModel!){[weak self] currentPage in
                            guard let `self` = self else {return}
                            if self.formBuilder.enablePageValidation {
                                if !self.isFormHasErrors().0 {
                                    self.currentPage = currentPage
                                    self.loadPrevAndNextBtns()
                                } else {
                                    if !isSinglePageHasErrors() {
                                        guard currentPage < formBuilder.pagesArray.count else {return}
                                        let pageTitle = isArabic() ? formBuilder.pagesArray[currentPage].localization?["ar"]?.label ?? "" : formBuilder.pagesArray[currentPage].localization?["en"]?.label ?? ""
                                        let pageId = formBuilder.pagesArray[currentPage].fieldId
                                        // All controls are valid; proceed with form submission
                                        let sectionPage = SectionPagesControl(
                                            id: pageId,
                                            title: pageTitle,
                                            sectionObjectForSummary: formBuilder.sectionObjects,
                                            isCollapsedSection: self.currentPage == 0 ? false : true
                                        )
                                        
                                        formBuilder.summaryPageDataSourceArray.removeAll(where: {$0.id == pageId})
                                        formBuilder.summaryPageDataSourceArray.append(sectionPage)
                                        submitForm()
                                    }
                                }
                                self.stepProgressViewModel.setCurrentPage(self.currentPage)
                            }else {
                                self.currentPage = currentPage
                                self.loadPrevAndNextBtns()
                            }
                        }
                        let hostingController = UIHostingController(rootView: swiftUIView)
                        if self.formBuilder.pagesArray.count > 1 {
                            self.addChildHostingController(hostingController)
                        }else {
                            self.stepperView.isHidden = true
                        }
                    } else {
                        self.stepperView.isHidden = true
                    }
                    self.ValidationSectionArray = self.formBuilder.sectionObjects
                    FormManager.shared.fieldValidationChangedWhenEditRequest(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: self.submitButton)
                }
            }
        }
        formBuilder.reloadAt = { [unowned self] (section, _, _) in
            DispatchQueue.main.async {
                if section < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                }
            }
        }
    }
    
    /// get section header title
    /// - Parameter item: section
    /// - Returns: section title
    public func getSectionTitle(item: FormViewModelItem?) -> String {
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
    
    /// toggle section expansion
    /// - Parameter section: section number
    public  func toggleSection(_ section: Int) {
        formBuilder.sectionObjects[section].item?.isCollapsedSection?.toggle()
        formTableView.reloadData()
    }
    
    /// hide toolTip
    @objc func dismissToolTip() {
        // Check if the tooltip is showing and dismiss it
        if let tipView = currentTipView {
            tipView.dismiss {
                self.currentTipView = nil // Reset the reference
                self.outsideTapGesture?.isEnabled = false // Disable the gesture after dismissing
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        // Increment the currentPage
        if formBuilder.isPageMode {
            
            guard currentPage < formBuilder.pagesArray.count else {return}
            let pageTitle = isArabic() ? formBuilder.pagesArray[currentPage].localization?["ar"]?.label ?? "" : formBuilder.pagesArray[currentPage].localization?["en"]?.label ?? ""
            let pageId = formBuilder.pagesArray[currentPage].fieldId
            
            if formBuilder.enablePageValidation {
                
                if !isSinglePageHasErrors() {
                    // All controls are valid; proceed with form submission
                    let sectionPage = SectionPagesControl(
                        id: pageId,
                        title: pageTitle,
                        sectionObjectForSummary: formBuilder.sectionObjects,
                        isCollapsedSection: self.currentPage == 0 ? false : true
                    )
                    
                    formBuilder.summaryPageDataSourceArray.removeAll(where: {$0.id == pageId})
                    formBuilder.summaryPageDataSourceArray.append(sectionPage)
                    submitForm()
                }
            }else {
                // All controls are valid; proceed with form submission
                let sectionPage = SectionPagesControl(
                    id: pageId,
                    title: pageTitle,
                    sectionObjectForSummary: formBuilder.sectionObjects,
                    isCollapsedSection: self.currentPage == 0 ? false : true
                )
                
                formBuilder.summaryPageDataSourceArray.removeAll(where: {$0.id == pageId})
                formBuilder.summaryPageDataSourceArray.append(sectionPage)
                submitForm()
            }
        }
        else {
            //if no pages enable
            var hasErrors = false
            for sectionIndex in 0..<formBuilder.sectionObjects.count {
                let section = formBuilder.sectionObjects[sectionIndex]
                for rowIndex in 0..<section.items.count {
                    let item = section.items[rowIndex]
                    if (item.hidden) || (item.disabled) { continue }
                    let validationResult = FormManager.shared.validateControl(vc: self, item)
                    if validationResult.isError {
                        hasErrors = true
                        // Update UI for inline error
                        updateInlineError(for: item, at: IndexPath(row: rowIndex, section: sectionIndex), message: validationResult.errorMessage)
                    } else {
                        clearInlineError(for: item, at: IndexPath(row: rowIndex, section: sectionIndex))
                    }
                }
            }
            
            if !hasErrors {
                // All controls are valid; proceed with form submission
                let sectionPage = SectionPagesControl(
                    id: "",
                    title: "",
                    sectionObjectForSummary: formBuilder.sectionObjects
                )
                
                formBuilder.summaryPageDataSourceArray.removeAll()
                formBuilder.summaryPageDataSourceArray.append(sectionPage)
                submitForm()
            }
        }
    }
    
    
    
    @IBAction func prevBtnTapped(){
        currentPage -= 1
        stepProgressViewModel.setCurrentPage(currentPage)
        loadNextPrevBtnsTitles(direction: -1)
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
    
    /// getting section index
    /// - Parameter tableItem: table control
    /// - Returns: section index
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
                // display warning toast here
                
                sectionIdx = getSectionNumber(for: item) ?? 0
                if isEdit {
                    item.items[itemIndex - 1] = children
                    item.cascadingComponent?[itemIndex - 1] = cascadingComponent
                } else {
                    item.items.append(children)
                    item.cascadingComponent?.append(cascadingComponent)
                }
                if item.items.count < (item.field?.properties as? TableProperties)?.minRows ?? 0 {
                    var msg = ""
                    msg = isArabic() ? item.field?.properties?.localization?["ar"]?.fieldWarning?.minRows ?? self.formBuilder.form.warnings?.formWarning?.fieldValidation?.table?.minRows ?? "" : item.field?.properties?.localization?["en"]?.fieldWarning?.minRows ?? self.formBuilder.form.warnings?.formWarning?.fieldValidation?.table?.minRows ?? ""
                    self.showToastWithError(msg)
                } else {
                    item.inLineError = false
                    item.errorMessageInline = ""
                }
                
                if sectionIdx < self.formBuilder.sectionObjects.count {
                    self.formTableView.reloadSections(IndexSet(integer: sectionIdx), with: .none)
                }
            }
        }
        if isEdit {
            
            self.formBuilder.handleItemRules(self.formBuilder.sectionObjects[sectionIdx].items[0], excludedView: FormManager.shared.isEditable ? .Edit : .Create, removeAnswer: false)
        }
        formBuilder.uniqueRulePassed.accept((false,nil))
    }
    
    
    /// User dismissed table's bottom sheet
    func didDismiss() {
        formBuilder.reloadAt = { [unowned self] (section, ans, itemId) in
            DispatchQueue.main.async {
                guard section < self.formBuilder.sectionObjects.count else {return}
                FormManager.shared.updateControlValue(vc: self,
                                                      sectionObjects: self.formBuilder.sectionObjects,
                                                      section: section,
                                                      ans: ans,
                                                      fieldId: itemId ?? "")
            }
        }
    }
}

extension FormViewController: PopViewControllerDelegate {
   public func handlePopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
