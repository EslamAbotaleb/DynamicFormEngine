//
//  BaseRepo.swift
//  CERQEL
//
//  Created by ahmed maher on 14/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
internal import Promises

public enum EndPointServiceCerqel {
    case categories
    case subCategories(categroyId: String)
    case fileTypes
    case degreeLvlList
    case relationList
    case linksList
}


protocol BaseRepo {
    func categories() -> Promise<BaseResponse<[ListModel]>>
    func subCategories(categoryId: String)  -> Promise<BaseResponse<[ListModel]>>
    func fileTypes() -> Promise<BaseResponse<[ListModel]>>
    func degreeLvlList() -> Promise<BaseResponse<[ListModel]>>
    func relationList() -> Promise<BaseResponse<[ListModel]>>
    func linksList() -> Promise<BaseResponse<[ListModel]>>
}

extension BaseRepo {
    public func degreeLvlList() -> Promise<BaseResponse<[ListModel]>> {
        return Promise<BaseResponse<[ListModel]>>(on: .global()) { fulfill, reject in }
    }

    public func fileTypes() -> Promise<BaseResponse<[ListModel]>> {
        return Promise<BaseResponse<[ListModel]>>(on: .global()) { fulfill, reject in }
    }
    
    public func relationList() -> Promise<BaseResponse<[ListModel]>> {
        return Promise<BaseResponse<[ListModel]>>(on: .global()) { fulfill, reject in }
    }
    
    public func linksList() -> Promise<BaseResponse<[ListModel]>> {
        return Promise<BaseResponse<[ListModel]>>(on: .global()) { fulfill, reject in }
    }
}


