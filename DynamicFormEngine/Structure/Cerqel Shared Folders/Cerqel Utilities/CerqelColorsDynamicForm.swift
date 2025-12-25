//
//  ExtensionColor.swift
//  CerqelApp_SwiftUI
//
//  Created by Muhammed Sabri on 06/11/2023.
//

import SwiftUI

public struct CerqelColors {
    
    static public var white = Color(hex: "FFFFFF")
    static public var background = Color(hex: "F2F5FC")
    static public var alertSuccessApproved = Color(hex: "44C0B0")
    static public var alertsEscalated = Color(hex: "6A54FB")
    static public var alertsCompleted = Color(hex: "2E97EF")
    static public var alertsError = Color(hex: "EC4A4A")
    static public var alertsErrorLight = Color(hex: "FFF0F6")
    static public var backgroundBorder = Color(hex: "E7E4EC")
    static public var gray = Color(hex: "BDBDBD")
    static public var primaryLight = Color(hex: "FEF8FF")
    static public var primaryMain = Color(hex: "712B81")
    static public var supportGreen = Color(hex: "65D3A1")
    static public var typographySubtitle = Color(hex: "55565E")
    static public var typographyTitle = Color(hex: "23292F")
    static public var typographyBody = Color(hex: "969696")
    static public var grayLight = Color(hex: "F5F5F5")
    static public var secondarySkyBlue = Color(hex: "1582BC")
    static public var SupportSkyBlue = Color(hex: "5DA9E9")
    static public var bodyGray = Color(hex: "797979")
    static public var placeholder = Color(hex: "737373")
    static public var placeholderGrayDark = Color(hex: "969696")
    static public var titelGrayDark = Color(hex: "373737")
    static public var completedLight = Color(hex: "EAEFFD")
    static public var SupportSkyBlueLight = Color(hex: "F6FAFF")
    static public var YOUXELPrimaryPurple = Color(hex: "542D89")
    static public var YOUXELFuchsiaLight = Color(hex: "F9E8FF")
    static public var redButtons = Color(hex: "C93838")
}

extension Color {

    public init(hex: String) {
           let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int: UInt64 = 0
           Scanner(string: hex).scanHexInt64(&int)
           let a, r, g, b: UInt64
           switch hex.count {
           case 3: // RGB (12-bit)
               (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
           case 6: // RGB (24-bit)
               (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
           case 8: // ARGB (32-bit)
               (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
           default:
               (a, r, g, b) = (1, 1, 1, 0)
           }

           self.init(
               .sRGB,
               red: Double(r) / 255,
               green: Double(g) / 255,
               blue:  Double(b) / 255,
               opacity: Double(a) / 255
           )
       }
}
