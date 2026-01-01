//
//  DropDownTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 19/05/2022.
//

import UIKit
//import ActionSheetPicker_3_0
import IQKeyboardManagerSwift

class DropDownTableViewCell: ParentFieldTableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelDropdownItem {
                labelView.item = item
                labelView.required = item.required
                attachmentNoteView.item = item
                hasOther = item.otherOption
                hasNA = item.naOption
                otherOptionText = item.otherOptionText
                naOptionText = item.naOptionText
                handleOptionsLocalization(item.options ?? [], item: item)
                if hasOther {
                    if isArabic() {
                        options.append(MCQOption(id: nil,other: true, name: nil, name_ar: otherOptionText))
                    }else {
                        options.append(MCQOption(id: nil,other: true, name: otherOptionText, name_ar: nil))
                    }
                    
                }
                if hasNA {
                    if isArabic() {
                        options.append(MCQOption(id: nil,other: false, name: nil, name_ar: naOptionText))
                    }else {
                        options.append(MCQOption(id: nil,other: false, name: naOptionText, name_ar: nil))
                    }
                    
                }
//                if hasOther {
//                    options.append(MCQOption(id: nil,other: true, name: otherOptionText))
//                }
//                if hasNA {
//                    options.append(MCQOption(id: nil,other: false, name: naOptionText))
//                }
                otherTextField.placeholder = otherOptionText
                if let defaultAnswer = item.defaultAnswer {
                    handleValue(defaultAnswer)
                }
                if let value = item.answer as? BaseAnswerMCQ {
                    handleValue(value)
                }
            }
        }
    }
    
    var options = [MCQOption]()
    var hasOther = false
    var hasNA = false
    var otherOptionText: String?
    var naOptionText: String?
    var selectedValues = [String]()
    var otherValue = ""
    var valueChanged: ((BaseAnswerMCQ?) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 1
//        outerView.addCornerRadius(4)
        otherTextField.delegate = self
    }
    
    func handleOptionsLocalization(_ options: [MCQOption], item: FormViewModelDropdownItem) {
        let result = handleMCQLocalization(options, item: item)
        self.options = result.0
        otherOptionText = result.1
        naOptionText = result.2
    }
    
    func handleValue(_ value: BaseAnswerMCQ) {
        if let otherAnswer = value.otherAnswer, !otherAnswer.isEmpty {
            otherValue = otherAnswer
            otherTextField.text = otherAnswer
            otherTextField.isHidden = false
        }
//        selectedValues = value.value ?? []
        selectedLabel.text = options.filter({selectedValues.contains($0.id ?? "")}).map({$0.name ?? ""}).joined(separator: ", ")
        if selectedValues.contains(where: {$0.isMCQOtherID}) {
            self.otherTextField.text = otherValue
            self.otherTextField.isHidden = false
        } else {
            self.otherValue = ""
            self.otherTextField.isHidden = true
        }
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        let dropDownVC = Utilities.instantiateVCWithId("dropDownVC") as! DropDownViewController
        dropDownVC.delegate = self
        dropDownVC.questionTitle = item.label
        dropDownVC.allOptions = options
        dropDownVC.selectedValues = selectedValues
        dropDownVC.multiSelect = (item as? FormViewModelDropdownItem)?.multiSelect ?? false
        dropDownVC.selectAllEnabled = (item as? FormViewModelDropdownItem)?.selectAllBox ?? false
        self.parentContainerViewController()?.present(dropDownVC, animated: true)
    }
    
    func handleOptions() {
        if !selectedValues.contains(where: {$0.isMCQOtherID}) {
            self.otherValue = ""
            self.otherTextField.isHidden = true
        } else {
            self.otherTextField.text = otherValue
            self.otherTextField.isHidden = false
        }
        saveChanges(selectedValues)
    }
    
    func saveChanges(_ values: [String]) {
//        valueChanged?(BaseAnswerMCQ(val: values, otherAnswer: otherValue))
    }
}

extension DropDownTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        otherValue = textField.text!
        handleOptions()
    }
}

extension DropDownTableViewCell: DropDownDelegate {
    func userSelected(_ ids: [String]) {
        selectedValues = ids
        handleOptions()
    }
}
