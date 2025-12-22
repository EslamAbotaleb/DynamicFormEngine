//
//  UIButton+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 11/9/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class LocalizedButton: UIButton{
    
    override func awakeFromNib() {
        self.setTitle(self.currentTitle?.localized, for: .normal)
    }
    
}


extension UIButton{
    
    func cerqel_setGradientColor(isVertical: Bool, colors: [UIColor]){
        let gradientLayer = CAGradientLayer(isVertical: isVertical, frame: self.frame, colors: colors)
        self.setBackgroundImage(gradientLayer.cerqel_createGradientImage(), for: .normal)
        
    }
    

    
}
