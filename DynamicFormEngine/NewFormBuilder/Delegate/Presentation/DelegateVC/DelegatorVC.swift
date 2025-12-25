//
//  DelegatorVC.swift
//  CERQEL
//
//  Created by Youxel on 06/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

class DelegateItem: BaseItem {
    var action: Action
    var taskId: String?
    var successCallBack: SuccessCallBack
    
    init( action: Action,taskId: String?,successCallBack: @escaping SuccessCallBack) {
        self.action = action
        self.taskId = taskId
        self.successCallBack = successCallBack
    }
}

class DelegatorVC: BaseView<DelegateActionViewModel,DelegateItem>{
    
    @IBOutlet weak var topDivider: UIView!
    @IBOutlet weak var delegateTitleLbl: LocalizedLabel!
    @IBOutlet weak var selectedDelegate: UITextField!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var commentTitlLbl: LocalizedLabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var commentPlaceHolder: UILabel!{
        didSet {
            self.commentPlaceHolder.text = "Type your reason here".localized
        }
    }
    
    let textViewPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        configureUI()
        setNavigationTitle("Delegate".localized)
        setupBackButton()
        handleOvservation()
        textView.delegate = self
    }
    
    private func initialConfiguration() {
        viewModel =  DelegateActionViewModel(view: self, router: CerqelRouterManagerDynamicFormImpl(self),excuteActionUseCase: ExcuteActionUseCaseImpl(),successCallBack: item.successCallBack)
        setPayloadValue()
    }
    
    private func setPayloadValue(){
        self.viewModel.payload.value.actionId = item.action.id
        self.viewModel.payload.value.taskId = item.taskId
        self.viewModel.payload.value.payload?.comment = ""
    }
    
    private  func handleOvservation() {
        viewModel.selectedUser.bind { item in
            self.handleSubmitBtn(isDimmed: (item == nil))
            self.handleSelectedDelegateText(name: item?.name ?? "_")
        }
    }

  private func handleSubmitBtn(isDimmed: Bool){
        saveBtn.isUserInteractionEnabled = !isDimmed
        saveBtn.backgroundColor = isDimmed ? primaryMain.withAlphaComponent(0.5): primaryMain
    }
    
    private func handleSelectedDelegateText(name: String?) {
        selectedDelegate.text = name
    }
    
    func configureUI(){
        delegateTitleLbl.textColor = typographyTitle
        delegateTitleLbl.font = UIFont.bodyMRegular()
        delegateTitleLbl.textAlignment = isArabicCerqel() ? .right : .left
        selectedDelegate.textColor = typographyTitle
        selectedDelegate.font = UIFont.bodyLRegular()
        selectedDelegate.textAlignment = isArabicCerqel() ? .right : .left
        commentPlaceHolder.text = "Type your reason here".localized
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
        saveBtn.setTitle("Delegate".localized, for: .normal)
        saveBtn.titleLabel?.font = UIFont.buttonLSemibold()
        saveBtn.backgroundColor = primaryMain.withAlphaComponent(0.5)
        selectedDelegate.placeholder = "Select Name".localized
    }
  
    @IBAction func selectDelegateBtnPressed(_ sender: Any) {
        self.viewModel.navigateToDelegateBottomSheet()
    }
    
    @IBAction func delegateBtnPressed(_ sender: Any) {
        self.viewModel.executeAction()
    }
 
    @objc internal override func goBack() {
        if (self.viewModel.selectedUser.value == nil){
            navigationController?.popViewController(animated: true)
        }
        else {
            viewModel.showLeaveConfirmationBottomSheet()
        }
    }
}

extension DelegatorVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        commentPlaceHolder.isHidden = !textView.text.isEmpty
        viewModel.payload.value.payload?.comment = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
    }
}


