//
//  TextFieldExtension.swift
//  CERQEL
//
//  Created by ahmed maher on 05/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

import UIKit

class PaddingTextField: UITextField {

@IBInspectable var paddingLeft: CGFloat = 0
@IBInspectable var paddingRight: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRectMake(bounds.origin.x + paddingLeft, bounds.origin.y,
        bounds.size.width - paddingLeft - paddingRight, bounds.size.height);
}

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
}}
