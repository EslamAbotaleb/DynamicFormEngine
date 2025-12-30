//
//  CerqelCheckBoxSortCell.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit

class CerqelCheckBoxSortCell: UITableViewCell {
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var checkSortNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config (item:String) {
        checkSortNameLbl.text = item
    }
    
}
