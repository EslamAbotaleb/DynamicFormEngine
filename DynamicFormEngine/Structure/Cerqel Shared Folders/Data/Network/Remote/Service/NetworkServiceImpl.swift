//
//  NetworkServiceImpl.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import Promises
import Reachability
import SwiftyJSON
import CommonCrypto

public protocol EndpointExecuter {
    func execute(_ endpoint: Endpoint) -> Promise<NetworkServiceResponse>
    func cancelUpload(_ fileVersionType: FileVersionType) -> Void
    func uploadMultipart(_ endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<NetworkServiceResponse>
    func downloadFile(_ filesUrl: [String]) -> Promise<URL>
    func prepareJsonPayload(from payload: [ProfileSections: Any]) -> [String: Any]
    func prepareParameters(with jsonPayload: [String: Any]) -> [[String: Any]]
    func buildMultipartBody(parameters: [[String: Any]], boundary: String) throws -> Data
    func buildRequest(with body: Data, boundary: String) -> URLRequest
    func performRequest(_ request: URLRequest, completion: @escaping (BaseError?) -> Void)
}

public protocol ReachabilityProtocol {
    func connection() -> Reachability.Connection?
}

public class NetworkServiceImpl: Network {

    public var endpointExecuter: EndpointExecuter = AlamofireService()
    public var reachability: ReachabilityProtocol = ReachabilityImpl()

    public func callModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint) -> Promise<Model> {
        return Promise<Model>(on: .main) { fulfill, reject in
            self.call(endpoint: endpoint)
                .then({ (data) in
                    do {
                        //  print("Response Data 🤪🤪🤪🤪  \(JSON(data))")
                        let obj = try JSONDecoder().decode(Model.self, from: data)
                        fulfill(obj)
                    } catch let jsonError {
                        print("JsonSerlization Error 😱😱😱😱😱 \(jsonError.localizedDescription)")
                        reject(FailToMapResponseError(data: data))
                    }

                })
                .catch({ (error) in
                    if let error  = error as? ServerError, error.status == 401 {
                        guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
                        guard !AuthManager.shared.token.isEmpty else {
                            reject(error)
                            return
                        }
                            TokenManager.shared.refreshToken {
                                // Retry the request after token refresh
                                self.callModel(model, endpoint: endpoint)
                                                            .then(fulfill)
                                                            .catch(reject)
                        }
                    }
                    else {
                        reject(error)
                    }
                })
        }
    }



    public func uploadModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<Model> {
        return Promise<Model>(on: .main) { fulfill, reject in
            self.upload(endpoint: endpoint, progressCallBack: progressCallBack)
                .then({ (data) in
                    guard let response = try? JSONDecoder().decode(Model.self, from: data) else {
                        reject(FailToMapResponseError(data: data))
                        return
                    }
                    print("🎉🎉 After Codable : \(response)")
                    fulfill(response)})
                .catch({ (error) in
                    if let error  = error as? ServerError, error.status == 401 {
                        guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
                            TokenManager.shared.refreshToken {
                                // Retry the request after token refresh
                                self.uploadModel(model, endpoint: endpoint, progressCallBack: progressCallBack)
                                                            .then(fulfill)
                                                            .catch(reject)

                        }
                    }
                    else {
                        reject(error)
                    }

                })
        }
    }

    public func downloadModel( filesUrl: [String]) -> Promise<URL> {
        return Promise<URL>(on: .main) { fulfill, reject in
            self.download(filesUrl)
                .then({ (fileUrl) in
                    fulfill(fileUrl)})
                .catch({ (error) in
                    if let error  = error as? ServerError, error.status == 401 {
                        guard !(AuthManager.shared.unauthorizedFlag.value ?? false) else { return }
                            TokenManager.shared.refreshToken {
                                // Retry the request after token refresh
                                self.downloadModel(filesUrl: filesUrl)
                                                            .then(fulfill)
                                                            .catch(reject)

                        }
                    }
                    else {
                        reject(error)
                    }


                })
        }
    }

