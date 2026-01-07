//
//  LoginCerqelVC.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 02/10/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
import CommonCrypto

class LoginCerqelVC: BaseWireFrame<LoginViewModel> {
    
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var youxelImage: UIImageView!
    override func configure(with viewModel: LoginViewModel) {
        print("DONE")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "  Welcome to YOUXEL ! We’re glad you’re here.".localized
        getStartedBtn.setTitle("Let's Get Started".localized, for: .normal)
        configureUI()
    }
    
    
    func authCerqel() {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let verifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        // 2. and from this generates a code_challenge.
        let data = verifier.data(using: .utf8)
        var buffer2 = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = data?.withUnsafeBytes {
            CC_SHA256($0.baseAddress, CC_LONG(data?.count ?? 0), &buffer2)
        }
        let hash = Data(buffer2)
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        let auth0domain = "\(cerqel_Environment.Base_Url_Without_Http)identityserver/oauth2"
        let authorizeURL = "\(cerqel_Environment.Base_Url_Format)\(auth0domain)/authorize"
        let tokenURL = "\(cerqel_Environment.Base_Url_Format)\(auth0domain)/token"
        let clientId = "1dcbf44d-867d-4c19-b9f1-7bc7370c534b"
        let code_challenge = challenge
        if let app = UIApplication.shared.delegate as? AppDelegate {
            app.auth = OAuth2Client(configuration: OAuth2Configuration(clientId: clientId, authURL: authorizeURL, tokenURL: tokenURL, scope: "email profile roles cerqel-web cerqel-ios openid offline_access", redirectURL: "Cerqel://authorize", responseType: "code",code_challenge:code_challenge,codeVerifier: verifier))
            app.auth.authorize(from: self)
            app.auth.clientIsLoadingToken = {
                
            }
            app.auth.clientDidFinishLoadingToken = {
                registerToOurBE.shared.register()
                //go to Home
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.goToSideMenu()
            }
            app.auth.clientDidFailLoadingToken = { error in
                let _ = (error as? OAuth2Error)?.localizedDescription
            }
        }
    }
    
    
    @IBAction func loginSSOTapped(_ sender: Any) {
        authCerqel()
    }
}

extension LoginCerqelVC {
    private func configureUI() {
        getStartedBtn.backgroundColor = primaryMain
    }
}
