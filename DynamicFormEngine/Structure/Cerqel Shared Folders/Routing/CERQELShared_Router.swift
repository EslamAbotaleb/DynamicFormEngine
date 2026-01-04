//
//  CERQEL_Router.swift
//  CERQEL
//
//  Created by mac on 6/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

public enum CerqelAppStoryboard : String {
    
    case Main = "Main"
    case Auth = "AuthStoryboard"
    case myPage = "MyPageStoryboard"
    case form = "FormSB"
    case xibView

    public var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    public func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        if case .xibView = self{
            let scene = T()
            return scene

        }
        let storyboardID = (viewControllerClass as UIViewController.Type).cerqel_storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    public func navigationController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file, configurationHandler: ((T) -> Void)) -> UINavigationController {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).cerqel_storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        configurationHandler(scene)
        let navController = UINavigationController(rootViewController: scene)
        return navController
    }

    
    public func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}
