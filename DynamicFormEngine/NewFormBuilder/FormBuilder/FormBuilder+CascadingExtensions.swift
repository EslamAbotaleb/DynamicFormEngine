//
//  FormBuilder+CascadingExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 26/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

internal import Alamofire
internal import Expression
import Foundation

internal import RxCocoa
internal import RxSwift
import UIKit

extension FormBuilder {
    
    func setSelfControlCascading(action: DoAction) {
        self.cascadingSourceIDs = action.sourceFieldsIds
        var payloadId = ""
        
        // Extract ID from payload
        if let payloadArray = action.payload as? [String: AnyObject] {
            if let idValue = payloadArray["id"] as? String {
                print("ID inside payload: \(idValue)")
                payloadId = idValue
            } else {
                print("ID not found in payload")
            }
        } else {
            print("Payload format is incorrect")
        }
        
        // Create a Set to keep track of unique combinations
        var uniqueComponents = Set<String>()
//        var targetComponentsForAppend = [[String: String?]]()
//        targetComponentsForAppend = []
        var componentToAppend: [String: String?] = [:]
        
        // Iterate through target IDs
        for targetId in action.targetFieldsIds ?? [] {
            if let currentItem = formViewModel.items.first(where: {
                $0.fieldId == targetId
            }) {
                let id = currentItem.fieldId ?? ""
                let parentId = currentItem.parentId
                let rowIndex = "\(self.currentNestedRowIdx ?? "1")"
                
                // Create a unique key based on id, parentId, and rowIndex
                var uniqueKey = id
                if let parentId = parentId {
                    uniqueKey += "|\(parentId)|\(rowIndex)"
                }
                
                // Check if the unique key is already in the Set
                if !uniqueComponents.contains(uniqueKey) {
                    uniqueComponents.insert(uniqueKey)  // Add the unique key to the Set
                    
                    var component: [String: String?] = [
                        "id": id,
                        "name": currentItem.label ?? "",
                        "type": currentItem.type?.rawValue,
                        "code": payloadId
                    ]
                    
                    if let parentId = parentId {
                        component["parentId"] = parentId
                        component["rowIndex"] = rowIndex
                        if formSectionDictionary[parentId] != nil {
                            component["sectionItem"] = "true"
                        }else {
                            component["sectionItem"] = "false"
                        }
                    }
                    
                    // Add the unique component to the list
//                    targetComponentsForAppend.append(component)
                    componentToAppend = component
                }
            }
        }
        // Update target components
        var allTargetComponents = self.targetComponents.value
        allTargetComponents.append(componentToAppend)
        self.targetComponents.accept(allTargetComponents)
    }
    
    func setSelfControlCascadingForSameControl(
        item: FormViewModelItem, itemIdx: String? = "1"
    ) {
        var targetComponents = [[String: String?]]()
        if item.parentId != nil && !(item.isSectionItem ?? false) {
            targetComponents.append(["id": item.fieldId ?? "",
                                     "name": item.label ?? "",
                                     "type": item.type?.rawValue,
                                     "parentId": item.parentId,
                                     "rowIndex": itemIdx])
        } else if item.parentId != nil {
            targetComponents.append(["id": item.fieldId ?? "",
                                     "name": item.label ?? "",
                                     "type": item.type?.rawValue,
                                     "parentId": item.parentId])
        } else {
            targetComponents.append(["id": item.fieldId ?? "",
                                     "name": item.label ?? "",
                                     "type": item.type?.rawValue
                                    ])
        }
        self.targetComponents.accept(targetComponents)
    }
    
