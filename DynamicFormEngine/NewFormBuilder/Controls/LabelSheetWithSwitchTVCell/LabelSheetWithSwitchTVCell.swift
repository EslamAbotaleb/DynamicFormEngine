//
//  LabelSheetWithSwitchTVCell.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit


class LabelSheetWithSwitchTVCell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var switchCtlContainerView: UIStackView!
    @IBOutlet weak var switchCtl: UISwitch!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var openSheetLbl: UILabel!
    @IBOutlet weak var errIcon: UIImageView!
    @IBOutlet weak var errLbl: UILabel!
    @IBOutlet weak var errorContainer: UIStackView!
    @IBOutlet weak var checkBoxBtnContainerView: UIStackView!
    @IBOutlet weak var checkBoxBtn: UIButton!{
        didSet{
            checkBoxBtn.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
        }
    }
    @IBOutlet weak var toolTipIcon: UIButton!


    
    // MARK: - Variables
    var isSectionItem = false
    var validationChanged: ((Bool) -> ())?
    var dataSourceId = ""
    var didTapOpenBottomSheet: (() -> ())?
    var isRequired = false
    var isLabelSheetWithCheckBox = false
    var isLabelSheet = false
    var toolTipTxt = ""
    var reloadTableView: (() -> ())?
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelParagraphItem {
                contentView.backgroundColor = isSectionItem ? .white : .clear
                item.isSectionControl = isSectionItem
                updateConstraintsForSectionItem(section: item.isSectionControl)
                if let properties = item.field?.properties as? ParagraphProperties {
                    guard let localization = item.localization as? ParagraphLocalization else { return }
                    emptyValues()
                    let required = properties.required ?? false
                    self.isRequired = required
                    if isLabelSheet {
                        configureUIForLabelSheet()
                    } else {
                        configureUI()
                    }
                    isRequiredField(required: required,
                                    value:  (isArabicCerqel() ?  localization["ar"]?.label ?? "" :  localization["en"]?.label) ?? "")
                    if let localization = item.localization as? ParagraphLocalization {
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
                    }
                    toolTipIcon.isHidden = toolTipTxt.isEmpty
                    if let url = properties.dataSourcId {
                        dataSourceId = url
                    }
                    
                    let urlValue = isArabicCerqel() ?  ((localization["ar"]?.paragraphText == "" || localization["ar"]?.paragraphText == nil)  ? properties.paragraphText : localization["ar"]?.paragraphText ) :  ((localization["en"]?.paragraphText == ""  || localization["en"]?.paragraphText == nil) ?  properties.paragraphText : localization["en"]?.paragraphText )
                    subLbl.text = isArabicCerqel() ?  localization["ar"]?.sublabel :  localization["en"]?.sublabel
                    subLbl.isHidden =  subLbl.text == ""
                    if let stringValue = (item.answer as? ParagraphAnswer)?.value{
                        switchCtl.isOn = stringValue.lowercased() == "true"
                    } else if let defAns = (item.field?.properties as? ParagraphProperties)?.defaultAnswer?.value {
                        switchCtl.isOn = defAns.lowercased() == "true"
                    }
                    self.openSheetLbl.text = urlValue
                    self.openSheetLbl.isUserInteractionEnabled = properties.dataSourcId != nil ? true : false
                    
                    if let dataSourceId = properties.dataSourcId {
                        dataSourceFetching?(dataSourceId,item)
                    }
                }
                updateErrorState(inlineError: item.inLineError, message: item.errorMessageInline)
//                handleDisabledData(isDisabled: item.disabled)
            }
            
        }
    }
    var inlineError = false
    
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
    
    func handleDisabledData(isDisabled: Bool){
        checkBoxBtn.isUserInteractionEnabled = !isDisabled
        switchCtl.isUserInteractionEnabled = !isDisabled
    }
    
    func handleDisableControl(item: FormViewModelParagraphItem?,isRequest: Bool) {
        if isRequest {
            checkBoxBtn.isUserInteractionEnabled = !isRequest
            switchCtl.isUserInteractionEnabled = !isRequest
        }else {
            handleDisabledData(isDisabled: item?.disabled ?? false)
            handleDisabledData(isDisabled: item?.field?.properties?.readonly ?? false)
        }
    }
    
    func handleToggleValidation(isSwitchOn: Bool) {
        guard let item = item as? FormViewModelParagraphItem else { return }
        if  !self.isRequired {
            validationChanged?(true)
            errorContainer.isHidden = true
        } else {
            let validation = FormBuilder.shared.handleSwitchValidation(value: isSwitchOn, item: item, required: self.isRequired, row: item.fieldId)

            if validation.isError, validation.errorType == .required {
                errLbl.text = validation.errorMessage
                item.errorMessageInline = validation.errorMessage
                item.inLineError = validation.isError
                errorContainer.isHidden = false
            } else {
                errLbl.text = ""
                errorContainer.isHidden = true
            }
            return
        }
    }
    
    
    
    
    // MARK: - LifeCycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLabelAction()
        handleGesture()
    }
    
    func emptyValues() {
        switchCtl.isOn = false
        errorContainer.isHidden = true
    }
    
    func configureUI(){
        checkBoxBtnContainerView.isHidden = !isLabelSheetWithCheckBox
        let checkBoxColor = isLabelSheetWithCheckBox ? #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1) : #colorLiteral(red: 0.1803921569, green: 0.5921568627, blue: 0.937254902, alpha: 1)
        self.openSheetLbl.textColor = checkBoxColor
        switchCtlContainerView.isHidden = isLabelSheetWithCheckBox
        
        titleLbl.textColor = typographyTitle
        toolTipIcon.tintColor = typographyTitle
        subLbl.textColor = typographySubtitle
        switchCtl.onTintColor = primaryMain

    }
    func configureUIForLabelSheet(){
        checkBoxBtnContainerView.isHidden = isLabelSheet
        let checkBoxColor = #colorLiteral(red: 0.1803921569, green: 0.5921568627, blue: 0.937254902, alpha: 1)
        self.openSheetLbl.textColor = checkBoxColor
        switchCtlContainerView.isHidden = isLabelSheet
        
        titleLbl.textColor = typographyTitle
        subLbl.textColor = typographySubtitle
        toolTipIcon.tintColor = primaryMain
        switchCtl.onTintColor = primaryMain

    }
    
    
    
    // MARK: - Functions
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    func addLabelAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGoToURL))
        openSheetLbl.addGestureRecognizer(tapGesture)
    }
    
    func isRequiredField(required: Bool, value:String){
        let st = value
        let last = " *"
        
        let firstAttributes: [NSAttributedString.Key: Any] = [:]
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.SST_Arabic_Bold(ofSize: 15)]
        
        let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
        let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
        
        firstString.append(lastString)
        if required {
            self.titleLbl.attributedText = firstString
        }else {
            self.titleLbl.text = st
        }
    }
    
    
    // MARK: - IBActions
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @objc func didTapGoToURL() {
        if let action = didTapOpenBottomSheet {
            action()
        }
    }
    
    @IBAction func toolTipButton(_ sender: UIButton) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        var isChecked = (checkBoxBtn.imageView?.image == UIImage(named: "CheckboxFilled"))
        if let currentImage = checkBoxBtn.imageView?.image {
            if currentImage == UIImage(named: "CheckboxFilled") {
                checkBoxBtn.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
                isChecked = false
            } else if currentImage == UIImage(named: "CheckboxEmpty") {
                checkBoxBtn.setImage(UIImage(named: "CheckboxFilled"), for: .normal)
                isChecked = true
            }
        }
        let checkBoxColor = isChecked ? #colorLiteral(red: 0.1803921569, green: 0.5921568627, blue: 0.937254902, alpha: 1) : #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.openSheetLbl.textColor = checkBoxColor
        handleToggleValidation(isSwitchOn: isChecked)
        if let action = validationChanged {
            action(isChecked)
        }
    }
    @IBAction func switchTapped() {
            handleToggleValidation(isSwitchOn: switchCtl.isOn)
            if let action = validationChanged {
                action(switchCtl.isOn)
            }
        
    }
}

extension LabelSheetWithSwitchTVCell: ValidatableCell {
    private func updateErrorState(inlineError: Bool, message: String) {
        self.inlineError = inlineError
        errLbl.text = message
        errorContainer.isHidden = !inlineError
        
        item.inLineError = inlineError
        item.errorMessageInline = message
        
        if let action = reloadTableView {
            action()
        }
        
        validationChanged?(!inlineError)
    }

    func displayValidationError(_ message: String) {
//        updateConstraintsForSectionItem(section: item.isSectionControl)
        updateErrorState(inlineError: true, message: message)
    }

    func clearValidationError() {
        updateErrorState(inlineError: false, message: "")
    }
}

