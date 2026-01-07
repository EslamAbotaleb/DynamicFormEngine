//
//  FormBuilder+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

//extension FormBuilderVC: UITableViewDelegate, UITableViewDataSource{
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return viewModel.arrayOfTypes.count
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////
////        guard viewModel.arrayOfControls[indexPath.row].isHidden == false else{
////            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
////            return cell
////        }
////
////        if let vis = viewModel.arrayOfControls[indexPath.row].isVisible, vis == false{
////            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
////            return cell
////        }
////
////        switch viewModel.arrayOfTypes[indexPath.row]{
////        case .DropDown:
////            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownTVcell.cerqel_identifier, for: indexPath) as! DropDownTVcell
////            cell.configure(control: viewModel.arrayOfControls[indexPath.row])
////            cell.didChangeExpand = { [weak self] in
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.arrayOfControls[indexPath.row].isExpanded.toggle()
////                print("is Expanded: \(self?.viewModel.arrayOfControls[indexPath.row].isExpanded)")
////                self?.viewModel.doReload.accept([indexPath])
////            }
////
////            cell.didSelectOption = { [weak self] optionIdx, valids, isValid, inValidCon, notValidName in
////                if var opts = self?.viewModel.arrayOfControls[indexPath.row].options, opts.count > 0{
////                    if let multi = self?.viewModel.arrayOfControls[indexPath.row].isMultiSelect, multi{
////                        opts[optionIdx].isSelected.toggle()
////                        var valArr: [OptionsCerqel] = []
////                        for i in 0 ... opts.count - 1{
////                            if opts[i].isSelected{
////                                valArr.append(opts[i])
////                            }
////                        }
////
////
////                        self?.viewModel.arrayOfControls[indexPath.row].value = valArr
////
////                    }else{
////                        for i in 0 ... opts.count - 1{
////                            if i == optionIdx{
////                                opts[i].isSelected = true
////                            }else{
////                                opts[i].isSelected = false
////                            }
////                        }
////                        self?.viewModel.arrayOfControls[indexPath.row].value = [opts[optionIdx]]
////
////                        if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, idxs.count > 0, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                            self?.viewModel.deleteDependeciesValues(parentIdx: myIdx, idxsToCheck: idxs)
////                        }
////
////                    }
////
////                    self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                    self?.viewModel.arrayOfControls[indexPath.row].options = opts
////                    self?.viewModel.arrayOfControls[indexPath.row].validations = valids
////                    self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                    cell.arrayOfOptions = opts
////                    if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, idxs.count > 0, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                        self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////                    }
////                }
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.arrayOfControls[indexPath.row].isExpanded.toggle()
////                self?.viewModel.doReload.accept([indexPath])
////                self?.viewModel.inValidCon.accept(inValidCon)
////                cell.optionsTV.reloadData()
////
////                self?.viewModel.manageCascadingRelation(parentIdx: indexPath.row)
////            }
////            return cell
////
////
////        case .RadioButton:
////            if viewModel.arrayOfControls[indexPath.row].options?.count == 2{
////
////                let cell = tableView.dequeueReusableCell(withIdentifier: Radio2ItemsOnlyTVcell.cerqel_identifier, for: indexPath) as! Radio2ItemsOnlyTVcell
////                cell.configure(control: viewModel.arrayOfControls[indexPath.row])
////
////                cell.didSelectOption = { [weak self] optionIdx, valids, isValid, inValidCon, notValidName in
////                    if var opts = self?.viewModel.arrayOfControls[indexPath.row].options, opts.count > 0{
////                        for i in 0 ... opts.count - 1{
////                            if i == optionIdx{
////                                opts[i].isSelected = true
////                            }else{
////                                opts[i].isSelected = false
////                            }
////                        }
////                        self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                        self?.viewModel.arrayOfControls[indexPath.row].value = [opts[optionIdx]]
////                        self?.viewModel.arrayOfControls[indexPath.row].options = opts
////                        self?.viewModel.arrayOfControls[indexPath.row].validations = valids
////                        self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////
////                        cell.arrayOfOptions = opts
////                        if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                            self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                        }
////                    }
////                    self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                    self?.viewModel.doReload.accept([indexPath])
////                    self?.viewModel.inValidCon.accept(inValidCon)
////
////                }
////                return cell
////
////
////
////
////            }else{
////                return UITableViewCell()
////            }
////
////
////        case .TextBox:
////            let cell = tableView.dequeueReusableCell(withIdentifier: TextBoxTVcell.cerqel_identifier, for: indexPath) as! TextBoxTVcell
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            if let equ = self.viewModel.arrayOfControls[indexPath.row].relationEquation, let resuArr = equ.resultIndexes, resuArr.count > 0{
////                for resIdx in resuArr{
////                    self.viewModel.ManageRquationRelations(resultId: resIdx)
////                }
////            }
////
////            cell.didChangeText = { [weak self] text, isValid, inValidCon, notValidName in
////
////                self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                self?.viewModel.arrayOfControls[indexPath.row].value = [text]
////                if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                    self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                }
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.doReload.accept([indexPath])
////                self?.viewModel.inValidCon.accept(inValidCon)
////            }
////            return cell
////
////        case .TextArea:
////            let cell = tableView.dequeueReusableCell(withIdentifier: TextAreaTVcell.cerqel_identifier, for: indexPath) as! TextAreaTVcell
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didChangeText = { [weak self] text, isValid , inValidCon, notValidName in
////
////                self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                self?.viewModel.arrayOfControls[indexPath.row].value = [text]
////                if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                    self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                }
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.doReload.accept([indexPath])
////                self?.viewModel.inValidCon.accept(inValidCon)
////
////            }
////            return cell
////
////
////
////        case .FileUpload:
////            let cell = tableView.dequeueReusableCell(withIdentifier: UploadMediaTVcell.cerqel_identifier, for: indexPath) as! UploadMediaTVcell
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didTapAddAttachment = {
//////                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [ModelUploadedMediaCerqel]{
//////                    if arr.count < self.viewModel.arrayOfControls[indexPath.row].filesNumber ?? 0{
//////                        self.viewModel.selectedMediaUploaderIdx = indexPath.row
////                        self.cerqel_openMediaMenu()
//////                    }else{
//////                        self.viewModel.errorsSubject.onNext(BaseError.other(title: "Max Attachment Number is reached!".localized))
//////                    }
//////                }
//////                self.viewModel.selectedMediaUploaderIdx = indexPath.row
//////                self.openMediaMenu()
////            }
////
////            cell.didRemoveAttachment = { idx in
////                if let val = self.viewModel.arrayOfControls[indexPath.row].value, var arr = val as? [ModelUploadedMediaCerqel], arr.count > idx{
////                    arr.remove(at: idx)
////                    self.viewModel.arrayOfControls[indexPath.row].value = arr
////
////                    // edit by omar
////                    self.viewModel.checkValidation(control: self.viewModel.arrayOfControls[indexPath.row]) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
////
////                        self.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////
////                    }
////
////                    self.viewModel.doReload.accept([indexPath])
////                }
////            }
////
////            return cell
////
////
////        case .Link:
////            let cell = tableView.dequeueReusableCell(withIdentifier: LinkTVcellTableViewCell.cerqel_identifier, for: indexPath) as! LinkTVcellTableViewCell
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////
////            return cell
////
////        case .DatePicker:
////            let cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTVcell.cerqel_identifier, for: indexPath) as! DatePickerTVcell
////
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didTapDate = {
////                let picker = DatePickerPopup.instance()
////                picker.pickerTitle = ""
////        //                picker.currentDate = viewModel.fromDate
////                var dateCalendarType: Calendar.Identifier = .gregorian
////                if let type = cell.controlData.calendarType{
////                    switch type {
////                    case .Gregorian:
////                        picker.dateCalendarType = .gregorian
////                        dateCalendarType = .gregorian
////                    case .Hijri:
////                        picker.dateCalendarType = .islamicUmmAlQura
////                        dateCalendarType = .islamicUmmAlQura
////                    case .Gregorian_Hijri:
////                        print("EEh el L8bata Di")
////
////                    }
////                }
////                picker.didPickDate = { date in
////                    print(date)
////                    if let format = self.viewModel.arrayOfControls[indexPath.row].format{
////                        let formatter = DateFormatter()
////                        formatter.dateFormat = format
////                        formatter.timeZone = currentTimeZoneCerqel
////                        formatter.locale = dateFormatterLocal_en_USCerqel
////                        formatter.calendar = .init(identifier: dateCalendarType)
////                        cell.controlData.value = [formatter.string(from: date)]
////                        cell.checkValidation(control: cell.controlData) { [weak self] (isValid, conditionsArr, inValidCon, notValidConditionName) in
////                            self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                            self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidConditionName
////                            self?.viewModel.arrayOfControls[indexPath.row].value = cell.controlData.value
////                            if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                                self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                            }
////                            self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                            self?.viewModel.doReload.accept([indexPath])
////                            self?.viewModel.inValidCon.accept(inValidCon)
////
////                        }
////
////                    }
////
////                }
////                var minDate: Date? = nil
////                var maxDate: Date? = nil
////                var current: Date = Date()
////                if let min = self.viewModel.arrayOfControls[indexPath.row].minDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMinMonth, isMonth{
////                        let newMin = min * -1
////                        minDate = Date().addingMonthsCerqel(months: newMin)
////                    }else{
////                        minDate = Date().addingDaysCerqel(days: min)
////                    }
////                }
////                if let max = self.viewModel.arrayOfControls[indexPath.row].maxDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMaxMonth, isMonth{
////                        maxDate = Date().addingMonthsCerqel(months: max)
////                    }else{
////                        maxDate = Date().addingDaysCerqel(days: max)
////                    }
////                }
////
////                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String], let val = arr.first, let dt = val.cerqel_getDateFromString(){
////                    current = dt
////                }
//////                DatePicker
////                picker.showDate(vc: self, sender: nil, mode: .date, minimum: minDate, maximum: maxDate, currentDate: current)
////
////
////            }
////            return cell
////
////
////        case .Switch:
////            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTVcell.cerqel_identifier, for: indexPath) as! SwitchTVcell
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didChangeText = { [weak self] value, isValid , inValidCon, notValidName in
////
////                self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                self?.viewModel.arrayOfControls[indexPath.row].value = [value]
////                if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                    self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                }
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.doReload.accept([indexPath])
////                self?.viewModel.inValidCon.accept(inValidCon)
////
////            }
////            return cell
////
////
////        case .DateRangePicker:
////            let cell = tableView.dequeueReusableCell(withIdentifier: RangeDatePickerTVcell.cerqel_identifier, for: indexPath) as! RangeDatePickerTVcell
////
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didTapDate = { isFromDate in
////                let picker = DatePickerPopup.instance()
////                picker.pickerTitle = ""
////                var dateCalendarType: Calendar.Identifier = .gregorian
////                if let type = cell.controlData.calendarType{
////                    switch type {
////                    case .Gregorian:
////                        picker.dateCalendarType = .gregorian
////                        dateCalendarType = .gregorian
////                    case .Hijri:
////                        picker.dateCalendarType = .islamicUmmAlQura
////                        dateCalendarType = .islamicUmmAlQura
////                    case .Gregorian_Hijri:
////                        print("EEh el L8bata Di")
////
////                    }
////                }
////                picker.didPickDate = { date in
////                    print(date)
////                    if let format = self.viewModel.arrayOfControls[indexPath.row].format{
////                        let formatter = DateFormatter()
////                        formatter.dateFormat = format //"dd/MM/yyyy" if the format came from BE like this dd/mm/yyyy that will show a wrong Data
////                        formatter.timeZone = currentTimeZoneCerqel
////                        formatter.locale = dateFormatterLocal_en_USCerqel
////                        formatter.calendar = .init(identifier: dateCalendarType)
////
////                        if isFromDate{ // Set From Date
////                            if var arr = cell.controlData.value as? [String], arr.count > 0{
////                                arr[0] = formatter.string(from: date)
////                                cell.controlData.value = arr
////
////                            }else{
////                                cell.controlData.value = [formatter.string(from: date)]
////                            }
////                        }else{ // Set To Date
////                            if var arr = cell.controlData.value as? [String], arr.count > 0{
////                                if arr.count > 1{
////                                    arr[1] = formatter.string(from: date)
////                                    cell.controlData.value = arr
////
////                                }else{
////                                    arr.append(formatter.string(from: date))
////                                    cell.controlData.value = arr
////                                }
////
////                            }else{
////                                cell.controlData.value = ["", formatter.string(from: date)]
////                            }
////
////                        }
//////                        cell.controlData.value = [formatter.string(from: date)]
////                        cell.checkValidation(control: cell.controlData) { [weak self] (isValid, conditionsArr, inValidCon, notValidConditionName) in
////                            self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                            self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidConditionName
////                            self?.viewModel.arrayOfControls[indexPath.row].value = cell.controlData.value
////                            if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                                self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                            }
////                            self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                            self?.viewModel.doReload.accept([indexPath])
////                            self?.viewModel.inValidCon.accept(inValidCon)
////
////                        }
////
////                    }
////
////                }
////                var minDate: Date? = nil
////                var maxDate: Date? = nil
////                var currentDate = Date()
////
////                if let min = self.viewModel.arrayOfControls[indexPath.row].minDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMinMonth, isMonth{
////                        minDate = Date().addingMonthsCerqel(months: min)
////                    }else{
////                        minDate = Date().addingDaysCerqel(days: min)
////                    }
////                }else{
////                    minDate = nil
////                }
////                if let max = self.viewModel.arrayOfControls[indexPath.row].maxDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMaxMonth, isMonth{
////                        maxDate = Date().addingMonthsCerqel(months: max)
////                    }else{
////                        maxDate = Date().addingDaysCerqel(days: max)
////                    }
////                }else{
////                    maxDate = nil
////                }
////
////                if isFromDate{
////
////                    if let sMin = self.viewModel.arrayOfControls[indexPath.row].startMin?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].startMin?.key{
////                            if key == ""{
////
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                minDate = Date().addingMonthsCerqel(months: sMin)
////                            }else{
////                                minDate = Date().addingDaysCerqel(days: sMin)
////                            }
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].startMin?.key, key == "lastOfYear"{
////                        minDate = self.getLastDayOfYear()
////                    }
////
////                    if let sMax = self.viewModel.arrayOfControls[indexPath.row].startMax?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].startMax?.key{
////                            if key == ""{
////
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                maxDate = Date().addingMonthsCerqel(months: sMax)
////                            }else{
////                                maxDate = Date().addingDaysCerqel(days: sMax)
////                            }
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].startMax?.key, key == "lastOfYear"{
////                        maxDate = self.getLastDayOfYear()
////                    }
////
////                    // From Date MUST BE < To date
////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////                        if arr.count > 1{
////                            let toDate = arr[1]
////                            let selectedToDate = toDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "")
////                            maxDate = selectedToDate
////                        }
////                        currentDate = arr.first?.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "") ?? Date()
////
////                    }
////
////                }else{ // To Date
////                    // To Date MUST BE > From Date
////
////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String], let fromDate = arr.first{
////                        if let selectedFromDate = fromDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
////                            minDate = selectedFromDate
////                        }
////                    }
////
////                    if let eMin = self.viewModel.arrayOfControls[indexPath.row].endMin?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].endMin?.key{
////                            if key == "startDate"{
////                                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////                                    if let fromDate = arr.first{
////                                        if let selectedFromDate = fromDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
////                                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                                minDate = selectedFromDate.addingMonthsCerqel(months: eMin)
////                                            }else{
////                                                minDate = selectedFromDate.addingDaysCerqel(days: eMin)
////                                            }
////                                        }
////                                    }else{
////                                        minDate = nil
////                                    }
////                                }else{
////                                    minDate = nil
////                                }
////                            }else{
////                                if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                    minDate = Date().addingMonthsCerqel(months: eMin)
////                                }else{
////                                    minDate = Date().addingDaysCerqel(days: eMin)
////                                }
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                minDate = Date().addingMonthsCerqel(months: eMin)
////                            }else{
////                                minDate = Date().addingDaysCerqel(days: eMin)
////                            }
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].endMin?.key, key == "lastOfYear"{
////                        minDate = self.getLastDayOfYear()
////                    }
////
////                    if let eMax = self.viewModel.arrayOfControls[indexPath.row].endMax?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].endMax?.key{
////                            if key == "startDate"{
////                                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////                                    if let fromDate = arr.first{
////                                        if let selectedFromDate = fromDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
////                                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                                maxDate = selectedFromDate.addingMonthsCerqel(months: eMax)
////                                            }else{
////                                                maxDate = selectedFromDate.addingDaysCerqel(days: eMax)
////                                            }
////
////                                        }
////                                    }else{
////                                        maxDate = nil
////                                    }
////                                }else{
////                                    maxDate = nil
////                                }
////                            }else{
////                                if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                    maxDate = Date().addingMonthsCerqel(months: eMax)
////                                }else{
////                                    maxDate = Date().addingDaysCerqel(days: eMax)
////                                }
////
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                maxDate = Date().addingMonthsCerqel(months: eMax)
////                            }else{
////                                maxDate = Date().addingDaysCerqel(days: eMax)
////                            }
////
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].endMax?.key, key == "lastOfYear"{
////                        maxDate = self.getLastDayOfYear()
////                    }
////
////                    //set current date
////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////
////                        if arr.count > 1{
////                            currentDate = arr[1].cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "") ?? Date()
////
////                        }else{
////                            currentDate = Date()
////                        }
////
////                    }
////                }
////
////                print("DATE ISSUE: MIN = \(minDate.debugDescription)")
////                print("DATE ISSUE: MAX = \(maxDate.debugDescription)")
////                print("DATE ISSUE: CURRENT = \(currentDate.debugDescription)")
////                print("DATE ISSUE: -------------------------------------")
////                picker.showDate(vc: self, sender: nil, mode: .date, minimum: minDate, maximum: maxDate, currentDate: currentDate)
////
////            }
////            return cell
////
////        case .Label:
////            let cell = tableView.dequeueReusableCell(withIdentifier: LabelControleTVcell.cerqel_identifier, for: indexPath) as! LabelControleTVcell
////
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            return cell
////
////        case .InfoIndicator:
////            let cell = tableView.dequeueReusableCell(withIdentifier: InfoIndicatorTVcell.cerqel_identifier, for: indexPath) as! InfoIndicatorTVcell
////
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            return cell
////
////        case .TimePicker:
////            let cell = tableView.dequeueReusableCell(withIdentifier: TimePickerTVcell.cerqel_identifier, for: indexPath) as! TimePickerTVcell
////
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didTapTime = {
////                let picker = DatePickerPopup.instance()
////                picker.pickerTitle = ""
////                picker.datePickerMode = .time
////                picker.didPickDate = { date in
////                    print(date)
////                    if let format = self.viewModel.arrayOfControls[indexPath.row].format{
////                        let formatter = DateFormatter()
////                        formatter.dateFormat = format
////                        formatter.timeZone = currentTimeZoneCerqel
////                        formatter.locale = dateFormatterLocal_en_USCerqel
//////                        formatter.calendar = .init(identifier: dateCalendarType)
////                        cell.controlData.value = [formatter.string(from: date)]
////                        print(formatter.string(from: date))
////                        cell.checkValidation(control: cell.controlData) { [weak self] (isValid, conditionsArr, inValidCon, notValidConditionName) in
////                            self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                            self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidConditionName
////                            self?.viewModel.arrayOfControls[indexPath.row].value = cell.controlData.value
////                            if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                                self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                            }
////                            self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                            self?.viewModel.doReload.accept([indexPath])
////                            self?.viewModel.inValidCon.accept(inValidCon)
////
////                        }
////
////                    }
////
////                }
////                var minDate: Date? = nil
////                var maxDate: Date? = nil
////                var current: Date = Date()
////                if let min = self.viewModel.arrayOfControls[indexPath.row].minDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMinMonth, isMonth{
////                        minDate = Date().addingMonthsCerqel(months: min)
////                    }else{
////                        minDate = Date().addingDaysCerqel(days: min)
////                    }
////                }
////                if let max = self.viewModel.arrayOfControls[indexPath.row].maxDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMaxMonth, isMonth{
////                        maxDate = Date().addingMonthsCerqel(months: max)
////                    }else{
////                        maxDate = Date().addingDaysCerqel(days: max)
////                    }
////                }
////
////                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String], let val = arr.first, let dt = val.cerqel_getDateFromString(){
////                    current = dt
////                }
////                picker.showDate(vc: self, sender: nil, mode: .time, minimum: minDate, maximum: maxDate, currentDate: current)
////
////
////            }
////            return cell
////
////        case .CheckBox:
////            let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxControlTVcell.cerqel_identifier, for: indexPath) as! CheckBoxControlTVcell
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didChangeText = { [weak self] value, isValid , inValidCon, notValidName in
////
////                self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                self?.viewModel.arrayOfControls[indexPath.row].value = [value]
////                if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                    self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                }
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.doReload.accept([indexPath])
////                self?.viewModel.inValidCon.accept(inValidCon)
////
////            }
////
////            return cell
////
////        case .DateTimeRangePicker:
////            let cell = tableView.dequeueReusableCell(withIdentifier: DateTimeRangePickerTVcell.cerqel_identifier, for: indexPath) as! DateTimeRangePickerTVcell
////
////            cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////            cell.didTapDate = { isFromDate in
////                let picker = DatePickerPopup.instance()
////                picker.pickerTitle = ""
////                var dateCalendarType: Calendar.Identifier = .gregorian
////                if let type = cell.controlData.calendarType{
////                    switch type {
////                    case .Gregorian:
////                        picker.dateCalendarType = .gregorian
////                        dateCalendarType = .gregorian
////                    case .Hijri:
////                        picker.dateCalendarType = .islamicUmmAlQura
////                        dateCalendarType = .islamicUmmAlQura
////                    case .Gregorian_Hijri:
////                        print("EEh el L8bata Di")
////
////                    }
////                }
////                picker.didPickDate = { date in
////                    print(date)
////                    if let format = self.viewModel.arrayOfControls[indexPath.row].format{
////                        let formatter = DateFormatter()
////                        formatter.dateFormat = format
////                        formatter.timeZone = currentTimeZoneCerqel
////                        formatter.locale = dateFormatterLocal_en_USCerqel
////                        formatter.calendar = .init(identifier: dateCalendarType)
////
////                        if isFromDate{ // Set From Date
////                            if var arr = cell.controlData.value as? [String], arr.count > 0{
////                                if let oldDate = formatter.date(from: arr[0]),
////                                   let newDate = mergeDatesCerqel(usingDateFrom: date, UsingTimeFrom: oldDate){
////                                    arr[0] = formatter.string(from: newDate)
////                                }else{
////                                    arr[0] = formatter.string(from: date)
////                                }
////                                if arr.count > 2{
////                                    let daysCount = getDatesDifferenceInDaysCerqel(fromDate: formatter.date(from: arr[0]), toDate: formatter.date(from: arr[1]))
////                                    if let count = daysCount{
////                                        arr[2] = "\(count)"
////                                    }
////                                }
////
////                                cell.controlData.value = arr
////
////                            }else{
////                                cell.controlData.value = [formatter.string(from: date), "", ""]
////                            }
////                        }else{ // Set To Date
////                            if var arr = cell.controlData.value as? [String], arr.count > 0{
////                                if arr.count > 1{
////                                    if let oldDate = formatter.date(from: arr[1]),
////                                       let newDate = mergeDatesCerqel(usingDateFrom: date, UsingTimeFrom: oldDate){
////                                        arr[1] = formatter.string(from: newDate)
////                                    }else{
////                                        arr[1] = formatter.string(from: date)
////                                    }
////
////                                    if arr.count > 2{
////                                        let daysCount = getDatesDifferenceInDaysCerqel(fromDate: formatter.date(from: arr[0]), toDate: formatter.date(from: arr[1]))
////                                        if let count = daysCount{
////                                            arr[2] = "\(count)"
////                                        }
////                                    }
////
////                                    cell.controlData.value = arr
////
////                                }else{
////                                    arr.append(formatter.string(from: date))
////                                    arr.append("")
////                                    cell.controlData.value = arr
////                                }
////
////                            }else{
////                                cell.controlData.value = ["", formatter.string(from: date), ""]
////                            }
////
////                        }
//////                        cell.controlData.value = [formatter.string(from: date)]
////                        cell.checkValidation(control: cell.controlData) { [weak self] (isValid, conditionsArr, inValidCon, notValidConditionName) in
////                            self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                            self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidConditionName
////                            self?.viewModel.arrayOfControls[indexPath.row].value = cell.controlData.value
////                            if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                                self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                            }
////                            self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                            self?.viewModel.doReload.accept([indexPath])
////                            self?.viewModel.inValidCon.accept(inValidCon)
////
////                        }
////
////                    }
////
////                }
////                var minDate: Date? = nil
////                var maxDate: Date? = nil
////                var currentDate = Date()
////
////                if let min = self.viewModel.arrayOfControls[indexPath.row].minDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMinMonth, isMonth{
////                        minDate = Date().addingMonthsCerqel(months: min)
////                    }else{
////                        minDate = Date().addingDaysCerqel(days: min)
////                    }
////                }else{
////                    minDate = nil
////                }
////                if let max = self.viewModel.arrayOfControls[indexPath.row].maxDate{
////                    if let isMonth = self.viewModel.arrayOfControls[indexPath.row].isMaxMonth, isMonth{
////                        maxDate = Date().addingMonthsCerqel(months: max)
////                    }else{
////                        maxDate = Date().addingDaysCerqel(days: max)
////                    }
////                }else{
////                    maxDate = nil
////                }
////
////                if isFromDate{
////
////                    if let sMin = self.viewModel.arrayOfControls[indexPath.row].startMin?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].startMin?.key{
////                            if key == ""{
////
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                minDate = Date().addingMonthsCerqel(months: sMin)
////                            }else{
////                                minDate = Date().addingDaysCerqel(days: sMin)
////                            }
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].startMin?.key, key == "lastOfYear"{
////                        minDate = self.getLastDayOfYear()
////                    }
////
////                    if let sMax = self.viewModel.arrayOfControls[indexPath.row].startMax?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].startMax?.key{
////                            if key == ""{
////
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                maxDate = Date().addingMonthsCerqel(months: sMax)
////                            }else{
////                                maxDate = Date().addingDaysCerqel(days: sMax)
////                            }
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].startMax?.key, key == "lastOfYear"{
////                        maxDate = self.getLastDayOfYear()
////                    }
////                    // From Date MUST BE < To date
////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////                        if arr.count > 1{
////                            let toDate = arr[1]
////                            let selectedToDate = toDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "")
////                            maxDate = selectedToDate
////                        }
////                        currentDate = arr.first?.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "") ?? Date()
////
////                    }
////
////                }else{ // To Date
////                    // To Date MUST BE > From Date
////
////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String], let fromDate = arr.first{
////                        if let selectedFromDate = fromDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
////                            minDate = selectedFromDate
////                        }
////                    }
////
////                    if let eMin = self.viewModel.arrayOfControls[indexPath.row].endMin?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].endMin?.key{
////                            if key == "startDate"{
////                                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////                                    if let fromDate = arr.first{
////                                        if let selectedFromDate = fromDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
////                                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                                minDate = selectedFromDate.addingMonthsCerqel(months: eMin)
////                                            }else{
////                                                minDate = selectedFromDate.addingDaysCerqel(days: eMin)
////                                            }
////                                        }
////                                    }else{
////                                        minDate = nil
////                                    }
////                                }else{
////                                    minDate = nil
////                                }
////                            }else{
////                                if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                    minDate = Date().addingMonthsCerqel(months: eMin)
////                                }else{
////                                    minDate = Date().addingDaysCerqel(days: eMin)
////                                }
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                minDate = Date().addingMonthsCerqel(months: eMin)
////                            }else{
////                                minDate = Date().addingDaysCerqel(days: eMin)
////                            }
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].endMin?.key, key == "lastOfYear"{
////                        minDate = self.getLastDayOfYear()
////                    }
////
////                    if let eMax = self.viewModel.arrayOfControls[indexPath.row].endMax?.value{
////                        if let key = self.viewModel.arrayOfControls[indexPath.row].endMax?.key{
////                            if key == "startDate"{
////                                if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////                                    if let fromDate = arr.first{
////                                        if let selectedFromDate = fromDate.cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
////                                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                                maxDate = selectedFromDate.addingMonthsCerqel(months: eMax)
////                                            }else{
////                                                maxDate = selectedFromDate.addingDaysCerqel(days: eMax)
////                                            }
////
////                                        }
////                                    }else{
////                                        maxDate = nil
////                                    }
////                                }else{
////                                    maxDate = nil
////                                }
////                            }else{
////                                if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                    maxDate = Date().addingMonthsCerqel(months: eMax)
////                                }else{
////                                    maxDate = Date().addingDaysCerqel(days: eMax)
////                                }
////
////                            }
////                        }else{
////                            if let isMonths = self.viewModel.arrayOfControls[indexPath.row].startMin?.isMonth, isMonths{
////                                maxDate = Date().addingMonthsCerqel(months: eMax)
////                            }else{
////                                maxDate = Date().addingDaysCerqel(days: eMax)
////                            }
////
////                        }
////                    }else if let key = self.viewModel.arrayOfControls[indexPath.row].endMax?.key, key == "lastOfYear"{
////                        maxDate = self.getLastDayOfYear()
////                    }
////
////                    //set current date
////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
////
////                        if arr.count > 1{
////                            currentDate = arr[1].cerqel_getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "") ?? Date()
////
////                        }else{
////                            currentDate = Date()
////                        }
////
////                    }
////                }
////
////                print("DATE ISSUE: MIN = \(minDate.debugDescription)")
////                print("DATE ISSUE: MAX = \(maxDate.debugDescription)")
////                print("DATE ISSUE: CURRENT = \(currentDate.debugDescription)")
////                print("DATE ISSUE: -------------------------------------")
////                picker.showDate(vc: self, sender: nil, mode: .date, minimum: minDate, maximum: maxDate, currentDate: currentDate)
////
////            }
////
////            cell.didTapTime = { isFromDate in
////                let picker = DatePickerPopup.instance()
////                picker.pickerTitle = ""
////                var dateCalendarType: Calendar.Identifier = .gregorian
////                if let type = cell.controlData.calendarType{
////                    switch type {
////                    case .Gregorian:
////                        picker.dateCalendarType = .gregorian
////                        dateCalendarType = .gregorian
////                    case .Hijri:
////                        picker.dateCalendarType = .islamicUmmAlQura
////                        dateCalendarType = .islamicUmmAlQura
////                    case .Gregorian_Hijri:
////                        print("EEh el L8bata Di")
////
////                    }
////                }
////                picker.didPickDate = { date in
////                    print(date)
////                    if let format = self.viewModel.arrayOfControls[indexPath.row].format {
////                        let formatter = DateFormatter()
////                        formatter.dateFormat = format
////                        formatter.timeZone = currentTimeZoneCerqel
////                        formatter.locale = dateFormatterLocal_en_USCerqel
////                        formatter.calendar = .init(identifier: dateCalendarType)
////
////                        if isFromDate{ // Set From Time
////                            if var arr = cell.controlData.value as? [String], arr.count > 0{
////                                if let oldDate = formatter.date(from: arr[0]),
////                                   let newDate = mergeDatesCerqel(usingDateFrom: oldDate, UsingTimeFrom: date){
////                                    arr[0] = formatter.string(from: newDate)
////                                }else{
////                                    arr[0] = formatter.string(from: date)
////                                }
////
////                                cell.controlData.value = arr
////
////                            }else{
////                                cell.controlData.value = [formatter.string(from: date)]
////                            }
////                        }else{ // Set To Time
////                            if var arr = cell.controlData.value as? [String], arr.count > 0{
////                                if arr.count > 1{
////                                    if let oldDate = formatter.date(from: arr[1]),
////                                       let newDate = mergeDatesCerqel(usingDateFrom: oldDate, UsingTimeFrom: date){
////                                        arr[1] = formatter.string(from: newDate)
////                                    }else{
////                                        arr[1] = formatter.string(from: date)
////                                    }
////                                    cell.controlData.value = arr
////
////                                }else{
////                                    arr.append(formatter.string(from: date))
////                                    cell.controlData.value = arr
////                                }
////
////                            }else{
////                                cell.controlData.value = ["", formatter.string(from: date)]
////                            }
////
////                        }
//////                        cell.controlData.value = [formatter.string(from: date)]
////                        cell.checkValidation(control: cell.controlData) { [weak self] (isValid, conditionsArr, inValidCon, notValidConditionName) in
////                            self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                            self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidConditionName
////                            self?.viewModel.arrayOfControls[indexPath.row].value = cell.controlData.value
////                            if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                                self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                            }
////                            self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                            self?.viewModel.doReload.accept([indexPath])
////                            self?.viewModel.inValidCon.accept(inValidCon)
////
////                        }
////
////                    }
////
////                }
////                var minDate: Date? = nil
////                var maxDate: Date? = nil
////                let currentDate = Date()
////
////                if let min = self.viewModel.arrayOfControls[indexPath.row].minTime{
////                    minDate = Date().addingMinutesCerqel(minutes: min)
////                }else{
////                    minDate = nil
////                }
////                if let max = self.viewModel.arrayOfControls[indexPath.row].maxTime{
////                    maxDate = Date().addingMinutesCerqel(minutes: max)
////                }else{
////                    maxDate = nil
////                }
////
//////                if isFromDate{
//////                    // From Date MUST BE < To date
//////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String]{
//////                        if arr.count > 1{
//////                            let toDate = arr[1]
//////                            let selectedToDate = toDate.getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "")
//////                            maxDate = selectedToDate
//////                        }
//////                        currentDate = arr.first?.getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "") ?? Date()
//////
//////                    }
////
//////                }else{ // To Date
//////                    // To Date MUST BE > From Date
//////
//////                    if let arr = self.viewModel.arrayOfControls[indexPath.row].value as? [String], let fromDate = arr.first{
//////                        if let selectedFromDate = fromDate.getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? ""){
//////                            minDate = selectedFromDate
//////                        }
//////                        if arr.count > 1{
//////                            currentDate = arr[1].getDateUseringFormat(format: self.viewModel.arrayOfControls[indexPath.row].format ?? "") ?? Date()
//////
//////                        }else{
//////                            currentDate = Date()
//////                        }
//////
//////                    }
//////                }
////
////                print("DATE ISSUE: MIN = \(minDate.debugDescription)")
////                print("DATE ISSUE: MAX = \(maxDate.debugDescription)")
////                print("DATE ISSUE: CURRENT = \(currentDate.debugDescription)")
////                print("DATE ISSUE: -------------------------------------")
////                picker.showDate(vc: self, sender: nil, mode: .time, minimum: minDate, maximum: maxDate, currentDate: currentDate)
////
////            }
////
////            return cell
////
////        case .table:
////
////            let cell = tableView.dequeueReusableCell(withIdentifier: tableControlTVcell.cerqel_identifier, for: indexPath) as! tableControlTVcell
////            cell.configure(control: viewModel.arrayOfControls[indexPath.row])
////
////        //            cell.didSelectOption =
////            cell.didTapAdd = { [weak self] in
////                if let ctls = self?.viewModel.arrayOfControls[indexPath.row].controls, let vcc = self{
////                    self?.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .nestedDynamicForm(parentForm: vcc, nestedControlValue: ctls, nestedControlIndex: indexPath.row)), animated: true)
////                }
////
////            }
////
////            cell.didTaptableItem = { [weak self] idx in
////                if let val = self?.viewModel.arrayOfControls[indexPath.row].value as?  [ModelNestedFormValueCerqel], val.count > idx, let vcc = self{
////                    if let nested = val[idx].val{
////                        self?.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .nestedDynamicForm(parentForm: vcc, nestedControlValue: nested, nestedControlIndex: indexPath.row, editRawIndex: idx)), animated: true)
////
////                    }
////                }
////            }
////
////            cell.didDeletetableItem = { [weak self] idx in
////                if let val = self?.viewModel.arrayOfControls[indexPath.row].value as?  [ModelNestedFormValueCerqel], val.count > idx{
////                    self?.passDataToParentForm(parentControlIndex: indexPath.row, controlData: nil, editNestedRowIndex: idx)
////                }
////            }
////
////
////
////            return  cell
////
////        case .Search:
////            let cell = tableView.dequeueReusableCell(withIdentifier: SearchControlTVcell.cerqel_identifier, for: indexPath) as! SearchControlTVcell
////            cell.configure(control: viewModel.arrayOfControls[indexPath.row], searchResultArr: viewModel.arrayOfControls[indexPath.row].searchResultValue, searchedText: viewModel.arrayOfControls[indexPath.row].searchedText)
////
////            cell.requestSearchCall = { [weak self] searchText in
////                self?.viewModel.arrayOfControls[indexPath.row].searchedText = searchText
////                self?.viewModel.performSearchFromSearchControl(searchControlIdx: indexPath.row, searchText: searchText ?? "")
////            }
////
////            cell.didChangeExpand = { [weak self] in
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.arrayOfControls[indexPath.row].isExpanded.toggle()
////                print("is Expanded: \(self?.viewModel.arrayOfControls[indexPath.row].isExpanded)")
////                self?.viewModel.doReload.accept([indexPath])
////            }
////
////            cell.didSelectOption = { [weak self] optionIdx, valids, isValid, inValidCon, notValidName in
////                if var opts = self?.viewModel.arrayOfControls[indexPath.row].searchResultValue, opts.count > 0{
////                    for i in 0 ... opts.count - 1{
////                        if i == optionIdx{
////                            opts[i].isSelected = true
////                        }else{
////                            opts[i].isSelected = false
////                        }
////                    }
////                    self?.viewModel.arrayOfControls[indexPath.row].value = [opts[optionIdx]]
////
////                    if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, idxs.count > 0, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                        self?.viewModel.deleteDependeciesValues(parentIdx: myIdx, idxsToCheck: idxs)
////                    }
////
////                    if let idxs = self?.viewModel.arrayOfControls[indexPath.row].searchChildrenIndexes, idxs.count > 0{
////                        self?.viewModel.setSearchResultValueToChildrenControls(searchValueResult: opts[optionIdx], childIndex: idxs)
////                    }
////
////
////                    self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                    self?.viewModel.arrayOfControls[indexPath.row].searchResultValue = opts
////                    self?.viewModel.arrayOfControls[indexPath.row].validations = valids
////                    self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                    cell.arrayOfOptions = opts
////                    if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, idxs.count > 0, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                        self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////                    }
////                }
////                self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                self?.viewModel.arrayOfControls[indexPath.row].isExpanded.toggle()
////                self?.viewModel.doReload.accept([indexPath])
////                self?.viewModel.inValidCon.accept(inValidCon)
////                cell.optionsTV.reloadData()
////
////                self?.viewModel.manageCascadingRelation(parentIdx: indexPath.row)
////            }
////            return cell
////
////
////
////
////        case .customComponent:
////            if let ctlName = viewModel.arrayOfControls[indexPath.row].name, ctlName == "EmployeeInfo"{
////
////                let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeInfoControlTVcell.cerqel_identifier, for: indexPath) as! EmployeeInfoControlTVcell
////                cell.configure(control: self.viewModel.arrayOfControls[indexPath.row])
////
////
////                cell.didChangeValue = { [weak self] arr, isValid, inValidCon, notValidName in
////
////                    self?.viewModel.arrayOfControls[indexPath.row].isValid = isValid
////                    self?.viewModel.arrayOfControls[indexPath.row].notValidType = notValidName
////                    self?.viewModel.arrayOfControls[indexPath.row].value = arr
////                    if let idxs = self?.viewModel.arrayOfControls[indexPath.row].dependencies, let myIdx = self?.viewModel.arrayOfControls[indexPath.row].index{
////                        self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////
////                    }
////                    self?.viewModel.arrayOfReloadControlStatus[indexPath.row] = true
////                    self?.viewModel.doReload.accept([indexPath])
////                    self?.viewModel.inValidCon.accept(inValidCon)
////                    DispatchQueue.main.async {
////                        self?.controlsTV.scrollToRow(at: indexPath, at: .bottom, animated: true)
////                    }
////
////                }
////
////
////                return cell
////            }
////            return UITableViewCell()
////        default:
////            return UITableViewCell()
////        }
////
////    }
////}
////
////
////extension FormBuilderVC: UIDocumentMenuDelegate, UIDocumentPickerDelegate{
////    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
////        self.present(documentPicker, animated: true, completion: nil)
////
////    }
////
////
////    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
////        print("url", url)
////        var fileSize : Double = 0
////        do {
////            //return [FileAttributeKey : Any]
////            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
////            fileSize = attr[FileAttributeKey.size] as! Double
////
////        } catch {
////            print("Error: \(error)")
////        }
////
////        if ((fileSize) / 1024 / 1024) > 5{
////            self.viewModel.errorsSubject.onNext(BaseError.other(title: "Can't upload Media Size is > 5 MB".localized))
////            return
////
////        }
////        viewModel.uploadMedia(mediaImg: nil, fileUrl: url)
////
//////        self.filePickedBlock?(url)
////    }
////
////    //    Method to handle cancel action.
////    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//////        currentVC?.dismiss(animated: true, completion: nil)
////    }
////
////    func getLastDayOfYear() -> Date {
////        var dt = Date()
////        let year = Calendar.current.component(.year, from: Date())
////        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
////            let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear)
////            dt = lastOfYear ?? Date()
////        }
////        return dt
////    }
////
////}
////
////
////extension FormBuilderVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        self.dismiss(animated: true) {
////            if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
////                print("WE HAVE IMAGE !!!! 🚀")
////                let imgData = NSData(data: photo.jpegData(compressionQuality: 0.5)!)
////                let imageSize: Int = imgData.count / 1024 / 1024
////                print("actual size of image in MB: \(imageSize)")
////
////                if imageSize > 5{
////                    self.viewModel.errorsSubject.onNext(BaseError.other(title: "Can't upload Media Size is > 5 MB".localized))
////                    return
////                }
////                self.viewModel.uploadMedia(mediaImg: photo, fileUrl: nil)
////
////            }
////
////        }
////    }
////}
////
////
////extension FormBuilderVC: NestedFormDelegate{
////    func passDataToParentForm(parentControlIndex: Int?, controlData: [ModelControlCerqel]?, editNestedRowIndex: Int?) {
////        guard let parentControlIndex = parentControlIndex else{
////            return
////        }
////        if var val = self.viewModel.arrayOfControls[parentControlIndex].value as? [ModelNestedFormValueCerqel], val.count > 0{
////            if let editIdx = editNestedRowIndex, editIdx < val.count{
////                if let _  = controlData{
////                    val[editIdx] = ModelNestedFormValueCerqel(val: controlData)
////                }else{
////                    val.remove(at: editIdx)
////                }
////            }else{
////                val.append(ModelNestedFormValueCerqel(val: controlData))
////            }
////            self.viewModel.arrayOfControls[parentControlIndex].value = val
////
////        }else{
////            self.viewModel.arrayOfControls[parentControlIndex].value = [ModelNestedFormValueCerqel(val: controlData)]
////        }
////
////        var ctl = self.viewModel.arrayOfControls[parentControlIndex]
////        ctl.value = [ModelNestedFormValueCerqel(val: controlData)]
////
////
////        self.navigationController?.popToViewController(self, animated: true)
////
////
////        self.viewModel.checkTableControlValidation(control: ctl) { [weak self] isValid, conditionsArr, inValidCon, notValidConditionName in
////
////            self?.viewModel.arrayOfControls[parentControlIndex].isValid = isValid
////            self?.viewModel.arrayOfControls[parentControlIndex].validations = conditionsArr
////            self?.viewModel.arrayOfControls[parentControlIndex].notValidType = notValidConditionName
////
////            if let idxs = self?.viewModel.arrayOfControls[parentControlIndex].dependencies, idxs.count > 0, let myIdx = self?.viewModel.arrayOfControls[parentControlIndex].index{
////                self?.viewModel.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
////            }
////
////            self?.viewModel.arrayOfReloadControlStatus[parentControlIndex] = true
//////            self?.viewModel.arrayOfControls[parentControlIndex].isExpanded.toggle()
////            self?.viewModel.doReload.accept([IndexPath(row: parentControlIndex, section: 0)])
////            self?.viewModel.inValidCon.accept(inValidCon)
////
////        }
////    }
//
//}
