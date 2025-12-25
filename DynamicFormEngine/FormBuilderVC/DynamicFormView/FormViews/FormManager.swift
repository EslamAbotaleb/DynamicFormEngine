//
//  FormManager.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 02/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit
import EzPopup
import JGProgressHUD
import RxCocoa
internal import RxSwift
import Photos

private struct cerqel_HUDHolder {
    static var shared: LottieHUD = {
        let hud = LottieHUD("loading")
        return hud
    }()
}

// MARK: - Related To FormViewController & NestedForm

class FormManager {
    
    // MARK: - Variables
    
    static let shared = FormManager()
    private let disposeBag = DisposeBag()
    var uniqueIdentifiers = [String]()
    var managerSectionObjects: BehaviorRelay<([SectionObject],FormBaseViewController?)> = BehaviorRelay(value: ([],nil)) {
        didSet {
            let nested = (managerSectionObjects.value.1 as? NestedFormViewController) != nil ? true : false
            managerSectionObjects.accept((FormBuilder.shared.sort(managerSectionObjects.value.0,
                                                                  nested: nested),
                                          managerSectionObjects.value.1))
        }
    }
    var rowIndices: [Int] = []
    var isEditable = false
    var cerqel_HUD: LottieHUD {
        get {
            return cerqel_HUDHolder.shared
        }
    }
    
    
    // MARK: - Init
    
    private init() {}
    
    
    // MARK: - Functions
    
