//
//  BackwardRequestDetailsView.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 04/09/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown
internal import MOLH

public struct BackwardDataSoruceTableModel {
    public var parentid: String?
    public var rowIndex: String?
    public var relatedItems: [BackwardViewForm]?
    public var title: String?
    public var expanded: Bool? = false
}


//protocol HandlePayloadMethods {
//    func handleActionPayload(actionId: String,payload: [[String:Any]])
//}

public class BackwardRequestDetailsView: BaseWireFrameDynamicForm<RequestDetailsViewModel> {
    // MARK: - IBOutlets
    @IBOutlet weak var bgTopView: UIView!
    @IBOutlet weak var bgBottomView: UIView!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var chatTxtV: UITextView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var attachmentCV: UICollectionView!
    
    // MARK: - Variables
    
    public let dropDown = DropDown()
    public var commentID: String = ""
    public var id = ""
    public var isMyRequestFlag = false
    public var isFromNotifications = false
    public var actionCommentText = ""
    public var dataSourceTableArray: [BackwardDataSoruceTableModel] = []
    public var newFormWithTable: [BackwardViewForm]?
    public var arrayOfAttachment: [ModelUploadedMedia] = [] {
        didSet{
            self.attachmentCV.reloadData()
        }
    }
    
    // MARK: - Functions
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        create()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.removeBackButtonTitle()
        view.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        itemsTV.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        registerCells()
        if isMyRequestFlag{
            navigationItem.title = "Request Details".localized
            viewModel.getBackwardRequestDetails(id: id)
        }else{
            navigationItem.title = "Task Details".localized
            viewModel.getBackwardTaskDetails(id: id)
        }
        //set selectedTabId = 3 if we have comment id
        if commentID != "" {
            viewModel.selectedTabId.accept(3)
            //            self.itemsTV.scrollToBottom()
            scrollToIndexPath()
        }else {
            viewModel.selectedTabId.accept(1)
        }
        
    }
    public func scrollToIndexPath() {
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
    public func filterDuplicates(_ array: [BackwardViewForm]) -> [BackwardViewForm] {
        var uniqueForms: [BackwardViewForm] = []
        var seenParentIds: Set<String> = []
        
        for form in array {
            // Check if this form's parent id and row index combination has been seen before
            let formIdentifier = "\(form.parentId ?? "")_\(form.rowIndex)"
            
            // Check if the parentId is nil or if this form's parent id and row index combination has been seen before
            if form.parentId == nil || !seenParentIds.contains(formIdentifier) {
                // If not seen before, add it to the unique forms
                uniqueForms.append(form)
                
                // Add the parent id and row index combination to the set of seen values
                seenParentIds.insert(formIdentifier)
            }
//            if !seenParentIds.contains(formIdentifier) && form.properties?.defaultAnswer != nil{
//                uniqueForms.append(form)
//                seenParentIds.insert(formIdentifier)
//            }
        }
        
        return uniqueForms
    }
    
    public func create() {
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        chatTxtV.text = "Add discussion comment....".localized
        chatTxtV.textColor = .slate_grey
        shadowView.addNormalShadow()
    }
    
    public func loadTableRows() {
        if let viewForm = viewModel.backwardDetails.value?.viewForm {
            for form in viewForm {
                if let rowIndex = form.rowIndex, let parentId = form.parentId {
                    // Filter fields with the same parent ID and row index
                    let filteredFields = viewForm.filter { $0.rowIndex == rowIndex && $0.parentId == parentId }
                    
                    // Check if it's a new parent ID or a new combination of parent ID and row index
                    let isNewParentId = dataSourceTableArray.firstIndex { $0.parentid == parentId } == nil
                    let isNewCombination = dataSourceTableArray.firstIndex { $0.parentid == parentId && $0.rowIndex == rowIndex } == nil
                    
                    // Append to dataSourceTableArray if it's a new parent ID or a new combination
                    if isNewParentId || isNewCombination {
                        let label = isArabic() ? viewForm.first(where: { $0.id == parentId })?.properties?.localization?.ar?.label ?? "" : viewForm.first(where: { $0.id == parentId })?.properties?.label ?? ""
                        dataSourceTableArray.append(BackwardDataSoruceTableModel(parentid: parentId, rowIndex: rowIndex, relatedItems: filteredFields,title: label))
                    }
                }
            }
        }
        self.newFormWithTable = filterDuplicates(viewModel.backwardDetails.value?.viewForm.value ?? [])
    }
    /// Configure listeners
    /// - Parameter viewModel: request details' viewModel
    override public func configure(with viewModel: RequestDetailsViewModel) {
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
        
        viewModel.selectedTabId.subscribe(onNext: { [unowned self]  (id) in
            
            if isMyRequestFlag {
                viewModel.arrOfSections = [.reqInfo, .oldActions_Dicussion]
            }else {
                if id == 1 {
                    viewModel.arrOfSections = [.empInfo, .reqInfo, .oldActions_Dicussion, .takeAction]
                    
                }else{
                    viewModel.arrOfSections = [.empInfo, .reqInfo, .oldActions_Dicussion]
                }
            }
            
            if id == 3 {
                if commentID != "" {
                    self.scrollToIndexPath()
                }else {
                    self.itemsTV.scrollToBottom()
                }
            }
            self.itemsTV.reloadData()
        }).disposed(by: self.disposeBag)
        
        
        viewModel.backwardDetails.subscribe(onNext: { [unowned self]  (details) in
            if let _ = details {
                self.viewModel.getChat()
                loadTableRows()
                //                self.newFormWithTable = details?.viewForm ?? []
                self.itemsTV.reloadData()
            }
        }).disposed(by: self.disposeBag)
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateUI()
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
        itemsTV.register(ChatTVcell.cerqel_nib, forCellReuseIdentifier: ChatTVcell.cerqel_identifier)
        attachmentCV.register(ChatFooterAttachmentCVcell.cerqel_nib, forCellWithReuseIdentifier: ChatFooterAttachmentCVcell.cerqel_identifier)
        itemsTV.register(NewChatTVCell.cerqel_nib, forCellReuseIdentifier: NewChatTVCell.cerqel_identifier)
        itemsTV.register(TableDetailsRowTVCell.cerqel_nib, forCellReuseIdentifier: TableDetailsRowTVCell.cerqel_identifier)
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
//        itemsTV.register(UploadMediaTVcell.cerqel_nib, forCellReuseIdentifier: UploadMediaTVcell.cerqel_identifier)
        itemsTV.register(ActionCommentTVcell.cerqel_nib, forCellReuseIdentifier: ActionCommentTVcell.cerqel_identifier)
        itemsTV.register(EmptyPreviousActionsTVcell.cerqel_nib, forCellReuseIdentifier: EmptyPreviousActionsTVcell.cerqel_identifier)
        
        itemsTV.register(TableControlValueTVcell.cerqel_nib, forCellReuseIdentifier: TableControlValueTVcell.cerqel_identifier)
        itemsTV.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
        
    }
    
    // MARK: - IBActions
    
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

extension BackwardRequestDetailsView: HandlePayloadMethods {
    
    /// Dynamic actions delegate method
    /// - Parameters:
    ///   - actionId: dynamic action id
    ///   - payload: collected payload
   public func handleActionPayload(actionId: String,payload: [[String : Any]]) {
        var newArr: [ModelUploadedMediaFormPayload] = []
        if self.viewModel.arrayOfAttachmentsinAction.value.count > 0{
            for item in self.viewModel.arrayOfAttachmentsinAction.value {
                newArr.append(ModelUploadedMediaFormPayload.init(item: item))
            }
        }
        let actionIndex = viewModel.backwardDetails.value?.actions?.firstIndex(where: {$0.id == actionId}) ?? 0
        viewModel.executeAction(payload: payload,actionId: actionId, comment: self.actionCommentText, statusMessage: viewModel.backwardDetails.value?.actions?[actionIndex].actionTakenLabel ?? "Submitted".localized)
    }
}

extension BackwardRequestDetailsView: Popup {
    public func popup() {
        navigationController?.popViewController(animated: true)
    }
}
extension BackwardRequestDetailsView: UITableViewDelegate, UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrOfSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel.arrOfSections[section] {
        case .oldActions_Dicussion:
            if viewModel.selectedTabId.value == 1 { // Derails Tab
                if viewModel.backwardDetails.value?.viewFromMobile ?? false{
                    return  self.newFormWithTable?.count ?? 0
                    
                }
                else{
                    return 1
                }
                
            }else if viewModel.selectedTabId.value == 2 {
                if let arr = viewModel.backwardDetails.value?.previousActions, arr.count > 0 {
                    return arr.count
                }else {
                    return 1
                }
            }
            else {//Discussion Tab
                if viewModel.chatList.value?.count != 0 {
                    return viewModel.chatList.value?.count ?? 0
                } else {
                    return 1
                }
            }
            
        case .takeAction:
            return 2
        default:
            return 1
            
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.arrOfSections[indexPath.section] {
        case .empInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmpInfoTVC.cerqel_identifier, for: indexPath) as! EmpInfoTVC
            cell.configure(viewModel.backwardDetails.value?.employee, status: viewModel.backwardDetails.value?.status)
            return cell
            
        case .reqInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReqInfoTVC.cerqel_identifier, for: indexPath) as! ReqInfoTVC
            var status: Status?
            if isMyRequestFlag {
                status = viewModel.backwardDetails.value?.status
            }else {
                status = nil
            }
            cell.configure(icon: viewModel.backwardDetails.value?.serviceImage,
                           name: viewModel.backwardDetails.value?.serviceName,
                           id: viewModel.backwardDetails.value?.requestOrder,
                           department: viewModel.backwardDetails.value?.employee?.department,
                           pendingOn: viewModel.backwardDetails.value?.requestPendingOn?.name,
                           status: status,
                           date: viewModel.backwardDetails.value?.createdDate, isMyReqFlag: isMyRequestFlag)
            return cell
            
        case .oldActions_Dicussion:
            
            if viewModel.selectedTabId.value == 1  { // Details Tab
                //                itemsTV.isScrollEnabled = true
                containerView.isHidden = true
                if newFormWithTable?[indexPath.row].properties?.isVisibleInViewMode ?? false {
                    if newFormWithTable?[indexPath.row].type == "FileUpload" {
                        let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlAttachmentsTVcell.cerqel_identifier, for: indexPath) as! ActionControlAttachmentsTVcell
                        cell.configure(properties: newFormWithTable?[indexPath.row].properties)
                        cell.mediaTapped = {[weak self] id in
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
                        return cell
                    } else {
                        let emptyCell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                        emptyCell.config(customColor: true)
                        if self.dataSourceTableArray.count > 0 && newFormWithTable?[indexPath.row].parentId != nil {
                            // draw table here
                            let parentId = newFormWithTable?[indexPath.row].parentId
                            let rowIdx = newFormWithTable?[indexPath.row].rowIndex
                            if let obj = dataSourceTableArray.first(where: { $0.parentid == parentId && $0.rowIndex == rowIdx }) {
                                let cell = tableView.dequeueReusableCell(withIdentifier: TableDetailsRowTVCell.cerqel_identifier, for: indexPath) as! TableDetailsRowTVCell
                                cell.downloadMediaTapped = { [weak self] id in
                                    let url = "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Download/\(id)"
                                    self?.viewModel.downloadMedia(url: url) {[weak self] (imageDownloaded) in
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
//                                cell.config(item: obj )
//                                cell.expand = { [weak self] expand in
//                                    guard let `self` = self else { return }
//                                    cell.toggleExpantion(expand: expand) { [weak self] in
//                                        guard let `self` = self else { return }
//                                        let indexPath = IndexPath(row: indexPath.row, section: 0)
//                                        self.itemsTV.reloadRows(at: [indexPath], with: .none)
//                                    }
//                                }
                                cell.expand = { [weak self] expand in
                                    guard let `self` = self else { return }
                                    let index = obj.rowIndex
                                    self.dataSourceTableArray =  self.dataSourceTableArray.map({ dataSoruceTableModel in
                                        var item = dataSoruceTableModel
                                        if item.rowIndex == index {
                                            item.expanded?.toggle()
                                        }
                                        return item
                                    })
                                    self.itemsTV.reloadData()
                                }
                                return cell
                            }
                            return emptyCell
                            
                        }else if let _ = newFormWithTable?[indexPath.row].properties?.defaultAnswer?.defaultValue {
                            let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlTVcell.cerqel_identifier, for: indexPath) as! ActionControlTVcell
                            cell.configure(properties: newFormWithTable?[indexPath.row].properties)
                            return cell
                        }else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                            cell.config(customColor: true)
                            return cell
                        }
                    }
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: DetailsEmptyStateTVcell.cerqel_identifier, for: indexPath) as! DetailsEmptyStateTVcell
                    return cell
                }
                
            }else if viewModel.selectedTabId.value == 2 { // Previous Actions Tab
                //                itemsTV.isScrollEnabled = true
                containerView.isHidden = true
                if (viewModel.backwardDetails.value?.previousActions?.count ?? 0) > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: PreviousActionV2TVC.cerqel_identifier, for: indexPath) as! PreviousActionV2TVC
                    if let previousActions = viewModel.backwardDetails.value?.previousActions, previousActions.count > indexPath.row {
                        cell.configure(viewModel.backwardDetails.value?.previousActions?[indexPath.row])
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
            }else { //Discussion Tab
                containerView.isHidden = false
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
            
            
        case .takeAction:
            if isMyRequestFlag { // No actions in requests, only in tasks
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                return cell
            }
            else if viewModel.backwardDetails.value?.actions?.count ?? 0 > 0 { // actions array + comment + attachment
              if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ExecuteActionTVcell.cerqel_identifier, for: indexPath) as! ExecuteActionTVcell
                    cell.configure(actions: viewModel.backwardDetails.value?.actions)
                    cell.didMoreButtonPressed = {[weak self] actions in
                        guard let `self` = self else {return}
                        self.viewModel.showActionsListBottomSheet()
                    }
                    cell.didFirstButtonPressedClosure = {[weak self] action in
                        guard let `self` = self else {return}
                        self.viewModel.presentCommentBottomSheet(action: action)
                        
                    }
                    
                    cell.didSecondButtonPressedClosure = {[weak self] action in
                        guard let `self` = self else {return}
                        self.viewModel.presentCommentBottomSheet(action: action)
                    }
                    return cell
                }else{
                    //Attachment
                    let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                    return cell
                }
                
                
            }else if viewModel.backwardDetails.value?.isReopenAllowed ?? false{ // reopen action + comment + attachment
               if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ExecuteActionTVcell.cerqel_identifier, for: indexPath) as! ExecuteActionTVcell
                    cell.didMoreButtonPressed = {[weak self] actions in
                        guard let `self` = self else {return}
                        self.viewModel.showActionsListBottomSheet()
                    }
                    cell.didFirstButtonPressedClosure = {[weak self] action in
                        guard let `self` = self else {return}
                        self.viewModel.presentCommentBottomSheet(action: action)
                    }
                    
                    cell.didSecondButtonPressedClosure = {[weak self] action in
                        guard let `self` = self else {return}
                        self.viewModel.presentCommentBottomSheet(action: action)
                    }
                    
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                    return cell
                }
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
                return cell
            }
            
        default: return UITableViewCell()
            
        }
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.arrOfSections[section] {
        case .oldActions_Dicussion:
            return 60
        case .takeAction:
            return 48
        default:
            return 0
            
        }
    }
    
    public  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.arrOfSections[section] {
            
        case .oldActions_Dicussion:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTabsTVcell.cerqel_identifier) as! DetailsTabsTVcell
            cell.configure(selection: viewModel.selectedTabId.value, myRequest: isMyRequestFlag)
            cell.didChooseTab = { btn in
                self.viewModel.selectedTabId.accept(btn)
                self.commentID = ""
            }
            return cell
        case .takeAction:
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier) as! EmptyTVcell
            returnedView.backgroundColor = .clear
            
            if let actions = viewModel.backwardDetails.value?.actions, !actions.isEmpty {
                return returnedView
            }else {
                return cell
            }
            
            
            
        default:
            return nil
            
        }
    }

}


