//
//  TenantListEntity.swift
//  CERQEL
//
//  Created by Youxel on 15/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
struct TenantListEntity: Codable{
        var tenantID, tenantName: String?
        var isSelected: Bool?
        var isPrimary: Bool?
        var themeID, themeNameEn, themeNameAr: String?
        var isDefaultTheme: Bool?
        var markLogoAttachment: TenantAttachment?
        var fullLogoAttachment: TenantAttachment?
    var colors: PlatformsColor?
}
