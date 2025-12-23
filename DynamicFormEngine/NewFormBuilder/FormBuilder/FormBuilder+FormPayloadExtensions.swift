//
//  FormBuilder+FormPayloadExtensions.swift
//  CERQEL
//
//  Created by hassan elshaer on 24/12/2024.
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

    /// Create payload for all controls
    /// - Parameters:
    ///   - actionId: dynamic action id (from RequestDetails)
    ///   - sections: all DynamicForm sections
    ///   - completion: return dynamic actions payload
    func createPayload(
        actionId: String?, fromSummary: Bool? = false,
        isEditable: Bool? = false, isApproverForm: Bool? = false,
        reqIdApprover: String?, sections: [SectionObject],
        completion: @escaping (([[String: Any]]?) -> Void)
    ) {
        var payload = ModelSubmitForm()

        payload.formVersion = self.formVersionId
        payload.createdForUsername =
            AuthManager.shared.profile.value?.name ?? ""
        var payloadArr: [[String: Any]] = []

        for section in sections {
            for item in section.items {
                    // create payload for table component items
                    if let tableComponent = item as? FormViewModelTableItem {
                        if !tableComponent.items.isEmpty {
                            payloadArr.append(createPayloadValue(ctl: tableComponent))
                        }
                        var counter = 0
                        for items in tableComponent.items {
                            counter += 1
                            let filteredControls = self.allRowsChildControls
                                .filter { control in
                                    if let rowIndex = control.rowIndex {
                                        return Int(rowIndex) == counter
                                    }
                                    return false
                                }
                            for control in filteredControls {
                                payloadArr.append(createPayloadValue(ctl:FormViewModelFileUploadItem(from: control),rowIndex: counter))
                            }
                        }
                    } else {  // create payload for items
                        payloadArr.append(createPayloadValue(ctl: item))
                    }
            }
        }
        var payloadJSON = payload.toJSON()
        payloadJSON["payload"] = payloadArr
        print("payloadJSON = ", payloadJSON)

        // payload for dynamic actions in TaskDetails
        generateSummaryForm(payload: payloadArr)
        if let _ = actionId {
            completion(payloadArr)
        } else {

            // submit payload for DynamicForm service
            if fromSummary ?? false {
                if (isEditable ?? false) || (isApproverForm ?? false) {
                    formViewModel.submitEditRequest(
                        payload: payloadJSON, id: serviceId
                    ) {
                        [weak self]
                        success, requestOrder, id, isEligableForSurvey in
                        guard let `self` = self else { return }
                        if success ?? false {
                            self.serviceSubmittedResponse.accept(
                                SubmitModel(
                                    requestOrder: requestOrder ?? "",
                                    id: id ?? "",
                                    isEligableForSurvey: isEligableForSurvey))
                        } else {
                            completion([["error": requestOrder]])
                        }
                    }
                } else {
                    formViewModel.submit(payload: payloadJSON, id: serviceId) {
                        [weak self]
                        success, requestOrder, id, isEligableForSurvey in
                        guard let `self` = self else { return }
                        if success ?? false {
                            self.serviceSubmittedResponse.accept(
                                SubmitModel(
                                    requestOrder: requestOrder ?? "",
                                    id: id ?? "",
                                    isEligableForSurvey: isEligableForSurvey))
                            completion(nil)
                        } else {
                            completion([["error": requestOrder]])
                        }
                    }
                }
            }
        }
    }

    func generateSummaryForm(payload: [[String: Any]]) {
        var sectionItems: [SectionObject]? = []
        // Assuming FormViewModelItemStruct can be converted to SectionObject
        let convertedAllRowsChildControls = allRowsChildControls.map { item in
            // Convert FormViewModelItemStruct to SectionObject
            // Example conversion:
            let itemConverted = FormViewModelItem(from: item)
            return SectionObject(
                id: item.fieldId, dummy: false, opened: true,
                items: [itemConverted], item: nil)
        }

        self.summarySectionObjects = self.sectionObjects
        // Iterate over the summarySectionObjects array
        for index in summarySectionObjects.indices {
            var sectionObject = summarySectionObjects[index]  // Make sectionObject mutable
            // Check if the sectionObject contains a table
            if let indexOfTable = sectionObject.items.firstIndex(where: {
                $0.type == .Table
            }) {
                // Iterate over convertedAllRowsChildControls
                for itemofConverted in convertedAllRowsChildControls {
                    for item in itemofConverted.items {
                        let intItemRowIdx = Int(item.rowIndex ?? "0") ?? 0
                        // Find the index where the item should be inserted based on its rowIndex
                        let insertionIndex =
                            sectionObject.items.firstIndex {
                                (Int($0.rowIndex ?? "0") ?? 0) > intItemRowIdx
                            } ?? sectionObject.items.endIndex
                        // Insert the item at the calculated index
                        sectionObject.items.insert(item, at: insertionIndex)
                    }
                }
            }
            // Assign the modified sectionObject back to the summarySectionObjects array
            summarySectionObjects[index] = sectionObject
        }

        // Iterate over the payload
        for payloadItem in payload {
            // Find the corresponding field in sectionObjects
            if let fieldId = payloadItem["id"] as? String,
                let value = payloadItem["value"]
            {
                for sectionObject in self.summarySectionObjects {
                    let rowIdx = payloadItem["rowIndex"] as? String
                    if let item = sectionObject.items.first(where: {
                        $0.fieldId == fieldId && $0.rowIndex == rowIdx
                            && $0.rowIndex != nil
                    }) {
                        // Update the answer property of the found field
                        item.defualtTabldItemsSummaryAnswer = payloadItem
                        //                        item.rowIndex = payloadItem["rowIndex"] as? String
                    }
                    if let item = sectionObject.items.first(where: {
                        $0.fieldId == fieldId
                    }) {
                        item.defualtSummaryAnswer = payloadItem
                    }
                }
            }
        }

        // Remove items with fieldId not found in payload
        self.summarySectionObjects.removeAll { sectionObject in
            // If sectionObject.item is of type .Section, add it to sectionItems
            if sectionObject.item?.type == .Section {
                sectionItems?.append(sectionObject)
            }

            // Check if section contains an item of type FormViewModelTableItem
            let containsTableItem = sectionObject.items.contains { item in
                return item is FormViewModelTableItem
            }

            // If the section contains a FormViewModelTableItem, we don't want to remove it
            if containsTableItem {
                return false
            }

            // Check if fieldId of any item in sectionObject is not found in payload
            return sectionObject.items.contains { item in
                guard let fieldId = item.fieldId else { return false }
                return !payload.contains { payloadItem in
                    guard let payloadFieldId = payloadItem["id"] as? String
                    else { return false }
                    return payloadFieldId == fieldId
                }
            }
        }

        guard var itemsArray = sectionItems else { return }
        for (index, sectionObject) in itemsArray.enumerated() {
            var updatedItems = sectionObject.items
            updatedItems.removeAll { item in
                guard let fieldId = item.fieldId else { return false }
                return !payload.contains { payloadItem in
                    guard let payloadFieldId = payloadItem["id"] as? String
                    else { return false }
                    return payloadFieldId == fieldId
                }
            }
            itemsArray[index].items = updatedItems
        }

        sectionItems = itemsArray
        if let sectionControls = sectionItems {
            for sectionControl in sectionControls {
                let idx = Int(sectionControl.item?.field?.order ?? "0") ?? 0
                // Check if sectionControl is already in self.summarySectionObjects based on its unique identifier
                if !self.summarySectionObjects.contains(where: {
                    $0.id == sectionControl.id
                }) && !(sectionControl.items.isEmpty) {
                    // Ensure idx is within bounds
                    if idx > 0 && idx <= self.summarySectionObjects.count {
                        self.summarySectionObjects.insert(
                            sectionControl, at: idx - 1)
                    } else {
                        // If idx is out of bounds, append to the end of the array
                        self.summarySectionObjects.append(sectionControl)
                    }
                }
            }
        }
        print("section objects are \(self.summarySectionObjects)")
    }


    /// Creating payload for all controls
    /// - Parameters:
    ///   - ctl: Current Control
    ///   - rowIndex: control index
    /// - Returns: payload
    private func createPayloadValueForSummary(
        ctl: FormViewModelItem, rowIndex: Int? = nil
    ) -> [String: Any] {
        var pObj: [String: Any] = SubmitFormPayload(control: ctl).toJSON()

        guard ctl.type?.rawValue.lowercased() != "Table".lowercased() else {
            return [:]  // Return an empty dictionary or handle accordingly
        }

        if let pID = ctl.parentId, !pID.isEmpty {
            pObj["parentId"] = pID
        }

        if let rowIndex = rowIndex, rowIndex != 0 {
            pObj["rowIndex"] = "\(rowIndex)"
        }

        if var val = ctl.answer as? [String] {
            // to handle DateRangePicker optional end date in sending it's value and send it with ""
            if ctl.type?.rawValue == "DateRangePicker" {
                if val.count == 1 {
                    val.append("")
                }
            }
            pObj["value"] = val
        } else if let val = ctl.answer as? [Bool] {
            pObj["value"] = val
        } else if let arr = ctl.answer as? [VisitorInfo] {
            pObj["value"] = arr.toJSON()
        } else if let ans = ctl.answer as? DateTimeAnswer {
            // we will receive date format as date iso "12-8-2024T445555Z" ["",""] interid ["from": , "to":]
            let dateArr =
                handleDateTimeAnswersWhenSubmit(answer: ans, item: ctl)
                as? [String]
            if let dateItem = ctl.field?.properties as? DateTimeProperties {
                var modifiedDateArr: [String] = []
                for dateStr in dateArr ?? [] {
                    var modifiedDate = dateStr
                    switch dateItem.dateTimeType {
                    case .Date:
                        // Remove time part, keep only the date part
                        modifiedDate = String(dateStr.prefix(10))  // Extract date part only (e.g., "05-09-2030")
                    case .Time:
                        // Remove date part, keep only the time part
                        modifiedDate = String(dateStr.suffix(5))  // Extract time part only (e.g., "00:00")
                    case .Both:
                        // Keep the date and time as is
                        modifiedDate = dateStr
                    default:
                        break
                    }
                    modifiedDateArr.append(modifiedDate)
                }

                let convertedISODate = convertDates(
                    array: modifiedDateArr, dateProperties: dateItem)
                pObj["value"] = convertedISODate
            }

        } else if let ans = ctl.answer as? BaseAnswerMCQ {
            if let val = ans.value {
                pObj["value"] = val.toJSON()
            }
        } else if let ans = ctl.answer as? TextAreaAnswer {
            pObj["value"] = ans.value
        } else if let ans = ctl.answer as? FileUploadAnswer {

            var newArr: [ModelUploadedMediaFormPayloadForSummary] = []
            for item in ans.value ?? [] {
                newArr.append(
                    ModelUploadedMediaFormPayloadForSummary.init(item: item))
            }
            pObj["value"] = newArr.toJSON()
        } else if let ans = ctl.answer as? ParagraphAnswer {
            if let val = ans.value, !(val.isEmpty) {
                pObj["value"] =
                    (ctl.paragraphSubType == .LabelSheetWithToggle)
                    ? Bool(val) : val
            }
        }
        else if let ans = ctl.answer as? SwitchAnswer {
            pObj["value"] = ans.value
        } else if let ans = ctl.answer as? TextboxAnswer {
            if let val = ans.value {
                pObj["value"] = val
            }
        } else if let ans = ctl.answer as? DefaultBaseAnswerText {

            if let val = ans.value {
                pObj["value"] = val
            }
        } else if let ans = ctl.answer as? DefaultBaseAnswerTextNewFormat {
            if let val = ans.value {
                pObj["value"] = val
            }
        } else if let ans = ctl.answer as? BaseAnswerText {
            if let val = ans.value {
                pObj["value"] = (ctl.type?.rawValue.lowercased() == "number") ?  Float(val) : val
            }
        } else {
            if let item = ctl as? FormViewModelFileUploadItem {
                var newArr: [ModelUploadedMediaFormPayloadForSummary] = []
                for i in item.attachmentsList.map({ $0.uploadedMedia }) {
                    if let i = i {
                        newArr.append(
                            ModelUploadedMediaFormPayloadForSummary.init(
                                item: i))
                    }
                }
                if !newArr.isEmpty {
                    pObj["value"] = newArr.toJSON()
                }
            }
        }
        return pObj
    }

    /// Creating payload for all controls
    /// - Parameters:
    ///   - ctl: Current Control
    ///   - rowIndex: control index
    /// - Returns: payload
    private func createPayloadValue(
        ctl: FormViewModelItem, rowIndex: Int? = nil
    ) -> [String: Any] {
        var pObj: [String: Any] = SubmitFormPayload(control: ctl).toJSON()

        if let pID = ctl.parentId, !pID.isEmpty {
            pObj["parentId"] = pID
        }

        if let rowIndex = rowIndex, rowIndex != 0 {
            pObj["rowIndex"] = "\(rowIndex)"
        }

        if var val = ctl.answer as? [String] {
            // to handle DateRangePicker optional end date in sending it's value and send it with ""
            if ctl.type?.rawValue == "DateRangePicker" {
                if val.count == 1 {
                    val.append("")
                }
            }
            pObj["value"] = val
        } else if let val = ctl.answer as? [Bool] {
            pObj["value"] = val
        } else if let arr = ctl.answer as? [VisitorInfo] {
            pObj["value"] = arr.toJSON()
        } else if let ans = ctl.answer as? DateTimeAnswer {
            pObj["value"] = handleDateTimeAnswers(answer: ans, item: ctl)
        } else if let ans = ctl.answer as? BaseAnswerMCQ {
            if let val = ans.value as? [MCQOption] {
                pObj["value"] = val.toJSON()
            }
        } else if let ans = ctl.answer as? TextAreaAnswer {
            pObj["value"] = [ans.value]
        } else if let ans = ctl.answer as? FileUploadAnswer {
            var newArr: [ModelUploadedMediaFormPayload] = []
            for item in ans.value ?? [] {
                newArr.append(ModelUploadedMediaFormPayload.init(item: item))
            }
            pObj["value"] = newArr.toJSON()
        } else if let ans = ctl.answer as? ParagraphAnswer {
            if let val = ans.value {
                pObj["value"] = [val]
            }
        } else if let ans = ctl.answer as? SwitchAnswer {
            pObj["value"] = [ans.value]
        } else if let ans = ctl.answer as? TextboxAnswer {
            if let val = ans.value {
                pObj["value"] = [val]
            }
        } else if let ans = ctl.answer as? DefaultTextboxAnswerNewFormat {
            if let val = ans.value {
                pObj["value"] = [val]
            }
        } else if let ans = ctl.answer as? DefaultBaseAnswerText {
            if let val = ans.value {
                pObj["value"] = [val]
            }
        } else if let ans = ctl.answer as? BaseAnswerText {
            if let val = ans.value {
                pObj["value"] = [val]
            }
        } else {
            if let item = ctl as? FormViewModelFileUploadItem {
                var newArr: [ModelUploadedMediaFormPayload] = []
                for i in item.attachmentsList.map({ $0.uploadedMedia }) {
                    if let i = i {
                        newArr.append(
                            ModelUploadedMediaFormPayload.init(item: i))
                    }
                }
                if !newArr.isEmpty {
                    pObj["value"] = newArr.toJSON()
                }
            }
        }
        return pObj
    }

    func removeDuplicates(from payloadArr: [[String: Any]]) -> [[String: Any]] {
        var seenItemsWithParentId: Set<String> = []
        var seenItemsWithoutParentId: Set<String> = []
        var uniqueItems: [[String: Any]] = []

        for item in payloadArr {
            guard let id = item["id"] as? String else {
                // If no id, skip the item
                continue
            }
            let parentId = item["parentId"] as? String
            let rowIndex = item["rowIndex"] as? String ?? ""

            if let parentId = parentId {
                // Create a unique identifier for items with parentId
                let uniqueIdentifier = "\(parentId)-\(id)-\(rowIndex)"
                if !seenItemsWithParentId.contains(uniqueIdentifier) {
                    seenItemsWithParentId.insert(uniqueIdentifier)
                    uniqueItems.append(item)
                }
            } else {
                // Create a unique identifier for items without parentId
                if !seenItemsWithoutParentId.contains(id) {
                    seenItemsWithoutParentId.insert(id)
                    uniqueItems.append(item)
                }
            }
        }

        return uniqueItems
    }

    // Function to recursively clean empty dictionaries
    func removeEmptyDictionaries(from data: Any) -> Any? {
        if let dict = data as? [String: Any] {
            var cleanedDict = dict

            // Remove empty dictionaries from the dictionary
            cleanedDict = cleanedDict.filter { key, value in
                if let valueDict = value as? [String: Any], valueDict.isEmpty {
                    return false
                }
                return true
            }

            // Recursively clean nested dictionaries
            for (key, value) in cleanedDict {
                cleanedDict[key] = removeEmptyDictionaries(from: value)
            }
            return cleanedDict.isEmpty ? nil : cleanedDict

        } else if let array = data as? [Any] {
            // Recursively clean elements in the array
            let cleanedArray = array.compactMap {
                removeEmptyDictionaries(from: $0)
            }
            return cleanedArray.isEmpty ? nil : cleanedArray
        }

        return data
    }

    func createPayloadForSummaryPage(
        actionId: String?, fromSummary: Bool? = false,
        isEditable: Bool? = false, isApproverForm: Bool? = false,
        reqIdApprover: String?, sections: [SectionObject],
        completion: @escaping (([[String: Any]]?) -> Void)) {
        var payload = ModelSubmitForm()

        if isEditable ?? false {
            payload.roleType = "1"
        } else if isApproverForm ?? false {
            payload.roleType = "2"
        }

        payload.formVersion = self.formVersionId
        payload.createdForUsername =
            AuthManager.shared.profile.value?.name ?? ""
        var payloadArr: [[String: Any]] = []

        for section in sections {
            for item in section.items {
                // create payload for table component items
                if let tableComponent = item as? FormViewModelTableItem {
                    if !tableComponent.items.isEmpty {
                        payloadArr.append(createPayloadValueForSummary(ctl: tableComponent))
                    }
                    var counter = 0
                    for items in tableComponent.items {
                        counter += 1
                        let filteredControls = self.allRowsChildControls.filter{ control in
                            if let rowIndex = control.rowIndex {
                                return Int(rowIndex) == counter
                            }
                            return false
                        }
                        for control in filteredControls {
                            payloadArr.append(createPayloadValueForSummary(ctl: FormViewModelItem(from: control), rowIndex: counter))
                        }
                    }
                } else {  // create payload for items
                    payloadArr.append(createPayloadValueForSummary(ctl: item))
                }
            }
        }

        var payloadJSON = payload.toJSON()
        payloadJSON["payload"] = removeEmptyDictionaries(from: payloadArr)
        print("payloadJSON = ", payloadJSON)

        if actionId != nil {
            completion(payloadArr)
        } else {

            // submit payload for DynamicForm service
            if fromSummary ?? false {
                if isEditable ?? false {
                    formViewModel.submitEditRequest(
                        payload: payloadJSON, id: serviceId
                    ) {
                        [weak self]
                        success, requestOrder, id, isEligableForSurvey in
                        guard let `self` = self else { return }
                        if success ?? false {
                            self.serviceSubmittedResponse.accept(
                                SubmitModel(
                                    requestOrder: requestOrder ?? "",
                                    id: id ?? "",
                                    isEligableForSurvey: isEligableForSurvey))
                        } else {
                            completion([["error": requestOrder]])
                        }
                    }
                } else if isApproverForm ?? false {
                    formViewModel.submitEditRequest(
                        payload: payloadJSON, id: reqIdApprover ?? ""
                    ) {
                        [weak self]
                        success, requestOrder, id, isEligableForSurvey in
                        guard let `self` = self else { return }
                        if success ?? false {
                            self.serviceSubmittedResponse.accept(
                                SubmitModel(
                                    requestOrder: requestOrder ?? "",
                                    id: id ?? "",
                                    isEligableForSurvey: isEligableForSurvey))
                        } else {
                            completion([["error": requestOrder]])
                        }
                    }
                } else {
                    formViewModel.submit(payload: payloadJSON, id: serviceId) {
                        [weak self]
                        success, requestOrder, id, isEligableForSurvey in
                        guard let `self` = self else { return }
                        if success ?? false {
                            self.serviceSubmittedResponse.accept(
                                SubmitModel(
                                    requestOrder: requestOrder ?? "",
                                    id: id ?? "",
                                    isEligableForSurvey: isEligableForSurvey))
                            completion(nil)
                        } else {
                            completion([["error": requestOrder]])
                        }
                    }
                }
            }
            else {
                formViewModel.submit(payload: payloadJSON, id: serviceId) {
                    [weak self] success, requestOrder, id, isEligableForSurvey
                    in
                    guard let `self` = self else { return }
                    if success ?? false {
                        self.serviceSubmittedResponse.accept(
                            SubmitModel(
                                requestOrder: requestOrder ?? "", id: id ?? "",
                                isEligableForSurvey: isEligableForSurvey))
                        completion(nil)
                    } else {
                        completion([["error": requestOrder]])
                    }
                }
            }
        }
    }
}