    /// setting the updated item with it's answer into managerSectionObjects
    /// - Parameters:
    ///   - item: the updated item
    ///   - vc: presentation VC
    ///   - section: current section number
    ///   - row: current row number
    func replace(item: FormViewModelItem, in vc: FormBaseViewController, at section: Int, and row: Int) {
        if vc is FormViewController {
            FormBuilder.shared.sectionObjects[section].items[row] = item
        } else {
            var managerItems = managerSectionObjects.value.0
            var managerFormItem = managerItems[section].items[row]
            managerFormItem = item
            managerItems[section].items[row] = managerFormItem
            managerSectionObjects.accept((managerItems,vc))
        }
    }
    
    
    /// Fetching options list
    /// - Parameters:
    ///   - code: contro's data source id
    ///   - section: current section number
    ///   - row: current row number
    func fetchOptionsList(vc: FormBaseViewController, sectionObjects: [SectionObject], code: String, section: Int, row: Int, isLoadCell: Bool = false, completion: (([MCQOption]) -> Void)? = nil) {
        managerSectionObjects.accept((sectionObjects,vc))
        if !isLoadCell {
            DispatchQueue.main.async {
                self.cerqel_HUD.showHUD()
            }
        }
        
        let timeout: TimeInterval = 30.0
        var disposable: Disposable?
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let timeoutWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.cerqel_HUD.stopHUD()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
            
            DispatchQueue.main.async {
                self.cerqel_HUD.stopHUD()
            }
            disposable = cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObjectDynamicForm<SearchDynamicModel>(action: Dynamic_BasicAction.fetchDDLOptions(code: code, targetComponents: vc.formBuilder.targetComponents.value)))
                .subscribe(onNext: { [weak self] (response) in
                    guard let `self` = self else { return }
                    
                    DispatchQueue.main.async {
                        timeoutWorkItem.cancel() // Cancel the timeout work item
                        self.cerqel_HUD.stopHUD()
                        
                        if let data = response.item?.data {
                            if let components = data.components {
                                for component in components {
                                    if let values = component.values, !values.isEmpty, section >= 0, section < self.managerSectionObjects.value.0.count {
                                        guard let itemIndex = self.managerSectionObjects.value.0[section].items.firstIndex(where: { $0.fieldId == component.id }) else {
                                            // Handle the case where no matching item is found
                                            return
                                        }
                                        let item = self.managerSectionObjects.value.0[section].items[itemIndex]
                                        
                                        var opts = [MCQOption]()
                                        
                                        if let dropDownItem = item as? FormViewModelDropdownItem {
                                            guard !values.isEmpty else {
                                                if data.cascadeTargetType == 0 { //options
                                                    dropDownItem.options = []
                                                } else if data.cascadeTargetType == 1 { //value
                                                    dropDownItem.answer = nil
                                                }else {
                                                    dropDownItem.options = []
                                                }
                                                
                                                self.replace(item: dropDownItem, in: vc, at: section, and: itemIndex)
                                                self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                                return
                                            }
                                            
                                            if data.cascadeTargetType == 0 { //options
                                                for val in values {
                                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                                    opts.append(object)
                                                }
                                                dropDownItem.options = opts
                                                
                                                self.replace(item: dropDownItem, in: vc, at: section, and: itemIndex)
                                                self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                                completion?(opts)
                                            } else if data.cascadeTargetType == 1 { //value
                                                for val in values {
                                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                                    opts.append(object)
                                                }
                                                let _ = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                                
                                                self.replace(item: dropDownItem, in: vc, at: section, and: itemIndex)
                                                self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                                completion?(opts)
                                            }else { //options
                                                for val in values {
                                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                                    opts.append(object)
                                                }
                                                dropDownItem.options = opts
                                                
                                                self.replace(item: dropDownItem, in: vc, at: section, and: itemIndex)
                                                self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                                completion?(opts)
                                            }
                                            
                                            if opts.isEmpty {
                                                dropDownItem.isCascadeValuesEmpty = true
                                            } else {
                                                dropDownItem.isCascadeValuesEmpty = false
                                            }
                                            // Call completion when changes are saved
                                        } else if let paragraphItem = item as? FormViewModelParagraphItem {
                                            let ans = ParagraphAnswer(val: "false", htmlValue: values.map({ $0.name ?? "" }).first, lNote: nil, lAttachments: nil)
                                            paragraphItem.answer = ans
                                            
                                            self.replace(item: paragraphItem, in: vc, at: section, and: itemIndex)
                                            self.saveChanges(activeTableView: vc.activeTableView, reload: false, section: section, row: row)
                                        }else if let numericItem = item as? FormViewModelNumericItem {
                                            let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                            numericItem.answer = ans
                                            
                                            self.replace(item: numericItem, in: vc, at: section, and: itemIndex)
                                            self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                        }else if let textItem = item as? FormViewModelTextBoxItem {
                                            let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                            textItem.answer = ans
                                            
                                            self.replace(item: textItem, in: vc, at: section, and: itemIndex)
                                            self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }, onError: { [weak self] (error) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.cerqel_HUD.stopHUD()
                    }
                })
            
            self.disposeBag.insert(disposable!)
        }
    }
    
    /// Fetching data using json's dataSource
    /// - Parameters:
    ///   - vc: presenting view controller
    ///   - sectionObjects: children sections of vc
    ///   - submitButton: vc's submit button
    ///   - code: data source id
    ///   - parameters: payload parameters
    ///   - section: current section number
    ///   - row: current row number
    ///   - isLoadCell: for showing loader
    ///   - completion: returned options
    func fetchDataSourceOptionsList(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, code: String, parameters: [[String:String]], section: Int, row: Int, isLoadCell: Bool = false, completion: (([MCQOption]) -> Void)? = nil) {
        managerSectionObjects.accept((sectionObjects,vc))
        
        let targetComps =  getTargetComponents(vc: vc, for: code, row: row).isEmpty ? vc.formBuilder.targetComponents.value :  getTargetComponents(vc: vc, for: code, row: row)
        var params = [[String:String]]()
        if parameters.first?.keys.first != parameters.first?.values.first {
            params = parameters
        }
        
        cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObjectDynamicForm<SearchDynamicModel>(action: Dynamic_BasicAction.fetchDataSourceOptions(code: code, parameters: params, targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            var sectionIndex = 0
            var isFromTable = false
            var isCascadeInsideTable = false
            
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            if component.rowIndex != nil {
                                // if its row you need to return components with rowIndex
                                // else you need to return components with null rowIndex
                                if components.count >= vc.formBuilder.tableSectionObjects.count {
                                    isFromTable = true
                                    isCascadeInsideTable = false
                                }else {
                                    isCascadeInsideTable = true
                                }
                                
                                if let nestedVC = vc as? NestedFormViewController {
                                    sectionIndex = nestedVC.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                    self.updateFieldsValues(vc: nestedVC, sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
                                }
                            } else if component.parentId != nil && component.rowIndex == nil {
                                
                                isCascadeInsideTable = true
                                isFromTable = false
                                
                                sectionIndex = vc.formBuilder.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                self.updateFieldsValuesInsideSection(vc: vc,
                                                                     sectionIndex: sectionIndex,
                                                                     row: row,
                                                                     values: values,
                                                                     component: component)
                            }
                            else {
                                guard let sectionIndex = managerSectionObjects.value.0.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) else {return}
                                guard let itemIndex = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == component.id }) else {
                                    // Handle the case where no matching item is found
                                    return
                                }
                                guard itemIndex < managerSectionObjects.value.0[sectionIndex].items.count else {return}
                                let item = managerSectionObjects.value.0[sectionIndex].items[itemIndex]
                                if let dropDownItem = item as? FormViewModelDropdownItem {
                                    let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                    let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                    if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                        dropDownItem.answer = nil
                                    }
                                    var opts = [MCQOption]()
                                    guard !values.isEmpty else {
                                        dropDownItem.options = []
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                
                                                self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        return
                                    }
                                    for val in values {
                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                        opts.append(object)
                                    }
                                    if data.cascadeTargetType == 0 { //options
                                        dropDownItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                
                                                self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    } else if data.cascadeTargetType == 1 { //value
                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                        dropDownItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                
                                                self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else {
                                        dropDownItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                
                                                self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
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
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                                            
                                            self.replace(item: dateItem, in: vc, at: sectionIndex, and: index)
                                        }
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                    let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                    paragraphItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == paragraphItem.fieldId }) {
                                            
                                            self.replace(item: paragraphItem, in: vc, at: sectionIndex, and: index)
                                        }
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let numericItem = item as? FormViewModelNumericItem {
                                    let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                    numericItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == numericItem.fieldId }) {
                                            
                                            self.replace(item: numericItem, in: vc, at: sectionIndex, and: index)
                                        }
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let textItem = item as? FormViewModelTextBoxItem {
                                    let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                    textItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
                                            
                                            self.replace(item: textItem, in: vc, at: sectionIndex, and: index)
                                        }
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let textItem = item as? FormViewModelTextAreaItem {
                                    let ans = TextAreaAnswer(val: values.map({$0.name ?? ""}).first ?? "", htmlVal: "")
                                    textItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
                                            
                                            self.replace(item: textItem, in: vc, at: sectionIndex, and: index)
                                        }
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let switchItem = item as? FormViewModelSwitchItem {
                                    let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                                           lNote: nil,
                                                           lAttachments: nil)
                                    switchItem.answer = ans
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                                            
                                            self.replace(item: switchItem, in: vc, at: sectionIndex, and: index)
                                        }
                                    } else {
                                        print("Warning: Section index \(sectionIndex) is out of bounds.")
                                    }
                                    
                                    self.fieldValidationChangedWhenMultiCascade(vc: vc, submitButton: submitButton, sectionObjects: managerSectionObjects.value.0)
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let checkboxItem = item as? FormViewModelCheckboxItem {
                                    
                                    
                                    let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                    let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                    if currentCascadingItemID != checkboxItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                        checkboxItem.answer = nil
                                    }
                                    var opts = [MCQOption]()
                                    guard !values.isEmpty else {
                                        checkboxItem.options = []
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
                                                
                                                self.replace(item: checkboxItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        return
                                    }
                                    for val in values {
                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                        opts.append(object)
                                    }
                                    if data.cascadeTargetType == 0 { //options
                                        checkboxItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
                                                
                                                self.replace(item: checkboxItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    } else if data.cascadeTargetType == 1 { //value
                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                        checkboxItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
                                                
                                                self.replace(item: checkboxItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else {
                                        checkboxItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == checkboxItem.fieldId }) {
                                                
                                                self.replace(item: checkboxItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }
                                }else if let radioItem = item as? FormViewModelRadioItem {
                                    
                                    
                                    let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                    let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                    if currentCascadingItemID != radioItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                        radioItem.answer = nil
                                    }
                                    var opts = [MCQOption]()
                                    guard !values.isEmpty else {
                                        radioItem.options = []
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                                                
                                                self.replace(item: radioItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        return
                                    }
                                    for val in values {
                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                        opts.append(object)
                                    }
                                    if data.cascadeTargetType == 0 { //options
                                        radioItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                                                
                                                self.replace(item: radioItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    } else if data.cascadeTargetType == 1 { //value
                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                        radioItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                                                
                                                self.replace(item: radioItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else {
                                        radioItem.options = opts
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == radioItem.fieldId }) {
                                                
                                                self.replace(item: radioItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }
                                    
                                    
                                }else if let tableItem = item as? FormViewModelTableItem {
                                    let val = values.first?.name ?? ""
                                    
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        let itemIndex = vc.formBuilder.itemsDict[tableItem.fieldId]?.1 ?? 0
                                        vc.formBuilder.formViewModel.items[itemIndex] = vc.formBuilder.updateItemProperty(item: tableItem, value: [val], payload: vc.formBuilder.currentPropertyTragetName)
                                    }
                                }
                            }
                        }
                    }
                    if isCascadeInsideTable {
                        for (_, tableSectionObject) in vc.formBuilder.tableSectionObjects.enumerated() {
                            for (_, tableItem) in tableSectionObject.items.enumerated() {
                                // Check the fieldId and update
                                for sectionIndex in managerSectionObjects.value.0.indices {
                                    // Get the section object
                                    let section = managerSectionObjects.value.0[sectionIndex]
                                    
                                    // Check the first item in the section
                                    if let sectionItem = (section.items[0] as? FormViewModelTableItem) {
                                        // Check if the sectionItem's fieldId matches the tableItem's parentId
                                        if sectionItem.fieldId == tableItem.parentId {
                                            for (childControlIndex, childControl) in sectionItem.childControls.enumerated() {
                                                // If the childControl's fieldId matches the tableItem's fieldId, update it
                                                if childControl.fieldId == tableItem.fieldId {
                                                    // Update the childControl with tableItem
                                                    sectionItem.childControls[childControlIndex] = tableItem
                                                    
                                                    // Update the section in formBuilder.sectionObjects
                                                    self.replace(item: sectionItem, in: vc, at: sectionIndex, and: 0)
                                                    // Trigger reload or any necessary update logic
                                                    // Your update/reload logic here
                                                    
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    if isFromTable {
                        // Create a dictionary to hold grouped items based on rowIndex
                        var groupedItems: [String: [FormViewModelItem]] = [:]
                        // Iterate through tableSectionObjects to populate the groupedItems dictionary
                        for sectionObject in vc.formBuilder.tableSectionObjects {
                            for item in sectionObject.items {
                                if let rowIndex = item.rowIndex {
                                    // Find the index of the existing item based on specific properties
                                    if let existingIndex = vc.formBuilder.allRowsChildControls.firstIndex(where: { existingItem in
                                        return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
                                    }) {
                                        // Replace the existing item with the new one
                                        vc.formBuilder.allRowsChildControls[existingIndex] = FormViewModelItemStruct(from: item)
                                    } else {
                                        // If the item doesn't exist, append it to allRowsChildControls
                                        vc.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
                                    }
                                    
                                    vc.formBuilder.handleItemRules(item, excludedView: isEditable ? .Edit : .Create, removeAnswer: true)
                                    // Handle groupedItems
                                    if groupedItems[rowIndex] == nil {
                                        groupedItems[rowIndex] = [item]
                                    } else {
                                        groupedItems[rowIndex]?.append(item)
                                    }
                                }
                            }
                        }
                        rowIndices = vc.formBuilder.allRowsChildControls
                            .compactMap { Int($0.rowIndex ?? "0") }
                            .sorted()
                        let tables: [FormViewModelItem] = vc.formBuilder.formModelItems.filter({$0.type == .Table})
                        // Convert keys to integers and sort the dictionary
                        let sortedItems = groupedItems.sorted { (entry1, entry2) in
                            guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
                                return false // Handle non-integer keys
                            }
                            return num1 < num2
                        }
                        var tableId = ""
                        for groupItem in sortedItems {
                            for formItem in groupItem.value {
                                tableId = formItem.parentId ?? ""
                            }
                        }
                        
                        // Now sortedGroupedItems contains the sorted dictionary
                        
                        for table in tables {
                            if let item = table as? FormViewModelTableItem, item.fieldId == tableId  {
                                for groupItem in sortedItems {
                                    // Custom check to determine if groupItem.value exists in item.items
                                    var exists = false
                                    for existingItems in item.items {
                                        if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
                                            existingItems[0].answer = groupItem.value[0].answer
                                            exists = true
                                            break
                                        }
                                    }
                                    // If groupItem.value doesn't exist, append it to item.items
                                    if !exists {
                                        item.items.append(groupItem.value)
                                        item.cascadingComponent = nil
                                    }
                                }
                            }
                        }
                        
                        vc.formBuilder.reloadAt = {(section, _, _) in
                            DispatchQueue.main.async {[weak self] in
                                guard let `self` = self else {return}
                                if section < self.managerSectionObjects.value.0.count {
                                    if let formVC = vc as? FormViewController {
                                        formVC.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                                    }
                                } else {
                                    print("Attempt to reload a non-existent section")
                                }
                            }
                        }
                        if let formVC = vc as? FormViewController {
                            formVC.formTableView.reloadData()
                        }
                    }
                }
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
    }
    
    
    /// Fetch options for cascading rule
    /// - Parameters:
    ///   - code: id from rule's payload
    ///   - parentValue: [key from payload : value from payload]
    ///   - section: current section number
    ///   - row: current row number
    func fetchCascadingOptionsList(vc: FormBaseViewController, sectionObjects: [SectionObject], code: String,parentValue: [String:String]?, section: Int, row: Int) {
        managerSectionObjects.accept((sectionObjects,vc))
        cerqel_HUD.showHUD()
        var targetComps =  getTargetComponents(vc: vc, for: code, row: row)
        if let _ = vc as? NestedFormViewController {
            targetComps = updateTargetComponentsWithRowIndex(vc: vc, target: targetComps)
        }
        cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObjectDynamicForm<SearchDynamicModel>(action: Dynamic_BasicAction.fetchCascadingOptions(code: code, parentValue: parentValue ?? [:], targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        
                        if let values = component.values {
                            guard managerSectionObjects.value.0.count > section else {return}
                            let items = managerSectionObjects.value.0[section].items
                            guard items.count > row else {return}
                            guard let itemIndex = managerSectionObjects.value.0[section].items.firstIndex(where: { $0.fieldId == component.id }) else {
                                // Handle the case where no matching item is found
                                return
                            }
                            let item = items[itemIndex]
                            if let dropDownItem = item as? FormViewModelDropdownItem {
                                let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                    dropDownItem.answer = nil
                                }
                                var opts = [MCQOption]()
                                guard !values.isEmpty else {
                                    dropDownItem.options = []
                                    
                                    self.replace(item: dropDownItem, in: vc, at: section, and: itemIndex)
                                    self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                    return
                                }
                                for val in values {
                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                    opts.append(object)
                                    dropDownItem.options = opts
                                    
                                    self.replace(item: dropDownItem, in: vc, at: section, and: itemIndex)
                                    self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                                }
                            }
                            if let paragraphItem = item as? FormViewModelParagraphItem { // Nov 5
                                let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                paragraphItem.answer = ans
                                
                                self.replace(item: paragraphItem, in: vc, at: section, and: itemIndex)
                                self.saveChanges(activeTableView: vc.activeTableView, section: section, row: itemIndex)
                            }
                        }
                    }
                }
                
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
    }
    
    
    /// Fetch options for cascading rule with multi parents
    /// - Parameters:
    ///   - code: id from rule's payload
    ///   - parameters: [[key from payload : value from payload]]
    ///   - section: current section number
    ///   - row: current row number
    func fetchCascadingOptionsListWithMultiParents(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, code:String, parameters:[[String:String]], row: Int) {
        managerSectionObjects.accept((sectionObjects,vc))
        cerqel_HUD.showHUD()
        let targetComps =  getTargetComponents(vc: vc, for: code, row: row)
        var params = [[String:String]]()
        if parameters.first?.keys.first != parameters.first?.values.first {
            params = parameters
        }
        
        cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObjectDynamicForm<SearchDynamicModel>(action: Dynamic_BasicAction.fetchCascadingOptionsWithMultiParents(code: code, parameters: params, targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            var sectionIndex = 0
            var isFromTable = false
            var isCascadeInsideTable = false
            
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            if component.rowIndex != nil {
                                // if its row you need to return components with rowIndex
                                // else you need to return components with null rowIndex
                                if components.count >= vc.formBuilder.tableSectionObjects.count {
                                    isFromTable = true
                                    isCascadeInsideTable = false
                                }else {
                                    isCascadeInsideTable = true
                                }
                                
                                if let nestedVC = vc as? NestedFormViewController {
                                    sectionIndex = nestedVC.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                    self.updateFieldsValues(vc: nestedVC, sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
                                }
                            } else if component.parentId != nil && component.rowIndex == nil {
                                
                                isCascadeInsideTable = true
                                isFromTable = false
                            
                                sectionIndex = vc.formBuilder.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                self.updateFieldsValuesInsideSection(vc: vc,
                                                                     sectionIndex: sectionIndex,
                                                                     row: row,
                                                                     values: values,
                                                                     component: component)
                                
                            }
                            else {
                                if let sectionIndex = managerSectionObjects.value.0.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ,
                                   let itemIndex = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == component.id }),
                                   itemIndex < managerSectionObjects.value.0[sectionIndex].items.count { // refresh field from nested controller
                                    
                                    print("ids = ", managerSectionObjects.value.0.map({$0.items.map({$0.fieldId})}))
                                    let item = managerSectionObjects.value.0[sectionIndex].items[itemIndex]
                                    if let dropDownItem = item as? FormViewModelDropdownItem {
                                        let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                        let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                        if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                            dropDownItem.answer = nil
                                        }
                                        var opts = [MCQOption]()
                                        guard !values.isEmpty else {
                                            dropDownItem.options = []
                                            if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                                if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                            return
                                        }
                                        for val in values {
                                            let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                            opts.append(object)
                                        }
                                        if data.cascadeTargetType == 0 { //options
                                            dropDownItem.options = opts
                                            if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                                if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        } else if data.cascadeTargetType == 1 { //value
                                            let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                            dropDownItem.answer = ans
                                            if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                                if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        }else {
                                            dropDownItem.options = opts
                                            if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                                if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
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
                                        let ans = DateTimeAnswer(val: sortedValues,
                                                                 timeValues: sortedValues,
                                                                 lNote: nil,
                                                                 lAttachments: nil,
                                                                 type: .Gregorian)
                                        dateItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                                                
                                                self.replace(item: dateItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                        let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                        paragraphItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == paragraphItem.fieldId }) {
                                                
                                                self.replace(item: paragraphItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let numericItem = item as? FormViewModelNumericItem {
                                        let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                        numericItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == numericItem.fieldId }) {
                                                
                                                self.replace(item: numericItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let textItem = item as? FormViewModelTextBoxItem {
                                        let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                        textItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
                                                
                                                self.replace(item: textItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let switchItem = item as? FormViewModelSwitchItem {
                                        let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                                               lNote: nil,
                                                               lAttachments: nil)
                                        switchItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            if let index = managerSectionObjects.value.0[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                                                
                                                self.replace(item: switchItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        
                                        self.fieldValidationChangedWhenMultiCascade(vc: vc, submitButton: submitButton, sectionObjects: managerSectionObjects.value.0)
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let tableItem = item as? FormViewModelTableItem {
                                        let val = values.first?.name ?? ""
                                        if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                            let itemIndex = vc.formBuilder.itemsDict[tableItem.fieldId]?.1 ?? 0
                                            vc.formBuilder.formViewModel.items[itemIndex] = vc.formBuilder.updateItemProperty(item: tableItem, value: [val], payload: vc.formBuilder.currentPropertyTragetName)
                                            vc.formBuilder.currentPropertyTragetName = ""
                                        }
                                    }
                                }
                                else if let nestedVC = managerSectionObjects.value.1 as? NestedFormViewController,
                                        let formVC = nestedVC.delegate as? FormViewController,
                                        let sectionIndex = formVC.formBuilder.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ,
                                           let itemIndex = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == component.id }),
                                           itemIndex < formVC.formBuilder.sectionObjects[sectionIndex].items.count {
                                    print("ids = ", formVC.formBuilder.sectionObjects.map({$0.items.map({$0.fieldId})}))
                                    let vc = formVC
                                    let item = formVC.formBuilder.sectionObjects[sectionIndex].items[itemIndex]
                                    if let dropDownItem = item as? FormViewModelDropdownItem {
                                        let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                        let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                        if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                            dropDownItem.answer = nil
                                        }
                                        var opts = [MCQOption]()
                                        guard !values.isEmpty else {
                                            dropDownItem.options = []
                                            if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                                if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                            return
                                        }
                                        for val in values {
                                            let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                            opts.append(object)
                                        }
                                        if data.cascadeTargetType == 0 { //options
                                            dropDownItem.options = opts
                                            if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                                if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        } else if data.cascadeTargetType == 1 { //value
                                            let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                            dropDownItem.answer = ans
                                            if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                                if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        }else {
                                            dropDownItem.options = opts
                                            if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                                if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                                    
                                                    self.replace(item: dropDownItem, in: vc, at: sectionIndex, and: index)
                                                }
                                            } else {
                                                print("Warning: Section index \(sectionIndex) is out of bounds.")
                                            }
                                            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
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
                                        let ans = DateTimeAnswer(val: sortedValues,
                                                                 timeValues: sortedValues,
                                                                 lNote: nil,
                                                                 lAttachments: nil,
                                                                 type: .Gregorian)
                                        dateItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                            if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                                                
                                                self.replace(item: dateItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                        let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                        paragraphItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                            if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == paragraphItem.fieldId }) {
                                                
                                                self.replace(item: paragraphItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let numericItem = item as? FormViewModelNumericItem {
                                        let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                        numericItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                            if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == numericItem.fieldId }) {
                                                
                                                self.replace(item: numericItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let textItem = item as? FormViewModelTextBoxItem {
                                        let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                        textItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                            if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
                                                
                                                self.replace(item: textItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let switchItem = item as? FormViewModelSwitchItem {
                                        let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                                               lNote: nil,
                                                               lAttachments: nil)
                                        switchItem.answer = ans
                                        if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                            if let index = formVC.formBuilder.sectionObjects[sectionIndex].items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                                                
                                                self.replace(item: switchItem, in: vc, at: sectionIndex, and: index)
                                            }
                                        } else {
                                            print("Warning: Section index \(sectionIndex) is out of bounds.")
                                        }
                                        
                                        self.fieldValidationChangedWhenMultiCascade(vc: vc, submitButton: submitButton, sectionObjects: formVC.formBuilder.sectionObjects)
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                    }else if let tableItem = item as? FormViewModelTableItem {
                                        let val = values.first?.name ?? ""
                                        if sectionIndex >= 0 && sectionIndex < formVC.formBuilder.sectionObjects.count {
                                            let itemIndex = vc.formBuilder.itemsDict[tableItem.fieldId]?.1 ?? 0
                                            vc.formBuilder.formViewModel.items[itemIndex] = vc.formBuilder.updateItemProperty(item: tableItem, value: [val], payload: vc.formBuilder.currentPropertyTragetName)
                                            vc.formBuilder.currentPropertyTragetName = ""
                                        }
                                    }
                                }

                            }
                        }
                    }
                    if isCascadeInsideTable {
                        for (_, tableSectionObject) in vc.formBuilder.tableSectionObjects.enumerated() {
                            for (_, tableItem) in tableSectionObject.items.enumerated() {
                                // Check the fieldId and update
                                for sectionIndex in managerSectionObjects.value.0.indices {
                                    // Get the section object
                                    let section = managerSectionObjects.value.0[sectionIndex]
                                    
                                    // Check the first item in the section
                                    if !section.items.isEmpty, let sectionItem = (section.items[0] as? FormViewModelTableItem) {
                                        // Check if the sectionItem's fieldId matches the tableItem's parentId
                                        if sectionItem.fieldId == tableItem.parentId {
                                            for (childControlIndex, childControl) in sectionItem.childControls.enumerated() {
                                                // If the childControl's fieldId matches the tableItem's fieldId, update it
                                                if childControl.fieldId == tableItem.fieldId {
                                                    // Update the childControl with tableItem
                                                    sectionItem.childControls[childControlIndex] = tableItem
                                                    
                                                    // Update the section in formBuilder.sectionObjects
                                                    
                                                    self.replace(item: sectionItem, in: vc, at: sectionIndex, and: 0)
                                                    
                                                    // Trigger reload or any necessary update logic
                                                    // Your update/reload logic here
                                                    
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if isFromTable {
                        // Create a dictionary to hold grouped items based on rowIndex
                        var groupedItems: [String: [FormViewModelItem]] = [:]
                        // Iterate through tableSectionObjects to populate the groupedItems dictionary
                        for sectionObject in vc.formBuilder.tableSectionObjects {
                            for item in sectionObject.items {
                                if let rowIndex = item.rowIndex {
                                    // Find the index of the existing item based on specific properties
                                    if let existingIndex = vc.formBuilder.allRowsChildControls.firstIndex(where: { existingItem in
                                        return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
                                    }) {
                                        // Replace the existing item with the new one
                                        vc.formBuilder.allRowsChildControls[existingIndex] = FormViewModelItemStruct(from: item)
                                    } else {
                                        // If the item doesn't exist, append it to allRowsChildControls
                                        vc.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
                                    }
                                    
                                    vc.formBuilder.handleItemRules(item, excludedView: isEditable ? .Edit : .Create, removeAnswer: true)
                                    
                                    // Handle groupedItems
                                    if groupedItems[rowIndex] == nil {
                                        groupedItems[rowIndex] = [item]
                                    } else {
                                        groupedItems[rowIndex]?.append(item)
                                    }
                                }
                            }
                        }
                        rowIndices = vc.formBuilder.allRowsChildControls
                            .compactMap { Int($0.rowIndex ?? "0") }
                            .sorted()
                        let tables: [FormViewModelItem] = vc.formBuilder.formModelItems.filter({$0.type == .Table})
                        // Convert keys to integers and sort the dictionary
                        let sortedItems = groupedItems.sorted { (entry1, entry2) in
                            guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
                                return false // Handle non-integer keys
                            }
                            return num1 < num2
                        }
                        var tableId = ""
                        for groupItem in sortedItems {
                            for formItem in groupItem.value {
                                tableId = formItem.parentId ?? ""
                            }
                        }
                        
                        // Now sortedGroupedItems contains the sorted dictionary
                        
                        for table in tables {
                            if let item = table as? FormViewModelTableItem, item.fieldId == tableId  {
                                for groupItem in sortedItems {
                                    // Custom check to determine if groupItem.value exists in item.items
                                    var exists = false
                                    for existingItems in item.items {
                                        if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
                                            existingItems[0].answer = groupItem.value[0].answer
                                            exists = true
                                            break
                                        }
                                    }
                                    // If groupItem.value doesn't exist, append it to item.items
                                    if !exists {
                                        item.items.append(groupItem.value)
                                        item.cascadingComponent = nil
                                    }
                                }
                            }
                        }
                        
                        vc.formBuilder.reloadAt = { [weak self] (section, _, _) in
                            guard let `self` = self else {return}
                            DispatchQueue.main.async {
                                if section < self.managerSectionObjects.value.0.count {
                                    if let formVC = vc as? FormViewController {
                                        formVC.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                                    }
                                } else {
                                    print("Attempt to reload a non-existent section")
                                }
                            }
                        }
                        if let formVC = vc as? FormViewController {
                            formVC.formTableView.reloadData()
                        }
                    }
                }
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
    }
    
    /// Handling cascading behavior in pages mode
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - sectionObjects: children sections of vc
    ///   - submitButton: submit button in vc
    ///   - code: id from payload json
    ///   - parameters: parameters from payload json
    ///   - row: current row number
    func fetchCascadingOptionsListWithMultiParentsWhenPages(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, code:String, parameters:[[String:String]], row: Int) {
        managerSectionObjects.accept((sectionObjects,vc))
        cerqel_HUD.showHUD()
        let targetComps =  getTargetComponents(vc: vc, for: code, row: row)
        var params = [[String:String]]()
        if parameters.first?.keys.first != parameters.first?.values.first {
            params = parameters
        }
        
        cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObjectDynamicForm<SearchDynamicModel>(action: Dynamic_BasicAction.fetchCascadingOptionsWithMultiParents(code: code, parameters: params, targetComponents: targetComps))).subscribe(onNext: {[weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            var sectionIndex = 0
            var isFromTable = false
            var isCascadeInsideTable = false
            
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            if component.rowIndex != nil {
                                // if its row you need to return components with rowIndex
                                // else you need to return components with null rowIndex
                                if components.count >= vc.formBuilder.tableSectionObjects.count {
                                    isFromTable = true
                                    isCascadeInsideTable = false
                                }else {
                                    isCascadeInsideTable = true
                                }
                                
                                if let nestedVC = vc as? NestedFormViewController {
                                    sectionIndex = nestedVC.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                    self.updateFieldsValues(vc: nestedVC, sectionIndex: sectionIndex, row: row, values: values, component: component, isTableFields: true)
                                }
                            } else if component.parentId != nil && component.rowIndex == nil {
                                
                                isCascadeInsideTable = true
                                isFromTable = false
                                
                                
                                
                                sectionIndex = vc.formBuilder.sectionObjects.firstIndex(where: {$0.items.contains(where: {$0.fieldId == component.id})}) ?? 0
                                self.updateFieldsValuesInsideSection(vc: vc,
                                                                     sectionIndex: sectionIndex,
                                                                     row: row,
                                                                     values: values,
                                                                     component: component)
                            }
                            else {
                                let pageKey = component.parentId ?? ""
                                let items = vc.formBuilder.formPageDictionary[pageKey]
                                var itemIndex = 0
                                guard var items = items else {return}
                                var item = items[itemIndex]
                                if let selectedItemIndex = items.firstIndex(where: { $0.fieldId == component.id }) {
                                    itemIndex = selectedItemIndex
                                    item = items[itemIndex]
                                } else { // its section item
                                    for (rowIndex, currentItem) in items.enumerated() {
                                        if let sectionControl = currentItem as? FormViewModelSectionItem {
                                            // Retrieve items for the section
                                            if let sectionItems = vc.formBuilder.formSectionDictionary[sectionControl.fieldId] {
                                                for sectionItem in sectionItems {
                                                    // Assign values and break out if needed
                                                    item = sectionItem
                                                    itemIndex = rowIndex
                                                }
                                            }
                                        }
                                    }
                                }
                                if let dropDownItem = item as? FormViewModelDropdownItem {
                                    let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
                                    let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
                                    if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                                        dropDownItem.answer = nil
                                    }
                                    var opts = [MCQOption]()
                                    guard !values.isEmpty else {
                                        dropDownItem.options = []
                                        if let index = items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                            items[index] = dropDownItem
                                            vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                        }
                                        self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                        return
                                    }
                                    for val in values {
                                        let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                        opts.append(object)
                                    }
                                    if data.cascadeTargetType == 0 { //options
                                        dropDownItem.options = opts
                                    } else if data.cascadeTargetType == 1 { //value
                                        let ans = BaseAnswerMCQ(val: opts, otherAnswer: "")
                                        dropDownItem.answer = ans
                                    }else {
                                        dropDownItem.options = opts
                                    }
                                    if let index = items.firstIndex(where: { $0.fieldId == dropDownItem.fieldId }) {
                                        items[index] = dropDownItem
                                        vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
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
                                    if let index = items.firstIndex(where: { $0.fieldId == dateItem.fieldId }) {
                                        items[index] = dateItem
                                        vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let paragraphItem = item as? FormViewModelParagraphItem {
                                    let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
                                    paragraphItem.answer = ans
                                    if let index = items.firstIndex(where: { $0.fieldId == paragraphItem.fieldId }) {
                                        items[index] = paragraphItem
                                        vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let numericItem = item as? FormViewModelNumericItem {
                                    let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
                                    numericItem.answer = ans
                                    if let index = items.firstIndex(where: { $0.fieldId == numericItem.fieldId }) {
                                        items[index] = numericItem
                                        vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let textItem = item as? FormViewModelTextBoxItem {
                                    let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
                                    textItem.answer = ans
                                    if let index = items.firstIndex(where: { $0.fieldId == textItem.fieldId }) {
                                        items[index] = textItem
                                        vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                    }
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let switchItem = item as? FormViewModelSwitchItem {
                                    let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                                           lNote: nil,
                                                           lAttachments: nil)
                                    switchItem.answer = ans
                                    if let index = items.firstIndex(where: { $0.fieldId == switchItem.fieldId }) {
                                        items[index] = switchItem
                                        vc.formBuilder.formPageDictionary[pageKey] = items  // Update the dictionary with the modified array
                                    }
                                    self.fieldValidationChangedWhenMultiCascade(vc: vc, submitButton: submitButton, sectionObjects: managerSectionObjects.value.0)
                                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: itemIndex)
                                }else if let tableItem = item as? FormViewModelTableItem {
                                    let val = values.first?.name ?? ""
                                    if sectionIndex >= 0 && sectionIndex < managerSectionObjects.value.0.count {
                                        let itemIndex = vc.formBuilder.itemsDict[tableItem.fieldId]?.1 ?? 0
                                        vc.formBuilder.formViewModel.items[itemIndex] = vc.formBuilder.updateItemProperty(item: tableItem, value: [val], payload: vc.formBuilder.currentPropertyTragetName)
                                        vc.formBuilder.currentPropertyTragetName = ""
                                    }
                                }
                            }
                        }
                    }
                    if isCascadeInsideTable {
                        for (_, tableSectionObject) in vc.formBuilder.tableSectionObjects.enumerated() {
                            for (_, tableItem) in tableSectionObject.items.enumerated() {
                                // Check the fieldId and update
                                for sectionIndex in managerSectionObjects.value.0.indices {
                                    // Get the section object
                                    let section = managerSectionObjects.value.0[sectionIndex]
                                    
                                    // Check the first item in the section
                                    if let sectionItem = (section.items[0] as? FormViewModelTableItem) {
                                        // Check if the sectionItem's fieldId matches the tableItem's parentId
                                        if sectionItem.fieldId == tableItem.parentId {
                                            for (childControlIndex, childControl) in sectionItem.childControls.enumerated() {
                                                // If the childControl's fieldId matches the tableItem's fieldId, update it
                                                if childControl.fieldId == tableItem.fieldId {
                                                    // Update the childControl with tableItem
                                                    sectionItem.childControls[childControlIndex] = tableItem
                                                    
                                                    // Update the section in formBuilder.sectionObjects
                                                    
                                                    self.replace(item: sectionItem, in: vc, at: sectionIndex, and: 0)
                                                    
                                                    // Trigger reload or any necessary update logic
                                                    // Your update/reload logic here
                                                    
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    if isFromTable {
                        // Create a dictionary to hold grouped items based on rowIndex
                        var groupedItems: [String: [FormViewModelItem]] = [:]
                        // Iterate through tableSectionObjects to populate the groupedItems dictionary
                        for sectionObject in vc.formBuilder.tableSectionObjects {
                            for item in sectionObject.items {
                                if let rowIndex = item.rowIndex {
                                    // Find the index of the existing item based on specific properties
                                    if let existingIndex = vc.formBuilder.allRowsChildControls.firstIndex(where: { existingItem in
                                        return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
                                    }) {
                                        // Replace the existing item with the new one
                                        vc.formBuilder.allRowsChildControls[existingIndex] = FormViewModelItemStruct(from: item)
                                    } else {
                                        // If the item doesn't exist, append it to allRowsChildControls
                                        vc.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
                                    }
                                    
                                    vc.formBuilder.handleItemRules(item, excludedView: isEditable ? .Edit : .Create, removeAnswer: true)
                                    
                                    // Handle groupedItems
                                    if groupedItems[rowIndex] == nil {
                                        groupedItems[rowIndex] = [item]
                                    } else {
                                        groupedItems[rowIndex]?.append(item)
                                    }
                                }
                            }
                        }
                        rowIndices = vc.formBuilder.allRowsChildControls
                            .compactMap { Int($0.rowIndex ?? "0") }
                            .sorted()
                        let tables: [FormViewModelItem] = vc.formBuilder.formModelItems.filter({$0.type == .Table})
                        // Convert keys to integers and sort the dictionary
                        let sortedItems = groupedItems.sorted { (entry1, entry2) in
                            guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
                                return false // Handle non-integer keys
                            }
                            return num1 < num2
                        }
                        var tableId = ""
                        for groupItem in sortedItems {
                            for formItem in groupItem.value {
                                tableId = formItem.parentId ?? ""
                            }
                        }
                        
                        // Now sortedGroupedItems contains the sorted dictionary
                        
                        for table in tables {
                            if let item = table as? FormViewModelTableItem, item.fieldId == tableId  {
                                for groupItem in sortedItems {
                                    // Custom check to determine if groupItem.value exists in item.items
                                    var exists = false
                                    for existingItems in item.items {
                                        if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
                                            existingItems[0].answer = groupItem.value[0].answer
                                            exists = true
                                            break
                                        }
                                    }
                                    // If groupItem.value doesn't exist, append it to item.items
                                    if !exists {
                                        item.items.append(groupItem.value)
                                        item.cascadingComponent = nil
                                    }
                                }
                            }
                        }
                        
                        vc.formBuilder.reloadAt = { [weak self] (section, _, _) in
                            guard let `self` = self else {return}
                            DispatchQueue.main.async {
                                if section < self.managerSectionObjects.value.0.count {
                                    if let formVC = vc as? FormViewController {
                                        formVC.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                                    }
                                } else {
                                    print("Attempt to reload a non-existent section")
                                }
                            }
                        }
                        if let formVC = vc as? FormViewController {
                            formVC.formTableView.reloadData()
                        }
                    }
                }
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
        }).disposed(by: self.disposeBag)
    }
    
    func getInnerSectionItem(vc: FormBaseViewController, sectionIndex: Int, component: ComponentsModel) -> FormViewModelItem? {
        let sectionItems = vc.formBuilder.sectionObjects[sectionIndex].items
        if vc.formBuilder.sectionObjects[sectionIndex].item?.type == .Section {
            for innerItem in sectionItems {
                if innerItem.fieldId == component.id {
                    return innerItem
                }
            }
        }
        return nil
    }
    
    func createNewSectionObjectWithAnswer(vc: FormBaseViewController, sectionIndex: Int, row: Int, component: ComponentsModel, item: FormViewModelItem) -> Int {
        var sectionRow: Int?
        var newSectionObject: SectionObject!
        let sectionItems = vc.formBuilder.sectionObjects[sectionIndex].items
        if vc.formBuilder.sectionObjects[sectionIndex].item?.type == .Section {
            for (idx,innerItem) in sectionItems.enumerated() {
                if innerItem.fieldId == component.id {
                    newSectionObject = vc.formBuilder.sectionObjects[sectionIndex]
                    newSectionObject.items[idx] = item
                    vc.formBuilder.sectionObjects[sectionIndex] = newSectionObject
                    sectionRow = idx
                }
            }
        }else {
            newSectionObject = vc.formBuilder.sectionObjects[sectionIndex]
            newSectionObject.items[row] = item
            vc.formBuilder.sectionObjects[sectionIndex] = newSectionObject
        }
        
        return sectionRow ?? row
    }
    
    func updateFieldsValuesInsideSection(vc: FormBaseViewController,sectionIndex: Int, row: Int, values: [SearchValues], component: ComponentsModel) {
        
        guard sectionIndex <  vc.formBuilder.sectionObjects.count else {return}
        guard row <  vc.formBuilder.sectionObjects[sectionIndex].items.count else {return}
        
        var sectionRow: Int?
        var item = vc.formBuilder.sectionObjects[sectionIndex].items[row]
        
        guard sectionIndex <  vc.formBuilder.sectionObjects.count else {return}
        guard row <  vc.formBuilder.sectionObjects[sectionIndex].items.count else {return}
        
        if let innerItem = getInnerSectionItem(vc: vc, sectionIndex: sectionIndex, component: component) {
            item = innerItem
        }
        
        if let dropDownItem = item as? FormViewModelDropdownItem {
            let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
            let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
            if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                dropDownItem.answer = nil
            }
            var opts = [MCQOption]()
            guard !values.isEmpty else {
                dropDownItem.options = []
                vc.formBuilder.sectionObjects[sectionIndex].items[row] = dropDownItem
                self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
                
                return
            }
            if dropDownItem.rowIndex == component.rowIndex {
                for val in values {
                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                    opts.append(object)
                }
                dropDownItem.options = opts
                
                // Create a new sectionObject with switchItem and add it to sectionObjects
                
                sectionRow = createNewSectionObjectWithAnswer(vc: vc,
                                                              sectionIndex: sectionIndex,
                                                              row: row,
                                                              component: component,
                                                              item: dropDownItem)
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dropDownItem.rowIndex != component.rowIndex &&  dropDownItem.rowIndex != nil{
                    for sections in vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelDropdownItem(field: dropDownItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.options = opts
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: sectionRow ?? row)
            
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
            let ans = DateTimeAnswer(val: sortedValues,
                                     timeValues: sortedValues,
                                     lNote: nil,
                                     lAttachments: nil,
                                     type: .Gregorian)
            if dateItem.rowIndex == component.rowIndex {
                
                dateItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                sectionRow = createNewSectionObjectWithAnswer(vc: vc,
                                                              sectionIndex: sectionIndex,
                                                              row: row,
                                                              component: component,
                                                              item: dateItem)
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dateItem.rowIndex != component.rowIndex && dateItem.rowIndex != nil {
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelDateItem(field: dateItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            
        }else if let paragraphItem = item as? FormViewModelParagraphItem {
            let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
            if paragraphItem.rowIndex == component.rowIndex {
                paragraphItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                sectionRow = createNewSectionObjectWithAnswer(vc: vc,
                                                              sectionIndex: sectionIndex,
                                                              row: row,
                                                              component: component,
                                                              item: paragraphItem)
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if paragraphItem.rowIndex != component.rowIndex && paragraphItem.rowIndex != nil {
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelParagraphItem(field: paragraphItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
                
            }
            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            
        }else if let numericItem = item as? FormViewModelNumericItem {
            let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
            if numericItem.rowIndex == component.rowIndex && numericItem.fieldId ==  component.id {
                numericItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                sectionRow = createNewSectionObjectWithAnswer(vc: vc,
                                                              sectionIndex: sectionIndex,
                                                              row: row,
                                                              component: component,
                                                              item: numericItem)
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if numericItem.rowIndex != component.rowIndex  && numericItem.rowIndex != nil{
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = numericItem.copy() as? FormViewModelNumericItem
                                fieldItem?.rowIndex = component.rowIndex
                                fieldItem?.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                if let fieldItem = fieldItem {
                                    let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                    if !uniqueIdentifiers.contains(identifier) {
                                        uniqueIdentifiers.append(identifier)
                                        vc.formBuilder.tableSectionObjects.append(sectionObj)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            
        }else if let textItem = item as? FormViewModelTextBoxItem {
            let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
            if textItem.rowIndex == component.rowIndex && textItem.fieldId ==  component.id {
                textItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                sectionRow = createNewSectionObjectWithAnswer(vc: vc,
                                                              sectionIndex: sectionIndex,
                                                              row: row,
                                                              component: component,
                                                              item: textItem)
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if textItem.rowIndex != component.rowIndex && textItem.rowIndex != nil{
                    for sections in vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = textItem.copy() as? FormViewModelTextBoxItem
                                fieldItem?.rowIndex = component.rowIndex
                                fieldItem?.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                if let fieldItem = fieldItem {
                                    let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                    if !uniqueIdentifiers.contains(identifier) {
                                        uniqueIdentifiers.append(identifier)
                                        vc.formBuilder.tableSectionObjects.append(sectionObj)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            
        }else if let switchItem = item as? FormViewModelSwitchItem {
            let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                   lNote: nil,
                                   lAttachments: nil)
            if switchItem.rowIndex == component.rowIndex {
                
                switchItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                sectionRow = createNewSectionObjectWithAnswer(vc: vc,
                                                              sectionIndex: sectionIndex,
                                                              row: row,
                                                              component: component,
                                                              item: switchItem)
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if switchItem.rowIndex != component.rowIndex && switchItem.rowIndex != nil {
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelSwitchItem(field: switchItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Updating fields value
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - sectionIndex: current section index
    ///   - row: current row index
    ///   - values: new values to be updated
    ///   - component: component to be updated
    ///   - isTableFields: checking if it's nested control
    func updateFieldsValues(vc: NestedFormViewController,sectionIndex: Int, row: Int, values: [SearchValues], component: ComponentsModel,isTableFields: Bool) {
        guard sectionIndex < vc.sectionObjects.count else {
            return
        }
        guard row < vc.sectionObjects[sectionIndex].items.count else {return}
        var item = vc.sectionObjects[sectionIndex].items[row]
        
        
        if let dropDownItem = item as? FormViewModelDropdownItem {
            
            let sourceIDs = vc.formBuilder.cascadingSourceIDs ?? []
            let currentCascadingItemID = vc.formBuilder.cascadingCurrentItemID ?? ""
            if currentCascadingItemID != dropDownItem.fieldId && sourceIDs.contains(currentCascadingItemID)  {
                dropDownItem.answer = nil
            }
            var opts = [MCQOption]()
            guard !values.isEmpty else {
                dropDownItem.options = []
                vc.formBuilder.tableSectionObjects[sectionIndex].items[row] = dropDownItem
                if isTableFields {
                    self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
                }
                return
            }
            if dropDownItem.rowIndex == component.rowIndex {
                for val in values {
                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                    opts.append(object)
                }
                dropDownItem.options = opts
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   vc.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = dropDownItem
                vc.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                
                if let nestedVC = vc as? NestedFormViewController {
                    
                    for (idx,sectionObject) in nestedVC.sectionObjects.enumerated() {
                        if sectionObject.id == component.id {
                            if let newDDLItem = nestedVC.sectionObjects[idx].items.first as? FormViewModelDropdownItem {
                                newDDLItem.options = opts
                                nestedVC.sectionObjects[idx].items = [newDDLItem]
                                nestedVC.activeTableView.reloadSections([idx], with: .none)
                                break
                            }
                        }
                    }
                }
                
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dropDownItem.rowIndex != component.rowIndex &&  dropDownItem.rowIndex != nil{
                    for sections in vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelDropdownItem(field: dropDownItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.options = opts
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if isTableFields {
                self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
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
            let ans = DateTimeAnswer(val: sortedValues,
                                     timeValues: sortedValues,
                                     lNote: nil,
                                     lAttachments: nil,
                                     type: .Gregorian)
            if dateItem.rowIndex == component.rowIndex {
                
                dateItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   vc.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = dateItem
                vc.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if dateItem.rowIndex != component.rowIndex && dateItem.rowIndex != nil {
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelDateItem(field: dateItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
            if isTableFields {
                self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            }
        }else if let paragraphItem = item as? FormViewModelParagraphItem {
            let ans = ParagraphAnswer(val: values.map({$0.name ?? ""}).first, htmlValue: nil, lNote: nil, lAttachments: nil)
            if paragraphItem.rowIndex == component.rowIndex {
                paragraphItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject =   vc.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = paragraphItem
                vc.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if paragraphItem.rowIndex != component.rowIndex && paragraphItem.rowIndex != nil {
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelParagraphItem(field: paragraphItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
                
            }
            if isTableFields {
                self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            }
        }else if let numericItem = item as? FormViewModelNumericItem {
            let ans = BaseAnswerText(val: values.map({$0.name ?? ""}).first ?? "")
            if numericItem.rowIndex == component.rowIndex && numericItem.fieldId ==  component.id {
                numericItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject = vc.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = numericItem
                vc.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if numericItem.rowIndex != component.rowIndex  && numericItem.rowIndex != nil{
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = numericItem.copy() as? FormViewModelNumericItem
                                fieldItem?.rowIndex = component.rowIndex
                                fieldItem?.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                if let fieldItem = fieldItem {
                                    let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                    if !uniqueIdentifiers.contains(identifier) {
                                        uniqueIdentifiers.append(identifier)
                                        vc.formBuilder.tableSectionObjects.append(sectionObj)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            if isTableFields {
                self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            }
        }else if let textItem = item as? FormViewModelTextBoxItem {
            let ans = TextboxAnswer(val: values.map({$0.name ?? ""}).first ?? "")
            if textItem.rowIndex == component.rowIndex && textItem.fieldId ==  component.id {
                textItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject = vc.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = textItem
                vc.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if textItem.rowIndex != component.rowIndex && textItem.rowIndex != nil{
                    for sections in vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = textItem.copy() as? FormViewModelTextBoxItem
                                fieldItem?.rowIndex = component.rowIndex
                                fieldItem?.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                if let fieldItem = fieldItem {
                                    let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                    if !uniqueIdentifiers.contains(identifier) {
                                        uniqueIdentifiers.append(identifier)
                                        vc.formBuilder.tableSectionObjects.append(sectionObj)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if isTableFields {
                self.saveChanges(activeTableView: vc.activeTableView, section: sectionIndex, row: row)
            }
        }else if let switchItem = item as? FormViewModelSwitchItem {
            let ans = SwitchAnswer(val: values.first?.name?.lowercased() == "true" ? true : false,
                                   lNote: nil,
                                   lAttachments: nil)
            if switchItem.rowIndex == component.rowIndex {
                
                switchItem.answer = ans
                // Create a new sectionObject with switchItem and add it to sectionObjects
                var newSectionObject = vc.formBuilder.tableSectionObjects[sectionIndex]
                newSectionObject.items[row] = switchItem
                vc.formBuilder.tableSectionObjects[sectionIndex] = newSectionObject
                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                if !uniqueIdentifiers.contains(identifier) {
                    uniqueIdentifiers.append(identifier)
                }
            } else {
                if switchItem.rowIndex != component.rowIndex && switchItem.rowIndex != nil {
                    for sections in   vc.formBuilder.tableSectionObjects {
                        for item in sections.items {
                            if item.rowIndex ==  component.rowIndex &&  item.fieldId ==  component.id {} else {
                                let fieldItem = FormViewModelSwitchItem(field: switchItem.field)
                                fieldItem.rowIndex = component.rowIndex
                                fieldItem.answer = ans
                                let identifier = "\(component.rowIndex ?? "-1")-\(component.id ?? "")"
                                let sectionObj = SectionObject(id: component.id ?? "", dummy: true, opened: true, items: [fieldItem])
                                if !uniqueIdentifiers.contains(identifier) {
                                    uniqueIdentifiers.append(identifier)
                                    vc.formBuilder.tableSectionObjects.append(sectionObj)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// Select option from DDL
    /// - Parameters:
    ///   - options: DDL options
    ///   - title: DDL title
    ///   - selectedValues: DDL selected options
    ///   - multiSelect: is it multiSelect or not
    ///   - section: current section number
    ///   - row: current row number
    func selectOption(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, options: [MCQOption], title: String?, selectedValues: [MCQOption], multiSelect: Bool, selectAllEnabled: Bool, section: Int, row: Int) {
        
        managerSectionObjects.accept((sectionObjects,vc))
        let dropDownVC = RouterDynamicForm.goTo(viewName: .newFormBuilderDropDown) as! NewDropDownViewController
        var height = 0
        if selectAllEnabled {
            height = ((options.count + 1) * 50) + 70 + 80 + 30
        }else {
            height = (options.count * 50) + 70 + 80 + 20
        }
        
        if height > Int(vc.view.frame.size.height / 2) {
            height = Int(vc.view.frame.size.height / 2)
        }
        let popupVC = PopupViewController(contentController: dropDownVC, position: .bottom(0), popupWidth: vc.view.frame.width, popupHeight: CGFloat(height))
        dropDownVC.questionTitle = title ?? ""
        dropDownVC.allOptions = options
        dropDownVC.selectedValues = selectedValues
        dropDownVC.representation = multiSelect ? .CheckBox : .Radio
        dropDownVC.multiSelect = multiSelect
        dropDownVC.selectAllEnabled = selectAllEnabled
        dropDownVC.handleSelectAll()
        
        popupVC.backgroundAlpha = 0.5
        popupVC.cornerRadius = 8
        
        
        // user selected options
        dropDownVC.selectOption = { [weak self] options, otherVal in
            guard let `self` = self else {return}
            vc.dismiss(animated: false,completion: {[weak self] in
                guard let `self` = self else {return}
                let val = BaseAnswerMCQ(val: options, otherAnswer: otherVal)
                self.fieldValueChangedAt(vc: vc, sectionObjects: managerSectionObjects.value.0, submitButton: submitButton, section, row: row, value: val)
                guard section < sectionObjects.count else {return}
                guard row < sectionObjects[section].items.count else {return}
                if let item = sectionObjects[section].items[row] as? FormViewModelDropdownItem {
                    if let properties = item.field?.properties as? DropdownProperties {
                        let result = vc.formBuilder.handleDropDownError(optionsCount: (val.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: item , row: item.fieldId)
                        self.fieldValidationChangedAt(vc: vc, sectionObjects: managerSectionObjects.value.0, submitButton: submitButton, section, row: row, isValid: !result.isError)
                    }
                }
            })
        }
        
        // bottom sheet dismissed
        dropDownVC.dismiss = {
            vc.dismiss(animated: false,completion: {})
        }
        vc.present(popupVC, animated:true)
    }
    
    
    /// Select option from Search
    /// - Parameters:
    ///   - code: payload id
    ///   - options: search options
    ///   - title: search control's title
    ///   - placeHolder: search bar placeHolder
    ///   - selectedValues: search control selected options
    ///   - multiSelect: is it multiSelect or not
    ///   - section: current section
    ///   - row: current row
    func selectOptionFromSearch(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, code: String,options: [MCQOption], title: String?,placeHolder: String?, selectedValues: [MCQOption], multiSelect: Bool, selectAllEnabled: Bool, section: Int, row: Int) {
        managerSectionObjects.accept((sectionObjects,vc))
        
        let dropDownVC = RouterDynamicForm.goTo(viewName: .newFormBuilderSearch(code: code)) as! NewSearchVC
        
        let height = Int(vc.view.frame.size.height * 0.75)
        let popupVC = PopupViewController(contentController: dropDownVC, position: .bottom(0), popupWidth: vc.view.frame.width, popupHeight: CGFloat(height))
        popupVC.canTapOutsideToDismiss = false
        dropDownVC.questionTitle = title ?? ""
        dropDownVC.searchBarPlaceHolder = placeHolder ?? ""
        dropDownVC.allOptions.accept(options)
        dropDownVC.localSearch = !options.isEmpty
        dropDownVC.selectedValues = selectedValues
        dropDownVC.representation = multiSelect ? .CheckBox : .Radio
        dropDownVC.multiSelect = multiSelect
        dropDownVC.selectAllEnabled = selectAllEnabled
        dropDownVC.handleSelectAll()
        
        popupVC.backgroundAlpha = 0.5
        popupVC.cornerRadius = 8
        
        // user typed a word more than 3 chars
        dropDownVC.getSearchUrl = {[weak self] (code,keyword) in
            guard let `self` = self else {return}
            self.fetchSearchOptions(vc: vc,
                                    sectionObjects: managerSectionObjects.value.0,
                                    code: code,
                                    keyword: keyword,
                                    params: vc.formBuilder.searchComponents.value?.values.first,
                                    section: section,
                                    row: row) { [weak self] opts in
                guard let _ = self else {return}
                dropDownVC.allOptions.accept(opts)
            }
        }
        
        // user selected options
        dropDownVC.selectOption = { [weak self] options, otherVal in
            guard let `self` = self else {return}
            vc.dismiss(animated: false,completion: {[weak self] in
                guard let `self` = self else {return}
                let val = BaseAnswerMCQ(val: options, otherAnswer: otherVal)
                self.fieldValueChangedAt(vc: vc, sectionObjects: managerSectionObjects.value.0, submitButton: submitButton, section, row: row, value: val)
                if let item = managerSectionObjects.value.0[section].items[row] as? FormViewModelDropdownItem {
                    if let properties = item.field?.properties as? DropdownProperties {
                        let result = vc.formBuilder.handleDropDownError(optionsCount: (val.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: item , row: item.fieldId)
                        self.fieldValidationChangedAt(vc: vc,sectionObjects: managerSectionObjects.value.0 , submitButton: submitButton, section, row: row, isValid: !(result.isError ))
                    }
                }
            })
            
        }
        
        // user dismissed the search bottom sheet
        dropDownVC.dismiss = { _, _ in
            vc.dismiss(animated: false,completion: {})
            
        }
        vc.present(popupVC, animated:true)
    }
    
    
    /// Fetch search results
    /// - Parameters:
    ///   - code: payload id
    ///   - keyword: user's searched keyword
    ///   - params: [key from payload : value from payload]
    ///   - section: current section number
    ///   - row: current row number
    ///   - completion: returned results to be control's options
    func fetchSearchOptions(vc: FormBaseViewController, sectionObjects: [SectionObject], code: String,keyword: String, params: [String:String]?, section: Int, row: Int, completion: @escaping (([MCQOption]) ->Void)) {
        managerSectionObjects.accept((sectionObjects,vc))
        cerqel_HUD.showHUD()
        var targetComps = getTargetComponents(vc: vc, for: code, row: row)
        if let _ = vc as? NestedFormViewController {
            targetComps = updateTargetComponentsWithRowIndex(vc: vc, target: targetComps)
        }
        let timeout: TimeInterval = 4.0 // Adjust the timeout duration as needed
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            self?.cerqel_HUD.stopHUD()
        }
        cerqel_BasicNetworkServiceDynamicFormImpl.shared.load(cerqel_CodableResponseObjectDynamicForm<SearchDynamicModel>(action: Dynamic_BasicAction.fetchSearchOptions(code: code,
                                                                                                                                                   keyword: keyword,
                                                                                                                                                   parameters: params,
                                                                                                                                                   targetComponents: targetComps))).subscribe(onNext: {
            [weak self] (response) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            if let data = response.item?.data {
                if let components = data.components {
                    for component in components {
                        if let values = component.values {
                            let item = sectionObjects[section].items[row]
                            
                            if let dropDownItem = item as? FormViewModelDropdownItem {
                                var opts = [MCQOption]()
                                guard !values.isEmpty else {
                                    dropDownItem.options = []
                                    
                                    self.replace(item: dropDownItem, in: vc, at: section, and: row)
                                    self.saveChanges(activeTableView: vc.activeTableView, section: section, row: row)
                                    completion([])
                                    return
                                }
                                for val in values {
                                    let object = MCQOption(id: val.id, other: false, name: val.name, name_ar: val.nameAR)
                                    opts.append(object)
                                    dropDownItem.options = opts
                                    
                                    self.replace(item: dropDownItem, in: vc, at: section, and: row)
                                    self.saveChanges(activeTableView: vc.activeTableView, section: section, row: row)
                                    completion(opts)
                                }
                            }
                        }
                    }
                }
            }
        }, onError: {[weak self] (_) in
            guard let `self` = self else {return}
            self.cerqel_HUD.stopHUD()
            completion([])
        }).disposed(by: self.disposeBag)
    }
    
    
    /// Create target controls
    /// - Parameters:
    ///   - vc: current presenting view controller
    ///   - code: data source id
    ///   - row: current row number
    /// - Returns: target components
    func getTargetComponents(vc: FormBaseViewController, for code: String, row: Int) -> [[String: String?]] {
        var targetComponents = [[String: String?]]()
        var uniqueIds = Set<String>() // To keep track of unique ids
        
        // Iterate through all target components
        for targetComponent in vc.formBuilder.targetComponents.value {
            if targetComponent["code"] as? String == code {
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
    
    
    
    /// Check validation of every control
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - submitButton: vc's submit button
    ///   - sectionObjects: current vc's sections
    func fieldValidationChangedWhenMultiCascade(vc: FormBaseViewController, submitButton: UIButton, sectionObjects: [SectionObject]) {
        
        managerSectionObjects.accept((sectionObjects,vc))
        
        var isDimmed = false
        
        for section in sectionObjects {
            for item in section.items  {
                if item is FormViewModelSwitchItem {
                    let requiredItem = (item.field?.properties as? switchProperties)?.required
                    if item.answer != nil && !item.hidden && ((item.answer as? SwitchAnswer)?.value == false) && requiredItem == true  {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelDateItem{
                    let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true  {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelParagraphItem {
                    let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true    {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelNumericItem {
                    let requiredItem = (item.field?.properties as? NumberProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true {
                        isDimmed = true
                        break
                    }
                }
                
                if item is FormViewModelTextBoxItem {
                    let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                    if item.answer == nil && !item.hidden && requiredItem == true  {
                        isDimmed = true
                        break
                    }
                }
                if isDimmed {
                    break
                }
            }
        }
        if let nestedVC = vc as? NestedFormViewController {
            self.handleSubmitButton(vc: nestedVC, submitButton: submitButton, enabled: !isDimmed)
        }
    }
    
    /// Updating every control after it's value changed
    /// - Parameters:
    ///   - section: current section number
    ///   - row: current row number
    ///   - value: current control's answer
    ///   - isError: is control has error or not
    ///   - reload: should tableView reload or not
    func fieldValueChangedAt(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, _ section: Int, row: Int, value: Any?, isError: Bool = false, reload: Bool = true, userInteracted: Bool = true) {
        
        managerSectionObjects.accept((sectionObjects,vc))
        
        if vc.formBuilder.isCardMode {
            if vc.formBuilder.formModelItems.indices.contains(0) {
                vc.formBuilder.formModelItems[0].isError = isError
                vc.formBuilder.formModelItems[0].answer = value
            }
        } else {
            if managerSectionObjects.value.0.indices.contains(section) && managerSectionObjects.value.0[section].items.indices.contains(row) {
                managerSectionObjects.value.0[section].items[row].isError = isError
                managerSectionObjects.value.0[section].items[row].answer = value
                managerSectionObjects.value.0[section].items[row].isValid = !isError
                managerSectionObjects.value.0[section].items[row].isUpdated = true
            }
        }
        self.saveChanges(activeTableView: vc.activeTableView, reload: reload, section: section, row: row)
        
        
        
        if let formVC = vc as? NestedFormViewController {
            sectionObjects[section].items[row].isUpdated = true
            saveObjectsIntoFormBuilder(vc:formVC, tableSectionObjects: sectionObjects, sectionObjects: formVC.formBuilder.sectionObjects, section,row)
            let tableItems =  sectionObjects[section].items
            for item in tableItems {
                if let rowIndex = item.rowIndex, let _ = item.answer {
                    let hasDuplicateDropDown = formVC.singleRowItems.contains { existingItem in
                        // Unwrapping and type casting existing answer value
                        let existingVal = ((existingItem.answer as? BaseAnswerMCQ)?.value as? [MCQOption])
                        // Unwrapping and type casting new answer value
                        let newVal = ((item.answer as? BaseAnswerMCQ)?.value as? [MCQOption])
                        // Checking if existing and new values are equal
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingVal == newVal)
                    }
                    let hasDuplicateParagrapgh = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? BaseAnswerText) == (item.answer as? BaseAnswerText)
                    }
                    let hasDuplicateTextBox = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? TextboxAnswer) == (item.answer as? TextboxAnswer)
                    }
                    let hasDuplicateNumeric = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? BaseAnswerText) == (item.answer as? BaseAnswerText)
                    }
                    let hasDuplicateSwitch = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? SwitchAnswer) == (item.answer as? SwitchAnswer)
                    }
                    let hasDuplicateDateTime = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? DateTimeAnswer) == (item.answer as? DateTimeAnswer)
                    }
                    let hasDuplicateTextArea = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? TextAreaAnswer) == (item.answer as? TextAreaAnswer)
                    }
                    let hasDuplicateFileUpload = formVC.singleRowItems.contains { existingItem in
                        return existingItem.rowIndex == rowIndex && existingItem.fieldId == item.fieldId && (existingItem.answer as? FileUploadAnswer) == (item.answer as? FileUploadAnswer)
                    }
                    if !hasDuplicateDropDown {
                        let itemAnswer = ((item.answer as? BaseAnswerMCQ)?.value as? [MCQOption])
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateDateTime {
                        let itemAnswer = (item.answer as? DateTimeAnswer)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateTextArea {
                        let itemAnswer = (item.answer as? TextAreaAnswer)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateFileUpload {
                        let itemAnswer = (item.answer as? FileUploadAnswer)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateParagrapgh {
                        let itemAnswer = (item.answer as? ParagraphAnswer)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateTextBox {
                        let itemAnswer = (item.answer as? TextboxAnswer)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateNumeric {
                        let itemAnswer = (item.answer as? BaseAnswerText)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                    if !hasDuplicateSwitch {
                        let itemAnswer = (item.answer as? SwitchAnswer)
                        if itemAnswer != nil {
                            formVC.singleRowItems.append(item)
                        }
                    }
                }
            }
            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: !isError)
            DynamicAuthManager.shared.isCameraOpened = false
        }else {
            if managerSectionObjects.value.0.indices.contains(section) && managerSectionObjects.value.0[section].items.indices.contains(row) {
                
                vc.formBuilder.handleItemRules(managerSectionObjects.value.0[section].items[row], excludedView: isEditable ? .Edit : .Create, removeAnswer: userInteracted)
            }
            DynamicAuthManager.shared.isCameraOpened = false
            fieldValidationChangedAt(vc: vc, sectionObjects: managerSectionObjects.value.0, submitButton: submitButton, section, row: row, isValid: !isError)
        }
    }
    
    /// Updating row index in target components
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - target: target component
    /// - Returns: the updated target component
    func updateTargetComponentsWithRowIndex(vc: FormBaseViewController, target: [[String:String?]]) -> [[String:String?]] {
        var customizedTargets = target
        customizedTargets = customizedTargets.map({
            var dict = $0
            dict["rowIndex"] = vc.formBuilder.currentNestedRowIdx
            return dict
        })
        print("customizedTargets = ",customizedTargets.map({$0["rowIndex"]}))
        return customizedTargets
    }
    
    
    /// Updating control value after dismiss
    /// - Parameters:
    ///   - section: current section
    ///   - ans: current ans
    func updateControlValue(vc: FormBaseViewController, sectionObjects: [SectionObject], section: Int, ans: Any?, fieldId: String) {
//        managerSectionObjects.accept((sectionObjects,vc))
        guard section < sectionObjects.count else {return}
        let items = sectionObjects[section].items
        guard !items.isEmpty else {return}
        if sectionObjects[section].item?.type == .Section {
            if let index = items.firstIndex(where: { $0.fieldId == fieldId }) {
                // Use the index as needed
                items[index].answer = ans
            }
        } else {
            items[0].answer = ans
        }
        if section < sectionObjects.count {
            if let formVC = vc as? FormViewController {
                formVC.formTableView.reloadSections(IndexSet(integer: section), with: .none)
            }else if let formVC = vc as? NestedFormViewController {
                formVC.formTableView.reloadSections(IndexSet(integer: section), with: .none)
            }
        } else {
            print("Attempt to reload a non-existent section")
        }
    }
    
    
    
    /// Reloading table after saving changes
    /// - Parameters:
    ///   - activeTableView: current tableView
    ///   - reload: check if it need to reload or not
    ///   - section: current section number
    ///   - row: current row number
    func saveChanges(activeTableView: UITableView, reload: Bool = true, section: Int, row: Int) {
        guard section >= 0 && row >= 0 && section < activeTableView.numberOfSections && row < activeTableView.numberOfRows(inSection: section) else {
            // section or row value is invalid, so exit the function
            return
        }
        if reload {
            activeTableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .fade)
        }
    }
    
    /// Getting current control
    /// - Parameter indexPath: control's indexPath
    /// - Returns: rendered control
    func getCurrentItem(sectionObjects: [SectionObject], indexPath: IndexPath) -> FormViewModelItem {
        var item: FormViewModelItem!
        if sectionObjects.count > indexPath.section {
            item = sectionObjects[indexPath.section].items[indexPath.row]
            return item
        }
        return FormViewModelItem(field: nil)
    }
    
    /// Download attached image
    /// - Parameters:
    ///   - url: clicked attachment url
    ///   - completion: returning (downloaded or not)
    func downloadMedia(url: String, completion: @escaping(Bool)->Void) {
        cerqel_HUD.showHUD()
        guard let url = URL(string: url) else {return}
        
        var request = URLRequest(url: url)
        
        request.setValue("Bearer " + AuthManager.shared.token,
                         forHTTPHeaderField: "Authorization")
        request.setValue(isArabic() ? "Ar" : "En",
                         forHTTPHeaderField: "LanguageCode")
        request.setValue("IOS",
                         forHTTPHeaderField: "Platform")
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8",
                         forHTTPHeaderField: "charset")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let responseData = data {
                let base64String = responseData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                if let decodedData = Data(base64Encoded: base64String, options: []) {
                    if let decodedImage = UIImage(data: decodedData) {
                        UIImageWriteToSavedPhotosAlbum(decodedImage, nil, nil, nil)
                        
                        self.cerqel_HUD.stopHUD()
                        completion(true)
                    }else {
                        completion(false)
                    }
                }
            }
        }.resume()
    }
    
    /// Download attached video
    /// - Parameters:
    ///   - url: clicked attachment url
    ///   - completion: returning (downloaded or not)
    func downloadVideo(url: String, completion: @escaping(Bool)->Void) {
        
        // set up your download task
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        
        request.setValue("Bearer " + AuthManager.shared.token,
                         forHTTPHeaderField: "Authorization")
        request.setValue(isArabic() ? "Ar" : "En",
                         forHTTPHeaderField: "LanguageCode")
        request.setValue("IOS",
                         forHTTPHeaderField: "Platform")
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8",
                         forHTTPHeaderField: "charset")
        
        URLSession.shared.downloadTask(with: request) { (location, response, error) -> Void in
            
            // use guard to unwrap your optional url
            guard let location = location else { return }
            
            let num = Int.random(in: 0...1000)
            let fileName = String((url.lastPathComponent)) as NSString
            // Create destination URL
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsUrl.appendingPathComponent("\(fileName) \(num).mp4")
            
            
            do {
                
                try FileManager.default.moveItem(at: location, to: destinationURL)
                
                PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                    
                    // check if user authorized access photos for your app
                    if authorizationStatus == .authorized {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destinationURL)}) { completed, error in
                                if completed {
                                    
                                    self.cerqel_HUD.stopHUD()
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            }
                    }
                })
                
            } catch { print(error) }
            
        }.resume()
    }
    
    /// Download attached file
    /// - Parameters:
    ///   - url: clicked attachment url
    func downloadFile(vc: UIViewController, url: String) {
        guard let url = URL(string: url) else {return}
        let num = Int.random(in: 0...1000)
        let fileName = String((url.lastPathComponent)) as NSString
        // Create destination URL
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName) \(num).pdf")
        //Create URL to the source file you want to download
        let fileURL = url
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url:fileURL)
        request.setValue("Bearer " + AuthManager.shared.token,
                         forHTTPHeaderField: "Authorization")
        request.setValue(isArabic() ? "Ar" : "En",
                         forHTTPHeaderField: "LanguageCode")
        request.setValue("IOS",
                         forHTTPHeaderField: "Platform")
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("utf-8",
                         forHTTPHeaderField: "charset")
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    DispatchQueue.main.async {[weak self] in
                        guard let `self` = self else {return}
                        self.showToast(vc:vc, message: "Downloaded Successfully".localized, seconds: 3)
                    }
                    
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: [])
                                DispatchQueue.main.async {
                                    vc.present(activityViewController, animated: true, completion: nil)
                                }
                                
                            }
                        }
                    }
                    catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
            self.cerqel_HUD.stopHUD()
        }
        
        task.resume()
    }
    
    
    /// Drawing toast message
    /// - Parameters:
    ///   - message: toast's message
    ///   - seconds: flash message timer
    func showToast(vc: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        vc.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true,completion: nil)
        }
    }
    
    
    /// validating controls
    /// - Parameters:
    ///   - item: current control
    ///   - section: section number
    ///   - row: row number
    /// - Returns: is control valid or not & error message
    func validateControl(vc: FormBaseViewController, _ item: FormViewModelItem) -> (isError: Bool, errorMessage: String) {
        guard !item.hidden else { return (false, "") } // skip hidden fields validation
        switch item.type {
        case .TextBox:
            if let textBoxItem = item as? FormViewModelTextBoxItem {
                let itemAns = item.answer as? TextboxAnswer
                
                // Check if the field is required and itemAns is nil
                if itemAns?.value == ""  || itemAns?.value == nil {
                    if textBoxItem.field?.properties?.required == true {
                        // Required field is nil, return an error
                        let result = vc.formBuilder.handleTextboxValidation(
                            value: "",
                            item: textBoxItem,
                            row: item.fieldId
                        )
                        return (result.isError, result.errorMessage)
                    } else {
                        // Not required and no value, no error
                        return (false, "")
                    }
                }
                
                // If itemAns is not nil, proceed with validation regardless of the 'required' flag
                let result = vc.formBuilder.handleTextboxValidation(
                    value: itemAns?.value ?? "",
                    item: textBoxItem,
                    row: item.fieldId
                )
                return (result.isError, result.errorMessage)
            }
        case .Numerical:
            if let numericItem = item as? FormViewModelNumericItem {
                let itemAns = item.answer as? BaseAnswerText
                // Check if the field is required and itemAns is nil
                if itemAns?.value == ""  || itemAns?.value == nil {
                    if numericItem.field?.properties?.required == true {
                        // Required field is nil, return an error
                        let result = vc.formBuilder.handleNumericValidation(
                            value: "",
                            item: numericItem,
                            row: item.fieldId
                        )
                        return (result.isError, result.errorMessage)
                    } else {
                        // Not required and no value, no error
                        return (false, "")
                    }
                }
                // If itemAns is not nil, proceed with validation regardless of the 'required' flag
                let result = vc.formBuilder.handleNumericValidation(
                    value: itemAns?.value ?? "",
                    item: numericItem,
                    row: item.fieldId
                )
                return (result.isError, result.errorMessage)
            }
        case .TextArea:
            if let textAreaItem = item as? FormViewModelTextAreaItem {
                let itemAns = item.answer as? TextAreaAnswer
                // Check if the field is required and itemAns is nil
                if itemAns?.value == ""  || itemAns?.value == nil {
                    if textAreaItem.field?.properties?.required == true {
                        // Required field is nil, return an error
                        let currentText = itemAns?.value ?? ""
                        let result = FormBuilder.shared.handleEntryLimit(textAreaItem.entryLimit ?? .Character, changedText: currentText, item: textAreaItem, row: textAreaItem.fieldId)
                        return (result.isError, result.errorMessage)
                    } else {
                        // Not required and no value, no error
                        return (false, "")
                    }
                }
                // If itemAns is not nil, proceed with validation regardless of the 'required' flag
                let result = FormBuilder.shared.handleEntryLimit(textAreaItem.entryLimit ?? .Character, changedText:  itemAns?.value ?? "", item: textAreaItem, row: textAreaItem.fieldId)
                return (result.isError, result.errorMessage)
            }
        case .Date:
            if let dateItem = item as? FormViewModelDateItem {
                if  dateItem.answer == nil {
                    if dateItem.required {
                        let result = vc.formBuilder.handleDatePickerValidation(item: dateItem, finalDates: [], finalTimes: [], row: dateItem.fieldId)
                        return (result.isError,result.errorMessage)
                    } else {
                        return (false, "")
                    }
                }
                let dateAnswer = dateItem.answer as? DateTimeAnswer
                var timeValues: [String] = []
                if dateAnswer?.timeValues?.isEmpty ?? false {
                    for dateStr in dateAnswer?.value ?? [] {
                        let modifiedDate = String(dateStr.suffix(5)) // time part
                        timeValues.append(modifiedDate)
                    }
                }
                let timeValueArr = (dateAnswer?.timeValues?.isEmpty ?? false) ? timeValues :  dateAnswer?.timeValues
                let result = vc.formBuilder.handleDatePickerValidation(item: dateItem, finalDates:dateAnswer?.value ?? [], finalTimes: timeValueArr ?? [] , row: dateItem.fieldId)
                return (result.isError,result.errorMessage)
            }
        case .Checkbox:
            if let checkBoxItem = item as? FormViewModelCheckboxItem {
                if let properties = item.field?.properties as? CheckboxProperties {
                    let checkBoxValue = checkBoxItem.answer as? BaseAnswerMCQ
                    if checkBoxValue?.value?.count == 0 || checkBoxValue?.value == nil {
                        if properties.required == true {
                            let result = vc.formBuilder.handleCheckboxValidation(item: checkBoxItem, selectedOptions: checkBoxValue?.value ?? [], min: properties.minNumberOfSelectedOptions ?? 0, max: properties.maxNumberOfSelectedOptions, row: checkBoxItem.fieldId)
                            return (result.error, result.errorMessage)
                        } else {
                            return (false, "")
                        }
                    } else {
                        let result = vc.formBuilder.handleCheckboxValidation(item: checkBoxItem, selectedOptions: checkBoxValue?.value ?? [], min: properties.minNumberOfSelectedOptions ?? 0, max: properties.maxNumberOfSelectedOptions, row: checkBoxItem.fieldId)
                        return (result.error, result.errorMessage)
                    }
                }
            }
        case .Radio:
            if let radioItem = item as? FormViewModelRadioItem {
                if let properties = item.field?.properties as? RadioProperties {
                    let radioValue = radioItem.answer as? BaseAnswerMCQ
                    if radioValue?.value?.count == 0 || radioValue?.value == nil {
                        if properties.required == true {
                            let result = vc.formBuilder.handleCheckboxValidation(item: radioItem, selectedOptions: radioValue?.value ?? [], min: 1, max: 1, row: radioItem.fieldId)
                            return (result.error, result.errorMessage)
                        } else {
                            return (false, "")
                        }
                    } else {
                        let result = vc.formBuilder.handleCheckboxValidation(item: radioItem, selectedOptions: radioValue?.value ?? [], min: 1, max: 1, row: radioItem.fieldId)
                        return (result.error, result.errorMessage)
                    }
                }
            }
        case .Dropdown:
            if let dropdownItem = item as? FormViewModelDropdownItem {
                if let properties = item.field?.properties as? DropdownProperties {
                    let dropDownVal = dropdownItem.answer as? BaseAnswerMCQ
                    if dropDownVal?.value?.count == 0 || dropDownVal?.value == nil {
                        if properties.required == true {
                            let result = vc.formBuilder.handleDropDownError(optionsCount: (dropDownVal?.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: dropdownItem , row: dropdownItem.fieldId)
                            return (result.isError, result.errorMessage)
                        } else {
                            return (false, "")
                        }
                    }
                    let result = vc.formBuilder.handleDropDownError(optionsCount: (dropDownVal?.value?.count ?? 0), minOptions: properties.minNumberOfSelectedOptions, maxOptions: properties.maxNumberOfSelectedOptions, item: dropdownItem , row: dropdownItem.fieldId)
                    return (result.isError, result.errorMessage)
                }
            }
        case .FileUpload:
            if let fileUploadItem = item as? FormViewModelFileUploadItem {
                let fileUploadValue = fileUploadItem.answer as? FileUploadAnswer
                if fileUploadValue?.value?.count == 0 || fileUploadValue?.value == nil {
                    if fileUploadItem.field?.properties?.required == true {
                        let result = vc.formBuilder.handleUplaodFileError(attachCount: fileUploadItem.attachmentsList.count, maxAttachNumber: fileUploadItem.maxAttachmentsNumber, item: fileUploadItem, row: fileUploadItem.fieldId)
                        return (result.isError, result.errorMessage)
                    } else {
                        return (false, "")
                    }
                }
                let result = vc.formBuilder.handleUplaodFileError(attachCount: fileUploadItem.attachmentsList.count, maxAttachNumber: fileUploadItem.maxAttachmentsNumber, item: fileUploadItem, row: fileUploadItem.fieldId)
                return (result.isError, result.errorMessage)
            }
        case .Table:
            if let tableItem = item as? FormViewModelTableItem {
                let res =  vc.formBuilder.handleTableError(cellCount: tableItem.items.count, maxRowNumber: tableItem.maxRows, minRowNumber: tableItem.minRows, item: tableItem, row: tableItem.fieldId)
                return (res.isError, res.errorMessage)

            }
        case .switchControl:
            if let switchItem = item as? FormViewModelSwitchItem {
                let switchAns = switchItem.answer as? SwitchAnswer
                if switchItem.required && switchAns?.value == false {
                    let result = vc.formBuilder.handleSwitchValidationForSwitch(value: switchAns?.value ?? false, item: switchItem, required: switchItem.required , row: switchItem.fieldId)
                    return (result.isError, result.errorMessage)
                } else {
                    return (false, "")
                }
            }
        case .Paragraph:
            if let paragrapghItem = item as? FormViewModelParagraphItem {
                if paragrapghItem.paragraphSubType == .LabelSheetWithToggle || paragrapghItem.paragraphSubType == .LabelSheetWithCheckBox {
                    let paragraphAnswer = paragrapghItem.answer as? ParagraphAnswer
                    var boolVal = false
                    if let value = paragraphAnswer?.value {
                        boolVal = value.lowercased()  == "true"
                    } else {
                        boolVal = false
                    }
                    if paragrapghItem.field?.properties?.required ?? false && boolVal == false {
                        let result = vc.formBuilder.handleSwitchValidation(value: boolVal, item: paragrapghItem, required: paragrapghItem.field?.properties?.required ?? false , row: paragrapghItem.fieldId)
                        return (result.isError, result.errorMessage)
                    } else {
                        return (false, "")
                    }
                }
            }
        default:
            break
        }
        return (false, "") // Default return if no conditions met

    }
}

// MARK: - Related To NestedForm Only
extension FormManager {
    
    /// Reload current tableView in a specific section with it's answer
    /// - Parameters:
    ///   - vc: nested vc
    ///   - sectionObjects: current row controls
    func reloadFormData(vc: NestedFormViewController) {
        let sectionObjects = vc.sectionObjects
        managerSectionObjects.accept((sectionObjects,vc))
        vc.formBuilder.reloadAtNested = { section, answer in
            DispatchQueue.main.async {
                guard section < sectionObjects.count else {return}
                vc.updateProperties(section: section) { updatedSectionObjects in
                    FormManager.shared.updateControlValue(vc: vc,
                                                          sectionObjects: updatedSectionObjects,
                                                          section: section,
                                                          ans: answer,
                                                          fieldId: "")
                }
                
            }
        }
    }
    
    /// Saving table children into the main form then fire thier rules
    /// - Parameters:
    ///   - section: current section number
    ///   - row: current row number
    func saveObjectsIntoFormBuilder(vc: NestedFormViewController, tableSectionObjects: [SectionObject], sectionObjects: [SectionObject], _ section: Int, _ row: Int) {
        managerSectionObjects.accept((tableSectionObjects,vc))
        if let sectionIndex = sectionObjects.firstIndex(where: {$0.id == vc.tableControlFieldID}) {
            guard !sectionObjects[sectionIndex].items.isEmpty else {return}
            guard let allComponent = sectionObjects[sectionIndex].items[0] as? FormViewModelTableItem else {return}
            let children = allComponent.childControls
            guard section < tableSectionObjects.count else {return}
            guard !tableSectionObjects[section].items.isEmpty else {return}
            let childIndex = children.firstIndex(where: {$0.fieldId == tableSectionObjects[section].items[row].fieldId}) ?? 0
            allComponent.childControls[childIndex] =  tableSectionObjects[section].items[row]
            
            vc.formBuilder.sectionObjects[sectionIndex].items[0] = allComponent
            
            for (index,item) in vc.formBuilder.formViewModel.items.enumerated() {
                for (innerChildIndex,child) in allComponent.childControls.enumerated() {
                    if item.fieldId == child.fieldId {
                        if childIndex == innerChildIndex {
                            vc.formBuilder.formViewModel.items[index] = allComponent.childControls[childIndex]
                        }else {
                            for sectionObject in sectionObjects {
                                if sectionObject.items[row].fieldId == vc.formBuilder.formViewModel.items[index].fieldId {
                                    vc.formBuilder.formViewModel.items[index] = sectionObject.items[row]
                                }
                            }
                        }
                    }
                }
            }
            vc.formBuilder.populateItemsDict()
            
            vc.formBuilder.handleItemRules(tableSectionObjects[section].items[row], excludedView: isEditable ? .Edit : .Create, removeAnswer: true)
        }
    }
    
    /// Handle submit button state
    /// - Parameter enabled: should it to be enabled or not
    func handleSubmitButton(vc: NestedFormViewController,submitButton: UIButton, enabled: Bool) {
        guard vc.enableAddButton() else {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = UIColor.init(hexCerqel: "#BDBDBD")
            return
        }
        submitButton.isUserInteractionEnabled = enabled
        submitButton.backgroundColor = !enabled ? UIColor.init(hexCerqel: "#BDBDBD") : .primary
    }
    
    /// Handle FileUpload validation
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - sectionObjects: vc's controls
    ///   - submitButton: vc's submit button
    ///   - item: validated item
    ///   - section: current section number
    ///   - row: current row number
    func validation(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton,_ item: FormViewModelItem, _ section: Int, _ row: Int) {
        managerSectionObjects.accept((sectionObjects,vc))
        if let item = item as? FormViewModelFileUploadItem {
            fieldValidationChangedAt(vc: vc,
                                     sectionObjects: sectionObjects,
                                     submitButton: submitButton,
                                     section,
                                     row: row,
                                     isValid: (!(item.attachmentsList.isEmpty)) && ((item.field?.properties as? FileUploadProperties)?.required ?? false))
        }
    }
    
    /// Check validation of every control
    /// - Parameters:
    ///   - section: current section
    ///   - row: current row
    ///   - isValid: is current control valid or not
    func fieldValidationChangedAt(vc: FormBaseViewController, sectionObjects: [SectionObject], submitButton: UIButton, _ section: Int, row: Int, isValid: Bool) {
        guard vc is NestedFormViewController else {return}
        managerSectionObjects.accept((sectionObjects,vc))
        
        guard section < managerSectionObjects.value.0.count else {
            // Section index is out of range
            return
        }
        guard row < managerSectionObjects.value.0[section].items.count else {
            // Row index is out of range
            return
        }
        
        managerSectionObjects.value.0[section].items[row].isError = !isValid
        managerSectionObjects.value.0[section].items[row].isValid = isValid
        var isDimmed = false
        for section in managerSectionObjects.value.0 {
            for item in section.items {
                // Check if the item is required and its answer is nil
                var isRequired: Bool
                if let switchItem = item as? FormViewModelSwitchItem {
                    isRequired = switchItem.required
                    if (switchItem.answer as? SwitchAnswer)?.value == nil || (switchItem.answer as? SwitchAnswer)?.value == false {
                        item.answer = nil
                    }
                } else if let dropdownItem = item as? FormViewModelDropdownItem {
                    isRequired = dropdownItem.required
                    if (dropdownItem.answer as? BaseAnswerMCQ)?.value == nil || ((dropdownItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? true) {
                        item.answer = nil
                    }
                } else if let checkboxItem = item as? FormViewModelCheckboxItem {
                    isRequired = checkboxItem.required
                    if (checkboxItem.answer as? BaseAnswerMCQ)?.value == nil || ((checkboxItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? true) {
                        item.answer = nil
                    }
                } else if let radioItem = item as? FormViewModelRadioItem {
                    isRequired = radioItem.required
                    if (radioItem.answer as? BaseAnswerMCQ)?.value == nil || ((radioItem.answer as? BaseAnswerMCQ)?.value?.isEmpty ?? true) {
                        item.answer = nil
                    }
                } else if let dateItem = item as? FormViewModelDateItem {
                    isRequired = dateItem.required
                    if (dateItem.answer as? DateTimeAnswer)?.value == nil && (dateItem.answer as? DateTimeAnswer)?.timeValues == nil || ((dateItem.answer as? DateTimeAnswer)?.value?.isEmpty ?? true) {
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
                    isRequired = numericItem.required
                    if item.type == .Numerical {
                        if (numericItem.answer.value as? BaseAnswerText) == nil || ((numericItem.answer as? BaseAnswerText)?.value?.isEmpty ?? true)  {
                            item.answer = nil
                        }
                    } else {
                        if (numericItem.answer as? TextboxAnswer).value == nil || ((numericItem.answer as? TextboxAnswer)?.value?.isEmpty ?? true) {
                            item.answer = nil
                        }
                    }
                } else if let textBoxItem = item as? FormViewModelTextBoxItem {
                    isRequired = textBoxItem.required
                    if (textBoxItem.answer as? TextboxAnswer).value == nil || ((textBoxItem.answer as? TextboxAnswer)?.value?.isEmpty ?? true) {
                        item.answer = nil
                    }
                } else if let fileUploadItem = item as? FormViewModelFileUploadItem {
                    isRequired = fileUploadItem.required
                    if (fileUploadItem.answer as? FileUploadAnswer)?.value?.isEmpty ?? true {
                        item.answer = nil
                    }
                }else if let textAreaItem = item as? FormViewModelTextAreaItem {
                    isRequired = textAreaItem.required
                    if (textAreaItem.answer as? TextAreaAnswer).value == nil || ((textAreaItem.answer as? BaseAnswerText)?.value?.isEmpty ?? true) {
                        item.answer = nil
                    }
                }else if let table = item as? FormViewModelTableItem {
                    if table.items.count < (table.minRows ?? 0) || table.items.count > (table.maxRows ?? 0) {
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
                    print("Required component with error: \(item.label ?? "")")
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
            
            print("isDimmed = \(isDimmed)")
            
            if isDimmed {
                break
            }
        }
        
        if let nestedVC = vc as? NestedFormViewController {
            // handle submit button state
            self.handleSubmitButton(vc: nestedVC, submitButton: submitButton, enabled: !isDimmed)
        }
    }
}

// MARK: - Related To FormViewController Only

extension FormManager {
    
    /// Check fields validations
    /// - Parameter vc: current presenting view controller
    func fieldValidationChangedWhenEditRequestForTableFields(vc: FormViewController) {
        var isDimmed = false
        if !vc.formBuilder.tableSectionObjects.isEmpty {
            
            for i in 0 ... vc.formBuilder.tableSectionObjects.count - 1 {
                let sectionObject = vc.formBuilder.tableSectionObjects[i]
                for item in sectionObject.items  {
                    if let _ = item as? FormViewModelSwitchItem {
                        let requiredItem = (item.field?.properties as? switchProperties)?.required
                        let defaultAnswer = (item.field?.properties as? switchProperties)?.defaultAnswer
                        self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: defaultAnswer, isError: false, reload: false)
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if let checkBoxItem = item as? FormViewModelCheckboxItem {
                        let requiredItem = checkBoxItem.required
                        let defaultAnswer = checkBoxItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? []{
                            // Set selectedValues to contain the matched option
                            selectedValues.append(val)
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if let _ = item as? FormViewModelDropdownItem {
                        let requiredItem = (item.field?.properties as? DropdownProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DropdownProperties)?.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? []{
                            // Set selectedValues to contain the matched option
                            selectedValues.append(val)
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if let radioItem = item as? FormViewModelRadioItem {
                        let requiredItem = radioItem.required
                        let defaultAnswer = radioItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? []{
                            // Set selectedValues to contain the matched option
                            selectedValues.append(val)
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: ans, isError: false, reload: false)
                        }
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    if let item = item as? FormViewModelDateItem {
                        if let defualtAnswer = item.defaultAnswer {
                            var sortedValues = [String]()
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                            for val in defualtAnswer.value ?? [] {
                                if let from = val.from, let to = val.to { // If it's a dateRange
                                    sortedValues.append(dateFormatter.string(from: from))
                                    sortedValues.append(dateFormatter.string(from: to))
                                } else {
                                    if let from = val.from { // If it's a date from
                                        sortedValues.append(dateFormatter.string(from: from))
                                    }
                                }
                            }
                            if !(sortedValues.isEmpty) {
                                let ans = DateTimeAnswer(val: sortedValues, // Assuming this is what you need
                                                         timeValues: [], // Assuming this is what you need
                                                         lNote: nil,
                                                         lAttachments: nil,
                                                         type: .Gregorian)
                                
                                self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: ans, isError: false, reload: false)
                            }
                        }
                        let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DateTimeProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    
                    if item is FormViewModelParagraphItem {
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .Text{
                            let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let ans = ParagraphAnswer(val: defaultAnswer?.value)
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: ans, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
                            }
                        }
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle{
                            let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let boolAns = defaultAnswer?.value?.lowercased() == "true"
                            let ans = ParagraphAnswer(val: String(boolAns))
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: ans, isError: false, reload: false)
                            if defaultAnswer?.value  == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelNumericItem {
                        if AuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value ?? 0.0)", lNote: nil)
                                    self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                            let _ = BaseAnswerText(val: "\(defaultAnswer?.value ?? 0.0)", lNote: "")
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }else {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value?.first ?? "0.0")", lNote: nil)
                                    self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                        
                    }
                    
                    if item is FormViewModelTextBoxItem {
                        if AuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer
                            if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                                isDimmed = true
                            }
                        } else {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value?.first ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelTextAreaItem {
                        if AuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value ?? "", htmlVal: defualtAnswer.htmlValue ?? "", lNote: nil, lAttachments: nil)
                                self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                                isDimmed = true
                            }
                        } else {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value?.first ?? "", htmlVal: defualtAnswer.value?.first ?? "")
                                self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: defaultAnswer, isError: false, reload: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelFileUploadItem {
                        let mediaItem = item as? FormViewModelFileUploadItem
                        var defaultAttchs = [ModelUploadedMedia]()
                        if let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer {
                            for attach in defaultAnswer.value ?? [] {
                                if let uploadedMedia = DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach).uploadedMedia {
                                    defaultAttchs.append(uploadedMedia)
                                }
                                mediaItem?.attachmentsList.append(DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach))
                            }
                            let answer = FileUploadAnswer(val: defaultAttchs, lNote: nil, lAttachments: nil)
                            self.fieldValueChangedAtTableFields(vc: vc, i, row: 0, value: answer, isError: false, reload: false)
                        }
                        let requiredItem = (item.field?.properties as? FileUploadProperties)?.required
                        let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                            isDimmed = true
                        }
                    }
                    if isDimmed {
                        break
                    }
                }
            }
            
            if isEditable || vc.isApproverForm {
                
                // Create a dictionary to hold grouped items based on rowIndex
                var groupedItems: [String: [FormViewModelItem]] = [:]
                // Iterate through tableSectionObjects to populate the groupedItems dictionary
                for sectionObject in vc.formBuilder.tableSectionObjects {
                    for item in sectionObject.items {
                        if let rowIndex = item.rowIndex , item.answer != nil  {
                            let itemExists = vc.formBuilder.allRowsChildControls.contains { existingItem in
                                // Compare based on specific properties of FormViewModelItemStruct
                                // For example, compare based on identifier property
                                return existingItem.fieldId == item.fieldId && existingItem.rowIndex == item.rowIndex
                            }
                            
                            // If the item doesn't exist, append it to allRowsChildControls
                            if !itemExists {
                                vc.formBuilder.allRowsChildControls.append(FormViewModelItemStruct(from: item))
                            }
                            if groupedItems[rowIndex] == nil {
                                groupedItems[rowIndex] = [item]
                            } else {
                                groupedItems[rowIndex]?.append(item)
                            }
                        }
                    }
                }
                rowIndices = vc.formBuilder.allRowsChildControls
                    .compactMap { Int($0.rowIndex ?? "0") }
                    .sorted()
                let tables: [FormViewModelItem] = vc.formBuilder.formModelItems.filter({$0.type == .Table})
                // Convert keys to integers and sort the dictionary
                let sortedItems = groupedItems.sorted { (entry1, entry2) in
                    guard let num1 = Int(entry1.key), let num2 = Int(entry2.key) else {
                        return false // Handle non-integer keys
                    }
                    return num1 < num2
                }
                
                // Now sortedGroupedItems contains the sorted dictionary
                
                for table in tables {
                    if let item = table as? FormViewModelTableItem {
                        for groupItem in sortedItems {
                            // Custom check to determine if groupItem.value exists in item.items
                            var exists = false
                            for existingItems in item.items {
                                if existingItems[0].rowIndex == groupItem.value[0].rowIndex {
                                    existingItems[0].answer = groupItem.value[0].answer
                                    exists = true
                                    break
                                }
                            }
                            // If groupItem.value doesn't exist, append it to item.items
                            if !exists {
                                item.items.append(groupItem.value)
                                item.cascadingComponent = nil
                            }
                        }
                    }
                    for section in vc.formBuilder.sectionObjects {
                        guard !section.items.isEmpty else {return}
                        if section.items[0].fieldId == table.fieldId {
                            
                            vc.formBuilder.handleItemRules(section.items[0], excludedView: isEditable ? .Edit : .Create, removeAnswer: false)
                        }
                    }
                }
            }
            vc.formTableView.reloadData()
            
            vc.formBuilder.reloadAt = { (section, _, _) in
                DispatchQueue.main.async {
                    guard section < vc.formBuilder.sectionObjects.count else {return}
                    vc.formTableView.reloadSections(IndexSet(integer: section), with: .none)
                }
            }
        }
    }
    
    /// check validation for items
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - sectionObjects: vc's children
    ///   - submitButton: vc's submit button
    func fieldValidationChangedWhenEditRequest(vc: FormViewController, sectionObjects: [SectionObject], submitButton: UIButton) {
        managerSectionObjects.accept((sectionObjects,vc))
        fieldValidationChangedWhenEditRequestForTableFields(vc: vc)
        var isDimmed = false
        if !vc.formBuilder.sectionObjects.isEmpty {
            
            for i in 0 ... sectionObjects.count - 1 {
                let sectionObject = sectionObjects[i]
                for (index, item) in sectionObject.items.enumerated() {
                    let row = index  // Use the index as the row value
                    
                    if let switchItem = item as? FormViewModelSwitchItem {
                        let requiredItem = switchItem.required
                        let defaultAnswer = switchItem.defaultAnswer
                        fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: defaultAnswer, isError: false, reload: false, userInteracted: false)
                        if defaultAnswer == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
                        }
                        vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if let dropDownItem = item as? FormViewModelDropdownItem {
                        let requiredItem = dropDownItem.required
                        let defaultAnswer = dropDownItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? [] {
                            selectedValues.append(val)
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: ans, isError: false, reload: false, userInteracted: false)
                        }
                        if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
                        }
                        vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if let checkBoxItem = item as? FormViewModelCheckboxItem {
                        let requiredItem = checkBoxItem.required
                        let defaultAnswer = checkBoxItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? [] {
                            selectedValues.append(val)
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: ans, isError: false, reload: false, userInteracted: false)
                        }
                        if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
                        }
                        
                        vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if let radioItem = item as? FormViewModelRadioItem {
                        let requiredItem = radioItem.required
                        let defaultAnswer = radioItem.defaultAnswer
                        var selectedValues = [MCQOption]()
                        for val in defaultAnswer?.value ?? [] {
                            selectedValues.append(val)
                        }
                        if !(selectedValues.isEmpty) {
                            let ans = BaseAnswerMCQ(val: selectedValues, otherAnswer: "")
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: ans, isError: false, reload: false, userInteracted: false)
                        }
                        if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
                        }
                        vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                        
                    }
                    
                    if let item = item as? FormViewModelDateItem {
                        if let defualtAnswer = item.defaultAnswer {
                            var sortedValues = [String]()
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
                            for val in defualtAnswer.value ?? [] {
                                if let from = val.from, let to = val.to { // If it's a dateRange
                                    sortedValues.append(dateFormatter.string(from: from))
                                    sortedValues.append(dateFormatter.string(from: to))
                                } else {
                                    if let from = val.from { // If it's a date from
                                        sortedValues.append(dateFormatter.string(from: from))
                                    }
                                }
                            }
                            if !(sortedValues.isEmpty) {
                                let ans = DateTimeAnswer(val: sortedValues, timeValues: [], lNote: nil, lAttachments: nil, type: .Gregorian)
                                fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: ans, isError: false, reload: false, userInteracted: false)
                            }
                        }
                        let requiredItem = (item.field?.properties as? DateTimeProperties)?.required
                        let defaultAnswer = (item.field?.properties as? DateTimeProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
                        }
                        
                        vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                    
                    if item is FormViewModelParagraphItem {
                        
                        let requiredItem = (item.field?.properties as? ParagraphProperties)?.required
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .Text {
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let ans = ParagraphAnswer(val: defaultAnswer?.value)
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: ans, isError: false, reload: false, userInteracted: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
                            }
                        }
                        if (item.field?.properties as? ParagraphProperties)?.paragraphSubType == .LabelSheetWithToggle {
                            let defaultAnswer = (item.field?.properties as? ParagraphProperties)?.defaultAnswer
                            let boolAns = defaultAnswer?.value?.lowercased() == "true"
                            let ans = ParagraphAnswer(val: String(boolAns))
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: ans, isError: false, reload: false, userInteracted: false)
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true    {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelNumericItem {
                        if AuthManager.shared.newSubmissionRetreiveEnabled {
                            
                            
                            if item.type == .TextBox {
                                if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswerWhenTextBox {
                                    let answer = TextboxAnswer(val: defualtAnswer.value ?? "", lPrefix: defualtAnswer.prefix, lSuffix: defualtAnswer.suffix, lNote: nil, lAttachments: nil)
                                    fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: true, userInteracted: false)
                                }
                                let requiredItem = (item.field?.properties as? NumberProperties)?.required
                                let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswerWhenTextBox
                                if defaultAnswer == nil && !item.hidden && requiredItem == true  {
                                    isDimmed = true
                                }
                            } else {
                                if let defualtAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer {
                                    if defualtAnswer.value != nil {
                                        let answer = BaseAnswerText(val: "\(defualtAnswer.value ?? 0.0)", lNote: nil)
                                        fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: true, userInteracted: false)
                                    }
                                }
                                let requiredItem = (item.field?.properties as? NumberProperties)?.required
                                let defaultAnswer = (item.field?.properties as? NumberProperties)?.newDefaultAnswer
                                if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                    isDimmed = true
                                }
                            }
                        } else {
                            if let defualtAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer {
                                if defualtAnswer.value != nil {
                                    let answer = BaseAnswerText(val: "\(defualtAnswer.value?.first ?? "0.0")", lNote: nil)
                                    fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: false, userInteracted: false)
                                }
                            }
                            let requiredItem = (item.field?.properties as? NumberProperties)?.required
                            let defaultAnswer = (item.field?.properties as? NumberProperties)?.DefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelTextBoxItem {
                        if AuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: false, userInteracted: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.newDefaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                            
                            vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                        } else {
                            if let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer, defaultAnswer.value != nil {
                                let answer = TextboxAnswer(val: defaultAnswer.value?.first ?? "", lPrefix: defaultAnswer.prefix, lSuffix: defaultAnswer.suffix, lNote: nil, lAttachments: nil)
                                fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: false, userInteracted: false)
                            }
                            let requiredItem = (item.field?.properties as? TextBoxProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextBoxProperties)?.defaultAnswer
                            if defaultAnswer?.value == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelTextAreaItem {
                        if AuthManager.shared.newSubmissionRetreiveEnabled {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value ?? "", htmlVal: defualtAnswer.value ?? "")
                                fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: false, userInteracted: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.newDefaultAnswer
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: defaultAnswer, isError: false, reload: false, userInteracted: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                            vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                        } else {
                            if let defualtAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer {
                                let answer = TextAreaAnswer(val: defualtAnswer.value?.first ?? "", htmlVal: defualtAnswer.value?.first ?? "")
                                fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: false, userInteracted: false)
                            }
                            let requiredItem = (item.field?.properties as? TextAreaProperties)?.required
                            let defaultAnswer = (item.field?.properties as? TextAreaProperties)?.defaultAnswer
                            fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: defaultAnswer, isError: false, reload: false, userInteracted: false)
                            if defaultAnswer == nil && !item.hidden && requiredItem == true {
                                isDimmed = true
                            }
                        }
                    }
                    
                    if item is FormViewModelFileUploadItem {
                        let mediaItem = item as? FormViewModelFileUploadItem
                        var defaultAttchs = [ModelUploadedMedia]()
                        if let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer {
                            for attach in defaultAnswer.value ?? [] {
                                if let uploadedMedia = DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach).uploadedMedia {
                                    defaultAttchs.append(uploadedMedia)
                                }
                                mediaItem?.attachmentsList.append(DynamicAuthManager.shared.convertToUploadMediaUIModel(from: attach))
                            }
                            if !(defaultAttchs.isEmpty) {
                                let answer = FileUploadAnswer(val: defaultAttchs, lNote: nil, lAttachments: nil)
                                fieldValueChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, i, row: row, value: answer, isError: false, reload: false, userInteracted: false)
                            }
                        }
                        let requiredItem = (item.field?.properties as? FileUploadProperties)?.required
                        let defaultAnswer = (item.field?.properties as? FileUploadProperties)?.defaultAnswer
                        if defaultAnswer == nil && !item.hidden && requiredItem == true {
                            isDimmed = true
                        }
                        vc.formTableView.reloadSections(IndexSet(integer: i), with: .none)
                    }
                }
            }
        }
    }
    
    /// check tabl's items validation
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - sectionObjects: vc's children
    ///   - submitButton: vc's submit button
    ///   - tableItems: table children
    ///   - cell: table cell
    ///   - section: current section number
    ///   - row: current row number
    func validateTableItems(vc: FormViewController, sectionObjects: [SectionObject], submitButton: UIButton, _ tableItems: [[FormViewModelItem]], in cell: NewTableControlTVCell, section: Int, row: Int) {
        managerSectionObjects.accept((sectionObjects,vc))
        for tableItem in tableItems {
            for currentControl in tableItem {
                if let numControl = currentControl.field?.properties as? NumberProperties {
                    if let answerText = currentControl.answer as? BaseAnswerText {
                        let isRequired = numControl.required ?? false
                        let isEmptyValue = answerText.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let textBoxControl = currentControl.field?.properties as? FormViewModelTextBoxItem {
                    if let answerText = currentControl.answer as? TextboxAnswer {
                        let isRequired = textBoxControl.required
                        let isEmptyValue = answerText.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                    
                } else if let textAreaControl = currentControl.field?.properties as? TextAreaProperties {
                    if let answerText = currentControl.answer as? TextAreaAnswer {
                        let isRequired = textAreaControl.required ?? false
                        let isEmptyValue = answerText.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let dateTimeControl = currentControl.field?.properties as? DateTimeProperties {
                    if let dateAnswer = currentControl.answer as? DateTimeAnswer {
                        let isRequired = dateTimeControl.required ?? false
                        let isEmptyValue = dateAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let switchControl = currentControl.field?.properties as? switchProperties {
                    if let switchAnswer = currentControl.answer as? SwitchAnswer {
                        let isRequired = switchControl.required ?? false
                        let isEmptyValue = !switchAnswer.value
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let checkboxControl = currentControl.field?.properties as? CheckboxProperties {
                    if let checkBoxAnswer = currentControl.answer as? BaseAnswerMCQ {
                        let isRequired = checkboxControl.required ?? false
                        let isEmptyValue = checkBoxAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let radioControl = currentControl.field?.properties as? RadioProperties {
                    if let  radioAnswer = currentControl.answer as? BaseAnswerMCQ {
                        let isRequired = radioControl.required ?? false
                        let isEmptyValue = radioAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let dropdownControl = currentControl.field?.properties as? DropdownProperties {
                    if let  dropdownAnswer = currentControl.answer as? BaseAnswerMCQ {
                        let isRequired =  dropdownControl.required ?? false
                        let isEmptyValue = dropdownAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let fileUploadControl = currentControl.field?.properties as? FileUploadProperties {
                    if let  fileAnswer = currentControl.answer as? FileUploadAnswer {
                        let isRequired =  fileUploadControl.required ?? false
                        let isEmptyValue = fileAnswer.value?.isEmpty ?? true
                        
                        if isRequired && isEmptyValue && !currentControl.hidden {
                            cell.handleValidation(updateRules: false, requiredChild: true)
                            fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                        }
                    }
                } else if let paragraphControl = currentControl.field?.properties as? ParagraphProperties {
                    if paragraphControl.paragraphSubType == .LabelSheetWithToggle {
                        if let paragraphAnswer = currentControl.answer as? ParagraphAnswer {
                            let isRequired = paragraphControl.required ?? false
                            let isEmptyValue = !(paragraphAnswer.value == "true")
                            
                            if isRequired && isEmptyValue && !currentControl.hidden {
                                cell.handleValidation(updateRules: false, requiredChild: true)
                                fieldValidationChangedAt(vc: vc, sectionObjects: sectionObjects, submitButton: submitButton, section, row: row, isValid: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Setting value to table children
    /// - Parameters:
    ///   - vc: current presenting vc
    ///   - section: current section number
    ///   - row: current row number
    ///   - value: new value
    ///   - isError: if item not valid
    ///   - reload: should reload table or not
    func fieldValueChangedAtTableFields(vc: FormViewController, _ section: Int, row: Int, value: Any?, isError: Bool = false, reload: Bool = true) {
        if vc.formBuilder.isCardMode {
            if vc.formBuilder.formModelItems.indices.contains(vc.currentPage) {
                vc.formBuilder.formModelItems[vc.currentPage].isError = isError
                vc.formBuilder.formModelItems[vc.currentPage].answer = value
            }
        } else {
            if vc.formBuilder.tableSectionObjects.indices.contains(section) && vc.formBuilder.tableSectionObjects[section].items.indices.contains(row) {
                vc.formBuilder.tableSectionObjects[section].items[row].isError = isError
                vc.formBuilder.tableSectionObjects[section].items[row].answer = value
                vc.formBuilder.tableSectionObjects[section].items[row].isValid = !isError
                vc.formBuilder.tableSectionObjects[section].items[row].isUpdated = true
            }
        }
        saveChanges(activeTableView: vc.activeTableView, reload: reload, section: section, row: row)
        DynamicAuthManager.shared.isCameraOpened = false
    }
}