    public func call(endpoint: Endpoint) -> Promise<Data> {
        return Promise<Data>(on: .main) { fulfill, reject in
            self.endpointExecuter.execute(endpoint)
                .then({ (response) in
                    self.networkSuccess(data: response.data, statusCode: response.statusCode).then({ (data) in
                        let header = response.headers as? [String: Any]
                        let jsonData = try JSONSerialization.data(withJSONObject: header, options: [])
                        let decoder = JSONDecoder()
                        let headerResponse = try decoder.decode(HeaderResponse.self, from: jsonData)
                        fulfill(data)
                    }).catch({ (error) in
                         reject(error)
                    })
                })
                .catch({ (error) in

                    if error is ServerError {
                        reject(error)
                    }
                    else {
                        reject(self.networkFail())
                    }
                })
        }
    }

    private func upload(endpoint: Endpoint,progressCallBack: @escaping UploadProgrssCallBack) -> Promise<Data> {
        return Promise<Data>(on: .main) { fulfill, reject in
            self.endpointExecuter.uploadMultipart(endpoint, progressCallBack: progressCallBack)
                .then({ (response) in
                    self.networkSuccess(data: response.data, statusCode: response.statusCode).then({ (data) in
                        fulfill(data)
                    }).catch({ (error) in
                        reject(error)
                    })
                }).catch({ _ in
                    reject(self.networkFail())
                })
        }
    }

    private func download(_ filesUrl: [String]) -> Promise<URL> {
        return Promise<URL>(on: .main) { fulfill, reject in
            self.endpointExecuter.downloadFile(filesUrl)
                .then({ (response) in

                    fulfill(response)
                }).catch({ error in
                    reject(self.networkFail())
                })


        }
    }

    public func cancelUpload(_ fileVersionType: FileVersionType) {
        self.endpointExecuter.cancelUpload(fileVersionType)
    }
    
    public func uploadProfileUpdate(
        payload: [ProfileSections: Any],
        completion: @escaping (Error?) -> Void
    ) {
        do {
            let jsonPayload = endpointExecuter.prepareJsonPayload(from: payload)
            let parameters = endpointExecuter.prepareParameters(with: jsonPayload)
            let boundary = "Boundary-\(UUID().uuidString)"
            let body = try endpointExecuter.buildMultipartBody(parameters: parameters, boundary: boundary)
            let request = endpointExecuter.buildRequest(with: body, boundary: boundary)
            endpointExecuter.performRequest(request, completion: completion)
        } catch {
            completion(error)
        }
    }

    private func networkSuccess(data: Data, statusCode: Int?) -> Promise<Data> {
        return Promise<Data>(on: .main) { fulfill, reject in
            print("⬆️⬆️ Status Code : \(String(describing: statusCode ?? 0))")
            print("⬆️⬆️ Endpoint Respose : \(JSON(data))")

            if (200...299).contains(statusCode ?? 0) {
                fulfill(data)
            } else {
                guard let error = try? JSONDecoder().decode(ServerError.self, from: data) else {
                    if let statusCode = statusCode {
                        reject(ServerError(status: statusCode))
                    }
                    return
                }
                reject(error)
                if  statusCode == 401 {
                    AuthManager.shared.unauthorizedFlag.accept(true)
                }

            }
        }
    }

    private func saveHeaders( _ header: HeaderResponse) {
        UserAuthoriationHandler().setAuthManually(authToken: header.token ?? "")
        UserAuthoriationHandler().setUidManually(uid: header.uid ?? "")    }

    private func networkFail() -> Error {
        return isConnectedToInternet ? FailToCallNetworkError() : NoInternetConnectionError()
    }

    private var isConnectedToInternet: Bool {
        return reachability.connection() != Reachability.Connection.none
    }

    private func mapJsonToModel<Model: Codable>(_ model: Model.Type, from data: Data) -> Promise<Model>{
        return Promise<Model>(on: .main) { fulfill, reject in
            guard let response = try? JSONDecoder().decode(Model.self, from: data) else {
                return  reject(FailToMapResponseError(data: data))
            }
            return fulfill(response)
        }
    }

    public init() {}
}

public struct NetworkServiceResponse {
    public var data: Data
    public var statusCode: Int?
    public var headers: [AnyHashable: Any]?
}

public class ReachabilityImpl: ReachabilityProtocol {
    public func connection() -> Reachability.Connection? {
        return Reachability()?.connection
    }
}

public struct HeaderResponse: Codable {
    public var token: String?
    public var client: String?
    public var uid: String?

    enum CodingKeys: String, CodingKey {
        case token = "access-token"
        case client, uid
    }
}
