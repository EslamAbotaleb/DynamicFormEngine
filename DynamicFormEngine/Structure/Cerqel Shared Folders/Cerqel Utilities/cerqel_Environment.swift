//
//  Environment.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

public enum cerqel_Environment {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let API_Base_URL = "API_Base_URL"
            static let loginClientId = "client_id"
            static let authConfigRedirectionUri = "Auth_Config_Redirection_Uri"
            static let authConfigAuthorizationUri = "Auth_Config_Authorization_Uri"
            static let authConfigTokenUri = "Auth_Config_Token_Uri"
            static let loginClientSecret = "client_secret"
            static let loginIV = "iv"
            static let Share_Link_URL = "Share_Link_URL"
            static let encryptionKey = "encryptionKey"
            static let CONTENT_Base_URL = "CONTENT_Base_URL"
            static let Self_Service_URL = "Self_Service_URL"
            static let User_Manager_URL = "User_Manager_URL"
            static let Notification_Base_URL = "Notification_Base_URL"
            static let FileManager_Base_URL = "FileManager_Base_URL"
            static let Mocking_Base_URL = "Mocking_Base_URL"
            static let appCenterKey = "appCenterKey"
            static let Search_Base_URL = "Search_Base_URL"

            static let notificationHubNamespace = "notificationHubNamespace"
            static let notificationHubName = "notificationHubName"
            static let notificationHubKeyName = "notificationHubKeyName"
            static let notificationHubKey = "notificationHubKey"
        }
        
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let Api_Base_URL: String = {
        guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.API_Base_URL] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return apiKey
    }()
        
    static let loginClientId: String = {
        guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.loginClientId] as? String else {
            fatalError("loginClientId Key not set in plist for this environment")
        }
        return apiKey
    }()
    
    static let authConfigRedirectionUri: String = {
        guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.authConfigRedirectionUri] as? String else {
            fatalError("authConfigRedirectionUri Key not set in plist for this environment")
        }
        return apiKey
    }()
    
    static let authConfigAuthorizationUri: String = {
        guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.authConfigAuthorizationUri] as? String else {
            fatalError("authConfigAuthorizationUri Key not set in plist for this environment")
        }
        return apiKey
    }()

    struct EnvironmentConfig {
        static let authConfigTokenUri: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.authConfigTokenUri] as? String else {
                fatalError("authConfigTokenUri Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let loginClientSecret: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.loginClientSecret] as? String else {
                fatalError("loginClientSecret Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let loginIV: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.loginIV] as? String else {
                fatalError("IV Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let encryptionKey: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.encryptionKey] as? String else {
                fatalError("encryptionKey Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let CONTENT_Base_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.CONTENT_Base_URL] as? String else {
                fatalError("CONTENT_Base_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let Search_Base_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Search_Base_URL] as? String else {
                fatalError("Search_Base_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let Self_Service_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Self_Service_URL] as? String else {
                fatalError("Self_Service_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let User_Manager_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.User_Manager_URL] as? String else {
                fatalError("User_Manager_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let Notification_Base_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Notification_Base_URL] as? String else {
                fatalError("Notification_Base_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let FileManager_Base_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.FileManager_Base_URL] as? String else {
                fatalError("FileManager_Base_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let Mocking_Base_URL: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Mocking_Base_URL] as? String else {
                fatalError("Mocking_Base_URL Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let appCenterKey: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.appCenterKey] as? String else {
                fatalError("appCenterKey Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let notificationHubNamespace: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubNamespace] as? String else {
                fatalError("notificationHubNamespace Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let notificationHubName: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubName] as? String else {
                fatalError("notificationHubName Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let notificationHubKeyName: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubKeyName] as? String else {
                fatalError("notificationHubKeyName Key not set in plist for this environment")
            }
            return apiKey
        }()

        static let notificationHubKey: String = {
            guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubKey] as? String else {
                fatalError("notificationHubKey Key not set in plist for this environment")
            }
            return apiKey
        }()
    }


//    let authConfigTokenUri: String = {
//        guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.authConfigTokenUri] as? String else {
//            fatalError("authConfigTokenUri Key not set in plist for this environment")
//
//            let loginClientSecret: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.loginClientSecret] as? String else {
//                    fatalError("loginClientSecret Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//            let loginIV: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.loginIV] as? String else {
//                    fatalError("IV Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//            let encryptionKey: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.encryptionKey] as? String else {
//                    fatalError("encryptionKey Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let CONTENT_Base_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.CONTENT_Base_URL] as? String else {
//                    fatalError("CONTENT_Base_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let Search_Base_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Search_Base_URL] as? String else {
//                    fatalError("Search_Base_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let Self_Service_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Self_Service_URL] as? String else {
//                    fatalError("Self_Service_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let User_Manager_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.User_Manager_URL] as? String else {
//                    fatalError("User_Manager_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let Notification_Base_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Notification_Base_URL] as? String else {
//                    fatalError("Notification_Base_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let FileManager_Base_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.FileManager_Base_URL] as? String else {
//                    fatalError("FileManager_Base_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let Mocking_Base_URL: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.Mocking_Base_URL] as? String else {
//                    fatalError("Mocking_Base_URL Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//            let appCenterKey: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.appCenterKey] as? String else {
//                    fatalError("appCenterKey Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//            let notificationHubNamespace: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubNamespace] as? String else {
//                    fatalError("notificationHubNamespace Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//            let notificationHubName: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubName] as? String else {
//                    fatalError("notificationHubName Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//            let notificationHubKeyName: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubKeyName] as? String else {
//                    fatalError("notificationHubKeyName Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//            let notificationHubKey: String = {
//                guard let apiKey = cerqel_Environment.infoDictionary[Keys.Plist.notificationHubKey] as? String else {
//                    fatalError("notificationHubKey Key not set in plist for this environment")
//                }
//                return apiKey
//            }()
//
//        }
//      }
    }
