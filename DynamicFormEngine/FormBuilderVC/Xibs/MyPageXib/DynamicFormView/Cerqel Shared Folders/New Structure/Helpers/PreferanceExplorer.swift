//
//  PreferanceExplorer.swift
//  beauty_user
//
//  Created by Mac on 12/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit

public enum PreferenceType: String {
    
    case general = "General"
    case network = "General&path=Network"
    case phone = "tel://"
    case photos = "Photos"
    case safari = "Safari"
    case facebook = "Face"
    case snap = "snapchat"
    case linkedIn = "linkedin"
    case youtube = "Youtube"
    case twitter = "Twitter"
    case instagram = "insta"
    case whatsApp = "https://wa.me/"
    case wifi = "WIFI"
    case mail = "mailto:"
    
}

open class PreferencesExplorer {
    
    // MARK: - Class properties -
    
    static private let preferencePath = "App-Prefs:root"
    
    // MARK: - Class methods -
    
    static func open(_ preferenceType: PreferenceType,contact:String = "") {
        let appPath = "\(preferenceType.rawValue)"
        let urlPath = appPath != "Face" && appPath != "Twitter" && appPath != "insta" && appPath != "Safari" && appPath != "linkedin" &&
        appPath != "Youtube" &&
        appPath != "snapchat" ? (appPath+contact): contact
        print("url Path => \(urlPath)")
        if let url = URL(string: urlPath) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open( url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL( url)
            }
        }
        
    }
    
    
    
    static func openMap(_ lat:String, _ long: String){
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let s  = "comgooglemaps://?center=\(lat),\(long)&zoom=14&views=traffic"
            if let url = URL(string: s) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open( url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL( url)
                }
            }
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(long)&zoom=14&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
        }
    }
    

}
