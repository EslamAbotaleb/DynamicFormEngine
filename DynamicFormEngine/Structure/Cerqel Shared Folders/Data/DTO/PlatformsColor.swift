//
//  PlatformsColor.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation

public struct PlatformsColor : Codable {
    public let primaryColorMain : String?
    public let primaryColorLight : String?
    public let secondaryColorMain : String?
    public let secondaryColorLight : String?
    public let typographyColorHeading : String?
    public let typographyColorSubtitle : String?
    public let typographyColorBody : String?
    public let mainHeaderColorBg : String?
    public let mainHeaderColorTextAndIcons : String?
    public let subHeaderColorBg : String?
    public let subHeaderColorTextAndIcons : String?
    public let subHeaderColorBgColorButton : String?
    public let subHeaderColorTextAndIconsButton : String?
    public let sideMenuColorBg : String?
    public let sideMenuColorTextAndIcons : String?
    public let sideMenuColorHighlight : String?
    public let backgroundColor : String?
    public let mobileBgHeaderColor : String?
    public let mobileBgTabNavigatorColor : String?
    
    enum CodingKeys: String, CodingKey {
        
        case primaryColorMain = "primaryColorMain"
        case primaryColorLight = "primaryColorLight"
        case secondaryColorMain = "secondaryColorMain"
        case secondaryColorLight = "secondaryColorLight"
        case typographyColorHeading = "typographyColorHeading"
        case typographyColorSubtitle = "typographyColorSubtitle"
        case typographyColorBody = "typographyColorBody"
        case mainHeaderColorBg = "mainHeaderColorBg"
        case mainHeaderColorTextAndIcons = "mainHeaderColorTextAndIcons"
        case subHeaderColorBg = "subHeaderColorBg"
        case subHeaderColorTextAndIcons = "subHeaderColorTextAndIcons"
        case subHeaderColorBgColorButton = "subHeaderColorBgColorButton"
        case subHeaderColorTextAndIconsButton = "subHeaderColorTextAndIconsButton"
        case sideMenuColorBg = "sideMenuColorBg"
        case sideMenuColorTextAndIcons = "sideMenuColorTextAndIcons"
        case sideMenuColorHighlight = "sideMenuColorHighlight"
        case backgroundColor = "backgroundColor"
        case mobileBgHeaderColor = "mobileBgHeaderColor"
        case mobileBgTabNavigatorColor = "mobileBgTabNavigatorColor"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        primaryColorMain = try values.decodeIfPresent(String.self, forKey: .primaryColorMain)
        primaryColorLight = try values.decodeIfPresent(String.self, forKey: .primaryColorLight)
        secondaryColorMain = try values.decodeIfPresent(String.self, forKey: .secondaryColorMain)
        secondaryColorLight = try values.decodeIfPresent(String.self, forKey: .secondaryColorLight)
        typographyColorHeading = try values.decodeIfPresent(String.self, forKey: .typographyColorHeading)
        typographyColorSubtitle = try values.decodeIfPresent(String.self, forKey: .typographyColorSubtitle)
        typographyColorBody = try values.decodeIfPresent(String.self, forKey: .typographyColorBody)
        mainHeaderColorBg = try values.decodeIfPresent(String.self, forKey: .mainHeaderColorBg)
        mainHeaderColorTextAndIcons = try values.decodeIfPresent(String.self, forKey: .mainHeaderColorTextAndIcons)
        subHeaderColorBg = try values.decodeIfPresent(String.self, forKey: .subHeaderColorBg)
        subHeaderColorTextAndIcons = try values.decodeIfPresent(String.self, forKey: .subHeaderColorTextAndIcons)
        subHeaderColorBgColorButton = try values.decodeIfPresent(String.self, forKey: .subHeaderColorBgColorButton)
        subHeaderColorTextAndIconsButton = try values.decodeIfPresent(String.self, forKey: .subHeaderColorTextAndIconsButton)
        sideMenuColorBg = try values.decodeIfPresent(String.self, forKey: .sideMenuColorBg)
        sideMenuColorTextAndIcons = try values.decodeIfPresent(String.self, forKey: .sideMenuColorTextAndIcons)
        sideMenuColorHighlight = try values.decodeIfPresent(String.self, forKey: .sideMenuColorHighlight)
        backgroundColor = try values.decodeIfPresent(String.self, forKey: .backgroundColor)
        mobileBgHeaderColor = try values.decodeIfPresent(String.self, forKey: .mobileBgHeaderColor)
        mobileBgTabNavigatorColor = try values.decodeIfPresent(String.self, forKey: .mobileBgTabNavigatorColor)
    }
}
