//
//  CustomDashedView.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 29/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

public class CustomDashedView: UIView {
    
    
    // MARK: - Variables
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    var dashBorder: CAShapeLayer?
    
    
    // MARK: - LifeCycle
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        handleDashBorder()
    }
    
    
    // MARK: - Functions
    
    /// drawing dashborder for the uploaded media
    /// - Parameter dashBorder: drawed border
    public func settingDashBorderUI(dashBorder: CAShapeLayer) {
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
    }
    
    /// setting dashed border for the uploaded media
    public func handleDashBorder() {
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        settingDashBorderUI(dashBorder: dashBorder)
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
