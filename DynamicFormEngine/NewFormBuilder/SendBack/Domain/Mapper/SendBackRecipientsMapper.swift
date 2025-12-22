//
//  SendBackRecipientsMapper.swift
//  CERQEL
//
//  Created by Youxel on 28/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
class SendBackRecipientsMapper: EntityMapper{
    

    typealias DTO = SendBackRecipientsDTO
    typealias Entity = ListModel

    func map(from dto: SendBackRecipientsDTO) -> ListModel {
        return ListModel(id: dto.key, name: dto.value, nameEn:dto.value,nameAr: dto.value,isSelected: false)
    }
}
