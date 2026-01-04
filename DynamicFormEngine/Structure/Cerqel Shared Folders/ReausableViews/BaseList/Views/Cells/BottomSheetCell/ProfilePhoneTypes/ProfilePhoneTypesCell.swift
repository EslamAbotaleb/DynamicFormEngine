//
//  ProfilePhoneTypesCell.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 03/08/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit

class ProfilePhoneTypesCell: UITableViewCell {

    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var checkSortNameLbl: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
   
    public func configure(item: ListModel) {
        checkSortNameLbl.text = item.name
        checkSortNameLbl.font = UIFont.bodyLRegular()
        
        if item.isSelected ?? false {
            checkIcon.isHidden = false
            checkSortNameLbl.textColor = typographyBody
        }else {
            checkIcon.isHidden = true
            checkSortNameLbl.textColor = typographyTitle
        }
        
    }
    
}
