//
//  ParagraphTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 22/11/2021.
//

import UIKit


class ParagraphTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var paragraphLabel: UILabel!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelParagraphItem {
                do {
                    let attrStr = try NSAttributedString(
                        data: item.label.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                        options: [.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil)
                    paragraphLabel.attributedText = attrStr
                } catch let error {
                    paragraphLabel.text = item.label
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
//        contentView.backgroundColor = .normalBorderColor
//        outerView.backgroundColor = .fieldsBackground
//
//        paragraphLabel.font = UIFont(name: Constants.mediumFont(), size: 16)!
//        paragraphLabel.textColor = .checkText
    }
}
