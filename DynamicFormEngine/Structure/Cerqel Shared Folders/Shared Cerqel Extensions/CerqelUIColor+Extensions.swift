//
//  UIColor+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/20/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
          let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
          var rgb: UInt64 = 0
          Scanner(string: hex).scanHexInt64(&rgb)
          
          let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
          let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
          let blue = CGFloat(rgb & 0xFF) / 255.0
          
          self.init(red: red, green: green, blue: blue, alpha: 1.0)
      }
    
    public convenience init?(hexCerqel: String) {
        let r, g, b, a: CGFloat
        
        if hexCerqel.hasPrefix("#") {
            let start = hexCerqel.index(hexCerqel.startIndex, offsetBy: 1)
            let hexColor = String(hexCerqel[start...])
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if hexColor.count == 8 {
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
            
        }
        
        return nil
    }
    
    convenience init(hexStringCerqel:String, alphaCerqel: CGFloat = 1) {
        let hexString:String = hexStringCerqel.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner            = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alphaCerqel)
    }
    
    convenience init(rCerqel: Int, gCerqel: Int, bCerqel: Int) {
        self.init(rCerqel: rCerqel, gCerqel: gCerqel, bCerqel: bCerqel, aCerqel: 1.0)
    }
    
    convenience init(rCerqel: Int, gCerqel: Int, bCerqel: Int, aCerqel: CGFloat) {
        self.init(red: CGFloat(rCerqel) / 255.0, green: CGFloat(gCerqel) / 255.0, blue: CGFloat(bCerqel) / 255.0, alpha: aCerqel)
    }
    
    func toHexStringCerqel() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
}

extension UIColor {
    
    @nonobjc class var whiteCerqel: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

    @nonobjc class var errorbgCerqel: UIColor {
        return UIColor(rCerqel: 255, gCerqel: 240, bCerqel: 246, aCerqel: 1)
    }
    
    @nonobjc class var warningCerqel: UIColor {
        return UIColor(rCerqel: 255, gCerqel: 160, bCerqel: 114, aCerqel: 1)
    }
    @nonobjc class var warningbgCerqel: UIColor {
        return UIColor(rCerqel: 255, gCerqel: 240, bCerqel: 246, aCerqel: 1)
    }
  
    @nonobjc class var grayLightColor: UIColor {
        return UIColor(rCerqel: 245, gCerqel: 245, bCerqel: 245, aCerqel: 1)
    }
    
    @nonobjc class var SelectCardBGColor: UIColor {
        return UIColor(rCerqel: 245, gCerqel: 250, bCerqel: 255, aCerqel: 1)
    }
    
    @nonobjc class var alertErrorColor: UIColor {
        return UIColor(rCerqel: 236, gCerqel: 74, bCerqel: 74, aCerqel: 1)
    }
    
    @nonobjc class var emptyStateColor: UIColor {
        return UIColor(rCerqel: 241, gCerqel: 243, bCerqel: 249, aCerqel: 1)
    }
}
