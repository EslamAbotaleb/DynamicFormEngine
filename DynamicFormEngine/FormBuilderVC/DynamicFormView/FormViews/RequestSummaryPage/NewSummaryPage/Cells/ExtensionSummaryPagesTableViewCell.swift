//
//  ExtensionSummaryPagesTableViewCell.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 12/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension SummaryPagesTableViewCell {
    func fieldValidationChangedAt(_ section: Int, row: Int, isValid: Bool) {
        guard section < sectionObjects.count else {
            // Section index is out of range
            return
        }
        guard row < sectionObjects[section].items.count else {
            // Row index is out of range
            return
        }
        
        sectionObjects[section].items[row].isError = !isValid
        sectionObjects[section].items[row].isValid = isValid
        var isDimmed = false
        for section in sectionObjects {
            for var item in section.items {
                // Check if the item is required and its answer is nil
                var isRequired: Bool
                if let switchItem = item as? FormViewModelSwitchItem {
                    isRequired = switchItem.required
                    if (switchItem.answer as? SwitchAnswer)?.value == nil || (switchItem.answer as? SwitchAnswer)?.value == false {
                        item.answer = nil
                    }
                } else if let dropdownItem = item as? FormViewModelDropdownItem {
                    isRequired = dropdownItem.required
                    if (dropdownItem.answer as? BaseAnswerMCQ)?.value == nil || ((dropdownItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let checkboxItem = item as? FormViewModelCheckboxItem {
                    isRequired = checkboxItem.required
                    if (checkboxItem.answer as? BaseAnswerMCQ)?.value == nil || ((checkboxItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let radioItem = item as? FormViewModelRadioItem {
                    isRequired = radioItem.required
                    if (radioItem.answer as? BaseAnswerMCQ)?.value == nil || ((radioItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let dateItem = item as? FormViewModelDateItem {
                    isRequired = dateItem.required
                    if (dateItem.answer as? DateTimeAnswer)?.value == nil && (dateItem.answer as? DateTimeAnswer)?.timeValues == nil || ((dateItem.answer as? DateTimeAnswer)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if item is FormViewModelParagraphItem {
                    isRequired = false // Assuming paragraph items are never required
                    if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle {
                        let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                        let answer = item.answer as? ParagraphAnswer
                        if answer?.value == "false" && !item.hidden && requiredItem == true {
                            isRequired = true
                        } else {
                            isRequired = false
                        }
                    }
                } else if let numericItem = item as? FormViewModelNumericItem {
                    if item.type == .Numerical {
                        isRequired = (numericItem.field?.properties as? NumberProperties)?.required ?? false
                        if (numericItem.answer.value as? BaseAnswerText) == nil || ((numericItem.answer as? BaseAnswerText)?.value?.isEmpty ?? false)  {
                            item.answer = nil
                        }
                    } else {
                        isRequired = (numericItem.field?.properties as? TextBoxProperties)?.required ?? false
                        if (numericItem.answer as? TextboxAnswer).value == nil || ((numericItem.answer as? TextboxAnswer)?.value?.isEmpty ?? false) {
                            item.answer = nil
                        }
                    }
                } else if let textBoxItem = item as? FormViewModelTextBoxItem {
                    isRequired = (textBoxItem.field?.properties as? TextBoxProperties)?.required ?? false
                    if (textBoxItem.answer as? TextboxAnswer).value == nil || ((textBoxItem.answer as? TextboxAnswer)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                } else if let fileUploadItem = item as? FormViewModelFileUploadItem {
                    isRequired = fileUploadItem.required
                    if (fileUploadItem.answer as? FileUploadAnswer)?.value?.isEmpty ?? true {
                        item.answer = nil
                    }
                }else if let textAreaItem = item as? FormViewModelTextAreaItem {
                    isRequired = textAreaItem.required
                    if (textAreaItem.answer as? TextAreaAnswer).value == nil || ((textAreaItem.answer as? BaseAnswerText)?.value?.isEmpty ?? false) {
                        item.answer = nil
                    }
                }else if let table = item as? FormViewModelTableItem {
                    if table.items.count < (table.minRows ?? 0) || table.items.count > (table.maxRows ?? 0){
                        item.answer = nil
                        isRequired = true
                    }else {
                        isRequired = false
                    }
                    
                    if table.isValid {
                        isRequired = false
                    }else {
                        isRequired = true
                    }
                }
                else {
                    isRequired = false
                }
                
                if isRequired && item.answer == nil && !item.hidden && !item.disabled {
                    print("Required component without answer: \(item.label ?? "")")
                    isDimmed = true
                    break
                } else if isRequired && item.isError && !item.hidden && !item.disabled {
                    print("Required component without answer: \(item.label ?? "")")
                    isDimmed = true
                    break
                } else if item.answer != nil && item.isError && !item.hidden && !item.disabled {
                    print("Not valid component: \(item.label ?? "")")
                    isDimmed = true
                    break
                }else if isRequired && item.answer.value == nil && !item.hidden && !item.disabled {
                    isDimmed = true
                    break
                }else if isRequired && ((item.answer as? ParagraphAnswer)?.value.value == "false") && !item.hidden && !item.disabled {
                    isDimmed = true
                    break
                }
            }
            
            if isDimmed {
                break
            }
        }
    }
    
    func fieldValueChangedAt(_ section: Int, row: Int, value: Any?, isError: Bool = false, reload: Bool = true) {
//        if formBuilder.isCardMode {
//            if formBuilder.formModelItems.indices.contains(currentPage) {
//                formBuilder.formModelItems[currentPage].isError = isError
//                formBuilder.formModelItems[currentPage].answer = value
//            }
//        } else {
//            if formBuilder.sectionObjects.indices.contains(section) && sectionObjects[section].items.indices.contains(row) {
//                sectionObjects[section].items[row].isError = isError
//                sectionObjects[section].items[row].answer = value
//                sectionObjects[section].items[row].isValid = !isError
//                sectionObjects[section].items[row].isUpdated = true
//            }
//        }
//        saveChanges(reload: reload, section: section, row: row)
//        if sectionObjects.indices.contains(section) && sectionObjects[section].items.indices.contains(row) {
//            formBuilder.handleItemRules(&sectionObjects[section].items[row], excludedView: isEditable ?? false ? .Edit : .Create, removeAnswer: true)
//        }
//        
//        DynamicAuthManager.shared.isCameraOpened = false
//        fieldValidationChangedAt(section, row: row, isValid: !isError)
    }
    
    func saveChanges(reload: Bool = true, section: Int, row: Int) {
        guard section >= 0 && row >= 0 && section < tableView.numberOfSections && row < tableView.numberOfRows(inSection: section) else {
            // section or row value is invalid, so exit the function
            return
        }
        if reload {
            tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }
    }
    
    func fetchDataSourceOptionsList(code: String, parameters: [[String:String]], section: Int, row: Int, isLoadCell: Bool = false, completion: (([MCQOption]) -> Void)? = nil) {
//        //        cerqel_HUD.showHUD()
//        let targetComps = getTargetComponents(for: code, row: row).isEmpty ? formBuilder.targetComponents.value : getTargetComponents(for: code, row: row)
//        var params = [[String:String]]()
//        if parameters.first?.keys.first != parameters.first?.values.first {
//            params = parameters
//        }
//        
//        cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObject<SearchDynamicModel>(action: Dynamic_BasicActionDynamicForm.fetchDataSourceOptions(code: code, parameters: params, targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
//            guard let `self` = self else {return}
//            var sectionIndex = 0
//            var isFromTable = false
//            var isCascadeInsideTable = false
//            
//            if let data = response.item?.data {
//                if let components = data.components {
//                    for component in components {
//                        if let values = component.values {
//                            if component.rowIndex != nil {
//                                // if its row you need to return components with rowIndex
//                                // else you need to return components with null rowIndex
//                                if components.count >= formBuilder.tableSectionObjects.count {
//                                    isFromTable = true
//                                    isCascadeInsideTable = false
//                                }else {
//                                    isCascadeInsideTable = true
//                                }
//                                sectionIndex = self.formBuilder.tableSectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
//                                self.updateFieldsValues(sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
//                            } else if component.parentId != nil && component.rowIndex == nil {
//                                
//                                isCascadeInsideTable = true
//                                isFromTable = false
//                                
//                                sectionIndex = self.formBuilder.tableSectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
//                                self.updateFieldsValues(sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
//                            }
//                            else {
//                                guard let sectionIndex = self.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) else {return}
//                                guard let itemIndex = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == component.id }) else {
//                                    // Handle the case where no matching item is found
//                                    return
//                                }
//                                guard itemIndex < self.sectionObjects[sectionIndex].items.count else {return}
//                                let item = self.sectionObjects[sectionIndex].items[itemIndex]
//                                if let dropDownItem = item as? FormViewModelDropdownItem {
//                                    let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
//                                    let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
//                                    if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
//                                        dropDownItem.answer = nil
//                                    }
//                                    var opts = [MCQOption]()
//                                    guard !values.isEmpty else {
//                                        dropDownItem.options = []
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = dropDownItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                        return
//                                    }
//                                    for val in values {
//                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
//                                        opts.append(object)
//                                    }
//                                    if data.cascadeTargetType == 0 { //options
//                                        dropDownItem.options = opts
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = dropDownItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    } else if data.cascadeTargetType == 1 { //value
//                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
//                                        dropDownItem.answer = ans
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = dropDownItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    }else {
//                                        dropDownItem.options = opts
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = dropDownItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    }
//                                }else if let dateItem = item as? FormViewModelDateItem {
//                                    var sortedValues = [String]()
//                                    for val in values {
//                                        if let key = val.key, key.lowercased() == "from" { // dateRange
//                                            sortedValues.insert(val.name ?? "", at: 0)
//                                        }else if let key = val.key, key.lowercased() == "to" { // dateRange
//                                            sortedValues.insert(val.name ?? "", at: 1)
//                                        }else {
//                                            sortedValues = values.map({$0.name ?? ""}) // date/time/datetime (not range)
//                                        }
//                                        
//                                    }
//                                    let ans = DateTimeAnswer(val: sortedValues/*values.map({$0.name ?? ""})*/,
//                                                             timeValues: sortedValues/*values.map({$0.name ?? ""})*/,
//                                                             lNote: nil,
//                                                             lAttachments: nil,
//                                                             type: .Gregorian)
//                                    dateItem.answer = ans
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
//                                            self.sectionObjects[sectionIndex].items[index] = dateItem
//                                        }
//                                    } else {
//                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                    }
//                                    self.saveChanges(section: sectionIndex, row: itemIndex)
//                                }else if let paragraphItem = item as? FormViewModelParagraphItem {
//                                    let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
//                                    paragraphItem.answer = ans
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == paragraphItem.fieldId }) {
//                                            self.sectionObjects[sectionIndex].items[index] = paragraphItem
//                                        }
//                                    } else {
//                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                    }
//                                    self.saveChanges(section: sectionIndex, row: itemIndex)
//                                }else if let numericItem = item as? FormViewModelNumericItem {
//                                    let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
//                                    numericItem.answer = ans
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == numericItem.fieldId }) {
//                                            self.sectionObjects[sectionIndex].items[index] = numericItem
//                                        }
//                                    } else {
//                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                    }
//                                    self.saveChanges(section: sectionIndex, row: itemIndex)
//                                }else if let textItem = item as? FormViewModelTextBoxItem {
//                                    let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
//                                    textItem.answer = ans
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
//                                            self.sectionObjects[sectionIndex].items[index] = textItem
//                                        }
//                                    } else {
//                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                    }
//                                    self.saveChanges(section: sectionIndex, row: itemIndex)
//                                }else if let textItem = item as? FormViewModelTextAreaItem {
//                                    let ans = TextAreaAnswer(val: values.map({$0.name ?? ""}).first ?? "", htmlVal: "")
//                                    textItem.answer = ans
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
//                                            self.sectionObjects[sectionIndex].items[index] = textItem
//                                        }
//                                    } else {
//                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                    }
//                                    self.saveChanges(section: sectionIndex, row: itemIndex)
//                                }else if let switchItem = item as? FormViewModelSwitchItem {
//                                    let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
//                                                           lNote: nil,
//                                                           lAttachments: nil)
//                                    switchItem.answer = ans
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
//                                            self.sectionObjects[sectionIndex].items[index] = switchItem
//                                        }
//                                    } else {
//                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                    }
//                                    self.saveChanges(section: sectionIndex, row: itemIndex)
//                                }else if let checkboxItem = item as? FormViewModelCheckboxItem {
//                                    
//                                    
//                                    let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
//                                    let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
//                                    if currentCascadingItemID != checkboxItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
//                                        checkboxItem.answer = nil
//                                    }
//                                    var opts = [MCQOption]()
//                                    guard !values.isEmpty else {
//                                        checkboxItem.options = []
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = checkboxItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                        return
//                                    }
//                                    for val in values {
//                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
//                                        opts.append(object)
//                                    }
//                                    if data.cascadeTargetType == 0 { //options
//                                        checkboxItem.options = opts
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = checkboxItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    } else if data.cascadeTargetType == 1 { //value
//                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
//                                        checkboxItem.answer = ans
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = checkboxItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    }else {
//                                        checkboxItem.options = opts
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = checkboxItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    }
//                                }else if let radioItem = item as? FormViewModelRadioItem {
//                                    
//                                    
//                                    let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
//                                    let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
//                                    if currentCascadingItemID != radioItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
//                                        radioItem.answer = nil
//                                    }
//                                    var opts = [MCQOption]()
//                                    guard !values.isEmpty else {
//                                        radioItem.options = []
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = radioItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                        return
//                                    }
//                                    for val in values {
//                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
//                                        opts.append(object)
//                                    }
//                                    if data.cascadeTargetType == 0 { //options
//                                        radioItem.options = opts
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = radioItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    } else if data.cascadeTargetType == 1 { //value
//                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
//                                        radioItem.answer = ans
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = radioItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    }else {
//                                        radioItem.options = opts
//                                        if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                            if let index = self.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
//                                                self.sectionObjects[sectionIndex].items[index] = radioItem
//                                            }
//                                        } else {
//                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
//                                        }
//                                        self.saveChanges(section: sectionIndex, row: itemIndex)
//                                    }
//                                    
//                                    
//                                }else if let tableItem = item as? FormViewModelTableItem {
//                                    let val = values.first?.name ?? ""
//                                    var payload = ""
//                                    if parameters.first?.keys.first == parameters.first?.values.first {
//                                        payload = parameters.first?.values.first ?? ""
//                                    }
//                                    
//                                    if sectionIndex >= 0 && sectionIndex < self.sectionObjects.count {
//                                        let itemIndex = formBuilder.itemsDict[tableItem.fieldId]?.1 ?? 0
//                                        formBuilder.formViewModel.items[itemIndex] = formBuilder.updateItemProperty(item: tableItem, value: [val], payload: formBuilder.currentPropertyTragetName)
//                                        formBuilder.currentPropertyTragetName = ""
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    if isCascadeInsideTable {
//                        for (tableSectionIndex, tableSectionObject) in self.formBuilder.tableSectionObjects.enumerated() {
//                            for (_, tableItem) in tableSectionObject.items.enumerated() {
//                                // Check the fieldId and update
//                                for sectionIndex in formBuilder.sectionObjects.indices {
//                                    // Get the section object
//                                    var section = formBuilder.sectionObjects[sectionIndex]
//                                    
//                                    // Check the first item in the section
//                                    if let sectionItem = (section.items[0] as? FormViewModelTableItem) {
//                                        // Check if the sectionItem's fieldId matches the tableItem's parentId
//                                        if sectionItem.fieldId == tableItem.parentId {
//                                            for (childControlIndex, childControl) in sectionItem.childControls.enumerated() {
//                                                // If the childControl's fieldId matches the tableItem's fieldId, update it
//                                                if childControl.fieldId == tableItem.fieldId {
//                                                    // Update the childControl with tableItem
//                                                    sectionItem.childControls[childControlIndex] = tableItem
//                                                    
//                                                    // Update the section in formBuilder.sectionObjects
//                                                    formBuilder.sectionObjects[sectionIndex].items[0] = sectionItem
//                                                    
//                                                    // Trigger reload or any necessary update logic
//                                                    // Your update/reload logic here
//                                                    
//                                                    break
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                
//                            }
//                        }
//                    }
//                    
//                    if isFromTable {
//                        // Create a dictionary to hold grouped items based on rowIndex
//                        var groupedItems: [String: [FormViewModelItem]] = [:]
//                        // Iterate through tableSectionObjects to populate the groupedItems dictionary
//                        for sectionObject in self.formBuilder.tableSectionObjects {
//                            for var item in sectionObject.items {
//                                if let rowIndex = item.rowIndex {
//                                    // Find the index of the existing item based on specific properties
//                                    if let existingIndex = self.formBuilder.allRowsChildControls.firstIndex(where: { existingItem in
//                                        return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
//                                    }) {
//                                        // Replace the existing item with the new one
//                                        self.formBuilder.allRowsChildControls[existingIndex] = FormViewModelItemStruct(from: item)
//                                    } else {
//                                        // If the item doesn't exist, append it to allRowsChildControls
//                                        self.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
//                                    }
//                                    self.formBuilder.handleItemRules(&item, excludedView: isMyRequestFlag ? .RequestDetails : .TaskDetails, removeAnswer: false)
//                                    // Handle groupedItems
//                                    if groupedItems[rowIndex] == nil {
//                                        groupedItems[rowIndex] = [item]
//                                    } else {
//                                        groupedItems[rowIndex]?.append(item)
//                                    }
//                                }
//                            }
//                        }
//                        rowIndices = self.formBuilder.allRowsChildControls
//                            .compactMap { Int($0.rowIndex ?? "0") }
//                            .sorted()
//                        let tables: [FormViewModelItem] = formBuilder.formModelItems.filter({$0.type == .Table})
//                        // Convert keys to integers and sort the dictionary
//                        let sortedItems = groupedItems.sorted { (entry1, entry2) in
//                            guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
//                                return false // Handle non-integer keys
//                            }
//                            return num1 < num2
//                        }
//                        var tableId = ""
//                        for groupItem in sortedItems {
//                            for formItem in groupItem.value {
//                                tableId = formItem.parentId ?? ""
//                            }
//                        }
//                        
//                        // Now sortedGroupedItems contains the sorted dictionary
//                        
//                        for table in tables {
//                            if let item = table as? FormViewModelTableItem, item.fieldId == tableId  {
//                                for groupItem in sortedItems {
//                                    // Custom check to determine if groupItem.value exists in item.items
//                                    var exists = false
//                                    for existingItems in item.items {
//                                        if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
//                                            existingItems[0].answer = groupItem.value[0].answer
//                                            exists = true
//                                            break
//                                        }
//                                    }
//                                    // If groupItem.value doesn't exist, append it to item.items
//                                    if !exists {
//                                        item.items.append(groupItem.value)
//                                        item.cascadingComponent = nil
//                                    }
//                                }
//                            }
//                        }
//                        
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }, onError: {[weak self] (_) in
//            guard let `self` = self else {return}
//        })
    }
    
    func getTargetComponents(for code: String, row: Int) -> [[String: String?]] {
        var targetComponents = [[String: String?]]()
        var uniqueIds = Set<String>() // To keep track of unique ids
        
        // Iterate through all target components
        for targetComponent in formBuilder.targetComponents.value {
            if targetComponent["code"] as? String == code || targetComponent["name"] as? String == code {
                let id = targetComponent["id"] as? String ?? ""
                
                // Check if the id is unique before adding to targetComponents
                if !uniqueIds.contains(id) {
                    uniqueIds.insert(id) // Mark the id as added
                    
                    if let _ = targetComponent["parentId"] as? String , (targetComponent["sectionItem"] as? String == "true")  {
                        let component: [String: String?] = [
                            "id": id,
                            "name": targetComponent["name"] as? String ?? "",
                            "type": targetComponent["type"] as? String ?? "",
                            "parentId": targetComponent["parentId"] as? String ?? ""
                        ]
                        targetComponents.append(component)
                    } else if let _ = targetComponent["parentId"] as? String , (targetComponent["sectionItem"] as? String == "false")  {
                        let component: [String: String?] = [
                            "id": id,
                            "name": targetComponent["name"] as? String ?? "",
                            "type": targetComponent["type"] as? String ?? "",
                            "parentId": targetComponent["parentId"] as? String ?? "",
                            "rowIndex": targetComponent["rowIndex"] as? String ?? ""
                        ]
                        targetComponents.append(component)
                    } else {
                        let component: [String: String?] = [
                            "id": id,
                            "name": targetComponent["name"] as? String ?? "",
                            "type": targetComponent["type"] as? String ?? ""
                        ]
                        targetComponents.append(component)
                    }
                }
            }
        }
        
        // If no matching components found, print a message
        if targetComponents.isEmpty {
            print("No matching component found for code: \(code)")
        }
        
        return targetComponents
    }
    
    func updateFieldsValues(sectionIndex: Int, row: Int, values: [SearchValues], component: ComponentsModel,isTableFields: Bool) {
        guard sectionIndex <  self.formBuilder.tableSectionObjects.count else {
            return
        }
        guard row <  self.formBuilder.tableSectionObjects[sectionIndex].items.count else {return}
        let item =  self.formBuilder.tableSectionObjects[sectionIndex].items[row]
        if let dropDownItem = item as? FormViewModelDropdownItem {
            let sourceIDs = self.formBuilder.cascadingSourceIDs ?? []
            let currentCascadingItemID = self.formBuilder.cascadingCurrentItemID ?? ""
            if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                dropDownItem.answer = nil
            }
            var opts = [MCQOption]()
            guard !values.isEmpty else {
                dropDownItem.options = []
                self.formBuilder.tableSectionObjects[sectionIndex].items[row] = dropDownItem
                if !isTableFields {
                    self.saveChanges(section: sectionIndex, row: row)
                }
                return
            }
            for val in values {
                let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                opts.append(object)
            }
            dropDownItem.options = opts
            if dropDownItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = dropDownItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dropDownItem.rowIndex != component.rowIndex &&  dropDownItem.rowIndex != nil{
                    var uniqueItems = [SectionObject]()
                    for sections in self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelDropdownItem(field: dropDownItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.options = opts
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let dateItem = item as? FormViewModelDateItem {
            var sortedValues = [String]()
            for val in values {
                if let key = val.key, key.lowercased() == "from" { // dateRange
                    sortedValues.insert(val.name ?? "", at: 0)
                }else if let key = val.key, key.lowercased() == "to" { // dateRange
                    sortedValues.insert(val.name ?? "", at: 1)
                }else {
                    sortedValues = values.map({$0.name ?? ""}) // date/time/datetime (not range)
                }
                
            }
            let ans = DateTimeAnswer(val: sortedValues/*values.map({$0.name ?? ""})*/,
                                     timeValues: sortedValues/*values.map({$0.name ?? ""})*/,
                                     lNote: nil,
                                     lAttachments: nil,
                                     type: .Gregorian)
            dateItem.answer = ans
            if dateItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = dateItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dateItem.rowIndex != component.rowIndex && dateItem.rowIndex != nil {
                    var uniqueItems = [SectionObject]()
                    for sections in self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelDateItem(field: dateItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let paragraphItem = item as? FormViewModelParagraphItem {
            let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
            paragraphItem.answer = ans
            if paragraphItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = paragraphItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if paragraphItem.rowIndex != component.rowIndex && paragraphItem.rowIndex != nil {
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelParagraphItem(field: paragraphItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
                
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let numericItem = item as? FormViewModelNumericItem {
            let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
            numericItem.answer = ans
            if numericItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = numericItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if numericItem.rowIndex != component.rowIndex  && numericItem.rowIndex != nil{
                    var uniqueItems = [SectionObject]()
                    for sections in   self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelNumericItem(field: numericItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
                
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let textItem = item as? FormViewModelTextBoxItem {
            let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
            textItem.answer = ans
            if textItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = textItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if textItem.rowIndex != component.rowIndex && textItem.rowIndex != nil{
                    var uniqueItems = [SectionObject]()
                    for sections in self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelTextBoxItem(field: textItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if !isTableFields {
                self.saveChanges(section: sectionIndex, row: row)
            }
        }else if let switchItem = item as? FormViewModelSwitchItem {
            let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                   lNote: nil,
                                   lAttachments: nil)
            switchItem.answer = ans
            if switchItem.rowIndex == component.rowIndex {
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   self.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = switchItem
                self.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if switchItem.rowIndex != component.rowIndex && switchItem.rowIndex != nil {
                    var uniqueItems = [SectionObject]()
                    for sections in self.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                var fieldItem = FormViewModelSwitchItem(field: switchItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    self.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func validation(_ item: FormViewModelItem, _ section: Int, _ row: Int) {
        if let item = item as? FormViewModelFileUploadItem {
            if (!(item.attachmentsList.isEmpty)) && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: true)
            } else if (item.attachmentsList.isEmpty) && ((item.field?.properties as? FileUploadProperties)?.required ?? false) {
                self.fieldValidationChangedAt(section, row: row, isValid: false)
            }
        }
    }
}
