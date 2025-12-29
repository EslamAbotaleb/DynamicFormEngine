//
//  ServicesRepo.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 26/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import Promises
import DynamicFormEngine

protocol ServicesRepo {
    func getAllCategories() -> Promise<BaseResponse<[GetAllCategoriesDTO]>>
    func allServices(cerqelFilterPayload: CerqelFilterPayload ) -> Promise<BaseResponse<AllServicesDataDTO>>
    func addRemoveServicesFav(addToFavouritePayload: AddToFavouritePayload) -> Promise<BaseSuccessResponse>
}
