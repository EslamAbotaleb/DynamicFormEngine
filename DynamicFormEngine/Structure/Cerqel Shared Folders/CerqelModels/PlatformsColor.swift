//
//  PlatformsColor.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation

public struct PlatformsColor : Codable {
    let primaryColorMain : String?
    let primaryColorLight : String?
    let secondaryColorMain : String?
    let secondaryColorLight : String?
    let typographyColorHeading : String?
    let typographyColorSubtitle : String?
    let typographyColorBody : String?
    let mainHeaderColorBg : String?
    let mainHeaderColorTextAndIcons : String?
    let subHeaderColorBg : String?
    let subHeaderColorTextAndIcons : String?
    let subHeaderColorBgColorButton : String?
    let subHeaderColorTextAndIconsButton : String?
    let sideMenuColorBg : String?
    let sideMenuColorTextAndIcons : String?
    let sideMenuColorHighlight : String?
    let backgroundColor : String?
    let mobileBgHeaderColor : String?
    let mobileBgTabNavigatorColor : String?
    
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
