//
//  DynamicSharedRouter.swift
//  CERQEL
//
//  Created by hassan elshaer on 18/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

public enum AppStoryboardDynamicForm: String {
    
    case Main = "Main"
    case Auth = "AuthStoryboard"
    case myPage = "MyPageStoryboard"
    case form = "FormSB"
    case xibView

    public var instance : UIStoryboard {
        /*
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
         */
        return UIStoryboard(
            name: self.rawValue,
            bundle: Bundle(for: RouterDynamicForm.self)
        )
    }
    
    public func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
//        if case .xibView = self{
//            let scene = T()
//            return scene
//
//        }
        if case .xibView = self {
            let bundle = Bundle(for: T.self)
            let scene = T(nibName: String(describing: T.self), bundle: bundle)
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

enum ViewControllerNameDynamicForm {
    case dynamicForm(ServiceId: String, categoryTitle: String?, hasSubService: Bool?, subParentName: String?)
    case requestDetails(Id: String, isMyRequestFlag: Bool, requestId: String, isFromNotifications: Bool = false , det: ModelRequestDetailsData? = nil, view: UIViewController?)
    case delegatorView(Id: String, isMyRequestFlag: Bool, requestId: String, isFromNotifications: Bool = false , det: ModelRequestDetailsData? = nil, view: UIViewController?)
    case newFormBuilderDropDown
    case newFormBuilderSearch(code: String)
}

class RouterDynamicForm {
    static public func goTo(viewName: ViewControllerNameDynamicForm)-> BottomSheetVCCerqel{
        switch viewName {
            
        case .newFormBuilderSearch(let code):
            let storyboard: AppStoryboardDynamicForm = .xibView
            let controller = storyboard.viewController(viewControllerClass: NewSearchVC.self)
            controller.searchCode = code
            return controller
            
            
        case .newFormBuilderDropDown:
            let storyboard: AppStoryboardDynamicForm = .xibView
            let controller = storyboard.viewController(viewControllerClass: NewDropDownViewController.self)
            return controller
            
                        
        case .dynamicForm(let ServiceId, let catTtl, let hasSubService, let subParentName):
            let viewModel = FormBuilderViewModel(cerqel_BasicNetworkServiceDynamicFormImpl.shared)
            let storyboard: AppStoryboardDynamicForm = .Main
            viewModel.selectedServiceId = ServiceId
            viewModel.hasSubService = hasSubService
            viewModel.categoryTitle = catTtl
            viewModel.subParentName = subParentName
            viewModel.nestedFormControlIndex = nil
            viewModel.nestedFormControlData = nil
            viewModel.nestedDataDelegate = nil
            viewModel.editNestedRowIndex = nil


            let controller = storyboard.viewController(viewControllerClass: FormBuilderVC.self)
            controller.viewModel = viewModel
            return controller

        case .requestDetails(Id: let Id, isMyRequestFlag: let isMyRequestFlag, let requestId, let isFromNotifications, let det, let view):
            let storyboard: AppStoryboardDynamicForm = .xibView
            let controller = storyboard.viewController(viewControllerClass: RequestDetailsView.self)
            let viewModel = RequestDetailsViewModel(cerqel_BasicNetworkServiceDynamicFormImpl.shared, requestId: requestId, view: view ?? controller, router: CerqelRouterManagerDynamicFormImpl(controller))
            
            controller.viewModel = viewModel
            controller.id = Id
            controller.isMyRequestFlag = isMyRequestFlag
            controller.isFromNotifications = isFromNotifications
            controller.hidesBottomBarWhenPushed = true
            if isFromNotifications{
                viewModel.details.accept(det)
            }
            
            return controller
            
            
        case .delegatorView(Id: let Id, isMyRequestFlag: let isMyRequestFlag, let requestId, let isFromNotifications, let det, let view):
            let storyboard: AppStoryboardDynamicForm = .xibView
            let controller = storyboard.viewController(viewControllerClass: RequestDetailsView.self)
            let viewModel = RequestDetailsViewModel(cerqel_BasicNetworkServiceDynamicFormImpl.shared, requestId: requestId, view: view ?? controller, router: CerqelRouterManagerDynamicFormImpl(controller))
            
            controller.viewModel = viewModel
            controller.id = Id
            controller.isMyRequestFlag = isMyRequestFlag
            controller.isFromNotifications = isFromNotifications
            controller.hidesBottomBarWhenPushed = true
            if isFromNotifications{
                viewModel.details.accept(det)
            }
            
            return controller
        }
    }
}
