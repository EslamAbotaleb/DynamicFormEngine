//
//  EmptyTVcell.swift
//  iJusoor
//
//  Created by iSlam on 8/7/19.
//  Copyright © 2019 Youxel. All rights reserved.
//

import UIKit

class EmptyTVcell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(customColor: Bool = false) {
        customColor ? (contentView.backgroundColor = UIColor.primaryLight) : (contentView.backgroundColor = .clear)
    }
    
}
