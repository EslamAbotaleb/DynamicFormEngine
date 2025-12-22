//
//  TextBoxTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 12/10/2021.
//

import UIKit
//import ActionSheetPicker_3_0
//import AKMaskField


class TextBoxTableViewCell: ParentFieldTableViewCell {

//    @IBOutlet weak var labelView: LabelView!
//    @IBOutlet weak var prefixView: UIView!
//    @IBOutlet weak var prefixTextField: UITextField!
//    @IBOutlet weak var prefixArrow: UIImageView!
//    @IBOutlet weak var textFieldView: UIView!
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var maskTextField: AKMaskField!
//    @IBOutlet weak var suffixView: UIView!
//    @IBOutlet weak var suffixTextField: UITextField!
//    @IBOutlet weak var suffixArrow: UIImageView!
//    @IBOutlet var textFieldViews: [UIView]!
//    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
//    
//    var item: FormViewModelItem! {
//        didSet {
//            if let item = item as? FormViewModelTextBoxItem {
//                setupWithTextBox(item: item)
//            } else if let item = item as? FormViewModelNumericItem {
//                setupWithNumerical(item: item)
//            }
//        }
//    }
//    
//    var valueChanged: ((TextboxAnswer?, Bool) -> ())?
//    var numberValueChanged: ((BaseAnswerText?, Bool) -> ())?
//    
//    var prefixInd = 0
//    var prefixValue = ""
//    var suffixInd = 0
//    var suffixValue = ""
//    var textFieldValue = ""
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        super.attachmentView = attachmentNoteView
//        super.objectOuterViews = [textFieldView]
//        
//        textField.delegate = self
//        prefixTextField.delegate = self
//        suffixTextField.delegate = self
//        for view in textFieldViews {
////            view.layer.borderColor = UIColor(r: 208, g: 217, b: 226).cgColor
//            view.layer.borderWidth = 1
//            view.layer.cornerRadius = 4
//        }
//        prefixInd = 0
//        prefixValue = ""
//        suffixInd = 0
//        suffixValue = ""
//        textFieldValue = ""
//    }
//    
//    func setupWithTextBox(item: FormViewModelTextBoxItem) {
//        labelView.item = item
//        labelView.required = item.required
//        setupPlaceholderLabel(item)
//        if let mask = item.mask {
//            handleMask(mask)
//        } else {
//            handleMask("")
//        }
//        handleSubType(item.subType)
//        emptyValues()
//        if let defaultAnswer = item.defaultAnswer {
//            textFieldValue = defaultAnswer.value ?? ""
//            prefixValue = defaultAnswer.prefix ?? ""
//            suffixValue = defaultAnswer.suffix ?? ""
//        }
//        if let value = item.answer as? TextboxAnswer {
//            textFieldValue = value.value ?? ""
//            prefixValue = value.prefix ?? ""
//            suffixValue = value.suffix ?? ""
//        }
//        handleValue()
//        attachmentNoteView.item = item
//        if item.allowSpellCheck ?? false {
//            textField.spellCheckingType = .yes
//        } else {
//            textField.spellCheckingType = .no
//        }
//        textField.autocapitalizationType = .words
//        prefixView.isHidden = true
//        suffixView.isHidden = true
//        prefixView.tag = 10
//        suffixView.tag = 20
//        
//        if let preifxObject = item.prefix {
//            handlePrefixSuffixView(lItem: item, prefix: true, object: preifxObject)
//        }
//        if let suffixObject = item.suffix {
//            handlePrefixSuffixView(lItem: item, prefix: false, object: suffixObject)
//        }
//        updateErrorState(item.isError, with: "")
//    }
//    
//    func handleSubType(_ subType: TextBoxSubType?) {
//        guard let subType = subType else {
//            textField.keyboardType = .default
//            return
//        }
//        switch subType {
//        case .AnySubType, .Alphanumeric, .Custom:
//            textField.keyboardType = .default
//        case .Email:
//            textField.keyboardType = .emailAddress
//        case .URL:
//            textField.keyboardType = .URL
//        case .Numeric:
//            textField.keyboardType = .numberPad
//        case .Alphabetic:
//            textField.keyboardType = .alphabet
//        case .password:
//            textField.keyboardType = .numberPad
//        }
//    }
//    
//    func handlePrefixSuffixView(lItem: FormViewModelTextBoxItem, prefix: Bool, object: PrefixViewModel) {
//        var currentView: UIView!
//        var currentArrow: UIImageView!
//        var currentTextField: UITextField!
//        
//        if prefix {
//            currentView = prefixView
//            currentArrow = prefixArrow
//            currentTextField = prefixTextField
//            if let objectValue = (lItem.answer as? TextboxAnswer)?.prefix, !objectValue.isEmpty {
//                currentTextField.text = objectValue
//                if let objectOptions = object.value, let valueIndex = objectOptions.firstIndex(of: objectValue) {
//                    prefixInd = valueIndex
//                }
//            } else {
//                currentTextField.text = ""
//            }
//        } else {
//            currentView = suffixView
//            currentArrow = suffixArrow
//            currentTextField = suffixTextField
//            if let objectValue = (lItem.answer as? TextboxAnswer)?.suffix, !objectValue.isEmpty {
//                currentTextField.text = objectValue
//                if let objectOptions = object.value, let valueIndex = objectOptions.firstIndex(of: objectValue) {
//                    suffixInd = valueIndex
//                }
//            } else {
//                currentTextField.text = ""
//            }
//        }
//        if object.display == .TextBox {
//            currentView.isHidden = false
//            currentArrow.isHidden = true
//            currentTextField.isUserInteractionEnabled = true
//        } else if object.display == .DropDown {
//            currentView.isHidden = false
//            currentArrow.isHidden = false
//            currentTextField.isUserInteractionEnabled = false
//            let tap = UITapGestureRecognizer(target: self, action: #selector(dropDownAction(_:)))
//            currentView.addGestureRecognizer(tap)
//        }
//    }
//    
//    func emptyValues() {
//        prefixInd = 0
//        prefixValue = ""
//        suffixInd = 0
//        suffixValue = ""
//        textFieldValue = ""
//    }
//    
//    func handleValue() {
//        if !textField.isHidden {
//            textField.text = textFieldValue
//        } else if !maskTextField.isHidden {
//            maskTextField.text = textFieldValue
//        }
//    }
//    
//    func handleMask(_ mask: String) {
//        maskTextField.isHidden = mask.isEmpty
//        textField.isHidden = !mask.isEmpty
//        if !mask.isEmpty {
//            let maskExpression = mask.replacingOccurrences(of: "9", with: "d").replacingOccurrences(of: "*", with: ".")
//            let maskTemplate = mask.replacingOccurrences(of: "9", with: "_").replacingOccurrences(of: "a", with: "_").replacingOccurrences(of: "*", with: "_")
//            let maskPlaceholder = maskTemplate.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
//            let specialChars: [Character] = ["d", "a", "."]
//            var newMask = ""
//            for char in maskExpression {
//                if specialChars.contains(char) {
//                    newMask.append("{\(char)}")
//                } else {
//                    newMask.append(char)
//                }
//            }
////            if Localizer.currentAppLanguageArabic() {
////                maskTextField.textAlignment = .right
////            } else {
////                maskTextField.textAlignment = .left
////            }
//            maskTextField.setMask(newMask, withMaskTemplate: "_")
//            maskTextField.placeholder = maskPlaceholder
//            maskTextField.maskDelegate = self
//            maskTextField.refreshMask()
//        }
//    }
//    
//    func setupWithNumerical(item: FormViewModelNumericItem) {
//        labelView.item = item
//        labelView.required = item.required
//        setupPlaceholderLabel(item)
//        handleMask("")
//        textField.keyboardType = .decimalPad
//        textField.text = ""
//        if let defaultValue = item.defaultAnswer?.value {
//            textField.text = "\(defaultValue)"
//        }
//        if let value = (item.answer as? BaseAnswerText)?.value {
//            textField.text = "\(value)"
//        }
//        attachmentNoteView.item = item
//        prefixView.isHidden = true
//        suffixView.isHidden = true
//        updateErrorState(item.isError, with: "")
//    }
//    
//    @objc func dropDownAction(_ sender: UITapGestureRecognizer) {
//        guard let item = item as? FormViewModelTextBoxItem else {
//            return
//        }
//        var options = [String]()
//        var prefix: Bool!
//        var model: PrefixViewModel?
//        if sender.view?.tag == 10 {
//            prefix = true
//            model = item.prefix
//        } else if sender.view?.tag == 20 {
//            prefix = false
//            model = item.suffix
//        }
//        if let model = model, let aOptions = getAffixValues(model, prefix: prefix, item: item) {
//            options = aOptions
//        }
//        let picker = ActionSheetStringPicker(title: "", rows: options, initialSelection: prefix ? prefixInd : suffixInd, doneBlock: { picker, selectedIndex, selectedValue in
//            if prefix {
//                self.prefixTextField.text = "\(selectedValue ?? "")"
//                self.prefixInd = selectedIndex
//                self.prefixValue = "\(selectedValue ?? "")"
//                self.submitValue(text: self.textField.text!)
//            } else {
//                self.suffixTextField.text = "\(selectedValue ?? "")"
//                self.suffixInd = selectedIndex
//                self.suffixValue = "\(selectedValue ?? "")"
//                self.submitValue(text: self.textField.text!)
//            }
//        }, cancel: { _ in
//            //empty
//        }, origin: sender.view)
//        
//        picker?.show()
//    }
//    
//    func checkError() -> Bool {
//        if textField.text!.lowercased().contains("er") {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func submitValue(text: String) {
//        if item is FormViewModelTextBoxItem {
//            let answerObject = TextboxAnswer(val: text, lPrefix: prefixValue, lSuffix: suffixValue)
//            valueChanged?(answerObject, self.checkError())
//        } else {
////            if let doubleValue = Double(text) {
//                let answerObject = BaseAnswerText(val: text)
//                numberValueChanged?(answerObject, self.checkError())
////            }
//        }
//    }
//    
//    func setupPlaceholderLabel(_ item: FormViewModelInteractiveItem) {
//        textField.placeholder = item.placeHolder
//        if isArabic() {
//            textField.placeholder = item.placeHolder
//        } else {
//            if let localization = item.localization as? InteractiveLocalization, let localizedPlaceholder = localization["ar"]?.placeholder, !localizedPlaceholder.isEmpty {
//                textField.placeholder = localizedPlaceholder
//            } else {
//                textField.placeholder = item.placeHolder
//            }
//        }
//    }
//    
//    func getAffixValues(_ affix: PrefixViewModel, prefix: Bool, item: FormViewModelTextBoxItem) -> [String]? {
//        return affix.value
////        if Localizer.isFormSameLanguage {
////            return affix.value
////        } else {
////            if let localization = item.localization as? TextBoxLocalization {
////                if prefix {
////                    return localization[Localizer.currentLanguage]?.prefix?.value?.components(separatedBy: ",") ?? affix.value
////                } else {
////                    return localization[Localizer.currentLanguage]?.suffix?.value?.components(separatedBy: ",") ?? affix.value
////                }
////            } else {
////                return affix.value
////            }
////        }
//    }
}

