//
//  FormBuilderEngineManager.swift
//  FormBuilderEngine
//
//  Created by hassan elshaer on 27/02/2024.
//

import Foundation
import UIKit

public class FormBuilderEngineManager: NSObject {
    
    public override init() {
        super.init()
    }
    
    public func navigateToRequestDetails(navigationController: UINavigationController?, taskID: String, requestId: String,token: String, requestFlag: Bool) {
        guard let navigationController = navigationController else {
            // Handle the case where navigationController is nil
            return
        }
        DFAuthManager.shared.token = token
        navigationController.pushViewController(
            RouterFE.goTo(viewName: .requestDetails(
                Id: taskID,
                isMyRequestFlag: requestFlag,
                requestId: requestId,
                isFromNotifications: false,
                det: nil,
                view: navigationController
            )),
            animated: true
        )
    }
    
    public func navigateToFormVC(navigationController: UINavigationController?, serviceId: String,token: String) {
        guard let navigationController = navigationController else {
            // Handle the case where navigationController is nil
            return
        }
//        let bundle = Bundle(for: FormViewController.self)
//        if let vc = UIStoryboard(name: "FormViewController", bundle: bundle).instantiateInitialViewController() as? FormViewController {
//            DFAuthManager.shared.token = token
//            vc.serviceId = serviceId
//            vc.hidesBottomBarWhenPushed = true
    
        let vc = FormVC(nibName: "FormVC", bundle: Bundle(for: FormVC.self))
        DFAuthManager.shared.token = token
        vc.serviceId = serviceId
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
       
////        loadStoryBoardBundle()
//        navigationController.pushViewController(RouterFE.goTo(viewName: .formViewController(serviceId: serviceId, actionId: nil, buttonId: nil, view: navigationController)), animated: true)
    }
//    func loadStoryBoardBundle(){
//        let bundle = Bundle(for: FormVC.self) // Use any class from the bundle containing the storyboard
//        let storyboard = UIStoryboard(name: "NewFormBuilder", bundle: bundle)
//    }
}

