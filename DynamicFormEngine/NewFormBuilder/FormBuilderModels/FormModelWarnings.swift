//
//  FormModelWarnings.swift
//  CHECK
//
//  Created by Yasser Osama on 21/09/2022.
//

import ObjectMapper

struct Warning: Mappable, Codable {
    var formWarning: FormWarning?
    var localization: localizationLanguages?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        formWarning <- map["formWarning"]
        localization <- map["localization"]
    }
    
    enum CodingKeys: String, CodingKey {
        case formWarning, localization
    }
}

struct localizationLanguages: Mappable, Codable {
    var en: FormWarning?
    var ar: FormWarning?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        en <- map["en"]
        ar <- map["ar"]
    }
    
    enum CodingKeys: String, CodingKey {
        case en, ar
    }

}

struct FormWarning: Mappable, Codable {
    var formValidation: FormValidation?
    var fieldValidation: FieldValidation?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        formValidation <- map["formValidation"]
        fieldValidation <- map["fieldValidation"]
    }
    
    enum CodingKeys: String, CodingKey {
        case formValidation, fieldValidation
    }
}

struct FormValidation: Mappable, Codable {
    var expired: String?
    var notAvailable: String?
    var multipleSubmission: String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        expired <- map["expired"]
        notAvailable <- map["notAvailable"]
        multipleSubmission <- map["multipleSubmission"]
    }
    
    enum CodingKeys: String, CodingKey {
        case expired, notAvailable, multipleSubmission
    }
}


struct InternalRuleValidation: Mappable {
    var unique: String?
    
    init?(map: Map) {
        // empty
    }
    
    mutating func mapping(map: Map) {
        unique <- map["unique"]
    }
}


struct InternalFieldValidation: Mappable {
    var required: String?
    var minimumNumberOfSelectedOptions: String?
    var maximumNumberOfSelectedOptions: String?
    var minimumCharacterLength: String?
    var maximumCharacterLength: String?
    var minimumWordLength: String?
    var maximumWordLength: String?
    var email: String?
    var url: String?
    var numeric: String?
    var alphabetic: String?
    var alphanumeric: String?
    var custom: String?
    var minimumValue: String?
    var maximumValue: String?
    var minimumDigits: String?
    var maximumDigits: String?
    var dateTime: String?
    var maxAttachment: String?
    var minimumDate:String?
    var maximumDate:String?
    var minimumTime:String?
    var maximumTime:String?
    var allowedDaysRange:String?
    var minRows:String?
    var maxRows:String?
    var maxAttachmentSize:String?
    var attachmentType:String?
    var attachmentExtensions:String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        required <- map["required"]
        minimumNumberOfSelectedOptions <- map["minimumNumberOfSelectedOptions"]
        maximumNumberOfSelectedOptions <- map["maximumNumberOfSelectedOptions"]
        minimumCharacterLength <- map["minimumCharacterLength"]
        maximumCharacterLength <- map["maximumCharacterLength"]
        minimumWordLength <- map["minimumWordLength"]
        maximumWordLength <- map["maximumWordLength"]
        email <- map["email"]
        url <- map["url"]
        numeric <- map["numeric"]
        alphabetic <- map["alphabetic"]
        alphanumeric <- map["alphanumeric"]
        custom <- map["custom"]
        minimumValue <- map["minimumValue"]
        maximumValue <- map["maximumValue"]
        minimumDigits <- map["minimumDigits"]
        maximumDigits <- map["maximumDigits"]
        dateTime <- map["dateTime"]
        maxAttachment <- map["maxAttachmentNumber"]
        minRows <- map["minRows"]
        maxRows <- map["maxRows"]
        maxAttachmentSize <- map["maxAttachmentSize"]
        attachmentType <- map["attachmentType"]
        attachmentExtensions <- map["attachmentExtensions"]
        allowedDaysRange <- map["allowedDaysRange"]
        minimumDate <- map["minimumDate"]
        maximumDate <- map["maximumDate"]
        minimumTime <- map["minimumTime"]
        maximumTime <- map["maximumTime"]
        allowedDaysRange <- map["allowedDaysRange"]


    }
}

struct FieldValidation: Mappable, Codable {
    var fileUpload: FileUploadValidation?
    var table: TableValidation?
    var input: InputValidation?
    var number: NumberValidation?
    var dateTime: dateTimeValidation?
    var mcq: MCQValidation?
    var required: String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        fileUpload <- map["fileUpload"]
        table <- map["table"]
        input <- map["input"]
        number <- map["number"]
        dateTime <- map["dateTime"]
        mcq <- map["mcq"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case fileUpload, table, input, number, dateTime, mcq, required
    }
}

