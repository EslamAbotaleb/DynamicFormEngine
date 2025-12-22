//
//  RequestDetailsView.swift
//
//
//  Created by Marwan Osama on 09/12/2021.
//  Copyright © 2021 All rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown
import MOLH
import FittedSheets

struct dataSoruceTableModel {
    var parentid: String?
    var rowIndex: String?
    var relatedItems: [Field]? = []
    var title: String?
    var expanded: Bool? = false
    var insideSection: Bool? = false
}
struct sectionDataSourceModel {
    var id: String?
    var order: String?
    var relatedItems: [Field]? = []
    var title: String?
    var expanded: Bool? = false
    var hidden: Bool? = false
    var insideSection: Bool? = false
}

protocol HandlePayloadMethods {
    func handleActionPayload(actionId: String,payload: [[String:Any]])
}

class RequestDetailsView: BaseWireFrame<RequestDetailsViewModel> {
    // MARK: - IBOutlets
//    @IBOutlet weak var showHideEmptyFieldsView: ShowHideEmptyFieldsView!
    @IBOutlet weak var bgTopView: UIView!
    @IBOutlet weak var bgBottomView: UIView!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var chatTxtV: UITextView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var attachmentCV: UICollectionView!
    @IBOutlet weak var actionsV: UIView!
    @IBOutlet weak var firstBtn: UIButton! // first button
    @IBOutlet weak var firstBtnContainerView: UIView!
    @IBOutlet weak var secondBtn: UIButton! // second button
    @IBOutlet weak var secondBtnContainerView: UIView!
    @IBOutlet weak var moreBtn: LocalizedButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    @IBOutlet weak var bottomActionsMainStack: UIStackView!
    @IBOutlet weak var bottomMessageStack: UIStackView!
    @IBOutlet weak var bottomActionsStack: UIStackView!
    @IBOutlet weak var bottomMessagLabel: UILabel!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var actionsContainerV: UIView!
    
    // MARK: - Variables
    var firstButton: Action?
    var secondButton: Action?
    var notPresentedActions = [Action]()
    var formBuilder = FormBuilder.shared
    let dropDown = DropDown()
    var commentID: String = ""
    var id = ""
    var isMyRequestFlag = false
    var isFromNotifications = false
    var actionCommentText = ""
    var showEmptyFieldsFlag = false // show/hide empty fields based on this flag
    var reloaded = false // to reload external TV after toggle switch
    var showEmptyFieldsSwitchSection = true // show/hide switch section when user navigate between requestDetails tabs (details,discussions, etc...)
    var disableSwitch = false // to disable switch when all controls filled
    var arrayOfAttachment: [ModelUploadedMedia] = [] {
        didSet{
            self.attachmentCV.reloadData()
        }
    }
    var DetailsTabsTVcellReloaded = false
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getDetailsFormJson(id: id, isRequest: isMyRequestFlag)
        self.viewModel.formBuilder.resetValues()
        create()
        setupViews()
        registerCells()
        reloadFormData()
        self.viewModel.isMyRequestFlag = isMyRequestFlag
        self.viewModel.id = id
        
        ///set selectedTabId = 3 if we have comment id
        ///if we from notification
        if commentID != "" {
            viewModel.selectedTabId.accept(3)
            scrollToIndexPath()
        }
        else {
            viewModel.selectedTabId.accept(1)
        }
        