extension BackwardRequestDetailsView {
    func sendMessage(txt: String) {
        var chatMsg = txt
        if chatMsg == "Add discussion comment....".localized{
            chatMsg = ""
        }
        if viewModel.arrayOfChatAttachments.value.count > 0{
            var newArr: [ModelUploadedMediaFormPayload] = []
            for item in viewModel.arrayOfChatAttachments.value{
                newArr.append(ModelUploadedMediaFormPayload.init(item: item))
            }
            if chatMsg.count > 200{
                self.viewModel.errorsSubject.onNext(BaseError.other(title: "The maximun length of letters are 200".localized))
                return
            }
            self.chatTxtV.resignFirstResponder()
            self.chatTxtV.text.removeAll()
            self.viewModel.sendComment(message: chatMsg, attachment: newArr.toJSON())
            
        }else{
            guard !chatMsg.isEmpty else {
                return
            }
            
            if chatMsg.count > 200{
                self.viewModel.errorsSubject.onNext(BaseError.other(title: "The maximun length of letters are 200".localized))
                return
            }
            
            self.chatTxtV.resignFirstResponder()
            self.chatTxtV.text.removeAll()
            self.viewModel.sendComment(message: chatMsg, attachment: nil)
        }
    }
    
    func sendAttachment() {
        self.cerqel_openMediaMenu()
        
    }
    
