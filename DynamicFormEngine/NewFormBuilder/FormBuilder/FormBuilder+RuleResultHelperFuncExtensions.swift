//
//  FormBuilder+RuleResultHelperFuncExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 25/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

internal import Alamofire
internal import Expression
import Foundation
internal import ObjectMapper
internal import RxCocoa
internal import RxSwift
import UIKit


extension FormBuilder {
    
     func handleSetPropertyCase(_ action: DoAction, _ result: (Bool, ActionType), _ itemIndex: Int, _ removeAnswer: Bool) {
        // Implementation specific to SetProperty case
        // The logic here can be broken down further if needed
        if result.0 {
            let payload = action.payload as? [String:Any?]
            var fieldValue: [String]?
            for id in action.sourceFieldsIds ?? [] {
                if let x = itemsDict[id] {
                    self.getItemValue(x.0, &fieldValue)
                }
            }
            if let interActiveItem = formViewModel.items[itemIndex] as? FormViewModelInteractiveItem {
                if let isExternal = payload?["isExternal"] as? Bool, isExternal == false {
                    formViewModel.items[itemIndex] = updateItemProperty(item: interActiveItem, value: fieldValue, payload: payload?["targetPropertyName"] as? String ?? "")
                    
                }else {
                    // new impl
                    currentPropertyTragetName = ""
                    setSelfControlCascading(action: action)
                    let pl = Payload(id: payload?["id"] as? String ?? "",
                                     parameters: payload?["parameters"] as? [String])
                    currentPropertyTragetName = payload?["targetPropertyName"] as? String ?? ""
                    handleCascading(targetFieldIds: action.targetFieldsIds,
                                    sourceFieldsIds: action.sourceFieldsIds,
                                    payload: pl,
                                    itemIndex: itemIndex,
                                    reload: true,
                                    action: action)
                }
                if removeAnswer {
                    if let tableItem = formViewModel.items[itemIndex] as? FormViewModelTableItem {
                        self.isRuleViolated = false
                        allRowsChildControls.removeAll()
                        tableItem.items.removeAll()
                        reloadAt?(itemIndex,nil, nil)
                    }else {
                        formViewModel.items[itemIndex].answer = nil
                        clearFieldValue(itemIndex: itemIndex)
                    }
                    
                }
            }
        }
    }
    
