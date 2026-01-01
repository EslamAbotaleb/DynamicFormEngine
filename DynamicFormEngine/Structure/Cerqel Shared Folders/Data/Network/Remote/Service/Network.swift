//

//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
//
public import Promises

public typealias UploadProgrssCallBack = ((Double,FileVersionType)->())
public typealias ProgressCallback = (Double) -> Void

public protocol Network {
    func call(endpoint: Endpoint) -> Promise<Data>
    func callModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint) -> Promise<Model>
    func uploadModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<Model>
    func downloadModel( filesUrl: [String]) -> Promise<URL>
    func cancelUpload(_ fileVersionType: FileVersionType) -> Void
    func uploadProfileUpdate(payload: [ProfileSections: Any], completion: @escaping ((Error?)->()))
}
