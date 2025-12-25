//
//  RadioBtnBaseSortCell.swift
//  CERQEL
//
//  Created by Maher on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit

public class RadioCell: UITableViewCell {
    @IBOutlet weak var sortNameLbl: UILabel!
    @IBOutlet weak var sortIcon: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    public  func configure(indexPath: IndexPath, totalRows: Int, item: ListModel) {
        if indexPath.row == totalRows - 1 {
            bottomView.isHidden = true
        } else {
            bottomView.isHidden = false
        }
        sortNameLbl.text = item.name ?? (isArabicCerqel() ? item.nameAr : item.nameEn)
        sortIcon.image = item.isSelected ?? false ?  UIImage(named: "Radio Status") : UIImage(named: "Radio Status unselected")
        sortNameLbl.textColor = typographyTitle
        sortNameLbl.font = UIFont.bodyLRegular()
    }
    
}

