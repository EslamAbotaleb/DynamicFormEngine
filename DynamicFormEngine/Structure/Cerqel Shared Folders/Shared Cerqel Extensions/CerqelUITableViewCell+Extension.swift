//
//  UITableViewCell+Extension.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

extension UITableViewCell{
    static var cerqel_identifier: String {
        return String(describing: self)
    }
    
    static var cerqel_nib : UINib{
        return UINib(nibName: cerqel_identifier, bundle: Bundle(for: Self.self))
    }
}
