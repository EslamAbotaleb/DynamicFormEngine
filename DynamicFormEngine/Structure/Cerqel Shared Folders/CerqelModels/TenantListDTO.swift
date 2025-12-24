//
//  TenantListDTO.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import Foundation

public struct TenantListDTO : Codable {
    public var tenantId : String? = ""
    public var tenantName : String? = ""
    public var tenantLogo: String? = ""
    public var isPrimary : Bool? = false
    public var themeId : String? = ""
    public var themeNameEn: String? = ""
    public var themeNameAr: String? = ""
    public var isDefaultTheme: Bool? = false
    public var markLogoAttachment: TenantAttachment? = TenantAttachment()
    public var fullLogoAttachment: TenantAttachment? = TenantAttachment()
    public var colors: PlatformsColor? = nil
    public var isSelected: Bool? = false

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
    public init(tenantId: String = "", tenantName: String = "",tenantLogo: String = "", isSelected: Bool? ) {
        self.tenantId = tenantId
        self.tenantName = tenantName
        self.tenantLogo = tenantLogo
        self.isSelected = isSelected
    }

}

// MARK: - Attachment
public struct TenantAttachment: Codable {
    public var attachmentExtension, uploadID, name: String?
    public var size: Double?
    public var type: String?
    public var url: String?

    enum CodingKeys: String, CodingKey {
        case attachmentExtension = "extension"
        case uploadID = "uploadId"
        case name, size, type, url
    }
}
