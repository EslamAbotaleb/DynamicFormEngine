//
//  ActionBaseListTableViewCell.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 23/04/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

class ActionBaseListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func configure(indexPath: IndexPath, totalRows: Int, item: ListModel) {
        if indexPath.row == totalRows - 1 {
            bottomView.isHidden = true
        } else {
            bottomView.isHidden = false
        }
        titleLbl.text = item.name ?? (isArabicCerqel() ? item.nameAr : item.nameEn)
        icon.image = UIImage(named: item.icon ?? "")
        icon.isHidden = item.icon == "" 
        titleLbl.textColor = typographyTitle
        titleLbl.font = UIFont.bodyLRegular()
        
        if item.isEditable == false {
            self.isUserInteractionEnabled = false
            titleLbl.textColor = UIColor.lightGray
        }
        if item.isWithdrawal == false {
            self.isUserInteractionEnabled = false
            titleLbl.textColor = UIColor.lightGray
        }
    }
    
    func configureAction(item: Action) {
        titleLbl.text = item.name
        titleLbl.textColor = typographyTitle
        titleLbl.font = UIFont.bodyLRegular()
    }

}
