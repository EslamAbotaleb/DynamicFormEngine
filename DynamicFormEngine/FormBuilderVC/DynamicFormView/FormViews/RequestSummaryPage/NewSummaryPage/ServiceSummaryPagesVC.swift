//
//  ServiceSummaryPagesVC.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 09/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit
//import EasyTipView

// MARK: - SectionPagesControl
/// Represents a section in the summary page, including its id, title, and content.
struct SectionPagesControl {
    public var id: String?
    public var title: String?
    public var sectionObjectForSummary: [SectionObject]?
    public var isCollapsedSection: Bool?

    /// Initializes a SectionPagesControl instance.
    init(id: String? = nil, title: String? = nil, sectionObjectForSummary: [SectionObject]? = nil, isCollapsedSection: Bool? = true) {
        self.id = id
        self.title = title
        self.sectionObjectForSummary = sectionObjectForSummary
        self.isCollapsedSection = isCollapsedSection
    }
}

// MARK: - ServiceSummaryPagesVC
/// A view controller that displays the summary of a service request.
class ServiceSummaryPagesVC: BaseWireFrameDynamicForm<RequestDetailsViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet weak var showHideEmptyFieldsView: ShowHideEmptyFieldsView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: LocalizedButton!
    @IBOutlet weak var cancelBtn: LocalizedButton!
    
    // MARK: - Properties
    var currentRow = 1
    var id = ""
    var formBuilder = FormBuilder.shared
    var buttonId: String?
    var delegate: HandlePayloadMethods?
    var actionId: String?
    var isEditable: Bool? = false
    var isApproverForm: Bool? = false
    var currentTipView: EasyTipView?
    var outsideTapGesture: UITapGestureRecognizer?
    var showEmptyFieldsFlag = false
    var reloaded = false
    
    
    // MARK: - Lifecycle Methods
    
    /// Called after the view has been loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        handleShowHideView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if formBuilder.hiddenItemsIDs.isEmpty {
            showHideEmptyFieldsView.disableSwitch()
        }
    }
    
    /// Called just before the view appears on the screen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cerqel_hideLoading()
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
    /// Called just before the view disappears from the screen.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetHiddenItems()
    }
    
    /// Configures the view model with reactive subscriptions.
    override func configure(with viewModel: RequestDetailsViewModel) {
        formBuilder.serviceSubmittedResponse
            .subscribe(onNext: { [weak self] item in
                self?.handleSubmissionResponse(item)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup Methods
    
    /// Configures the initial UI elements and settings for the view controller.
    private func setupViews() {
        cancelBtn.setCancelButtonTheme()
        submitBtn.setSubmitButtonTheme()
        view.backgroundColor = bg
        configureNavigationBar()
        configureTableView()
    }
    
    /// Configures the navigation bar appearance and title.
    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.removeBackButtonTitle()
        navigationItem.title = "Request Summary".localized
    }
    
    /// Configures the table view's appearance and registers cells.
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.registerHaederFooterCell(viewType: ExpandedSectionHeader.self)

//        tableView.registerHaederFooterCell(idintifier: ExpandedSectionHeader.cerqel_identifier)
        tableView.register(SummaryPagesTableViewCell.cerqel_nib, forCellReuseIdentifier: SummaryPagesTableViewCell.cerqel_identifier)
    }
    
    /// Resets any hidden items in the form builder when the view disappears.
    private func resetHiddenItems() {
        formBuilder.goToSummary = false
        
        for section in formBuilder.sectionObjects {
            for item in section.items {
                formBuilder.hiddenItemsIDs.removeAll(where: { $0 == item.fieldId })
                if let visibilityPermission = item.field?.visibilityPermissions {
                    if !visibilityPermission.contains("Hide") {
                        item.hidden = false
                    }
                } else {
                    item.hidden = false
                }
            }
        }
    }
    
    
    /// draw toolTip text above controls
    func showToolTip(toolTip: String, sender: Any) {
        if let tipView = currentTipView {
            // Dismiss the tooltip if it's currently showing
            tipView.dismiss {
                self.currentTipView = nil
                self.outsideTapGesture?.isEnabled = false // Disable the outside tap gesture
            }
        } else {
            // Configure the tooltip preferences
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = UIColor.black
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            preferences.drawing.arrowPosition = .bottom
            preferences.drawing.cornerRadius = 8
            
            EasyTipView.globalPreferences = preferences
            
            // Create and show the tooltip
            let tipView = EasyTipView(text: toolTip)
            if let button = sender as? UIView {
                tipView.show(forView: button) // Show tooltip for the sender view
            }
            currentTipView = tipView
            
            // Enable the outside tap gesture to detect taps outside of the tooltip
            outsideTapGesture?.isEnabled = true
        }
    }
    
    // MARK: - Button Actions
    
    /// Handles the action when the cancel button is tapped.
    @IBAction func cancelBtnTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Handles the action when the submit button is tapped.
    @IBAction func submitBtnTapped(_ sender: Any) {
        cerqel_HUD.showHUD()
//        let sectionObjects = formBuilder.summaryPageDataSourceArray
//            .compactMap { $0.sectionObjectForSummary }
//            .flatMap { $0 }
        
        var sectionObjects: [SectionObject] = []
        for item in formBuilder.summaryPageDataSourceArray.map({$0.sectionObjectForSummary}) {
            item?.forEach({sectionObjects.append($0)})
        }
        
        createPayload(with: sectionObjects)
    }
    
    // MARK: - Payload Creation
    
    /// Creates a payload using the given section objects.
    private func createPayload(with sectionObjects: [SectionObject]) {
        let payloadCreation: (([[String: Any]]?) -> Void) = { [weak self] payload in
            self?.handlePayloadCreation(payload)
        }
        
        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
            formBuilder.createPayloadForSummaryPage(
                actionId: actionId,
                fromSummary: true,
                isEditable: isEditable,
                isApproverForm: isApproverForm,
                reqIdApprover: viewModel.reqIdForApprover,
                sections: sectionObjects,
                completion: payloadCreation
            )
        } else {
            formBuilder.createPayload(
                actionId: actionId,
                fromSummary: true,
                isEditable: isEditable,
                isApproverForm: isApproverForm,
                reqIdApprover: viewModel.reqIdForApprover,
                sections: sectionObjects,
                completion: payloadCreation
            )
        }
    }
    
    /// Handles the payload creation response.
    private func handlePayloadCreation(_ payload: [[String: Any]]?) {
        guard let payload = payload else {
            cerqel_HUD.stopHUD()
            return
        }
        
        if payload.first?.keys.first == "error" {
            let error = payload.first?.values.first as? String ?? "Error not found"
            showToast(with: error)
        } else if let id = buttonId {
            dismiss(animated: true) {
                self.delegate?.handleActionPayload(actionId: id, payload: payload)
            }
        }
        cerqel_HUD.stopHUD()
    }
    
    /// Displays a toast message for errors.
    private func showToast(with error: String) {
        let viewColor = #colorLiteral(red: 0.9176470588, green: 0.9607843137, blue: 0.9921568627, alpha: 1)
        ToastManager.showToast(
            withText: error,
            containerBg: viewColor,
            containerBorderColor: .toastInfo,
            image: UIImageView(image: UIImage(named: "toastInfo")),
            closeBtnColor: .toastInfo,
            txtColor: .toastInfo
        )
    }
    
    // MARK: - Submission Response Handling
    
    /// Handles the response after a submission.
    private func handleSubmissionResponse(_ item: SubmitModel?) {
        guard let item = item else { return }
        DispatchQueue.main.async {
            self.cerqel_hideLoading()
            self.showSuccessResponse(item: item)
        }
    }
    
    /// Displays the success response UI based on the submission model.
    private func showSuccessResponse(item: SubmitModel) {
        if item.isEligableForSurvey {
            navigateToSurvey(item)
        } else {
            showSuccessBottomSheet(item)
        }
    }
    
    /// Navigates to the survey view.
    private func navigateToSurvey(_ item: SubmitModel) {
        viewModel.routerToSurvey(serviceId: formBuilder.serviceId, requestOrder: item.requestOrder)
        formBuilder.resetFormBuilder()
    }
    
    /// Shows the bottom sheet with a success message.
    private func showSuccessBottomSheet(_ item: SubmitModel) {
        let successData = successRequestData(
            service: formBuilder.serviceName ?? "",
            title: "Your request".localized + " \"\(item.requestOrder)\" " + "Submitted successfully".localized,
            description: "\("Please wait for a response from management Your request ID:#".localized)\(item.requestOrder)",
            isRequest: true,
            reqId: item.id
        )
        SubmittedSuccessRequestBottomSheet.delegate = self
        SubmittedSuccessRequestBottomSheet.navigateToRequests = { [weak self] isRequest, requestId in
            self?.handleNavigationToRequests(isRequest: isRequest, requestId: requestId)
        }
        viewModel.successBottomSheetServices(title: successData.title)
        formBuilder.resetFormBuilder()
    }
    
    /// Handles navigation to the request details.
    private func handleNavigationToRequests(isRequest: Bool, requestId: String) {
        navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AuthManagerDynamicForm.shared.isTasks = !isRequest
            AuthManagerDynamicForm.shared.isPopUpFromFormBuilder?(requestId)
        }
    }
    
    func handleShowHideView() {
        showHideEmptyFieldsView.commonInit()
        showHideEmptyFieldsView.hideServiceName(false)
        
        showHideEmptyFieldsView.showEmptyFieldsClosure = {[weak self] show in
            guard let `self` = self else {return}
            self.reloaded = false
            self.showEmptyFieldsFlag = show
        }
        
        showHideEmptyFieldsView.reloadExternalTableView = {[weak self] in
            guard let `self` = self else {return}
            self.resetHiddenItems()
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension ServiceSummaryPagesVC: UITableViewDelegate, UITableViewDataSource {
    
    /// Returns the number of sections in the table view.
    /// The number of sections is determined by the count of `summaryPageDataSourceArray` in `FormBuilder`.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var summaryPageDataSourceArrayCount = formBuilder.summaryPageDataSourceArray.count
        
        for detail in formBuilder.summaryPageDataSourceArray {
            for sectionObjectSummary in detail.sectionObjectForSummary ?? [] {
                if sectionObjectSummary.items.count == 0 {
                    summaryPageDataSourceArrayCount -= 1
                }
            }
        }
        
        
        return summaryPageDataSourceArrayCount
    }
    
    /// Returns the height for rows in the table view.
    /// Automatic dimension is used to adjust the height based on the content.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Returns the number of rows in a given section.
    /// If `isPageMode` is true and the section is collapsed, the row count is 0; otherwise, it is 1.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = formBuilder.summaryPageDataSourceArray[section]
        return formBuilder.isPageMode ? ((currentSection.isCollapsedSection ?? false) ? 0 : 1) : 1
    }
    
    /// Configures and returns the cell for the given index path.
    /// The cell is configured using `SummaryPagesTableViewCell` and populated with the section's data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryPagesTableViewCell.cerqel_identifier, for: indexPath) as? SummaryPagesTableViewCell else {
            return UITableViewCell()
        }
        cell.formViewController = self
        // Fetch the data object for the current section
        let dto = formBuilder.summaryPageDataSourceArray[indexPath.section].sectionObjectForSummary ?? []
        
        // Configure the cell with the data and delegate
        cell.configure(with: dto, parentVC: self, isEditable: isEditable ?? false, isFromRequestDetails: false, isMyRequestFlag: false, showEmptyFieldsFlag: self.showEmptyFieldsFlag, reloaded: self.reloaded)
        cell.delegate = self
        
        // Handle hidden items IDs update
        cell.updateHiddenItemsIDs = { [weak self] items in
            guard let self = self else { return }
            self.formBuilder.hiddenItemsIDs.append(contentsOf: items)
        }
        
        cell.reloadExternalTableView = {[weak self] reload in
            if reload {
                guard let self = self else { return }
                self.tableView.reloadData()
                self.reloaded = true
            }
        }
        
        // Force layout updates for proper rendering
        cell.layoutIfNeeded()
        
        // Handle attachment download logic
        cell.didTapDownloadAttachment = { downloadUrl in
            let url = downloadUrl
            self.viewModel.downloadMedia(url: url) { [weak self] imageDownloaded in
                guard let self = self else { return }
                
                if !imageDownloaded {
                    self.viewModel.downloadVideo(url: url) { [weak self] videoDownloaded in
                        guard let self = self else { return }
                        
                        if !videoDownloaded {
                            self.viewModel.downloadFile(url: url)
                        } else {
                            DispatchQueue.main.async {
                                self.viewModel.showToast(message: "Downloaded Successfully".localized, seconds: 3)
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.viewModel.showToast(message: "Downloaded Successfully".localized, seconds: 3)
                    }
                }
            }
        }
        
        return cell
    }
    
    /// Returns a header view for the given section.
    /// The header includes a title and a toggle button for collapsing/expanding the section.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard formBuilder.isPageMode else { return nil }
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandedSectionHeader.cerqel_identifier) as? ExpandedSectionHeader else {
            return UIView()
        }
        
        let currentSection = formBuilder.summaryPageDataSourceArray[section]
        
        // Configure the header with section details
        header.configure(
            sectionTitle: currentSection.title ?? "",
            isExpanded: !(currentSection.isCollapsedSection ?? false),
            isEditMode: true,
            isParent: true,
            index: section + 1
        )
        
        // Toggle section collapse/expand on header interaction
        header.collapsed = { [weak self] in
            self?.toggleSection(section)
        }
        if formBuilder.pagesArray.count > 1 {
            return header
        }else {
            return nil
        }
    }
    
    /// Returns the height for the header of a given section.
    /// If `isPageMode` is true, a height of 72 is used; otherwise, 0.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return formBuilder.isPageMode && formBuilder.pagesArray.count > 1 ? 72.0 : 0.0
    }
    
    /// Toggles the collapsed state of a section and reloads the table view.
    /// - Parameter section: The index of the section to toggle.
    private func toggleSection(_ section: Int) {
        formBuilder.summaryPageDataSourceArray[section].isCollapsedSection?.toggle()
        tableView.reloadData()
    }
}

