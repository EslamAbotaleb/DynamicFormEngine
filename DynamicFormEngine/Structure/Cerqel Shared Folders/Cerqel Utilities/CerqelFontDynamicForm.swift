//
//  CerqelFont.swift
//  CerqelApp_SwiftUI
//
//  Created by Muhammed Sabri on 06/11/2023.
//

import SwiftUI

public struct CerqelFonts {
    static public var subtitleLRegular = Font.cerqel(.regular, size: 20.0)
    static public var bodyLSemibold = Font.cerqel(.semibold, size: 16)
    static public var bodyLMedium = Font.cerqel(.medium, size: 16)
    static public var bodyLRegular = Font.cerqel(.regular, size: 16)
    static public var bodyMSemibold = Font.cerqel(.semibold, size: 14)
    static public var bodyMMedium = Font.cerqel(.medium, size: 14)
    static public var bodyMRegular = Font.cerqel(.regular, size: 14)
    static public var bodySSemibold = Font.cerqel(.semibold, size: 12)
    static public var bodySMedium = Font.cerqel(.medium, size: 12)
    static public var bodySRegular = Font.cerqel(.regular, size: 12)
    static public var caption1Semibold = Font.cerqel(.semibold, size: 10)
    static public var caption2Medium = Font.cerqel(.medium, size: 10)
    static public var caption3Regular = Font.cerqel(.regular, size: 10)
    static public var popinsItalic16 = Font.cerqel(.mediumItalic, size: 16)
    static public var popinsItalic14 = Font.cerqel(.mediumItalic, size: 14)
    static public var popinsItalic12 = Font.cerqel(.mediumItalic, size: 12)
    static public var popinsItalic10 = Font.cerqel(.mediumItalic, size: 10)
}

extension Font {
    
    public enum CerqelFont {
        case regular
        case medium
        case semibold
        case mediumItalic
        case custom(String)
        
        public var value: String {
            switch self {
            case .regular:
                return "Poppins-Regular"
            case .medium:
                return "Poppins-Medium"
            case .semibold:
                return "Poppins-Semibold"
            case .mediumItalic:
                return "Poppins-MediumItalic"
            case .custom(let name):
                return name
            }
        }
    }
    
    static public func cerqel(_ type: CerqelFont, size: CGFloat = 14) -> Font {
        return .custom(type.value, size: size)
    }
}
