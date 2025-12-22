//
//  UITableViewCell+Extention.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

//extension UITableViewCell{
//    static var identifier: String {
//        return String(describing: self)
//    }
//    
//    static var nib : UINib{
//        return UINib(nibName: identifier, bundle: nil)
//    }
//}
extension UITableView {
    func registerCell(nibName: String, cellId: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections-1)
            guard indexPath.row >= 0 else {return}
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

extension UITableViewCell{
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}