    func appendSelfControlCascadingforItems(
        items: [FormViewModelItem], itemIdx: String? = "1"
    ) {
        // Retrieve the current value of `targetComponents`
        var currentComponents = [[String: String?]]()
        
        // Iterate over each item in the array
        for item in items {
            var newComponent = [String: String?]()
            
            if item.parentId != nil && !(item.isSectionItem ?? false) {
                newComponent = [
                    "id": item.fieldId ?? "",
                    "name": item.label ?? "",
                    "type": item.type?.rawValue,
                    "parentId": item.parentId,
                    "rowIndex": itemIdx
                ]
            } else if item.parentId != nil {
                newComponent = [
                    "id": item.fieldId ?? "",
                    "name": item.label ?? "",
                    "type": item.type?.rawValue,
                    "parentId": item.parentId
                ]
            } else {
                newComponent = [
                    "id": item.fieldId ?? "",
                    "name": item.label ?? "",
                    "type": item.type?.rawValue
                ]
            }
            // Append the new component to the current components
            currentComponents.append(newComponent)
        }
        // Update `targetComponents` with the new array
        self.targetComponents.accept(currentComponents)
    }
    
    func getDataSourceParameters(dataSourceId: String, currentId: String, parameters: [String]?) -> [[String: String]] {
        var itemIndex = 0
        if let x = itemsDict[currentId] {
            itemIndex = x.1
        }
        var multiAnswers = [[String: String]]()
        
        if parameters?.count ?? 0 > 0 {
            
            for (paramIndex, param) in (parameters ?? []).enumerated() {
                if !param.contains("{") {
                    let fullParamArr = param.components(separatedBy: "=")
                    let key = fullParamArr.first ?? ""
                    var val = fullParamArr.last ?? ""
                    multiAnswers.append([key: val])
                } else {
                    if let parentItem = formViewModel.items.first(where: {
                        $0.fieldId == param.getStringWithinTwoBrackets("{", "}")
                    }) {
                        if let dropDownItem = parentItem as? FormViewModelDropdownItem {
                            if let dropDownAnswer = dropDownItem.answer as? BaseAnswerMCQ {
                                let parentAnswer =
                                dropDownAnswer.value?.first?.id ?? ""
                                if param.getStringWithinTwoBrackets(
                                    "{", "}") == parentItem.fieldId
                                {
                                    let fullParam = param.replace(
                                        target:
                                            param.getStringWithinTwoBrackets(
                                                "{", "}") ?? "",
                                        withString: parentAnswer)
                                    let fullParamArr = fullParam.components(
                                        separatedBy: "=")
                                    let key = fullParamArr.first ?? ""
                                    var val = fullParamArr.last ?? ""
                                    val = val.replace(
                                        target: "{", withString: "")
                                    val = val.replace(
                                        target: "}", withString: "")
                                    //                                        for targetId in targetFieldIds ?? [] {
                                    if let currentItem = formViewModel
                                        .items.first(where: {
                                            $0.fieldId == currentId
                                        })
                                    {
                                        if let item = currentItem
                                            as? FormViewModelDropdownItem
                                        {
                                            if item.ddlSubType == "Search"
                                            {
                                                searchComponents.accept(
                                                    [dataSourceId: [key: val]])
                                            }
                                        }
                                    }
                                    //                                        }
                                    multiAnswers.append([key: val])
                                    break
                                }
                            } else {
                                searchComponents.accept([dataSourceId: ["": ""]])
                            }
                            
                        } else if let dateItem = parentItem
                                    as? FormViewModelDateItem
                        {
                            if let dateAnswer = dateItem.answer
                                as? DateTimeAnswer
                            {
                                if let parameters = parameters?.filter({ parameter in
                                    if let extractedId = extractFieldID(from: parameter) {
                                        if let item = formViewModel
                                            .items.first(where: {
                                                ($0
                                                 as? FormViewModelDateItem)?
                                                    .fieldId
                                                == extractedId
                                            })
                                        {
                                            return item
                                            is FormViewModelDateItem
                                        }
                                    }
                                    return false
                                }) {
                                    for (_, parentAnswer) in (dateAnswer.value?.filter {$0 != ""} ?? []).enumerated() {
                                        let originalFormat = "yyyy-MM-dd"
                                        let desiredFormat = "yyyy-MM-dd"
                                        let convertedParentAnswer =
                                        convertDateFormat(
                                            originalDateString:
                                                parentAnswer,
                                            originalFormat:
                                                originalFormat,
                                            desiredFormat: desiredFormat
                                        ) ?? ""
                                        
                                        if param.getStringWithinTwoBrackets(
                                            "{", "}") == parentItem.fieldId
                                        {
                                            let fullParam = param.replace(
                                                target:
                                                    param
                                                    .getStringWithinTwoBrackets(
                                                        "{", "}") ?? "",
                                                withString:
                                                    convertedParentAnswer)
                                            let fullParamArr =
                                            fullParam.components(
                                                separatedBy: "=")
                                            let key =
                                            fullParamArr.first ?? ""
                                            var val =
                                            fullParamArr.last ?? ""
                                            val = val.replace(
                                                target: "{", withString: "")
                                            val = val.replace(
                                                target: "}", withString: "")
                                            
                                            // Convert the value to a Date object for comparison
                                            let dateFormatter =
                                            DateFormatter()
                                            dateFormatter.dateFormat =
                                            "yyyy-MM-dd"
                                            guard
                                                let currentValDate =
                                                    dateFormatter.date(
                                                        from: val)
                                            else { continue }
                                            
                                            if key == "from" {
                                                // Check if a "from" value already exists and compare dates
                                                if let index =
                                                    multiAnswers.firstIndex(
                                                        where: {
                                                            $0.keys
                                                                .contains(
                                                                    key)
                                                        })
                                                {
                                                    if let existingDateStr =
                                                        multiAnswers[index][
                                                            key],
                                                       let existingDate =
                                                        dateFormatter
                                                        .date(
                                                            from:
                                                                existingDateStr
                                                        ),
                                                       currentValDate
                                                        < existingDate
                                                    {
                                                        // Update if the new "from" date is earlier
                                                        multiAnswers[index][
                                                            key] = val
                                                    }
                                                } else {
                                                    // Add the "from" date if it doesn't exist
                                                    multiAnswers.append([
                                                        key: val
                                                    ])
                                                }
                                            } else if key == "to" {
                                                // Check if a "to" value already exists and compare dates
                                                if let index =
                                                    multiAnswers.firstIndex(
                                                        where: {
                                                            $0.keys
                                                                .contains(
                                                                    key)
                                                        })
                                                {
                                                    if let existingDateStr =
                                                        multiAnswers[index][
                                                            key],
                                                       let existingDate =
                                                        dateFormatter
                                                        .date(
                                                            from:
                                                                existingDateStr
                                                        ),
                                                       currentValDate
                                                        > existingDate
                                                    {
                                                        // Update if the new "to" date is later
                                                        multiAnswers[index][
                                                            key] = val
                                                    }
                                                } else {
                                                    // Add the "to" date if it doesn't exist
                                                    multiAnswers.append([
                                                        key: val
                                                    ])
                                                }
                                            } else {
                                                multiAnswers.append([
                                                    key: val
                                                ])
                                            }
                                        }
                                    }
                                }
                            }
                        } else if let paragraphItem = parentItem
                                    as? FormViewModelParagraphItem
                        {
                            if let paragraphAnswer = paragraphItem.answer
                                as? ParagraphAnswer
                            {
                                let parentAnswer =
                                paragraphAnswer.value ?? ""
                                
                                if let params = parameters, !params.isEmpty {
                                    if param.getStringWithinTwoBrackets("{", "}") == parentItem.fieldId {
                                        let fullParam = param.replace(
                                            target:
                                                param
                                                .getStringWithinTwoBrackets(
                                                    "{", "}") ?? "",
                                            withString: parentAnswer)
                                        let fullParamArr =
                                        fullParam.components(
                                            separatedBy: "=")
                                        let key = fullParamArr.first ?? ""
                                        var val = fullParamArr.last ?? ""
                                        val = val.replace(
                                            target: "{", withString: "")
                                        val = val.replace(
                                            target: "}", withString: "")
                                        multiAnswers.append([key: val])
                                        break
                                    }
                                } else {
                                    cascadingComponents.accept([
                                        itemIndex: [dataSourceId: [:]]
                                    ])
                                }
                            } else {
                                cascadingComponents.accept([
                                    itemIndex: [dataSourceId: [:]]
                                ])
                            }
                        } else if let numericItem = parentItem
                                    as? FormViewModelNumericItem
                        {
                            if let numericAnswer = numericItem.answer
                                as? BaseAnswerText
                            {
                                let parentAnswer = numericAnswer.value ?? ""
                                if let params = parameters,
                                   !params.isEmpty
                                {
                                    if param.getStringWithinTwoBrackets(
                                        "{", "}") == parentItem.fieldId
                                    {
                                        let fullParam = param.replace(
                                            target:
                                                param
                                                .getStringWithinTwoBrackets(
                                                    "{", "}") ?? "",
                                            withString: parentAnswer)
                                        let fullParamArr =
                                        fullParam.components(
                                            separatedBy: "=")
                                        let key = fullParamArr.first ?? ""
                                        var val = fullParamArr.last ?? ""
                                        val = val.replace(
                                            target: "{", withString: "")
                                        val = val.replace(
                                            target: "}", withString: "")
                                        multiAnswers.append([key: val])
                                        break
                                    }
                                } else {
                                    cascadingComponents.accept([itemIndex: [dataSourceId: [:]]])
                                }
                            } else {
                                cascadingComponents.accept([itemIndex: [dataSourceId: [:]]])
                            }
                        } else if let textItem = parentItem
                                    as? FormViewModelTextBoxItem
                        {
                            if let textAnswer = textItem.answer
                                as? TextboxAnswer
                            {
                                let parentAnswer = textAnswer.value ?? ""
                                if let params = parameters, !params.isEmpty {
                                    if param.getStringWithinTwoBrackets(
                                        "{", "}") == parentItem.fieldId {
                                        let fullParam = param.replace(target: param.getStringWithinTwoBrackets("{", "}") ?? "", withString: parentAnswer)
                                        let fullParamArr =
                                        fullParam.components(
                                            separatedBy: "=")
                                        let key = fullParamArr.first ?? ""
                                        var val = fullParamArr.last ?? ""
                                        val = val.replace(
                                            target: "{", withString: "")
                                        val = val.replace(
                                            target: "}", withString: "")
                                        multiAnswers.append([key: val])
                                        break
                                    }
                                } else {
                                    cascadingComponents.accept([
                                        itemIndex: [dataSourceId: [:]]
                                    ])
                                }
                            } else {
                                cascadingComponents.accept([
                                    itemIndex: [dataSourceId: [:]]
                                ])
                            }
                        }else {
                            print("no item found")
                        }
                    }
                    //                    }
                }
            }
            return multiAnswers
        } else {
            return multiAnswers
        }
    }
    
