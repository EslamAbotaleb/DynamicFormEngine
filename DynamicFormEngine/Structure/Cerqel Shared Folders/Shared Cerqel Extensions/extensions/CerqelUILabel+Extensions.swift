//
//  UILabel+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 11/9/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class LocalizedLabel: UILabel{
    
    override func awakeFromNib() {
        if let txt = self.text{
            self.text = txt.localized
        }
    }
}
