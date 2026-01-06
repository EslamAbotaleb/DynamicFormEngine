//
//  UIViewController.swift
//  CERQEL
//
//  Created by Youxel on 02/06/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
   public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}
