//
//  TokenManager.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation
import UIKit
import CommonCrypto
import SwiftUI

class TokenManager {
    static var shared = TokenManager()

    private var pendingRequests = [(() -> Void)]()
    private var isRefreshTokenInProgress = DynamicObjects(false)
    private let lockQueue = DispatchQueue(label: "com.tokenManager.lock") // Serial queue for thread safety

    func resetPendingTasks() {
        pendingRequests.removeAll()
    }
    
    func refreshToken(completion: @escaping () -> Void) {
           lockQueue.sync {
            guard !isRefreshTokenInProgress.value else {
                pendingRequests.append(completion)
                return
            }

            isRefreshTokenInProgress.value = true

        }


        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let verifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")

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

        let auth0domain = "\(cerqel_Environment.Api_Base_URL)identityserver/"
        let authorizeURL = "\(auth0domain)\(cerqel_Environment.authConfigAuthorizationUri)"
        let tokenURL = "\(auth0domain)\(cerqel_Environment.EnvironmentConfig.authConfigTokenUri)"
        let clientId = cerqel_Environment.loginClientId
        let code_challenge = challenge

        let OAuth2Client = OAuth2ClientDynamicForm(configuration: OAuth2Configuration(clientId: clientId, authURL: authorizeURL, tokenURL: tokenURL, scope: "email profile roles cerqel-ios  offline_access", redirectURL: cerqel_Environment.authConfigRedirectionUri, responseType: "code", code_challenge: code_challenge, codeVerifier: verifier))

    }

}

