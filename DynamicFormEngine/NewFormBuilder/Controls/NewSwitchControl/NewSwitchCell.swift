//
//  NewSwitchCell.swift
//
//
//  Created by Mohamed Karmout on 12/02/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewSwitchCell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLabl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var valueSwitch: UISwitch!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var errorConstant: NSLayoutConstraint!
    @IBOutlet weak var toolTipIcon: UIButton!

    
    // MARK: - Variables
    var isSectionItem = false
    var item: FormViewModelItem! {
        didSet {
            if let switchItem = item as? FormViewModelSwitchItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupItem(switchItem)
                updateErrorState(inlineError: item.inLineError, message: item.errorMessageInline)
            }
        }
    }
    var validationChanged: ((Bool) -> ())?
    var valueChanged: ((SwitchAnswer?, _ isError: Bool) -> ())?
    var toolTipTxt = ""
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        errorView.isHidden = true
        errorConstant.constant = .zero
        handleGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleDisabledData(isDisable:Bool){
        valueSwitch.isUserInteractionEnabled = !isDisable
    }
    
    func handleDisableControl(item: FormViewModelSwitchItem?,isRequest: Bool) {
        if isRequest {
            valueSwitch.isUserInteractionEnabled = !isRequest
        }else {
            handleDisabledData(isDisable: (item?.disabled ?? false || item?.field?.properties?.readonly ?? false))
        }
    }

    
    // MARK: - Functions
    
    private func configureUI() {
        titleLbl.textColor = typographyTitle
        descLabl.textColor = typographySubtitle
        toolTipIcon.tintColor = typographyTitle
        valueSwitch.onTintColor = primaryMain
    }
    
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
    
    func setupItem(_ item: FormViewModelSwitchItem) {
        if !item.required {
            validationChanged?(true)
        }else if item.required && !self.valueSwitch.isOn {
            validationChanged?(false)
        }
        valueSwitch.isUserInteractionEnabled = !item.disabled
        setupLabel(item: item)
        setupSubLabel(item: item)
        handleSwitchStatus(item)
        
        if let dataSourceId = item.field?.properties?.dataSourcId,!(valueSwitch.isOn ?? false) {
            dataSourceFetching?(dataSourceId,item)
        }
    }
    
    func setupLabel(item:FormViewModelSwitchItem) {
        if let localization = item.localization as? InteractiveLocalization {
            if !isArabicCerqel() {
                if let localizedLabel = localization["en"]?.label, !localizedLabel.isEmpty {
                    self.isRequiredField(item: item, value: localizedLabel)
                } else {
                    self.isRequiredField(item: item, value: item.label ?? "")
                }
            } else {
                if let localizedLabel = localization["ar"]?.label, !localizedLabel.isEmpty {
                    self.isRequiredField(item: item, value: localizedLabel)
                } else {
                    self.isRequiredField(item: item, value: item.label ?? "")
                }
            }
        } else {
            self.isRequiredField(item: item, value: item.label ?? "")
        }
        titleLbl.isHidden = (titleLbl.text ?? "").isEmpty ? true : false
        if let localization = item.localization as? InteractiveLocalization {
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

    }
    
    func setupSubLabel(item:FormViewModelSwitchItem) {
        if let localization = item.localization as? InteractiveLocalization {
            if !isArabicCerqel() {
                if let localizedLabel = localization["en"]?.sublabel, !localizedLabel.isEmpty {
                    descLabl.text = localizedLabel
                } else {
                    descLabl.text = item.sublabel
                }
            } else {
                if let localizedLabel = localization["ar"]?.sublabel, !localizedLabel.isEmpty {
                    descLabl.text = localizedLabel
                } else {
                    descLabl.text = item.sublabel
                }
            }
        } else {
            descLabl.text = item.sublabel
        }
        if descLabl.text?.isEmpty == true {
            descLabl.isHidden = true
        } else {
            descLabl.isHidden = false
        }
    }
    
    func isRequiredField(item:FormViewModelSwitchItem?,value:String) {
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
            } else{
                self.titleLbl.text = value
            }
        } else {
                self.titleLbl.text = value
            }
        }
            
    
    func handleSwitchStatus(_ item: FormViewModelSwitchItem) {
        if let defaultAnswet = (item.field?.properties as? switchProperties)?.defaultAnswer?.value {
            valueSwitch.isOn = defaultAnswet
        }
        if let isOn = (item.answer as? SwitchAnswer)?.value {
            valueSwitch.isOn = isOn
        }
        valueChanged?(SwitchAnswer(val: valueSwitch.isOn), checkError())
    }
    
    func checkError() -> Bool {
        if !(errorLbl.isHidden) {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        guard let item = item as? FormViewModelSwitchItem else {return}

        self.valueChanged?(SwitchAnswer(val: sender.isOn), checkError())
        if !item.required {
            validationChanged?(true)
        }else {
            sender.isOn ? validationChanged?(true) : validationChanged?(false)
        }
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
}

extension NewSwitchCell: ValidatableCell {
    func updateErrorState(inlineError: Bool, message: String = "") {
        if inlineError {
            displayValidationError(message)
        } else {
            clearValidationError()
        }
    }

    func displayValidationError(_ message: String) {
//        updateConstraintsForSectionItem(section: item.isSectionControl)
        errorLbl.text = message
        errorView.isHidden = false
        errorLbl.isHidden = false
    }

    func clearValidationError() {
        errorView.isHidden = true
        errorLbl.isHidden = true
        errorLbl.text = ""
    }
}

