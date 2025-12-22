//
//  ExtensionColor.swift
//  CerqelApp_SwiftUI
//
//  Created by Muhammed Sabri on 06/11/2023.
//

import SwiftUI

struct CerqelColors {
    
    static var white = Color(hex: "FFFFFF")
    static var background = Color(hex: "F2F5FC")
    static var alertSuccessApproved = Color(hex: "44C0B0")
    static var alertsEscalated = Color(hex: "6A54FB")
    static var alertsCompleted = Color(hex: "2E97EF")
    static var alertsError = Color(hex: "EC4A4A")
    static var alertsErrorLight = Color(hex: "FFF0F6")
    static var backgroundBorder = Color(hex: "E7E4EC")
    static var gray = Color(hex: "BDBDBD")
    static var primaryLight = Color(hex: "FEF8FF")
    static var primaryMain = Color(hex: "712B81")
    static var supportGreen = Color(hex: "65D3A1")
    static var typographySubtitle = Color(hex: "55565E")
    static var typographyTitle = Color(hex: "23292F")
    static var typographyBody = Color(hex: "969696")
    static var grayLight = Color(hex: "F5F5F5")
    static var secondarySkyBlue = Color(hex: "1582BC")
    static var SupportSkyBlue = Color(hex: "5DA9E9")
    static var bodyGray = Color(hex: "797979")
    static var placeholder = Color(hex: "737373")
    static var placeholderGrayDark = Color(hex: "969696")
    static var titelGrayDark = Color(hex: "373737")
    static var completedLight = Color(hex: "EAEFFD")
    static var SupportSkyBlueLight = Color(hex: "F6FAFF")
    static var YOUXELPrimaryPurple = Color(hex: "542D89")
    static var YOUXELFuchsiaLight = Color(hex: "F9E8FF")
    static var redButtons = Color(hex: "C93838")
}

extension Color {

    init(hex: String) {
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