    func didRemoveAttachment(idx: Int) {
        var arr = self.viewModel.arrayOfChatAttachments.value
        arr.remove(at: idx)
        self.viewModel.arrayOfChatAttachments.accept(arr)
    }
    
}

extension BackwardRequestDetailsView: UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        var fileSize : Double = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = attr[FileAttributeKey.size] as! Double
            
        } catch {
        }
        
        if ((fileSize) / 1024 / 1024) > 5{
            self.viewModel.errorsSubject.onNext(BaseError.other(title: "Can't upload Media Size is > 5 MB".localized))
            return
            
        }
        self.viewModel.uploadMedia(mediaImg: nil, fileUrl: url)
        
    }
    
    //    Method to handle cancel action.
    public  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
    }
    
    public  func showWithdrawAller() {
        let alertVC = UIAlertController(title: "Withdraw Request".localized, message: ("Are you sure you want to withdraw the request?".localized), preferredStyle: .alert)
        let ok = UIAlertAction(title: " Withdraw Request ".localized, style: .destructive, handler: { (alertAction) in
            self.viewModel.doWithdrawAction(requestId: self.viewModel.backwardDetails.value?.requestOrder ?? "")
        })
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertVC.addAction(ok)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension BackwardRequestDetailsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                print("WE HAVE IMAGE !!!! 🚀")
                let imgData = NSData(data: photo.jpegData(compressionQuality: 0.5)!)
                let imageSize: Int = imgData.count / 1024 / 1024
                print("actual size of image in MB: \(imageSize)")
                
                if imageSize > 5{
                    self.viewModel.errorsSubject.onNext(BaseError.other(title: "Can't upload Media Size is > 5 MB".localized))
                    return
                }
                self.viewModel.uploadMedia(mediaImg: photo, fileUrl: nil)
                
            }
            
        }
    }
}

extension BackwardRequestDetailsView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Add discussion comment....".localized{
            textView.text.removeAll()
            textView.textColor = .DarkBlack
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0{
            textView.text = "Add discussion comment....".localized
            textView.textColor = .slate_grey
        }
        return true
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
    }
    
}


extension BackwardRequestDetailsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    public  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAttachment.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatFooterAttachmentCVcell.cerqel_identifier, for: indexPath) as! ChatFooterAttachmentCVcell
        cell.configure(arrayOfAttachment[indexPath.row])
        cell.removeBtnTapped = {
            self.didRemoveAttachment(idx: indexPath.row)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.7
        return CGSize(width: width, height: 36)
    }
    
}

