//
//  RoutingManeger.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit

public protocol CerqelRouterManager {
    func push(vc: UIViewController)
    func present(vc: UIViewController)
    func pushTo<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type, viewModel: viewModel.Type, item: Item )
    func pushToScreenWithSameViewModel<ViewController: UIViewController, Item: BaseItem, ViewModel: BaseVM>(
        controller: ViewController.Type,viewModel: ViewModel, item: Item
    )

    func present<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type, viewModel: viewModel.Type, item: Item )
    func presentFullScreenWithSameViewModel<ViewController: UIViewController, Item: BaseItem, ViewModel: BaseVM>( controller: ViewController.Type,  viewModel: ViewModel,  item: Item)
    func presentFullScreen<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(controller: ViewController.Type, viewModel: viewModel.Type, item: Item )
    func popBack( )
    func presentbottomSheet<ViewController: UIViewController,viewModel: BaseVM, Item: BaseItem>(fromProfile: Bool, controller: ViewController.Type, viewModel: viewModel.Type, item: Item )
    func dismiss( )
    func dismissCurrentController(completion: (() -> Void)?)
    func popToViewController(ofClass: AnyClass, animated: Bool )
    func popToSpecialViewController(ofClass: AnyClass, animated: Bool )
    func popToAnyViewController(ofClass: AnyClass, animated: Bool)
}
