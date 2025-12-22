//
//  FormViewController+Extension.swift
//
//
//  Created by Marwan on 23/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit
import Kingfisher


extension FormViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// display inline error
    /// - Parameters:
    ///   - item: current control
    ///   - indexPath: control position
    ///   - message: error message
    func updateInlineError(for item: FormViewModelItem, at indexPath: IndexPath, message: String) {
        // Get the cell for the given index path
        guard let cell = formTableView.cellForRow(at: indexPath) as? ValidatableCell else {
            return
        }
        // Call the method to display the validation error
        cell.displayValidationError(message)
    }
    
    /// clearing inline error
    /// - Parameters:
    ///   - item: current control
    ///   - indexPath: control position
    func clearInlineError(for item: FormViewModelItem, at indexPath: IndexPath) {
        // Get the cell for the given index path
        guard let cell = formTableView.cellForRow(at: indexPath) as? ValidatableCell else {
            return
        }
        // Call the method to clear the validation error
        cell.clearValidationError()
    }
    
    /// getting number of sections in table
    /// - Parameter tableView: current table view
    /// - Returns: number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return formBuilder.sectionObjects.count
    }
    
    // This function returns the number of rows in a given section of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Get the current section object from the formBuilder's sectionObjects array
        let currentSection = formBuilder.sectionObjects[section].item
        
        // Check if the current section type is .Section and not hidden
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) {
            // If the section is collapsed, loop through the items and call fieldValidationChangedAt
            if currentSection?.isCollapsedSection ?? false {
                // Return 0 rows for a collapsed section
                return 0
            }
            // If not collapsed, return the count of items in the section
            return formBuilder.sectionObjects[section].items.count
        } else {
            // If the current section type is not .Section, return 1 (single row)
            return 1
        }
    }
    // This function returns a view to be used as the header for a given section of the table view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Get the current section object from the formBuilder's sectionObjects array
        let currentSection = formBuilder.sectionObjects[section].item
        // Check if the current section type is .Section
        if currentSection?.type == .Section && !(currentSection?.hidden ?? false) && !HelperFunctions.isHiddenSectionInForm(items: formBuilder.sectionObjects[section].items) {
            // Dequeue a reusable header view of type ExpandedSectionHeader
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandedSectionHeader.cerqel_identifier) as! ExpandedSectionHeader
            // Configure the header with the section title and expansion state
            header.configure(sectionTitle: self.getSectionTitle(item: currentSection), isExpanded: !(currentSection?.isCollapsedSection ?? false), isEditMode: true)
            
            // Define a closure to handle the collapsed state toggling
            header.collapsed = {
                self.toggleSection(section)
            }
            
            // Return the configured header view
            return header
        } else {
            // If the current section type is not .Section, return nil (no header view)
            return nil
        }
    }
    
    /// drawing header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let currentSection = formBuilder.sectionObjects[section].item
        
        return (currentSection?.type == .Section && !(currentSection?.hidden ?? false) && !HelperFunctions.isHiddenSectionInForm(items: formBuilder.sectionObjects[section].items)) ? 72.0 : 0.0 // Adjust as needed
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let sectionType =  formBuilder.sectionObjects[section].item
        let row = indexPath.row
        
        let item = FormManager.shared.getCurrentItem(sectionObjects: formBuilder.sectionObjects, indexPath: indexPath)
        item.isSectionControl = sectionType?.type == .Section
        if item.hidden {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
            return cell
        }
        switch item.type {
        case .TextBox, .Numerical:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextBoxTVCell.cerqel_identifier, for: indexPath) as! NewTextBoxTVCell
            cell.tag = section
            cell.formViewController = self
            cell.isSectionItem = sectionType?.type == .Section
            cell.dataSourceFetchingInTextNumberControl = { [weak self] dataSource, textBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: textBoxItem)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textBoxItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textBoxItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.item = item
            cell.valueChanged = { [unowned self] text, isError in
                if (item.answer as? TextboxAnswer)?.value as? String != (text)?.value as? String , item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: text, isError: isError, reload: false)
                }
            }
            
            cell.numberValueChanged = { [unowned self] numberValue, isError in
                if (item.answer as? BaseAnswerText)?.value as? String != (numberValue as? BaseAnswerText)?.value as? String , item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: numberValue, isError: isError, reload: false)
                }
            }
            
            // Check and call the closure if needed
            if let dataSourceId = item.field?.properties?.dataSourcId, cell.textFieldValue.isEmpty {
                cell.dataSourceFetchingInTextNumberControl?(dataSourceId, item)
            }
            
            cell.isUserInteractionEnabled = !item.disabled
            return cell
        case .TextArea:
            guard let item = item as? FormViewModelTextAreaItem else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextAreaTVcell.cerqel_identifier, for: indexPath) as! NewTextAreaTVcell
            cell.isSectionItem = sectionType?.type == .Section
            cell.dataSourceFetching = { [weak self] dataSource, textAreaItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: textAreaItem)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textAreaItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textAreaItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.item = item
            cell.formViewController = self
            cell.textViewEndEditing = { [unowned self] text, isError in
                let textAnswer = (item.answer as? TextAreaAnswer)?.htmlValue?.lowercased()
                let newTextAnswer = text?.htmlValue?.lowercased()
                if textAnswer != newTextAnswer, cell.item.fieldId == item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: text, isError: isError,reload: false)
                }
            }
            
            
            
            cell.tag = section
            cell.isUserInteractionEnabled = !item.disabled
            return cell
        case .Paragraph:
            if item is FormViewModelParagraphItem {
                
                let subType = item.paragraphSubType
                if subType == .Text {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLblTVcell.cerqel_identifier, for: indexPath) as! NewLblTVcell
                    cell.formViewController = self
                    cell.valueChanged = {[weak self] value in
                        guard let `self` = self else {return}
                        if value.value != (item.answer as? ParagraphAnswer)?.value ,item.fieldId == cell.item.fieldId {
                            FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: value, reload: false)
                        }
                    }
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            if FormManager.shared.isEditable {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                                    return
                                }
                            }
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    cell.item = item
                    cell.tag = section
                    cell.isUserInteractionEnabled = !item.disabled
                    return cell
                }
                if subType == .Link {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLinkControlTVcell.cerqel_identifier, for: indexPath) as! NewLinkControlTVcell
                    cell.formViewController = self
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    cell.isUserInteractionEnabled = !item.disabled
                    
                    return cell
                }
                if subType == .InfoIndcator {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewInfoIndicatorTVcell.cerqel_identifier, for: indexPath) as! NewInfoIndicatorTVcell
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.item = item
                    cell.tag = section
                    cell.isUserInteractionEnabled = !item.disabled
                    
                    return cell
                }
                if subType == .LabelSheetWithToggle {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheetWithCheckBox = false
                    cell.isLabelSheet = false
                    cell.formViewController = self
                    cell.isSectionItem = sectionType?.type == .Section
                    
                    cell.reloadTableView = {[weak self] in
                        guard let `self` = self else { return }
                        self.formTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            if FormManager.shared.isEditable {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                                    return
                                }
                            }
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    cell.item = item
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
                    }
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: paragraphAnswer, reload: false)
                    }
                    cell.isUserInteractionEnabled = !item.disabled
                    
                    return cell
                }
                
                if subType == .LabelSheetWithCheckBox {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheetWithCheckBox = true
                    cell.isLabelSheet = false
                    cell.formViewController = self
                    cell.isSectionItem = sectionType?.type == .Section
                    
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            if FormManager.shared.isEditable {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                                    return
                                }
                            }
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    
                    cell.item = item
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
                    }
                    
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: paragraphAnswer, reload: false)
                    }
                    cell.isUserInteractionEnabled = !item.disabled
                    
                    return cell
                }
                
                if subType == .LabelSheet {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheet = true
                    cell.formViewController = self
                    cell.isSectionItem = sectionType?.type == .Section
                    cell.dataSourceFetching = { [weak self] dataSource, labelItem in
                        guard let `self` = self else { return }
                        DispatchQueue.global(qos: .background).async { [weak self] in
                            guard let `self` = self else { return }
                            if FormManager.shared.isEditable {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                                    return
                                }
                            }else {
                                if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                                    return
                                }
                            }
                            formBuilder.setSelfControlCascadingForSameControl(item: labelItem)
                            if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                                }
                            } else {
                                print("textBoxItem not found in sectionObjects")
                            }
                        }
                    }
                    cell.item = item
                    
                    cell.didTapOpenBottomSheet = {[weak self] in
                        guard let `self` = self else {return}
                        let sheet = LabelBottomSheetVC.instance(item: item)
                        sheet.show(vc: self, sender: nil)
                    }
                    
                    cell.validationChanged = {[weak self] ans in
                        guard let `self` = self else {return}
                        let paragraphAnswer = ParagraphAnswer(val: "\(ans)", htmlValue: (item.answer as? ParagraphAnswer)?.htmlValue)
                        FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: paragraphAnswer, reload: false)
                    }
                    return cell
                }
            }
            return UITableViewCell()
            
        case .Date:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDatePickerTVCell.cerqel_identifier, for: indexPath) as! NewDatePickerTVCell
            cell.tag = section
            cell.formViewController = self
            cell.valueChanged = { [unowned self] value, isError in
                if item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: value, isError: isError, reload: false)
                }
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, dateItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: dateItem)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == dateItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.isUserInteractionEnabled = !item.disabled
            
            return cell
            
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewSwitchCell.cerqel_identifier, for: indexPath) as! NewSwitchCell
            cell.isSectionItem = sectionType?.type == .Section
            
            cell.dataSourceFetching = { [weak self] dataSource, switchItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: switchItem)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == switchItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.item = item
            cell.formViewController = self
            cell.tag = section
            cell.valueChanged = { [unowned self] value, isError in
                if (item.answer as? SwitchAnswer)?.value as? Bool != value?.value as? Bool, item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: value, isError: isError, reload: false)
                }
            }
            
            
            cell.isUserInteractionEnabled = !item.disabled
            
            return cell
        case .Checkbox:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            
            cell.isFromRequest = FormManager.shared.isEditable
            cell.handleDissabledControl(isFromRequest: FormManager.shared.isEditable, item: item as? FormViewModelMCQBaseItem)
            
            cell.dataSourceFetching = { [weak self] dataSource, checkBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: checkBoxItem)
                    if let _ = item.field?.properties?.dataSource {
                        if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                            sectionObject.items.contains(where: { $0.fieldId == checkBoxItem.fieldId })
                        }) {
                            if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkBoxItem.fieldId }) {
                                print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                     currentId: item.fieldId,
                                                                                     parameters: item.field?.properties?.dataSource?.parameters)
                                FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                            }
                        } else {
                            print("textBoxItem not found in sectionObjects")
                        }
                    }
                }
            }
            cell.formViewController = self
            cell.valueChangedCheckBox = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: value,isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.isUserInteractionEnabled = !item.disabled
            
            
            return cell
        case .Radio:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            
            cell.isFromRequest = FormManager.shared.isEditable
            cell.handleDissabledControl(isFromRequest: FormManager.shared.isEditable, item: item as? FormViewModelMCQBaseItem)
            
            
            cell.formViewController = self
            cell.valueChangedRadio = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId{
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: value,isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            
            cell.dataSourceFetching = { [weak self] dataSource, radioItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: radioItem)
                    if let _ = item.field?.properties?.dataSource {
                        if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                            sectionObject.items.contains(where: { $0.fieldId == radioItem.fieldId })
                        }) {
                            if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                                print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                     currentId: item.fieldId,
                                                                                     parameters: item.field?.properties?.dataSource?.parameters)
                                FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                            }
                        } else {
                            print("textBoxItem not found in sectionObjects")
                        }
                    }
                }
            }
            cell.item = item
            cell.isUserInteractionEnabled = !item.disabled
            
            
            return cell
        case .Dropdown:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDropDownTVCell.cerqel_identifier, for: indexPath) as! NewDropDownTVCell
            cell.formViewController = self
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            
            cell.dataSourceFetchingInDDL = {[weak self] dataSource, ddlItem in
                guard let `self` = self else {return}
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: ddlItem)
                    if let _ = item.field?.properties?.dataSource {
                        if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                            sectionObject.items.contains(where: { $0.fieldId == ddlItem.fieldId })
                        }) {
                            if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == ddlItem.fieldId }) {
                                print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                     currentId: item.fieldId,
                                                                                     parameters: item.field?.properties?.dataSource?.parameters)
                                FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                            }
                        } else {
                            print("textBoxItem not found in sectionObjects")
                        }
                    }
                }
            }
            cell.item = item
            cell.dropDownPressed = { [weak self] options, title, placeHolder, selectedValues, multiSelect, selectAllEnabled, ddlSubType in
                guard let `self` = self else {return}
                if ddlSubType == "Search" {
                    if !options.isEmpty {
                        self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                        FormManager.shared.selectOptionFromSearch(vc: self,
                                                                  sectionObjects: formBuilder.sectionObjects,
                                                                  submitButton: submitButton,
                                                                  code: self.formBuilder.searchComponents.value?.keys.first ?? "" ,
                                                                  options: options,
                                                                  title: title,
                                                                  placeHolder: placeHolder,
                                                                  selectedValues: selectedValues,
                                                                  multiSelect: multiSelect,
                                                                  selectAllEnabled: selectAllEnabled,
                                                                  section: section,
                                                                  row: row)
                    } else {
                        if let dropDownitem = item as? FormViewModelDropdownItem {
                            DispatchQueue.main.async {[weak self] in
                                guard let `self` = self else {return}
                                self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                FormManager.shared.fetchOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, code: dropDownitem.dataSourcId ?? "", section: section, row: row) { opts in
                                    self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                    FormManager.shared.selectOptionFromSearch(vc: self,
                                                                              sectionObjects: self.formBuilder.sectionObjects,
                                                                              submitButton: self.submitButton,
                                                                              code: self.formBuilder.searchComponents.value?.keys.first ?? "" ,
                                                                              options: opts,
                                                                              title: title,
                                                                              placeHolder: placeHolder,
                                                                              selectedValues: selectedValues,
                                                                              multiSelect: multiSelect,
                                                                              selectAllEnabled: selectAllEnabled,
                                                                              section: section,
                                                                              row: row)
                                }
                            }
                        }
                    }
                }else {
                    guard !options.isEmpty else {
                        if let dropDownitem = item as? FormViewModelDropdownItem {
                            DispatchQueue.main.async {[weak self] in
                                guard let `self` = self else {return}
                                self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                FormManager.shared.fetchOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, code: dropDownitem.dataSourcId ?? "", section: section, row: row) { opts in
                                    FormManager.shared.selectOption(vc: self,
                                                                    sectionObjects: self.formBuilder.sectionObjects,
                                                                    submitButton: self.submitButton,
                                                                    options: opts,
                                                                    title: title,
                                                                    selectedValues: selectedValues,
                                                                    multiSelect: multiSelect,
                                                                    selectAllEnabled: selectAllEnabled,
                                                                    section: section,
                                                                    row: row)
                                }
                            }
                        }
                        return
                    }
                    FormManager.shared.selectOption(vc: self,
                                                    sectionObjects: self.formBuilder.sectionObjects,
                                                    submitButton: submitButton,
                                                    options: options,
                                                    title: title,
                                                    selectedValues: selectedValues,
                                                    multiSelect: multiSelect,
                                                    selectAllEnabled: selectAllEnabled,
                                                    section: section,
                                                    row: row)
                }
            }
            cell.validationChanged = { [unowned self] valid in
                if let _ = item as? FormViewModelDropdownItem {
                    formBuilder.sectionObjects[section].items[row].isError = !valid
                }
            }
            cell.valueChanged = {[weak self] value, isError in
                guard let `self` = self else {return}
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, section, row: row, value: value,isError: isError, reload: false, userInteracted: cell.item.isUpdated)
                    cell.item.isUpdated = false
                }
            }
            
            cell.isUserInteractionEnabled = !item.disabled
            
            return cell
            
        case .FileUpload:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewUploadMediaTVcell.cerqel_identifier, for: indexPath) as! NewUploadMediaTVcell
            cell.tag = section
            cell.formViewController = self
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            self.maxAttachmentsSize = cell.maxAttachmentsSize
            cell.didTapAddAttachment = {[weak self] in
                guard let `self` = self else {return}
                self.formBuilder.fileUploadFieldID = item.fieldId
                self.formBuilder.fileUploadFieldRow = row
                self.formBuilder.fileUploadFieldSection = section
                if let arr = item as? FormViewModelFileUploadItem{
                    arr.syncPropertiesFromFileUploadProperties()
                    if arr.attachmentsList.count < arr.maxAttachmentsNumber ?? 0 || arr.maxAttachmentsNumber == nil  {
                        self.selectedMediaUploaderIdx = indexPath.row
                        self.uploadingExtensions = arr.attachmentExtensions
                        self.openMFileMenu(attachmentExtensions: arr.attachmentExtensions)
                    }
                }
            }
            
            cell.didRemoveAttachment = { attachmentID in
                guard let item = item as? FormViewModelFileUploadItem else { return }
                let indexToDelete = item.attachmentsList.firstIndex(where: { $0.id == attachmentID })
                item.attachmentsList.remove(at: indexToDelete ?? 0)
                guard let newAnswer = item.answer as? FileUploadAnswer else {
                    tableView.reloadSections(IndexSet(integer: section), with: .none)
                    return
                }
                newAnswer.value?.remove(at: indexToDelete ?? 0)
                item.answer = newAnswer
                tableView.reloadSections(IndexSet(integer: section), with: .none)
            }
            cell.isUserInteractionEnabled = !item.disabled
            
            cell.didTapDownloadAttachment = { downloadUrl in
                let url = downloadUrl
                FormManager.shared.downloadMedia(url: url) {[weak self] (imageDownloaded) in
                    guard let `self` = self else {return}
                    if !imageDownloaded {
                        FormManager.shared.downloadVideo(url: url) {[weak self] videoDownloaded in
                            guard let `self` = self else {return}
                            if !videoDownloaded {
                                FormManager.shared.downloadFile(vc: self, url: url)
                            }else {
                                DispatchQueue.main.async {[weak self] in
                                    guard let `self` = self else {return}
                                    FormManager.shared.showToast(vc: self, message: "Downloaded Successfully".localized, seconds: 3)
                                }
                            }
                        }
                    }else {
                        DispatchQueue.main.async {[weak self] in
                            guard let `self` = self else {return}
                            FormManager.shared.showToast(vc: self, message: "Downloaded Successfully".localized, seconds: 3)
                        }
                    }
                }
            }
            
            return cell
            
        case .Table:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTableControlTVCell.cerqel_identifier, for: indexPath) as! NewTableControlTVCell
            cell.formViewController = self
            cell.isSectionItem = sectionType?.type == .Section
            cell.dataSourceFetching = { [weak self] dataSource, tableItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if FormManager.shared.isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    var tableItems = [FormViewModelItem]()
                    for section in formBuilder.sectionObjects {
                        for item in section.items {
                            if let tableItem =  item as? FormViewModelTableItem {
                                for child in tableItem.childControls {
                                    tableItems.append(child)
                                }
                            }
                        }
                    }
                    formBuilder.appendSelfControlCascadingforItems(items: tableItems)
                    if let sectionIndex = formBuilder.sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == tableItem.fieldId })
                    }) {
                        if let rowIndex = formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == tableItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: submitButton, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.item = item
            cell.isEditable = FormManager.shared.isEditable
            if let _ = item as? FormViewModelTableItem {
                cell.item.isUpdated = false
            }
            
            if let table = item as? FormViewModelTableItem {
                FormManager.shared.validateTableItems(vc: self, sectionObjects: formBuilder.sectionObjects, submitButton: self.submitButton, table.items, in: cell, section: indexPath.section, row: indexPath.row)
            }
            
            cell.validationChanged = {[weak self] valid, updateRules in
                guard let `self` = self else {return}
                if updateRules {
                    
                    self.formBuilder.handleItemRules(self.formBuilder.sectionObjects[section].items[row], excludedView: FormManager.shared.isEditable ? .Edit : .Create, removeAnswer: false)
                }
                cell.item.isUpdated = false
            }
            
            cell.didTapAdd = {[weak self] completion in
                guard let `self` = self else {return}
                // Perform the "add" logic here.
                
                self.formBuilder.handleItemRules(self.formBuilder.sectionObjects[section].items[row], excludedView: FormManager.shared.isEditable ? .Edit : .Create, removeAnswer: false)
                if (item as? FormViewModelTableItem)?.items.count ?? 0 >= (item.field?.properties as? TableProperties)?.maxRows ?? 0 {
                    var msg = ""
                    msg = isArabic() ? (item as? FormViewModelTableItem)?.field?.properties?.localization?["ar"]?.fieldWarning?.maxRows ?? self.formBuilder.form.warnings?.formWarning?.fieldValidation?.table?.maxRows ?? "" : (item as? FormViewModelTableItem)?.field?.properties?.localization?["en"]?.fieldWarning?.maxRows ?? self.formBuilder.form.warnings?.formWarning?.fieldValidation?.table?.maxRows ?? ""
                    self.showToastWithError(msg)
                    cell.item.isUpdated = false
                }
                completion()
            }
            
            cell.didDeleteTableItem = { [weak self] idx in
                guard let self = self else { return }
                
                // Iterate through each item and update rowIndex
                
                // Filter out the deleted item
                // Assuming idx is the index of the row to be deleted
                let deletedRowIndex = idx + 1
                
                if (FormManager.shared.rowIndices.isEmpty ?? false ){
                    FormManager.shared.rowIndices = formBuilder.allRowsChildControls
                        .compactMap { Int($0.rowIndex ?? "0") }
                        .sorted()
                }
                
                // Find the index of the deleted row
                var indexToRemove = FormManager.shared.rowIndices.firstIndex(of: deletedRowIndex)
                
                while let index = indexToRemove {
                    FormManager.shared.rowIndices.remove(at: index)
                    indexToRemove = FormManager.shared.rowIndices.firstIndex(of: deletedRowIndex)
                }
                
                var updatedRowIndices: [Int] = []
                
                for (_, rowIndex) in FormManager.shared.rowIndices.enumerated() {
                    if rowIndex > deletedRowIndex {
                        updatedRowIndices.append(rowIndex - 1)
                    } else {
                        updatedRowIndices.append(rowIndex)
                    }
                }
                
                // Assign the updatedRowIndices to rowIndices
                FormManager.shared.rowIndices = updatedRowIndices
                
                
                // Update the rowIndex for each item in allRowsChildControls
                for var item in formBuilder.allRowsChildControls {
                    if let rowIndexString = item.rowIndex, let oldIndex = Int(rowIndexString) {
                        if let newIndex = FormManager.shared.rowIndices.firstIndex(of: oldIndex + 1) {
                            item.rowIndex = String(FormManager.shared.rowIndices[newIndex])
                        }
                    }
                }
                if let tableComponent = item as? FormViewModelTableItem {
                    if !tableComponent.childControls.isEmpty {
                        for child in tableComponent.childControls {
                            child.answer = nil
                        }
                    }
                }
                let sortedArr = formBuilder.allRowsChildControls.sorted {
                    // Use optional chaining to safely unwrap and compare rowIndex values
                    let index1 = $0.rowIndex ?? ""
                    let index2 = $1.rowIndex ?? ""
                    return index1 < index2
                }
                formBuilder.allRowsChildControls = sortedArr
                if formBuilder.allRowsChildControls.count > FormManager.shared.rowIndices.count {
                    let excessItemCount = formBuilder.allRowsChildControls.count - FormManager.shared.rowIndices.count
                    formBuilder.allRowsChildControls = formBuilder.allRowsChildControls.filter { Int($0.rowIndex ?? "0") != (idx + 1) }
                    
                    for i in 0 ..< min(formBuilder.allRowsChildControls.count, FormManager.shared.rowIndices.count) {
                        let rowIndex = FormManager.shared.rowIndices[i] // Get the corresponding index from rowIndices
                        formBuilder.allRowsChildControls[i].rowIndex = "\(rowIndex)"
                    }
                    
                }
                
                if formBuilder.allRowsChildControls.isEmpty {
                    formBuilder.isRuleViolated = false
                }
                tableView.reloadSections(IndexSet(integer: section), with: .none)
                
                if ((item as? FormViewModelTableItem)?.items.count ?? 0) < (item as? FormViewModelTableItem)?.minRows ?? 0 {
                    var msg = ""
                    msg = isArabic() ? (item as? FormViewModelTableItem)?.field?.properties?.localization?["ar"]?.fieldWarning?.minRows ?? self.formBuilder.form.warnings?.formWarning?.fieldValidation?.table?.minRows ?? "" : (item as? FormViewModelTableItem)?.field?.properties?.localization?["en"]?.fieldWarning?.minRows ?? self.formBuilder.form.warnings?.formWarning?.fieldValidation?.table?.minRows ?? ""
                    if !(msg.isEmpty ) {
                        self.showToastWithError(msg)
                    }
                }
                
            }
            
            cell.handleHiddenViews(item: item as? FormViewModelTableItem,isRequest: 0)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = FormManager.shared.getCurrentItem(sectionObjects: formBuilder.sectionObjects, indexPath: indexPath)
        if item.hidden {
            return 0
        }
        return UITableView.automaticDimension
    }
    
}

