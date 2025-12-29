//
//  ServicesRepoImpl.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 26/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import Promises

class ServicesRepoImpl: ServicesRepo, BaseRepo {

    private var network: Network
    private var localData: LocalData

    init(network: Network = NetworkServiceImpl(), localData: LocalData = LocalDataImpl()) {
        self.network = network
        self.localData = localData
    }

    func getAllCategories() -> Promises.Promise<BaseResponse<[GetAllCategoriesDTO]>> {
        return self.network.callModel(BaseResponse<[GetAllCategoriesDTO]>.self, endpoint: GetServicesCategoriesEndPoint())
    }

    func allServices(cerqelFilterPayload: CerqelFilterPayload) -> Promises.Promise<BaseResponse<AllServicesDataDTO>> {
        return self.network.callModel(BaseResponse<AllServicesDataDTO>.self, endpoint: AllServicesEndPoint(cerqelFilterPayload: cerqelFilterPayload ))
    }

    func addRemoveServicesFav(addToFavouritePayload: AddToFavouritePayload) -> Promise<BaseSuccessResponse> {
        return self.network.callModel(BaseSuccessResponse.self, endpoint: AddServiceToFavouriteEndPoint(addToFavouritePayload: addToFavouritePayload))
    }


    func categories() -> Promise<BaseResponse<[ListModel]>> {
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: GetAllParentCategoriesEndpoint())
    }
    func subCategories(categoryId: String) -> Promise<BaseResponse<[ListModel]>> {
        return self.network.callModel(BaseResponse<[ListModel]>.self, endpoint: GetSubCategoryByParentIdEndPoint(parentCategoryId: categoryId))
    }
}
