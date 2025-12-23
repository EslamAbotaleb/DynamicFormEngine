//
//  DynamicSharedRouter.swift
//  CERQEL
//
//  Created by hassan elshaer on 18/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

enum DynamicAppStoryboard : String {
    
    case Main = "Main"
    case Auth = "AuthStoryboard"
    case myPage = "MyPageStoryboard"
    case form = "FormSB"
    case xibView
    case NewFormBuilder

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
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
    
    func navigationController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file, configurationHandler: ((T) -> Void)) -> UINavigationController {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).cerqel_storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        configurationHandler(scene)
        let navController = UINavigationController(rootViewController: scene)
        return navController
    }

    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

public enum DynamicViewControllerName {
    case backwardRequestDetails(Id: String, isMyRequestFlag: Bool, requestId: String, isFromNotifications: Bool = false , det: BackwardModelRequestDetailsData? = nil, view: UIViewController?,commentID: String? = "")
    case requestDetails(Id: String, isMyRequestFlag: Bool, requestId: String, isFromNotifications: Bool = false , det: ModelRequestDetailsData? = nil, view: UIViewController?,commentID: String? = "")
    case newFormBuilderDropDown
    case newFormBuilderSearch(code: String)
    case formViewController(serviceId: String,actionId: String?,buttonId: String?, isEditable: Bool? = false, isApproverForm: Bool? = false, requestId: String?)
    case serviceSummaryPagesVC(buttonId: String?, actionId: String?, isEditable: Bool?,isApproverForm: Bool?, requestIdForApprover: String?,view: UIViewController?)
//    case baseSort(sortName:String,sortType:sortSections,sortData:[sortModel])

}

public class DynamicSharedRouter {

    static public func goTo(viewName: DynamicViewControllerName)-> BottomSheetVCCerqel{
        switch viewName {
                
        case .serviceSummaryPagesVC(let buttonId, let actionId,let isEditable, let isApproverForm, let requestIdForApprover, let view):
            let storyboard: AppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: ServiceSummaryPagesVC.self)
            let viewModel = RequestDetailsViewModel(cerqel_BasicNetworkServiceImpl.shared, requestId: "", view: view ?? controller, router: CerqelRouterManagerImpl(controller))
            controller.isEditable = isEditable
            controller.isApproverForm = isApproverForm
            controller.viewModel = viewModel
            controller.buttonId = buttonId
            viewModel.reqIdForApprover = requestIdForApprover ?? ""
            controller.actionId = actionId
            controller.hidesBottomBarWhenPushed = true
            return controller
        case .newFormBuilderSearch(let code):
            let storyboard: DynamicAppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: NewSearchVC.self)
            controller.searchCode = code
            return controller
            
        case .newFormBuilderDropDown:
            let storyboard: AppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: NewDropDownViewController.self)
            return controller
            
        case .backwardRequestDetails(Id: let Id, isMyRequestFlag: let isMyRequestFlag, let requestId, let isFromNotifications, let det, let view, let commentID):
            let storyboard: AppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: BackwardRequestDetailsView.self)
            let viewModel = RequestDetailsViewModel(cerqel_BasicNetworkServiceImpl.shared, requestId: requestId, view: view ?? controller, router: CerqelRouterManagerImpl(controller))
            
            controller.viewModel = viewModel
            controller.id = Id
            controller.commentID = commentID ?? ""
            controller.isFromNotifications = isFromNotifications 
            controller.isMyRequestFlag = isMyRequestFlag
            controller.hidesBottomBarWhenPushed = true
            return controller
            
        case .requestDetails(Id: let Id, isMyRequestFlag: let isMyRequestFlag, let requestId, let isFromNotifications, let det, let view, let commentID):
            let storyboard: AppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: RequestDetailsView.self)
            let viewModel = RequestDetailsViewModel(cerqel_BasicNetworkServiceImpl.shared, requestId: requestId, view: view ?? controller, router: CerqelRouterManagerImpl(controller))
            
            controller.viewModel = viewModel
            controller.id = Id
            controller.commentID = commentID ?? ""
            controller.isFromNotifications = isFromNotifications 
            controller.isMyRequestFlag = isMyRequestFlag
            controller.hidesBottomBarWhenPushed = true
            return controller
            

        case .formViewController(let serviceId, let actionId, let buttonId, let isEditable,let isApproveForm, let reqId ) :
            let storyboard: DynamicAppStoryboard = .NewFormBuilder
            let controller = storyboard.viewController(viewControllerClass: FormViewController.self)
//            controller.viewModel = FormViewModel(form: nil)
            controller.serviceId = serviceId
            controller.actionId = actionId
            controller.buttonId = buttonId
            controller.isApproverForm = isApproveForm ?? false
            FormManager.shared.isEditable = isEditable ?? false
            controller.requestIdForApprover = reqId ?? ""
            controller.isApproverForm = isApproveForm ?? false
            controller.hidesBottomBarWhenPushed = true
            return controller
                
//        case .baseSort(let sortName,let sortType,let sortData):
//            let viewModel = BaseSortViewModel(cerqel_BasicNetworkServiceImpl.shared)
//            let storyboard: AppStoryboard = .xibView
//            let controller = storyboard.viewController(viewControllerClass: BaseSortVC.self)
//            controller.viewModel = viewModel
//            controller.sortBaseName = sortName
//            controller.sortType = sortType
//            controller.sortData = sortData
//            controller.hidesBottomBarWhenPushed = true
//            return controller
                
        }
    }
    
}

