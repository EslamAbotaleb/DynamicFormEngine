//
//  NewTextBoxTVCell.swift
//
//
//  Created by Marwan on 23/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit
import EasyTipView

class NewTextBoxTVCell: ParentFieldTableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorImg: UIImageView!
    @IBOutlet weak var errorContainer: UIStackView!
    
    @IBOutlet weak var passwordEyeBtn: UIButton!{
        didSet{
            passwordEyeBtn.isHidden = true
            passwordEyeBtn.tintColor = primaryMain
        }
    }
    @IBOutlet weak var txtFieldContainer: UIView!{
        didSet{
            txtFieldContainer.layer.borderWidth = 1
            txtFieldContainer.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
    }
    @IBOutlet weak var toolTipIcon: UIButton!

    var toolTipTxt = ""
    // MARK: - Variables
    var isFromDetails: Bool = false
    var iconClick = true
    var dataSourceFetchingInTextNumberControl: ((_ dataSource: String, FormViewModelItem)->())?
    var isSectionItem = false
    var inlineError = false
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelTextBoxItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupWithTextBox(item: item)
            } else if let item = item as? FormViewModelNumericItem {
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupWithNumerical(item: item)
            }
        }
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
    
    var valueChanged: ((TextboxAnswer?, Bool) -> ())?
    var numberValueChanged: ((BaseAnswerText?, Bool) -> ())?
    var validationChanged: ((Bool) -> ())?
    var prefixInd = 0
    var prefixValue = ""
    var suffixInd = 0
    var suffixValue = ""
    var textFieldValue = ""

    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTF.delegate = self
        valueTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        handleGesture()
        configureUI()
    }
    
    private func configureUI() {
        titleLbl.textColor = typographyTitle
        subTitleLabel.textColor = typographySubtitle
        toolTipIcon.tintColor = typographyTitle
    }
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange() {
        if item is FormViewModelTextBoxItem {
            handleTextBoxValidation(endEditing: true, text: valueTF.text ?? "")
        } else if item is FormViewModelNumericItem {
            handleNumericValidation(endEditing: true, text: valueTF.text ?? "")
        }
        textFieldValue = valueTF.text ?? ""
        submitValue(text: textFieldValue)
    }
    
    func setupTitle(isNumeric: Bool, textBoxItem: FormViewModelTextBoxItem?, numericItem: FormViewModelNumericItem?) {
        if isNumeric {
            guard let item = numericItem else { return }
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
                if let localizedToolTip = item.localization?["en"]?.tooltip, !localizedToolTip.isEmpty {
                    self.toolTipTxt = localizedToolTip
                } else {
                    self.toolTipTxt = item.tooltip ?? ""
                }
            } else {
                if let localizedToolTip = item.localization?["ar"]?.tooltip, !localizedToolTip.isEmpty {
                    self.toolTipTxt = localizedToolTip
                } else {
                    self.toolTipTxt = item.tooltip ?? ""
                }
            }

            setRequiredMark(required: item.required, value: titleLbl.text ?? "")
            titleLbl.isHidden = (titleLbl.text ?? "").isEmpty ? true : false

        } else {
            guard let item = textBoxItem else { return }
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
                if let localizedToolTip = item.localization?["en"]?.tooltip, !localizedToolTip.isEmpty {
                    self.toolTipTxt = localizedToolTip
                } else {
                    self.toolTipTxt = item.tooltip ?? ""
                }
            } else {
                if let localizedToolTip = item.localization?["ar"]?.tooltip, !localizedToolTip.isEmpty {
                    self.toolTipTxt = localizedToolTip
                } else {
                    self.toolTipTxt = item.tooltip ?? ""
                }
            }
            
            setRequiredMark(required: item.required, value: titleLbl.text ?? "")
            titleLbl.isHidden = (titleLbl.text ?? "").isEmpty ? true : false

        }
        toolTipIcon.isHidden = toolTipTxt.isEmpty
    }
    
    func setupSubTitle(isNumeric: Bool, textBoxItem: FormViewModelTextBoxItem?, numericItem: FormViewModelNumericItem?) {
        if isNumeric {
            guard let item = numericItem else { return }
            guard let localization = item.localization as? TextBoxLocalization else { return }
            if !isArabicCerqel() {
                subTitleLabel.text = item.sublabel
            } else {
                if let localizedLabel = localization["ar"]?.sublabel, !localizedLabel.isEmpty {
                    subTitleLabel.text = localizedLabel
                }
            }
            subTitleLabel.isHidden = (subTitleLabel.text ?? "").isEmpty ? true : false

        } else {
            guard let item = textBoxItem else { return }
            guard let localization = item.localization as? TextBoxLocalization else { return }
            if !isArabicCerqel() {
                subTitleLabel.text = item.sublabel
            } else {
                if let localizedLabel = localization["ar"]?.sublabel, !localizedLabel.isEmpty {
                    subTitleLabel.text = localizedLabel
                }
            }
            subTitleLabel.isHidden = (subTitleLabel.text ?? "").isEmpty ? true : false
        }
        
    }
    
    func setupPlaceholder(isNumeric: Bool, textBoxItem: FormViewModelTextBoxItem?, numericItem: FormViewModelNumericItem?) {
        if isNumeric {
            guard let item = numericItem else { return }
            guard let localization = item.localization as? InteractiveLocalization else { return }
            if !isArabicCerqel() {
                valueTF.placeholder = item.placeHolder
            } else {
                if let localizedLabel = localization["ar"]?.placeholder, !localizedLabel.isEmpty {
                    valueTF.placeholder = localizedLabel
                } else {
                    valueTF.placeholder = item.placeHolder
                }
            }
            subTitleLabel.isHidden = (subTitleLabel.text ?? "").isEmpty ? true : false
            
        } else {
            guard let item = textBoxItem else { return }
            guard let localization = item.localization as? TextBoxLocalization else { return }
            if !isArabicCerqel() {
                valueTF.placeholder = item.placeHolder
            } else {
                if let localizedLabel = localization["ar"]?.placeholder, !localizedLabel.isEmpty {
                    valueTF.placeholder = localizedLabel
                } else {
                    valueTF.placeholder = item.placeHolder
                }
            }
            subTitleLabel.isHidden = (subTitleLabel.text ?? "").isEmpty ? true : false
        }
    }
    
    func setRequiredMark(required: Bool, value:String) {
        if required {
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
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }

    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
   
    func setupWithTextBox(item: FormViewModelTextBoxItem) {
        setupPlaceholder(isNumeric: false, textBoxItem: item, numericItem: nil)
        setupTitle(isNumeric: false, textBoxItem: item, numericItem: nil)
        setupSubTitle(isNumeric: false, textBoxItem: item, numericItem: nil)
        handleSubType(item.field?.properties?.subType)
        emptyValues()

        if AuthManager.shared.newSubmissionRetreiveEnabled {
            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer{
                textFieldValue = defaultAnswer.value ?? ""
                prefixValue = defaultAnswer.prefix ?? ""
                suffixValue = defaultAnswer.suffix ?? ""
                if textFieldValue != "" {
                }
            }
        } else {
            if let defaultAnswer = item.defaultAnswer {
                textFieldValue = defaultAnswer.value?.first ?? ""
                prefixValue = defaultAnswer.prefix ?? ""
                suffixValue = defaultAnswer.suffix ?? ""
                if textFieldValue != "" {
                    //                submitValue(text: textFieldValue)
                }
            }
        }
        
        if let value = (item.answer as? TextboxAnswer).value {
            textFieldValue = value.value ?? ""
            prefixValue = (item.answer as? TextboxAnswer)?.prefix ?? ""
            suffixValue = (item.answer as? TextboxAnswer)?.suffix ?? ""
            submitValue(text: textFieldValue)
        }
        
        handleValue()
        if item.allowSpellCheck ?? false {
            valueTF.spellCheckingType = .yes
        } else {
            valueTF.spellCheckingType = .no
        }
        valueTF.autocapitalizationType = .words
        handleDisabledText(disabled: (item.disabled ||  item.field?.properties?.readonly ?? false))
        updateErrorState(item.isError, with: "")
        updateValidationError(with: item.errorMessageInline)
        if item.isUpdated && item.answer != nil{
            handleErrorShowingText(endEditing: true, text: textFieldValue)
            handleTextBoxValidation(endEditing: true, text: valueTF.text ?? "")
        }

        if let dataSourceId = item.field?.properties?.dataSourcId, (textFieldValue.isEmpty || (item.disabled || item.field?.properties?.readonly ?? false)) {
            dataSourceFetchingInTextNumberControl?(dataSourceId,item)
        }
    }
    
    func setupWithNumerical(item: FormViewModelNumericItem) {
        setupPlaceholder(isNumeric: true, textBoxItem: nil, numericItem: item)
        setupTitle(isNumeric: true, textBoxItem: nil, numericItem: item)
        setupSubTitle(isNumeric: true, textBoxItem: nil, numericItem: item)
        valueTF.keyboardType = .asciiCapableNumberPad
        if let properties = item.field?.properties as? NumberProperties {
            if properties.DecimalPlaces ?? 0 > 0 {
                valueTF.keyboardType = .decimalPad
            }
        }
        emptyValues()
        
        if let numberProperties = item.field?.properties as? NumberProperties {
            if let defaultValue = numberProperties.newDefaultAnswer.value, defaultValue.value != nil {
                if numberProperties.DecimalPlaces ?? 0 > 0 { // double default value
                    textFieldValue = "\(defaultValue.value ?? 0.0)"
                }else { // int default value
                    textFieldValue = "\(Int(defaultValue.value ?? 0.0))"
                }
            }
        }
        
        if let value = (item.answer as? BaseAnswerText)?.value {
            if let numberProperties = item.field?.properties as? NumberProperties {
                if numberProperties.DecimalPlaces ?? 0 > 0 { // double default value
                    textFieldValue = value
                }else { // int default value
                    if numberOfDecimalDigits(value) > 0 {
                        textFieldValue = "\(Int(Double(value) ?? 0.0))"
                    }else {
                        textFieldValue = value
                    }
                }
                submitValue(text: textFieldValue)
            }
        }
        
        handleValue()
        updateErrorState(item.isError, with: "")
        updateValidationError(with: item.errorMessageInline)
        handleDisabledText(disabled: (item.disabled ||  item.field?.properties?.readonly ?? false))

        if item.isUpdated && item.answer != nil{
            handleErrorShowingNumeric(endEditing: true, text: textFieldValue)
            handleNumericValidation(endEditing: true, text: valueTF.text ?? "")
        }
        
        if let dataSourceId = item.field?.properties?.dataSourcId, (textFieldValue.isEmpty || (item.disabled || item.field?.properties?.readonly ?? false)) {
            dataSourceFetchingInTextNumberControl?(dataSourceId,item)
        }
    }
    
    func emptyValues() {
        prefixInd = 0
        prefixValue = ""
        suffixInd = 0
        suffixValue = ""
        textFieldValue = ""
        errorLabel.text = ""
        errorContainer.isHidden = true
        txtFieldContainer.layer.borderWidth = 1
        txtFieldContainer.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
    }
   
    func handleValue() {
        if !valueTF.isHidden {
            valueTF.text = textFieldValue
        }
    }
    
    func handleSubType(_ subType: TextBoxSubType?) {
        guard let subType = subType else {
            valueTF.keyboardType = .default
            return
        }
        switch subType {
        case .AnySubType, .Alphanumeric, .Custom:
            valueTF.keyboardType = .default
        case .Email:
            valueTF.keyboardType = .emailAddress
        case .URL:
            valueTF.keyboardType = .URL
        case .Numeric:
            valueTF.keyboardType = .decimalPad
        case .Alphabetic:
            valueTF.keyboardType = .alphabet
        case .password:
            valueTF.keyboardType = .alphabet
            valueTF.isSecureTextEntry = true
            passwordEyeBtn.isHidden = false
        }
    }
    
    func checkError() -> Bool {
        if !(errorContainer.isHidden) {
            return true
        } else {
            return false
        }
    }
    
    func handleDisabledText(disabled:Bool){
        txtFieldContainer.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        valueTF.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        valueTF.isUserInteractionEnabled = disabled ? false : true
        if disabled { txtFieldContainer.borderColorV = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1) }
    }
    
    func submitValue(text: String) {
        if item is FormViewModelTextBoxItem {
            let answerObject = TextboxAnswer(val: text, lPrefix: prefixValue, lSuffix: suffixValue)
            valueChanged?(answerObject, self.checkError())
        } else {
            let answerObject = BaseAnswerText(val: text)
            if let action = numberValueChanged {
                action(answerObject, self.checkError())
            }
        }
    }
    
    func handleTextBoxValidation(endEditing: Bool, text: String) {
        guard let item = item as? FormViewModelTextBoxItem else { return }
        if item.required {
            let validation = FormBuilder.shared.handleTextboxValidation(value: text, item: item, row: item.fieldId)
            validationChanged?(!validation.isError)
            
            if validation.isError {
                item.inLineError = validation.isError
                item.errorMessageInline = validation.errorMessage
                errorLabel.text = validation.errorMessage
                errorContainer.isHidden =  !validation.isError
                txtFieldContainer.layer.borderWidth = 1
                txtFieldContainer.layer.borderColor = validation.isError ? #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
            } else {
                errorLabel.text = validation.errorMessage
                if let txt = valueTF.text, txt != "" {
                    showValidContorl(isValid: !validation.isError)
                }else {
                    errorContainer.isHidden = true
                }
            }
        } else if !item.required && text.isEmpty {
            validationChanged?(true)
            errorContainer.isHidden =  true
        } else if !item.required && !text.isEmpty {
            let validation = FormBuilder.shared.handleTextboxValidation(value: text, item: item, row: item.fieldId)
            validationChanged?(!validation.isError)
            errorLabel.text = validation.errorMessage
            errorContainer.isHidden =  !validation.isError
            txtFieldContainer.layer.borderWidth = 1
            txtFieldContainer.layer.borderColor = validation.isError ? #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
            if !validation.isError {
                if endEditing {
                    if let txt = valueTF.text, txt != "" {
                        showValidContorl(isValid: true)
                    }else {
                        errorContainer.isHidden = true
                    }
                } else {
                    if let txt = valueTF.text, txt != "" {
                        focusTxtBox(isFocus: true)
                    }else {
                        errorContainer.isHidden = true
                    }
                }
            }
        }
        if let value = item.answer as? TextboxAnswer {
            textFieldValue = value.value ?? ""
            submitValue(text: textFieldValue)
        }
    }
    
    func handleErrorShowingText(endEditing: Bool, text: String){
        guard let item = item as? FormViewModelTextBoxItem else { return }
        guard !item.required && text.isEmpty else {
            let validation = FormBuilder.shared.handleTextboxValidation(value: text, item: item, row: item.fieldId)
            if validation.isError {
                errorLabel.text = validation.errorMessage
                errorContainer.isHidden =  !validation.isError
                txtFieldContainer.layer.borderWidth = 1
                txtFieldContainer.layer.borderColor = validation.isError ? #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
            } else {
                errorLabel.text = validation.errorMessage
                if endEditing {
                    if let txt = valueTF.text, txt != "" {
                        showValidContorl(isValid: !validation.isError)
                    }else {
                        errorContainer.isHidden = true
                    }
                } else {
                    if let txt = valueTF.text, txt != "" {
                        focusTxtBox(isFocus: !validation.isError)
                    }else {
                        errorContainer.isHidden = true
                    }
                }
            }
            return
        }
    }
    
    
    func handleErrorShowingNumeric(endEditing: Bool, text: String){
        guard let item = item as? FormViewModelNumericItem else { return }
        guard !item.required && text.isEmpty else {
            let validation = FormBuilder.shared.handleNumericValidation(value: text, item: item, row: item.fieldId)
            if validation.isError {
                errorLabel.text = validation.errorMessage
                errorContainer.isHidden = !validation.isError
                txtFieldContainer.layer.borderWidth = 1
                txtFieldContainer.layer.borderColor = validation.isError ? #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
            } else {
                if endEditing {
                    if let txt = valueTF.text, txt != "" {
                        showValidContorl(isValid: !validation.isError)
                    }else {
                        errorContainer.isHidden =  true
                    }
                } else {
                    if let txt = valueTF.text, txt != "" {
                        focusTxtBox(isFocus: !validation.isError)
                    }else {
                        errorContainer.isHidden = true
                    }
                }
                errorLabel.text = validation.errorMessage
            }
            return
        }
    }

    
    func handleNumericValidation(endEditing: Bool, text: String) {
        guard let item = item as? FormViewModelNumericItem else { return }
        if item.required {
            let validation = FormBuilder.shared.handleNumericValidation(value: text, item: item, row: item.fieldId)
            validationChanged?(!validation.isError)
            
            if validation.isError {
                errorLabel.text = validation.errorMessage
                errorContainer.isHidden = !validation.isError
                txtFieldContainer.layer.borderWidth = 1
                txtFieldContainer.layer.borderColor = validation.isError ? #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
            } else {
                errorLabel.text = validation.errorMessage
                if let txt = valueTF.text, txt != "" {
                    showValidContorl(isValid: !validation.isError)
                }else {
                    errorContainer.isHidden = true
                }
            }
        } else if !item.required && text.isEmpty {
            validationChanged?(true)
            errorContainer.isHidden = true
        } else if !item.required && !text.isEmpty {
            let validation = FormBuilder.shared.handleNumericValidation(value: text, item: item, row: item.fieldId)
            validationChanged?(!validation.isError)
            errorLabel.text = validation.errorMessage
            if endEditing {
                if let txt = valueTF.text, txt != "" {
                    showValidContorl(isValid: !validation.isError)
                }else {
                    errorContainer.isHidden = true
                }
            } else {
                if let txt = valueTF.text, txt != "" {
                    focusTxtBox(isFocus: !validation.isError)
                }else {
                    errorContainer.isHidden = true
                }
            }
        }
        if let value = item.answer as? TextboxAnswer {
            textFieldValue = value.value ?? ""
            submitValue(text: textFieldValue)
        }
        if let value = item.answer as? BaseAnswerText {
            textFieldValue = value.value ?? ""
            submitValue(text: textFieldValue)
        }
    }
    
    func showValidContorl(isValid: Bool){
        errorContainer.isHidden = isValid
        let disabled = (item.disabled ||  item.field?.properties?.readonly ?? false)
        disabled ? (txtFieldContainer.borderColorV = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)) : (txtFieldContainer.borderColorV = isValid ? #colorLiteral(red: 0.2666666667, green: 0.7529411765, blue: 0.6901960784, alpha: 1) : #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1))
    }
    func focusTxtBox(isFocus:Bool){
        txtFieldContainer.layer.borderWidth = 1
        txtFieldContainer.layer.borderColor = isFocus ?   #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1) : #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        errorContainer.isHidden =  isFocus
    }
    
    // MARK: - IBActions
    
    @IBAction func passwordEyePressed(_ sender: Any) {
        if iconClick {
            valueTF.isSecureTextEntry = false
            passwordEyeBtn.setImage(UIImage(named: "Show-password"), for: .normal)
        } else {
            valueTF.isSecureTextEntry = true
            passwordEyeBtn.setImage(UIImage(named: "view-off-1"), for: .normal)
        }
        iconClick = !iconClick
    }
}


