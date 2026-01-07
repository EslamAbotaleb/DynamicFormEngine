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
    @IBOutlet weak var checkBoxBtnContainerView: UIStackView!
    @IBOutlet weak var checkBoxBtn: UIButton!{
        didSet{
            checkBoxBtn.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
        }
    }

    
    // MARK: - Variables
    
    var validationChanged: ((Bool) -> ())?
    var dataSourceId = ""
    var didTapOpenBottomSheet: (() -> ())?
    var isRequired = false
    var isLabelSheetWithCheckBox = false
    var isLabelSheet = false
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelParagraphItem {
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
                    if let url = properties.dataSourcId {
                        dataSourceId = url
                    }
                    
                    let urlValue = isArabicCerqel() ?  ((localization["ar"]?.paragraphText == "" || localization["ar"]?.paragraphText == nil)  ? properties.paragraphText : localization["ar"]?.paragraphText ) :  ((localization["en"]?.paragraphText == ""  || localization["en"]?.paragraphText == nil) ?  properties.paragraphText : localization["en"]?.paragraphText )
                    subLbl.text = isArabicCerqel() ?  localization["ar"]?.sublabel :  localization["en"]?.sublabel
                    subLbl.isHidden =  subLbl.text == ""
                    if let stringValue = (item.answer as? ParagraphAnswer)?.value,
                       let booleanValue = Bool(stringValue) {
                        switchCtl.isOn = booleanValue
                    }
                    self.openSheetLbl.text = urlValue
                    self.openSheetLbl.isUserInteractionEnabled = properties.dataSourcId != nil ? true : false
                }
            }
        }
    }
    
    func handleToggleValidation(isSwitchOn: Bool) {
        guard let item = item as? FormViewModelParagraphItem else { return }
        if  !self.isRequired {
            validationChanged?(true)
            errLbl.isHidden = true
            errIcon.isHidden = true
        } else {
            let validation = FormBuilder.shared.handleSwitchValidation(value: isSwitchOn, item: item, required: self.isRequired, row: item.fieldId)

            if validation.isError, validation.errorType == .required {
                errLbl.text = validation.errorMessage
                errLbl.isHidden = false
                errIcon.isHidden = false
            } else {
                errLbl.text = ""
                errLbl.isHidden = true
                errIcon.isHidden = true
            }
            return
        }
    }
    
    
    
    
    // MARK: - LifeCycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLabelAction()
    }
    
    func emptyValues() {
        switchCtl.isOn = false
        errLbl.isHidden = true
        errIcon.isHidden = true
    }
    
    func configureUI(){
        checkBoxBtnContainerView.isHidden = !isLabelSheetWithCheckBox
        let checkBoxColor = isLabelSheetWithCheckBox ? #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1) : #colorLiteral(red: 0.1803921569, green: 0.5921568627, blue: 0.937254902, alpha: 1)
        self.openSheetLbl.textColor = checkBoxColor
        switchCtlContainerView.isHidden = isLabelSheetWithCheckBox
    }
    func configureUIForLabelSheet(){
        checkBoxBtnContainerView.isHidden = isLabelSheet
        let checkBoxColor = #colorLiteral(red: 0.1803921569, green: 0.5921568627, blue: 0.937254902, alpha: 1)
        self.openSheetLbl.textColor = checkBoxColor
        switchCtlContainerView.isHidden = isLabelSheet
    }
    
    
    
    // MARK: - Functions
    
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
    
    @objc func didTapGoToURL() {
        if let action = didTapOpenBottomSheet {
            action()
        }
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
