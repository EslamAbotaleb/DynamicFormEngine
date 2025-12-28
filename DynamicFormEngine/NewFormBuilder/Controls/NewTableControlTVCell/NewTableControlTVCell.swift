//
//  NewTableControlTVCell.swift
//
//
//  Created by Marwan on 30/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit
//internal import FittedSheetsDF

class NewTableControlTVCell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var optionsListHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var initialTableView: UIView!
    @IBOutlet weak var titleInInitialLbl: UILabel!
    @IBOutlet weak var heightForInitalView: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var subLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addRowViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var addRowView: UIView!
    
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var toolTipIcon: UIButton!

    @IBOutlet weak var errorViewHeightLayout: NSLayoutConstraint!
    // MARK: - Variables
    var isSectionItem = false
    var didTapAdd: ((@escaping () -> Void) -> Void)?
    var didTaptableItem: ((Int)->())?
    var didDeleteTableItem: ((Int)->())?
    var validationChanged: ((Bool,Bool) -> ())?
    var tableChildren: [FormViewModelItem] = []
    var rowTitle: String = ""
    var minimiumRows: Int = 0
    var maximumRows: Int = 0
    var allowEdit = false
    var allowDelete = false
    var isRequest: Int = 0
    var tableTitle = ""
    
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelTableItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupTableControl(item: item)
                updateErrorState(inlineError: item.inLineError , message: item.errorMessageInline)
            }
        }
    }
    var isEditable = false
    var toolTipTxt = ""
    var arrayOfOptions: [[FormViewModelItem]] = [] {
        didSet{
            if arrayOfOptions.count > 0 {
                optionsListHeightContraint.constant = arrayOfOptions.count == 1 ? CGFloat(arrayOfOptions.count * 100) : CGFloat(arrayOfOptions.count * 65)
                optionsTV.isHidden = false
                initialTableView.isHidden = true
            }else{
                optionsTV.isHidden = true
                heightForInitalView.constant = 100
                initialTableView.isHidden = false
            }
            optionsTV.reloadData()
        }
    }
    
    private func updateConstraintsForSectionItem(section: Bool) {
        if section {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = true
            NSLayoutConstraint.deactivate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    }
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        optionsTV.delegate = self
        optionsTV.dataSource = self
        optionsTV.register(OptionTVcell.cerqel_nib, forCellReuseIdentifier: OptionTVcell.cerqel_identifier)
        handleGesture()
    }
    
    
    
    // MARK: - Functions
    func handleHiddenViews(item: FormViewModelTableItem?,isRequest: Int) {
            subTitleLbl.isHidden = isRequest > 0 ? true : false
            
            if isRequest > 0 || arrayOfOptions.count > 0 {
                initialTableView.isHidden = true
            }else {
                initialTableView.isHidden = false
            }
            
            self.isRequest = isRequest
            if isRequest > 0 {
                self.addRowView.isHidden = true
                addRowViewHeightLayout.constant = 0
            }else {
                self.addRowView.isHidden = !(item?.allowAddRows ?? false)
                addRowViewHeightLayout.constant = (item?.allowAddRows ?? false) ? 26 : 0
            }
        }
    
    func handleGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    func setupTitle(item: FormViewModelTableItem) {
        guard let localization = item.localization else { return }
        if !isArabicCerqel() {
            titleLbl.text = localization["en"]?.label
            titleInInitialLbl.text = localization["en"]?.label
            tableTitle = localization["en"]?.label ?? ""
        } else {
            if let localizedLabel = item.localization?["ar"]?.label, !localizedLabel.isEmpty {
                titleLbl.text = localizedLabel
                titleInInitialLbl.text = localizedLabel
                tableTitle = localizedLabel
            } else {
                titleLbl.text = localization["en"]?.label
                titleInInitialLbl.text = localization["en"]?.label
                tableTitle = localization["en"]?.label ?? ""
            }
        }
        setRequiredMark(required: minimiumRows > 0, value: titleLbl.text ?? "")
        rowTitle = titleLbl.text ?? ""
        if !isArabicCerqel() {
            if let localizedToolTip = item.localization?["en"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item.tooltip ?? ""
            }
        } else {
            if let localizedToolTip = item.localization?["ar"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item.tooltip ?? ""
            }
        }
        toolTipIcon.isHidden = toolTipTxt.isEmpty

    }
    
    func setRequiredMark(required: Bool, value:String) {
        if required {
            let st = value
            let last = " *"
            let firstAttributes: [NSAttributedString.Key: Any] = [:]
            let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.SST_Arabic_Bold(ofSize: 15)]
            let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
            let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
            firstString.append(lastString)
            self.titleLbl.attributedText = firstString
        }else{
            self.titleLbl.text = value
        }
    }
    
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
    func setupSubTitle(item: FormViewModelTableItem) {
        guard let localization = item.localization else { return }
        if !isArabicCerqel() {
            if let localizedSubLabel = localization["en"]?.sublabel, !localizedSubLabel.isEmpty {
                subTitleLbl.text = localizedSubLabel
            } else {
                subTitleLbl.text = item.sublabel
            }
        } else {
            if let localizedSubLabel = localization["ar"]?.sublabel, !localizedSubLabel.isEmpty {
                subTitleLbl.text = localizedSubLabel
            } else {
                subTitleLbl.text = item.sublabel
            }
        }
        if subTitleLbl.text?.isEmpty == true {
            subTitleLbl.isHidden = true
            subLblHeight.constant = .zero
        } else {
            subTitleLbl.isHidden = false
        }
    }
    
    func setupProperties(item: FormViewModelTableItem) {
        self.minimiumRows = (item.field?.properties as? TableProperties)?.minRows ?? 0
        self.maximumRows = (item.field?.properties as? TableProperties)?.maxRows ?? 0
        self.allowEdit = (item.field?.properties as? TableProperties)?.allowEditRows ?? false
        self.allowDelete = (item.field?.properties as? TableProperties)?.allowDeleteRows ?? false
    }
    
    func setupTableControl(item: FormViewModelTableItem) {
        setupProperties(item: item)
        setupTitle(item: item)
        setupSubTitle(item: item)
        
        arrayOfOptions = item.items
        tableChildren = item.childControls
        if item.items.count < ((item.field?.properties as? TableProperties)?.minRows ?? 0) || item.items.count > ((item.field?.properties as? TableProperties)?.maxRows ?? 0) {
            item.required = true
        }
        if !item.isUpdated, !item.required && item.answer == nil {
            validationChanged?(true,false)
        }
        if item.isUpdated {
            item.isUpdated = false
            handleValidation(updateRules: true)
        }
        tableStackView.isUserInteractionEnabled =  !item.disabled
        optionsTV.reloadData()
        
        if let dataSourceId = item.field?.properties?.dataSourcId, arrayOfOptions.count == 0  {
            dataSourceFetching?(dataSourceId,item)
        }
    }
    
    func resetValues() {
        errorView.isHidden = true
        errorLbl.text = ""
    }
    // table view didSelect action
    func itemTapAction(index: Int,isEdit: Bool? = false) {
        guard let formVC = self.formVC else { return }
        guard let item = item as? FormViewModelTableItem else { return }
        // Assuming `index` is the row index in `item.items`
        let itemControls = item.items[index]
        let sharedControls = FormBuilder.shared.allRowsChildControls
        
        for (i, control) in itemControls.enumerated() {
            if i < sharedControls.count {
                let sharedControl = sharedControls[i]
                
                // Check if both controls have answers
                if let sharedAnswer = sharedControl.answer,
                   let _ = control.answer {
                    
                    // Update the control in item.items with the sharedControl's answer
                    item.items[index][i].answer = sharedAnswer
                }
            }
        }
        let children = item.items[index]
        if let nestedVC = UIStoryboard(name: "NestedFormViewController", bundle: nil).instantiateInitialViewController() as? NestedFormViewController {
            nestedVC.tableControlFieldID = item.fieldId
            nestedVC.tableItem = item
            nestedVC.isEditable = isEditable
            let filteredItems = nestedVC.formBuilder.allRowsChildControls.filter { item in
                if  let rowIndex = item.rowIndex, let rowIndexInt = Int(rowIndex) {
                    return index + 1 == rowIndexInt
                }
                return false
            }
            let sortedItems = filteredItems.sorted { (firstItem: FormViewModelItemStruct, secondItem: FormViewModelItemStruct) -> Bool in
                let firstOrder = Int(firstItem.field?.order ?? "0") ?? 0
                let secondOrder = Int(secondItem.field?.order ?? "0") ?? 0
                return firstOrder < secondOrder
            }
            for i in 0..<sortedItems.count {
                let filteredItem = sortedItems[i]
                if let matchingIndex = children.firstIndex(where: { $0.fieldId == filteredItem.fieldId }) {
                    // Update the child properties with corresponding values from filteredItem
                    children[matchingIndex].answer = filteredItem.answer
                    children[matchingIndex].rowIndex = filteredItem.rowIndex
                }
            }
            
            
            //            let convertedItems = filteredItems.map { FormViewModelItem(from: $0) }
            nestedVC.childControls = children
            nestedVC.itemIndex = index + 1
            nestedVC.formBuilder.currentNestedRowIdx = "\(index + 1 )"
            nestedVC.titleForTable = "\(tableTitle) \(index + 1 )"
            editAt = (edit: true, at: index,delete: false)
            nestedVC.isEdit = isEdit ?? false
            nestedVC.formBuilder.cascadingComponents.accept(nil)
            nestedVC.formBuilder.cascadingComponentsWithMultiParentsNested.accept(nil)
            print("cascadingComponent = ",item.cascadingComponent)
            
            nestedVC.delegate = formVC
            formVC.modalPresentationStyle = .fullScreen
            formVC.present(nestedVC, animated: false, completion: nil)
        }
    }
        
    
    func itemFromRequestTapAction(index: Int,isEdit: Bool? = false) {
        guard let requestDetailsView = self.requestDetailsView else { return }
        guard let item = item as? FormViewModelTableItem else { return }
        // Assuming `index` is the row index in `item.items`
        let itemControls = item.items[index]
        let sharedControls = FormBuilder.shared.allRowsChildControls
        
        for (i, control) in itemControls.enumerated() {
            if i < sharedControls.count {
                let sharedControl = sharedControls[i]
                
                // Check if both controls have answers
                if let sharedAnswer = sharedControl.answer,
                   let _ = control.answer {
                    
                    // Update the control in item.items with the sharedControl's answer
                    item.items[index][i].answer = sharedAnswer
                }
            }
        }
        var children = item.items[index]
        if let nestedVC = UIStoryboard(name: "NestedFormViewController", bundle: nil).instantiateInitialViewController() as? NestedFormViewController {
            nestedVC.tableControlFieldID = item.fieldId
            nestedVC.isEditable = isEditable
            let filteredItems = nestedVC.formBuilder.allRowsChildControls.filter { item in
                if  let rowIndex = item.rowIndex, let rowIndexInt = Int(rowIndex) {
                    return index + 1 == rowIndexInt
                }
                return false
            }
            let sortedItems = filteredItems.sorted { (firstItem: FormViewModelItemStruct, secondItem: FormViewModelItemStruct) -> Bool in
                let firstOrder = Int(firstItem.field?.order ?? "0") ?? 0
                let secondOrder = Int(secondItem.field?.order ?? "0") ?? 0
                return firstOrder < secondOrder
            }
            for i in 0..<sortedItems.count {
                let filteredItem = sortedItems[i]
                if let matchingIndex = children.firstIndex(where: { $0.fieldId == filteredItem.fieldId }) {
                    // Update the child properties with corresponding values from filteredItem
                    children[matchingIndex].answer = filteredItem.answer
                    children[matchingIndex].rowIndex = filteredItem.rowIndex
                }
            }
            
            
            //            let convertedItems = filteredItems.map { FormViewModelItem(from: $0) }
            nestedVC.childControls = children
            nestedVC.itemIndex = index + 1
            nestedVC.formBuilder.currentNestedRowIdx = "\(index + 1 )"
            nestedVC.titleForTable = "\(tableTitle) \(index + 1 )"
            editAt = (edit: true, at: index,delete: false)
            nestedVC.isEdit = isEdit ?? false
            nestedVC.isFromRequestDetails = true
            nestedVC.formBuilder.cascadingComponents.accept(nil)
            nestedVC.formBuilder.cascadingComponentsWithMultiParentsNested.accept(nil)
            print("cascadingComponent = ",item.cascadingComponent)
            
            nestedVC.delegate = requestDetailsView
            requestDetailsView.modalPresentationStyle = .fullScreen
            requestDetailsView.present(nestedVC, animated: false, completion: nil)
        }
    }
    func itemFromSummaryTapAction(index: Int,isEdit: Bool? = false) {
        guard let requestSummaryVC = self.requestSummaryVC else { return }
        guard let item = item as? FormViewModelTableItem else { return }
        // Assuming `index` is the row index in `item.items`
        let itemControls = item.items[index]
        let sharedControls = FormBuilder.shared.allRowsChildControls
        
        for (i, control) in itemControls.enumerated() {
            if i < sharedControls.count {
                let sharedControl = sharedControls[i]
                
                // Check if both controls have answers
                if let sharedAnswer = sharedControl.answer,
                   let _ = control.answer {
                    
                    // Update the control in item.items with the sharedControl's answer
                    item.items[index][i].answer = sharedAnswer
                }
            }
        }
        var children = item.items[index]
        if let nestedVC = UIStoryboard(name: "NestedFormViewController", bundle: nil).instantiateInitialViewController() as? NestedFormViewController {
            nestedVC.tableControlFieldID = item.fieldId
            nestedVC.isEditable = isEditable
            let filteredItems = nestedVC.formBuilder.allRowsChildControls.filter { item in
                if  let rowIndex = item.rowIndex, let rowIndexInt = Int(rowIndex) {
                    return index + 1 == rowIndexInt
                }
                return false
            }
            let sortedItems = filteredItems.sorted { (firstItem: FormViewModelItemStruct, secondItem: FormViewModelItemStruct) -> Bool in
                let firstOrder = Int(firstItem.field?.order ?? "0") ?? 0
                let secondOrder = Int(secondItem.field?.order ?? "0") ?? 0
                return firstOrder < secondOrder
            }
            for i in 0..<sortedItems.count {
                let filteredItem = sortedItems[i]
                if let matchingIndex = children.firstIndex(where: { $0.fieldId == filteredItem.fieldId }) {
                    // Update the child properties with corresponding values from filteredItem
                    children[matchingIndex].answer = filteredItem.answer
                    children[matchingIndex].rowIndex = filteredItem.rowIndex
                }
            }
            
            
            //            let convertedItems = filteredItems.map { FormViewModelItem(from: $0) }
            nestedVC.childControls = children
            nestedVC.itemIndex = index + 1
            nestedVC.formBuilder.currentNestedRowIdx = "\(index + 1 )"
            nestedVC.titleForTable = "\(tableTitle) \(index + 1 )"
            editAt = (edit: true, at: index,delete: false)
            nestedVC.isEdit = isEdit ?? false
            nestedVC.isFromRequestDetails = true
            nestedVC.formBuilder.cascadingComponents.accept(nil)
            nestedVC.formBuilder.cascadingComponentsWithMultiParentsNested.accept(nil)
            print("cascadingComponent = ",item.cascadingComponent)
            
            nestedVC.delegate = requestSummaryVC
            requestSummaryVC.modalPresentationStyle = .fullScreen
            requestSummaryVC.present(nestedVC, animated: false, completion: nil)
        }
    }
    func syncPropertiesFromTableProperties(item: FormViewModelTableItem) {
        guard let properties = item.field?.properties as? TableProperties else {
            return
        }

        // Set only if `properties` values are non-nil
        if let minRows = properties.minRows {
            item.minRows = minRows
            self.minimiumRows = minRows
        }
        
        if let maxRows = properties.maxRows {
            item.maxRows = maxRows
            self.maximumRows = maxRows
        }
        
        if let showTotals = properties.showTotals {
            item.showTotals = showTotals
        }
        
        if let totalFields = properties.totalFields {
            item.totalFields = totalFields
        }
        
        if let allowDeleteRows = properties.allowDeleteRows {
            item.allowDeleteRows = allowDeleteRows
            self.allowDelete = allowDeleteRows
        }
        
        if let allowEditRows = properties.allowEditRows {
            item.allowEditRows = allowEditRows
            self.allowEdit = allowEditRows
        }
        
        if let allowAddRows = properties.allowAddRows {
            item.allowAddRows = allowAddRows
            self.addRowView.isHidden = !allowAddRows
        }
    }

    func handleValidation(updateRules: Bool) {
        guard let item = item as? FormViewModelTableItem else { return }
        syncPropertiesFromTableProperties(item: item)
        let validation = FormBuilder.shared.handleTableError(cellCount: arrayOfOptions.count, maxRowNumber: (item.field?.properties as? TableProperties)?.maxRows, minRowNumber: (item.field?.properties as? TableProperties)?.minRows, item: item, row: item.fieldId)
        if validation.isError {
            errorView.isHidden = false
            errorLbl.text = validation.errorMessage
            item.inLineError = validation.isError
            item.errorMessageInline = validation.errorMessage
            validationChanged?(false,updateRules)
        } else {
            item.inLineError = false
            item.errorMessageInline = ""
            errorView.isHidden = true
            errorViewHeightLayout.constant = 0
            validationChanged?(true,updateRules)
        }
        
    }
    
    func handleValidation(updateRules: Bool, requiredChild: Bool = false) {
        guard let item = item as? FormViewModelTableItem else { return }
        //        guard item.required else {return}
        syncPropertiesFromTableProperties(item: item)
        let validation = FormBuilder.shared.handleTableError(cellCount: arrayOfOptions.count, maxRowNumber: (item.field?.properties as? TableProperties)?.maxRows, minRowNumber: (item.field?.properties as? TableProperties)?.minRows, item: item, row: item.fieldId, requiredChild: requiredChild)
        if validation.isError/*, validation.errorType == .required*/ {
            errorView.isHidden = false
            errorLbl.text = validation.errorMessage
            validationChanged?(false,updateRules)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addBtnTapped(){
        if let tableItem = self.item as? FormViewModelTableItem {
            setupProperties(item: tableItem)
        }
        item.isUpdated = true
        didTapAdd? {
            guard let formVC = self.formVC else { return }
            guard let tableItem = self.item as? FormViewModelTableItem, self.arrayOfOptions.count < (self.maximumRows) else { return }
            
            var children: [FormViewModelItem] = []
            for table in FormBuilder.shared.tables {
                guard tableItem.fieldId == table else { continue }
                let tableChildren = FormBuilder.shared.tablesDictionary[table] ?? []
                for tableChild in tableChildren {
                    if children.map({$0.fieldId}).contains(tableChild.fieldId) {
                        continue
                    }
                    if let child = tableChild as? FormViewModelTextBoxItem {
                        let copy = child.copy() as! FormViewModelTextBoxItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelNumericItem {
                        let copy = child.copy() as! FormViewModelNumericItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelTextAreaItem {
                        let copy = child.copy() as! FormViewModelTextAreaItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelParagraphItem {
                        let copy = child.copy() as! FormViewModelParagraphItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelDateItem {
                        let copy = child.copy() as! FormViewModelDateItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelCheckboxItem {
                        let copy = child.copy() as! FormViewModelCheckboxItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelRadioItem {
                        let copy = child.copy() as! FormViewModelRadioItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelDropdownItem {
                        let copy = child.copy() as! FormViewModelDropdownItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.options = child.options
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelFileUploadItem {
                        let copy = child.copy() as! FormViewModelFileUploadItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                    
                    if let child = tableChild as? FormViewModelSwitchItem {
                        let copy = child.copy() as! FormViewModelSwitchItem
                        copy.disabled = child.disabled
                        copy.hidden = child.hidden
                        copy.rowIndex = "\(self.arrayOfOptions.count + 1)"
                        children.append(copy)
                        continue
                    }
                }
            }
            if let nestedVC = UIStoryboard(name: "NestedFormViewController", bundle: nil).instantiateInitialViewController() as? NestedFormViewController {

                nestedVC.tableControlFieldID = tableItem.fieldId
                nestedVC.tableItem = tableItem
                nestedVC.childControls = children
                nestedVC.isEditable = self.isEditable
                nestedVC.itemIndex = (self.arrayOfOptions.count + 1)
                nestedVC.formBuilder.currentNestedRowIdx = "\((self.arrayOfOptions.count + 1))"
                nestedVC.delegate = formVC
                nestedVC.isFromRequestDetails = self.isRequest > 0 ? true : false
                nestedVC.titleForTable = "\(self.tableTitle) \(self.arrayOfOptions.count + 1)"
                formVC.modalPresentationStyle = .fullScreen
                editAt = (edit: false, at: 0,delete: false)
                nestedVC.formBuilder.cascadingComponents.accept(nil)
                nestedVC.formBuilder.cascadingComponentsWithMultiParentsNested.accept(nil)
                formVC.present(nestedVC, animated: false, completion: nil)
                
            }
        }
    }
}


extension NewTableControlTVCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTVcell.cerqel_identifier, for: indexPath) as! OptionTVcell
        cell.deleteBtn.isHidden = !self.allowDelete
        cell.editBtn.isHidden = !self.allowEdit
        cell.nameLbl.text =  "\(rowTitle) \(indexPath.row + 1)"
        cell.handleDisabledData(isDisable:(item.disabled || item.field?.properties?.readonly ?? false))
        cell.deleteBtn.isHidden = isRequest > 0 ? true : !self.allowDelete
        cell.editBtn.isHidden = isRequest > 0 ? true : !self.allowEdit
        cell.viewBtn.isHidden = isRequest > 0 ? false : true
        cell.deleteBtnTapped = { [weak self] in
            if let item = self?.item as? FormViewModelTableItem {
                item.items.remove(at: indexPath.row)
                self?.didDeleteTableItem?(indexPath.row)
                item.isUpdated = true
                self?.setupTableControl(item: item)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    editAt = (edit: true, at: indexPath.row, delete: true)
                }
            }
            tableView.reloadData()
        }
        cell.editBtnTapped = { [weak self] in
            self?.item.isUpdated = true
            self?.itemTapAction(index: indexPath.row, isEdit: true)
        }
        
        cell.viewBtnTapped = { [weak self] in
            self?.item.isUpdated = true
            if self?.isRequest == 1 {
                self?.itemFromRequestTapAction(index: indexPath.row, isEdit: false)
            }
            else if self?.isRequest == 2 {
                self?.itemFromSummaryTapAction(index: indexPath.row, isEdit: false)
            }
            else {
                self?.itemTapAction(index: indexPath.row, isEdit: true)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRequest == 1 {
            itemFromRequestTapAction(index: indexPath.row, isEdit: false)
        }
        else if isRequest == 2 {
            itemFromSummaryTapAction(index: indexPath.row, isEdit: false)
        }
        else {
            itemTapAction(index: indexPath.row, isEdit: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NewTableControlTVCell: ValidatableCell {
    func updateErrorState(inlineError: Bool, message: String = "") {
        if inlineError {
            displayValidationError(message)
        } else {
            clearValidationError()
        }
    }

    func displayValidationError(_ message: String) {
//        updateConstraintsForSectionItem(section: item.isSectionControl)
        errorView.isHidden = false
        errorLbl.text = message
    }

    func clearValidationError() {
        errorView.isHidden = true
        errorLbl.text = ""
        errorViewHeightLayout.constant = 0
    }
}

