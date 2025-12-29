//
//  FormBuilderManager.swift
//  DynamicFormEngine
//
//  Created by hassan elshaer on 08/10/2024.
//

import Foundation
import UIKit

public class FormBuilderManager: NSObject {
    
    public override init() {
        super.init()
    }
    
    public func navigateToRequestDetails(Id: String, isMyRequestFlag: Bool, requestId: String, isFromNotifications: Bool = false, navigationController: UINavigationController?, commentID: String? = "", token: String) {
        guard let navigationController = navigationController else {
            // Handle the case where navigationController is nil
            return
        }
//        DFAuthManagerDynamicForm.shared.token = token
//        navigationController.pushViewController(
//            DynamicSharedRouter.goTo(viewName: .requestDetails(
//                Id: Id,
//                isMyRequestFlag: isMyRequestFlag,
//                requestId: Id,
//                isFromNotifications: false,
//                det: nil,
//                view: navigationController
//            )),
//            animated: true
//        )
    }
    
//case formViewController(serviceId: String,actionId: String?,buttonId: String?, isEditable: Bool? = false, isApproverForm: Bool? = false, requestId: String?, serviceIdFromDetails: String? = "")
//    formViewController(let serviceId, let actionId, let buttonId, let isEditable,let isApproveForm, let reqId, let servIdFromDetails ) :
//        let storyboard: DynamicAppStoryboard = .NewFormBuilder
//        let controller = storyboard.viewController(viewControllerClass: FormViewController.self)
//        controller.serviceId = serviceId
//        controller.actionId = actionId
//        controller.buttonId = buttonId
//        controller.serviceIdFromDetails = servIdFromDetails ?? ""
//        controller.isApproverForm = isApproveForm ?? false
//        controller.isEditable = isEditable ?? false
//        controller.requestIdForApprover = reqId ?? ""
//        controller.isApproverForm = isApproveForm ?? false
//        controller.hidesBottomBarWhenPushed = true
//        return controller
    
    public func navigateToFormVC(navigationController: UINavigationController?, serviceId: String, actionId: String?, buttonId: String?, isEditable: Bool? = false, isApproverForm: Bool? = false, requestId: String?, serviceIdFromDetails: String? = "", token: String) {
        guard let navigationController = navigationController else {
            // Handle the case where navigationController is nil
            return
        }
//        let vc = FormVC(nibName: "FormVC", bundle: Bundle(for: FormVC.self))
//        DFAuthManagerDynamicForm.shared.token = token
//        vc.serviceId = serviceId
//        vc.actionId = actionId
//        vc.buttonId = buttonId
//        vc.serviceIdFromDetails = serviceIdFromDetails ?? ""
//        vc.isApproverForm = isApproverForm ?? false
//        vc.isEditable = isEditable ?? false
//        vc.requestIdForApprover = requestId ?? ""
//        vc.isApproverForm = isApproverForm ?? false
//        vc.hidesBottomBarWhenPushed = true
//        navigationController.pushViewController(vc, animated: true)
       
////        loadStoryBoardBundle()
//        navigationController.pushViewController(RouterFE.goTo(viewName: .formViewController(serviceId: serviceId, actionId: nil, buttonId: nil, view: navigationController)), animated: true)
    }
//    func loadStoryBoardBundle(){
//        let bundle = Bundle(for: FormVC.self) // Use any class from the bundle containing the storyboard
//        let storyboard = UIStoryboard(name: "NewFormBuilder", bundle: bundle)
//    }
}


