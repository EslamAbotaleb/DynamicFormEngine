//
//  LoginViewModel.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/14/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CryptoSwift
//import MSAL

class LoginViewModel: BaseViewModel {
    
    private let service: cerqel_NetworkService
    private let disposeBag = DisposeBag()
    
//    let kClientID = "1dcbf44d-867d-4c19-b9f1-7bc7370c534b"
//    let kRedirectUri = "msauth.com.youxel.cerqel://auth"
//    let kAuthority = "https://login.microsoftonline.com/43d9f497-df52-4d38-ab24-ee8f3eb4fa44"
//    let kGraphEndpoint = "https://graph.microsoft.com/"
//    
//    let kScopes: [String] = ["user.read"]
//    var accessToken = String()
//    var applicationContext : MSALPublicClientApplication?
//    var webViewParamaters : MSALWebviewParameters?
//    var currentAccount: MSALAccount?
//    var currentDeviceMode: MSALDeviceMode?
//    typealias AccountCompletion = (MSALAccount?) -> Void
    
    var unopenedNotificationCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)

    init(_ service: cerqel_NetworkService) {
        self.service = service
        super.init()
    }
    
    func checkUnOpenedNotification() {
        self.service.load(cerqel_CodableResponseObject<ModelNotificationCountDataCerqel>(action: cerqel_BasicAction.unOpenedNotificationCount)).subscribe(onNext: {
            (response) in
            if let val = response.item?.data{
                self.unopenedNotificationCount.accept(val.notificationCounter ?? 0)
                print("Unopened Notifications : \(val.notificationCounter)")
            }else{
                self.unopenedNotificationCount.accept(0)
            }
        }, onError: { (error) in
            self.unopenedNotificationCount.accept(0)
        }).disposed(by: self.disposeBag)
    }

    //Removes all tokens from the cache for this application for the provided account
    // MARK: Get account and removing cache
//    func signOut() {
//        guard let applicationContext = self.applicationContext else {
//            return
//        }
//        guard let account = self.currentAccount else { return }
//        do {
//            let signoutParameters = MSALSignoutParameters(webviewParameters: self.webViewParamaters!)
//            // set this to true if you also want to signout from browser or webview
//            if (self.currentDeviceMode == .shared) {
//                signoutParameters.signoutFromBrowser = true
//            } else {
//                signoutParameters.signoutFromBrowser = false
//            }
//            applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {(success, error) in
//                if let error = error {
//                    print("Couldn't sign out account with error: \(error)")
//                    return
//                }
//                print("Sign out completed successfully")
//                AuthManager.shared.token = ""
//                //go to login Screen
//
//                self.updateCurrentAccount(account: nil)
//            })
//        }
//    }
    
//    func platformViewDidLoadSetup() {
//        NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeGround(notification:)),name: UIApplication.willEnterForegroundNotification,object: nil)
//    }
    
//    @objc func appCameToForeGround(notification: Notification) {
//        self.loadCurrentAccount()
//    }
    
//    func loadCurrentAccount(completion: AccountCompletion? = nil) {
//        guard let applicationContext = self.applicationContext else {
//            return
//        }
//        let msalParameters = MSALParameters()
//        msalParameters.completionBlockQueue = DispatchQueue.main
//        applicationContext.getCurrentAccount(with: msalParameters, completionBlock: { (currentAccount, previousAccount, error) in
//            if let error = error {
//                print("Couldn't query current account with error: \(error)")
//                return
//            }
//            if let currentAccount = currentAccount {
//                print("Found a signed in account \(String(describing: currentAccount.username)). Updating data for that account...")
//                self.updateCurrentAccount(account: currentAccount)
//                if let completion = completion {
//                    completion(self.currentAccount)
//                }
//                return
//            }
//            if let previousAccount = previousAccount {
//                print("The account with username \(String(describing: previousAccount.username)) has been signed out.")
//            } else {
//                print("Account signed out. Updating UX")
//            }
////            AuthManager.shared.token = ""
//            registerToOurBE.shared.register()
//            self.updateCurrentAccount(account: nil)
//            if let completion = completion {
//                completion(nil)
//            }
//        })
//    }
    
