//
//  UIViewControllerExtention.swift
//  PantherAppIOS
//
//  Created by Ahmed Maher on 6/8/19.
//  Copyright © 2019 MahmoudOrganization. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func setNavigationTitle( _ title: String) {
        self.navigationItem.title = title
    }
    
    public func setNavigationTheme() {
        let appearance = UINavigationBarAppearance()
        if #available(iOS 15, *) {
            appearance.configureWithOpaqueBackground()
        }
        appearance.backgroundColor = bgHColor
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: typographyTitle,
            NSAttributedString.Key.font: UIFont.bodyLMedium()
        ]
        appearance.buttonAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: typographyTitle,
            NSAttributedString.Key.font: UIFont.bodyLMedium()
        ]
        appearance.backButtonAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: typographyTitle,
            NSAttributedString.Key.font: UIFont.bodyLMedium()
        ]

        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    
    public func setNavigationBarTitle( _ title: String) {
        self.navigationItem.title = title
    }
    public func largeTitle() {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    public func setNavgationWithSearch(_ title: String) {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search transaction"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        hideNavigationBar(hide: false)
    }
    
    public func hideNavigationBar(hide: Bool = true) {
        self.navigationController?.setNavigationBarHidden(hide, animated: false)
    }
}