        setActionBtns()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.itemsTV.reloadData()
            self.itemsTV.layoutIfNeeded()
        }
    }
    
    func reloadFormData(){
        viewModel.formBuilder.reloadAt = { [unowned self] section, answer, _ in
            DispatchQueue.main.async {
                self.itemsTV.reloadData()
                self.itemsTV.layoutIfNeeded()
                self.viewModel.setActionBtnsInVM()
            }
        }
    }
    
    func setupViews() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.removeBackButtonTitle()
        view.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        itemsTV.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        if isMyRequestFlag {
            navigationItem.title = "Request Details".localized
        }
        else{
            navigationItem.title = "Task Details".localized
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        formBuilder.detailsPageDataSourceArray.removeAll()
    }
    
    func setActionBtns(){
        if((viewModel.isEditableDimmedActions.value.0 ?? false) && (viewModel.isEditableDimmedActions.value.2 ?? false)){
            bottomMessageStack.isHidden = false
            actionsActivatedStatus(status:false)
            bottomMessagLabel.setClickableText(from: viewModel.isEditableDimmedActions.value.1 ?? "",
                                               clickableColor: .blue,
                                               target: self,
                                               action: #selector(buttonLabelMessageClicked))
        }
        else if((viewModel.isEditableDimmedActions.value.0 ?? false) && !(viewModel.isEditableDimmedActions.value.2 ?? false)){
            bottomMessageStack.isHidden = false
            actionsActivatedStatus(status:true)
            bottomMessagLabel.setClickableText(from: viewModel.isEditableDimmedActions.value.1 ?? "",
                                               clickableColor: .blue,
                                               target: self,
                                               action: #selector(buttonLabelMessageClicked))
        }
        else {
            bottomMessageStack.isHidden = true
            actionsActivatedStatus(status:true)
        }
    }
    
    func actionsActivatedStatus(status:Bool){
        firstBtn.isUserInteractionEnabled = status
        secondBtn.isUserInteractionEnabled = status
    }
    
    @objc func buttonLabelMessageClicked() {
        print("Button Clicked")
        self.viewModel.handleApproverAdditionalData()
    }
    
    func configure(actions: [Action]?,isDimmed:Bool) {
        guard var actions = actions, !actions.isEmpty else {return}
        if actions.count <= 2 { // 2 buttons or less
            moreBtnContainerView.isHidden = true
            for (index,button) in actions.enumerated() {
                if index == 0 { // first button
                    firstBtn.backgroundColor = !isDimmed ? (UIColor(hex: button.styleCode ?? "#712B81")) : (UIColor(hexString: button.styleCode ?? "#712B81",alpha:0.5))
                    firstBtn.setTitleColor(hexStringToUIColor(hex: button.buttonStyleCode ?? "#FFFFFF"), for: .normal)
                    firstButton = button
                    firstBtnContainerView.isHidden = false
                    firstBtn.setTitle(button.label, for: .normal)
                }
                if index == 1 { // second button
                    secondBtn.backgroundColor = !isDimmed ? hexStringToUIColor(hex: button.styleCode ?? "#1C3968") : (UIColor(hexString: button.styleCode ?? "#712B81",alpha:0.5))
                    secondBtn.setTitleColor(hexStringToUIColor(hex: button.buttonStyleCode ?? "#FFFFFF"), for: .normal)
                    secondButton = button
                    secondBtnContainerView.isHidden = false
                    secondBtn.setTitle(button.label, for: .normal)
                }
            }
        }
        else { // more than 2 buttons
            
            moreBtnContainerView.isHidden = false
            let icon = UIImage(named: "moreIcon")!
            moreBtn.setImage(icon, for: .normal)
            moreBtn.imageView?.contentMode = .scaleAspectFit
            moreBtn.setTitle("More".localized, for: .normal)
            
            moreBtn.imageView?.tintColor = hexStringToUIColor(hex: "#712B81")
            moreBtn.tintColor = hexStringToUIColor(hex: "#712B81")
            moreBtn.titleLabel?.textColor = hexStringToUIColor(hex: "#712B81")
            moreBtn.setTitleColor(hexStringToUIColor(hex: "#712B81"), for: .normal)
            moreBtn.imageEdgeInsets = isArabicCerqel() ? UIEdgeInsets(top: 0, left: -60, bottom: 0, right: 60) : UIEdgeInsets(top: 0, left: 60, bottom: 0, right: -60)
            actions = actions.sorted(by: {$0.actionOrder ?? 0 < $1.actionOrder ?? 0})
            var filteredArray = actions
            filteredArray.remove(at: 0)
            filteredArray.remove(at: 0)
            notPresentedActions = filteredArray
            
            
            let fButton = actions[0]
            firstBtn.backgroundColor = !isDimmed ? hexStringToUIColor(hex: fButton.buttonStyle?.backgroundColor ?? "#712B81").withAlphaComponent(CGFloat(fButton.buttonStyle?.opacity ?? 0.0)) : UIColor(hexString: fButton.buttonStyle?.backgroundColor ?? "#712B81",alpha: 0.5)
            firstBtn.layer.cornerRadius = 8
            firstBtn.layer.borderWidth = 1
            firstBtn.setTitleColor(!isDimmed ? hexStringToUIColor(hex: fButton.buttonStyle?.textColor ?? "#FFFFFF") : UIColor(hexString: fButton.buttonStyle?.textColor ?? "#FFFFFF",alpha: 0.5), for: .normal)
            firstBtn.borderColorV = !isDimmed ? hexStringToUIColor(hex: fButton.buttonStyle?.borderColor ?? "#712B81") : UIColor(hexString: fButton.buttonStyle?.borderColor ?? "#712B81",alpha: 0.5)
            firstButton = fButton
            firstBtnContainerView.isHidden = false
            firstBtn.setTitle(fButton.label, for: .normal)
            
            let sButton = actions[1]
            secondBtn.backgroundColor = !isDimmed ? hexStringToUIColor(hex: sButton.buttonStyle?.backgroundColor ?? "#1C3968").withAlphaComponent(CGFloat(sButton.buttonStyle?.opacity ?? 0.0)) : UIColor(hexString: sButton.buttonStyle?.backgroundColor ?? "#712B81",alpha: 0.5)
            secondBtn.layer.cornerRadius = 8
            secondBtn.layer.borderWidth = 1
            secondBtn.setTitleColor(!isDimmed ? hexStringToUIColor(hex: sButton.buttonStyle?.textColor ?? "#FFFFFF") : UIColor(hexString: sButton.buttonStyle?.textColor ?? "#FFFFFF",alpha: 0.5), for: .normal)
            secondBtn.borderColorV = !isDimmed ? hexStringToUIColor(hex: sButton.buttonStyle?.borderColor ?? "#712B81") : UIColor(hexString: sButton.buttonStyle?.borderColor ?? "#712B81",alpha: 0.5)
            secondButton = sButton
            secondBtnContainerView.isHidden = false
            secondBtn.setTitle(sButton.label, for: .normal)
        }
    }

    func scrollToIndexPath() {
        if let index = viewModel.chatList.value?.firstIndex(where: {$0.id == commentID}) {
            if index == ( (viewModel.chatList.value?.count ?? 0) - 1 ){
                print("commentIndexLast == \(index)")
                self.itemsTV.scrollToBottom()
            } else {
                print("commentIndexFirst == \(index)")
                let indexPath = IndexPath(row: index, section: isMyRequestFlag ? 1 : 2)
                self.itemsTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.itemsTV.reloadData()
            }
        }
    }
    
    func filterDuplicates(_ array: [Field]) -> [Field] {
        var uniqueForms: [Field] = []
        var seenParentIds: Set<String> = []
        
        for form in array {
            let formIdentifier = (form.parentId ?? "") + "\(form.rowIndex)"
            
            // Check if form.parentId matches any form.id in the array, and that form also has a parentId
            let parentFormExists = array.contains { $0.id == form.parentId && $0.parentId != nil }
            
            if (form.parentId == nil || !seenParentIds.contains(formIdentifier)) && !parentFormExists {
                // If not seen before and no such parent form exists, add it to the unique forms
                uniqueForms.append(form)
                
                // Add the parent id and row index combination to the set of seen values
                seenParentIds.insert(formIdentifier)
            }
        }
        uniqueForms = uniqueForms.filter { !($0.parentId != nil && $0.rowIndex == nil) }
        return uniqueForms
    }
    
    
    func create() {
        chatTxtV.delegate = self
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        chatTxtV.text = "Add discussion comment....".localized
        chatTxtV.textColor = .slate_grey
        shadowView.addNormalShadow()
        messageView.backgroundColor = bg
        bottomMessageStack.backgroundColor = bg
        alertImage.tintColor = primaryMain
        bottomMessagLabel.font = UIFont.bodySMedium(ofSize: 12)
        actionsContainerV.isHidden = true
    }
    /// Configure listeners
    /// - Parameter viewModel: request details' viewModel
    override func configure(with viewModel: RequestDetailsViewModel) {
        viewModel.arrayOfAttachmentsinAction.subscribe(onNext: { [unowned self]  (arr) in
            if !arr.isEmpty {
                self.itemsTV.reloadData()
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.arrayOfChatAttachments.subscribe(onNext: { [unowned self]  (arr) in
            self.arrayOfAttachment = arr
            self.attachmentCV.reloadData()
        }).disposed(by: self.disposeBag)
        
        viewModel.messageSentSuccessfully.subscribe(onNext: { [unowned self]  (isSuccess) in
            if let ss = isSuccess, ss{
                self.viewModel.getChat()
            }
        }).disposed(by: self.disposeBag)
        viewModel.actionTakenSuccessfully.subscribe(onNext: { [unowned self]  success, statusMessage in
            if success {
                self.viewModel.successBottomSheet()
            }
        }).disposed(by: self.disposeBag)
        viewModel.requestReopenedSuccessfully.subscribe(onNext: { [unowned self]  (isSuccess) in
            if let ss = isSuccess, ss{
                viewModel.getRequestDetails(id: id)
            }
        }).disposed(by: self.disposeBag)
        viewModel.requestWithdrawedSuccessfully.subscribe(onNext: { [unowned self]  (isSuccess) in
            if let ss = isSuccess, ss{
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: self.disposeBag)
        viewModel.chatList.subscribe(onNext: { [unowned self]  (arr) in
            if viewModel.selectedTabId.value == 3 {
                self.itemsTV.reloadData()
                if commentID != "" {
                    self.scrollToIndexPath()
                }
                else {
                    self.itemsTV.scrollToBottom()
                }
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.selectedTabId.subscribe(onNext: { [weak self]  (id) in
            guard let `self` = self else {return}
            if isMyRequestFlag {
                if id == 1 {
                    viewModel.arrOfSections = viewModel.arrOfSectionsForTab1
                    showEmptyFieldsSwitchSection = true
                    containerView.isHidden = false
                    shadowView.isHidden = true
                    attachmentCV.isHidden = true
                } else {
                    viewModel.arrOfSections = [.reqInfo, .requestTabs, .oldActions_Dicussion]
                    showEmptyFieldsSwitchSection = false
                    containerView.isHidden = true
                }
            }else {
                if id == 1 {
                    showEmptyFieldsSwitchSection = true
                    containerView.isHidden = false
                    self.actionsContainerV.isHidden = self.viewModel.details.value?.actions?.count ?? 0 <= 0
                    shadowView.isHidden = true
                    attachmentCV.isHidden = true
                    viewModel.arrOfSections = viewModel.arrOfSectionsForTab1
                }else{
                    showEmptyFieldsSwitchSection = false
                    viewModel.arrOfSections = [.empInfo, .reqInfo, .requestTabs, .oldActions_Dicussion]
                }
            }
            
            if id == 3 {
                containerView.isHidden = false
                shadowView.isHidden = false
                attachmentCV.isHidden = false
                if commentID != "" {
                    self.scrollToIndexPath()
                }else {
                    self.itemsTV.scrollToBottom()
                }
            }
            self.itemsTV.reloadData()
        }).disposed(by: self.disposeBag)
        
        viewModel.details.subscribe(onNext: { [unowned self]  (details) in
            if let det = details {
                self.viewModel.getChat()
                setActionBtns()
                if !isMyRequestFlag {
                    if det.actions?.count ?? 0 > 0 {
                        actionsContainerV.isHidden = false
                        self.configure(actions: det.actions,isDimmed:viewModel.isEditableDimmedActions.value.2 ?? false)
                    }
                    else {
                        actionsContainerV.isHidden = true
                    }
                }
                self.itemsTV.reloadData()
            }
        }).disposed(by: self.disposeBag)
        
        viewModel.isEditableDimmedActions.subscribe(onNext: { [unowned self]  (isEditable) in
            self.setActionBtns()
            if let det = viewModel.details.value {
                if det.actions?.count ?? 0 > 0 {
                    self.configure(actions: det.actions,isDimmed:viewModel.isEditableDimmedActions.value.2 ?? false)
                }
            }
        }).disposed(by: self.disposeBag)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        updateUI()
    }
    
    
    /// Updating UI
    private func updateUI(){
        bgTopView.roundCorners(corners: .bottomLeft, radius: 50)
        bgBottomView.roundCorners(corners: .topRight, radius: 50)
        view.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        self.view.layoutIfNeeded()
    }
    
    /// Registering tableView's cells
    private func registerCells(){
        itemsTV.registerHaederFooterCell(idintifier: ExpandedSectionHeader.cerqel_identifier)
        itemsTV.register(ChatTVcell.cerqel_nib, forCellReuseIdentifier: ChatTVcell.cerqel_identifier)
        attachmentCV.register(ChatFooterAttachmentCVcell.cerqel_nib, forCellWithReuseIdentifier: ChatFooterAttachmentCVcell.cerqel_identifier)
        attachmentCV.delegate = self
        attachmentCV.dataSource = self
        itemsTV.register(PreviousActionV2TVC.cerqel_nib, forCellReuseIdentifier: PreviousActionV2TVC.cerqel_identifier)
        itemsTV.register(EmpInfoTVC.cerqel_nib, forCellReuseIdentifier: EmpInfoTVC.cerqel_identifier)
        itemsTV.register(ReqInfoTVC.cerqel_nib, forCellReuseIdentifier: ReqInfoTVC.cerqel_identifier)
        itemsTV.register(TakeActionTVC.cerqel_nib, forCellReuseIdentifier: TakeActionTVC.cerqel_identifier)
        itemsTV.register(ActionControlTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlTVcell.cerqel_identifier)
        itemsTV.register(PreviousActionsTVC.cerqel_nib, forCellReuseIdentifier: PreviousActionsTVC.cerqel_identifier)
        itemsTV.register(DetailsEmptyStateTVcell.cerqel_nib, forCellReuseIdentifier: DetailsEmptyStateTVcell.cerqel_identifier)
        itemsTV.register(DetailsTabsTVcell.cerqel_nib, forCellReuseIdentifier: DetailsTabsTVcell.cerqel_identifier)
        itemsTV.register(ChatTVcell.cerqel_nib, forCellReuseIdentifier: ChatTVcell.cerqel_identifier)
        itemsTV.register(ChatEmptyTVcell.cerqel_nib, forCellReuseIdentifier: ChatEmptyTVcell.cerqel_identifier)
        itemsTV.register(FillFreeSpaceTVcell.cerqel_nib, forCellReuseIdentifier: FillFreeSpaceTVcell.cerqel_identifier)
        itemsTV.register(ActionControlAttachmentsTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlAttachmentsTVcell.cerqel_identifier)
        itemsTV.register(ExecuteActionTVcell.cerqel_nib, forCellReuseIdentifier: ExecuteActionTVcell.cerqel_identifier)
        itemsTV.register(ActionCommentTVcell.cerqel_nib, forCellReuseIdentifier: ActionCommentTVcell.cerqel_identifier)
        itemsTV.register(EmptyPreviousActionsTVcell.cerqel_nib, forCellReuseIdentifier: EmptyPreviousActionsTVcell.cerqel_identifier)
        
        itemsTV.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
        
        itemsTV.registerHaederFooterCell(idintifier: ExpandedSectionHeader.cerqel_identifier)
        itemsTV.register(SummaryPagesTableViewCell.cerqel_nib, forCellReuseIdentifier: SummaryPagesTableViewCell.cerqel_identifier)
    }
    
    /// Resets any hidden items in the form builder when the view disappears.
    private func resetHiddenItems() {
        formBuilder.goToSummary = false
        
        for section in formBuilder.sectionObjects {
            for item in section.items {
                formBuilder.hiddenItemsIDs.removeAll(where: { $0 == item.fieldId })
                item.hidden = false
            }
        }
    }
    
    
    func showAlert(names: [String]) {
        let sheetViewController = SheetVCC()
        sheetViewController.stringsArray = names
        sheetViewController.titleText = "Pending On".localized
        sheetViewController.preferredContentSize = CGSize(width: 300, height: 350)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(sheetViewController, forKey: "contentViewController")
        
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func firstBtnTapped() {
        if let action = firstButton {
            self.viewModel.presentCommentBottomSheet(action: action)
        }
    }
    
    @IBAction func secondBtnTapped() {
        if let action = secondButton {
            self.viewModel.presentCommentBottomSheet(action: action)
        }
    }
    
    @IBAction func moreTapped() {
        self.viewModel.showActionsListBottomSheet()
    }
    
    @IBAction func sendMsgBtnTapped(){
        self.sendMessage(txt: self.chatTxtV.text ?? "")
        chatTxtV.text = "Add discussion comment....".localized
        chatTxtV.textColor = .slate_grey
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.itemsTV.scrollToBottom()
        }
    }
    
    @IBAction func attachmentBtnTapped(){
        self.sendAttachment()
    }
}

extension RequestDetailsView: HandlePayloadMethods {
    
    /// Dynamic actions delegate method
    /// - Parameters:
    ///   - actionId: dynamic action id
    ///   - payload: collected payload
    func handleActionPayload(actionId: String,payload: [[String : Any]]) {
        var newArr: [ModelUploadedMediaFormPayload] = []
        if self.viewModel.arrayOfAttachmentsinAction.value.count > 0{
            for item in self.viewModel.arrayOfAttachmentsinAction.value {
                newArr.append(ModelUploadedMediaFormPayload.init(item: item))
            }
        }
        let actionIndex = viewModel.details.value?.actions?.firstIndex(where: {$0.id == actionId}) ?? 0
        viewModel.executeAction(payload: payload,actionId: actionId, comment: self.actionCommentText, statusMessage: viewModel.details.value?.actions?[actionIndex].actionTakenLabel ?? "Submitted".localized)
    }
}

extension RequestDetailsView: Popup {
    func popup() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView Delegate and Data Source Implementation
extension RequestDetailsView: UITableViewDelegate, UITableViewDataSource{
    /// Determines the number of sections in the table view.
    /// - Parameter tableView: The table view requesting the information.
    /// - Returns: The number of sections based on the selected tab ID.
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.selectedTabId.value == 1 {
            var detailsPageDataSourceArrayCount = formBuilder.detailsPageDataSourceArray.count
            return detailsPageDataSourceArrayCount + 3
        }else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 {
            return 1
        }
        else {
            if viewModel.selectedTabId.value == 1 {
                let currentSection = formBuilder.detailsPageDataSourceArray[section - 3]
                return formBuilder.isPageMode ? ((currentSection.isCollapsedSection ?? false) ? 0 : 1) : 1
            }else if viewModel.selectedTabId.value == 2 {
                return (self.viewModel.details.value?.previousActions ?? []).isEmpty ? 1 : (self.viewModel.details.value?.previousActions ?? []).count
            } else if viewModel.selectedTabId.value == 3 {
                return self.viewModel.chatList.value?.count ?? 0
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { //empInfo
            let cell = tableView.dequeueReusableCell(withIdentifier: EmpInfoTVC.cerqel_identifier, for: indexPath) as! EmpInfoTVC
            cell.configure(viewModel.details.value?.employee, status: viewModel.details.value?.status)
            return cell
        }
        else if indexPath.section == 1 { //reqInfo
            let cell = tableView.dequeueReusableCell(withIdentifier: ReqInfoTVC.cerqel_identifier, for: indexPath) as! ReqInfoTVC
            var status: Status?
            if isMyRequestFlag {
                status = viewModel.details.value?.status
            }else {
                status = nil
            }
            cell.HandlePendingOnGroupBtn = {
                if self.viewModel.details.value?.requestPendingOn?.isGroup ?? false {
                    self.showAlert(names: self.viewModel.details.value?.requestPendingOn?.groupNames ?? [])
                }
             }
            cell.configure(icon: viewModel.details.value?.serviceImage,
                           name: viewModel.details.value?.serviceName,
                           id: viewModel.details.value?.requestOrder,
                           department: viewModel.details.value?.employee?.department,
                           pendingOn: viewModel.details.value?.requestPendingOn?.name,
                           status: status,
                           date: viewModel.details.value?.createdDate, isMyReqFlag: isMyRequestFlag)
            return cell
            
        }
        else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTabsTVcell.cerqel_identifier) as! DetailsTabsTVcell
            
            cell.showHideEmptyFieldsView.isHidden = !showEmptyFieldsSwitchSection
            
            if disableSwitch {
                cell.disableSwitch()
            }
            
            cell.reloadExternalTableView = {[weak self] in
                guard let `self` = self else {return}
                self.resetHiddenItems()
                self.itemsTV.reloadData()
            }
            
            cell.showEmptyFieldsClosure = {[weak self] show in
                guard let `self` = self else {return}
                self.showEmptyFieldsFlag = show
            }
            
            cell.configure(selection: viewModel.selectedTabId.value, myRequest: isMyRequestFlag)
            cell.didChooseTab = { btn in
                self.viewModel.selectedTabId.accept(btn)
                self.commentID = ""
            }
            return cell
        }
        else {
            if viewModel.selectedTabId.value == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryPagesTableViewCell.cerqel_identifier, for: indexPath) as? SummaryPagesTableViewCell else {return UITableViewCell()}
                let dto = formBuilder.detailsPageDataSourceArray[indexPath.section - 3].sectionObjectForSummary ?? []
                cell.configure(with: dto,parentVC: self,isEditable: FormManager.shared.isEditable, isFromRequestDetails: true, isMyRequestFlag: isMyRequestFlag, showEmptyFieldsFlag: self.showEmptyFieldsFlag, reloaded: self.reloaded)
                cell.delegate = self
                cell.updateHiddenItemsIDs = { [weak self] items in
                    guard let `self` = self else {return}
                    if !items.isEmpty {
                        self.formBuilder.hiddenItemsIDs.append(contentsOf: items)
                        self.disableSwitch = false
                    }else {
                        self.disableSwitch = true
                    }
                    if !DetailsTabsTVcellReloaded {
                        self.itemsTV.reloadSections([2], with: .none)
                        DetailsTabsTVcellReloaded = true
                    }
                }
                
                cell.layoutIfNeeded()
                cell.didTapDownloadAttachment = { attachmentID in
                    let url = attachmentID
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
            }
            
            else if viewModel.selectedTabId.value == 2 { // Previous Actions Tab
                containerView.isHidden = true
                if (viewModel.details.value?.previousActions?.count ?? 0) > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: PreviousActionV2TVC.cerqel_identifier, for: indexPath) as! PreviousActionV2TVC
                    if let previousActions = viewModel.details.value?.previousActions, previousActions.count > indexPath.row {
                        cell.configure(viewModel.details.value?.previousActions?[indexPath.row])
                        cell.attTapped = {[weak self] id in
                            guard let `self` = self else {return}
                            let url = "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Download/\(id)"
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
                                                self.viewModel.showToast(message: "Downloaded Successfully".localized, seconds: 1)
                                            }
                                        }
                                    }
                                }else {
                                    DispatchQueue.main.async {[weak self] in
                                        guard let `self` = self else {return}
                                        self.viewModel.showToast(message: "Downloaded Successfully".localized, seconds: 1)
                                    }
                                }
                            }
                        }
                    }
                    return cell
                }else{
                    if indexPath.row == 0{
                        // Empty State
                        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyPreviousActionsTVcell.cerqel_identifier, for: indexPath) as! EmptyPreviousActionsTVcell
                        return cell
                    }
                    else{
                        //Fillling free space #talees
                        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                        return cell
                    }
                }
            }
            else { //Discussion Tab
                containerView.isHidden = false
                shadowView.isHidden = false
                attachmentCV.isHidden = false
                actionsContainerV.isHidden = true
                if viewModel.chatList.value?.count ?? 0 > 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTVcell.cerqel_identifier, for: indexPath) as? ChatTVcell else {return UITableViewCell()}
                    let dto = viewModel.chatList.value?[indexPath.row]
                    cell.configure(dto, empMail: AuthManager.shared.profile.value?.mail ?? "")
                    cell.attachmentTapped = {[weak self] id in
                        guard let `self` = self else {return}
                        let url = "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Download/\(id)"
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
                }else {
                    let emptyCell = tableView.dequeueReusableCell(withIdentifier: ChatEmptyTVcell.cerqel_identifier, for: indexPath) as! ChatEmptyTVcell
                    return emptyCell
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 2 && viewModel.selectedTabId.value == 1 && formBuilder.detailsPageDataSourceArray.count > 0 && formBuilder.isPageMode {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandedSectionHeader.cerqel_identifier) as? ExpandedSectionHeader else {return UIView()}
            let currentSection = formBuilder.detailsPageDataSourceArray[section - 3]
            header.configure(sectionTitle: currentSection.title ?? "", isExpanded: !(currentSection.isCollapsedSection ?? false), isEditMode: true,isParent: true,index: section - 2)
            header.collapsed = {
                self.toggleSection(section)
            }
            if formBuilder.pagesArray.count > 1 {
                return header
            }else {
                return UIView()
            }
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 2 && viewModel.selectedTabId.value == 1 {
            return formBuilder.isPageMode && formBuilder.pagesArray.count > 1 ? 72 : 0
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isMyRequestFlag {
            if indexPath.section == 0 {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    private func toggleSection(_ section: Int) {
        if formBuilder.detailsPageDataSourceArray.count > section - 3 {
            formBuilder.detailsPageDataSourceArray[section - 3].isCollapsedSection?.toggle()
            itemsTV.reloadData()
        }
    }
}

// MARK: - Chat Message and Attachment Management
extension RequestDetailsView {
    
    /// Sends a message with optional attachments.
    ///
    /// - Parameter txt: The text message to send.
    func sendMessage(txt: String) {
        var chatMessage = txt
        
        // Replace placeholder text with an empty string.
        if chatMessage == "Add discussion comment....".localized {
            chatMessage = ""
        }
        
        // If there are attachments, include them in the message payload.
        if viewModel.arrayOfChatAttachments.value.count > 0 {
            var attachments: [ModelUploadedMediaFormPayload] = []
            
            for item in viewModel.arrayOfChatAttachments.value {
                attachments.append(ModelUploadedMediaFormPayload(item: item))
            }
            
            // Validate message length.
            if chatMessage.count > 200 {
                self.viewModel.errorsSubject.onNext(
                    BaseError.other(title: "The maximum length of letters is 200.".localized)
                )
                return
            }
            
            // Reset the input field and send the message with attachments.
            self.chatTxtV.resignFirstResponder()
            self.chatTxtV.text.removeAll()
            self.viewModel.sendComment(message: chatMessage, attachment: attachments.toJSON())
        } else {
            // Ensure the message is not empty.
            guard !chatMessage.isEmpty else { return }
            
            // Validate message length.
            if chatMessage.count > 200 {
                self.viewModel.errorsSubject.onNext(
                    BaseError.other(title: "The maximum length of letters is 200.".localized)
                )
                return
            }
            
            // Reset the input field and send the message without attachments.
            self.chatTxtV.resignFirstResponder()
            self.chatTxtV.text.removeAll()
            self.viewModel.sendComment(message: chatMessage, attachment: nil)
        }
    }
    
    /// Opens the media menu for sending an attachment.
    func sendAttachment() {
        self.cerqel_openMediaMenu()
    }
    
    /// Removes an attachment at the specified index.
    ///
    /// - Parameter idx: The index of the attachment to remove.
    func didRemoveAttachment(idx: Int) {
        var attachments = self.viewModel.arrayOfChatAttachments.value
        
        // Remove the attachment at the specified index.
        attachments.remove(at: idx)
        
        // Update the attachments list in the view model.
        self.viewModel.arrayOfChatAttachments.accept(attachments)
    }
}

// MARK: - UIDocumentMenuDelegate, UIDocumentPickerDelegate Implementation
extension RequestDetailsView: UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    /// Called when the user picks a document picker from the document menu.
    ///
    /// - Parameters:
    ///   - documentMenu: The `UIDocumentMenuViewController` instance.
    ///   - documentPicker: The `UIDocumentPickerViewController` instance to present.
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        // Present the document picker to the user.
        self.present(documentPicker, animated: true, completion: nil)
    }

    /// Called when the user selects a document in the document picker.
    ///
    /// - Parameters:
    ///   - controller: The `UIDocumentPickerViewController` instance.
    ///   - url: The URL of the picked document.
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        var fileSize: Double = 0
        
        // Retrieve file attributes to calculate the file size.
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = attributes[FileAttributeKey.size] as? Double ?? 0
        } catch {
            print("Error retrieving file attributes: \(error.localizedDescription)")
        }
        
        // Validate file size (must be ≤ 5 MB).
        if (fileSize / 1024 / 1024) > 5 {
            self.viewModel.errorsSubject.onNext(
                BaseError.other(title: "Can't upload. Media size is > 5 MB.".localized)
            )
            return
        }
        
        // Upload the selected document.
        self.viewModel.uploadMedia(mediaImg: nil, fileUrl: url)
    }

    /// Called when the user cancels the document picker.
    ///
    /// - Parameters:
    ///   - controller: The `UIDocumentPickerViewController` instance.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // No additional action needed, but this method is required to handle cancellations.
        print("Document picker was cancelled.")
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate Implementation
extension RequestDetailsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /// Called when the user finishes picking media from the image picker.
    ///
    /// - Parameters:
    ///   - picker: The `UIImagePickerController` instance used for picking media.
    ///   - info: A dictionary containing the media info, such as the original image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Dismiss the picker before processing the selected media.
        self.dismiss(animated: true) {
            // Attempt to retrieve the selected image.
            if let photo = info[.originalImage] as? UIImage {
                print("WE HAVE IMAGE !!!! 🚀")
                
                // Convert the image to JPEG data with 50% compression quality.
                if let imgData = photo.jpegData(compressionQuality: 0.5) {
                    let imageSizeInMB = (NSData(data: imgData).count / 1024 / 1024)
                    print("Actual size of image in MB: \(imageSizeInMB)")
                    
                    // Validate image size (must be less than or equal to 5 MB).
                    if imageSizeInMB > 5 {
                        self.viewModel.errorsSubject.onNext(
                            BaseError.other(title: "Can't upload. Media size is > 5 MB.".localized)
                        )
                        return
                    }
                    
                    // Upload the selected image using the view model.
                    self.viewModel.uploadMedia(mediaImg: photo, fileUrl: nil)
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate Implementation
extension RequestDetailsView: UITextViewDelegate {

    /// Called when the text view begins editing.
    ///
    /// - Parameter textView: The text view that started editing.
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Clear placeholder text when the user starts typing.
        if textView.text == "Add discussion comment....".localized {
            textView.text = ""
        }
    }

    /// Asks whether editing should begin in the specified text view.
    ///
    /// - Parameter textView: The text view requesting permission to begin editing.
    /// - Returns: `true` to allow editing to begin, otherwise `false`.
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Remove placeholder text and set appropriate text color when editing begins.
        if textView.text == "Add discussion comment....".localized {
            textView.text.removeAll()
            textView.textColor = .DarkBlack
        }
        return true
    }

    /// Asks whether editing should stop in the specified text view.
    ///
    /// - Parameter textView: The text view requesting permission to end editing.
    /// - Returns: `true` to allow editing to end, otherwise `false`.
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // Reset to placeholder text and color if the text view is empty when editing ends.
        if textView.text.isEmpty {
            textView.text = "Add discussion comment....".localized
            textView.textColor = .slate_grey
        }
        return true
    }

    /// Asks whether the specified text should be replaced in the text view.
    ///
    /// - Parameters:
    ///   - textView: The text view containing the text to be replaced.
    ///   - range: The range of the text to be replaced.
    ///   - text: The replacement text.
    /// - Returns: `true` if the replacement is allowed, otherwise `false`.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Ensure the new text doesn't start with whitespace or a newline at the beginning of the text view.
        guard range.location == 0 else {
            return true
        }

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: .whitespacesAndNewlines).location != 0
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout Implementation
extension RequestDetailsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    /// Returns the number of items in the collection view section.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: The index of the section in the collection view.
    /// - Returns: The number of items in the `arrayOfAttachment`.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAttachment.count
    }

    /// Configures and returns the cell for the specified index path.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured `UICollectionViewCell` for the given index path.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a reusable cell of type `ChatFooterAttachmentCVcell`.
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ChatFooterAttachmentCVcell.cerqel_identifier,
            for: indexPath
        ) as? ChatFooterAttachmentCVcell else {
            fatalError("Unable to dequeue ChatFooterAttachmentCVcell")
        }

        // Configure the cell with the attachment data.
        cell.configure(arrayOfAttachment[indexPath.row])

        // Handle the remove button action within the cell.
        cell.removeBtnTapped = { [weak self] in
            guard let self = self else { return }
            self.didRemoveAttachment(idx: indexPath.row)
        }

        return cell
    }

    /// Specifies the size of the items in the collection view layout.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - collectionViewLayout: The layout object of the collection view.
    ///   - indexPath: The index path of the item.
    /// - Returns: The size of the cell as a `CGSize`.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.7 // Calculate the cell width.
        return CGSize(width: width, height: 36) // Fixed height of 36.
    }
}