struct FileUploadValidation: Mappable, Codable {
    var maxAttachmentNumber: String?
    var maxAttachmentSize: String?
    var attachmentType: String?
    var attachmentExtensions: String?
    var required: String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        maxAttachmentNumber <- map["maxAttachmentNumber"]
        maxAttachmentSize <- map["maxAttachmentSize"]
        attachmentType <- map["attachmentType"]
        attachmentExtensions <- map["attachmentExtensions"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case maxAttachmentNumber, maxAttachmentSize, attachmentType, attachmentExtensions, required
    }
}

struct TableValidation: Mappable, Codable {
    var minRows: String?
    var maxRows: String?
    var required: String?
    
    init?(map: Map) {
        //empty
    }

    mutating func mapping(map: Map) {
        minRows <- map["minRows"]
        maxRows <- map["maxRows"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case minRows, maxRows, required
    }
}

struct InputValidation: Mappable, Codable {
    var minimumCharacterLength: String?
    var maximumCharacterLength: String?
    var minimumWordLength: String?
    var maximumWordLength: String?
    var email: String?
    var url: String?
    var numeric: String?
    var alphabetic: String?
    var alphanumeric: String?
    var custom: String?
    var required: String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        minimumCharacterLength <- map["minimumCharacterLength"]
        maximumCharacterLength <- map["maximumCharacterLength"]
        minimumWordLength <- map["minimumWordLength"]
        maximumWordLength <- map["maximumWordLength"]
        email <- map["email"]
        url <- map["url"]
        numeric <- map["numeric"]
        alphabetic <- map["alphabetic"]
        alphanumeric <- map["alphanumeric"]
        custom <- map["custom"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case minimumCharacterLength, maximumCharacterLength, minimumWordLength, maximumWordLength, email, url, numeric, alphabetic, alphanumeric, custom, required
    }

}

struct NumberValidation: Mappable, Codable {
    var minimumValue: String?
    var maximumValue: String?
    var minimumDigits: String?
    var maximumDigits: String?
    var required: String?

    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        minimumValue <- map["minimumValue"]
        maximumValue <- map["maximumValue"]
        minimumDigits <- map["minimumDigits"]
        maximumDigits <- map["maximumDigits"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case minimumValue, maximumValue, minimumDigits, maximumDigits, required
    }
}

struct dateTimeValidation: Mappable, Codable {
    var minimumDate:String?
    var maximumDate:String?
    var minimumTime:String?
    var maximumTime:String?
    var allowedDaysRange:String?
    var required:String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        minimumDate <- map["minimumDate"]
        maximumDate <- map["maximumDate"]
        minimumTime <- map["minimumTime"]
        maximumTime <- map["maximumTime"]
        allowedDaysRange <- map["allowedDaysRange"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case minimumDate, maximumDate, minimumTime, maximumTime, allowedDaysRange, required
    }

}

struct MCQValidation: Mappable, Codable {
    var minimumNumberOfSelectedOptions: String?
    var maximumNumberOfSelectedOptions: String?
    var required: String?
    
    init?(map: Map) {
        //empty
    }
    
    mutating func mapping(map: Map) {
        minimumNumberOfSelectedOptions <- map["minimumNumberOfSelectedOptions"]
        maximumNumberOfSelectedOptions <- map["maximumNumberOfSelectedOptions"]
        required <- map["required"]
    }
    
    enum CodingKeys: String, CodingKey {
        case minimumNumberOfSelectedOptions, maximumNumberOfSelectedOptions, required
    }

}

enum FormValidationType {
    case expired, notAvailable, multipleSubmission
}

public enum FieldValidationType {
    case required, maxAttachment,minimumDate,maximumDate,minimumTime,maximumTime,allowedDaysRange, dateTime, minimumCharacterLength, maximumCharacterLength, minimumWordLength, maximumWordLength, email, url, numeric, alphabetic, alphanumeric, custom, minimumValue, maximumValue, minimumDigits, maximumDigits, minimumNumberOfSelectedOptions, maximumNumberOfSelectedOptions,minRows,maxRows,maxAttachmentNumber,maxAttachmentSize,attachmentType,attachmentExtensions
}

enum FieldValidationRequiredType {
    case fileUpload, table, input, number, dateTime, mcq
}





