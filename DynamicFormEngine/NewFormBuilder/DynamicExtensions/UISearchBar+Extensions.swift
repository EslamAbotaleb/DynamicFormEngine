//
//  UISearchBar+Extensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 17/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//


import Foundation
import UIKit

extension UISearchBar {
    func searchActive() -> Bool {
        if self.isTranslucent && self.text != "" {
            return true
        }
        return false
    }
}
