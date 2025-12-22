//
//  NewLinkControlTVcell.swift
//
//
//  Created by Hassan elshair on 24/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewLinkControlTVcell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var urlLbl: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subLbl: UILabel!
    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.layer.borderWidth = 1
            bgView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        }
    }
    @IBOutlet weak var toolTipIcon: UIButton!
    @IBOutlet weak var goToLinkButton: UIButton!
    
    
    // MARK: - Variables
    
    var validationChanged: ((Bool) -> ())?
    var isSectionItem = false
    var toolTipTxt = ""
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelParagraphItem {
                do {
                    item.isSectionControl = isSectionItem
                    contentView.backgroundColor = isSectionItem ? .white : .clear
                    updateConstraintsForSectionItem(section: item.isSectionControl )
                    guard let localization = item.localization as? ParagraphLocalization else { return }
                    let urlValue = isArabicCerqel() ?  localization["ar"]?.paragraphText :  localization["en"]?.paragraphText
                    
                    isRequiredField(value:  (isArabicCerqel() ?  localization["ar"]?.label ?? "" :  localization["en"]?.label) ?? "")
                    subLbl.text = isArabicCerqel() ?  localization["ar"]?.sublabel :  localization["en"]?.sublabel
                    urlLbl.dataDetectorTypes = .link
                    let attributedString = NSMutableAttributedString(string: urlValue ?? "")
                    self.urlLbl.attributedText = attributedString
                    if  let url = URL(string: urlValue ?? ""){
                        attributedString.setAttributes([.link: url], range: NSMakeRange(0,((urlValue?.count ?? 0))))
                        self.urlLbl.attributedText = attributedString
                    }
                    self.urlLbl.isUserInteractionEnabled = true
                    self.urlLbl.isEditable = false
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

                } catch let error {
                    urlLbl.text = item.label
                }
            }
        }
    }

    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        handleGesture()
        configureUI()
    }
    
    
    // MARK: - Functions
    
    private func configureUI() {
        titleLbl.textColor = typographyTitle
        subLbl.textColor = typographySubtitle
        toolTipIcon.tintColor = typographySubtitle
        goToLinkButton.tintColor = primaryMain
    }
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    func isRequiredField(value:String){
                let st = value
                let last = ""//" *"
                
                let firstAttributes: [NSAttributedString.Key: Any] = [:]
                let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.SST_Arabic_Bold(ofSize: 15)]
                
                let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
                let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
                
                firstString.append(lastString)
                
                self.titleLbl.attributedText = firstString
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


    // MARK: - IBActions
    
    
    @IBAction func didTapGoToURL(){
        guard let localization = self.item.localization as? ParagraphLocalization else { return }
        let urlValue = (isArabicCerqel() ?  localization["ar"]?.paragraphText :  localization["en"]?.paragraphText) ?? ""
            openAttachment(withURLString: urlValue)
        validationChanged?(true)
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
}