// MARK: - UpdateConstraintTableViewDelegate Implementation
extension RequestDetailsView: UpdateConstraintTableViewDelegate {

    /// Notifies the delegate that the height of the table view needs to be updated.
    ///
    /// This method ensures that the table view recalculates its layout after a height change,
    /// allowing dynamic cell heights to adjust appropriately.
    func didUpdateHeight() {
        DispatchQueue.main.async {
            // Begin and end updates to trigger a layout recalculation for the table view.
            self.itemsTV.beginUpdates()
            self.itemsTV.endUpdates()
        }
    }
}

// MARK: - NestedFormViewDelegate Implementation
extension RequestDetailsView: NestedFormViewDelegate {
    
    /// Retrieves the section index for a given table item within the form builder's sections.
    ///
    /// - Parameter tableItem: The `FormViewModelTableItem` for which the section index is needed.
    /// - Returns: The index of the section containing the specified table item, or `nil` if not found.
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
    
    /// Handles the addition or editing of a table item in the form.
    ///
    /// - Parameters:
    ///   - tableID: The identifier of the table where the action occurs.
    ///   - itemIndex: The index of the item being edited (for edit mode only).
    ///   - children: The child items to be added or updated in the table.
    ///   - cascadingComponent: Optional cascading component data to be added or updated.
    ///   - isEdit: A Boolean indicating whether the action is an edit (`true`) or an addition (`false`).
    func didTapAdd(tableID: String, itemIndex: Int, children: [FormViewModelItem], cascadingComponent: [Int: [String: [String: String]]]? = nil, isEdit: Bool) {
        // Filter for all table-type items within the form model.
        let tables: [FormViewModelItem] = viewModel.formBuilder.formModelItems.filter({ $0.type == .Table })
        var sectionIdx = 0
        
        // Iterate through all table items to find the matching table by its field ID.
        for table in tables {
            if let item = table as? FormViewModelTableItem, item.fieldId == tableID {
                sectionIdx = getSectionNumber(for: item) ?? 0
                
                // Update or append the child items and cascading components based on edit mode.
                if isEdit {
                    item.items[itemIndex - 1] = children
                    item.cascadingComponent?[itemIndex - 1] = cascadingComponent
                } else {
                    item.items.append(children)
                    item.cascadingComponent?.append(cascadingComponent)
                }
                
                // Reload the table view to reflect the changes.
                self.itemsTV.reloadData()
            }
        }
        
        // If editing, handle item rules to maintain form consistency.
        if isEdit {
            self.viewModel.formBuilder.handleItemRules(
                self.viewModel.formBuilder.sectionObjects[sectionIdx].items[0],
                excludedView: isMyRequestFlag ? .RequestDetails : .TaskDetails,
                removeAnswer: false
            )
        }
    }
    
    /// Handles the dismissal of the table's bottom sheet.
    func didDismiss() {
        // Currently no action is needed when the bottom sheet is dismissed.
    }
}
