//
//  FormBuilder+FieldStateFuncExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 25/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

internal import Alamofire
import Expression
import Foundation
import ObjectMapper
import RxCocoa
internal import RxSwift
import UIKit

extension FormBuilder {
    
    /// Checking if control's value equal to condition's value or not
    /// - Parameters:
    ///   - value: current control's value
    ///   - valueValidator: condition's value to be compared with control's value
    ///   - valid: is control valid or not
    ///   - equal: fieldState in condition
    func handleEqualState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        equal: Bool
    ) {
        if let valueStrings = value {
            if let validatorValue = valueValidator?.first {
                let values = valueStrings.map({ $0.toEnglish })
                if equal {
                    if values.contains(validatorValue) {
                        valid = true
                    }
                } else {
                    if !values.contains(validatorValue) {
                        valid = true
                    }
                }
            }
        } else if let valueString = value?.first,
                  let validatorValue = valueValidator?.first,
                  valueString.toEnglish == validatorValue
        {
            valid = true
        }
    }
    
    /// Checking if control's value compared to condition's value valid or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - equal: fieldState in condition
    ///   - timeFormat24: control's timeFormat
    func handleTimeState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        equal: Bool, timeFormat24: Bool
    ) {
        let fromFormat = "y-MM-dd'T'HH:mm:ss"
        let toFormat = timeFormat24 ? "HH:mm" : "hh:mm a"
        if let valueStrings = value {
            if let validatorValue = valueValidator?.first?.changeFormat(
                fromFormat: fromFormat, toFormat: toFormat)
            {
                let values = valueStrings.map({
                    $0.toEnglish.changeFormat(
                        fromFormat: fromFormat, toFormat: toFormat)
                })
                if equal {
                    if values.contains(validatorValue) {
                        valid = true
                    }
                } else {
                    if !values.contains(validatorValue) {
                        valid = true
                    }
                }
            }
        } else if let valueString = value?.first?.changeFormat(
            fromFormat: fromFormat, toFormat: toFormat),
                  let validatorValue = valueValidator?.first?.changeFormat(
                    fromFormat: fromFormat, toFormat: toFormat),
                  valueString.toEnglish == validatorValue
        {
            valid = true
        }
    }
    
    /// Checking if control's value contains condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - contains: fieldState in condition
    func handleContainsState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        contains: Bool
    ) {
        guard let validatorValue = valueValidator, let itemValue = value else {
            return
        }
        for value in validatorValue {
            if contains {
                if itemValue.contains(where: { $0.contains(value) }) {
                    valid = true
                }
            } else {
                if !itemValue.contains(where: { $0.contains(value) }) {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value start with condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - startWith: fieldState in condition
    func handleStartsWithState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        startWith: Bool
    ) {
        if let valueString = value?.first,
           let validatorValue = valueValidator?.first
        {
            if startWith {
                if valueString.starts(with: validatorValue) {
                    valid = true
                }
            } else {
                if !valueString.starts(with: validatorValue) {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value ends with condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - endWith: fieldState in condition
    func handleEndsWithState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        endWith: Bool
    ) {
        //        if let valueString = value?.first, let validatorValue = valueValidator?.first {
        if let valueString = value?.last,
           let validatorValue = valueValidator?.first
        {
            if endWith {
                if valueString.hasSuffix(validatorValue) {
                    valid = true
                }
            } else {
                if !valueString.hasSuffix(validatorValue) {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value less than condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - lessThan: fieldState in condition
    func handleLessThanState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        lessThan: Bool
    ) {
        guard let validatorValue = valueValidator?.first,
              let validatorDoubleValue = Double(validatorValue)
        else {
            return
        }
        if let value = value {
            var dblVals = [Double]()
            for val in value {
                if let dblVal = Double(val) {
                    dblVals.append(dblVal)
                }
            }
            if dblVals.count > 1 {
                handleLessThanMultipleVals(
                    &dblVals, lessThan, validatorDoubleValue, &valid)
            } else {
                handleLessThanOneVal(
                    dblVals, lessThan, validatorDoubleValue, &valid)
            }
        }
    }
    
    /// Checking if control's values less than condition's value or not
    /// - Parameters:
    ///   - dblVals: control's values
    ///   - lessThan: fieldState in condition
    ///   - validatorDoubleValue: condition's value
    ///   - valid: is control valid or not
    func handleLessThanMultipleVals(
        _ dblVals: inout [Double], _ lessThan: Bool,
        _ validatorDoubleValue: Double, _ valid: inout Bool
    ) {
        dblVals.sort()
        if let firstVal = dblVals.first, let lastVal = dblVals.last {
            if lessThan {
                if lastVal < validatorDoubleValue {
                    valid = true
                }
            } else {
                if firstVal > validatorDoubleValue {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value less than condition's value or not
    /// - Parameters:
    ///   - dblVals: control's value
    ///   - lessThan: fieldState in condition
    ///   - validatorDoubleValue: condition's value
    ///   - valid: is control valid or not
    func handleLessThanOneVal(
        _ dblVals: [Double], _ lessThan: Bool, _ validatorDoubleValue: Double,
        _ valid: inout Bool
    ) {
        if let dblVal = dblVals.first {
            if lessThan {
                if dblVal < validatorDoubleValue {
                    valid = true
                }
            } else {
                if dblVal > validatorDoubleValue {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value equal to condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - equal: fieldState in condition
    func handleEqualToDayState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        equal: Bool
    ) {
        if let valueDate = value?.first?.getDateFromString() {
            if equal {
                valid = Calendar.current.isDateInToday(valueDate)
            } else {
                valid = !Calendar.current.isDateInToday(valueDate)
            }
        }
    }
    
    /// Checking if control's value after condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - after: fieldState in condition
    func handleAfterState(
        _ value: [String]?, _ valueValidator: [String]?, _ valid: inout Bool,
        after: Bool
    ) {
        guard let validatorValue = valueValidator?.first,
              let validatorValueDate = validatorValue.getDateFromString()
        else {
            return
        }
        if let value = value {
            var dateValues = [Date]()
            for val in value {
                if let dateValue = val.getDateFromString() {
                    dateValues.append(dateValue)
                }
            }
            if dateValues.count > 1 {
                handleAfterMultipleVals(
                    &dateValues, after, validatorValueDate, &valid)
            } else {
                handleAfterOneVal(dateValues, after, validatorValueDate, &valid)
            }
        }
    }
    
    /// Checking if control's values after condition's value or not
    /// - Parameters:
    ///   - dateValues: control's values
    ///   - after: fieldState in condition
    ///   - validatorValueDate: condition's value
    ///   - valid: is control valid or not
    func handleAfterMultipleVals(
        _ dateValues: inout [Date], _ after: Bool, _ validatorValueDate: Date,
        _ valid: inout Bool
    ) {
        dateValues.sort()
        if let firstVal = dateValues.first, let lastVal = dateValues.last {
            if after {
                if lastVal < validatorValueDate {
                    valid = true
                }
            } else {
                if firstVal > validatorValueDate {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value after condition's value or not
    /// - Parameters:
    ///   - dateValues: control's value
    ///   - after: fieldState in condition
    ///   - validatorValueDate: condition's value
    ///   - valid: is control valid or not
    fileprivate func handleAfterOneVal(
        _ dateValues: [Date], _ after: Bool, _ validatorValueDate: Date,
        _ valid: inout Bool
    ) {
        if let dateVal = dateValues.first {
            if after {
                if dateVal > validatorValueDate {
                    valid = true
                }
            } else {
                if dateVal < validatorValueDate {
                    valid = true
                }
            }
        }
    }
    
    /// Checking if control's value include condition's value or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valueValidator: condition's value
    ///   - valid: is control valid or not
    ///   - include: fieldState in condition
    func handleIncludeState(
        _ value: [String]?, _ valueValidator: [String]?, valid: inout Bool,
        include: Bool
    ) {
        guard let validatorValue = valueValidator, let itemValue = value else {
            return
        }
        for value in validatorValue {
            if include {
                if itemValue.contains(where: {
                    $0.lowercased() == value.lowercased()
                }) {
                    valid = true
                }
            } else {
                if !itemValue.contains(where: { $0 == value }) {
                    valid = true
                }
            }
            
        }
    }
    
    /// Checking if control filled or not
    /// - Parameters:
    ///   - value: control's value
    ///   - valid: is control valid or not
    ///   - filled: fieldState in condition
    func handleFilledState(
        _ value: [String]?, _ valid: inout Bool, filled: Bool
    ) {
        if let valueString = value?.first {
            if filled {
                if !valueString.isEmpty {
                    valid = true
                }
            } else {
                if valueString.isEmpty {
                    valid = true
                }
            }
        } else {
            valid = !filled
        }
    }
    
    func handleTableFilledState(_ childrenCount: Int, _ valid: inout Bool, filled: Bool) {
        if filled {
            valid = childrenCount > 0
        } else {
            valid = childrenCount == 0
        }
    }
}
