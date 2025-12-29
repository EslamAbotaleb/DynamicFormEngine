//
//  ToastManger.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 16/01/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import UIKit
public import Toast

public class ToastManager {
    
    private static var toastContainerView: UIView?
    private static var v = UIView()
    
    static public func showToast(withText text: String, containerBg: UIColor, containerBorderColor: UIColor, image: UIImageView, closeBtnColor : UIColor , txtColor : UIColor , containerHeight: CGFloat? = 65 ) {
        let toastContainerView = UIView()
        toastContainerView.isHidden = false
        toastContainerView.translatesAutoresizingMaskIntoConstraints = false
        toastContainerView.backgroundColor = containerBg
        toastContainerView.borderWidthV = 1
        toastContainerView.borderColorV = containerBorderColor
        toastContainerView.cornerRadiusV = 8
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                v.isHidden = false
                v.frame = window.frame
                window.addSubview(v)
            }
        }
                
        v.addSubview(toastContainerView)
        
        self.toastContainerView = toastContainerView  // Assign to the static property

        let imageView = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        toastContainerView.addSubview(imageView)

        let button = UIButton()
//        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = closeBtnColor
        button.translatesAutoresizingMaskIntoConstraints = false
        toastContainerView.addSubview(button)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        let closeImgV = UIImageView(image: UIImage(named: "close"))
        closeImgV.translatesAutoresizingMaskIntoConstraints = false
        closeImgV.tintColor = closeBtnColor
        closeImgV.contentMode = .scaleToFill
        toastContainerView.addSubview(closeImgV)

        let label = UILabel()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = txtColor
        label.font = UIFont.bodySRegular()
        toastContainerView.addSubview(label)

        NSLayoutConstraint.activate([
            toastContainerView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 16),
            toastContainerView.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -16),
            toastContainerView.topAnchor.constraint(equalTo: v.topAnchor, constant: 60),
            toastContainerView.heightAnchor.constraint(equalToConstant: containerHeight ?? 65),

            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22),
            imageView.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: toastContainerView.leadingAnchor, constant: 16),

            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 12),
            button.trailingAnchor.constraint(equalTo: toastContainerView.trailingAnchor, constant: -16),
            
            closeImgV.widthAnchor.constraint(equalToConstant: 14),
            closeImgV.heightAnchor.constraint(equalToConstant: 14),
            closeImgV.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 15),
            closeImgV.trailingAnchor.constraint(equalTo: toastContainerView.trailingAnchor, constant: -19),

            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 13),
        ])
        dismissToastAfterSeconds(seconds: 3)
    }

    static public func dismissToastAfterSeconds(seconds: Double) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { (_) in
           // TODO: - whatever you want
            self.toastContainerView?.isHidden = true
            self.v.isHidden = true
        }
    }
    
    
    @objc private static func dismissButtonTapped() {
        // Handle button tapped event here
        print("Close")
        self.toastContainerView?.isHidden = true
        self.v.isHidden = true
    }
}
