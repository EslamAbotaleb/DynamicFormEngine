//
//  SendBackBottomSheet.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 12/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
internal import PanModal

class AddCommentItem: BaseItem {
    var didCommentSent:  ((String?)->())
    var mainTitle: String
    var isCommentRequired: Bool
    init( mainTitle: String, isCommentRequired: Bool, didCommentSent: @escaping ((String?)->())) {
        self.didCommentSent = didCommentSent
        self.mainTitle = mainTitle
        self.isCommentRequired = isCommentRequired
        
    }
}

class AddCommentBottomSheet: BaseView<AddCommentViewModel, AddCommentItem> {
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var titleLabel: LocalizedLabel!
    @IBOutlet weak var secondeTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submittButton: UIButton!
    @IBOutlet weak var bottomSheetHeight: NSLayoutConstraint!
    @IBOutlet weak var placeholderLbl: UILabel! {
        didSet {
            self.placeholderLbl.text = "Type your comment here".localized
        }
    }
    
    let textViewPadding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    var currentHeight : CGFloat  = 380
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initialConfiguration()
        textView.delegate = self
    }
    
    private func initialConfiguration(){
        viewModel = AddCommentViewModel(router: CerqelRouterManagerDynamicFormImpl(self), item: item)
    }
    
    private func configureUI(){
        submittButton.setTitle("Submit".localized, for: .normal)
        cancelButton.setTitle("Cancel".localized, for: .normal)
        secondeTitle.text = "Comment".localized
        placeholderLbl.text = "Type your comment here".localized
        if item.isCommentRequired == true {
            submittButton.tintColor = UIColor.lightGray
            submittButton.isUserInteractionEnabled = false
            setRequiredMark()
        } else {
            submittButton.tintColor = primaryMain
            submittButton.isUserInteractionEnabled = true
        }
        cancelButton.tintColor = primaryMain
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.906, green: 0.894, blue: 0.925, alpha: 1).cgColor
        textView.textContainerInset = textViewPadding
        textView.textAlignment = isArabicCerqel() ? .right : .left
        titleLabel.text = item.mainTitle.localized
    }
    
    func setRequiredMark() {
        let st = secondeTitle.text ?? ""
        let last = " *"
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.Poppins_regular(ofSize: 14)]
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.Poppins_regular(ofSize: 14)]
        let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
        let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
        firstString.append(lastString)
        secondeTitle.attributedText = firstString
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.viewModel.successCallBack()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let text = textView.text {
            item.didCommentSent(text)
        }
        self.viewModel.successCallBack()
    }
}

extension AddCommentBottomSheet:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLbl.isHidden = !textView.text.isEmpty
        if item.isCommentRequired == true {
            submittButton.isUserInteractionEnabled = !textView.text.isEmpty
            submittButton.tintColor = textView.text.isEmpty ? UIColor.lightGray : primaryMain
        } else {
            submittButton.tintColor = primaryMain
            submittButton.isUserInteractionEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
    }
}
