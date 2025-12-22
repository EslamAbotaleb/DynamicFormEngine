//
//  MCQTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 17/05/2022.
//

import UIKit


class MCQTableViewCell: ParentFieldTableViewCell {
    
    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var mcqStackView: UIStackView!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!

    var item: FormViewModelItem! {
        didSet {
            if let checkBoxItem = item as? FormViewModelCheckboxItem {
                representation = checkBoxItem.representation
                setupWithItem(checkBoxItem)
            } else if let radioItem = item as? FormViewModelRadioItem {
                representation = radioItem.representation
                setupWithItem(radioItem)
            }
        }
    }
    
    var representation: CheckBoxRepresentation!
    var options = [MCQOption]()
    var hasOther = false
    var hasNA = false
    var otherOptionText: String?
    var naOptionText: String?
    var selectedValues = [String]()
    var otherValue = ""
    var valueChanged: ((BaseAnswerMCQ?, Bool) -> ())?
    var allShownChanged: ((Bool) -> ())?
    var allShown = false
    var oldSelectedValues = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWithItem(_ item: FormViewModelMCQBaseItem) {
        labelView.item = item
        labelView.required = item.required
        attachmentNoteView.item = item
        hasOther = item.otherOption
        hasNA = item.naOption
        otherOptionText = item.otherOptionText
        naOptionText = item.naOptionText
        handleOptionsLocalization(item.options ?? [], item: item)
        allShown = item.allShown
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
        if let defaultAnswer = item.defaultAnswer {
            handleValue(defaultAnswer)
        }
        if let value = item.answer as? BaseAnswerMCQ {
            handleValue(value)
        }
        handleOptionsData()
    }
    
    func handleOptionsLocalization(_ options: [MCQOption], item: FormViewModelMCQBaseItem) {
        let result = handleMCQLocalization(options, item: item)
        self.options = result.0
        otherOptionText = result.1
        naOptionText = result.2
    }
    
    func handleValue(_ value: BaseAnswerMCQ) {
        if let otherAnswer = value.otherAnswer, !otherAnswer.isEmpty {
            otherValue = otherAnswer
        }
//        selectedValues = value.value?.filter({!$0.isEmpty}) ?? []
        oldSelectedValues = selectedValues
    }
    
    func handleOptionsData() {
        for view in mcqStackView.subviews {
            view.removeFromSuperview()
        }
        for i in 0..<options.count {
            addCheckBoxView(options[i].name, index: i)
            if !allShown, i == 2 {
                break
            }
        }
        
        if options.count > 3 {
            var title = ""
            if allShown {
                title = "Show less"
            } else {
                title = "Show more" + " \(options.count - 3)"
            }
            addShowMoreView(title: title)
        }
        
        if hasOther && selectedValues.contains(where: {$0.isMCQOtherID}) {
            addOtherView()
        } else {
            otherValue = ""
        }
        self.mcqStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addCheckBoxView(_ option: String?, index: Int) {
        let checkBoxView = CheckBoxView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        checkBoxView.titleLabel.text = option
        checkBoxView.representation = representation
        checkBoxView.checked = selectedValues.contains(options[index].id ?? "")
        checkBoxView.selectionButton.tag = index
        checkBoxView.selectionButton.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
        mcqStackView.addArrangedSubview(checkBoxView)
    }
    
    func addShowMoreView(title: String) {
        let showMoreView = ShowMoreView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        showMoreView.showMoreButton.setTitle(title, for: .normal)
        showMoreView.showMoreButton.addTarget(self, action: #selector(showMoreAction(_:)), for: .touchUpInside)
        self.mcqStackView.addArrangedSubview(showMoreView)
    }
    
    func addOtherView() {
        let otherView = OtherOptionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        otherView.otherTextField.placeholder = (item as? FormViewModelCheckboxItem)?.otherOptionText
        otherView.otherTextField.text = otherValue
        otherView.otherTextField.delegate = self
        self.mcqStackView.addArrangedSubview(otherView)
    }
    
    @objc func showMoreAction(_ sender: UIButton) {
        allShown.toggle()
        allShownChanged?(allShown)
    }
    
    @objc func selectAction(_ sender: UIButton) {
        guard let id = options[sender.tag].id else {
            return
        }
        if representation == .CheckBox {
            if selectedValues.contains(id) {
                removeValue(id)
            } else {
                selectedValues.append(id)
            }
        } else {
            if selectedValues.contains(id) {
                removeValue(id)
            } else {
                selectedValues = [id]
            }
        }
        handleOptionsData()
        saveChanges()
    }
    
    func removeValue(_ id: String) {
        selectedValues.removeAll(where: {$0 == id})
        if id.isMCQOtherID {
            otherValue = ""
        }
    }
    
    func saveChanges() {
        if (selectedValues.contains(where: {$0.isMCQOtherID}) && !oldSelectedValues.contains(where: {$0.isMCQOtherID})) || (oldSelectedValues.contains(where: {$0.isMCQOtherID}) && !selectedValues.contains(where: {$0.isMCQOtherID})) {
//            valueChanged?(BaseAnswerMCQ(val: selectedValues, otherAnswer: otherValue), true)
        } else {
//            valueChanged?(BaseAnswerMCQ(val: selectedValues, otherAnswer: otherValue), false)
        }
    }
}

extension MCQTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        otherValue = textField.text!
        saveChanges()
    }
}