    func reloadItem(_ itemIndex: Int) {
        DispatchQueue.main.async {
            let fieldIdToCompare = self.formViewModel.items[itemIndex].fieldId
            if self.isNestedForm {
                for formItem in self.sectionObjects {
                    if let tableComponent = formItem.items[0] as? FormViewModelTableItem {
                        if !tableComponent.childControls.isEmpty {
                            if let matchingIndex = tableComponent
                                .childControls.firstIndex(where: {$0.fieldId == fieldIdToCompare}) {
                                self.reloadAtNested?(
                                    matchingIndex,
                                    self.formViewModel.items[itemIndex]
                                        .answer)
                            } else {
                                if let matchingIndex = self.sectionObjects
                                    .firstIndex(where: {
                                        $0.id == fieldIdToCompare
                                    })
                                {
                                    self.reloadAt?(
                                        matchingIndex,
                                        self.formViewModel.items[itemIndex]
                                            .answer,  self.formViewModel.items[itemIndex].fieldId)
                                } else {
                                    for (sectionIndex, section) in self
                                        .sectionObjects.enumerated()
                                    {
                                        if let itemIndex = section.items
                                            .firstIndex(where: {
                                                $0.fieldId
                                                == fieldIdToCompare
                                            })
                                        {
                                            // Call reloadAt with both sectionIndex and itemIndex
                                            self.reloadAt?(
                                                sectionIndex,
                                                self.formViewModel.items[
                                                    itemIndex
                                                ].answer,  self.formViewModel.items[itemIndex].fieldId)
                                        } else {
                                            print(
                                                "No matching fieldId found in sectionObjects"
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if let matchingIndex = self.sectionObjects.firstIndex(
                    where: { $0.id == fieldIdToCompare })
                {
                    self.reloadAt?(
                        matchingIndex,
                        self.formViewModel.items[itemIndex].answer,  self.formViewModel.items[itemIndex].fieldId)
                } else {
                    for (sectionIndex, section) in self.sectionObjects
                        .enumerated()
                    {
                        if let itemIndex = section.items.firstIndex(where: {
                            $0.fieldId == fieldIdToCompare
                        }) {
                            // Call reloadAt with both sectionIndex and itemIndex
                            self.reloadAt?(
                                sectionIndex,
                                self.formViewModel.items[itemIndex].answer,  self.formViewModel.items[itemIndex].fieldId)
                        } else {
                            print(
                                "No matching fieldId found in sectionObjects"
                            )
                        }
                    }
                }
            }
        }
    }
    
    func handleValidationRule(payload: AnyObject?, sourceFieldsIds: [String]?) {
        if let payload = payload as? String {
            var signSeparatorArr =  payload.components(separatedBy:"$")
            signSeparatorArr.removeFirst()
            let signCount = signSeparatorArr.count
            
            if signCount == 1 {
                handleSingleUniqueValidation(arr: signSeparatorArr)
            }else if signCount > 1 {
                handleMultiUniqueValidations(arr: signSeparatorArr,
                                             sourceFieldsIds: sourceFieldsIds)
            }
        }
    }
    
    func handleSingleUniqueValidation(arr: [String]) {
        var childrenAnswers = [Any?]()
        for child in allRowsChildControls {
            for column in arr {
                if let id = column.getStringWithinTwoBrackets("{", "}") {
                    
                    if id == child.fieldId {
                        
                        if let ans = child.answer as? TextboxAnswer {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? TextboxAnswer)?.value == ans.value {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }else if let ans = child.answer as? BaseAnswerText {
                            
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? BaseAnswerText)?.value == (child.answer as? BaseAnswerText)?.value {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        //                                        break
                                    }
                                }
                            }else {
                            }
                        }else if let ans = child.answer as? DateTimeAnswer {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? DateTimeAnswer)?.value == ans.value &&  (childrenAnswer as? DateTimeAnswer)?.timeValues != ans.timeValues {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }else if let ans = child.answer as? BaseAnswerMCQ {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? BaseAnswerMCQ)?.value == ans.value {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }else if let ans = child.answer as? TextAreaAnswer {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? TextAreaAnswer)?.value == ans.value {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }else if let ans = child.answer as? ParagraphAnswer {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? ParagraphAnswer)?.value == ans.value {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }else if let ans = child.answer as? Bool {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? Bool) == ans {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }else if let ans = child.answer as? SwitchAnswer {
                            if childrenAnswers.count > 0 {
                                for childrenAnswer in childrenAnswers {
                                    if (childrenAnswer as? SwitchAnswer)?.value == ans.value {
                                        isRuleViolated = true
                                        return
                                    }else {
                                        isRuleViolated = false
                                        childrenAnswers.append(ans)
                                    }
                                }
                            }else {
                                childrenAnswers.append(ans)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func handleMultiUniqueValidations(arr: [String], sourceFieldsIds: [String]?) {
        var tableAnswersArr = [[Any?]]()
        if let tableItem = formViewModel.items.first(where: {$0.fieldId == sourceFieldsIds?.first}) as? FormViewModelTableItem {
            for items in tableItem.items {
                tableAnswersArr.append(items.map({$0.answer}))
            }
        }
        guard tableAnswersArr.count >= 1 else { return }
        var currentAnswersArr = [(Any?,FieldType?)]()
        for column in arr {
            
            if let id = column.getStringWithinTwoBrackets("{", "}") {
                let currentColumn = allRowsChildControls.filter({$0.fieldId == id}).last
                currentAnswersArr.append((currentColumn?.answer,currentColumn?.type))
            }
        }
        
        for tableAnswer in tableAnswersArr {
            if areArraysEqual(tableAnswer, currentAnswersArr) {
                isRuleViolated = true
                return
            }
        }
        isRuleViolated = false
    }
    
    
    func areArraysEqual(_ array1: [Any], _ array2: [(Any?,FieldType?)]) -> Bool {
        for (element1, element2) in zip(array1, array2) {
            
            // Try casting each element as `Equatable` and compare
            if let e1 = element1 as? TextboxAnswer, let e2 = element2.0 as? TextboxAnswer {
                if e1.value != e2.value { return false }
            }else if let e1 = element1 as? BaseAnswerText, let e2 = element2.0 as? BaseAnswerText {
                if e1.value != e2.value { return false }
            }else if let e1 = element1 as? DateTimeAnswer, let e2 = element2.0 as? DateTimeAnswer {
                if e1.value != e2.value || e1.timeValues != e2.timeValues { return false }
            }else if let e1 = element1 as? BaseAnswerMCQ, let e2 = element2.0 as? BaseAnswerMCQ {
                if e1.value != e2.value { return false }
            }else if let e1 = element1 as? TextAreaAnswer, let e2 = element2.0 as? TextAreaAnswer {
                if e1.value != e2.value { return false }
                
                
            }else if let e1 = element1 as? ParagraphAnswer, let e2 = element2.0 as? ParagraphAnswer {
                if e1.value != e2.value { return false }
            }else if let e1 = element1 as? Bool, let e2 = element2.0 as? Bool {
                if e1 != e2 { return false }
            }else if let e1 = element1 as? SwitchAnswer, let e2 = element2.0 as? SwitchAnswer {
                if e1.value != e2.value { return false }
            }else {
                // If elements aren't comparable,
                switch element2.1 {
                case .TextBox:
                    
                    if element1 as? TextboxAnswer == nil && element2.0 as? TextboxAnswer == nil {
                    }else {
                        return false
                    }
                case .Numerical:
                    
                    if element1 as? BaseAnswerText == nil && element2.0 as? BaseAnswerText == nil {
                    }else {
                        return false
                    }
                case .Date:
                    if element1 as? DateTimeAnswer == nil && element2.0 as? DateTimeAnswer == nil {
                    }else {
                        return false
                    }
                case .TextArea:
                    if element1 as? TextAreaAnswer == nil && element2.0 as? TextAreaAnswer == nil {
                    }else {
                        return false
                    }
                case .Paragraph:
                    if element1 as? ParagraphAnswer == nil && element2.0 as? ParagraphAnswer == nil {
                        if element1 as? Bool == nil && element2.0 as? Bool == nil {
                        }else {
                            return false
                        }
                    }else {
                        return false
                    }
                case .switchControl:
                    if element1 as? SwitchAnswer == nil && element2.0 as? SwitchAnswer == nil {
                    }else {
                        return false
                    }
                case .Checkbox, .Radio, .Dropdown:
                    if element1 as? BaseAnswerMCQ == nil && element2.0 as? BaseAnswerMCQ == nil {
                    }else {
                        return false
                    }
                case .none:
                    if element1 as? TextboxAnswer == nil && element2.0 as? TextboxAnswer == nil {
                    }else if element1 as? BaseAnswerText == nil && element2.0 as? BaseAnswerText == nil {
                    }else if element1 as? DateTimeAnswer == nil && element2.0 as? DateTimeAnswer == nil {
                    }else if element1 as? TextAreaAnswer == nil && element2.0 as? TextAreaAnswer == nil {
                    }else if element1 as? ParagraphAnswer == nil && element2.0 as? ParagraphAnswer == nil {
                        if element1 as? Bool == nil && element2.0 as? Bool == nil {
                        }else {
                            return false
                        }
                    }else if element1 as? SwitchAnswer == nil && element2.0 as? SwitchAnswer == nil {
                    }else if element1 as? BaseAnswerMCQ == nil && element2.0 as? BaseAnswerMCQ == nil {
                    }else {
                        return false
                    }
                case .some(.Page):
                    return false
                case .some(.Section):
                    return false
                case .some(.Label):
                    return false
                case .some(.Submit):
                    return false
                case .some(.Map):
                    return false
                case .some(.Location):
                    return false
                case .some(.Slider):
                    return false
                case .some(.NPS):
                    return false
                case .some(.Rate):
                    return false
                case .some(.FaceRate):
                    return false
                case .some(.Table):
                    return false
                case .some(.FileUpload):
                    return false
                }
            }
        }
        return true
    }
    
    func updateItemProperty(item: FormViewModelInteractiveItem, value: [String]?, payload: String) -> FormViewModelInteractiveItem {
        if let properties = item.field?.properties as? TextBoxProperties {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? NumberProperties {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? TextAreaProperties
        {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? DateTimeProperties
        {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? CheckboxProperties
        {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? RadioProperties {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? DropdownProperties
        {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties
                    as? FileUploadProperties
        {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        } else if let properties = item.field?.properties as? TableProperties {
            properties.updateProperty(
                propertyName: payload, newValue: value?.first ?? "")
        }
        return item
    }
    
    func passMinMaxDates(
        targetFieldIds: [String]?, sourceFieldsIds: [String]?,
        payload: inout Payload, itemIndex: Int, reload: Bool
    ) {
        var multiAnswers = [[String: String]]()
        var parameters: [String] = []
        
        let currentItem = formViewModel.items.first(where: {
            $0.fieldId == sourceFieldsIds?.first
        })
        
        for (index, sourceFieldsId) in (sourceFieldsIds ?? []).enumerated() {
            if payload.parameters?.isEmpty ?? false {
                // Create parameters with sourceFieldId
                let sourceFieldId = sourceFieldsId
                parameters.append("from={\(sourceFieldId)}")
                parameters.append("to={\(sourceFieldId)}")
                let originalPayload = Payload(id: nil, parameters: parameters)
                payload = originalPayload
            }
            
            if let parentItem = formViewModel.items.first(where: {
                $0.fieldId == sourceFieldsId
            }),
               let dateItem = parentItem as? FormViewModelDateItem,
               let dateAnswer = dateItem.answer as? DateTimeAnswer
            {
                
                for (parentAnswerIndex, parentAnswer)
                        in (dateAnswer.value ?? []).enumerated()
                {
                    for (paramIndex, param) in (payload.parameters ?? [])
                        .enumerated()
                    {
                        if parentAnswerIndex == paramIndex {
                            let fullParam = param.replace(
                                target: param.getStringWithinTwoBrackets(
                                    "{", "}") ?? "", withString: parentAnswer)
                            let fullParamArr = fullParam.components(
                                separatedBy: "=")
                            let key = fullParamArr.first ?? ""
                            var val = fullParamArr.last ?? ""
                            val = val.replace(target: "{", withString: "")
                            val = val.replace(target: "}", withString: "")
                            multiAnswers.insert([key: val], at: index)
                        }
                    }
                }
            }
        }
        
        // Loop through all target field IDs
        if let targetFieldIds = targetFieldIds {
            for targetItemId in targetFieldIds {
                if let targetItemIndex = formViewModel.items.firstIndex(where: {
                    $0.fieldId == targetItemId
                }),
                   let targetItem = formViewModel.items[targetItemIndex]
                    as? FormViewModelDateItem
                {
                    
                    // Update the date properties if multiAnswers is not empty
                    if !multiAnswers.isEmpty {
                        for answer in multiAnswers {
                            if let key = answer.keys.first,
                               let value = answer.values.first
                            {
                                if key == "from" {
                                    targetItem.dateProperties?.minimumDate =
                                    value
                                } else if key == "to" {
                                    targetItem.dateProperties?.maximumDate =
                                    value
                                }
                            }
                        }
                        // Replace the target item in formViewModel.items
                        targetItem.answer = nil
                        formViewModel.items[targetItemIndex] = targetItem
                    }
                }
            }
        }
    }
    
    /// Clear field value in this index
    /// - Parameter itemIndex: current control index
    func clearFieldValue(itemIndex: Int) {
        formViewModel.items[itemIndex].answer = nil
        if let sectionIndex = self.sectionObjects.firstIndex(where: {
            $0.items.contains(where: {
                $0.fieldId == self.formViewModel.items[itemIndex].fieldId
            })
        }) {
            self.reloadAt?(sectionIndex, nil,  self.formViewModel.items[itemIndex].fieldId)
        } else {
            for section in self.sectionObjects {
                for item in section.items {
                    if let item = item as? FormViewModelTableItem {
                        let children = item.childControls
                        if let sectionIndex = children.firstIndex(where: {
                            $0.fieldId
                            == self.formViewModel.items[itemIndex].fieldId
                        }) {
                            self.reloadAt?(
                                sectionIndex,
                                self.formViewModel.items[itemIndex].answer,  self.formViewModel.items[itemIndex].fieldId)
                        }
                    }
                }
            }
        }
    }
    
    func extractFieldID(from parameter: String) -> String? {
        let pattern = "\\{([^{}]+)\\}"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(
            in: parameter,
            range: NSRange(parameter.startIndex..., in: parameter))
        {
            if let range = Range(match.range(at: 1), in: parameter) {
                return String(parameter[range])
            }
        }
        return nil
    }
    
    // Filter parameters
    /// Handling calculate rule
    /// - Parameters:
    ///   - equation: equation in the rule
    ///   - itemIndex: current control index
    ///   - reload: reload tableView or not
    func handleRelationEquation(equation: String, itemIndex: Int, reload: Bool)
    {
        getResultFromEquation(
            equation: equation,
            { [weak self] finalResult in
                
                guard let `self` = self else { return }
                guard itemIndex < self.formViewModel.items.count else { return }
                if let final = finalResult {
                    if self.formViewModel.items[itemIndex]
                        is FormViewModelTextBoxItem
                    {
                        if final == "0.0" {
                            self.formViewModel.items[itemIndex].answer = nil
                        } else {
                            self.formViewModel.items[itemIndex].isUpdated = true
                            self.formViewModel.items[itemIndex].answer =
                            TextboxAnswer(val: final)
                        }
                    } else if self.formViewModel.items[itemIndex]
                                is FormViewModelNumericItem
                    {
                        if final == "0.0" {
                            self.formViewModel.items[itemIndex].answer = nil
                        } else {
                            self.formViewModel.items[itemIndex].isUpdated = true
                            self.formViewModel.items[itemIndex].answer =
                            BaseAnswerText(val: final)
                        }
                    } else if self.formViewModel.items[itemIndex]
                                is FormViewModelParagraphItem
                    {
                        if final == "0.0" {
                            self.formViewModel.items[itemIndex].answer = nil
                        } else {
                            self.formViewModel.items[itemIndex].answer =
                            ParagraphAnswer(val: final)
                        }
                    } else if self.formViewModel.items[itemIndex]
                                is FormViewModelDateItem
                    {
                        if final == "" {
                            self.formViewModel.items[itemIndex].answer = nil
                        } else {
                            if final.contains(" ") {
                                // The string contains both date and time
                                let dateComponents = final.split(separator: " ")
                                if let date = dateComponents.first,
                                   let time = dateComponents.last
                                {
                                    // Append the date to `val`
                                    let dateString = String(date)
                                    let timeString = String(time)
                                    let ans = DateTimeAnswer(
                                        val: [dateString],
                                        timeValues: [timeString], lNote: nil,
                                        lAttachments: nil, type: .Gregorian)
                                    self.formViewModel.items[itemIndex].answer =
                                    ans
                                }
                            } else {
                                // The string contains only the date
                                let ans = DateTimeAnswer(
                                    val: [final], timeValues: [], lNote: nil,
                                    lAttachments: nil, type: .Gregorian)
                                self.formViewModel.items[itemIndex].answer = ans
                            }
                        }
                    }
                    
                    if reload {  // reload main form
                        if let sectionIndex = self.sectionObjects.firstIndex(
                            where: {
                                $0.items.contains(where: {
                                    $0.fieldId
                                    == self.formViewModel.items[itemIndex]
                                        .fieldId
                                })
                            })
                        {
                            self.reloadAt?(
                                sectionIndex,
                                self.formViewModel.items[itemIndex].answer,  self.formViewModel.items[itemIndex].fieldId)
                        } else {  // reload nested form
                            for section in self.sectionObjects {
                                for item in section.items {
                                    if let item = item
                                        as? FormViewModelTableItem
                                    {
                                        let children = item.childControls
                                        if let sectionIndex =
                                            children.firstIndex(where: {
                                                $0.fieldId
                                                == self.formViewModel.items[
                                                    itemIndex
                                                ].fieldId
                                            })
                                        {
                                            self.reloadAtNested?(
                                                sectionIndex,
                                                self.formViewModel.items[
                                                    itemIndex
                                                ].answer)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
    }
}
