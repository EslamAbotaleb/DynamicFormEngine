//
//  UsersViewController.swift
//  CERQEL
//
//  Created by Youxel on 14/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
import SwiftUI

class UsersViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var presentedFromProfile = false
    var selectedItem :  ((UserEntity?)->())!
    var currentselectedItems :  [UserEntity]?

    init(selectedItem: @escaping ((UserEntity?)->()),currentselectedItems: [UserEntity]?) {
        self.selectedItem = selectedItem
        self.currentselectedItems = currentselectedItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customizeWidgetView = DelegatorNames(isSingleSelection: true,
                                                 popupTitle: presentedFromProfile ? "Relatives Names".localized : "Delegator Names".localized,
                                                 selectedItemResult: selectedItem,
                                                 currentSelectedUsers: currentselectedItems)
        let hostingController = UIHostingController(rootView: customizeWidgetView)

        // Add the SwiftUI view as a subview
        addChild(hostingController)
        containerView.addSubview(hostingController.view)

        // Setup constraints (optional)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}
