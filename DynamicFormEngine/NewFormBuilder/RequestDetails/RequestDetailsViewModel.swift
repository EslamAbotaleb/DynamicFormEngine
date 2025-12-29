//
//  RequestDetailsViewModel.swift
//
//
//  Created by Abdallah Elmahlawy on 12/30/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
public import RxCocoa
public import RxSwift
import Photos
import SwiftUI
import DropDown
import DynamicFormEngine

public enum RequestDetailsSections {
    case oldActions_Dicussion
    case empInfo
    case reqInfo
    case requestTabs
    case takeAction
    case sectionDetails
}

public class RequestDetailsViewModel: BaseVM {
    
    // MARK: - Variables
    public var router: CerqelRouterManager
    private let service: cerqel_NetworkServiceDynamicForm
    private let disposeBag = DisposeBag()
    public var details: BehaviorRelay<ModelRequestDetailsData?> = BehaviorRelay(value: nil)
    public var backwardDetails: BehaviorRelay<BackwardModelRequestDetailsData?> = BehaviorRelay(value: nil)
    public var formSummaryList: BehaviorRelay<[Field]?> = BehaviorRelay(value: nil)
    public var reqIdForApprover = ""
    public var messageSentSuccessfully: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    public var actionTakenSuccessfully: BehaviorRelay<(Bool,String)> = BehaviorRelay(value: (false,"Submitted".localized))
    public var requestReopenedSuccessfully: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    public var requestWithdrawedSuccessfully: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    public var chatList: BehaviorRelay<[ModelDicussionMessageData]?> = BehaviorRelay(value: nil)
    public var view: UIViewController
    public var arrOfSections: [RequestDetailsSections] = [.empInfo, .reqInfo, .requestTabs]
    public var arrOfSectionsForTab1: [RequestDetailsSections] = [.empInfo, .reqInfo, .requestTabs]
    public var arrOfSectionsForSummary: [RequestDetailsSections] = []
    public let dropDown = DropDown()
    
    /// 1 -> Details, 2-> Actions, 3-> Discussions
    public var selectedTabId: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    
    public var arrayOfChatAttachments: BehaviorRelay<[ModelUploadedMedia]> = BehaviorRelay(value: [])
    public var arrayOfAttachmentsinAction: BehaviorRelay<[ModelUploadedMedia]> = BehaviorRelay(value: [])
    public var requestId: String
    public var commentSubmeted: DynamicObjects<String> = DynamicObjects("")
    public var userMail: DynamicObjects<String> = DynamicObjects("")
    public var actionName: DynamicObjects<[ListModel]> = DynamicObjects([ListModel()])
    public var selecteActionName: DynamicObjects<ListModel> = DynamicObjects(ListModel())
    public var performCommentAction: ((Action, String) -> ())?
    public var selectedUser: DynamicObjects<UserEntity> = DynamicObjects(UserEntity())
    
    public var isWithdrawal: DynamicObjects<Bool?> = DynamicObjects(nil)
    public var isEditable: BehaviorRelay<Bool?> = BehaviorRelay(value: false)
    //Bottom Action Buttons and Message Status (IsCanEdit,Alert Message,IsButtonsDimmed)
    public var isEditableDimmedActions: BehaviorRelay<(Bool?,String?,Bool?)> = BehaviorRelay(value: (false,"",false))
    public var editRequestTitle: DynamicObjects<[ListModel]> = DynamicObjects([ListModel()])
    public var selectedRequestAction: DynamicObjects<ListModel> = DynamicObjects(ListModel())
    public var requestWithDrawId: DynamicObjects<String?> = DynamicObjects("")
    public var id = ""
    public var isMyRequestFlag = false

    public var formBuilder = FormBuilder.shared
    public  var rowIndices: [Int] = []

    public init(_ service: cerqel_NetworkServiceDynamicForm, requestId: String, view: UIViewController, router: CerqelRouterManager) {
        self.service = service
        self.requestId = requestId
        self.view = view
        self.router = router
    }
    
    public func presentCommentBottomSheet(action: Action) {
        guard let actionCode = action.actionCode?.lowercased() else { return }
        
        let commentBottomSheetActions = ["sendback", "approve", "reject"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            switch actionCode {
//            case "delegated":
//                self.presentDelegateBottomSheet()
            case let code where commentBottomSheetActions.contains(code):
                self.showCommentBottomSheet(
                    title: action.label ?? "",
                    isCommentRequired: action.isCommentRequired ?? false,
                    action: action
                )
                
            case "withdraw":
                self.showDeleteBottomSheet(for: self.selecteActionName.value)
            case "edit":
                self.showEditRequestBottomSheet(for: self.selecteActionName.value)
            default:
                break
            }
        }
    }
    
    // MARK: - Functions
    public func showCommentBottomSheet(title: String, isCommentRequired: Bool, action: Action) {
        // Create the comment item
        let commentItem = AddCommentItem(
            mainTitle: title,
            isCommentRequired: isCommentRequired,
            didCommentSent: { [weak self] commentSent in
                guard let self = self, let commentSent = commentSent else { return }
                self.commentSubmeted.value = commentSent
                self.actionPressed(action: action)
            }
        )
        
        // Initialize the view controller for the bottom sheet
        let commentViewController = CerqelView.controller(
            controller: AddCommentBottomSheet.self,
            viewModel: AddCommentViewModel.self,
            item: commentItem
        )
        
        // Configure the sheet view controller
        let sheetViewController = SheetViewController(controller: commentViewController, sizes: [.fixed(370)])
        sheetViewController.handleColor = .clear
        sheetViewController.topCornersRadius = 12
        sheetViewController.overlayColor = UIColor(rCerqel: 34, gCerqel: 16, bCerqel: 59, aCerqel: 0.5)
        sheetViewController.dismissOnBackgroundTap = true
        
        // Present the sheet
        router.present(vc: sheetViewController)
    }
    
