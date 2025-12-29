//
//  GetAllCategoriesUseCase.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 26/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import Promises
import DynamicFormEngine

protocol GetAllCategoriesUseCase {
    func execute() -> Promise<BaseResponse<[GetAllCategoriesEntity]>>
}


class GetAllCategoriesUseCaseImpl: GetAllCategoriesUseCase {
    
    private let repository: ServicesRepo
    private let mapper: any EntityMapper
    
    init(repository: ServicesRepo = ServicesRepoImpl(), mapper: any EntityMapper = GetAllCategoriesMapper()) {
        self.repository = repository
        self.mapper = mapper
    }
    
    func execute() -> Promises.Promise<BaseResponse<[GetAllCategoriesEntity]>> {
        return Promise<BaseResponse<[GetAllCategoriesEntity]>> { fulfill, reject in
            self.repository.getAllCategories().then { response in
                
                let serviceCategories = response.result.data
                let mappedEntities = self.mapCategories(serviceCategories: serviceCategories)
                let result = Result(totalCount: response.result.totalCount, data: mappedEntities, pagesCount: response.result.pagesCount)
                let baseResponse = BaseResponse(message: response.message, result: result)
                fulfill(baseResponse)
            }.catch { error in
                reject (error)
            }
            
        }
    }
    
    
    func mapCategories(serviceCategories: [GetAllCategoriesDTO]) -> [GetAllCategoriesEntity] {
        return serviceCategories.compactMap { categoriesResponse in
            if let entityMapper = mapper as? GetAllCategoriesMapper {
                return entityMapper.map(from: categoriesResponse)
            } else {
                return nil
            }
        }
        
    }
}
