//
//  TableViewExtensions.swift
//  CERQEL
//
//  Created by ahmed maher on 05/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

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