// MARK: - Popup Protocol Implementation
extension ServiceSummaryPagesVC: Popup {
    
    /// Handles the popup action by navigating back to the root view controller.
    /// This method is typically triggered when a popup action is completed,
    /// ensuring the user is returned to the initial screen of the navigation stack.
    func popup() {
        // Navigate back to the root view controller with an animation.
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UpdateConstraintTableViewDelegate
extension ServiceSummaryPagesVC: UpdateConstraintTableViewDelegate {
    
    /// Notifies the delegate when the height of a table view cell needs to be updated.
    /// This method ensures the table view recalculates its layout dynamically to reflect any changes in cell height.
    func didUpdateHeight() {
        DispatchQueue.main.async {
            // Begin and end updates to trigger automatic height recalculation for the table view.
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

// MARK: - NestedFormViewDelegate
extension ServiceSummaryPagesVC: NestedFormViewDelegate {
    
    /// Called when a nested form view is dismissed.
    /// No specific action is implemented for this delegate method.
    func didDismiss() {
        // No implementation needed for dismissing the view.
    }
    
    /// Called when the "Add" button is tapped in a nested form.
    /// This method handles adding or editing items in a table within the form.
    /// - Parameters:
    ///   - tableID: The unique identifier for the table being modified.
    ///   - itemIndex: The index of the item being edited (if applicable).
    ///   - children: The array of `FormViewModelItem` representing the children of the table item.
    ///   - cascadingComponent: A dictionary for cascading components, mapping indices to field-value pairs.
    ///   - isEdit: A flag indicating whether the action is an edit (`true`) or a new addition (`false`).
    func didTapAdd(
        tableID: String,
        itemIndex: Int,
        children: [FormViewModelItem],
        cascadingComponent: [Int: [String: [String: String]]]?,
        isEdit: Bool
    ) {
        // Filter to retrieve all items of type `.Table`
        let tables: [FormViewModelItem] = formBuilder.formModelItems.filter { $0.type == .Table }
        var sectionIdx = 0
        
        // Iterate over each table item to find the matching tableID
        for table in tables {
            if let item = table as? FormViewModelTableItem, item.fieldId == tableID {
                // Retrieve the section index for the table item
                sectionIdx = getSectionNumber(for: item) ?? 0
                
                if isEdit {
                    // Update the existing item at the specified index
                    item.items[itemIndex - 1] = children
                    item.cascadingComponent?[itemIndex - 1] = cascadingComponent
                } else {
                    // Append a new item and its cascading components
                    item.items.append(children)
                    item.cascadingComponent?.append(cascadingComponent)
                }
                
                // Reload the table view to reflect changes
                self.tableView.reloadData()
            }
        }
        
        // Handle item rules if the action is an edit
        if isEdit {
            self.viewModel.formBuilder.handleItemRules(
                self.formBuilder.sectionObjects[sectionIdx].items[0],
                excludedView: isEditable ?? false ? .Edit : .Create,
                removeAnswer: false
            )
        }
    }
    
    /// Retrieves the section index for a given `FormViewModelTableItem`.
    /// - Parameter tableItem: The table item whose section index is to be found.
    /// - Returns: The section index if found, or `nil` if the table item is not present.
    func getSectionNumber(for tableItem: FormViewModelTableItem) -> Int? {
        return self.formBuilder.sectionObjects.firstIndex { section in
            // Check if the section contains the given table item
            section.items.contains { item in
                if let itemTable = item as? FormViewModelTableItem {
                    return itemTable.fieldId == tableItem.fieldId
                }
                return false
            }
        }
    }
}
