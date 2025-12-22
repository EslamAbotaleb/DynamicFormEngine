//
//  NSAttributedString+Extensions.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 29/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
extension NSAttributedString {
    // Extension to detect links and apply blue color, underline, and make them clickable
    func makeLinksClickable() -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        
        // Improved Regular Expression pattern to match URLs
        let regexPattern = "(https?|ftp)://[a-zA-Z0-9-\\.]+(?:\\.[a-zA-Z]{2,})+(?:/[^\\s]*)?"
        
        // Create a regular expression to match URLs
        let regex = try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.length)
        
        // Apply blue color, underline, and clickable link attribute to detected links
        regex.enumerateMatches(in: self.string, options: [], range: range) { (match, _, _) in
            guard let matchRange = match?.range else { return }
            
            // Add blue color and underline to the link
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: matchRange)
            mutableAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: matchRange)
            
            // Make the text clickable (add URL attribute)
            let urlString = (self.string as NSString).substring(with: matchRange)
            if let url = URL(string: urlString) {
                mutableAttributedString.addAttribute(.link, value: url, range: matchRange)
            }
        }
        
        return mutableAttributedString
    }
}
