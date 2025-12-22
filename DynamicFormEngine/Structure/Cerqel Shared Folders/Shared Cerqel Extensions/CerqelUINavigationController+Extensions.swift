//
//  UINavigationController+Extensions.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/12/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    
    func cerqel_popBack(_ nb: Int) {
        let viewControllers: [UIViewController] = self.viewControllers
        guard viewControllers.count < nb else {
            self.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
            return
        }
    }
    
    func popToSpecialViewController(ofClass: AnyClass, animated: Bool) {
        // Look for existing VC of requested class
        if let targetVC = self.viewControllers.first(where: { $0.isKind(of: ofClass) }) {
            self.popToViewController(targetVC, animated: animated)
        } else {
            // If not found, create or reset the stack
            var controllers = self.viewControllers
            
            // Optionally trim stack if you want to remove controllers above root
            controllers = [controllers.first].compactMap { $0 }
            
            // Create new instance of AllServicesController (or view controller matching ofClass)
            let newController: UIViewController
            
            newController = UIViewController()
            
            controllers.append(newController)
            self.setViewControllers(controllers, animated: animated)
        }
    }
    
    /// pop back to specific viewcontroller
    func cerqel_popBack<T: UIViewController>(toControllerType: T.Type) {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController .isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: true)
                break
            }
        }
    }

    var cerqel_previousViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }

    func cerqel_setDefaultNavigationAppearance(){
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = UIColor.clear
            appearance.backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font : UIFont.heading1(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.black]
            appearance.setBackIndicatorImage(UIImage(named: isArabicCerqel() ? "Back" : "Back")!, transitionMaskImage: UIImage(named: "Back")!)
            navigationBar.standardAppearance = appearance;
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            navigationBar.tintColor = .darkGreenBlue
        } else {
            // Fallback on earlier versions
            print("this earlier called")
        }
    }
}
