//
//  NewCheckBoxTVCell.swift
// 
//
//  Created by Mohamed Karmout on 25/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewCheckBoxTVCell: ParentFieldTableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var ttlLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var subTitleHeight: NSLayoutConstraint!
    
    @IBOutlet weak var checkBoxStack: UIStackView!
    @IBOutlet weak var checkedImgView: UIImageView!
    @IBOutlet weak var selectionImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var toolTipIcon: UIButton!

    
    // MARK: - Variables
    var isSectionItem = false
    var checkboxViews: [MCQOption : NewCheckboxView] = [:]
    var representation: CheckBoxRepresentation!
    var minNumberOfSelectedOptions: Int = 1
    var maxNumberOfSelectedOptions: Int?
    var selectedOptions: [MCQOption] = []
    var valueChangedCheckBox: ((BaseAnswerMCQ?, _ isError: Bool) -> ())?
    var valueChangedRadio: ((BaseAnswerMCQ?, _ isError: Bool) -> ())?
    var validationChanged: ((Bool) -> ())?
    var isFromRequest: Bool = false
    
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?
    
    var item: FormViewModelItem! {
        didSet {
            if let checkBoxItem = item as? FormViewModelMCQBaseItem {
                setupItem(checkBoxItem)
            }
        }
    }
    var toolTipTxt = ""
    var inlineError = false
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        handleGesture()
    }
    
    private func configureUI() {
        ttlLbl.textColor = typographyTitle
        subLbl.textColor = typographySubtitle
        toolTipIcon.tintColor = typographyTitle
    }
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        ttlLbl.isUserInteractionEnabled = true
        ttlLbl.addGestureRecognizer(tapGesture)
    }
    
    func setupTitle(item: FormViewModelMCQBaseItem?) {
        if let localization = item?.localization as? InteractiveLocalization {
            item?.isSectionControl = isSectionItem
            contentView.backgroundColor = isSectionItem ? .white : .clear
            updateConstraintsForSectionItem(section: item?.isSectionControl ?? false)
            if !isArabicCerqel() {
                if let localizedLabel = localization["en"]?.label, !localizedLabel.isEmpty {
                    self.isRequiredField(item: item, value: localizedLabel)
                } else {
                    self.isRequiredField(item: item, value: item?.label ?? "")
                }
            } else {
                if let localizedLabel = localization["ar"]?.label, !localizedLabel.isEmpty {
                    self.isRequiredField(item: item, value:localizedLabel)
                } else {
                    self.isRequiredField(item: item, value: item?.label ?? "")
                }
            }
        } else {
            self.isRequiredField(item: item, value: item?.label ?? "")
        }
        ttlLbl.isHidden = (ttlLbl.text ?? "").isEmpty ? true : false
        if !isArabicCerqel() {
            if let localizedToolTip = item?.localization?["en"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item?.tooltip ?? ""
            }
        } else {
            if let localizedToolTip = item?.localization?["ar"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item?.tooltip ?? ""
            }
        }
        toolTipIcon.isHidden = toolTipTxt.isEmpty
        updateErrorState(inlineError: item?.inLineError ?? false, message: item?.errorMessageInline ?? "")
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
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
    
    func setupSubTitle(item: FormViewModelMCQBaseItem?){
        if let localization = item?.localization as? InteractiveLocalization {
            if !isArabicCerqel() {
                if let localizedLabel = localization["en"]?.sublabel, !localizedLabel.isEmpty {
                    subLbl.text = localizedLabel
                } else {
                    subLbl.text = item?.sublabel
                }
            } else {
                if let localizedLabel = localization["ar"]?.sublabel, !localizedLabel.isEmpty {
                    subLbl.text = localizedLabel
                } else {
                    subLbl.text = item?.sublabel
                }
            }
        } else {
            subLbl.text = item?.sublabel
        }
        if subLbl.text?.isEmpty == true {
            subLbl.isHidden = true
            subTitleHeight.constant = .zero
        } else {
            subLbl.isHidden = false
        }
    }
    
    
    func isRequiredField(item:FormViewModelMCQBaseItem?,value:String){
        if let isRequired = item?.required{
            if isRequired {
                let st = value
                let last = " *"
                
                let firstAttributes: [NSAttributedString.Key: Any] = [:]
                let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.SST_Arabic_Bold(ofSize: 15)]
                
                let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
                let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
                
                firstString.append(lastString)
                
                self.ttlLbl.attributedText = firstString
            }else{
                self.ttlLbl.text = value
            }
        }else{
            self.ttlLbl.text = value
        }
    }

    func setupItem(_ item: FormViewModelMCQBaseItem) {
        resetValues()
        setupTitle(item: item)
        setupSubTitle(item: item)
        if let value = item.defaultAnswer { selectedOptions = value.value ?? [] }
        if let value = item.answer as? BaseAnswerMCQ { selectedOptions = value.value ?? [] }
        setupCheckboxesProperties(item: item)
        setupOptions(item: item)
        if item.isUpdated {
            addErrorMsg()
        }
        
        if let dataSourceId = item.field?.properties?.dataSourcId {
            if item.answer == nil || (item.answer as? BaseAnswerMCQ)?.value?.count ?? 0 == 0 {
                dataSourceFetching?(dataSourceId,item)
            }
        }
    }
    
    func handleDissabledControl(isFromRequest: Bool , item: FormViewModelMCQBaseItem?) {
        if isFromRequest {
            checkBoxStack.isUserInteractionEnabled = false
        }else {
            handleDissabledData(isDisabled: item?.disabled ?? false)
            handleDissabledData(isDisabled: item?.field?.properties?.disabled ?? false)
        }
    }
    
    func handleDissabledData(isDisabled: Bool){
        stackView.isUserInteractionEnabled = !isDisabled
        
    }
    
    func handleValueMappedFromOptions(_ options: [MCQOption], value: BaseAnswerMCQGUID) {
        // Find the option matching the given value (ID)
        for val in value.value ?? [] {
            if let selectedOption = options.first(where: { $0.id == val }) {
                // Set selectedValues to contain the matched option
                checkAction(option: selectedOption, isFromDefaultAnswer: true)
            } else {
                // Handle the case where no matching option is found
                resetValues()
            }
        }
    }
    
    func setupCheckboxesProperties(item: FormViewModelMCQBaseItem) {
        if let item = item as? FormViewModelCheckboxItem {
            self.representation = .CheckBox
            self.minNumberOfSelectedOptions = item.minNumberOfSelectedOptions ?? 1
            self.maxNumberOfSelectedOptions = item.maxNumberOfSelectedOptions ?? item.options?.count ?? 1
        } else if let item = item as? FormViewModelRadioItem {
            self.representation = .Radio
            self.minNumberOfSelectedOptions = 1
            self.maxNumberOfSelectedOptions = 1
            
        }
        
    }
    
    func setupOptions(item: FormViewModelMCQBaseItem) {
        guard let options = item.options, !options.isEmpty else { return }
        
        for option in options {
            let checkboxView = generateCheckboxView(option: option,isDisabled: item.field?.properties?.readonly ?? false)
            checkboxViews[option] = checkboxView
            stackView.addArrangedSubview(checkboxView)
        }
        
        for checkboxView in checkboxViews {
            if selectedOptions.contains(where: { $0 == checkboxView.key }) {
                checkboxView.value.isSelected = true
                checkboxView.value.setChecked(isDisabled: item.field?.properties?.readonly ?? false)
            }
        }
        
    }
    
    func generateCheckboxView(option: MCQOption,isDisabled: Bool) -> NewCheckboxView {
        let checkboxView = NewCheckboxView()
        checkboxView.canInteraction = !isDisabled
        if isArabicCerqel() {
            checkboxView.title = option.name_ar ?? ""
        }else {
            checkboxView.title = option.name ?? ""
        }
        checkboxView.checkboxRepresentation = self.representation
        checkboxView.setupUI()
        checkboxView.didCheck =  { [weak self] in
            guard let self = self else { return }
            self.checkAction(option: option)
        }
        
        checkboxView.didUncheck = { [weak self] in
            guard let self = self else { return }
            self.uncheckAction(option: option)
        }
        
        if isFromRequest {
            checkboxView.checkboxDisabled()
        }
        
        return checkboxView
    }
    
    func checkAction(option: MCQOption, isFromDefaultAnswer: Bool? = false) {
        guard let checkboxView = checkboxViews[option] else { return }
        item.isUpdated = true
        checkboxView.isSelected = isFromDefaultAnswer ?? false
        if item is FormViewModelCheckboxItem {
            checkboxView.setChecked(isDisabled: item.field?.properties?.readonly ?? false)
            selectedOptions.append(option)

        } else {
            if selectedOptions.count < maxNumberOfSelectedOptions ?? 1 {
                checkboxView.setChecked(isDisabled: item.field?.properties?.readonly ?? false)
                selectedOptions.append(option)
            } else {
                if let lastOption = selectedOptions.last, let lastCheckboxView = checkboxViews[lastOption] {
                    lastCheckboxView.setUnchecked(isDisabled: item.field?.properties?.readonly ?? false)
                    lastCheckboxView.isSelected = false
                    selectedOptions.removeLast()
                    checkboxView.setChecked(isDisabled: item.field?.properties?.readonly ?? false)
                    selectedOptions.append(option)
                }
            }
        }
        if self.representation == .Radio {
            saveValuesToRadio()
        } else if self.representation == .CheckBox {
            saveValuesToCheckBox()
        }
        handleValidation()
    }
    
    func uncheckAction(option: MCQOption) {
        guard let checkboxView = checkboxViews[option], let optionIndex = getIndexOfOption(id: option.id ?? "") else { return }
        item.isUpdated = true
        checkboxView.setUnchecked(isDisabled: item.field?.properties?.readonly ?? false)
        selectedOptions.remove(at: optionIndex)
        if self.representation == .Radio {
            saveValuesToRadio()
        } else if self.representation == .CheckBox {
            saveValuesToCheckBox()
        }
        self.handleValidation()
    }
    
    func getIndexOfOption(id: String) -> Int? {
        return selectedOptions.firstIndex(where: { $0.id == id })
    }
    
    func addErrorMsg(){
        guard let item = item as? FormViewModelMCQBaseItem else { return }

        let result = FormBuilder.shared.handleCheckboxValidation(item: item, selectedOptions: selectedOptions, min: minNumberOfSelectedOptions, max: maxNumberOfSelectedOptions, row: item.fieldId)
        if result.error, item.required {
            errorView.isHidden = false
            errorLabel.text = result.errorMessage
            item.inLineError = result.error
            item.errorMessageInline = result.errorMessage
        } else {
            errorView.isHidden = true
        }
    }
    
    func handleValidation() {
        guard let item = item as? FormViewModelMCQBaseItem else { return }

        let result = FormBuilder.shared.handleCheckboxValidation(item: item, selectedOptions: selectedOptions, min: minNumberOfSelectedOptions, max: maxNumberOfSelectedOptions, row: item.fieldId)
        if result.error/*, item.required*/ {
            errorView.isHidden = false
            errorLabel.text = result.errorMessage
        } else {
            errorView.isHidden = true
        }
//        if selectedOptions.count == 0 && !item.required {
//            validationChanged?(true)
//        }else{
            validationChanged?(!result.error)
//        }
        
    }
    
    func saveValuesToCheckBox() {
        let answer = BaseAnswerMCQ(val: selectedOptions)
        valueChangedCheckBox?(answer,checkError())
        item.isUpdated = true
    }
    func saveValuesToRadio() {
        let answer = BaseAnswerMCQ(val: selectedOptions)
        valueChangedRadio?(answer,checkError())
        item.isUpdated = true
    }
    
    func checkError() -> Bool {
        if !(errorView.isHidden) {
            return true
        } else {
            return false
        }
    }
    
    func resetValues() {
        checkboxViews = [:]
        selectedOptions = []
        stackView.removeAllArrangedSubviewsCompletely()
        errorView.isHidden = true
        errorLabel.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - IBActions
    
    @IBAction func selectionBtnTapped(){
        selectionImgView.isHighlighted = true
    }
}

extension NewCheckBoxTVCell: ValidatableCell {
    func updateErrorState(inlineError: Bool, message: String = "") {
        self.inlineError = inlineError
        if inlineError {
            displayValidationError(message)
        } else {
            clearValidationError()
        }
    }

    func displayValidationError(_ message: String) {
//        updateConstraintsForSectionItem(section: item.isSectionControl)
        errorView.isHidden = false
        errorLabel.text = message
    }

    func clearValidationError() {
        errorView.isHidden = true
        errorLabel.text = ""
    }
}

