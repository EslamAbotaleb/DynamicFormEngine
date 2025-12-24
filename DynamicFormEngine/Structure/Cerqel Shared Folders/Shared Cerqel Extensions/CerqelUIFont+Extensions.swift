//
//  UIFont+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/22/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
import SwiftUI

extension UIFont{
    
    static public func subtitleLRegular(ofSize: CGFloat = 20.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static public func subtitleMMedium(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static public func bodyLSemibold(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static public func bodyLMedium(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static public func bodyLRegular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static public func bodyMSemibold(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static public func bodyMMedium(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static public func bodyMRegular(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static public func bodySSemibold(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static public func bodySMedium(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static public func bodySRegular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static public func caption1Semibold(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static public func caption2Medium(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static public func caption3Regular(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static public func numberLRegular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static public func numberMRegular(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static public func numberSRegular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static public func buttonLSemibold(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static public func buttonMSemibold(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static public func buttonLMedium(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
        
    static public func buttonMMedium(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static public func inputRegular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static public func labelRegular(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static public func helperRegular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static public func popinsItalic(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-MediumItalic", size: ofSize)!
    }

}

extension Font {
    static public func subtitleLRegular(ofSize: CGFloat = 20.0) -> Font {
        return Font (UIFont.subtitleLRegular(ofSize: ofSize))
    }

    static public func subtitleMMedium(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.subtitleMMedium(ofSize: ofSize))
    }

    static public func bodyLSemibold(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.bodyLSemibold(ofSize: ofSize))
    }

    static public func bodyLMedium(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.bodyLMedium(ofSize: ofSize))
    }

    static public func bodyLRegular(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.bodyLRegular(ofSize: ofSize))
    }

    static public func bodyMSemibold(ofSize: CGFloat = 14.0) -> Font {
        return Font (UIFont.bodyMSemibold(ofSize: ofSize))
    }

    static public func bodyMMedium(ofSize: CGFloat = 14.0) -> Font {
        return Font (UIFont.bodyMMedium(ofSize: ofSize))
    }

    static public func bodyMRegular(ofSize: CGFloat = 14.0) -> Font {
        return Font (UIFont.bodyMRegular(ofSize: ofSize))
    }

    static public func bodySSemibold(ofSize: CGFloat = 12.0) -> Font {
        return Font (UIFont.bodySSemibold(ofSize: ofSize))
    }

    static public func bodySMedium(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.bodySMedium(ofSize: ofSize))
    }

    static public func bodySRegular(ofSize: CGFloat = 12.0) -> Font {
        return Font (UIFont.bodySRegular(ofSize: ofSize))
    }

    static public func caption1Semibold(ofSize: CGFloat = 10.0) -> Font {
        return Font (UIFont.caption1Semibold(ofSize: ofSize))
    }

    static public func caption2Medium(ofSize: CGFloat = 10.0) -> Font {
        return Font (UIFont.caption2Medium(ofSize: ofSize))
    }

    static public func caption3Regular(ofSize: CGFloat = 10.0) -> Font {
        return  Font (UIFont.caption3Regular(ofSize: ofSize))
    }

    static public func numberLRegular(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.numberLRegular(ofSize: ofSize))
    }

    static public func numberMRegular(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.numberMRegular(ofSize: ofSize))
    }

    static public func numberSRegular(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.numberSRegular(ofSize: ofSize))
    }

    static public func buttonLSemibold(ofSize: CGFloat = 16.0) -> Font {
        return  Font (UIFont.buttonLSemibold(ofSize: ofSize))
    }

    static public func buttonMSemibold(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.buttonMSemibold(ofSize: ofSize))
    }

    static public func buttonLMedium(ofSize: CGFloat = 16.0) -> Font {
        return  Font (UIFont.buttonLMedium(ofSize: ofSize))
    }

    static public func buttonMMedium(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.buttonMMedium(ofSize: ofSize))
    }

    static public func inputRegular(ofSize: CGFloat = 16.0) -> Font {
        return  Font (UIFont.inputRegular(ofSize: ofSize))
    }

    static public func labelRegular(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.labelRegular(ofSize: ofSize))
    }

    static public func helperRegular(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.helperRegular(ofSize: ofSize))
    }

    static public func popinsItalic(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.popinsItalic(ofSize: ofSize))
    }

}
