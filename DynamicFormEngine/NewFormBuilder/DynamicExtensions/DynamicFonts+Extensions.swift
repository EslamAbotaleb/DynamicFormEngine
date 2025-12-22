//
//  DynamicFonts+Extensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 18/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

extension UIFont{
    
    static func Poppins_regular(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize) ?? UIFont.boldSystemFont(ofSize: ofSize)
    }
    
    static func Poppins_bold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: ofSize)!
    }
    
    
    static func Poppins_semiBold(ofSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    
    static func button(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static func subtitle1(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static func textStyle16Regular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    
    static func subtitle2(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static func textStyleBody(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static func textStyle12Regular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func caption(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    

}

