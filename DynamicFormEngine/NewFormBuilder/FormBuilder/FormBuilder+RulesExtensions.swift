//
//  FormBuilder+RulesExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 25/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Alamofire
import Expression
import Foundation
import ObjectMapper
import RxCocoa
import RxSwift
import UIKit


extension FormBuilder {
    
    /// Handling rules for controls
    /// This method is called when the form is first opened. It iterates over all rules in the formViewModel and applies them.
    /// - Parameters:
    ///   - excludedView: A view to be excluded from the rule handling.
    ///   - removeAnswer: A flag indicating whether the answer should be removed.
    func handleItemsRulesWhenFirstInitiateForm(excludedView: ExcludedViews, removeAnswer: Bool) {
        for rule in formViewModel.rules ?? [] {
            handleRule(rule, nil, excludedView: excludedView, removeAnswer: removeAnswer)
        }
    }
    
    /// Handling rules for every control
    /// This method is triggered when a specific field has changed its value or when user interaction occurs.
    /// It processes the rules associated with the given form item.
    /// - Parameters:
    ///   - item: The current control whose rules are being handled.
    ///   - excludedView: A view to be excluded from the rule handling.
    ///   - removeAnswer: A flag indicating whether the answer should be removed.
    public func handleItemRules(_ item: FormViewModelItem, excludedView: ExcludedViews, removeAnswer: Bool) {
        for ruleId in item.rules?.effectIn ?? [] {
            if let rule = formViewModel.rules?.first(where: { $0.id == ruleId }) {
                handleRule(rule, reload: true, item, excludedView: excludedView, removeAnswer: removeAnswer)
            }
        }
    }
    /// Checking if a rule is valid and applying it for the given control.
    /// - Parameters:
    ///   - rule: The rule to be validated and applied.
    ///   - reload: A flag indicating whether to reload the tableView.
    ///   - item: The current control to which the rule is related.
    ///   - excludedView: A view to be excluded from the rule handling.
    ///   - removeAnswer: A flag indicating whether the answer should be removed.
    func handleRule(_ rule: Rule, reload: Bool = false, _ item: FormViewModelItem?, excludedView: ExcludedViews, removeAnswer: Bool) {
        // Check if the rule's excluded views contain the specified excluded view
        if let excludedViews = rule.excludedViews {
            guard !excludedViews.contains(excludedView) else { return }
        }
        
        var valid = false
        let ruleOperation = rule.operation ?? .OR
        self.cascadingCurrentItemID = item?.fieldId
        
        let conditions = rule.ifConditions ?? []
        var validCount = 0 // Counter for valid conditions (used for ALL operation)
        
        func evaluateCondition(at index: Int) {
            // Check if index is within bounds of conditions array
            guard index < conditions.count else {
                // If operation is ALL, check if all conditions were valid
                if ruleOperation == .And {
                    valid = (validCount == conditions.count)
                }
                // Execute actions with the final validity status
                executeActions(valid: valid, rule: rule, reload: reload, removeAnswer: removeAnswer)
                return
            }
            
            let condition = conditions[index]
            var linkedItem: FormViewModelItem?
            
            if let fieldId = condition.fieldId {
                if let item = item, item.fieldId == fieldId {
                    linkedItem = item
                }else {
                    linkedItem = itemsDict[fieldId]?.0 ?? item
                }
            } else if let item = item {
                linkedItem = item
            }
            
            if let linkedItem = linkedItem {
                isItemValid(linkedItem, condition: condition) { isValid in
                    if isValid {
                        validCount += 1 // Increment valid condition counter
                    }
                    
                    if ruleOperation == .OR {
                        if isValid {
                            // If operation is OR and one condition is valid, execute with valid = true
                            self.executeActions(valid: true, rule: rule, reload: reload, removeAnswer: removeAnswer)
                            return
                        }
                    }
                    
                    // Move to the next condition
                    evaluateCondition(at: index + 1)
                }
            } else {
                // If no linkedItem, move to the next condition
                evaluateCondition(at: index + 1)
            }
        }
        
        // Start evaluating conditions from the first one
        evaluateCondition(at: 0)
    }
    
