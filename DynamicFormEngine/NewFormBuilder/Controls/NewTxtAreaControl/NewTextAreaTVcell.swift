//
//  NewTextAreaTVcell.swift
//
//
//  Created by Hassan elshair on 24/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewTextAreaTVcell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.layer.borderWidth = 1
            textView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
    }
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var errorImg: UIImageView!
    @IBOutlet weak var toolTipIcon: UIButton!

    
    // MARK: - Variables
    var toolTipTxt = ""
    var placeHolderVal = ""
    var isSectionItem = false
    var validationChanged: ((Bool) -> ())?
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelTextAreaItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupWith(item: item)
                updateValidationError(with: item.errorMessageInline)
            }
        }
    }
    var textViewEndEditing: ((TextAreaAnswer?, Bool) -> ())?
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?
    var inlineError = false
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        handleGesture()
        configureUI()
    }

    private func configureUI() {
        titleLbl.textColor = typographyTitle
        subTitleLbl.textColor = typographySubtitle
        toolTipIcon.tintColor = typographyTitle
    }
    // MARK: - Functions
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    private func updateConstraintsForSectionItem(section: Bool) {
        if section {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = true
            NSLayoutConstraint.deactivate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    }
    
    func setupWith(item: FormViewModelTextAreaItem) {
        self.resetValues()
        setupTitle(item: item)
        setupSubTitle(item: item)
        handleDisabledText(disabled: (item.disabled || item.field?.properties?.readonly ?? false))
//        if let defaultValue = item.defaultAnswer?.value {
//            textView.text = defaultValue.first
//            checkTextValueAndNotify(textView.text)
//        }
        if AuthManagerDynamicForm.shared.newSubmissionRetreiveEnabled {
            if let defaultValue = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer?.value {
                item.answer = TextAreaAnswer(val: defaultValue, htmlVal: defaultValue)
                textView.text = defaultValue
                checkTextValueAndNotify(textView.text)
            }
        }else {
            if let defaultValue = item.defaultAnswer?.value {
                textView.text = defaultValue.first
                checkTextValueAndNotify(textView.text)
            }
        }
       
        if let value = (item.answer as? TextAreaAnswer)?.value {
            textView.textColor = .DarkBlack
            textView.text = value
            checkTextValueAndNotify(textView.text)
        }
        if textView.text == ""{
            setupPlaceHolder(item: item)
        }

        if item.allowSpellCheck ?? false {
            textView.spellCheckingType = .yes
        } else {
            textView.spellCheckingType = .no
        }
        textView.autocapitalizationType = .words
        
        if let autoExpand = item.autoExpand {
            textView.isScrollEnabled = !autoExpand
        }
        
        
        updateErrorState(item.isError, with: "")
        
        if let dataSourceId = item.field?.properties?.dataSourcId, textView.text == item.placeHolder {
            dataSourceFetching?(dataSourceId,item)
        }
    }
    
    func showErrorLbl(error:String,isHidden:Bool){
        guard let item = item as? FormViewModelTextAreaItem else {return}
//        guard item.required else {return}
        errorLbl.text = error
        errorLbl.isHidden = isHidden
        errorImg.isHidden = isHidden
        textView.layer.borderWidth = 1
        textView.layer.borderColor = !isHidden ?  #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
    }
    
    func handleDisabledText(disabled:Bool){
        textView.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        textView.isUserInteractionEnabled = disabled ? false : true
    }
    
    func textAreaFocus(isFocused:Bool){
        textView.layer.borderWidth = 1
        textView.layer.borderColor = isFocused ?  #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1) :  #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        errorLbl.isHidden = isFocused
        errorImg.isHidden = isFocused
    }
    func showValidContorl(isValid:Bool){
        errorLbl.isHidden = isValid
        errorImg.isHidden = isValid
        textView.layer.borderWidth = 1
        textView.layer.borderColor = isValid ? #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1) : #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    }
    
    func setupTitle(item: FormViewModelTextAreaItem?) {
        titleLbl.isHidden = (titleLbl.text ?? "").isEmpty ? true : false
        guard let localization = item?.localization as? InteractiveLocalization else { return }
        guard let item = item else { return }
        if !isArabicCerqel() {
            if let localizedLabel = item.localization?["en"]?.label, !localizedLabel.isEmpty {
                titleLbl.text = localizedLabel
            } else {
                titleLbl.text = item.label
            }
        } else {
            if let localizedLabel = item.localization?["ar"]?.label, !localizedLabel.isEmpty {
                titleLbl.text = localizedLabel
            } else {
                titleLbl.text = item.label
            }
        }
        if !isArabicCerqel() {
            if let localizedToolTip = localization["en"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item.tooltip ?? ""
            }
        } else {
            if let localizedToolTip = localization["ar"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item.tooltip ?? ""
            }
        }
        toolTipIcon.isHidden = toolTipTxt.isEmpty
        isRequiredField(item: item, value: titleLbl.text ?? "")
    }
    
    func setupPlaceHolder(item: FormViewModelTextAreaItem?) {
        if textView.text == item?.placeHolder || textView.text == "" {
         textView.textColor = UIColor.slate_grey.withAlphaComponent(0.4)
        }
        if !isArabicCerqel() {
            textView.text = item?.placeHolder
            self.placeHolderVal =  item?.placeHolder ?? ""
        } else {
            guard let localization = item?.localization as? InteractiveLocalization else { return }
            if textView.text == localization["ar"]?.placeholder || textView.text == ""{
             textView.textColor = UIColor.slate_grey.withAlphaComponent(0.4)
            }
            if let localizedLabel = localization["ar"]?.placeholder, !localizedLabel.isEmpty {
                textView.text = localizedLabel
                self.placeHolderVal =  localizedLabel
            } else {
                textView.text = item?.placeHolder
                self.placeHolderVal =  item?.placeHolder ?? ""
            }
        }
    }
    
    
    func setupSubTitle(item: FormViewModelTextAreaItem?){
        if isArabicCerqel() {
            subTitleLbl.text = item?.sublabel
        } else {
            guard let localization = item?.localization as? InteractiveLocalization else { return }
            if let localizedLabel = localization["ar"]?.sublabel, !localizedLabel.isEmpty {
                subTitleLbl.text = localizedLabel
            } else {
                subTitleLbl.text = item?.sublabel
            }
        }
        subTitleLbl.isHidden = (subTitleLbl.text ?? "").isEmpty ? true : false
    }
    
    func isRequiredField(item:FormViewModelTextAreaItem?,value:String){
        if let isRequired = item?.required{
            if isRequired {
                let st = value
                let last = " *"
                
                let firstAttributes: [NSAttributedString.Key: Any] = [:]
                let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.SST_Arabic_Bold(ofSize: 15)]
                
                let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
                let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
                
                firstString.append(lastString)
                
                self.titleLbl.attributedText = firstString
            }else{
                self.titleLbl.text = value
            }
        }else{
            self.titleLbl.text = value
        }
    }
    
    
    func checkError() -> Bool {
        if !(errorLbl.isHidden) {
            return true
        } else {
            return false
        }
    }
    
    func resetValues(){
        textView.text = ""
    }
    
    func checkTextValueAndNotify(_ text: String) {
        textViewEndEditing?(TextAreaAnswer(val: text, htmlVal: text), checkError())
    }
}

