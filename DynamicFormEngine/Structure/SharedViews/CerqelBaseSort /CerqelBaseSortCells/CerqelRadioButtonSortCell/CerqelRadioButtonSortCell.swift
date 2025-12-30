//
//  RadioBtnBaseSortCell.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
import DynamicFormEngine

class CerqelRadioButtonSortCell: UITableViewCell {
    @IBOutlet weak var sortNameLbl: UILabel!
    @IBOutlet weak var sortIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CerqelRadioButtonSortCell {
    private func configureUI() {
        sortNameLbl.textColor = typographyTitle
        sortNameLbl.font = UIFont.bodyLRegular()
    }
}