extension FormViewController: UploadMedia {
    /// uploading file
    /// - Parameters:
    ///   - fileSize: file size
    ///   - url: file url
    func uploadFile(fileSize: Double, url: URL, isVideo: Bool) {
        if let maxSize = maxAttachmentsSize {
            if fileSize > Double(maxSize) {
                let errMsg = formBuilder.getUploadFileMaxSizeErrorMsg(maxSize: maxSize, row: "\(formBuilder.fileUploadFieldID)")
                showToastCerqel(parentView: self, msg: errMsg)
                return
            }
        }
        
        if isVideo {
            self.formBuilder.uploadVideo(videoURL: url) {[weak self] val in
                guard let `self` = self else {return}
                FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: submitButton, self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
            }
        }else {
            self.formBuilder.uploadMedia(fieldID: formBuilder.fileUploadFieldID, photo: nil, fileUrl: url) {[weak self] val in
                guard let `self` = self else {return}
                FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: submitButton, self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
            }
        }
    }
    
    /// uploading image
    /// - Parameters:
    ///   - imageSize: image size
    ///   - photo: image to be uploaded
    func uploadImage(imageSize: Int, photo: UIImage) {
        if let maxSize = maxAttachmentsSize {
            if imageSize > maxSize {
                let errMsg = formBuilder.getUploadFileMaxSizeErrorMsg(maxSize: maxSize, row: "\(formBuilder.fileUploadFieldID)")
                showToastCerqel(parentView: self, msg: errMsg)
                return
            }
        }
        self.formBuilder.uploadMedia(fieldID: self.formBuilder.fileUploadFieldID, photo: photo, fileUrl: nil) {[weak self] val in
            guard let `self` = self else {return}
            FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.formBuilder.sectionObjects, submitButton: submitButton, self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
        }
    }
}
