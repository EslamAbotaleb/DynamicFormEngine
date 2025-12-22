//
//  UIViw+Extention.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 15/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeRounded(color : UIColor?, borderWidth : CGFloat?) {
        layer.borderWidth = borderWidth ?? 1
        layer.masksToBounds = false
        layer.borderColor = color == nil ? UIColor.black.cgColor : color?.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