extension TextBoxTableViewCell: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else {
//            return false
//        }
//        let changedText = currentText.replacingCharacters(in: stringRange, with: string)
//        if let item = item as? FormViewModelTextBoxItem, textField == self.textField, let entryLimit = item.entryLimit {
//            let result = FormBuilder.shared.handleEntryLimit(entryLimit, changedText: changedText, item: item, row: item.fieldId)
//            if result.shouldChange {
//                if let subType = item.subType, subType == .Numeric, (string.isNotEmpty && !string.isNumber) {
//                    return false
//                }
//                attachmentNoteView.characterCountLabel.text = result.countLabel
//                updateErrorState(result.isError, with: result.errorMessage)
//            }
//            return result.shouldChange
//        } else if let item = item as? FormViewModelNumericItem {
//            let result = handleNumeric(newText: changedText, string: string, numericItem: item)
////            if result {
////                let textLimitResult = FormBuilder.shared.handleTextLimitLabel(current: changedText.count, fieldType: item.type, minLength: item.minDigit, maxLength: item.maxDigit, item: item)
////                attachmentNoteView.characterCountLabel.text = textLimitResult.countLabel
////                if textLimitResult.isError {
////                    updateErrorState(true, with: textLimitResult.errorMessage)
////                } else {
////                    let valueLimitResult = FormBuilder.shared.handleNumericValue(current: Double(changedText) ?? 0, minValue: item.minValue, maxValue: item.maxValue)
////                    updateErrorState(valueLimitResult.isError, with: valueLimitResult.errorMessage)
////                }
////            }
//            return result
//        }
//        return true
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == prefixTextField {
//            prefixValue = textField.text!
//        } else if textField == suffixTextField {
//            suffixValue = textField.text!
//        } else if textField == self.textField {
//            textFieldValue = textField.text!
//        } else if textField == maskTextField {
//            textFieldValue = textField.text!
//        }
//        submitValue(text: textFieldValue)
//    }
//    
//    func handleNumeric(newText: String, string: String, numericItem: FormViewModelNumericItem) -> Bool {
//        if string == "" {
//            return true
//        }
//        return Double(newText) != nil
//    }
//    
//    func numberOfDecimalDigits(_ text: String) -> Int {
//        let numberOfDecimalDigits: Int
//        if let dotIndex = text.firstIndex(of: ".") {
//            numberOfDecimalDigits = text.distance(from: dotIndex, to: text.endIndex) - 1
//        } else {
//            numberOfDecimalDigits = 0
//        }
//        return numberOfDecimalDigits
//    }
}

extension TextBoxTableViewCell: AKMaskFieldDelegate {
//    func maskFieldDidEndEditing(_ maskField: AKMaskField) {
//        textFieldDidEndEditing(maskField)
//    }
//    
//    func maskField(_ maskField: AKMaskField, shouldChangeBlock block: AKMaskFieldBlock, inRange range: inout NSRange, replacementString string: inout String) -> Bool {
//        return textField(maskField, shouldChangeCharactersIn: range, replacementString: string)
    }
//}
