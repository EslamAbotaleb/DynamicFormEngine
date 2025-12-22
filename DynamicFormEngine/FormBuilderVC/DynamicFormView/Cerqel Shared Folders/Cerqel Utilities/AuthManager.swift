//
//  AuthManager.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/20/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AuthManager {
    
    private let service: cerqel_NetworkService = cerqel_BasicNetworkServiceImpl.shared
    private let disposeBag = DisposeBag()
    var isTasks = true
    var userProfile = ""
    var isPopUpFromFormBuilder:(() -> ())?
    static var shared = AuthManager()
    var token: String = ""{
        didSet{
            UserDefaults.standard.set(token, forKey: "Token")
        }
    }
    var refreshToken: String = ""{
        didSet{
            UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
        }
    }
    var loginInfo: ModelLoginCerqel?
    var profile: DynamicObjects<ModelUserProfileDataCerqel?> = DynamicObjects( nil)

    var unauthorizedFlag: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
    var isInboxRefreshRequired = false
    
    init() {
        self.token = UserDefaults.standard.string(forKey: "Token") ?? ""
        self.refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") ?? ""
    }
    
    func configAuthManager() {
        unauthorizedFlag.subscribe(onNext: { [unowned self]  flag in
            if flag == true{
                if let topController = UIApplication.cerqel_topVC() {
                    if topController is UIAlertController {
                    } else {
                        let alert = UIAlertController(title: "", message: "Session expired, please login again".localized, preferredStyle: .alert)
                        alert.view.tintColor = primaryMain
                        let ok = UIAlertAction(title: "Login".localized, style: .default) { (_) in
                            self.logout()
                        }
                        alert.addAction(ok)
                        topController.present(alert, animated: true)
                    }
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func fetchProfile(){
        self.service.load(cerqel_CodableResponseObject<ModelUserProfileDataCerqel>(action: cerqel_BasicAction.fetchProfile)).subscribe(onNext: {
            [weak self] (response) in
            if let obj = response.item?.data{
                self?.profile.value = obj
            }
        }, onError: { (error) in

        }).disposed(by: self.disposeBag)
    }
    
    func logout(){
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        AuthManager.shared.profile.value = nil
        AuthManager.shared.loginInfo = nil
        AuthManager.shared.token = ""
        unauthorizedFlag.accept(false)
        let NavCtl = UINavigationController(rootViewController: CERQEL_Router.goTo(viewName: .LoginCerqelVC))
        NavCtl.navigationBar.isHidden = true
        appDel.window!.rootViewController = NavCtl
        appDel.window!.makeKeyAndVisible()

    }
}
