//
//  TableViewExtensions.swift
//  CERQEL
//
//  Created by ahmed maher on 05/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

/*
 extension UITableView {
     
     func registerCell(idintifier: String){
         self.register(UINib(nibName: idintifier, bundle: nil),
                                 forCellReuseIdentifier: idintifier)
     }
     
     func registerHaederFooterCell(idintifier: String){
         self.register(UINib(nibName: idintifier, bundle: nil),
                                 forHeaderFooterViewReuseIdentifier: idintifier)
     }

 }
 */
extension UITableView {
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let bundle = Bundle(for: T.self)
        self.register(UINib(nibName: T.cerqel_identifier, bundle: bundle), forCellReuseIdentifier: T.cerqel_identifier)
    }
    
    func registerHaederFooterCell<T: UITableViewHeaderFooterView>(viewType: T.Type) {
        let bundle = Bundle(for: T.self)
        self.register(UINib(nibName: T.cerqel_identifier, bundle: bundle),
                      forHeaderFooterViewReuseIdentifier: T.cerqel_identifier)
    }
}
