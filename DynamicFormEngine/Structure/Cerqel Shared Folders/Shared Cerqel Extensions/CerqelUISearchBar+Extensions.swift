//
//  UISearchBar+Extensions.swift
//  CERQEL
//
//  Created by Marwan on 23/01/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    public func cerqel_searchActive() -> Bool {
        if self.isTranslucent && self.text != "" {
            return true
        }
        return false
    }
    
    public func cerqel_setPlaceholderTextColorTo(color: UIColor) {
          let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
          textFieldInsideSearchBar?.textColor = color
          let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
          textFieldInsideSearchBarLabel?.textColor = color
      }
    
    public func cerqel_setClearButtonColorTo(color: UIColor) {
          // Clear Button
          let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
          let crossIconView = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
          crossIconView?.setImage(crossIconView?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
          crossIconView?.tintColor = color
      }

    public func cerqel_setMagnifyingGlassColorTo(color: UIColor) {
          let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
          let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
          glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
          glassIconView?.tintColor = color
      }
    
    public func cerqel_changeSearchBarColor(color: UIColor, size: CGSize) {
          UIGraphicsBeginImageContext(self.frame.size)
          color.setFill()
          UIBezierPath(rect: self.frame).fill()
          let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()
          self.setSearchFieldBackgroundImage(bgImage, for: .normal)
      }
}
