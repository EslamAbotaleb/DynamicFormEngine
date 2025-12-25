//
//  SendBackVC.swift
//  CERQEL
//
//  Created by Youxel on 11/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

class SendBackItem: BaseItem {
    var action: Action
    var sendBackId: String?
    var taskId: String?
    var successCallBack: SuccessCallBack
    
    init( action: Action,sendBackId: String?,taskId: String?,successCallBack: @escaping SuccessCallBack) {
        self.action = action
        self.sendBackId = sendBackId
        self.taskId = taskId
        self.successCallBack = successCallBack
    }
}

class SendBackVC: BaseView<SendBackViewModel,SendBackItem>{
    
    @IBOutlet weak var topDivider: UIView!
    @IBOutlet weak var sendBackTitleLbl: LocalizedLabel!
    @IBOutlet weak var selectedDelegate: UITextField!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var commentTitlLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentPlaceHolder: UILabel!{
        didSet {
            self.commentPlaceHolder.text = "Type your comment here".localized
        }
    }
    
    let textViewPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        configureUI()
        setNavigationTitle("Send Back".localized)
        setupBackButton()
        handleOvservation()
        textView.delegate = self
        viewModel.sendBackLevelsEndPoint()
    }
    
    private func initialConfiguration() {
        viewModel =  SendBackViewModel(router: CerqelRouterManagerDynamicFormImpl(self),sendBackRecipientsUseCase:SendBackRecipientsUseCaseImpl(),excuteActionUseCase: ExcuteActionUseCaseImpl(),successCallBack: item.successCallBack)
        setPayloadData()
    }
    
    private func setPayloadData(){
        self.viewModel.payload.value.actionId = item.action.id
        self.viewModel.payload.value.taskId = item.taskId
        self.viewModel.payload.value.payload?.comment = ""
        self.viewModel.sendBackId = item.sendBackId ?? ""
    }
    
    private  func handleOvservation() {
        // Bind on Comment
        viewModel.comment.bind { comment in
            self.handleSubmitBtn(isDimmed: (self.viewModel.selectedlevel.value.id == "" || self.viewModel.selectedlevel.value.id == nil || comment == ""))
        }
        
        //Bind on SendBackLevel
        viewModel.selectedlevel.bind { person in
            self.bindSendBackLevels(level: (isArabicCerqel() ? (person.nameAr ?? "") : (person.nameEn ?? "") ))
            self.handleSubmitBtn(isDimmed: (person.id == "" || person.id == nil || self.viewModel.comment.value == ""))
        }
    }
    
    private func bindSendBackLevels(level: String) {
        self.selectedDelegate.text = level
    }
    
    private func handleSubmitBtn(isDimmed: Bool){
        saveBtn.isUserInteractionEnabled = !isDimmed
        saveBtn.backgroundColor = isDimmed ? primaryMain.withAlphaComponent(0.5): primaryMain
    }
    
    
    func configureUI(){
        sendBackTitleLbl.textColor = typographyTitle
        sendBackTitleLbl.font = UIFont.bodyMRegular()
        sendBackTitleLbl.textAlignment = isArabicCerqel() ? .right : .left
        selectedDelegate.textColor = typographyTitle
        selectedDelegate.font = UIFont.bodyLRegular()
        selectedDelegate.textAlignment = isArabicCerqel() ? .right : .left
        commentPlaceHolder.text = "Type your comment here".localized
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.906, green: 0.894, blue: 0.925, alpha: 1).cgColor
        textView.textContainerInset = textViewPadding
        textView.textAlignment = isArabicCerqel() ? .right : .left
        topDivider.layer.backgroundColor =  UIColor(red: 0.906, green: 0.894, blue: 0.925, alpha: 1).cgColor
        topDivider.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        topDivider.shadowOpacity = 1
        topDivider.shadowRadius = 5
        topDivider.shadowOffset = CGSize(width: 0, height: 1)
        saveBtn.setTitle("Send Back".localized, for: .normal)
        saveBtn.titleLabel?.font = UIFont.buttonLSemibold()
        saveBtn.backgroundColor = primaryMain.withAlphaComponent(0.5)
        selectedDelegate.placeholder = "Select".localized
    }
    
    @IBAction func selectDelegateBtnPressed(_ sender: Any) {
        self.viewModel.navigateToSendBackLevelsBottomSheet()
    }
    
    @IBAction func delegateBtnPressed(_ sender: Any) {
        self.viewModel.executeActionSendBack()
    }
    
    @objc internal override func goBack() {
        if ((self.viewModel.selectedlevel.value.id == "" || self.viewModel.selectedlevel.value.id == nil) && self.viewModel.comment.value == ""){
            navigationController?.popViewController(animated: true)
        }
        else {
            viewModel.showLeaveConfirmationBottomSheet()
        }
    }
}

extension SendBackVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        commentPlaceHolder.isHidden = !textView.text.isEmpty
        viewModel.comment.value = textView.text
        viewModel.payload.value.payload?.comment = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
    }
}