extension NewTextAreaTVcell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        if range.location == 0, text == " " {
            return false
        }
        
        guard let textCase = (item.field?.properties as? TextAreaProperties)?.textCase else {
            textView.text = currentText
            return false
        }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        if let item = item as? FormViewModelTextAreaItem, let entryLimit = item.entryLimit {
            let result = FormBuilder.shared.handleEntryLimit(entryLimit, changedText: changedText, item: item, row: item.fieldId)
            if  result.isError == true {
                self.showErrorLbl(error:  result.errorMessage,isHidden:!result.isError)
                item.inLineError = result.isError
                item.errorMessageInline = result.errorMessage
            }else{
                item.inLineError = result.isError
                item.errorMessageInline = result.errorMessage
                textAreaFocus(isFocused: true)
            }
            if textView.text.isEmpty && !item.required {
                validationChanged?(true)
            }else{
                validationChanged?(!result.isError)
            }
            if result.shouldChange {
                updateErrorState(result.isError, with: result.errorMessage)
            }
        }
        switch textCase {
        case .LowerCase:
            textCaseUpdate(currentText: currentText, text: text,range: range, textCase: textCase)
            return false
        case .UpperCase:
            textCaseUpdate(currentText: currentText, text: text,range: range, textCase: textCase)
            return false
        case .Mixed: break
        }
        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .DarkBlack
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        if let autoExpand = (item as? FormViewModelTextAreaItem)?.autoExpand, autoExpand {
            let startHeight = textView.frame.size.height
            let calcHeight = textView.sizeThatFits(textView.frame.size).height
            if startHeight != calcHeight, let formVC = self.parentContainerViewController() as? FormViewController {
                UIView.setAnimationsEnabled(false) // Disable animations
                formVC.activeTableView.beginUpdates()
                formVC.activeTableView.endUpdates()
                UIView.setAnimationsEnabled(true)  // Re-enable animations.
            }
        }
        
        
        checkTextValueAndNotify(textView.text)
    }
    
    func textCaseUpdate(currentText: String,text: String, range: NSRange, textCase: TextCase) {
        if let stringRange = Range(range, in: currentText) {
            var updatedText = ""
            switch textCase {
            case .LowerCase:
                updatedText = currentText.replacingCharacters(in: stringRange, with: text.lowercased())
            case .UpperCase:
                updatedText = currentText.replacingCharacters(in: stringRange, with: text.uppercased())
            default:
                return
            }
            
            textView.text = updatedText
            checkTextValueAndNotify(textView.text)
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0{
            textView.textColor =  UIColor.slate_grey.withAlphaComponent(0.4)
        }else{
            textView.textColor = .DarkBlack
        }
        return true
    }

    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let itemTxtArea = item as? FormViewModelTextAreaItem {
            let localization = item?.localization as? InteractiveLocalization
            let localizedLabel = localization?["ar"]?.placeholder
            if textView.text == itemTxtArea.placeHolder || textView.text == localizedLabel {
                textView.text.removeAll()
                textView.textColor = .DarkBlack
            }
            
            if let contentType = itemTxtArea.contentType{
                if contentType == "number"{
                    textView.keyboardType = .numberPad
                }else{
                    textView.keyboardType = .default
                }
            }else{
                textView.keyboardType = .default
            }
        }
        return true
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
}

extension NewTextAreaTVcell: ValidatableCell {
    func updateValidationError(with message: String) {
        inlineError = !message.isEmpty
        if inlineError {
            displayValidationError(message)
        } else {
            clearValidationError()
        }
    }

    func displayValidationError(_ message: String) {
//        updateConstraintsForSectionItem(section: item.isSectionControl)
        self.inlineError = true
        setErrorMessage(message)
        setErrorState(isError: true)
    }

    func clearValidationError() {
        self.inlineError = false
        setErrorMessage("")
        setErrorState(isError: false)
    }

    private func setErrorMessage(_ message: String) {
        errorLbl.text = message
    }

    private func setErrorState(isError: Bool) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = isError ?  #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
        errorLbl.isHidden = !isError
        errorImg.isHidden = !isError
    }
}
