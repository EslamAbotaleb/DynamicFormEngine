//
//  ButtonExtensions.swift
//  CERQEL
//
//  Created by ahmed maher on 17/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func setActiveButton(fontsize: CGFloat = 16, background: UIColor? = primaryMain, titleColor: UIColor = .white) {
        isUserInteractionEnabled = true
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = UIFont.buttonLSemibold()
        sizeToFit()
        if background != nil {
            backgroundColor = background
        }
    }
    
    func setUnActiveButton(fontsize: CGFloat = 16, background: UIColor? = .lightGray, titleColor: UIColor = .white){
        isUserInteractionEnabled = false
        setTitleColor(titleColor, for: .disabled)
        setTitleColor(titleColor, for: .normal)
        if background != nil {
            backgroundColor = background
        }
    }

    func underline() {
        
        if let textUnwrapped = self.titleLabel?.text {
            let underlineAttribute: [NSAttributedString.Key: Any] = [
                .font:  UIFont.bodyLRegular(ofSize: 16),
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            let attributeString = NSMutableAttributedString(
                string: textUnwrapped,
                attributes: underlineAttribute
            )
            self.setAttributedTitle(attributeString, for: .normal)
        }
    }
    
    func setCancelButtonTheme() {
        self.layer.borderColor = primaryMain.cgColor
        self.titleLabel?.font = UIFont.buttonLSemibold()
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        self.setTitleColor(primaryMain, for: .normal)
    }
    
    func setSubmitButtonTheme() {
        self.titleLabel?.font = UIFont.buttonLSemibold()
        self.backgroundColor = primaryMain
        self.setTitleColor(.white, for: .normal)

    }
}
