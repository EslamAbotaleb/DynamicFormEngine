//
//  ColorCustomization.swift
//  CERQEL
//
//  Created by mac on 4/4/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

var needed: Bool = false

// MARK:- App Colors
var primaryMain = UIColor(rCerqel: 113, gCerqel: 43, bCerqel: 129, aCerqel: 1)
var primaryLight = UIColor(rCerqel: 254, gCerqel: 248, bCerqel: 255, aCerqel: 1)
var secondaryMain = UIColor(rCerqel: 218, gCerqel: 62, bCerqel: 123, aCerqel: 1)
var secondaryLight = UIColor(rCerqel: 255, gCerqel: 245, bCerqel: 249, aCerqel: 1)
var typographyTitle = UIColor(rCerqel: 35, gCerqel: 41, bCerqel: 47, aCerqel: 1)
var typographySubtitle = UIColor(rCerqel: 85, gCerqel: 86, bCerqel: 94, aCerqel: 1)
var typographyBody = UIColor(rCerqel: 150, gCerqel: 150, bCerqel: 150, aCerqel: 1)
var bg = UIColor(rCerqel: 242, gCerqel: 245, bCerqel: 252, aCerqel: 1)
var bgHeader = UIColor(rCerqel: 255, gCerqel: 255, bCerqel: 255, aCerqel: 1)
var bgTabNavigation = UIColor(rCerqel: 255, gCerqel: 255, bCerqel: 255, aCerqel: 1)
var bgHColor = UIColor(rCerqel: 255, gCerqel: 255, bCerqel: 255, aCerqel: 1)
var alertSuccessColor = UIColor(rCerqel: 27, gCerqel: 153, bCerqel: 139, aCerqel: 1)
var defaultGrayColor = UIColor(rCerqel: 189, gCerqel: 189, bCerqel: 189, aCerqel: 1)
var TypographyLinks = UIColor(rCerqel: 46, gCerqel: 151, bCerqel: 239, aCerqel: 1)
var selectExcellentEmojiColor = UIColor(hexString: "#309620")
var selectGoodEmojiColor = UIColor(hexString: "#62DA4E")
var selectFairEmojiColor = UIColor(hexString: "#E7BB4B")
var selectBadEmojiColor = UIColor(hexString: "#EF5757")
var selectVeryBadEmojiColor = UIColor(hexString: "#AE2A2A")
var redButton = UIColor(rCerqel: 201, gCerqel: 56, bCerqel: 56, aCerqel: 1)
var sideMenuBG: UIColor = .white
var sideMenuTextColor: UIColor = .white
var sideMenuColorhighLight: UIColor = .white

class MyColor {
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 1.0

    func setFromAPIResponse(_ response: [String: Any]) {
        if let red = response["red"] as? Double {
            self.red = CGFloat(red)
        }
        if let green = response["green"] as? Double {
            self.green = CGFloat(green)
        }
        if let blue = response["blue"] as? Double {
            self.blue = CGFloat(blue)
        }
        if let alpha = response["alpha"] as? Double {
            self.alpha = CGFloat(alpha)
        }
    }

    func setFromObject(_ color: ColorCustomizationModelCerqel) {
        if let red = color.red {
            self.red = CGFloat(red)
        }
        if let green = color.green {
            self.green = CGFloat(green)
        }
        if let blue = color.blue {
            self.blue = CGFloat(blue)
        }
        if let alpha = color.alpha {
            self.alpha = CGFloat(alpha)
        }

    }

    func asUIColor() -> UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        guard let color = color else {
            removeObject(forKey: key)
            return
        }

        let data = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        guard let colorData = data else { return }
        set(colorData, forKey: key)
    }

    func colorForKey(key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        let color = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor) ?? .systemBackground
        return color
    }
}
