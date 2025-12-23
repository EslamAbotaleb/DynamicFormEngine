//
//  FormBuilder+ValidItemRuleExtensions.swift
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
    
    /// Checking if each control is valid or not
    /// - Parameters:
    ///   - item: current control
    ///   - condition: condition related to control's rule
    /// - Returns: valid or not
    func isItemValid(
        _ item: FormViewModelItem, condition: IfCondition,
        completion: @escaping (Bool) -> Void
    ) {
        DispatchQueue.main.async {
            var valid = false
            var value: [String]?
            var valueTimes: [String]?  // used only with time rules

//            if item.parentId != nil {
//                for formItem in self.sectionObjects {
//                    // Check if `formItem.items` is not empty
//                    if let firstItem = formItem.items.first,
//                       let tableComponent = firstItem as? FormViewModelTableItem {
//                        if !self.allRowsChildControls.isEmpty {
//                            for children in self.allRowsChildControls {
//                                if children.fieldId == item.fieldId {
//                                    let childItem = FormViewModelItem(from: children)
//                                    value = self.getItemValueForTableFields(childItem)
//                                }
//                            }
//                        }
//                    } else {
//                        self.getItemValue(item, &value)
//                    }
//                }
//            } else {
                self.getItemValue(item, &value)
//            }

            self.getDatePickerTimesValues(item, &valueTimes)  // responsible for getting time values from date picker
            var valueValidator: [String]?

            if condition.target == "Field" {
                let fieldID = condition.value
                if let item = self.formModelItems.first(where: {
                    $0.fieldId == fieldID
                }) {
                    self.getItemValue(item, &valueValidator)
                }
            } else {
                if let value = condition.value {
                    valueValidator = [value]
                }
            }

            if let fieldState = condition.fieldState {
                switch fieldState {

                case .Filled, .Empty:
                    self.handleFilledState(value, &valid, filled: fieldState == .Filled)
                    
                    if item.type == .Table {
                        self.handleTableFilledState((item as? FormViewModelTableItem)?.items.count ?? 0, &valid, filled: fieldState == .Filled)
                    }
                    
                case .Equal, .NotEqual:
                    self.handleEqualState(
                        value, valueValidator, &valid,
                        equal: fieldState == .Equal)

                case .Contains, .NotContain:
                    self.handleContainsState(
                        value, valueValidator, &valid,
                        contains: fieldState == .Contains)

                case .StartsWith, .NotStartWith:
                    self.handleStartsWithState(
                        value, valueValidator, &valid,
                        startWith: fieldState == .StartsWith)

                case .EndsWith, .NotEndWith:
                    self.handleEndsWithState(
                        value, valueValidator, &valid,
                        endWith: fieldState == .EndsWith)

                case .LessThan, .GreaterThan:
                    self.handleLessThanState(
                        value, valueValidator, &valid,
                        lessThan: fieldState == .LessThan)

                case .After, .Before:
                    self.handleAfterState(
                        value, valueValidator, &valid,
                        after: fieldState == .After)

                case .EqualToDate, .NotEqualToDate:
                    self.handleEqualState(
                        value, valueValidator, &valid,
                        equal: fieldState == .EqualToDate)

                case .EqualToTime, .NotEqualToTime:
                    let timeItem = item as? FormViewModelDateItem
                    self.handleTimeState(
                        valueTimes, valueValidator, &valid,
                        equal: fieldState == .EqualToTime,
                        timeFormat24: (timeItem?.dateProperties?.timeFormat?
                            .rawValue == "FullDay") ? true : false)

                case .EqualToDay, .NotEqualToDay:
                    self.handleEqualToDayState(
                        value, valueValidator, &valid,
                        equal: fieldState == .EqualToDay)

                case .Include, .NotInclude:
                    self.handleIncludeState(
                        value, valueValidator, valid: &valid,
                        include: fieldState == .Include)
                }
            }

            completion(valid)
        }
    }

    /// Updating each control value based on it's answer type
    /// - Parameters:
    ///   - item: current control
    ///   - value: current control's value that will be updated and passed back
    func getItemValue(_ item: FormViewModelItem, _ value: inout [String]?) {
        if let val = (item.answer as? BaseAnswerText)?.value {
            value = [val]
        }
        if let val = (item.answer as? SliderAnswer)?.value {
            value = getNumberValue(val: val)
        }
        if var val = (item.answer as? DateTimeAnswer)?.value,
            let timeVal = (item.answer as? DateTimeAnswer)?.timeValues,
            !val.isEmpty, !timeVal.isEmpty
        {

            // Concatenate the first elements
            val[0] += " " + timeVal[0]

            // Concatenate the last elements
            if val.count > 1 && timeVal.count > 1 {
                val[val.count - 1] += " " + timeVal[timeVal.count - 1]
            }

            value = val
        } else if let val = (item.answer as? DateTimeAnswer)?.value {
            value = val
        }
        if let val = (item.answer as? BaseAnswerMCQ)?.value {
            value = val.map { $0.id ?? "" }
        }
        if let val = (item.answer as? LocationAnswer)?.value {
            value = [val.toJSONString() ?? ""]
        }
        if let val = (item.answer as? ParagraphAnswer)?.value {
            value = [val]
        }
    }

    func getItemValueForTableFields(_ item: FormViewModelItem) -> [String]? {
        var tempValue: [String]?

        if let val = (item.answer as? BaseAnswerText)?.value {
            tempValue = [val]
        }
        if let val = (item.answer as? SliderAnswer)?.value {
            tempValue = getNumberValue(val: val)
        }
        if let val = (item.answer as? DateTimeAnswer)?.value {
            tempValue = val
        }
        if let val = (item.answer as? BaseAnswerMCQ)?.value {
            tempValue = val.map { $0.id ?? "" }
        }
        if let val = (item.answer as? LocationAnswer)?.value {
            tempValue = [val.toJSONString() ?? ""]
        }
        if let val = (item.answer as? ParagraphAnswer)?.value {
            tempValue = [val]
        }
        return tempValue
    }

    /// Updating datePicker's values
    /// - Parameters:
    ///   - item: current control
    ///   - valueTimes: current control's value that will be updated and passed back
    func getDatePickerTimesValues(
        _ item: FormViewModelItem, _ valueTimes: inout [String]?
    ) {
        if let val = (item.answer as? DateTimeAnswer)?.timeValues {
            valueTimes = val
        }
    }

    /// Converting [Double] answer into [String] to be passed to payload
    /// - Parameter val: current value
    /// - Returns: [string] value
    func getNumberValue(val: [Double]) -> [String]? {
        var value: [String]?
        for v in val {
            let isInteger = v.truncatingRemainder(dividingBy: 1) == 0
            if isInteger {
                let intVal = Int(v)
                if value == nil {
                    value = [String(intVal)]
                } else {
                    value?.append(String(intVal))
                }
            } else {
                if value == nil {
                    value = [String(v)]
                } else {
                    value?.append(String(v))
                }
            }
        }
        return value
    }
}
