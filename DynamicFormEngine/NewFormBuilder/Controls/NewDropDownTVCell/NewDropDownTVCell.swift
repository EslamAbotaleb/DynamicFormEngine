//
//  NewDropDownTVCell.swift
//
//
//  Created by mac on 1/29/23.
//  Copyright © 2023 All rights reserved.
//

import UIKit
import FittedSheets

class NewDropDownTVCell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overlineLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var checkedImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var errorStack: UIStackView!
    @IBOutlet weak var toolTipIcon: UIButton!
    @IBOutlet weak var selectedOptionsCV: UICollectionView!

    
    var toolTipTxt = ""
    var inlineError = false
    // MARK: - Variables
    override func prepareForReuse() {
        super.prepareForReuse()
//        valueTF.text = ""
        selectedValues = []
    }
    var isSectionItem = false
    var item: FormViewModelItem! {
        didSet {
            if let dropDownitem = item as? FormViewModelDropdownItem {
//                valueTF.text = ""
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                item.isSectionControl = isSectionItem
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupTitle(item: dropDownitem)
                setupSubTitle(item: dropDownitem)
                setupSubPlaceholder(item: dropDownitem)
                hasOther = dropDownitem.otherOption
                
                if let ddlAnswer = dropDownitem.answer as? [MCQOption] {
                    handleValueMappedFromOptions(ddlAnswer)
                }
                if let value = dropDownitem.answer as? BaseAnswerMCQ {
                    handleValue(value)
                    if self.parentCascadingItemID == item.fieldId {
                        handleOptions()
                    }else { // clear child value for new parent
                        if #available(iOS 16.0, *) {
                            if !(dropDownitem.options ?? []).contains(value.value ?? []) && dropDownitem.defaultAnswer == nil {
                                selectedValues = []
                                valueTF.text = ""
                            }
                        }
                    }
                } else if let defaultAnswer = dropDownitem.defaultAnswer {
                    handleValue(defaultAnswer)
                    if self.parentCascadingItemID == item.fieldId {
                        handleOptions()
                    }else { // clear child value for new parent
                        if #available(iOS 16.0, *) {
                            if !(dropDownitem.options ?? []).contains(defaultAnswer.value ?? []) && dropDownitem.defaultAnswer == nil {
                                selectedValues = []
                                valueTF.text = ""
                            }
                        }
                    }
                }
                
                
                if (dropDownitem.answer as? [MCQOption])?.count ?? 0 > 0 {
                    self.selectedValues = dropDownitem.answer as! [MCQOption]
                }
                hasNA = dropDownitem.naOption
                otherOptionText = dropDownitem.otherOptionText
                naOptionText = dropDownitem.naOptionText
                
                handleOptionsLocalization(dropDownitem.options ?? [], item: dropDownitem)

                if (dropDownitem.options?.isEmpty ?? true || dropDownitem.options == nil) && dropDownitem.isCascade == false && dropDownitem.isCascadeValuesEmpty == false {
                    if let sourceId = dropDownitem.dataSourcId {
                        if item.answer == nil || (item.answer as? BaseAnswerMCQ)?.value?.count ?? 0 == 0 {
                            dataSourceFetchingInDDL?(sourceId, item)
                        }
                    }
                }
                
                if hasOther {
                    if isArabicCerqel() {
                        options.append(MCQOption(id: nil,other: true, name: nil, name_ar: otherOptionText))
                    }else {
                        options.append(MCQOption(id: nil,other: true, name: otherOptionText, name_ar: nil))
                    }
                    
                }
                if hasNA {
                    if isArabicCerqel() {
                        options.append(MCQOption(id: nil,other: false, name: nil, name_ar: naOptionText))
                    }else {
                        options.append(MCQOption(id: nil,other: false, name: naOptionText, name_ar: nil))
                    }
                    
                }
                
                
                if item.isUpdated/*, dropDownitem.required*/ {
                    let result = FormBuilder.shared.handleDropDownError(optionsCount: selectedValues.count,
                                                                        minOptions: dropDownitem.minNumberOfSelectedOptions,
                                                                        maxOptions: dropDownitem.maxNumberOfSelectedOptions,
                                                                        item: dropDownitem,
                                                                        row: item.fieldId)
                    errorLbl.text = result.errorMessage
                    item.errorMessageInline = result.errorMessage
                    item.inLineError = result.isError
                    errorStack.isHidden = !result.isError
                    errorLbl.isHidden = !result.isError
                    updateErrorState(result.isError, with: result.errorMessage)
//                    validationChanged?(!result.isError)
                } else {
                    item.errorMessageInline = ""
                    item.inLineError = false
                    errorLbl.text = ""
                    errorStack.isHidden = true
                    errorLbl.isHidden = true
                }
                
                if item.disabled || item.field?.properties?.readonly ?? false {
                    bgView.backgroundColor = .emptyStateColor1
                    v.backgroundColor = .emptyStateColor1
                    bgView.borderColorV = .emptyStateColor2
                    selectionBtn.isHidden = true
                    arrowImgView.tintColor = .greyIcon
                } else {
                    bgView.backgroundColor = .white
                    v.backgroundColor = .white
                    bgView.borderColorV = .gray
                    selectionBtn.isHidden = false
                    arrowImgView.tintColor = primaryMain
                }
                updateValidationError(with: dropDownitem.errorMessageInline)
            }
        }
    }
    
    var options = [MCQOption]()
    var hasOther = false
    var hasNA = false
    var otherOptionText: String?
    var naOptionText: String?
    var selectedValues = [MCQOption]() {
        didSet {
            if selectedValues.isEmpty {
                selectedOptionsCV.isHidden = true
            }else {
                selectedOptionsCV.isHidden = false
                valueTF.placeholder = nil
            }
            DispatchQueue.main.async {[weak self] in
                self?.selectedOptionsCV.reloadData()
            }
        }
    }
    var otherValue = ""
    var valueChanged: ((BaseAnswerMCQ?,_ isError: Bool) -> ())?
    var dropDownPressed: ((_ options: [MCQOption],_ title: String?,_ placeHolder: String?,_ selectedValue: [MCQOption],_ multiSelect: Bool,_ selectAllEnables: Bool,_ subType: String)->())?
    var parentCascadingItemID: String?
    var didPressSelectBtn: ((_ options: [MCQOption])->())?
    var didSelectOption: ((_ optionIdx: Int, _ conditionsAfterValidations: [Validations], _ isValid: Bool, _ inValidCon: Validations, ValidationName?)->())?
    var validationChanged: ((Bool) -> ())?
    var dataSourceFetchingInDDL: ((_ dataSource: String, FormViewModelItem)->())?

   
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureOptionsCV()
        handleGesture()
        setValueTFPadding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setValueTFPadding() {
        valueTF.setRightPaddingPoints(30)
    }
    
    private func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Functions
    
    private func configureUI() {
        titleLbl.textColor = typographyTitle
        descLbl.textColor = typographySubtitle
        toolTipIcon.tintColor = typographyTitle
    }
    
    private func configureOptionsCV() {
        selectedOptionsCV.register(AddEditInvitedCV.cerqel_nib, forCellWithReuseIdentifier: AddEditInvitedCV.cerqel_identifier)
        selectedOptionsCV.delegate = self
        selectedOptionsCV.dataSource = self
        selectedOptionsCV.reloadData()
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
    
    func loadErrorMessageText(dropDownitem: FormViewModelDropdownItem){
        if item.isUpdated, dropDownitem.required {
            let result = FormBuilder.shared.handleDropDownError(optionsCount: selectedValues.count,
                                                                minOptions: dropDownitem.minNumberOfSelectedOptions,
                                                                maxOptions: dropDownitem.maxNumberOfSelectedOptions,
                                                                item: dropDownitem,
                                                                row: item.fieldId)
            errorLbl.text = result.errorMessage
            errorStack.isHidden = !result.isError
            errorLbl.isHidden = !result.isError
            updateErrorState(result.isError, with: result.errorMessage)
        } else {
            errorLbl.text = ""
            errorStack.isHidden = true
            errorLbl.isHidden = true
        }
    }
    
    func disableDropDown() {
        bgView.backgroundColor = .emptyStateColor1
        v.backgroundColor = .emptyStateColor1
        bgView.borderColorV = .emptyStateColor2
        selectionBtn.isHidden = true
    }
    
    func setupTitle(item: FormViewModelDropdownItem) {
        guard let localization = item.localization as? InteractiveLocalization else { return }
        if !isArabicCerqel() {
            if item.required {
                handleRequire(txt: localization["en"]?.label ?? "")
            } else {
                titleLbl.text = localization["en"]?.label
            }
        } else {
            if item.required {
                handleRequire(txt: localization["ar"]?.label ?? "")
            } else {
                titleLbl.text = localization["ar"]?.label
            }
        }
        titleLbl.isHidden = (titleLbl.text ?? "").isEmpty ? true : false
        if !isArabicCerqel() {
            if let localizedToolTip =  localization["en"]?.tooltip, !localizedToolTip.isEmpty {
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

    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
    
    func handleRequire(txt:String) {
        let st = txt
        let last = " *"

        let firstAttributes: [NSAttributedString.Key: Any] = [:]
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.heading1(ofSize: 12)]

        let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
        let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)

        firstString.append(lastString)

        self.titleLbl.attributedText = firstString
    }
    
    func handleValueMappedFromOptions(_ options: [MCQOption]) {
        // Find the option matching the given value (ID)
        if !(options.isEmpty ?? false) {
            // Set selectedValues to contain the matched option
            selectedValues = options
            handleOptions()
            // Update the valueTF text based on the language setting
//            if isArabic() {
//                valueTF.text = selectedValues.map({ $0.name_ar ?? "" }).joined(separator: ", ")
//            } else {
//                valueTF.text = selectedValues.map({ $0.name ?? "" }).joined(separator: ", ")
//            }
        } else {
            // Handle the case where no matching option is found
            selectedValues = []
//            valueTF.text = ""
        }
    }
    
    func setupSubTitle(item: FormViewModelDropdownItem) {
        guard let localization = item.localization as? InteractiveLocalization else { return }
        if !isArabicCerqel() {
            descLbl.text = localization["en"]?.sublabel
        } else {
            descLbl.text = localization["ar"]?.sublabel
        }
        descLbl.isHidden = (descLbl.text ?? "").isEmpty ? true : false
    }

    func setupSubPlaceholder(item: FormViewModelDropdownItem) {
        guard let localization = item.localization as? InteractiveLocalization, selectedValues.isEmpty else { return }
        if !isArabicCerqel() {
            valueTF.placeholder = localization["en"]?.placeholder
        } else {
            valueTF.placeholder = localization["ar"]?.placeholder
        }
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
        }
        selectedValues = value.value ?? []
//        if isArabicCerqel() {
//            valueTF.text = selectedValues.map({ $0.name_ar ?? ""}).joined(separator: ", ")
//        }else {
//            valueTF.text = selectedValues.map({ $0.name ?? ""}).joined(separator: ", ")
//        }
    }
    
    func handleValueMappedFromOptions(_ options: [MCQOption], value: BaseAnswerMCQGUID) {
        // Find the option matching the given value (ID)
        for val in value.value ?? [] {
            if let selectedOption = options.first(where: { $0.id == val }) {
                // Set selectedValues to contain the matched option
                selectedValues = [selectedOption]
                handleOptions()
                // Update the valueTF text based on the language setting
//                if isArabicCerqel() {
//                    valueTF.text = selectedValues.map({ $0.name_ar ?? "" }).joined(separator: ", ")
//                } else {
//                    valueTF.text = selectedValues.map({ $0.name ?? "" }).joined(separator: ", ")
//                }
            } else {
                // Handle the case where no matching option is found
                selectedValues = []
//                valueTF.text = ""
            }
        }
    }



    func handleOptions() {
        saveChanges(selectedValues)
    }
    
    func saveChanges(_ values: [MCQOption]) {
        valueChanged?(BaseAnswerMCQ(val: values, otherAnswer: otherValue), checkError())
    }
    
    
    func checkError() -> Bool {
        if !(errorLbl.isHidden) {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func selectBtnIsPressed(_ sender: Any) {
        item.isUpdated = true
        dropDownPressed!(options, titleLbl.text, valueTF.placeholder, selectedValues, (item as? FormViewModelDropdownItem)?.multiSelect ?? false, (item as? FormViewModelDropdownItem)?.selectAllBox ?? false , (item as? FormViewModelDropdownItem)?.ddlSubType ?? "")
        
        if let sourceId = (item as? FormViewModelDropdownItem)?.dataSourcId {
            if let item = item as? FormViewModelDropdownItem, item.isCascade != true {
                if item.answer == nil || (item.answer as? BaseAnswerMCQ)?.value?.count ?? 0 == 0 {
                    dataSourceFetchingInDDL?(sourceId, item)
                }
            }
        }
    }
    
}

extension NewDropDownTVCell: NewDropDownDelegate {
    func userSelected(_ ids: [MCQOption]) {
        selectedValues = ids
        handleOptions()
    }
}

extension NewDropDownTVCell: ValidatableCell {
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
        errorLbl.text = message
        updateErrorVisibility(isHidden: false)
        updateErrorState(true)
    }

    func clearValidationError() {
        errorLbl.text = ""
        updateErrorVisibility(isHidden: true)
        updateErrorState(false)
    }

    private func updateErrorVisibility(isHidden: Bool) {
        errorStack.isHidden = isHidden
        errorLbl.isHidden = isHidden
    }

    private func updateErrorState(_ isError: Bool) {
        // Update any additional UI elements based on error state
        // e.g., changing border color, background, etc.
    }
}