extension NewTextBoxTVCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        item.isUpdated = true
        // Ensure the range is valid for the current text
        guard let stringRange = Range(range, in: currentText) else {
            return true
        }
        
        // Prevent leading spaces
        if range.location == 0, string == " " {
            return false
        }
        let changedText = currentText.replacingCharacters(in: stringRange, with: string)
        if item is FormViewModelTextBoxItem {
            handleTextBoxValidation(endEditing: false, text: changedText)
            guard let textCase = (item.field?.properties as? TextBoxProperties)?.textCase else {
                textField.text = currentText
                return false
            }
            switch textCase {
            case .LowerCase:
                if let stringRange = Range(range, in: currentText) {
                    let updatedText = currentText.replacingCharacters(in: stringRange, with: string.lowercased())
                    textField.text = updatedText
                    return false
                }
            case .UpperCase:
                if let stringRange = Range(range, in: currentText) {
                    let updatedText = currentText.replacingCharacters(in: stringRange, with: string.uppercased())
                    textField.text = updatedText
                    return false
                }
            case .Mixed: break
            }

        }
        // Ensure only numeric input
        if item.type == .Numerical {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
        }
        // Prevent multiple dots for numeric input
        if item is FormViewModelNumericItem {
            let countDots = currentText.components(separatedBy: ".").count - 1
            if countDots > 0 && string == "." {
                return false
            }
        }
        // Compute the new text
        if item is FormViewModelNumericItem && !changedText.isEmpty {
            handleNumericValidation(endEditing: false, text: changedText)
        }
        // Allow text changes only if the result doesn't start with whitespace
        let newString = (currentText as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }

    
    func handleNumeric(newText: String, string: String, numericItem: FormViewModelNumericItem) -> Bool {
        if string == "" {
            return true
        }
        return Double(newText) != nil
    }
    
    func numberOfDecimalDigits(_ text: String) -> Int {
        let numberOfDecimalDigits: Int
        if let dotIndex = text.firstIndex(of: ".") {
            numberOfDecimalDigits = text.distance(from: dotIndex, to: text.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        return numberOfDecimalDigits
    }
}

extension NewTextBoxTVCell: ValidatableCell {
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
        errorLabel.text = message
        errorContainer.isHidden = message.isEmpty
    }

    private func setErrorState(isError: Bool) {
        txtFieldContainer.layer.borderWidth = 1
        txtFieldContainer.layer.borderColor = isError ? #colorLiteral(red: 0.8352941176, green: 0.1058823529, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.1333333333, green: 0.168627451, blue: 0.2235294118, alpha: 1)
    }
}


