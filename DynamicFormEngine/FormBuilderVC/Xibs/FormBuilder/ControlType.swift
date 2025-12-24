//
//  ControlType.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import Foundation

public enum ControlType: String, Codable {
    case TextBox
    case RadioButton
    case DropDown
    case paragraph
    case TextArea
    case FileUpload
    case customComponent
    case Label
    case DatePicker
    case DateRangePicker
    case TimePicker
    case DateTimePicker
    case InfoIndicator
    case Switch
    case Link
    case CheckBox
    case DateTimeRangePicker
    case table
    case Search
}


public enum ValidationName: String, Codable {
    case valueRequired
    case required
    case pattern
    case minlength
    case maxlength
    case min
    case max
    case dateRangeFrom_required = "dateRangeFrom-required"
    case dateRangeTo_required = "dateRangeTo-required"
    case dateFrom_required = "dateFrom-required"
    case dateTo_required = "dateTo-required"
    case timeFrom_required = "timeFrom-required"
    case timeTo_required = "timeTo-required"
    case minRows
    case maxRows
}


public enum ContentType: String, Codable{
    case multiSelect
    case number
    case empty = ""
}

public struct DateValidationObject : Codable {
    var key : String?
    var value : Int?
    var isMonth: Bool?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case value = "value"
        case isMonth = "isMonth"
    }
}
