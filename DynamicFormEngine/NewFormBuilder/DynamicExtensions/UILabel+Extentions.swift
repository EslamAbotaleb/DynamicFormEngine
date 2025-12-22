//
//  UILabel+Extentions.swift
//  CERQEL
//
//  Created by Youxel on 29/07/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
extension UILabel {
    func setClickableText(from message: String, clickableColor: UIColor, target: Any?, action: Selector) {
        guard let range = message.range(of: "Click Here".localized) else {
            // If "Click Here" is not found in the message, set the whole message as mainText
            self.text = message
            return
        }
        
        let mainText = String(message[..<range.lowerBound]).localized
        let clickableText = String(message[range]).localized
        let additionalText = String(message[range.upperBound...]).localized
        
        let attributedString = NSMutableAttributedString(string: mainText + clickableText + additionalText)
        
        // Set the color for the clickable text
        attributedString.addAttribute(.foregroundColor, value: clickableColor, range: NSRange(location: mainText.count, length: clickableText.count))
        
        // Make the clickable text clickable
        let clickableRange = NSRange(location: mainText.count, length: clickableText.count)
        attributedString.addAttribute(.link, value: clickableText, range: clickableRange)
        
        self.attributedText = attributedString
        self.isUserInteractionEnabled = true
        
        // Add a tap gesture recognizer to handle the clickable text
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
}
