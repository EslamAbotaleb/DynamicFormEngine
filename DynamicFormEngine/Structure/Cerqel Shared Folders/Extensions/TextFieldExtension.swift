//
//  TextFieldExtension.swift
//  CERQEL
//
//  Created by ahmed maher on 05/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

import UIKit

public class PaddingTextField: UITextField {

@IBInspectable public var paddingLeft: CGFloat = 0
@IBInspectable public var paddingRight: CGFloat = 0

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRectMake(bounds.origin.x + paddingLeft, bounds.origin.y,
        bounds.size.width - paddingLeft - paddingRight, bounds.size.height);
}

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
}}
