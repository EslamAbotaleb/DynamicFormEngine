//
//  NewOptionTVCell.swift
//
//
//  Created by mac on 1/29/23.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewOptionTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    var representation: CheckBoxRepresentation!
    
    var checked: Bool! {
        didSet {
            if representation == .CheckBox {
                if checked {
                    selectionImageView.image = UIImage(named: "Rectangle 5977")
                } else {
                    selectionImageView.image = UIImage(named: "Rectangle 5961")
                }
            } else {
                if checked {
                    selectionImageView.image = UIImage(named: "Ellipse 304")
                } else {
                    selectionImageView.image = UIImage(named: "Ellipse 10")
                }
            }
        }
    }
    
    var value: String! {
        didSet {
            titleLabel.text = value
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        checked = false
//        if representation == .CheckBox {
//            selectionImageView.image = UIImage(named: "Rectangle 5961")
//        } else {
//            selectionImageView.image = UIImage(named: "Ellipse 10")
//        }
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
