//
//  UIFont+extensions.swift
//  CERQEL
//
//  Created by mac on 7/26/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func SST_Arabic_Bold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "SST Arabic Bold", size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
    }
    
    static func SST_Arabic_Light(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "SST Arabic Light", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
    
    static func SST_Arabic_Medium(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "SST Arabic Medium", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
    
    static func SST_Arabic_Roman(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "SST Arabic Roman", size: ofSize) ?? UIFont.italicSystemFont(ofSize: ofSize)
    }
    
    static func heading1(ofSize: CGFloat = 33.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func heading2(ofSize: CGFloat = 30.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static func heading3(ofSize: CGFloat = 24.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static func heading4(ofSize: CGFloat = 18.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static func heading5(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static func LT_Bukra_Regular(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "29LTBukra-Rg", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }
    
    static func LT_Bukra_Medium(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "29LTBukra-Md", size: ofSize) ?? UIFont.systemFont(ofSize: ofSize)
    }

}