    /// Executes the actions defined in the rule based on the validity of conditions.
    /// - Parameters:
    ///   - valid: The final validity status of the rule.
    ///   - rule: The rule whose actions are being executed.
    ///   - reload: A flag indicating whether to reload the tableView.
    ///   - removeAnswer: A flag indicating whether the answer should be removed.
    private func executeActions(valid: Bool, rule: Rule, reload: Bool, removeAnswer: Bool) {
        for action in rule.doActions ?? [] {
            let actionType = action.type ?? .Show
            for id in action.targetFieldsIds ?? [] {  // Dependent fields
                if let x = itemsDict[id] {
                    handleRuleResult(
                        action: action, (valid, actionType), itemIndex: x.1,
                        reload: reload,
                        rule: rule,
                        removeAnswer: removeAnswer)
                }
            }
        }
    }
    
    /// Applying Rule if all conditions are valid
    /// - Parameters:
    ///   - action: action that will be executed
    ///   - result: (valid rule or not, action type)
    ///   - itemIndex: current control index
    ///   - reload: reload tableView or not
    func handleRuleResult(action: DoAction, _ result: (Bool, ActionType), itemIndex: Int, reload: Bool = false,rule: Rule, removeAnswer: Bool) {
        //        setSelfControlCascading(action: action)
        var shouldReload = false
        let oldVals = [formViewModel.items[itemIndex].hidden, formViewModel.items[itemIndex].disabled, formViewModel.items[itemIndex].isRequired]
        switch result.1 {
        case .Show:
            formViewModel.items[itemIndex].hidden = !result.0
        case .Hide:
            formViewModel.items[itemIndex].hidden = result.0
            formViewModel.items[itemIndex].answer = nil
            if let item = formViewModel.items[itemIndex]
                as? FormViewModelFileUploadItem
            {
                item.attachmentsList.removeAll()
            }
        case .Enable:
            formViewModel.items[itemIndex].disabled = !result.0
            formViewModel.items[itemIndex].field?.properties?.disabled = !result.0
            formViewModel.items[itemIndex].field?.properties?.readonly = !result.0
        case .Disable:
            if let interActiveItem = formViewModel.items[itemIndex]
                as? FormViewModelInteractiveItem
            {
                shouldReload = interActiveItem.required != false
                interActiveItem.required = result.0 ? false : interActiveItem.field?.properties?.required ?? false
                interActiveItem.isRequired = result.0 ? false : interActiveItem.field?.properties?.required ?? false
                interActiveItem.field?.properties?.disabled = result.0
                interActiveItem.disabled = result.0
                interActiveItem.field?.properties?.readonly = result.0
                formViewModel.items[itemIndex].disabled = result.0
                formViewModel.items[itemIndex].field?.properties?.readonly = result.0
                formViewModel.items[itemIndex] = interActiveItem
            }
        case .Require:
            if let interActiveItem = formViewModel.items[itemIndex]
                as? FormViewModelInteractiveItem
            {
                shouldReload = interActiveItem.required != result.0
                interActiveItem.field?.properties?.required = result.0
                interActiveItem.required = result.0
                interActiveItem.isRequired = result.0
                formViewModel.items[itemIndex] = interActiveItem
            }
        case .UnRequire:
            if let interActiveItem = formViewModel.items[itemIndex]
                as? FormViewModelInteractiveItem
            {
                shouldReload = interActiveItem.required != result.0
                interActiveItem.required = !result.0
                interActiveItem.field?.properties?.required = !result.0
                interActiveItem.isRequired = !result.0
                formViewModel.items[itemIndex] = interActiveItem
            }
        case .SetProperty:
            handleSetPropertyCase(action, result, itemIndex, removeAnswer)
        case .Calculate:
            if result.0, let equation = action.payload as? String {  // field 1 = filled , field2 = not filled (3)
                handleRelationEquation(
                    equation: equation, itemIndex: itemIndex, reload: true)
            } else {
                // clear depend fields' values then reload
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.clearFieldValue(itemIndex: itemIndex)
                }
            }
            
        case .Cascade:
            setSelfControlCascading(action: action)
            if result.0, let payload = action.payload {
                
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.clearFieldValue(itemIndex: itemIndex)
                }
                
                
                let pl = Payload(id: payload["id"] as? String,
                                 parameters: payload["parameters"] as? [String])
                handleCascading(targetFieldIds: action.targetFieldsIds,
                                sourceFieldsIds: action.sourceFieldsIds,
                                payload: pl,
                                itemIndex: itemIndex,
                                reload: true,
                                action: action)
            }else {
                // clear depend fields' values then reload
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.clearFieldValue(itemIndex: itemIndex)
                }
            }
        case .RangeIncluded:
            var pl = Payload(id: "",
                             parameters: [] )
            return  passMinMaxDates(targetFieldIds: action.targetFieldsIds,
                                    sourceFieldsIds: action.sourceFieldsIds,
                                    payload: &pl,
                                    itemIndex: itemIndex,
                                    reload: true)
            
        case .Validation:
            if result.0 {
                handleValidationRule(payload: action.payload,
                                     sourceFieldsIds: action.sourceFieldsIds)
            }
        default:
            break
        }
        let newVals = [
            formViewModel.items[itemIndex].hidden,
            formViewModel.items[itemIndex].disabled,
            formViewModel.items[itemIndex].isRequired,
        ]
        if !shouldReload {
            shouldReload = oldVals != newVals
        }
        if shouldReload, reload {
            reloadItem(itemIndex)
        }
    }
  
    /// Calculating rule's equation
    /// - Parameters:
    ///   - equation: rule's equation
    ///   - completion: returning calculated answer
    func getResultFromEquation(equation: String, _ completion: @escaping ((String?) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            var finalResult: String?
            var lowerCasedEquation = equation
            var fieldIDs: [String] = [] // ids mentioned in equation
            
            // Adjusted regex to capture both curly brace IDs and raw IDs
            let pattern = "\\{?([a-z0-9\\-]{36})\\}?"
            let regex = try? NSRegularExpression(pattern: pattern)
            let results = regex?.matches(in: lowerCasedEquation, range: NSRange(lowerCasedEquation.startIndex..., in: lowerCasedEquation))
            
            for result in results ?? [] {
                let range = result.range(at: 1)
                if let range = Range(range, in: lowerCasedEquation) {
                    let fieldID = lowerCasedEquation[range]
                    fieldIDs.append(String(fieldID))
                }
            }
            
            var valuesArray = [String]()
            for fieldID in fieldIDs {
                for (index, id) in self.sectionObjects.map({ $0.id }).enumerated() {
                    if id == fieldID {
                        isTableEquation = false
                        guard let item = self.sectionObjects[index].items.first else { return }
                        var fieldValue: [String]?
                        
                        // Get item value logic
                        self.getItemValue(item, &fieldValue)
                        if let value = fieldValue?.first {
                            valuesArray.append(value)
                            lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "{\(fieldID)}", with: "\(value)")
                            lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "\(fieldID)", with: "\(value)") // Also handle IDs without braces
                        } else {
                            lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "{\(fieldID)}", with: "0")
                            lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "\(fieldID)", with: "0")
                        }
                    } else {
                        lowerCasedEquation = self.extractTableItems(id: id, fieldID: fieldID, equation: &lowerCasedEquation, values: &valuesArray)
                        isTableEquation = true
                    }
                }
                if self.sectionObjects.contains(where: { $0.item != nil }) {
                    if self.sectionObjects.contains(where: { $0.items.contains(where: { $0.fieldId == fieldID }) }) {
                        isTableEquation = false
                        for (sectionIndex, sectionObject) in self.sectionObjects.enumerated() {
                            // Loop through all items in this sectionObject
                            for item in sectionObject.items {
                                if item.fieldId == fieldID {
                                    // Found the matching item
                                    var fieldValue: [String]?
                                    
                                    // Get the item value
                                    self.getItemValue(item, &fieldValue)
                                    
                                    if let value = fieldValue?.first {
                                        valuesArray.append(value)
                                        lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "{\(fieldID)}", with: "\(value)")
                                        lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "\(fieldID)", with: "\(value)") // Also handle IDs without braces
                                    } else {
                                        lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "{\(fieldID)}", with: "0")
                                        lowerCasedEquation = lowerCasedEquation.replacingOccurrences(of: "\(fieldID)", with: "0")
                                    }
                                }
                            }
                        }
                    } else {
                        // Handle case when fieldID is not found in any sectionObject
                        lowerCasedEquation = self.extractTableItems(id: fieldID, fieldID: fieldID, equation: &lowerCasedEquation, values: &valuesArray)
                        isTableEquation = true
                    }
                    
                }
                
            }
            
            // Evaluate the final expression
            let expression = Expression(lowerCasedEquation)
            if let result = try? expression.evaluate() {
                finalResult = "\(result)"
            } else {
                finalResult = self.handleMultiFieldsOperationsWrapper(customExpression: lowerCasedEquation, values: valuesArray, isTable: isTableEquation )
            }
            completion(finalResult)
        }
    }
    
    /// Calculating rule's equation if it applied on more than one field
    /// - Parameters:
    ///   - customExpression: rule's expression
    ///   - values: controls' values
    /// - Returns: returns calculated answer
    func handleMultiFieldsOperations(customExpression: String, values: [String]?) -> String? {
        let engine = FormulaEngine()
        var finalResult = ""
        
        // Convert customExpression to lowercase for case-insensitive operations
        let lowercasedExpression = customExpression.lowercased()
        var customExpressionVar = customExpression
        
        // Ensure values are either empty or present
        let variables: [String: Any]
        if let values = values, !values.isEmpty {
            // Create variables dictionary based on input values
            variables = Dictionary(uniqueKeysWithValues: zip((1...values.count).map { "par\($0)" }, values))
        } else {
            // If no values are provided, set variables as an empty dictionary
            variables = [:]
        }
        
        // Check for table field indicator ($) and handle table operations
        if customExpressionVar.contains("$") {
            // Regex to find `$` placeholders
            //            let regex = try! NSRegularExpression(pattern: "\\$\\d+", options: [])
            //            let matches = regex.matches(in: customExpressionVar, options: [], range: NSRange(location: 0, length: customExpressionVar.count))
            
            if let values = values {
                // Concatenate all values for this placeholder
                let concatenatedValues = values.joined(separator: ",")
                
                // Regex to match placeholders in the form {${...}}
                let bracesRegex = try! NSRegularExpression(pattern: "\\{\\$([\\w-]+)\\}", options: [])
                
                // Regex to match placeholders in the form ${...}
                let dollarBracesRegex = try! NSRegularExpression(pattern: "\\$\\{([\\w-]+)\\}", options: [])
                
                // Regex to match simple placeholders in the form $...
                let placeholderRegex = try! NSRegularExpression(pattern: "\\$(\\w+)", options: [])
                
                // Regex to match function call with placeholder, e.g., sum(${...})
                let functionWithPlaceholderRegex = try! NSRegularExpression(pattern: "(\\w+)\\(\\$\\{([\\w-]+)\\}\\)", options: [])
                
                // Check and replace function with placeholder, e.g., sum(${...})
                if let match = functionWithPlaceholderRegex.firstMatch(in: customExpressionVar, options: [], range: NSRange(location: 0, length: customExpressionVar.count)) {
                    if let range = Range(match.range(at: 2), in: customExpressionVar) {
                        let placeholder = String(customExpressionVar[range])
                        customExpressionVar = customExpressionVar.replacingOccurrences(of: "${\(placeholder)}", with: concatenatedValues)
                    }
                }
                // Check and replace {${...}}
                else if let bracesMatch = bracesRegex.firstMatch(in: customExpressionVar, options: [], range: NSRange(location: 0, length: customExpressionVar.count)) {
                    if let range = Range(bracesMatch.range(at: 1), in: customExpressionVar) {
                        let placeholder = String(customExpressionVar[range])
                        customExpressionVar = customExpressionVar.replacingOccurrences(of: "{${\(placeholder)}}", with: concatenatedValues)
                    }
                }
                // Check and replace ${...}
                else if let dollarBracesMatch = dollarBracesRegex.firstMatch(in: customExpressionVar, options: [], range: NSRange(location: 0, length: customExpressionVar.count)) {
                    if let range = Range(dollarBracesMatch.range(at: 1), in: customExpressionVar) {
                        let placeholder = String(customExpressionVar[range])
                        customExpressionVar = customExpressionVar.replacingOccurrences(of: "${\(placeholder)}", with: concatenatedValues)
                    }
                }
                // Check and replace $...
                else if let placeholderMatch = placeholderRegex.firstMatch(in: customExpressionVar, options: [], range: NSRange(location: 0, length: customExpressionVar.count)) {
                    if let range = Range(placeholderMatch.range(at: 1), in: customExpressionVar) {
                        let placeholder = String(customExpressionVar[range])
                        customExpressionVar = customExpressionVar.replacingOccurrences(of: "$\(placeholder)", with: concatenatedValues)
                    }
                }
            }
            
        }
        
        do {
            // Arithmetic operations
            if lowercasedExpression.hasPrefix("sum") {
                if let resultSum = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultSum)"
                }
            } else if lowercasedExpression.hasPrefix("subtract") {
                if let resultSubtract = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultSubtract)"
                }
            } else if lowercasedExpression.hasPrefix("multiply") {
                if let resultMultiply = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultMultiply)"
                }
            } else if lowercasedExpression.hasPrefix("divide") {
                if let resultDivide = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultDivide)"
                }
            } else if lowercasedExpression.hasPrefix("min") {
                if let resultMin = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultMin)"
                }
            } else if lowercasedExpression.hasPrefix("max") {
                if let resultMax = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultMax)"
                }
            } else if lowercasedExpression.hasPrefix("average") {
                if let resultAverage = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Double {
                    finalResult = "\(resultAverage)"
                }
            }
            
            // DateTime operations
            else if lowercasedExpression.hasPrefix("adddays") || lowercasedExpression.hasPrefix("addmonths") || lowercasedExpression.hasPrefix("addweeks") {
                if let resultDate = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    finalResult = dateFormatter.string(from: resultDate)
                }
            } else if lowercasedExpression.hasPrefix("formatdatetime") {
                if let resultFormatted = try engine.evaluate(formula: customExpressionVar, variables: variables) as? String {
                    finalResult = resultFormatted
                }
            } else if lowercasedExpression.hasPrefix("daysbetween") {
                if let resultDaysBetween = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Int {
                    finalResult = "\(resultDaysBetween)"
                }
            }
            
            // Text operations
            else if lowercasedExpression.hasPrefix("concatenate") {
                if let resultConcat = try engine.evaluate(formula: customExpressionVar, variables: variables) as? String {
                    finalResult = resultConcat
                }
            } else if lowercasedExpression.hasPrefix("toupper") {
                if let resultToUpper = try engine.evaluate(formula: customExpressionVar, variables: variables) as? String {
                    finalResult = resultToUpper
                }
            } else if lowercasedExpression.hasPrefix("tolower") {
                if let resultToLower = try engine.evaluate(formula: customExpressionVar, variables: variables) as? String {
                    finalResult = resultToLower
                }
            } else if lowercasedExpression.hasPrefix("replace") {
                if let resultReplace = try engine.evaluate(formula: customExpressionVar, variables: variables) as? String {
                    finalResult = resultReplace
                }
            } else if lowercasedExpression.hasPrefix("trim") {
                if let resultTrim = try engine.evaluate(formula: customExpressionVar, variables: variables) as? String {
                    finalResult = resultTrim
                }
            } else if lowercasedExpression.hasPrefix("contains") {
                if let resultContains = try engine.evaluate(formula: customExpressionVar, variables: variables) as? Bool {
                    finalResult = "\(resultContains)"
                }
            }
        } catch {
            print("Error evaluating formula: \(error)")
            return nil
        }
        
        return finalResult
    }
    
    func handleMultiFieldsOperationsOld(customExpression: String, values: [String])
    -> String?
    {
        print("custom express \(customExpression)")
        var finalResult = ""
        print("values = ", values)
        
        // Parse the date values
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        // $0.getDateFromString(dateFormatter: format)
        let dateValues = values.compactMap { /*parseDate(from: $0)*/
            $0.getDateFromString(dateFormatter: format)
        }
        let pattern =
        #"^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}) \- (\d{4}-\d{2}-\d{2} \d{2}:\d{2})$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let matches = regex?.matches(
            in: customExpression, options: [],
            range: NSRange(location: 0, length: customExpression.utf16.count))
        
        if let match = matches?.first, match.numberOfRanges == 3 {
            let firstRange = match.range(at: 1)
            let secondRange = match.range(at: 2)
            let firstDateString = (customExpression as NSString).substring(
                with: firstRange)
            let secondDateString = (customExpression as NSString).substring(
                with: secondRange)
            
            if let firstDate = parseDate(from: firstDateString),
               let secondDate = parseDate(from: secondDateString)
            {
                let interval = firstDate.timeIntervalSince(secondDate)
                finalResult = "\(Int(interval / 60 / 60 / 24))"
            }
        } else if !dateValues.isEmpty {
            let dateFormatter = DateFormatter()
            
            for date in dateValues {
                // Extract the hour, minute, and second components from the date
                let components = Calendar.current.dateComponents(
                    [.hour, .minute, .second], from: date)
                if components.hour != 0 || components.minute != 0
                    || components.second != 0
                {
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                }
            }
            if customExpression.hasPrefix("min") {
                if let minDate = dateValues.min() {
                    finalResult = dateFormatter.string(from: minDate)
                }
            } else if customExpression.hasPrefix("max") {
                if let maxDate = dateValues.max() {
                    finalResult = dateFormatter.string(from: maxDate)
                }
            } else if customExpression.hasPrefix("sum") {
                // Summing dates doesn't make sense, but you can return a sum of intervals
                let totalInterval = dateValues.reduce(0.0) {
                    $0 + $1.timeIntervalSinceReferenceDate
                }
                let summedDate = Date(
                    timeIntervalSinceReferenceDate: totalInterval)
                finalResult = dateFormatter.string(from: summedDate)
            } else if customExpression.hasPrefix("sub") {
                // Subtraction: Return the interval between the first and last dates
                if let firstDate = dateValues.first,
                   let lastDate = dateValues.last
                {
                    let interval = lastDate.timeIntervalSince(firstDate)
                    finalResult = "\(interval)"
                }
            }
        } else {
            // Handle integer values (existing logic)
            let intValues = values.map { Double($0) ?? 0.0 }
            if customExpression.lowercased().hasPrefix("sum") {
                finalResult = "\(intValues.reduce(0.0, +))"
            } else if customExpression.lowercased().hasPrefix("min") {
                finalResult = "\(intValues.min() ?? 0)"
            } else if customExpression.lowercased().hasPrefix("max") {
                finalResult = "\(intValues.max() ?? 0)"
            }
        }
        
        return finalResult
    }
    
    func handleMultiFieldsOperationsWrapper(customExpression: String, values: [String]?, isTable: Bool) -> String? {
        // Attempt to use the new implementation
        if (customExpression.contains("$") == false) && (isTable ) {
            if let values = values {
                return handleMultiFieldsOperationsOld(customExpression: customExpression, values: values)
            }
        }
        if let result = handleMultiFieldsOperations(customExpression: customExpression, values: values) {
            return result
        }
        return nil
    }
    
    /// Extract table's controls to apply equation on each of them separately
    /// - Parameters:
    ///   - id: current control id
    ///   - fieldID: fieldId mentioned in the equation
    ///   - equation: current equation
    ///   - values: calculated values for each control
    /// - Returns: returned equation to be calculated in getResultFromEquation function
    func extractTableItems(
        id: String, fieldID: String, equation: inout String,
        values: inout [String]
    ) -> String {
        if let item = self.sectionObjects.first(where: { $0.id == id })?.items
            .first as? FormViewModelTableItem
        {
            if editAt.delete {  // for delete row
                if !item.items.isEmpty {
                    for (_, children) in item.items.enumerated() {
                        if let child = children.first(where: {
                            $0.fieldId == fieldID
                        }) {
                            // update equation and return it
                            var fieldValue: [String]?
                            self.getItemValue(child, &fieldValue)
                            if let value = fieldValue?.first {
                                values.append(value)
                            }
                        }
                    }
                }
                
            } else {  // for adding new row when table contains other rows
                if !item.items.isEmpty {
                    for (index, children) in item.items.enumerated() {
                        if !editAt.edit || (editAt.edit && index != editAt.at) {
                            if let child = children.first(where: {
                                $0.fieldId == fieldID
                            }) {
                                // update equation and return it
                                var fieldValue: [String]?
                                self.getItemValue(child, &fieldValue)
                                if let value = fieldValue?.first {
                                    values.append(value)
                                }
                            }
                            // to be tested
                        } else if editAt.edit {
                            if let child = children.first(where: {
                                $0.fieldId == fieldID
                            }) {
                                // update equation and return it
                                var fieldValue: [String]?
                                self.getItemValue(child, &fieldValue)
                                if let value = fieldValue?.first {
                                    values.append(value)
                                }
                            }
                        }
                    }
                }
                // for adding new row in a new table (table without row) or editing row
                let children = item.childControls
                if let child = children.first(where: { $0.fieldId == fieldID })
                {
                    // update equation and return it
                    var fieldValue: [String]?
                    self.getItemValue(child, &fieldValue)
                    if let value = fieldValue?.first {
                        //                        values.append(value)
                        equation = equation.replacingOccurrences(
                            of: "{\(fieldID)}", with: "\(value)")
                    } else {
                        equation = equation.replacingOccurrences(
                            of: "{\(fieldID)}", with: "0")
                    }
                }
            }
        }
        return equation
    }
}
