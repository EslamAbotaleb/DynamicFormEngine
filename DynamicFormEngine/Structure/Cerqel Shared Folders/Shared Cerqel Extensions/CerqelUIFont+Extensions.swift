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
    
    static func subtitleLRegular(ofSize: CGFloat = 20.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func subtitleMMedium(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static func bodyLSemibold(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static func bodyLMedium(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static func bodyLRegular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func bodyMSemibold(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static func bodyMMedium(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static func bodyMRegular(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func bodySSemibold(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static func bodySMedium(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static func bodySRegular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static func caption1Semibold(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static func caption2Medium(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }

    static func caption3Regular(ofSize: CGFloat = 10.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func numberLRegular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func numberMRegular(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static func numberSRegular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }
    
    static func buttonLSemibold(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }
    
    static func buttonMSemibold(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: ofSize)!
    }

    static func buttonLMedium(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
        
    static func buttonMMedium(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: ofSize)!
    }
    
    static func inputRegular(ofSize: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static func labelRegular(ofSize: CGFloat = 14.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static func helperRegular(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: ofSize)!
    }

    static func popinsItalic(ofSize: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Poppins-MediumItalic", size: ofSize)!
    }

}

extension Font {
    static func subtitleLRegular(ofSize: CGFloat = 20.0) -> Font {
        return Font (UIFont.subtitleLRegular(ofSize: ofSize))
    }

    static func subtitleMMedium(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.subtitleMMedium(ofSize: ofSize))
    }

    static func bodyLSemibold(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.bodyLSemibold(ofSize: ofSize))
    }

    static func bodyLMedium(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.bodyLMedium(ofSize: ofSize))
    }

    static func bodyLRegular(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.bodyLRegular(ofSize: ofSize))
    }

    static func bodyMSemibold(ofSize: CGFloat = 14.0) -> Font {
        return Font (UIFont.bodyMSemibold(ofSize: ofSize))
    }

    static func bodyMMedium(ofSize: CGFloat = 14.0) -> Font {
        return Font (UIFont.bodyMMedium(ofSize: ofSize))
    }

    static func bodyMRegular(ofSize: CGFloat = 14.0) -> Font {
        return Font (UIFont.bodyMRegular(ofSize: ofSize))
    }

    static func bodySSemibold(ofSize: CGFloat = 12.0) -> Font {
        return Font (UIFont.bodySSemibold(ofSize: ofSize))
    }

    static func bodySMedium(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.bodySMedium(ofSize: ofSize))
    }

    static func bodySRegular(ofSize: CGFloat = 12.0) -> Font {
        return Font (UIFont.bodySRegular(ofSize: ofSize))
    }

    static func caption1Semibold(ofSize: CGFloat = 10.0) -> Font {
        return Font (UIFont.caption1Semibold(ofSize: ofSize))
    }

    static func caption2Medium(ofSize: CGFloat = 10.0) -> Font {
        return Font (UIFont.caption2Medium(ofSize: ofSize))
    }

    static func caption3Regular(ofSize: CGFloat = 10.0) -> Font {
        return  Font (UIFont.caption3Regular(ofSize: ofSize))
    }

    static func numberLRegular(ofSize: CGFloat = 16.0) -> Font {
        return Font (UIFont.numberLRegular(ofSize: ofSize))
    }

    static func numberMRegular(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.numberMRegular(ofSize: ofSize))
    }

    static func numberSRegular(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.numberSRegular(ofSize: ofSize))
    }

    static func buttonLSemibold(ofSize: CGFloat = 16.0) -> Font {
        return  Font (UIFont.buttonLSemibold(ofSize: ofSize))
    }

    static func buttonMSemibold(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.buttonMSemibold(ofSize: ofSize))
    }

    static func buttonLMedium(ofSize: CGFloat = 16.0) -> Font {
        return  Font (UIFont.buttonLMedium(ofSize: ofSize))
    }

    static func buttonMMedium(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.buttonMMedium(ofSize: ofSize))
    }

    static func inputRegular(ofSize: CGFloat = 16.0) -> Font {
        return  Font (UIFont.inputRegular(ofSize: ofSize))
    }

    static func labelRegular(ofSize: CGFloat = 14.0) -> Font {
        return  Font (UIFont.labelRegular(ofSize: ofSize))
    }

    static func helperRegular(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.helperRegular(ofSize: ofSize))
    }

    static func popinsItalic(ofSize: CGFloat = 12.0) -> Font {
        return  Font (UIFont.popinsItalic(ofSize: ofSize))
    }

}
