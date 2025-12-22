//
//  DropDownItemTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 25/05/2022.
//

import UIKit

class DropDownItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    var representation: CheckBoxRepresentation!
    
    var checked: Bool! {
        didSet {
            if representation == .CheckBox {
                if checked {
                    selectionImageView.image = UIImage(named: "mcqCheckBoxSelected")
                } else {
                    selectionImageView.image = UIImage(named: "mcqCheckBox")
                }
            } else {
                if checked {
                    selectionImageView.image = UIImage(named: "mcqRadioSelected")
                } else {
                    selectionImageView.image = UIImage(named: "mcqRadio")
                }
            }
        }
    }
    
    var value: String! {
        didSet {
            titleLabel.text = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
