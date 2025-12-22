//
//  CheckBoxSortCell.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit

class CheckBoxCell: UITableViewCell {
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var checkSortNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        self.checkIcon.image = isSelected ? UIImage(named: "Checkbox Checked") : UIImage(named: "Checkbox Unchecked")
    }
    
   
    func configure(item: ListModel) {
        checkSortNameLbl.text = item.name
        self.checkIcon.image = item.isSelected ?? false ? UIImage(named: "Checkbox Checked") : UIImage(named: "Checkbox Unchecked")
        checkSortNameLbl.textColor = typographyTitle
        checkSortNameLbl.font = UIFont.bodyLRegular()
    }
}