//    func updateCurrentAccount(account: MSALAccount?) {
//        self.currentAccount = account
//    }
    
//    func refreshDeviceMode() {
//        if #available(iOS 13.0, *) {
//            self.applicationContext?.getDeviceInformation(with: nil, completionBlock: { (deviceInformation, error) in
//                guard let deviceInfo = deviceInformation else {
//                    return
//                }
//                self.currentDeviceMode = deviceInfo.deviceMode
//            })
//        }
//    }
    
//    func getContentWithToken() {
//        // Specify the Graph API endpoint
//        let graphURI = getGraphEndpoint()
//        let url = URL(string: graphURI)
//        var request = URLRequest(url: url!)
//        
//        request.setValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Couldn't get graph result: \(error)")
//                return
//            }
//            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
//                print("Couldn't deserialize result JSON")
//                return
//            }
//           // print("Result from Graph: \(result)")
//        }.resume()
//    }
    
//    func getGraphEndpoint() -> String {
//        return kGraphEndpoint.hasSuffix("/") ? (kGraphEndpoint + "v1.0/me/") : (kGraphEndpoint + "/v1.0/me/");
//    }
    
//    func acquireTokenInteractively() {
//        guard let applicationContext = self.applicationContext else { return }
//        guard let webViewParameters = self.webViewParamaters else { return }
//        let parameters = MSALInteractiveTokenParameters(scopes:kScopes, webviewParameters: webViewParameters)
//        parameters.promptType = .selectAccount
//        applicationContext.acquireToken(with: parameters) { (result, error) in
//            if let error = error {
//                print("Could not acquire token: \(error)")
//                return
//            }
//            guard let result = result else {
//                print("Could not acquire token: No result returned")
//                return
//            }
//            AuthManager.shared.token = result.idToken ?? ""
//            print(AuthManager.shared.token)
//            print("Access token is \(AuthManager.shared.token)")
//            //go to Home
//            self.updateCurrentAccount(account: result.account)
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.goToSideMenu()
//            self.getContentWithToken()
//        }
//    }
    
//    func acquireTokenSilently(_ account : MSALAccount!) {
//        guard let applicationContext = self.applicationContext else {
//            return
//        }
//        let parameters = MSALSilentTokenParameters(scopes:kScopes, account: account)
//        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
//            if let error = error {
//                let nsError = error as NSError
//                if (nsError.domain == MSALErrorDomain) {
//                    if (nsError.code == MSALError.interactionRequired.rawValue) {
//                        DispatchQueue.main.async {
//                            self.acquireTokenInteractively()
//                        }
//                        return
//                    }
//                }
//                print("Could not acquire token silently: \(error)")
//                return
//            }
//            guard let result = result else {
//                print("Could not acquire token: No result returned")
//                return
//            }
//            print(AuthManager.shared.token)
//            AuthManager.shared.token = result.idToken ?? ""
//            self.getContentWithToken()
//            print("Refreshed Access token is \(result.idToken ?? "")")
//            //go to Home
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.goToSideMenu()
//        }
//    }
    
//    func initMSAL(vc:UIViewController) throws {
//        guard let authorityURL = URL(string: kAuthority) else {
//            print("Unable to create authority URL")
//            return
//        }
//        let authority = try MSALAADAuthority(url: authorityURL)
//        let msalConfiguration = MSALPublicClientApplicationConfig(clientId:kClientID,redirectUri: kRedirectUri,authority: authority)
//        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
//        self.initWebViewParams(vc: vc)
//    }
    
//    func initWebViewParams(vc:UIViewController) {
//        self.webViewParamaters = MSALWebviewParameters(authPresentationViewController: vc)
//    }
}