    private func setEditRequestDataSource(){
        editRequestTitle.value = [
            ListModel(id: "0",name: "Edit".localized, isSelected: false, icon: "", isEditable: isEditable.value ?? false),
            ListModel(id: "1",name: "Withdraw".localized, isSelected: false, icon: "", isWithdrawal: isWithdrawal.value ?? false )
        ]
        
    }
    
    
    /// Displays an alert to confirm withdrawal of the request.
    func showWithdrawAller() {
        let alertVC = UIAlertController(
            title: "Withdraw Request".localized,
            message: "Are you sure you want to withdraw the request?".localized,
            preferredStyle: .alert
        )
        
        // "Withdraw Request" action
        let withdrawAction = UIAlertAction(
            title: "Withdraw Request".localized,
            style: .destructive
        ) { _ in
            self.doWithdrawAction(requestId: self.details.value?.requestOrder ?? "")
        }
        
        // "Cancel" action
        let cancelAction = UIAlertAction(
            title: "Cancel".localized,
            style: .cancel,
            handler: nil
        )
        
        alertVC.addAction(withdrawAction)
        alertVC.addAction(cancelAction)
        
        // Present the alert to the user.
        view.present(alertVC, animated: true, completion: nil)
    }
    
    func showEditRequestBottomSheet(for item: ListModel) {
        handleEditRequestAction(item: item)
    }
    
