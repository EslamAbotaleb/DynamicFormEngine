//
//  RoutingController.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit
import PanModal
import AVFoundation
import AVKit

public enum CerqelView {
    static public func baseController<ViewController: UIViewController>(viewControllerType: ViewController.Type) -> ViewController {
        let controller =  ViewController(nibName: ViewController.identifier , bundle: nil)
        return controller
    }

    static public func controller<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type,viewModel: viewModel.Type, item: Item) -> BaseView<viewModel, Item> {
        let controller =  ViewController(nibName: controller.identifier , bundle: nil) as! BaseView<viewModel, Item>
        controller.item = item
        return controller
    }

}


public class CerqelRouterManagerDynamicFormImpl: CerqelRouterManager {

    var currentViewController: UIViewController

    public init(_ currentViewController: UIViewController = UIViewController()) {
        self.currentViewController = currentViewController
    }
    public func push(vc: UIViewController) {
        currentViewController.navigationController?.pushViewController(vc, animated: true)
    }
    public func present(vc: UIViewController) {
        currentViewController.present(vc, animated: true)

    }

    public  func pushTo<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type, viewModel: viewModel.Type, item: Item ) {
        let controller =  ViewController(nibName: controller.identifier , bundle: nil) as! BaseView<viewModel, Item>
        controller.item = item
        controller.hidesBottomBarWhenPushed = true
        currentViewController.navigationController?.pushViewController(controller, animated: true)
    }

    public  func pushToScreenWithSameViewModel<ViewController: UIViewController, Item: BaseItem, ViewModel: BaseVM>(
        controller: ViewController.Type,
        viewModel: ViewModel,
        item: Item
    ) {
        let controller = ViewController(nibName: controller.identifier, bundle: nil) as! BaseView<ViewModel, Item>
        controller.item = item
        controller.viewModel = viewModel

        currentViewController.navigationController?.pushViewController(controller, animated: true)
    }



    public func presentbottomSheet<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(fromProfile: Bool = false, controller: ViewController.Type, viewModel: viewModel.Type, item: Item ) {
        let controller =  ViewController(nibName: controller.identifier , bundle: nil) as! BaseView<viewModel, Item>
        controller.item = item
        if fromProfile {
            currentViewController.modalPresentationStyle = .formSheet
            currentViewController.present(controller, animated: true)
        }else {
            currentViewController.presentPanModal(controller)
        }
    }



    public  func presentFullScreenWithSameViewModel<ViewController: UIViewController, Item: BaseItem, ViewModel: BaseVM>(
        controller: ViewController.Type,
        viewModel: ViewModel,
        item: Item
    ) {
        let controller = ViewController(nibName: controller.identifier, bundle: nil) as! BaseView<ViewModel, Item>
        controller.item = item
        controller.viewModel = viewModel

        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        currentViewController.present(navController, animated: true, completion: nil)
    }

    public func present<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type, viewModel: viewModel.Type, item: Item ) {
        let controller =  ViewController(nibName: controller.identifier , bundle: nil) as! BaseView<viewModel, Item>
        controller.item = item
        controller.modalPresentationStyle = .automatic
        currentViewController.present(controller, animated: true)
    }

    public func presentFullScreen<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type, viewModel: viewModel.Type, item: Item ) {
        let controller =  ViewController(nibName: controller.identifier , bundle: nil) as! BaseView<viewModel, Item>
        controller.item = item


        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        currentViewController.present(navController, animated: true, completion: nil)

    }


    public func popBack( ) {
        currentViewController.navigationController?.popViewController(animated: true)
    }

    public func dismiss( ) {
        currentViewController.dismiss(animated: true)
    }



    public func dismissCurrentController(completion: (() -> Void)?) {
        currentViewController.dismiss(animated: true, completion: {
            completion?()
        })
    }


    public func popToViewController(ofClass: AnyClass, animated: Bool ) {
        if let vc = currentViewController.navigationController?.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            currentViewController.navigationController?.popToViewController(vc, animated: animated)
        }


    }

    public func popToSpecialViewController(ofClass: AnyClass, animated: Bool) {
        if let vc = currentViewController.navigationController?.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            currentViewController.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    public  func popToAnyViewController(ofClass: AnyClass, animated: Bool) {
        if let navController = currentViewController.navigationController {
            // Look for existing VC of requested class
            if let targetVC = navController.viewControllers.first(where: { $0.isKind(of: ofClass) }) {
                navController.popToViewController(targetVC, animated: animated)
            } else {
                // If not found, create or reset the stack
                var controllers = navController.viewControllers
                
                // Optionally trim stack if you want to remove controllers above root
                controllers = [controllers.first].compactMap { $0 }
                
                // Create new instance of AllServicesController (or view controller matching ofClass)
                let newController: UIViewController
//                if ofClass == AllServicesViewController.self {
//                    newController = CerqelView.controller(controller: AllServicesViewController.self, viewModel: AllServicesViewModel.self, item: NewServiceFilterItem(serviceFrom: .allServices))
//                } else {
                    // fallback or create other controllers
                    newController = UIViewController()
//                }
                
                controllers.append(newController)
                navController.setViewControllers(controllers, animated: animated)
            }
        }
    }

}



extension UINavigationController {

    public func popToViewController(ofClass: AnyClass, animated: Bool = false) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }

    public  func popViewControllers(viewsToPop: Int, animated: Bool = false) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }

}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}
