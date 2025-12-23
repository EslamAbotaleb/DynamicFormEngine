//
//  UIView+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/18/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

public extension UIView {
    
    func cerqel_fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    var globalFrameCerqel: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
    
    func cerqel_addShadowWith(color: UIColor, radius: CGFloat, opacity: Float?) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity ?? 0.7
    }
    
    func cerqel_addNormalShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        
    }
    
    func cerqel_addMaveShadow(){
        self.layer.shadowColor = UIColor.darkGreenBlue.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        
    }
    
    func cerqel_cornerRadiusRound(usingCorners corners: UIRectCorner, cornerRadii: CGSize) {
        let path = UIBezierPath(roundedRect: self .bounds,
                                byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer ( )
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func cerqel_roundCorners(corners: UIRectCorner, radius: CGFloat) {
        var corner = corners
        if isArabicCerqel(){
            if corner == .bottomLeft{
                corner = .bottomRight
            }
            if corner == .topRight{
                corner = .topLeft
            }
        }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: 0, height: 0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func cerqel_topCorners(radius: CGFloat) {

        self.clipsToBounds = true

        self.layer.cornerRadius = radius

        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }

    func cerqel_bottomCorners(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
