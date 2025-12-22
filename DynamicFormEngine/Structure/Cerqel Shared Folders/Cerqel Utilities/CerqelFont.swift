//
//  CerqelFont.swift
//  CerqelApp_SwiftUI
//
//  Created by Muhammed Sabri on 06/11/2023.
//

import SwiftUI

struct CerqelFonts {
    static var subtitleLRegular = Font.cerqel(.regular, size: 20.0)
    static var bodyLSemibold = Font.cerqel(.semibold, size: 16)
    static var bodyLMedium = Font.cerqel(.medium, size: 16)
    static var bodyLRegular = Font.cerqel(.regular, size: 16)
    static var bodyMSemibold = Font.cerqel(.semibold, size: 14)
    static var bodyMMedium = Font.cerqel(.medium, size: 14)
    static var bodyMRegular = Font.cerqel(.regular, size: 14)
    static var bodySSemibold = Font.cerqel(.semibold, size: 12)
    static var bodySMedium = Font.cerqel(.medium, size: 12)
    static var bodySRegular = Font.cerqel(.regular, size: 12)
    static var caption1Semibold = Font.cerqel(.semibold, size: 10)
    static var caption2Medium = Font.cerqel(.medium, size: 10)
    static var caption3Regular = Font.cerqel(.regular, size: 10)
    static var popinsItalic16 = Font.cerqel(.mediumItalic, size: 16)
    static var popinsItalic14 = Font.cerqel(.mediumItalic, size: 14)
    static var popinsItalic12 = Font.cerqel(.mediumItalic, size: 12)
    static var popinsItalic10 = Font.cerqel(.mediumItalic, size: 10)
}

extension Font {
    
    enum CerqelFont {
        case regular
        case medium
        case semibold
        case mediumItalic
        case custom(String)
        
        var value: String {
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
    
    static func cerqel(_ type: CerqelFont, size: CGFloat = 14) -> Font {
        return .custom(type.value, size: size)
    }
}
