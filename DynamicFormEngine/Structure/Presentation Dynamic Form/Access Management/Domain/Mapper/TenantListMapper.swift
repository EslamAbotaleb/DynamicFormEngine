//
//  TenantListMapper.swift
//  CERQEL
//
//  Created by Youxel on 15/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
class TenantListMapper: EntityMapper {
 
    typealias DTO = TenantListDTO
    typealias Entity = TenantListEntity
    
    func map(from dto: TenantListDTO) -> TenantListEntity{
        return TenantListEntity(tenantID: dto.tenantId, tenantName: dto.tenantName, isPrimary: dto.isPrimary, themeID: dto.themeId, themeNameEn: dto.themeNameEn, themeNameAr: dto.themeNameAr, isDefaultTheme: dto.isDefaultTheme, markLogoAttachment: dto.markLogoAttachment, fullLogoAttachment: dto.fullLogoAttachment, colors: dto.colors)
    }
    
}
