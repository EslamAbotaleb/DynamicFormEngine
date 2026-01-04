//
//  LocallizedCollectionViewCerqel.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 1/10/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit
//internal import MOLH

public class LocallizedCollectionViewCerqel: UICollectionViewFlowLayout {
    override public var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return MOLHLanguage.isArabic()
    }
    
}

extension UICollectionView {
    
    // This is in the UICollectionView subclass
    public func cerqel_addGradientMask() {
        let coverView = cerqel_GradientView(frame: self.bounds)
        let coverLayer = coverView.layer as! CAGradientLayer
        coverLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        coverLayer.locations = [0.0, 0.5, 1.0]
        coverLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        coverLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.mask = coverView
    }

    // Declare this anywhere outside the sublcass
    public  class cerqel_GradientView: UIView {
        public  class func layerClass() -> AnyClass {
            return CAGradientLayer.self
        }
    }

}
