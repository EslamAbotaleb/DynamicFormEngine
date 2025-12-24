//
//  UICollectionViewCell+Extensions.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

extension UICollectionViewCell{
    static public var cerqel_identifier: String {
        return String(describing: self)
    }
    
    static public var cerqel_nib : UINib{
        return UINib(nibName: cerqel_identifier, bundle: nil)
    }
    
}
extension UITableViewHeaderFooterView{
    static public var cerqel_identifier: String {
        return String(describing: self)
    }
    
    static public var cerqel_nib : UINib{
        return UINib(nibName: cerqel_identifier, bundle: nil)
    }
    
}

