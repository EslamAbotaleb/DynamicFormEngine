//
//  NewLblTVcell.swift
//
//
//  Created by Mohamed Karmout on 24/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewLblTVcell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueTFContainerView: UIView!
    @IBOutlet weak var valueTF: UITextView!
    @IBOutlet weak var toolTipIcon: UIButton!

    
    // MARK: - Variables
    
    var valueChanged: ((ParagraphAnswer) -> ())?
    var isSectionItem = false
    var toolTipTxt = ""
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?

    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelParagraphItem {
                valueTF.text = ""
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                guard let localization = item.localization as? ParagraphLocalization else { return }
                let lbl = isArabicCerqel() ?  localization["ar"]?.label :  localization["en"]?.label
                fieldLabel.text = lbl
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
                let ans = item.answer as? ParagraphAnswer
                handleAnswer(ans: ans)
                if let dataSourceId = item.field?.properties?.dataSourcId, valueTF.text.isEmpty {
                    dataSourceFetching?(dataSourceId,item)
                }
            }
        }
    }
    
    
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueTFContainerView.layer.borderWidth = 1
        valueTFContainerView.layer.borderColor = UIColor.init(hexString: "#969696").cgColor
        handleDisabledText(disabled: true)
        handleGesture()
        configureUI()
    }
    
    private func configureUI() {
        fieldLabel.textColor = typographyTitle
        toolTipIcon.tintColor = primaryMain
    }
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        fieldLabel.isUserInteractionEnabled = true
        fieldLabel.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        valueTF.centerVertically()
    }
    
    func handleAnswer(ans: ParagraphAnswer?) {
        var textFieldValue = ""
        
        if ans?.value != "" && ans?.value != nil {
            textFieldValue = ans?.value ?? ""
        }else {
            if let paragraphProperties = item.field?.properties as? ParagraphProperties {
                if let paragraphText = paragraphProperties.paragraphText, paragraphText != "" {
                    textFieldValue = paragraphText
                } else if let defAnswerValue = paragraphProperties.defaultAnswer?.value, defAnswerValue != "" {
                    textFieldValue = defAnswerValue
                }
            }
        }
        
        if textFieldValue != valueTF.text {
            valueTF.text = textFieldValue
            submitValue(text: ParagraphAnswer(val: textFieldValue))
        }
    }
    
    func handleDisabledText(disabled:Bool){
        valueTFContainerView.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        valueTF.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        valueTF.isUserInteractionEnabled = disabled ? false : true
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
    
    func submitValue(text: ParagraphAnswer) {
        valueChanged?(text)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
}