    func showDeleteBottomSheet(for item: ListModel) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            self?.router.presentbottomSheet(fromProfile: false, controller: CerqelDeleteSheet.self, viewModel: FileActionsViewModel.self, item: DeleteItem({
//                self?.router.dismissCurrentController(completion: {
//                    self?.doWithdrawAction(requestId: self?.details.value?.id ?? "")
//                })
//            }, "Withdraw Request".localized, "Are you sure, you want to withdraw your request?".localized,  "withDrawAction", "YES".localized, "NO".localized, redButton))
//        }
    }
    
    private func handleEditRequestAction(item: ListModel){
        self.selectedRequestAction.value = item
            router.push(vc: DynamicSharedRouterDynamicForm.goTo(viewName: .formViewController(serviceId: self.requestWithDrawId.value ?? "", actionId: nil, buttonId: nil, isEditable: true, requestId: "")))
    }
        
    func checkIfAllFieldsHidden (parentID: String) -> Bool {
        return false
    }
    
    func handleApproverAdditionalData() {
        reqIdForApprover = self.details.value?.id ?? ""
        router.push(vc: DynamicSharedRouterDynamicForm.goTo(viewName: .formViewController(serviceId:  self.details.value?.taskId ?? "", actionId: nil, buttonId: nil, isEditable: false, isApproverForm: true, requestId: self.reqIdForApprover)))
    }
    
    func presentDelegateBottomSheet(action: Action) {
        let vc = UsersViewController(selectedItem: { user in
            if let user = user {
                self.selectedUser.value = user
                self.userMail.value = user.mail ?? ""
                self.actionPressed(action: action)
            }
        },currentselectedItems: [selectedUser.value])
        vc.modalPresentationStyle = .overFullScreen //or .overFullScreen for transparency
        view.present(vc, animated: true)
        
    }
    
    
    
    func setActionDateSource() {
        guard let actions = self.details.value?.actions else { return }
        
        let iconMapping: [String: String] = [
            "sendback": "sendbackIconForActions.pdf",
            "delegated": "delegateIconForActions.pdf",
            "approve": "RequestApprovedNotificationIcon.pdf",
            "reject": "RequestRejectedNotificationIcon.pdf",
            "edit": "editIconForActions.pdf",
            "withdraw": "withdrawIconForActions.pdf"
        ]
        
        var actionModels: [ListModel] = actions.compactMap { action in
            let icon = iconMapping[action.actionCode?.lowercased() ?? ""] ?? ""
            
            return ListModel(
                id: action.id,
                name: action.label,
                isSelected: false,
                icon: icon,
                actionCode: action.actionCode,
                actionFormId: action.actionFormId,
                isCommentRequired: action.isCommentRequired,
                isDimmed: false
            )
        }
        
        // Call the function to remove the elements
        removeFirstAndSecondElements(from: &actionModels)
        
        self.actionName.value = actionModels
    }
    
    // Function to remove first and second elements from the array
    func removeFirstAndSecondElements(from array: inout [ListModel]) {
        guard array.count > 1 else { return }
        array.remove(at: 1)
        array.remove(at: 0)
    }
    
    func showActionsListBottomSheet(){
//        router.presentbottomSheet(fromProfile: false, controller: BaseList.self, viewModel: BaseListBottomSheetViewModel.self, item: BaseListItem(list: self.actionName.value, title: "Actions".localized, type: .action, isSingleSelection: true, selectedItem: selectedAction, multiSelectedItems: multiSelectedItems))
    }
    
    func multiSelectedItems(item: [ListModel]){}
    
    
    func selectedAction(item: ListModel) {
        self.selecteActionName.value = item
        guard let actionCode = item.actionCode?.lowercased() else { return }
        
        switch actionCode {
        case "approve", "reject":
            handleActions(for: item, actionCode: actionCode)
        case "delegated":
            handleDelegateAction(for: item)
        case "sendback":
            handleSendBackAction(for: item)
        case "edit":
            showEditRequestBottomSheet(for: item)
        case "withdraw":
            showDeleteBottomSheet(for: item)
        default:
            break
        }
    }
    
    func successSheetMessage() -> SuccessMessageResponse{
        switch self.selecteActionName.value.actionCode?.lowercased() ?? "" {
        case "sendback":
            return SuccessMessageResponse(message: "Your task has been sent back successfully".localized)
        case "delegated":
            return SuccessMessageResponse(message: "Delegated Successfully".localized, description: "Our task has been delegated to ".localized + (selectedUser.value.name ?? "") + " " + "Successfully".localized)
        default:
            return SuccessMessageResponse(message: "Request Submitted".localized, description: "Request has been submitted successfully.".localized)
        }
    }
    
    private func handleActions(for item: ListModel, actionCode: String) {
        guard let actions = self.details.value?.actions else { return }
        guard let tappedAction = actions.first(where: { $0.actionCode?.lowercased() == actionCode }) else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.showCommentBottomSheet(
                title: item.name ?? "",
                isCommentRequired: item.isCommentRequired ?? false,
                action: tappedAction
            )
        }
    }
    
    func navigateToDelegator(action: Action) {
        router.pushTo(controller: DelegatorVC.self, viewModel: DelegateActionViewModel.self, item: DelegateItem(action: action, taskId:self.details.value?.taskId,successCallBack: { [self] in
            if( self.isMyRequestFlag){
                self.getRequestDetails(id: self.id)
            }
            else {
                self.getTaskDetails(id: id)
            }
        }))
    }
    
    func navigateToSendBack(action: Action) {
        router.pushTo(controller: SendBackVC.self, viewModel: SendBackViewModel.self, item: SendBackItem(action: action, sendBackId: self.details.value?.id, taskId: self.details.value?.taskId,successCallBack: { [self] in
            if( self.isMyRequestFlag){
                self.getRequestDetails(id: self.id)
            }
            else {
                self.getTaskDetails(id: id)
            }
        }))
    }
    
    private func handleDelegateAction(for item: ListModel) {
        guard let actions = self.details.value?.actions else { return }
        guard let delegateAction = actions.first(where: { $0.actionCode?.lowercased() == "delegated" }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.navigateToDelegator(action: delegateAction)
        }
    }
    
    private func handleSendBackAction(for item: ListModel) {
        guard let actions = self.details.value?.actions else { return }
        guard let delegateAction = actions.first(where: { $0.actionCode?.lowercased() == "sendback" }) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.navigateToSendBack(action: delegateAction)
        }
    }
    

    
    /// Getting request details
    /// - Parameter id: current request id
    func getRequestDetails(id: String) {
//        self.loadingSubject.onNext(.show)
//            self.service.load(cerqel_CodableResponseObject<ModelRequestDetailsData>(action: cerqel_BasicActionDynamicForm.requestDetails(id: id))).subscribe(onNext: {
//                [weak self] (response) in
//                self?.loadingSubject.onNext(.hide)
//                
//                if let details = response.item?.data{
//                    self?.details.accept(details)
//                    self?.isEditable.accept(details.isEditable)
//                    self?.isEditableDimmedActions.accept((details.isEditable,"",false))
//                    self?.isWithdrawal.value = details.isWithdrawal
//                    self?.requestWithDrawId.value = details.id
//                    self?.setEditRequestDataSource()
//                    self?.setActionBtns()
//                }
//            },onError: { (error) in
//                self.errorsSubject.onNext(error)
//                self.loadingSubject.onNext(.hide)
//                
//            }).disposed(by: self.disposeBag)
    }
    
    
    func getBackwardRequestDetails(id: String) {
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObjectDynamicForm<BackwardModelRequestDetailsData>(action: cerqel_BasicActionDynamicForm.requestDetails(id: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            
            if let details = response.item?.data{
                self?.backwardDetails.accept(details)
                self?.isEditable.accept(details.isEditable)
                self?.isWithdrawal.value = details.isWithdrawal
                self?.requestWithDrawId.value = details.id
                self?.setEditRequestDataSource()
            }
        },onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }
    

    /// Getting task details
    /// - Parameter id: current task id
    func getTaskDetails(id: String) {
//        self.loadingSubject.onNext(.show)
//        self.service.load(cerqel_CodableResponseObject<ModelRequestDetailsData>(action: cerqel_BasicActionDynamicForm.taskDetails(id: id))).subscribe(onNext: {
//            [weak self] (response) in
//            self?.loadingSubject.onNext(.hide)
//            if let details = response.item?.data {
//                self?.details.accept(details)
//                self?.isEditableDimmedActions.accept((details.isTaskEditable,"",false))
//                self?.setActionDateSource()
//                self?.setActionBtns()
//            }
//        },onError: { (error) in
//            self.errorsSubject.onNext(error)
//            self.loadingSubject.onNext(.hide)
//            
//        }).disposed(by: self.disposeBag)
    }
    
    /// Getting task details
    /// - Parameter id: current task id
    func getBackwardTaskDetails(id: String) {
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObjectDynamicForm<BackwardModelRequestDetailsData>(action: cerqel_BasicActionDynamicForm.taskDetails(id: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            if let details = response.item?.data {
                self?.backwardDetails.accept(details)
                self?.setActionDateSource()
            }
        },onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }
    
    
    
    /// Getting chat
    func getChat() {
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObjectDynamicForm<ModelDicussionMessageData>(action: cerqel_BasicActionDynamicForm.fetchRequestChat(id: details.value?.id ?? ""))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            if let details = response.item?.arrData{
                self?.chatList.accept(details)
            }
        },onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
        }).disposed(by: self.disposeBag)
    }
    /// Send chat message
    /// - Parameters:
    ///   - message: user's message in chat
    ///   - attachment: attached files in chat
    func sendComment(message: String?, attachment: [[String: Any]]?) {
        self.loadingSubject.onNext(.show)
        var pay: [String: Any] = [:]
        pay["requestId"] = self.details.value?.id
        if let txt = message{
            pay["comment"] = txt
        }
        if let att = attachment{
            pay["attachments"] = att
        }
        self.service.load(cerqel_CodableResponseObjectDynamicForm<Bool>(action: cerqel_BasicActionDynamicForm.addChatComment(payload: pay))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            
            if let d = response.item?.data, d{
                self?.arrayOfChatAttachments.accept([])
                self?.messageSentSuccessfully.accept(d)
            }
        },onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
        }).disposed(by: self.disposeBag)
    }
    /// Uploading attachments
    /// - Parameters:
    ///   - mediaImg: image uploaded
    ///   - fileUrl: file url uploaded
    func uploadMedia(mediaImg: UIImage?, fileUrl: URL?){
        self.loadingSubject.onNext(.show)
        
        cerqel_NormalAPIcallDynamicForm().uploadFile(action: .uploadFile(isPublic: false, serviceType: 0), photo: mediaImg, fileUrl: fileUrl, onCompletion: { (result) in
            if let res = result?["result"] as? [[String: Any]], let fir = res.first, let media = ModelUploadedMedia(JSON: fir), let id = media.id{
                if self.selectedTabId.value == 1{
                    var arr = self.arrayOfAttachmentsinAction.value
                    arr.append(media)
                    self.arrayOfAttachmentsinAction.accept(arr)
                }else{
                    var arr = self.arrayOfChatAttachments.value
                    arr.append(media)
                    self.arrayOfChatAttachments.accept(arr)
                }
            }
            self.loadingSubject.onNext(.hide)
        }, onError:  { (error) in
            self.loadingSubject.onNext(.hide)
            self.errorsSubject.onNext(BaseError.other(title: error?.localizedDescription ?? ""))
        })
    }
    /// Execute action in task details
    /// - Parameters:
    ///   - payload: collected payload
    ///   - actionId: clicked action button id
    ///   - attachments: uploaded attachments
    ///   - comment: approver's comment
    func executeAction(payload: [[String:Any]]?,actionId: String, comment: String, statusMessage: String) {
        
        self.loadingSubject.onNext(.show)
        var pay: [String: Any] = [:]
        pay["actionId"] = actionId
        pay["taskId"] = self.details.value?.taskId
        var internalPayload: [[String: Any]] = []
        if let pload = payload {
            internalPayload = pload
        }
        pay["pendingOnEmail"] = self.userMail.value
        pay["payload"] = ["payload":internalPayload,"comment":comment] as [String:Any]
        //        if let att = attachments{
        //            pay["attachments"] = att
        //
        //
        //        }
        
        self.service.load(cerqel_CodableResponseObjectDynamicForm<TakeActionResponse>(action: cerqel_BasicActionDynamicForm.executeAction(payload: pay))).subscribe(onNext: {
            [weak self] (response) in
            guard let `self` = self else {return}
            self.loadingSubject.onNext(.hide)
            if (response.success ?? false) {
                if let data = response.item?.data as? TakeActionResponse {
                    self.updateRequest(data: data, statusMessage: statusMessage)
                }  else if (response.success ?? false) {
                    self.actionTakenSuccessfully.accept((true,statusMessage))
                }
                //                if response.item?.data?.callUpdateRequest ?? false {
                //                    self.updateRequest(data: response.item?.data?.takeActionBody, statusMessage: statusMessage)
                //                }else {
                //                    self.actionTakenSuccessfully.accept((response.item?.data?.success ?? false, statusMessage))
                //                }
            }
        }, onError: {[weak self] (error) in
            guard let `self` = self else {return}
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    func updateRequest(data: TakeActionResponse?, statusMessage: String) {
        guard let data = data else {return}
        self.loadingSubject.onNext(.show)
        var pay: [String: Any] = [:]
        pay["requestId"] = data.requestId
        pay["statusCode"] = data.statusCode
        pay["pendingOn"] = data.pendingOn
        pay["isRequestCompleted"] = data.isRequestCompleted
        pay["bpmProcessId"] = data.bpmProcessId
        pay["isEditable"] = data.isEditable
        pay["isWithdrawal"] = data.isWithdrawal
        pay["messageId"] = data.messageId
        pay["itRequestId"] = data.itRequestId
        pay["isReopenAllowed"] = data.isReopenAllowed
        
        
        
        self.service.load(cerqel_CodableResponseObjectDynamicForm<Bool>(action: Dynamic_BasicActionDynamicForm.updateRequest(payload: pay))).subscribe(onNext: {
            [weak self] (response) in
            guard let `self` = self else {return}
            self.loadingSubject.onNext(.hide)
            AuthManagerDynamicForm.shared.isInboxRefreshRequired = true
            self.actionTakenSuccessfully.accept((true, statusMessage))
        }, onError: {[weak self] (error) in
            guard let `self` = self else {return}
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }
    
    func doReopenAction(requestId: String, comment: String) {
        self.loadingSubject.onNext(.show)
        var pay: [String: Any] = [:]
        pay["requestId"] = requestId
        pay["comment"] = comment
        
        self.service.load(cerqel_CodableResponseObjectDynamicForm<Bool>(action: cerqel_BasicActionDynamicForm.reopenRequest(payload: pay))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            self?.requestReopenedSuccessfully.accept(true)
            
            
        }, onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    func doWithdrawAction(requestId: String) {
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObjectDynamicForm<Bool>(action: cerqel_BasicActionDynamicForm.withdrawRequest(requestId: requestId))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            self?.router.dismiss()
            self?.requestWithdrawedSuccessfully.accept(true)
            
        }, onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    func successCallBack() {
        self.router.popBack()
    }
    
    func successBottomSheet () {
        let message: SuccessMessageResponse = successSheetMessage()
//        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: SuccessItem(successCallBack, message.message ?? "", message.description ?? ""))
    }
    
    /// Download attached image
    /// - Parameters:
    ///   - url: clicked attachment url
    ///   - completion: returning (downloaded or not)
    func downloadMedia(url: String, completion: @escaping(Bool)->Void) {
        self.loadingSubject.onNext(.show)
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer " + AuthManagerDynamicForm.shared.token,
                         forHTTPHeaderField: "Authorization")
        request.setValue(isArabic() ? "Ar" : "En",
                         forHTTPHeaderField: "LanguageCode")
        request.setValue("IOS",
                         forHTTPHeaderField: "Platform")
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8",
                         forHTTPHeaderField: "charset")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseData = data {
                let base64String = responseData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                if let decodedData = Data(base64Encoded: base64String, options: []) {
                    if let decodedImage = UIImage(data: decodedData) {
                        UIImageWriteToSavedPhotosAlbum(decodedImage, nil, nil, nil)
                        
                        self.loadingSubject.onNext(.hide)
                        completion(true)
                    }else {
                        completion(false)
                    }
                }
            }
        }.resume()
    }
    /// Download attached video
    /// - Parameters:
    ///   - url: clicked attachment url
    ///   - completion: returning (downloaded or not)
    func downloadVideo(url: String, completion: @escaping(Bool)->Void) {
        
        // set up your download task
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        
        request.setValue("Bearer " + AuthManagerDynamicForm.shared.token,
                         forHTTPHeaderField: "Authorization")
        request.setValue(isArabic() ? "Ar" : "En",
                         forHTTPHeaderField: "LanguageCode")
        request.setValue("IOS",
                         forHTTPHeaderField: "Platform")
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8",
                         forHTTPHeaderField: "charset")
        
        URLSession.shared.downloadTask(with: request) { (location, response, error) -> Void in
            
            // use guard to unwrap your optional url
            guard let location = location else { return }
            
            let num = Int.random(in: 0...1000)
            let fileName = String((url.lastPathComponent)) as NSString
            // Create destination URL
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsUrl.appendingPathComponent("\(fileName) \(num).mp4")
            
            
            do {
                
                try FileManager.default.moveItem(at: location, to: destinationURL)
                
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                    
                    // check if user authorized access photos for your app
                    if authorizationStatus == .authorized {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                if completed {
                                    
                                    self.loadingSubject.onNext(.hide)
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            }
                    }
                })
                
            } catch { print(error) }
            
        }.resume()
    }
    /// Download attached file
    /// - Parameters:
    ///   - url: clicked attachment url
    func downloadFile(url: String) {
        guard let url = URL(string: url) else {return}
        let num = Int.random(in: 0...1000)
        let fileName = String((url.lastPathComponent)) as NSString
        // Create destination URL
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName) \(num).pdf")
        //Create URL to the source file you want to download
        let fileURL = url
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url:fileURL)
        request.setValue("Bearer " + AuthManagerDynamicForm.shared.token,
                         forHTTPHeaderField: "Authorization")
        request.setValue(isArabic() ? "Ar" : "En",
                         forHTTPHeaderField: "LanguageCode")
        request.setValue("IOS",
                         forHTTPHeaderField: "Platform")
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8",
                         forHTTPHeaderField: "charset")
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    DispatchQueue.main.async {[weak self] in
                        guard let `self` = self else {return}
                        self.showToast(message: "Downloaded Successfully".localized, seconds: 3)
                    }
                    
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: [])
                                DispatchQueue.main.async {
                                    self.view.present(activityViewController, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
            self.loadingSubject.onNext(.hide)
        }
        
        task.resume()
    }
    
    
    /// Drawing toast message
    /// - Parameters:
    ///   - message: toast's message
    ///   - seconds: flash message timer
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        view.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true,completion: nil)
        }
    }
    
    func actionPressed(action: Action) {
        guard let id = action.actionFormId, !id.isEmpty else {
            self.executeAction(
                payload: nil,
                actionId: action.id ?? "",
                comment: self.commentSubmeted.value,
                statusMessage: action.actionTakenLabel ?? "Submitted".localized
                
            )
            return
        }
        performCommentAction?(action, id)
    }
    
    
    private func handleActionWithoutForm(_ action: Action) {
        let attachments = self.arrayOfAttachmentsinAction.value.map { ModelUploadedMediaFormPayload(item: $0) }
        
        if action.isCommentRequired == true && self.commentSubmeted.value.isEmpty {
            self.errorsSubject.onNext(BaseError.other(title: "Comment is Required".localized))
        } else if action.isAttachmentRequired == true && attachments.isEmpty {
            self.errorsSubject.onNext(BaseError.other(title: "Attachments are Required".localized))
        } else {
            self.executeAction(
                payload: nil,
                actionId: action.id ?? "",
                comment: self.commentSubmeted.value,
                statusMessage: action.actionTakenLabel ?? "Submitted".localized
                
            )
        }
    }
    
    func routerToSurvey(serviceId: String, requestOrder: String) {
//        router.presentbottomSheet(fromProfile: false, controller: FeedbackBottomSheetView.self, viewModel: FeedbackViewModel.self, item: SurveyItem(dismissPage,serviceId: serviceId, requestOrder: requestOrder))
    }
    
    func successBottomSheetServices(title : String){
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetWithNavigationLinkVC.self, viewModel: BottomSheetBaseViewModel.self, item: SuccessItem(dismissPage,  title,  "View All Services".localized))
    }
    
    func dismissPage(){
        self.router.dismiss()
        popToAllServices()
    }
    
    func popToAllServices() {
//        router.popToSpecialViewController(ofClass: AllServicesViewController.self, animated: true)
    }
    
    // Get Data From Json
    func getTaskDetailsFromJson() {
        getForm { responseJSON in
            guard let responseJSON = responseJSON else {
                return
            }
            self.handleFormJSON(responseJSON) { success in
                if !success {
                    //handle failure
                    return
                }
                
            }
        }
    }
    
    func getForm(completion: @escaping (JSON2?) -> Void) {
        if let path = Bundle.main.path(forResource: "details", ofType: "json") {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
                completion(nil)
                return
            }
            do {
                if let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON2 {
                    completion(response)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    public func handleFormJSON(_ formJSON: JSON2, completion: @escaping (Bool) -> Void) {
        
        if let res = formJSON["result"] as? [String: Any],
           let data = res["data"] as? [String: Any] {
            guard let formModel = ModelRequestDetailsData(JSON: data) else {
                completion(false)
                return
            }
            
            self.details.accept(formModel)
            self.isEditableDimmedActions.accept((self.details.value?.isTaskEditable ?? false,"",false))
            self.setActionDateSource()
//            self.setActionBtns()
            completion(true)
        }
    }
    
    
    // Handle Action Buttons
     func setActionBtnsInVM(){
        if self.formBuilder.requestModel.isTaskEditable ?? false { // if task ( Approver data ) is editable
            
            if (formBuilder.sectionObjects.count) > 0 {
                
                var resultArray: [FormViewModelItem]? = []
                
                for sectionObject in formBuilder.sectionObjects {
                    resultArray?.append(contentsOf: sectionObject.items)
//                    let currentItem = sectionObject.item
//                    if currentItem?.type == .Section {
//                        resultArray?.append(contentsOf: sectionObject.items)
//                    } else {
//                        guard let item = sectionObject.item else {continue}
//                        resultArray?.append(item)
//                    }
                }
                
                
                for obj in resultArray ?? [] { // loop on all fields
                    // if u got only just one field is ediable, required & have no value
                    // Then first two actions will be dimmed & the alert message appears with: (In order to take action, please, Click Here to add the required data first.)
                    if (obj.field?.visibilityPermissions?.contains("Edit") ?? false) &&
                        (obj.field?.properties?.required ?? false) &&
                        obj.answer == nil {
                        // make all actions dimmed and Set the alert messgae
                        self.isEditableDimmedActions.accept((true,"In order to take action, please, Click Here to add the required data first.".localized,true))
                        return
                    }
                }
            }
            
            self.isEditableDimmedActions.accept((true,"Required data completed.Proceed with submission or Click Here to edit.".localized,false))
            return
        } else { // if task ( Approver data ) is not editable
            // Make actions Active and hide alert message
            self.isEditableDimmedActions.accept((false,"",false))
        }
    }
    
    func getSectionTitle(item: Field?) -> String {
        var lbl = ""
        if let localization = item?.properties?.localization {
            if !isArabic() {
                if let localizedLabel = localization["en"]?.label, !localizedLabel.isEmpty {
                    lbl = localizedLabel
                } else {
                    lbl = item?.properties?.label ?? ""
                }
            }else {
                if let localizedLabel = localization["ar"]?.label, !localizedLabel.isEmpty {
                    lbl = localizedLabel
                } else {
                    lbl = item?.properties?.label ?? ""
                }
            }
        }
        return lbl
    }

    
}

extension RequestDetailsViewModel {
    func getDetailsFormJson(id: String, isRequest: Bool?) {
        self.loadingSubject.onNext(.show)
        
        Services.shared.getRequestDetailsForm(id: id, isRequest: isRequest ?? false, completion: {[weak self] serviceName , formViersionId, responseJSON , errorMsg in
            guard let `self` = self else {return}
            self.formBuilder.serviceName = serviceName
            self.formBuilder.formVersionId = formViersionId
             
            guard let res = responseJSON else { return }
            self.formBuilder.handleRequestDetailsJSON(res) {[weak self] success in
                guard let `self` = self else {return}
                if !success {
                    self.loadingSubject.onNext(.hide)
                    return
                }
                
                self.formBuilder.populateFormData(isEdit: true, excludedView: isRequest ?? false ? .RequestDetails : .TaskDetails)
                
                DispatchQueue.main.async {
                    self.loadingSubject.onNext(.hide)
                    
                    self.formBuilder.handlePageData()
                    self.formBuilder.handleTableControlChildren()
                    self.fieldValidationChangedWhenEditRequest(isRequest: isRequest)
                    
                    if isRequest ?? false {
                        self.details.accept(self.formBuilder.requestModel)
                        self.isEditable.accept(self.formBuilder.requestModel.isEditable)
                        self.isEditableDimmedActions.accept((self.formBuilder.requestModel.isEditable,"",false))
                        self.isWithdrawal.value = self.formBuilder.requestModel.isWithdrawal
                        self.requestWithDrawId.value = self.formBuilder.requestModel.id
                        self.setEditRequestDataSource()
                        self.setActionDateSource()
                        self.setActionBtnsInVM()
                    }else {
                        self.details.accept(self.formBuilder.requestModel)
                        self.isEditableDimmedActions.accept((self.formBuilder.requestModel.isTaskEditable,"",false))
                        self.setActionDateSource()
                        self.setActionBtnsInVM()
                    }
                }
            }
        })
    }
    
    func fieldValidationChangedWhenEditRequest(isRequest: Bool?) {
        fieldValidationChangedWhenEditRequestForTableFields(isRequest: isRequest)
        if !formBuilder.sectionObjects.isEmpty {
            
            for i in 0 ... formBuilder.sectionObjects.count - 1 {
                let sectionObject = formBuilder.sectionObjects[i]
                for (index, item) in sectionObject.items.enumerated() {
                    let row = index  // Use the index as the row value
                    
                    if let switchItem = item as? FormViewModelSwitchItem {
                        let requiredItem = switchItem.required
                        let defaultAnswer = switchItem.defaultAnswer
                        
                        formBuilder.sectionObjects[i].items[row].answer = defaultAnswer
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
                            formBuilder.sectionObjects[i].items[row].answer = defaultAnswer
                        }
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
                            formBuilder.sectionObjects[i].items[row].answer = ans
                        }
                        
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
                            formBuilder.sectionObjects[i].items[row].answer = ans
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
                                let ans = DateTimeAnswer(val: sortedValues, timeValues: [], lNote: nil, lAttachments: nil, type: .Gregorian)
                                formBuilder.sectionObjects[i].items[row].answer = ans
                            }
                        }
                        let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DateTimeProperties)?.defaultAnswer
                        
                    }
                    
                    if item is FormViewModelParagraphItem {
                        
                        let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .Text {
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let ans = ParagraphAnswer(val: defaultAnswer?.value)
                            formBuilder.sectionObjects[i].items[row].answer = ans
                        }
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle {
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let boolAns = defaultAnswer?.value?.lowercased() == "true"
                            let ans = ParagraphAnswer(val: String(boolAns))
                            formBuilder.sectionObjects[i].items[row].answer = ans
                        }
                    }
                    
                    if item is FormViewModelNumericItem {
                        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
                            
                            
                            if item.type == .TextBox {
                                if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswerWhenTextBox {
                                    let answer = TextboxAnswer(val: defualtAnswer.value ?? "", lPrefix: defualtAnswer.prefix, lSuffix: defualtAnswer.suffix, lNote: nil, lAttachments: nil)
                                    formBuilder.sectionObjects[i].items[row].answer = answer
                                }
                                let requiredItem = (item.field?.properties as? NumberProperties)?.required
                                let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswerWhenTextBox
                            } else {
                                if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer {
                                    if defualtAnswer.value != nil {
                                        let answer = BaseAnswerText(val: "\(defualtAnswer.value ?? 0.0)", lNote: nil)
                                        formBuilder.sectionObjects[i].items[row].answer = answer
                                    }
                                }
                                let requiredItem = (item.field?.properties as? NumberProperties)?.required
                                let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                            }
                        } else {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value?.first ?? "0.0")", lNote: nil)
                                    formBuilder.sectionObjects[i].items[row].answer = answer
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer
                        }
                    }
                    
                    if item is FormViewModelTextBoxItem {
                        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                formBuilder.sectionObjects[i].items[row].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer
                            
                        } else {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value?.first ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                formBuilder.sectionObjects[i].items[row].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer
                        }
                    }
                    
                    if item is FormViewModelTextAreaItem {
                        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value ?? "", htmlVal: defualtAnswer.value ?? "")
                                formBuilder.sectionObjects[i].items[row].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer
                            formBuilder.sectionObjects[i].items[row].answer = defaultAnswer
                        } else {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value?.first ?? "", htmlVal: defualtAnswer.value?.first ?? "")
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            formBuilder.sectionObjects[i].items[row].answer = defaultAnswer
                        }
                    }
                    
                    if item is FormViewModelFileUploadItem {
                        let mediaItem = item as? FormViewModelFileUploadItem
                        var defaultAttchs = [ModelUploadedMedia]()
                        if let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer {
                            for attach in defaultAnswer.value ?? [] {
                                if let uploadedMedia = DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach).uploadedMedia {
                                    defaultAttchs.append(uploadedMedia)
                                }
                                mediaItem?.attachmentsList.append(DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach))
                            }
                            if !(defaultAttchs.isEmpty) {
                                let answer = FileUploadAnswer(val: defaultAttchs, lNote: nil, lAttachments: nil)
                                formBuilder.sectionObjects[i].items[row].answer = answer
                            }
                        }
                        let requiredItem = (item.field?.properties as? FileUploadProperties)?.required
                        let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer
                    }
                }
            }
            
            for sectionIndex in self.formBuilder.sectionObjects.indices {
                for itemIndex in self.formBuilder.sectionObjects[sectionIndex].items.indices {
                    // Pass the actual item in sectionObjects by reference

                    self.formBuilder.handleItemRules(self.formBuilder.sectionObjects[sectionIndex].items[itemIndex],
                                                     excludedView: isRequest ?? false ? .RequestDetails : .TaskDetails, removeAnswer: false)
                }
            }
        }
    }
    
    func fieldValidationChangedWhenEditRequestForTableFields(isRequest: Bool?) {
        var isDimmed = false
        if !formBuilder.tableSectionObjects.isEmpty {
            
            for i in 0 ... formBuilder.tableSectionObjects.count - 1 {
                let sectionObject = formBuilder.tableSectionObjects[i]
                for item in sectionObject.items  {
                    if let switchItem = item as? FormViewModelSwitchItem {
                        let requiredItem = (item.field?.properties as? switchProperties)?.required
                        let defaultAnswer = (item.field?.properties as? switchProperties)?.defaultAnswer
                        formBuilder.tableSectionObjects[i].items[0].answer = defaultAnswer
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
                            formBuilder.tableSectionObjects[i].items[0].answer = ans
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
                            formBuilder.tableSectionObjects[i].items[0].answer = ans
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
                            formBuilder.tableSectionObjects[i].items[0].answer = ans
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
                                
                                formBuilder.tableSectionObjects[i].items[0].answer = ans
                            }
                        }
                        let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DateTimeProperties)?.defaultAnswer
                    }
                    
                    if item is FormViewModelParagraphItem {
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .Text{
                            let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let ans = ParagraphAnswer(val: defaultAnswer?.value)
                            formBuilder.tableSectionObjects[i].items[0].answer = ans
                        }
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle{
                            let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let boolAns = defaultAnswer?.value?.lowercased() == "true"
                            let ans = ParagraphAnswer(val: String(boolAns))
                            formBuilder.tableSectionObjects[i].items[0].answer = ans
                        }
                    }
                    
                    if item is FormViewModelNumericItem {
                        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value ?? 0.0)", lNote: nil)
                                    formBuilder.tableSectionObjects[i].items[0].answer = answer
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                            let answer = BaseAnswerText(val: "\(defaultAnswer?.value ?? 0.0)", lNote: "")
                        }else {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value?.first ?? "0.0")", lNote: nil)
                                    formBuilder.tableSectionObjects[i].items[0].answer = answer
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                        }
                        
                    }
                    
                    if item is FormViewModelTextBoxItem {
                        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                formBuilder.tableSectionObjects[i].items[0].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer
                        } else {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value?.first ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                formBuilder.tableSectionObjects[i].items[0].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer
                        }
                    }
                    
                    if item is FormViewModelTextAreaItem {
                        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value ?? "", htmlVal: defualtAnswer.htmlValue ?? "", lNote: nil, lAttachments: nil)
                                formBuilder.tableSectionObjects[i].items[0].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                        } else {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value?.first ?? "", htmlVal: defualtAnswer.value?.first ?? "")
                                formBuilder.tableSectionObjects[i].items[0].answer = answer
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            formBuilder.tableSectionObjects[i].items[0].answer = defaultAnswer
                        }
                    }
                    
                    if item is FormViewModelFileUploadItem {
                        let mediaItem = item as? FormViewModelFileUploadItem
                        var defaultAttchs = [ModelUploadedMedia]()
                        if let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer {
                            for attach in defaultAnswer.value ?? [] {
                                if let uploadedMedia = DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach).uploadedMedia {
                                    defaultAttchs.append(uploadedMedia)
                                }
                                mediaItem?.attachmentsList.append(DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach))
                            }
                            //                            formBuilder.sectionObjects[i].items[0] = mediaItem!
                            let answer = FileUploadAnswer(val: defaultAttchs, lNote: nil, lAttachments: nil)
                            formBuilder.tableSectionObjects[i].items[0].answer = answer
                        }
                        let requiredItem = (item.field?.properties as? FileUploadProperties)?.required
                        let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer
                    }
                }
            }
            
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
                    if section.items.count > 0 {
                        if section.items[0].fieldId == table.fieldId {

                            formBuilder.handleItemRules(section.items[0], excludedView: isRequest ?? false ? .RequestDetails : .TaskDetails, removeAnswer: false)
                        }
                    }
                }
            }
        }
    }
}
