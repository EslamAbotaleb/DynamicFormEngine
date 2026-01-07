//
//  FormBuilder+ControlValidationExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 24/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

internal import Alamofire
internal import Expression
import Foundation

internal import RxCocoa
internal import RxSwift
import UIKit

extension FormBuilder {
    
    /// Handling control's entry limit
    /// - Parameters:
    ///   - entryLimit: control's entry limit type
    ///   - changedText: control's text
    ///   - item: current item
    ///   - row: control's fieldId
    /// - Returns: (shouldChange, countLabel, isError, errorMessage)
    public func handleEntryLimit(
        _ entryLimit: EntryLimit, changedText: String,
        item: FormViewModelTextBaseItem, row: String
    ) -> (
        shouldChange: Bool, countLabel: String, isError: Bool,
        errorMessage: String
    ) {
        var str = ""
        var isHidden = true
        var errorMessage = ""
        if entryLimit == .Character {
            let result = handleTextLimitLabel(current: changedText.count, fieldType: item.type ?? .TextBox, entryLimit: .Character, minLength: item.minimumLength, maxLength: item.maximumLength, item: item, changedText: changedText, row: row)
            str = result.countLabel
            isHidden = result.isError
            errorMessage = result.errorMessage
            if let maxLength = item.maximumLength {
                return (
                    changedText.count <= maxLength, str, isHidden, errorMessage
                )
            }
        } else if entryLimit == .Word {
            let spaces = CharacterSet.whitespacesAndNewlines.union(
                .punctuationCharacters)
            var words = changedText.components(separatedBy: spaces)
            if changedText == "" {
                words = []
            }
            let result = handleTextLimitLabel(current: words.count, fieldType: item.type ?? .TextBox, entryLimit: .Word, minLength: item.minimumLength, maxLength: item.maximumLength, item: item, changedText: changedText, row: row)
            str = result.countLabel
            isHidden = result.isError
            errorMessage = result.errorMessage
            if let maxLength = item.maximumLength {
                return (words.count <= maxLength, str, isHidden, errorMessage)
            }
        }
        return (true, str, isHidden, errorMessage)
    }
    
    
    /// Handleing text box control's validation
    /// - Parameters:
    ///   - value: control's value
    ///   - item: current control
    ///   - row: control's fieldId
    /// - Returns: (isError, errorMessage, errorType)
    public func handleTextboxValidation(
        value: String, item: FormViewModelTextBoxItem, row: String
    ) -> (isError: Bool, errorMessage: String, errorType: FieldValidationType?)
    {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?
        let regex = item.regex
        var minLength = item.minimumLength
        var maxLength = item.maximumLength

        if value.isEmpty, item.required {  // empty field and required
            isError = true
            validationType = .required
        } else if minLength != nil && maxLength != nil {  // min and max length exist
            if value.count < minLength! {
                isError = true
                validationType = .minimumCharacterLength
                validatorValue = minLength
            } else if value.count > maxLength! {
                isError = true
                validationType = .maximumCharacterLength
                validatorValue = maxLength
            } else if let regex = regex, !regex.isEmpty {
                if !value.isValidRegex(regex: regex) {
                    isError = true
                    setTextValidationType(
                        validationType: &validationType, item: item)
                }
            }
        } else if minLength != nil {  // only min length exists
            if value.count < minLength! {
                isError = true
                validationType = .minimumCharacterLength
                validatorValue = minLength
            }
        } else if maxLength != nil {  // only max length exists
            if value.count > maxLength! {
                isError = true
                validationType = .maximumCharacterLength
                validatorValue = maxLength
            }
        }
        else {
            if let regex = regex, !regex.isEmpty {
                if !value.isValidRegex(regex: regex) {
                    isError = true
                    setTextValidationType(
                        validationType: &validationType, item: item)
                }
            }
        }

        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .input) ?? ""
            }
        }
        return (isError, errorMessage, validationType)

    }
    
    
    /// Handleing text box (numeric) validations
    /// - Parameters:
    ///   - value: control's value
    ///   - item: current control
    ///   - row: control's fieldId
    /// - Returns: (isError, errorMessage, errorType)
    func handleNumericValidation(
        value: String, item: FormViewModelNumericItem, row: String
    ) -> (isError: Bool, errorMessage: String, errorType: FieldValidationType?)
    {
        if item.type == .Numerical {
            item.syncPropertiesFromNumberProperties()
        }
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?
        let regex = item.regex
        var minDigits = item.minDigit
        var maxDigits = item.maxDigit
        let minValue = item.minValue
        let maxValue = item.maxValue
        
        if let numberProperties = item.field?.properties as? NumberProperties {
            let allowedDecimalPlaces = numberProperties.DecimalPlaces ?? 0
            
            if value.contains(".") {
                if let _ = minDigits {
                    minDigits! += allowedDecimalPlaces + 1 // 1 for . before decimal places
                }
    
                if let _ = maxDigits {
                    maxDigits! += allowedDecimalPlaces + 1 // 1 for . before decimal places
                }
            }
        }
        
        
        if value.isEmpty, item.required {  // empty field and required
            isError = true
            validationType = .required
        } else if minDigits != nil && maxDigits != nil {  // min and max length exist
            if value.count < minDigits! {
                isError = true
                validationType = .minimumDigits
                validatorValue = minDigits
            } else if value.count > maxDigits! {
                isError = true
                validationType = .maximumDigits
                validatorValue = maxDigits
            } else if let regex = regex, !regex.isEmpty {
                if !value.isValidRegex(regex: regex) {
                    isError = true
                    setTextValidationType(
                        validationType: &validationType, item: item)
                }
            } else if let value = Double(value), let minValue = minValue,
                value < minValue
            {
                isError = true
                validationType = .minimumValue
                validatorValue = minValue
            } else if let value = Double(value), let maxValue = maxValue,
                value > maxValue
            {
                isError = true
                validationType = .maximumValue
                validatorValue = maxValue
            }
        } else if minDigits != nil {  // only min length exists
            if value.count < minDigits! {
                isError = true
                validationType = .minimumDigits
                validatorValue = minDigits
            }
        } else if maxDigits != nil {  // only max length exists
            if value.count > maxDigits! {
                isError = true
                validationType = .maximumDigits
                validatorValue = maxDigits
            }
        } else {
            if let regex = regex, !regex.isEmpty {
                if !value.isValidRegex(regex: regex) {
                    isError = true
                    setTextValidationType(
                        validationType: &validationType, item: item)
                }
            } else if let value = Double(value), let minValue = minValue,
                value < minValue
            {
                isError = true
                validationType = .minimumValue
                validatorValue = minValue
            } else if let value = Double(value), let maxValue = maxValue,
                value > maxValue
            {
                isError = true
                validationType = .maximumValue
                validatorValue = maxValue
            }
        }

        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .input) ?? ""
            }
        }
        return (isError, errorMessage, validationType)

    }

    /// Set validation type for (textBox,textArea) controls
    /// - Parameters:
    ///   - validationType: control's validation type
    ///   - item: current control
    func setTextValidationType(
        validationType: inout FieldValidationType?, item: FormViewModelItem
    ) {
        if let item = item as? FormViewModelTextBoxItem {
            switch item.subType {
            case .URL: validationType = .url
            case .Email: validationType = .email
            case .Numeric: validationType = .numeric
            case .Alphabetic: validationType = .alphabetic
            case .Alphanumeric: validationType = .alphanumeric
            case .Custom: validationType = .custom
            default: validationType = .custom
            }
        } else if let item = item as? FormViewModelNumericItem {
            switch item.subType {
            case .URL: validationType = .url
            case .Email: validationType = .email
            case .Numeric: validationType = .numeric
            case .Alphabetic: validationType = .alphabetic
            case .Alphanumeric: validationType = .alphanumeric
            case .Custom: validationType = .custom
            default: validationType = .custom
            }
        } else if let item = item as? FormViewModelTextAreaItem {
            switch item.subType {
            case .URL: validationType = .url
            case .Email: validationType = .email
            case .Numeric: validationType = .numeric
            case .Alphabetic: validationType = .alphabetic
            case .Alphanumeric: validationType = .alphanumeric
            case .Custom: validationType = .custom
            default: validationType = .custom
            }
        } else {
            validationType = .custom
        }
    }

    /// Handleing text limit label
    /// - Parameters:
    ///   - current: control's value count
    ///   - fieldType: control type
    ///   - entryLimit: control's entry limit
    ///   - minLength: control's min length
    ///   - maxLength: control's max length
    ///   - item: current item
    ///   - changedText: control's value
    ///   - row: control's field id
    /// - Returns:(countLabel, isError, errorMessage)
    public func handleTextLimitLabel(
        current: Int, fieldType: FieldType, entryLimit: EntryLimit = .Character,
        minLength: Int? = nil, maxLength: Int? = nil,
        item: FormViewModelTextBaseItem, changedText: String, row: String
    ) -> (countLabel: String, isError: Bool, errorMessage: String) {
        var countLabel = ""
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if current == 0, item.required {
            isError = true
            validationType = .required
        } else if minLength != nil && maxLength != nil {
            if current < minLength! {
                countLabel = "\(current)/\(minLength!)"
                if current != 0 {
                    isError = true
                }
                validationType = getValidationType(
                    fieldType: fieldType, entryLimit: entryLimit, min: true)
                validatorValue = minLength
            } else if current > maxLength! {
                countLabel = "\(current)/\(maxLength!)"
                isError = true
                validationType = getValidationType(
                    fieldType: fieldType, entryLimit: entryLimit, min: false)
                validatorValue = maxLength
            } else if current >= minLength! && current <= maxLength! {
            }
        } else if minLength != nil {
            countLabel = "\(current)/\(minLength!)"
            if current < minLength!, current != 0 {
                isError = true
                validationType = getValidationType(
                    fieldType: fieldType, entryLimit: entryLimit, min: true)
                validatorValue = minLength
            }
        } else if maxLength != nil, current <= maxLength! {
            countLabel = "\(current)/\(maxLength!)"
        }
        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .input) ?? ""
            }
        }
        return (countLabel, isError, errorMessage)
    }

    /// Handleing text box control's validation
    /// - Parameters:
    ///   - value: control's value
    ///   - item: current control
    ///   - row: control's fieldId
    /// - Returns: (isError, errorMessage, errorType)
    public func handleSwitchValidation(
        value: Bool, item: FormViewModelParagraphItem, required: Bool,
        row: String
    ) -> (isError: Bool, errorMessage: String, errorType: FieldValidationType?)
    {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if value == false, required {  // empty field and required
            isError = true
            validationType = .required
        }

        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .input) ?? ""
            }
        }
        return (isError, errorMessage, validationType)

    }
    public func handleSwitchValidationForSwitch(
        value: Bool, item: FormViewModelSwitchItem, required: Bool,
        row: String
    ) -> (isError: Bool, errorMessage: String, errorType: FieldValidationType?)
    {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if value == false, required {  // empty field and required
            isError = true
            validationType = .required
        }

        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .input) ?? ""
            }
        }
        return (isError, errorMessage, validationType)

    }

    public func handleTableError(
        cellCount: Int, maxRowNumber: Int?, minRowNumber: Int?,
        item: FormViewModelTableItem, row: String?, requiredChild: Bool
    ) -> (isError: Bool, errorMessage: String, errorType: FieldValidationType?)
    {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if requiredChild {
            isError = true
            validationType = .required
        }
        if let max = maxRowNumber, cellCount > max {
            isError = true
            validationType = .maxRows
            validatorValue = maxRowNumber
        } else if let min = minRowNumber, cellCount < min {
            isError = true
            validationType = .minRows
            validatorValue = minRowNumber
        }
        if isError {
            if let errorMsg = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                errorMsg != ""
            {
                errorMessage = errorMsg
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .table) ?? ""
            }
        }
        return (isError, errorMessage, validationType)
    }

    /// Handle DDL error
    /// - Parameters:
    ///   - optionsCount: selected values count
    ///   - minOptions: min options to be selected
    ///   - maxOptions: max options to be selected
    ///   - item: current control
    ///   - row: control's field id
    /// - Returns: (isError, errorMessage)
    public func handleDropDownError(
        optionsCount: Int, minOptions: Int?, maxOptions: Int?,
        item: FormViewModelDropdownItem, row: String?
    ) -> (isError: Bool, errorMessage: String) {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if optionsCount == 0, item.required {
            isError = true
            validationType = .required
            validatorValue = minOptions
        } else if minOptions != nil, optionsCount < minOptions ?? 0 {
            isError = true
            validationType = .minimumNumberOfSelectedOptions
            validatorValue = minOptions
        } else if maxOptions != nil, optionsCount > maxOptions ?? 0 {
            isError = true
            validationType = .maximumNumberOfSelectedOptions
            validatorValue = maxOptions
        }
        if isError {
            if let errorMsg = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                errorMsg != ""
            {
                errorMessage = errorMsg
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .mcq) ?? ""
            }
        }
        return (isError, errorMessage)
    }

    /// Handle datePicker validation
    /// - Parameters:
    ///   - item: current control
    ///   - finalDates: selected dates
    ///   - finalTimes: selected times
    ///   - row: control's field id
    /// - Returns: (isError, errorMessage, fieldsError)
    public func handleDatePickerValidation(
        item: FormViewModelDateItem, finalDates: [String], finalTimes: [String],
        row: String
    ) -> (isError: Bool, errorMessage: String, fieldsError: [String]) {
        var isError = false
        var errorMessage = ""
        var fieldsError: [String] = []
        var validationType: FieldValidationType!

        var errorValueToReplace: String = ""

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone_UTC
        dateFormatter.locale = dateFormatterLocal_en_US

        let minimumDate = item.dateProperties?.minimumDate?.getDateFromString(
            dateFormatter: dateFormatter)
        let maximumDate = item.dateProperties?.maximumDate?.getDateFromString(
            dateFormatter: dateFormatter)

        let minimumTime = item.dateProperties?.minimumTime?.getTimeFromString()
        let maximumTime = item.dateProperties?.maximumTime?.getTimeFromString()
        let allowedRange = item.dateProperties?.allowedDaysRange

        let finalDates = finalDates.map {
            return $0.getDateFromString(dateFormatter: dateFormatter)
        }
        let finalTimes = finalTimes.map {
            return $0.getDateFromString(dateFormatter: dateFormatter)
        }

        // handle required validation
        // check if a field has no input (dependent on dateTimeType and dateSelectionMode)
        if item.required {
            if item.dateSelectionMode == .Single {
                if item.dateTimeType == .Date {
                    if finalDates.isEmpty {
                        isError = true
                        fieldsError.appendIfNotContain("dateFrom")
                        validationType = .required
                    } else {
                        if finalDates[0] == nil {
                            isError = true
                            fieldsError.appendIfNotContain("dateFrom")
                            validationType = .required
                        }
                    }
                } else if item.dateTimeType == .Time {
                    if finalTimes.isEmpty {
                        isError = true
                        fieldsError.appendIfNotContain("timeFrom")
                        validationType = .required
                    } else {
                        if finalTimes[0] == nil {
                            isError = true
                            fieldsError.appendIfNotContain("timeFrom")
                            validationType = .required
                        }
                    }
                } else {
                    if finalDates.isEmpty {
                        fieldsError.appendIfNotContain("dateFrom")
                        isError = true
                        validationType = .required
                    } else {
                        if finalDates[0] == nil {
                            fieldsError.appendIfNotContain("dateFrom")
                            isError = true
                            validationType = .required
                        }
                    }
                    if finalTimes.isEmpty {
                        fieldsError.appendIfNotContain("timeFrom")
                        isError = true
                        validationType = .required
                    } else {
                        if finalTimes[0] == nil {
                            fieldsError.appendIfNotContain("timeFrom")
                            isError = true
                            validationType = .required
                        }
                    }
                }

            } else {
                if item.dateTimeType == .Date {
                    if finalDates.isEmpty {
                        fieldsError.appendIfNotContain("dateFrom")
                        isError = true
                        validationType = .required
                    } else {
                        if finalDates[0] == nil {
                            fieldsError.appendIfNotContain("dateFrom")
                            isError = true
                            validationType = .required
                        }
                    }
                    if finalDates.count < 2 {
                        fieldsError.appendIfNotContain("dateTo")
                        isError = true
                        validationType = .required
                    } else {
                        if finalDates[1] == nil {
                            fieldsError.appendIfNotContain("dateTo")
                            isError = true
                            validationType = .required
                        }
                    }
                } else if item.dateTimeType == .Time {
                    if finalTimes.isEmpty {
                        fieldsError.appendIfNotContain("timeFrom")
                        isError = true
                        validationType = .required
                    } else {
                        if finalTimes[0] == nil {
                            fieldsError.appendIfNotContain("timeFrom")
                            isError = true
                            validationType = .required
                        }
                    }
                    if finalTimes.count < 2 {
                        fieldsError.appendIfNotContain("timeTo")
                        isError = true
                        validationType = .required
                    } else {
                        if finalTimes[1] == nil {
                            fieldsError.appendIfNotContain("timeTo")
                            isError = true
                            validationType = .required
                        }
                    }
                } else {
                    if finalDates.isEmpty {
                        fieldsError.appendIfNotContain("dateFrom")
                        isError = true
                        validationType = .required
                    } else {
                        if finalDates[0] == nil {
                            fieldsError.appendIfNotContain("dateFrom")
                            isError = true
                            validationType = .required
                        }
                    }
                    if finalDates.count < 2 {
                        fieldsError.appendIfNotContain("dateTo")
                        isError = true
                        validationType = .required
                    } else {
                        if finalDates[1] == nil {
                            fieldsError.appendIfNotContain("dateTo")
                            isError = true
                            validationType = .required
                        }
                    }
                    if finalTimes.isEmpty {
                        fieldsError.appendIfNotContain("timeFrom")
                        isError = true
                        validationType = .required
                    } else {
                        if finalTimes[0] == nil {
                            fieldsError.appendIfNotContain("timeFrom")
                            isError = true
                            validationType = .required
                        }
                    }
                    if finalTimes.count < 2 {
                        fieldsError.appendIfNotContain("timeTo")
                        isError = true
                        validationType = .required
                    } else {
                        if finalTimes[1] == nil {
                            fieldsError.appendIfNotContain("timeTo")
                            isError = true
                            validationType = .required
                        }
                    }
                }
            }
        }

        // handle allowed days range validation
        if let firstDate = finalDates.first, let firstDate = firstDate,
            let lastDate = finalDates.last, let lastDate = lastDate,
            let allowedRange = allowedRange, allowedRange != 0,
            let range = Date().numberOfDaysBetween(firstDate, and: lastDate)
        {

            if range > allowedRange {
                fieldsError.appendIfNotContain("dateFrom")
                fieldsError.appendIfNotContain("dateTo")
                isError = true
                errorValueToReplace =
                    item.dateProperties?.allowedDaysRange == nil
                    ? "" : "\(item.dateProperties!.allowedDaysRange!)"
                validationType = .allowedDaysRange
            }
        }

        // handle min & max dates validation
        for date in finalDates {
            // Assuming date is already a Date object
            if let date = date, let minimumDate = minimumDate {
                let calendar = Calendar.current

                // Extract year, month, day components from the dates to compare only the date part
                let dateComponents = calendar.dateComponents(
                    [.year, .month, .day], from: date)
                let minimumDateComponents = calendar.dateComponents(
                    [.year, .month, .day], from: minimumDate)

                if let dateOnly = calendar.date(from: dateComponents),
                    let minDateOnly = calendar.date(
                        from: minimumDateComponents),
                    dateOnly < minDateOnly
                {
                    fieldsError.appendIfNotContain("dateFrom")
                    isError = true
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    errorValueToReplace = dateFormatter.string(
                        from: minimumDate)
                    validationType = .minimumDate
                }
            }

            if let date = date, let maximumDate = maximumDate {
                let calendar = Calendar.current

                // Extract year, month, day components from the dates to compare only the date part
                let dateComponents = calendar.dateComponents(
                    [.year, .month, .day], from: date)
                let maximumDateComponents = calendar.dateComponents(
                    [.year, .month, .day], from: maximumDate)

                if let dateOnly = calendar.date(from: dateComponents),
                    let maxDateOnly = calendar.date(
                        from: maximumDateComponents),
                    dateOnly > maxDateOnly
                {
                    fieldsError.appendIfNotContain("dateTo")
                    isError = true
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    errorValueToReplace = dateFormatter.string(
                        from: maximumDate)
                    validationType = .maximumDate
                }
            }
        }

        // handle min & max time validation
        for time in finalTimes {
            if let time = time, let minimumTime = minimumTime {
                if time < minimumTime {
                    fieldsError.appendIfNotContain("timeFrom")
                    isError = true
                    dateFormatter.dateFormat = item.timeFormat?.swiftFormat
                    errorValueToReplace = dateFormatter.string(
                        from: minimumTime)
                    validationType = .minimumTime
                }
            }
            if let time = time, let maximumTime = maximumTime {
                if time > maximumTime {
                    fieldsError.appendIfNotContain("timeTo")
                    isError = true
                    dateFormatter.dateFormat = item.timeFormat?.swiftFormat
                    errorValueToReplace = dateFormatter.string(
                        from: maximumTime)
                    validationType = .maximumTime
                }
            }

        }

        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: errorValueToReplace, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: errorValueToReplace,
                        fieldValidationRequiredType: .dateTime) ?? ""
            }
        }
        return (isError, errorMessage, fieldsError)
    }
    
    /// Haneld file upload validation
    /// - Parameters:
    ///   - attachCount: uploaded attachments count
    ///   - maxAttachNumber: maximum attachments count to be uploaded
    ///   - item: current control
    ///   - row: control's field id
    /// - Returns: (isError, errorMessage)
    public func handleUplaodFileError(
        attachCount: Int, maxAttachNumber: Int?,
        item: FormViewModelFileUploadItem, row: String?
    ) -> (isError: Bool, errorMessage: String) {
        item.syncPropertiesFromFileUploadProperties()
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if attachCount == 0, item.required {
            isError = true
            validationType = .required
            validatorValue = maxAttachNumber
        } else if let max = maxAttachNumber, attachCount > max {
            isError = true
            validationType = .maxAttachmentNumber
            validatorValue = maxAttachNumber
        }
        if isError {
            if let errorMsg = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                errorMsg != ""
            {
                errorMessage = errorMsg
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .fileUpload) ?? ""
            }
        }
        return (isError, errorMessage)
    }

    /// Handle table control validation
    /// - Parameters:
    ///   - cellCount: table control rows count
    ///   - maxRowNumber: max row number to be added into table control
    ///   - minRowNumber: min row number to be added into table control
    ///   - item: current control
    ///   - row: control's field id
    /// - Returns: (isError, errorMessage, errorType)
    public func handleTableError(
        cellCount: Int, maxRowNumber: Int?, minRowNumber: Int?,
        item: FormViewModelTableItem, row: String?
    ) -> (isError: Bool, errorMessage: String, errorType: FieldValidationType?)
    {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if cellCount == 0, item.required {
            isError = true
            validationType = .required
            validatorValue = maxRowNumber
        } else if let max = maxRowNumber, cellCount > max {
            isError = true
            validationType = .maxRows
            validatorValue = maxRowNumber
        } else if let min = minRowNumber, cellCount < min {
            isError = true
            validationType = .minRows
            validatorValue = minRowNumber
        }
        if isError {
            if let errorMsg = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                errorMsg != "" {
                errorMessage = errorMsg
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .table) ?? ""
            }
        }
        return (isError, errorMessage, validationType)
    }

    /// Handle check box validation
    /// - Parameters:
    ///   - item: current control
    ///   - selectedOptions: selected options in checkBox control
    ///   - min: min options to be selected
    ///   - max: max options to be selected
    ///   - row: control's field id
    /// - Returns: (error, errorMessage)
   func handleCheckboxValidation(
        item: FormViewModelMCQBaseItem, selectedOptions: [MCQOption], min: Int,
        max: Int?, row: String
    ) -> (error: Bool, errorMessage: String) {
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?
        if item is FormViewModelCheckboxItem {

            if item.required, selectedOptions.count == 0 {
                isError = true
                validationType = .required
            } else if selectedOptions.count < min {
                isError = true
                validationType = .minimumNumberOfSelectedOptions
                validatorValue = min
            } else if selectedOptions.count > max ?? item.options?.count ?? 1 {
                isError = true
                validationType = .maximumNumberOfSelectedOptions
                validatorValue = max
            }
        } else {
            if item.required, selectedOptions.isEmpty {
                isError = true
                validationType = .required
            }
        }

        if isError {
            if let errorMsg = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row)
            {
                errorMessage = errorMsg
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .mcq) ?? ""
            }
        }
        return (isError, errorMessage)
    }

    /// Handle numeric limit label
    /// - Parameters:
    ///   - current: current control's text count
    ///   - fieldType: control's type
    ///   - entryLimit: control's entry limit
    ///   - minLength: min length to be entered
    ///   - maxLength: max length to be entered
    ///   - item: current control
    ///   - row: control's field id
    /// - Returns: (countLabel, isError, errorMessage)
    public func handleNumberLimitLabel(
        current: Int, fieldType: FieldType, entryLimit: EntryLimit = .Character,
        minLength: Int? = nil, maxLength: Int? = nil,
        item: FormViewModelNumericItem, row: String
    ) -> (countLabel: String, isError: Bool, errorMessage: String) {
        var countLabel = ""
        var isError = false
        var errorMessage = ""
        var validationType: FieldValidationType!
        var validatorValue: Any?

        if current == 0, item.required {
            isError = true
            validationType = .required
        } else if minLength != nil && maxLength != nil {
            if current < minLength! {
                countLabel = "\(current)/\(minLength!)"
                if current != 0 {
                    isError = true
                }
                validationType = getValidationType(
                    fieldType: fieldType, entryLimit: entryLimit, min: true)
                validatorValue = minLength
            } else if current > maxLength! {
                countLabel = "\(current)/\(maxLength!)"
                isError = true
                validationType = getValidationType(
                    fieldType: fieldType, entryLimit: entryLimit, min: false)
                validatorValue = maxLength
            } else if current >= minLength! && current <= maxLength! {
                countLabel = "\(current)/\(maxLength!)"
                isError = false
            }
        } else if minLength != nil {
            countLabel = "\(current)/\(minLength!)"
            if current < minLength!, current != 0 {
                isError = true
                validationType = getValidationType(
                    fieldType: fieldType, entryLimit: entryLimit, min: true)
                validatorValue = minLength
            }
        } else if maxLength != nil, current <= maxLength! {
            countLabel = "\(current)/\(maxLength!)"
        }
        if isError {
            if let customError = getErrorMessageForInternalWarning(
                validation: validationType, for: validatorValue, row: row),
                customError != ""
            {
                errorMessage = customError
            } else {
                errorMessage =
                    getErrorMessageFor(
                        validation: validationType, for: validatorValue,
                        fieldValidationRequiredType: .input) ?? ""
            }
        }
        return (countLabel, isError, errorMessage)
    }

    /// Get validation type
    /// - Parameters:
    ///   - fieldType: control's type
    ///   - entryLimit: control's entry limit
    ///   - min: min length to be accepted
    /// - Returns: control's validation type
    func getValidationType(
        fieldType: FieldType, entryLimit: EntryLimit, min: Bool
    ) -> FieldValidationType {
        var validationType: FieldValidationType!
        if fieldType == .Numerical {
            validationType = min ? .minimumDigits : .maximumDigits
        } else {
            if entryLimit == .Character {
                validationType =
                    min ? .minimumCharacterLength : .maximumCharacterLength
            } else {
                validationType = min ? .minimumWordLength : .maximumWordLength
            }
        }
        return validationType
    }

    /// Handle numerical value validation
    /// - Parameters:
    ///   - current:  control's value
    ///   - minValue: min value to be accepted
    ///   - maxValue: max value to be accepted
    /// - Returns: (isError, errorMessage)
    public func handleNumericValue(
        current: Double, minValue: Double? = nil, maxValue: Double? = nil
    ) -> (isError: Bool, errorMessage: String) {
        var isError = false
        var errorMessage = ""
        if minValue != nil && maxValue != nil {
            if current < minValue!, current != 0 {
                isError = true
                errorMessage =
                    getErrorMessageFor(
                        validation: .minimumValue, for: minValue!,
                        fieldValidationRequiredType: .number) ?? ""
            } else if current > maxValue! {
                isError = true
                errorMessage =
                    getErrorMessageFor(
                        validation: .maximumValue, for: maxValue!,
                        fieldValidationRequiredType: .number) ?? ""
            } else if current >= minValue! && current <= maxValue! {
                isError = false
            }
        } else if minValue != nil, current < minValue!, current != 0 {
            isError = true
            errorMessage =
                getErrorMessageFor(
                    validation: .minimumValue, for: minValue!,
                    fieldValidationRequiredType: .number) ?? ""
        } else if maxValue != nil, current <= maxValue! {
            isError = false
        }
        return (isError, errorMessage)
    }


    public func getUploadFileMaxSizeErrorMsg(maxSize: Int, row: String?)
        -> String
    {
        var errorMessage = ""
        if let errorMsg = getErrorMessageForInternalWarning(
            validation: .maxAttachmentSize, for: maxSize, row: row)
        {
            errorMessage = errorMsg
        }
        return errorMessage
    }
    
    public func getUploadFileExtensionErrorMsg(row: String?) -> String {
        var errorMessage = ""
        if let errorMsg = getErrorMessageForInternalWarning(validation: .attachmentExtensions, row: row) {
            errorMessage = errorMsg
        }
        return errorMessage
    }

    /// Get error message for every validation
    /// - Parameters:
    ///   - validation: validation type
    ///   - value: error message value
    ///   - fieldValidationRequiredType: control's validation required type
    /// - Returns: error message
    func getErrorMessageFor(
        validation: FieldValidationType, for value: Any? = nil,
        fieldValidationRequiredType: FieldValidationRequiredType
    ) -> String? {
        guard let form = form else {
            return nil
        }
        var validationObject = form.warnings?.formWarning?.fieldValidation
        if isArabic() {
            validationObject = form.warnings?.localization?.ar?.fieldValidation
        } else {
            validationObject = form.warnings?.localization?.en?.fieldValidation
        }
        switch validation {
        case .required:
            switch fieldValidationRequiredType {
            case .fileUpload:
                return validationObject?.fileUpload?.required != ""
                    ? validationObject?.fileUpload?.required
                    : validationObject?.required
            case .table:
                return validationObject?.table?.required != ""
                    ? validationObject?.table?.required
                    : validationObject?.required
            case .input:
                return validationObject?.input?.required != ""
                    ? validationObject?.input?.required
                    : validationObject?.required
            case .number:
                return validationObject?.number?.required != ""
                    ? validationObject?.number?.required
                    : validationObject?.required
            case .dateTime:
                return validationObject?.dateTime?.required != ""
                    ? validationObject?.dateTime?.required
                    : validationObject?.required
            case .mcq:
                return validationObject?.mcq?.required != ""
                    ? validationObject?.mcq?.required
                    : validationObject?.required
            }
        case .maxAttachmentSize:
            return validationObject?.fileUpload?.maxAttachmentSize
        case .minimumDate:
            return validationObject?.dateTime?.minimumDate?
                .replaceValidationWith(value)
        case .maximumDate:
            return validationObject?.dateTime?.maximumDate?
                .replaceValidationWith(value)
        case .minimumTime:
            return validationObject?.dateTime?.minimumTime?
                .replaceValidationWith(value)
        case .maximumTime:
            return validationObject?.dateTime?.maximumTime?
                .replaceValidationWith(value)
        case .allowedDaysRange:
            return validationObject?.dateTime?.allowedDaysRange?
                .replaceValidationWith(value)
        case .minimumCharacterLength:
            return validationObject?.input?.minimumCharacterLength?
                .replaceValidationWith(value)
        case .maximumCharacterLength:
            return validationObject?.input?.maximumCharacterLength?
                .replaceValidationWith(value)
        case .minimumWordLength:
            return validationObject?.input?.minimumWordLength?
                .replaceValidationWith(value)
        case .maximumWordLength:
            return validationObject?.input?.maximumWordLength?
                .replaceValidationWith(value)
        case .email:
            return validationObject?.input?.email
        case .url:
            return validationObject?.input?.url
        case .numeric:
            return validationObject?.input?.numeric
        case .alphabetic:
            return validationObject?.input?.alphabetic
        case .alphanumeric:
            return validationObject?.input?.alphanumeric
        case .custom:
            return validationObject?.input?.custom
        case .minimumValue:
            return validationObject?.number?.minimumValue?
                .replaceValidationWith(value)
        case .maximumValue:
            return validationObject?.number?.maximumValue?
                .replaceValidationWith(value)
        case .minimumDigits:
            return validationObject?.number?.minimumDigits?
                .replaceValidationWith(value)
        case .maximumDigits:
            return validationObject?.number?.maximumDigits?
                .replaceValidationWith(value)
        case .minimumNumberOfSelectedOptions:
            return validationObject?.mcq?.minimumNumberOfSelectedOptions?
                .replaceValidationWith(value)
        case .maximumNumberOfSelectedOptions:
            return validationObject?.mcq?.maximumNumberOfSelectedOptions?
                .replaceValidationWith(value)
        case .maxAttachmentNumber:
            return validationObject?.fileUpload?.maxAttachmentNumber?
                .replaceValidationWith(value)
        case .minRows:
            return validationObject?.table?.minRows ?? ""
        case .maxRows:
            return validationObject?.table?.maxRows ?? ""
        default:
            return ""
        }
    }

    /// Get error message from control's properties
    /// - Parameters:
    ///   - validation: control's validation type
    ///   - value: error message value
    ///   - row: control's field id
    /// - Returns: error message
    func getErrorMessageForInternalWarning(
        validation: FieldValidationType, for value: Any? = nil,
        row: String? = nil
    ) -> String? {
        var validationObject: InternalFieldValidation?
        guard let row = row else {
            return nil
        }
        guard let form = form else {
            return nil
        }
        if isArabic() {
            validationObject =
                form.fields?.first(where: { $0.id == row })?.properties?
                .localization?["ar"]?.fieldWarning
        } else {
            validationObject =
                form.fields?.first(where: { $0.id == row })?.properties?
                .localization?["en"]?.fieldWarning
        }
        switch validation {
        case .required:
            return validationObject?.required
        case .minimumNumberOfSelectedOptions:
            return validationObject?.minimumNumberOfSelectedOptions?
                .replaceValidationWith(value)
        case .maximumNumberOfSelectedOptions:
            return validationObject?.maximumNumberOfSelectedOptions?
                .replaceValidationWith(value)
        case .maxAttachment:
            return validationObject?.maxAttachment
        case .dateTime:
            return validationObject?.dateTime
        case .minimumCharacterLength:
            return validationObject?.minimumCharacterLength?
                .replaceValidationWith(value)
        case .maximumCharacterLength:
            return validationObject?.maximumCharacterLength?
                .replaceValidationWith(value)
        case .minimumWordLength:
            return validationObject?.minimumWordLength?.replaceValidationWith(
                value)
        case .maximumWordLength:
            return validationObject?.maximumWordLength?.replaceValidationWith(
                value)
        case .email:
            return validationObject?.email
        case .url:
            return validationObject?.url
        case .maxAttachmentNumber:
            return validationObject?.maxAttachment?.replaceValidationWith(value)
        case .numeric:
            return validationObject?.numeric
        case .alphabetic:
            return validationObject?.alphabetic
        case .alphanumeric:
            return validationObject?.alphanumeric
        case .custom:
            return validationObject?.custom
        case .minimumValue:
            return validationObject?.minimumValue?.replaceValidationWith(value)
        case .maximumValue:
            return validationObject?.maximumValue?.replaceValidationWith(value)
        case .minimumDigits:
            return validationObject?.minimumDigits?.replaceValidationWith(value)
        case .maximumDigits:
            return validationObject?.maximumDigits?.replaceValidationWith(value)
        case .minimumDate:
            return validationObject?.minimumDate?.replaceValidationWith(value)
        case .maximumDate:
            return validationObject?.maximumDate?.replaceValidationWith(value)
        case .minimumTime:
            return validationObject?.minimumTime?.replaceValidationWith(value)
        case .maximumTime:
            return validationObject?.maximumTime?.replaceValidationWith(value)
        case .allowedDaysRange:
            return validationObject?.allowedDaysRange?.replaceValidationWith(
                value)
        case .minRows:
            return validationObject?.minRows?.replaceValidationWith(value)
        case .maxRows:
            return validationObject?.maxRows?.replaceValidationWith(value)
        case .maxAttachmentSize:
            return validationObject?.maxAttachmentSize?.replaceValidationWith(
                value)
        case .attachmentType:
            return validationObject?.attachmentType?.replaceValidationWith(
                value)
        case .attachmentExtensions:
            return validationObject?.attachmentExtensions?
                .replaceValidationWith(value)
        }
    }
}
