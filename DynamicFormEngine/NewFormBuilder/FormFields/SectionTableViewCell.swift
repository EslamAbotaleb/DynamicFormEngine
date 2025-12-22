//
//  SectionTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 28/10/2021.
//

import UIKit


class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelSectionItem {
                sectionLabel.text = item.label
            }
        }
    }
    
    var opened: Bool! {
        didSet {
            if opened {
//                contentView.backgroundColor = .primaryColor
                arrowImageView.image = UIImage(named: "sectionArrowUp")
                sectionLabel.textColor = .white
            } else {
//                contentView.backgroundColor = .primaryDisabledColor
                arrowImageView.image = UIImage(named: "sectionArrowDown")
//                sectionLabel.textColor = .primaryColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
