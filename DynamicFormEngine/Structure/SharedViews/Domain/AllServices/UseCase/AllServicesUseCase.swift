//
//  AllServicesUseCase.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 28/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import Promises
import DynamicFormEngine

protocol AllServicesUseCase {
    
    func execute(payload: CerqelFilterPayload) -> Promise<BaseResponse<AllServicesDataEntity>>
    func addRemoveServicesFav(addToFavouritePayload: AddToFavouritePayload) -> Promise<Bool>


}

// swiftlint:disable all
class AllServicesUseCaseImpl: AllServicesUseCase {

    private let repository: ServicesRepo
    private let mapper: any EntityMapper
    
    init(repository: ServicesRepo = ServicesRepoImpl(), mapper: any EntityMapper = AllServicesMapper()) {
        self.repository = repository
        self.mapper = mapper
    }
    func execute(payload: CerqelFilterPayload) -> Promise<BaseResponse<AllServicesDataEntity>> {
        
        return Promise<BaseResponse<AllServicesDataEntity>> { fulfill, reject in
            self.repository.allServices(cerqelFilterPayload: payload).then { response in
                let serviceBase = response.result.data
                let entityMapper = self.mapper as! AllServicesMapper
                let entity = entityMapper.map(from: serviceBase)
                let result = Result(totalCount: response.result.totalCount, data: entity, pagesCount: response.result.pagesCount)
                let baseResponse = BaseResponse(message: response.message, result: result)
                fulfill(baseResponse)
            }.catch { error in
                reject (error)
            }
        }
    }
    // swiftlint:enable all
    func addRemoveServicesFav(addToFavouritePayload: AddToFavouritePayload) -> Promises.Promise<Bool> {
        return Promise<Bool> { fulfill, reject in
            self.repository.addRemoveServicesFav(addToFavouritePayload: addToFavouritePayload).then { response in
                let success = response.success
                fulfill(success ?? false)
            }.catch { error in
                reject (error)
            }
        }
    }
  
    

}
