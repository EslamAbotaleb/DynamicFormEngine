//
//  SettingManager.swift
//  CERQEL
//
//  Created by Youxel on 16/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
class SettingManager {
   static func openSettings() {
       guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
           return
       }
       UIApplication.shared.open(settingsURL)
    }
 
}
