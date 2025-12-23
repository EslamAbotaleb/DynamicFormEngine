//
//  AuthManager.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/20/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import RxCocoa
internal import RxSwift
internal import MOLH
import SideMenu
import UIKit

class AuthManager {

    private let service: cerqel_NetworkService = cerqel_BasicNetworkServiceImpl.shared
    private let disposeBag = DisposeBag()
    var isTasks = true
    var isAuthorized = false
    var userProfile = ""
    var isPopUpFromFormBuilder:((String) -> ())?
    var items: [[FormViewModelItem]] = []
    static var shared = AuthManager()
    var isRequestSubmitted = false
    var token: String = ""{
        didSet{
            UserDefaults.standard.set(token, forKey: "Token")
        }
    }
    
    var modules: [String:Any]? = [String:Any]()
    var refreshToken: String = ""{
        didSet{
            UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
        }
    }

    var is_single_tenant: Bool {
        get {
            UserDefaults.standard.bool(forKey: "is_single_tenant")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "is_single_tenant")
        }

    }

    var tenant: TenantListDTO? {
        get {
            guard let data = UserDefaults.standard.data(forKey: "tenant") else { return nil }
            let tenant = try? JSONDecoder().decode(TenantListDTO.self, from: data)
            return tenant
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "tenant")
        }
    }
    
    var unauthorizedFlag: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    var isInboxRefreshRequired = false
    var optionsRetreived = [MCQOption]()
    public var profile: BehaviorRelay<ModelUserProfileDataCerqel?> = BehaviorRelay(value: nil)
    var profilePicture: DynamicObjects<(UIImage?,Data?)?> = DynamicObjects(nil)

    var newSubmissionRetreiveEnabled = true
    
    init() {
        self.token = UserDefaults.standard.string(forKey: "Token") ?? ""
        self.refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") ?? ""
    }

    func UpdateLangAndRestartApp(selectedLang: Int, cancelCompletion: @escaping(()->()) = {}){
        let alert = UIAlertController(title: "Change Language".localized, message: "App Needs to Restart".localized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok".localized, style: .default) { (_) in
//            AuthManager.shared.tenant?.isSelected = false
            if selectedLang == 1, !isArabicCerqel() { // Do Arabic
                MOLH.setLanguageTo("ar")
            }else if selectedLang == 2, isArabicCerqel() { // Do English
                MOLH.setLanguageTo("en")
            }
            exit(1)
        }
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: .destructive) { (_) in
            cancelCompletion()
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    func configMenu() {
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width * 0.85
        SideMenuController.preferences.basic.statusBarBehavior = .hideOnMenu
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
    }
    
    func decode(jwtToken jwt: String) -> [String: Any]? {
        
        let segments = jwt.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }

        var base64String = segments[1]
        
        // Pad base64 string as needed
        let requiredLength = 4 * ((base64String.count + 3) / 4)
        let paddingLength = requiredLength - base64String.count
        if paddingLength > 0 {
            base64String += String(repeating: "=", count: paddingLength)
        }

        // Replace URL-safe characters
        base64String = base64String
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        guard let decodedData = Data(base64Encoded: base64String),
              let jsonObject = try? JSONSerialization.jsonObject(with: decodedData),
              let payload = jsonObject as? [String: Any] else {
            return nil
        }

        return payload
    }
}
