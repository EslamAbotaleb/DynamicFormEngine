//
//  MaskedImageView.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 1/20/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

@IBDesignable
class MaskedImageView: UIImageView {
    
    var maskImageView = UIImageView()
    
    @IBInspectable
    var maskImage: UIImage?{
        didSet{
            maskImageView.image = maskImage
            maskImageView.frame = bounds
            mask = maskImageView
        }
    }
}
