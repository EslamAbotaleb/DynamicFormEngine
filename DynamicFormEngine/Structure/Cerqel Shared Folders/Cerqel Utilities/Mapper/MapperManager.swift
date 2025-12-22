//
//  MapperManager.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation

protocol EntityMapper {
    associatedtype DTO
    associatedtype Entity
    func map (from dto: DTO) -> Entity
}
