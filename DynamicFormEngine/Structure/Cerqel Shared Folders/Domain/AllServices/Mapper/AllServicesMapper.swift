//
//  AllServicesMapper.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

class AllServicesMapper: EntityMapper {
    typealias DTO = AllServicesDataDTO
    typealias Entity = AllServicesDataEntity
    
    func map(from dto: AllServicesDataDTO) -> AllServicesDataEntity {
        return AllServicesDataEntity(services: dto.services, highlightedFilters: dto.highlightedFilters)
    }
    
}
