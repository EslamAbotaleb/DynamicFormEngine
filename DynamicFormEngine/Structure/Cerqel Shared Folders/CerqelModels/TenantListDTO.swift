//
//  TenantListDTO.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation

struct TenantListDTO : Codable {
    var tenantId : String? = ""
    var tenantName : String? = ""
    var tenantLogo: String? = ""
    var isPrimary : Bool? = false
    var themeId : String? = ""
    var themeNameEn: String? = ""
    var themeNameAr: String? = ""
    var isDefaultTheme: Bool? = false
    var markLogoAttachment: TenantAttachment? = TenantAttachment()
    var fullLogoAttachment: TenantAttachment? = TenantAttachment()
    var colors: PlatformsColor? = nil
    var isSelected: Bool? = false

    enum CodingKeys: String, CodingKey {


        case tenantId = "tenantId"
        case tenantName = "tenantName"
        case tenantLogo = "tenantLogo"
        case isPrimary = "isPrimary"
        case themeId = "themeId"
        case themeNameEn = "themeNameEn"
        case themeNameAr = "themeNameAr"
        case isDefaultTheme = "isDefaultTheme"
        case markLogoAttachment = "markLogoAttachment"
        case fullLogoAttachment = "fullLogoAttachment"
        case colors = "colors"
        case isSelected
    }
    init(tenantId: String = "", tenantName: String = "",tenantLogo: String = "", isSelected: Bool? ) {
        self.tenantId = tenantId
        self.tenantName = tenantName
        self.tenantLogo = tenantLogo
        self.isSelected = isSelected
    }

}

// MARK: - Attachment
struct TenantAttachment: Codable {
    var attachmentExtension, uploadID, name: String?
    var size: Double?
    var type: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case attachmentExtension = "extension"
        case uploadID = "uploadId"
        case name, size, type, url
    }
}
