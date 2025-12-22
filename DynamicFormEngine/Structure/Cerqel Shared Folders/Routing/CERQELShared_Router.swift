//
//  CERQEL_Router.swift
//  CERQEL
//
//  Created by mac on 6/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

enum CerqelAppStoryboard : String {
    
    case Main = "Main"
    case Auth = "AuthStoryboard"
    case myPage = "MyPageStoryboard"
    case form = "FormSB"
    case xibView

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
/*
enum CerqelSharedViewControllerName {
    case baseSort(sortName:String,sortType:sortSectionsCerqel,sortData:[sortModelCerqel])
    case recentSearchModule(module: ModuleSearchKey, filterModel: CerqelFilterModelCerqel?, selectedSort: String?, isDismiss: Bool)
    case filter(sections: [FilterSection], filterModel: CerqelFilterModelCerqel?, searchTxt: String?, selectedSort: String?)
    case searchModule(module: ModuleSearchKey, filterModel: CerqelFilterModelCerqel?, text: String?, selectedSort: String?, isDismiss: Bool,type: Int? = nil)
    case baseSearchFilterResult(filterModel: CerqelFilterModelCerqel?, searchTxt: String?, selectedSort: String?, module: moduleListEnum,type: Int? = nil)
}

class CERQELShared_Router {
    
    static func goTo(viewName: CerqelSharedViewControllerName)-> BottomSheetVCCerqel{
        
        switch viewName {
            
        case .baseSort(let sortName,let sortType,let sortData):
            let viewModel = CerqelBaseSortViewModel(cerqel_BasicNetworkServiceImpl.shared)
            let storyboard: CerqelAppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: CerqelBaseSortVC.self)
            controller.viewModel = viewModel
          //  controller.viewModel.sortName = sortName
           // controller.viewModel.sortType = sortType
              controller.sortBaseName = sortName
              controller.sortType = sortType
            controller.sortData = sortData
            controller.hidesBottomBarWhenPushed = true
            return controller
            
        case .recentSearchModule(module: let module, filterModel: let filterModel, selectedSort: let selectedSort, isDismiss: let isDismiss):
            let viewModel = SearchVM(cerqel_BasicNetworkServiceImpl.shared)
            let storyboard: CerqelAppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: RecentSearchVC.self)
            controller.viewModel = viewModel
            controller.viewModel.moduleSearchKey = module
            controller.viewModel.filterModel = filterModel
            controller.viewModel.selectedSort = selectedSort
            controller.viewModel.isDismiss = isDismiss
            controller.hidesBottomBarWhenPushed = true
            return controller

        case .filter(sections: let sections, filterModel: let filterModel, searchTxt: let searchTxt, selectedSort: let sort):
            let viewModel = FilterVM(cerqel_BasicNetworkServiceImpl.shared)
            let storyboard: CerqelAppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: FilterVC.self)
            controller.viewModel = viewModel
            controller.viewModel.sections.accept(sections)
            controller.viewModel.filterModel = filterModel
            controller.viewModel.searchTxt = searchTxt
            controller.viewModel.selectedSort = sort
            controller.hidesBottomBarWhenPushed = true
            return controller

        case .searchModule(module: let module, filterModel: let filterModel, text: let text, selectedSort: let sort, isDismiss: let isDismiss,type: let type):
            let viewModel = SearchVM(cerqel_BasicNetworkServiceImpl.shared)
            let storyboard: CerqelAppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: SearchScreenVC.self)
            controller.viewModel = viewModel
            controller.viewModel.moduleSearchKey = module
            controller.viewModel.filterModel = filterModel
            controller.viewModel.searchText.accept(text)
            controller.viewModel.type = type
            controller.viewModel.selectedSort = sort
            controller.viewModel.isDismiss = isDismiss
            controller.hidesBottomBarWhenPushed = true
            return controller

        case .baseSearchFilterResult(filterModel: let filterModel, searchTxt: let searchTxt, selectedSort: let selectedSort, let module,type: let type):
            let viewModel = SearchFilterViewModel(cerqel_BasicNetworkServiceImpl.shared, module: module)
            let storyboard: CerqelAppStoryboard = .xibView
            let controller = storyboard.viewController(viewControllerClass: SearchFilterResultView.self)
            controller.viewModel = viewModel
            controller.viewModel.filterModel = filterModel
            controller.viewModel.searchText = searchTxt
            controller.viewModel.type = type
            controller.viewModel.selectedSort = selectedSort ?? "Newest"
            controller.hidesBottomBarWhenPushed = true
            return controller
        }
        

        
    }
    
}
*/
