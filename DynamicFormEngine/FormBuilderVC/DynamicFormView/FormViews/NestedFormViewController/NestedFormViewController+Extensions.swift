//
//  NestedFormViewController+Extensions.swift
//
//
//  Created by Hassan elshair on 14/02/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit
import EzPopup
//internal import FittedSheetsDF
import Expression
import RxCocoa
internal import RxSwift
import SwiftUI


extension NestedFormViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let sectionType = sectionObjects[section].item
        
        let item = FormManager.shared.getCurrentItem(sectionObjects: sectionObjects, indexPath: indexPath)
        let hiddenCell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
        
        if item.hidden {
            
            return hiddenCell
        }else {
            if isFromRequestDetails {
                if item.type == .FileUpload, let mediaItem = item as? FormViewModelFileUploadItem {
                    if mediaItem.attachmentsList.isEmpty {
                        return hiddenCell
                    }
                }
            }
        }
        switch item.type {
        case .TextBox, .Numerical:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextBoxTVCell.cerqel_identifier, for: indexPath) as! NewTextBoxTVCell
            cell.tag = section
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.formViewController = self
            if (item.answer as? TextboxAnswer) != nil && ((item.field?.properties as? TextBoxProperties)?.required ?? false) && item.isError == false  {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            
            if isFromRequestDetails {
                cell.handleDisabledText(disabled: true)
            }
            
            if (item.answer as? BaseAnswerText) != nil && ((item.field?.properties as? NumberProperties)?.required ?? false) && item.isError == false  {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.valueChanged = { [unowned self] text, isError in
                FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: text, isError: isError, reload: false)
            }
            cell.dataSourceFetchingInTextNumberControl = { [weak self] dataSource, textBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: textBoxItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textBoxItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textBoxItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            // Check and call the closure if needed
            if let dataSourceId = item.field?.properties?.dataSourcId, cell.textFieldValue.isEmpty {
                cell.dataSourceFetchingInTextNumberControl?(dataSourceId, item)
            }
            cell.validationChanged = { [unowned self] valid in
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: valid)
            }
            cell.numberValueChanged = { [unowned self] numberValue, isError in
                if (item.answer as? BaseAnswerText)?.value as? String != (numberValue as? BaseAnswerText)?.value as? String , item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: numberValue, isError: isError, reload: false)
                }
            }
            return cell
        case .TextArea:
            guard let item = item as? FormViewModelTextAreaItem else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTextAreaTVcell.cerqel_identifier, for: indexPath) as! NewTextAreaTVcell
            cell.item = item
            cell.formViewController = self
            if item.answer != nil {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.textViewEndEditing = { [unowned self] text, isError in
                let textAnswer = (item.answer as? TextAreaAnswer)?.htmlValue?.lowercased()
                let newTextAnswer = text?.htmlValue?.lowercased()
                if textAnswer != newTextAnswer , cell.item.fieldId == item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: text, isError: isError,reload: false)
                }
            }
            cell.validationChanged = { [unowned self] valid in
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: valid)
            }
            if isFromRequestDetails {
                cell.handleDisabledText(disabled: true)
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, textAreaItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: textAreaItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == textAreaItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textAreaItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.tag = section
            return cell
        case .Paragraph:
            if item is FormViewModelParagraphItem {
                let subType = item.paragraphSubType
                if subType == .Text {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLblTVcell.cerqel_identifier, for: indexPath) as! NewLblTVcell
                    FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
                    cell.formViewController = self
                    
                    cell.valueChanged = {[weak self] value in
                        guard let `self` = self else {return}
                        FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: value, reload: false)
                    }
                    cell.item = item
                    if isFromRequestDetails {
                        cell.handleDisabledText(disabled: true)
                    }
                    cell.tag = section
                    return cell
                }
                if subType == .Link {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewLinkControlTVcell.cerqel_identifier, for: indexPath) as! NewLinkControlTVcell
                    FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
                    cell.item = item
                    cell.formViewController = self
                    cell.tag = section
                    return cell
                }
                if subType == .InfoIndcator {
                    let cell = tableView.dequeueReusableCell(withIdentifier: NewInfoIndicatorTVcell.cerqel_identifier, for: indexPath) as! NewInfoIndicatorTVcell
                    FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
                    cell.item = item
                    cell.formViewController = self
                    cell.tag = section
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
                            if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
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
                        FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.sectionObjects, submitButton: addBtn, section, row: row, value: paragraphAnswer, reload: false)
                    }
                    cell.isUserInteractionEnabled = !item.disabled
                    
                    return cell
                }
                
                if subType == .LabelSheetWithCheckBox {
                    let cell = tableView.dequeueReusableCell(withIdentifier: LabelSheetWithSwitchTVCell.cerqel_identifier, for: indexPath) as! LabelSheetWithSwitchTVCell
                    cell.isLabelSheetWithCheckBox = true
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
                            if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
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
                        FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.sectionObjects, submitButton: addBtn, section, row: row, value: paragraphAnswer, reload: false)
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
                            if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                                sectionObject.items.contains(where: { $0.fieldId == labelItem.fieldId })
                            }) {
                                if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == labelItem.fieldId }) {
                                    print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                                    let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                         currentId: item.fieldId,
                                                                                         parameters: item.field?.properties?.dataSource?.parameters)
                                    FormManager.shared.fetchDataSourceOptionsList(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, code: dataSource, parameters: parameters, section: sectionIndex, row: rowIndex, isLoadCell: true)
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
                        FormManager.shared.fieldValueChangedAt(vc: self, sectionObjects: self.sectionObjects, submitButton: addBtn, section, row: row, value: paragraphAnswer, reload: false)
                    }
                    return cell
                }
            }
            return UITableViewCell()
            
        case .Date:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDatePickerTVCell.cerqel_identifier, for: indexPath) as! NewDatePickerTVCell
            cell.tag = section
            cell.item = item
            cell.formViewController = self
            if item.answer != nil && ((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            if item.answer == nil &&  !((item.field?.properties as? DateTimeProperties)?.required ?? false) {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.valueChanged = { [unowned self] value, isError in
                if item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: value, isError: isError, reload: false)
                }
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: valid)
                
            }
            if isFromRequestDetails {
                cell.handleDisabledDateControl(disabled: true)
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, dateItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: dateItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == dateItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            return cell
            
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewSwitchCell.cerqel_identifier, for: indexPath) as! NewSwitchCell
            cell.item = item
            cell.tag = section
            cell.formViewController = self
            if item.answer != nil && (item.answer as? SwitchAnswer)?.value == true {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                if let item = item as? FormViewModelSwitchItem, !item.required {
                    FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
                }else {
                    FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: valid)
                }
            }
            cell.valueChanged = { [unowned self] value, isError in
                if (item.answer as? SwitchAnswer)?.value as? Bool != value?.value as? Bool, item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: value, isError: isError, reload: false)
                }
            }
            
            cell.dataSourceFetching = { [weak self] dataSource, switchItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: switchItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == switchItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            
            if isFromRequestDetails {
                cell.handleDisabledData(isDisable: true)
            }
            return cell
        case .Checkbox:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.valueChangedCheckBox = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc: self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: value,isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.formViewController = self
            if item.answer != nil && ((item.field?.properties as? CheckboxProperties)?.required ?? false) && item.isError == false {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: valid)
            }
            
            cell.isFromRequest = isFromRequestDetails
            cell.handleDissabledControl(isFromRequest: isFromRequestDetails, item: item as? FormViewModelMCQBaseItem)
            
            
            
            cell.dataSourceFetching = { [weak self] dataSource, checkBoxItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: checkBoxItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == checkBoxItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == checkBoxItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            
            return cell
        case .Radio:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewCheckBoxTVCell.cerqel_identifier, for: indexPath) as! NewCheckBoxTVCell
            cell.tag = section
            cell.valueChangedRadio = { [unowned self] value , isError in
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId{
                    FormManager.shared.fieldValueChangedAt(vc: self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: value,isError: isError, reload: false)
                }
            }
            cell.isSectionItem = sectionType?.type == .Section
            cell.item = item
            cell.formViewController = self
            if item.answer != nil && ((item.field?.properties as? RadioProperties)?.required ?? false) && (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != nil {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.validationChanged = {[weak self] valid in
                guard let `self` = self else {return}
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: valid)
            }
            cell.isFromRequest = isFromRequestDetails
            cell.handleDissabledControl(isFromRequest: isFromRequestDetails, item: item as? FormViewModelMCQBaseItem)
            
            cell.dataSourceFetching = { [weak self] dataSource, radioItem in
                guard let `self` = self else { return }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: radioItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == radioItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            return cell
        case .Dropdown:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewDropDownTVCell.cerqel_identifier, for: indexPath) as! NewDropDownTVCell
            
            cell.dataSourceFetchingInDDL = {[weak self] dataSource, ddlItem in
                guard let `self` = self else {return}
                DispatchQueue.global(qos: .background).async { [weak self] in
                    guard let `self` = self else { return }
                    if isEditable {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Edit]) {
                            return
                        }
                    }else {
                        if let excludedViews = item.field?.properties?.dataSource?.excludedViews, excludedViews.contains([.Create]) {
                            return
                        }
                    }
                    formBuilder.setSelfControlCascadingForSameControl(item: ddlItem)
                    if let sectionIndex = sectionObjects.firstIndex(where: { sectionObject in
                        sectionObject.items.contains(where: { $0.fieldId == ddlItem.fieldId })
                    }) {
                        if let rowIndex = sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == ddlItem.fieldId }) {
                            print("Found textBoxItem in section: \(sectionIndex), row: \(rowIndex)")
                            let parameters = formBuilder.getDataSourceParameters(dataSourceId: item.field?.properties?.dataSourcId ?? "",
                                                                                 currentId: item.fieldId,
                                                                                 parameters: item.field?.properties?.dataSource?.parameters)
                            FormManager.shared.fetchDataSourceOptionsList(vc: self,
                                                                          sectionObjects: self.sectionObjects,
                                                                          submitButton: self.addBtn,
                                                                          code: dataSource,
                                                                          parameters: parameters,
                                                                          section: sectionIndex,
                                                                          row: rowIndex,
                                                                          isLoadCell: true)
                        }
                    } else {
                        print("textBoxItem not found in sectionObjects")
                    }
                }
            }
            cell.tag = section
            cell.parentCascadingItemID = formBuilder.cascadingSourceIDs?.first
            cell.item = item
            cell.formViewController = self
            if item.answer != nil {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.dropDownPressed = { [weak self] options, title, placeHolder, selectedValues, multiSelect, selectAllEnabled, ddlSubType in
                guard let `self` = self else {return}
                if ddlSubType == "Search" {
                    if !options.isEmpty {
                        
                        self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                        FormManager.shared.selectOptionFromSearch(vc: self,
                                                                  sectionObjects: self.sectionObjects,
                                                                  submitButton: addBtn,
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
                                FormManager.shared.fetchOptionsList(vc: self, sectionObjects: self.sectionObjects, code: dropDownitem.dataSourcId ?? "", section: section, row: row) { opts in
                                    self.formBuilder.setSelfControlCascadingForSameControl(item: item)
                                    FormManager.shared.selectOptionFromSearch(vc: self,
                                                                              sectionObjects: self.sectionObjects,
                                                                              submitButton: self.addBtn,
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
                                FormManager.shared.fetchOptionsList(vc: self, sectionObjects: self.sectionObjects, code: dropDownitem.dataSourcId ?? "", section: section, row: row) { opts in
                                    FormManager.shared.selectOption(vc: self,
                                                                    sectionObjects: self.sectionObjects,
                                                                    submitButton: self.addBtn,
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
                        return}
                    FormManager.shared.selectOption(vc: self,
                                                    sectionObjects: self.sectionObjects,
                                                    submitButton: self.addBtn,
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
                self.sectionObjects[section].items[row].isError = !valid
            }
            cell.valueChanged = {[weak self] value, isError in
                guard let `self` = self else {return}
                if (item.answer as? BaseAnswerMCQ)?.value as? [MCQOption] != value?.value as? [MCQOption], item.fieldId == cell.item.fieldId {
                    FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,section, row: row, value: value,isError: isError, reload: false)
                }
            }
            
            if isFromRequestDetails {
                cell.disableDropDown()
            }
            return cell
            
        case .FileUpload:
            let cell = tableView.dequeueReusableCell(withIdentifier: NewUploadMediaTVcell.cerqel_identifier, for: indexPath) as! NewUploadMediaTVcell
            cell.tag = section
            cell.isRequest = isFromRequestDetails
            cell.item = item
            cell.formViewController = self
            FormManager.shared.validation(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, item, section, row)
            self.maxAttachmentsSize = cell.maxAttachmentsSize
            if item.answer != nil {
                FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
            }
            cell.didTapAddAttachment = {[weak self] in
                guard let `self` = self else {return}
                self.formBuilder.fileUploadFieldID = item.fieldId
                self.formBuilder.fileUploadFieldRow = row
                self.formBuilder.fileUploadFieldSection = section
                if let arr = item as? FormViewModelFileUploadItem {
                    arr.syncPropertiesFromFileUploadProperties()
                    if arr.attachmentsList.count < arr.maxAttachmentsNumber ?? 0 || arr.maxAttachmentsNumber == nil {
                        self.selectedMediaUploaderIdx = indexPath.row
                        self.uploadingExtensions = arr.attachmentExtensions
                        self.openMFileMenu(attachmentExtensions: arr.attachmentExtensions)
                    }
                }
            }
            
            cell.didRemoveAttachment = { attachmentID in
                guard let item = item as? FormViewModelFileUploadItem else { return }
                item.attachmentsList.removeAll(where: { $0.id == attachmentID })
                tableView.reloadSections(IndexSet(integer: section), with: .none)
            }
            
            cell.validationChanged = { [unowned self] valid in
                if let item = item as? FormViewModelFileUploadItem, !item.required {
                    FormManager.shared.fieldValidationChangedAt(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, section, row: row, isValid: true)
                }else {
                    FormManager.shared.validation(vc: self, sectionObjects: sectionObjects, submitButton: addBtn, item, section, row)
                }
            }
            
            
            
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
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = FormManager.shared.getCurrentItem(sectionObjects: sectionObjects, indexPath: indexPath)
        if item.hidden {
            return 0
        }
        return UITableView.automaticDimension
    }
}

extension NestedFormViewController: UploadMedia {
    func uploadFile(fileSize: Double, url: URL, isVideo: Bool) {
        if let maxSize = maxAttachmentsSize {
            if fileSize > Double(maxSize) {
                let errMsg = formBuilder.getUploadFileMaxSizeErrorMsg(maxSize: maxSize, row: "\(formBuilder.fileUploadFieldID)")
                CerqelUIManager.showToast(parent: self, msg: errMsg)
                
                return
            }
        }
        
        if isVideo {
            self.formBuilder.uploadVideo(videoURL: url) {[weak self] val in
                guard let `self` = self else {return}
                FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
            }
        }else {
            self.formBuilder.uploadMedia(fieldID: formBuilder.fileUploadFieldID, photo: nil, fileUrl: url) {[weak self] val in
                guard let `self` = self else {return}
                FormManager.shared.fieldValueChangedAt(vc:self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
            }
        }
    }
    
    func uploadImage(imageSize: Int, photo: UIImage) {
        if let maxSize = maxAttachmentsSize {
            if imageSize > maxSize {
                let errMsg = formBuilder.getUploadFileMaxSizeErrorMsg(maxSize: maxSize, row: "\(formBuilder.fileUploadFieldID)")
                CerqelUIManager.showToast(parent: self, msg: errMsg)
                return
            }
        }
        self.formBuilder.uploadMedia(fieldID: self.formBuilder.fileUploadFieldID, photo: photo, fileUrl: nil) {[weak self] val in
            guard let `self` = self else {return}
            FormManager.shared.fieldValueChangedAt(vc: self,sectionObjects: self.sectionObjects,submitButton: self.addBtn,self.formBuilder.fileUploadFieldSection, row: self.formBuilder.fileUploadFieldRow, value: val)
        }
    }
}
