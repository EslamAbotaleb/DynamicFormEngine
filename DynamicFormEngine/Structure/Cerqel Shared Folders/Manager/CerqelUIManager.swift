//
//  CerqelUIManager.swift
//  DynamicFormEngine
//
//  Created by Eslam on 20/12/2025.
//

import Foundation
public import Toast
import UIKit

public class CerqelUIManager {

    public static func showToast(
        parent: UIViewController,
        msg: String
    ) {
        var style = ToastStyle()
        style.imageSize = CGSize(width: 20, height: 20)
        style.messageFont = UIFont.bodyLMedium()
        style.messageColor = .white
        style.backgroundColor = .black
        style.fadeDuration = 3

        parent.view.makeToast(
            msg,
            point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140),
            title: nil,
            image: nil,
            style: style,
            completion: nil
        )
    }
    
    // Your old showToastCerqel method refactored as static
    public static func showToastCerqel(msg: String) {
        var style = ToastStyle()
        style.imageSize = CGSize(width: 20, height: 20)
        style.messageFont = UIFont.Poppins_regular(ofSize: 14)
        style.messageColor = .white
        style.backgroundColor = .black
        style.fadeDuration = 3
        
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first,
           let rootView = window.rootViewController?.view {
            rootView.makeToast(
                msg,
                point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140),
                title: nil,
                image: nil,
                style: style,
                completion: nil
            )
        }
    }
    
    public static func showAlert(_ text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default))
        
        if let topVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?
            .rootViewController {

            topVC.present(alert, animated: true)
        }
    }

    public static func setColors(apiResponse: [String: Double]) {
        let myColor = MyColor()
        myColor.setFromAPIResponse(apiResponse)
        primaryMain = myColor.asUIColor()
        
        //  tint color
        UIApplication.shared.windows.first?.tintColor = primaryMain
        
        UserDefaults.standard.setColor(color: primaryMain, forKey: "primaryMain")
    }

}
