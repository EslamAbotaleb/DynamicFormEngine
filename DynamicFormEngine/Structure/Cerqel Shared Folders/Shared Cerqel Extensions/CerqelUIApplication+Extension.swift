//
//  UIApplication+Extension.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 13/12/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func cerqel_topVC(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return cerqel_topVC(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return cerqel_topVC(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return cerqel_topVC(controller: presented)
        }
        return controller
    }
}