    /// Handling cascading rule
    /// - Parameters:
    ///   - targetFieldIds: Fields that will be affected by the rule (rule applied on them) => children fields
    ///   - sourceFieldsIds: Fields that effect in rule (rule depend on them) => parent fields
    ///   - payload: payload related to the rule
    ///   - itemIndex: current control index
    ///   - reload: reload tableView or not
    func handleCascading(targetFieldIds:[String]?,sourceFieldsIds: [String]?,payload: Payload, itemIndex: Int, reload: Bool, action: DoAction) {
        
        self.cascadingSourceIDs = sourceFieldsIds
        
        let id = payload.id ?? ""
        var multiAnswers = [[String: String]]()
        
        if let params = payload.parameters {
            
            for (paramIndex, param) in params.enumerated() {
                if !param.contains("{") {
                    let fullParamArr = param.components(separatedBy: "=")
                    let key = fullParamArr.first ?? ""
                    var val = fullParamArr.last ?? ""
                    multiAnswers.append([key: val])
                } else {
                    for (index, sourceFieldsId) in (sourceFieldsIds ?? [])
                        .enumerated()
                    {
                        if let parentItem = formViewModel.items.first(where: {
                            $0.fieldId == sourceFieldsId
                        }) {
                            if let dropDownItem = parentItem
                                as? FormViewModelDropdownItem
                            {
                                if let dropDownAnswer = dropDownItem.answer
                                    as? BaseAnswerMCQ
                                {
                                    let parentAnswer =
                                    dropDownAnswer.value?.first?.id ?? ""
                                    if param.getStringWithinTwoBrackets(
                                        "{", "}") == parentItem.fieldId
                                    {
                                        let fullParam = param.replace(
                                            target:
                                                param.getStringWithinTwoBrackets(
                                                    "{", "}") ?? "",
                                            withString: parentAnswer)
                                        let fullParamArr = fullParam.components(
                                            separatedBy: "=")
                                        let key = fullParamArr.first ?? ""
                                        var val = fullParamArr.last ?? ""
                                        val = val.replace(
                                            target: "{", withString: "")
                                        val = val.replace(
                                            target: "}", withString: "")
                                        for targetId in targetFieldIds ?? [] {
                                            if let currentItem = formViewModel
                                                .items.first(where: {
                                                    $0.fieldId == targetId
                                                })
                                            {
                                                if let item = currentItem
                                                    as? FormViewModelDropdownItem
                                                {
                                                    if item.ddlSubType
                                                        == "Search"
                                                    {
                                                        searchComponents.accept(
                                                            [id: [key: val]])
                                                    }
                                                }
                                            }
                                        }
                                        multiAnswers.append([key: val])
                                        break
                                    }
                                } else {
                                    searchComponents.accept([id: ["": ""]])
                                }
                                
                            } else if let dateItem = parentItem
                                        as? FormViewModelDateItem
                            {
                                if let dateAnswer = dateItem.answer
                                    as? DateTimeAnswer
                                {
                                    if let parameters = payload.parameters?
                                        .filter({ parameter in
                                            if let extractedId = extractFieldID(
                                                from: parameter)
                                            {
                                                if let item = formViewModel
                                                    .items.first(where: {
                                                        ($0
                                                         as? FormViewModelDateItem)?
                                                            .fieldId
                                                        == extractedId
                                                    })
                                                {
                                                    return item
                                                    is FormViewModelDateItem
                                                }
                                            }
                                            return false
                                        })
                                    {
                                        for (_, parentAnswer)
                                                in (dateAnswer.value?.filter {
                                                    $0 != ""
                                                } ?? []).enumerated()
                                        {
                                            let originalFormat = "yyyy-MM-dd"
                                            let desiredFormat = "dd-MM-yyyy"
                                            let convertedParentAnswer =
                                            convertDateFormat(
                                                originalDateString:
                                                    parentAnswer,
                                                originalFormat:
                                                    originalFormat,
                                                desiredFormat: desiredFormat
                                            ) ?? ""
                                            
                                            if param.getStringWithinTwoBrackets(
                                                "{", "}") == parentItem.fieldId
                                            {
                                                let fullParam = param.replace(
                                                    target:
                                                        param
                                                        .getStringWithinTwoBrackets(
                                                            "{", "}") ?? "",
                                                    withString:
                                                        convertedParentAnswer)
                                                let fullParamArr =
                                                fullParam.components(
                                                    separatedBy: "=")
                                                let key =
                                                fullParamArr.first ?? ""
                                                var val =
                                                fullParamArr.last ?? ""
                                                val = val.replace(
                                                    target: "{", withString: "")
                                                val = val.replace(
                                                    target: "}", withString: "")
                                                
                                                // Convert the value to a Date object for comparison
                                                let dateFormatter =
                                                DateFormatter()
                                                dateFormatter.dateFormat =
                                                "dd-MM-yyyy"
                                                guard
                                                    let currentValDate =
                                                        dateFormatter.date(
                                                            from: val)
                                                else { continue }
                                                
                                                if key == "from" {
                                                    // Check if a "from" value already exists and compare dates
                                                    if let index =
                                                        multiAnswers.firstIndex(
                                                            where: {
                                                                $0.keys
                                                                    .contains(
                                                                        key)
                                                            })
                                                    {
                                                        if let existingDateStr =
                                                            multiAnswers[index][
                                                                key],
                                                           let existingDate =
                                                            dateFormatter
                                                            .date(
                                                                from:
                                                                    existingDateStr
                                                            ),
                                                           currentValDate
                                                            < existingDate
                                                        {
                                                            // Update if the new "from" date is earlier
                                                            multiAnswers[index][
                                                                key] = val
                                                        }
                                                    } else {
                                                        // Add the "from" date if it doesn't exist
                                                        multiAnswers.append([
                                                            key: val
                                                        ])
                                                    }
                                                } else if key == "to" {
                                                    // Check if a "to" value already exists and compare dates
                                                    if let index =
                                                        multiAnswers.firstIndex(
                                                            where: {
                                                                $0.keys
                                                                    .contains(
                                                                        key)
                                                            })
                                                    {
                                                        if let existingDateStr =
                                                            multiAnswers[index][
                                                                key],
                                                           let existingDate =
                                                            dateFormatter
                                                            .date(
                                                                from:
                                                                    existingDateStr
                                                            ),
                                                           currentValDate
                                                            > existingDate
                                                        {
                                                            // Update if the new "to" date is later
                                                            multiAnswers[index][
                                                                key] = val
                                                        }
                                                    } else {
                                                        // Add the "to" date if it doesn't exist
                                                        multiAnswers.append([
                                                            key: val
                                                        ])
                                                    }
                                                } else {
                                                    multiAnswers.append([
                                                        key: val
                                                    ])
                                                }
                                            }
                                        }
                                        for (_, parentAnswer)
                                                in (dateAnswer.timeValues?.filter {
                                                    $0 != ""
                                                } ?? []).enumerated()
                                        {
                                            let originalFormat = "HH:mm"
                                            let desiredFormat = "HH:mm"
                                            let convertedParentAnswer =
                                            convertDateFormat(
                                                originalDateString:
                                                    parentAnswer,
                                                originalFormat:
                                                    originalFormat,
                                                desiredFormat: desiredFormat
                                            ) ?? ""
                                            
                                            if param.getStringWithinTwoBrackets(
                                                "{", "}") == parentItem.fieldId
                                            {
                                                let fullParam = param.replace(
                                                    target:
                                                        param
                                                        .getStringWithinTwoBrackets(
                                                            "{", "}") ?? "",
                                                    withString:
                                                        convertedParentAnswer)
                                                let fullParamArr =
                                                fullParam.components(
                                                    separatedBy: "=")
                                                let key =
                                                fullParamArr.first ?? ""
                                                var val =
                                                fullParamArr.last ?? ""
                                                val = val.replace(
                                                    target: "{", withString: "")
                                                val = val.replace(
                                                    target: "}", withString: "")
                                                
                                                // Convert the value to a Date object for comparison
                                                let dateFormatter =
                                                DateFormatter()
                                                dateFormatter.dateFormat =
                                                "HH:mm"
                                                guard
                                                    let currentValDate =
                                                        dateFormatter.date(
                                                            from: val)
                                                else { continue }
                                                
                                                if key == "from" || key.lowercased() == "start" {
                                                    // Check if a "from" value already exists and compare dates
                                                    if let index =
                                                        multiAnswers.firstIndex(
                                                            where: {
                                                                $0.keys
                                                                    .contains(
                                                                        key)
                                                            })
                                                    {
                                                        if let existingDateStr =
                                                            multiAnswers[index][
                                                                key],
                                                           let existingDate =
                                                            dateFormatter
                                                            .date(
                                                                from:
                                                                    existingDateStr
                                                            ),
                                                           currentValDate
                                                            < existingDate
                                                        {
                                                            // Update if the new "from" date is earlier
                                                            multiAnswers[index][
                                                                key] = val
                                                        }
                                                    } else {
                                                        // Add the "from" date if it doesn't exist
                                                        multiAnswers.append([
                                                            key: val
                                                        ])
                                                    }
                                                } else if key == "to" || key.lowercased() == "end" {
                                                    // Check if a "to" value already exists and compare dates
                                                    if let index =
                                                        multiAnswers.firstIndex(
                                                            where: {
                                                                $0.keys
                                                                    .contains(
                                                                        key)
                                                            })
                                                    {
                                                        if let existingDateStr =
                                                            multiAnswers[index][
                                                                key],
                                                           let existingDate =
                                                            dateFormatter
                                                            .date(
                                                                from:
                                                                    existingDateStr
                                                            ),
                                                           currentValDate
                                                            > existingDate
                                                        {
                                                            // Update if the new "to" date is later
                                                            multiAnswers[index][
                                                                key] = val
                                                        }
                                                    } else {
                                                        // Add the "to" date if it doesn't exist
                                                        multiAnswers.append([
                                                            key: val
                                                        ])
                                                    }
                                                } else {
                                                    multiAnswers.append([
                                                        key: val
                                                    ])
                                                }
                                            }
                                        }
                                    }
                                }
                            } else if let paragraphItem = parentItem
                                        as? FormViewModelParagraphItem
                            {
                                if let paragraphAnswer = paragraphItem.answer
                                    as? ParagraphAnswer
                                {
                                    let parentAnswer =
                                    paragraphAnswer.value ?? ""
                                    
                                    if let params = payload.parameters,
                                       !params.isEmpty
                                    {
                                        if param.getStringWithinTwoBrackets(
                                            "{", "}") == parentItem.fieldId
                                        {
                                            let fullParam = param.replace(
                                                target:
                                                    param
                                                    .getStringWithinTwoBrackets(
                                                        "{", "}") ?? "",
                                                withString: parentAnswer)
                                            let fullParamArr =
                                            fullParam.components(
                                                separatedBy: "=")
                                            let key = fullParamArr.first ?? ""
                                            var val = fullParamArr.last ?? ""
                                            val = val.replace(
                                                target: "{", withString: "")
                                            val = val.replace(
                                                target: "}", withString: "")
                                            multiAnswers.append([key: val])
                                            break
                                        }
                                    } else {
                                        cascadingComponents.accept([
                                            itemIndex: [id: [:]]
                                        ])
                                    }
                                } else {
                                    cascadingComponents.accept([
                                        itemIndex: [id: [:]]
                                    ])
                                }
                            } else if let numericItem = parentItem
                                        as? FormViewModelNumericItem
                            {
                                if let numericAnswer = numericItem.answer
                                    as? BaseAnswerText
                                {
                                    let parentAnswer = numericAnswer.value ?? ""
                                    if let params = payload.parameters,
                                       !params.isEmpty
                                    {
                                        if param.getStringWithinTwoBrackets(
                                            "{", "}") == parentItem.fieldId
                                        {
                                            let fullParam = param.replace(
                                                target:
                                                    param
                                                    .getStringWithinTwoBrackets(
                                                        "{", "}") ?? "",
                                                withString: parentAnswer)
                                            let fullParamArr =
                                            fullParam.components(
                                                separatedBy: "=")
                                            let key = fullParamArr.first ?? ""
                                            var val = fullParamArr.last ?? ""
                                            val = val.replace(
                                                target: "{", withString: "")
                                            val = val.replace(
                                                target: "}", withString: "")
                                            multiAnswers.append([key: val])
                                            break
                                        }
                                    } else {
                                        cascadingComponents.accept([
                                            itemIndex: [id: [:]]
                                        ])
                                    }
                                } else {
                                    cascadingComponents.accept([
                                        itemIndex: [id: [:]]
                                    ])
                                }
                            } else if let textItem = parentItem
                                        as? FormViewModelTextBoxItem
                            {
                                if let textAnswer = textItem.answer
                                    as? TextboxAnswer
                                {
                                    let parentAnswer = textAnswer.value ?? ""
                                    if let params = payload.parameters,
                                       !params.isEmpty
                                    {
                                        if param.getStringWithinTwoBrackets(
                                            "{", "}") == parentItem.fieldId
                                        {
                                            let fullParam = param.replace(
                                                target:
                                                    param
                                                    .getStringWithinTwoBrackets(
                                                        "{", "}") ?? "",
                                                withString: parentAnswer)
                                            let fullParamArr =
                                            fullParam.components(
                                                separatedBy: "=")
                                            let key = fullParamArr.first ?? ""
                                            var val = fullParamArr.last ?? ""
                                            val = val.replace(
                                                target: "{", withString: "")
                                            val = val.replace(
                                                target: "}", withString: "")
                                            multiAnswers.append([key: val])
                                            break
                                        }
                                    } else {
                                        cascadingComponents.accept([
                                            itemIndex: [id: [:]]
                                        ])
                                    }
                                } else {
                                    cascadingComponents.accept([
                                        itemIndex: [id: [:]]
                                    ])
                                }
                            }else if let checkBoxItem = parentItem as? FormViewModelCheckboxItem {
                                if let checkBoxAnswer = checkBoxItem.answer as? BaseAnswerMCQ {
                                    let parentAnswer =
                                    checkBoxAnswer.value?.first?.id ?? ""
                                    if param.getStringWithinTwoBrackets(
                                        "{", "}") == parentItem.fieldId
                                    {
                                        let fullParam = param.replace(
                                            target:
                                                param.getStringWithinTwoBrackets(
                                                    "{", "}") ?? "",
                                            withString: parentAnswer)
                                        let fullParamArr = fullParam.components(
                                            separatedBy: "=")
                                        let key = fullParamArr.first ?? ""
                                        var val = fullParamArr.last ?? ""
                                        val = val.replace(
                                            target: "{", withString: "")
                                        val = val.replace(
                                            target: "}", withString: "")
                                        for targetId in targetFieldIds ?? [] {
                                            if let currentItem = formViewModel
                                                .items.first(where: {
                                                    $0.fieldId == targetId
                                                })
                                            {
                                                if let item = currentItem
                                                    as? FormViewModelDropdownItem
                                                {
                                                    if item.ddlSubType
                                                        == "Search"
                                                    {
                                                        searchComponents.accept(
                                                            [id: [key: val]])
                                                    }
                                                }
                                            }
                                        }
                                        multiAnswers.append([key: val])
                                        break
                                    }
                                } else {
                                    searchComponents.accept([id: ["": ""]])
                                }
                            }else if let radioButtonItem = parentItem as? FormViewModelRadioItem {
                                if let radioButtonAnswer = radioButtonItem.answer as? BaseAnswerMCQ {
                                    let parentAnswer =
                                    radioButtonAnswer.value?.first?.id ?? ""
                                    if param.getStringWithinTwoBrackets(
                                        "{", "}") == parentItem.fieldId
                                    {
                                        let fullParam = param.replace(
                                            target:
                                                param.getStringWithinTwoBrackets(
                                                    "{", "}") ?? "",
                                            withString: parentAnswer)
                                        let fullParamArr = fullParam.components(
                                            separatedBy: "=")
                                        let key = fullParamArr.first ?? ""
                                        var val = fullParamArr.last ?? ""
                                        val = val.replace(
                                            target: "{", withString: "")
                                        val = val.replace(
                                            target: "}", withString: "")
                                        for targetId in targetFieldIds ?? [] {
                                            if let currentItem = formViewModel
                                                .items.first(where: {
                                                    $0.fieldId == targetId
                                                })
                                            {
                                                if let item = currentItem
                                                    as? FormViewModelDropdownItem
                                                {
                                                    if item.ddlSubType
                                                        == "Search"
                                                    {
                                                        searchComponents.accept(
                                                            [id: [key: val]])
                                                    }
                                                }
                                            }
                                        }
                                        multiAnswers.append([key: val])
                                        break
                                    }
                                } else {
                                    searchComponents.accept([id: ["": ""]])
                                }
                            }else {
                                print("no item found")
                            }
                        }
                    }
                }
            }
        } else {
            cascadingComponentsWithMultiParents.accept([
                [itemIndex: id]: multiAnswers
            ])
        }
        
        guard !multiAnswers.isEmpty else {return}
        if self.isNestedForm {
            cascadingComponentsWithMultiParentsNested.accept([[itemIndex:id]:multiAnswers])
        } else {
            cascadingComponentsWithMultiParents.accept([[itemIndex:id]:multiAnswers])
        }
    }
    
}
