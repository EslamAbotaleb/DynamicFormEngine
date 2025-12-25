//
//  FormBuilderViewModel.swift
//
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 All rights reserved.
//

import Foundation
import RxCocoa
public import RxSwift
import Expression
import UIKit

public protocol NestedFormDelegate {
    func passDataToParentForm(parentControlIndex: Int?, controlData: [ModelControl]?, editNestedRowIndex: Int?)
}

public class FormBuilderViewModel: BaseViewModel {
    
    private let service: cerqel_NetworkService
    private let disposeBag = DisposeBag()

    
    public var doReload: BehaviorRelay<[IndexPath]?> = BehaviorRelay(value: nil)
    public var arrayOfControls: [ModelControl] = []
    public var arrayOfTypes: [ControlType] = []
    public var arrayOfReloadControlStatus: [Bool] = []
    
    public var notValidList: BehaviorRelay<[Int]?> = BehaviorRelay(value: nil)
    public var inValidCon: BehaviorRelay<Validations?> = BehaviorRelay(value: nil)
    public var formData: BehaviorRelay<ModelForm?> = BehaviorRelay(value: nil)
    public var subservicesResponse: BehaviorRelay<ModelSubServiceData?> = BehaviorRelay(value: nil)
    public var serviceSubmittedResponse: BehaviorRelay<String?> = BehaviorRelay(value: nil)

    public var selectedMediaUploaderIdx: Int?
    public var categoryTitle: String?

    public var selectedServiceId: String?{
        didSet{
        }
    }
    public var hasSubService: Bool?
    public var subParentName: String?
    public var arrayOfSubServices: [ModelServicesCerqel]?
    
    public var isNestedForm: Bool = false
    public var nestedFormControlData: [ModelControl]? = nil
    public var nestedFormControlIndex: Int? = nil
    public var nestedDataDelegate: NestedFormDelegate? = nil
    public var editNestedRowIndex: Int? = nil

 
    public init(_ service: cerqel_NetworkService) {
        self.service = service
        super.init()
    }

    public func fetchService(id: String) {
//        guard let id = selectedServiceId else{
//            return
//        }
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObjectDynamicForm<ModelForm>(action: cerqel_BasicActionDynamicForm.fetchService(Id: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            if let item = response.item?.data{
                self?.formData.accept(item)
                self?.createFormItems(controls: item.requestForm?.controls ?? [])
                self?.selectedServiceId = id
            }
        }, onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }
    
    public func fetchSubServices(){
        guard let id = selectedServiceId else {
            return
        }
        self.loadingSubject.onNext(.show)
        self.service.load(cerqel_CodableResponseObjectDynamicForm<ModelSubServiceData>(action: cerqel_BasicActionDynamicForm.fetchSubServicesByParent(parentId: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.loadingSubject.onNext(.hide)
            //sorry for this bad handling but this just to show error if there is a sub parent services but don't have children services so the request is succes but they need to show error message
            if let resStatus = response.success , !resStatus{
                if let err = response.error{
                    self?.errorsSubject.onNext(err)
                }
            }
            if let item = response.item?.data{
                self?.subservicesResponse.accept(item)
            }
        }, onError: { (error) in
            self.errorsSubject.onNext(error)
            self.loadingSubject.onNext(.hide)
            
        }).disposed(by: self.disposeBag)
    }
    
    func createFormItems(controls: [ModelControl]){
        var dataArr: [ModelControl] = []
        var typeArr: [ControlType] = []
        var reload: [Bool] = []
        
        for var item in controls{
            if let type = item.type{
                typeArr.append(type)
                if let arr = item.validations, arr.count > 0{
                    if (arr.firstIndex(where: {$0.name == .required || $0.name == .valueRequired || $0.name == .dateRangeFrom_required || $0.name == .dateRangeTo_required}) != nil){
                        item.isValid = false
                    }else{
                        item.isValid = true
                    }
                }
                
//                if type == .customComponent, item.name == Service_Name_EmployeeInfo{
//                    if let _ = item.validations{
//                        item.validations?.append(Validations(name: .checkVisitorInfo, value: "", message: "Visitor info is Not Valid".localized, isValid: false))
//
//                    }else{
//                        item.validations = [
//                            Validations(name: .checkVisitorInfo, value: "", message: "Visitor info is Not Valid".localized, isValid: false)
//                        ]
//
//                    }
//                    item.readOnly = false
//                    item.isValid = false
//
//                }
//                item.dateFormat = "dd/MM/yyyy"
//                item.format = "dd/MM/yyyy hh:mm a"
//                if type == .customComponent, let n = item.name, n == "EmployeeInfo"{
//                    item.validations = [Validations(name: .required, value: "", message: "test", isValid: false)]
//                }
                dataArr.append(item)
                reload.append(true)
                
            }
        }
        
        self.arrayOfTypes = typeArr
        self.arrayOfReloadControlStatus = reload
        self.arrayOfControls = dataArr
        
        for item in self.arrayOfControls{
            if let myIdx = item.index, let idxs = item.dependencies{
                if idxs.count > 0{
                    doReload.accept(nil)
                    self.ManageFieldValidations(parentIdx: myIdx, idxsToCheck: idxs)
                }else{
                    doReload.accept(nil)
                }
            }
        }
        
    }
    
    func deleteDependeciesValues(parentIdx: Int, idxsToCheck: [String]) {
        
        var intIdxs: [Int] = []
        for item in idxsToCheck {
            
            if let val = Int(item){
                if arrayOfControls[val - 1].conditionalView?.conditions?.count ?? 0 > 0 {
                    for i in 0...(arrayOfControls[val - 1].conditionalView?.conditions!.count ?? 0) - 1 {
                        arrayOfControls[val - 1].conditionalView?.conditions?[i].validityStatus = false
                    }
                }
            }
        }
    }
    
    
    internal func ManageFieldValidations(parentIdx: Int, idxsToCheck: [String]){
        var intIdxs: [Int] = []
        for item in idxsToCheck{
            
            if let val = Int(item){
                intIdxs.append(val)
            }
        }

        for idx in intIdxs{
            var validConditionsCOunt = 0
            if var condView = arrayOfControls[idx - 1].conditionalView, var conditions = condView.conditions{
                if conditions.count > 0{
                    validConditionsCOunt = 0
                    for i in 0 ... conditions.count - 1{
                        if let dependInx = conditions[i].parentFieldIndex , dependInx == parentIdx{
                            for validation in arrayOfControls[parentIdx - 1 ].validations ?? []{
                                if let conValName = conditions[i].validationName, let valName = validation.name, conValName == valName{
                                    conditions[i].validityStatus = validation.isValid
                                }
                                else if let conValName = conditions[i].validationName, conValName == .valueRequired{
                                    if let selectedOption = arrayOfControls[parentIdx - 1].value as? [Options]{
                                        if conditions[i].value == selectedOption.first?.key{
                                            conditions[i].validityStatus = true
                                        }else{
                                            // to handel hidding conitional view of the parent conitional views
                                            //to be refactored
                                            //                                            arrayOfControls[idx - 1].isValid = false

                                            //this modification made to solve optional component without value depending on parent conditional view
                                            if let arr = arrayOfControls[idx - 1].validations, arr.count > 0{
                                                if (arr.firstIndex(where: {$0.name == .required || $0.name == .valueRequired || $0.name == .dateRangeFrom_required || $0.name == .dateRangeTo_required}) != nil){
                                                    arrayOfControls[idx - 1].isValid = false
                                                }else{
                                                    arrayOfControls[idx - 1].isValid = true
                                                }
                                            }
                                            if let _ = arrayOfControls[idx - 1].value as? [String]{
//                                                if arrayOfControls[idx - 1].type != .paragraph{
//                                                    arrayOfControls[idx - 1].value = []
//                                                }
                                            }else if let _ = arrayOfControls[idx - 1].value as? [Bool]{
                                                arrayOfControls[idx - 1].value = [false]
                                            }else{
                                                arrayOfControls[idx - 1].value = nil
                                            }
                                            
                                            for var element in arrayOfControls[idx - 1].conditionalView?.conditions ?? []{
                                                element.validityStatus = false
                                                if let parentDeps = arrayOfControls[element.parentFieldIndex! - 1].dependencies{
                                                    for idx in parentDeps{
                                                        if let item = Int(idx){
                                                            let conV = arrayOfControls[item - 1 ].conditionalView!.conditions
                                                            var nConV = conV
                                                            nConV?.removeAll()
                                                            for var e in conV ?? []
                                                            {
                                                                e.validityStatus = false
                                                                nConV?.append(e)
                                                            }
                                                        }
                                                    }
                                                }
                                                conditions[i].validityStatus = false
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        // condition made for infInicator (to be refactord)
                        for  element in arrayOfControls[idx - 1].conditionalView?.conditions ?? []{
                            if let conValName = element.validationName, conValName == .required{
                                if let parentVal = arrayOfControls[parentIdx - 1].value as? [Bool]{
                                    if parentVal.count > 0{
                                        if parentVal[0]{
                                            conditions[i].validityStatus = true
                                        }else{
                                            conditions[i].validityStatus = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                condView.conditions = conditions
                arrayOfControls[idx - 1].conditionalView = condView
                
                //Check Availability of target Field  to perform conditional view action or not
                for cond in conditions{
                    if let state = cond.validityStatus{
                        if state{
                            validConditionsCOunt += 1
                        }else{
                            
                        }
                    }
                }
                
            }
            
            if let min = arrayOfControls[idx - 1].conditionalView?.minimumAcceptableConditionsNumber , min > validConditionsCOunt {
                arrayOfControls[idx - 1].isHidden = true
            }else{
                arrayOfControls[idx - 1].isHidden = false
            }
//            arrayOfControls[idx - 1].isHidden = !allConditionsIsValid
//            arrayOfControls[idx - 1].isValid = allConditionsIsValid
        }
        var idxsPaths: [IndexPath] = []
        for idx in intIdxs{
            if arrayOfControls[idx - 1].isHidden != arrayOfReloadControlStatus[idx - 1]{
                idxsPaths.append(IndexPath(row: idx - 1, section: 0))
            }
        }
        
        self.doReload.accept(idxsPaths)
        
        if arrayOfControls.count > 0{
            for i in 0 ... arrayOfControls.count - 1 {
                arrayOfReloadControlStatus[i] = arrayOfControls[i].isHidden
            }
        }
    }
    
    internal func ManageRquationRelations(resultId: Int){
        let resultIdx = resultId - 1
        if self.arrayOfControls.count > resultIdx, let equation = self.arrayOfControls[resultIdx].relationEquation, let params = equation.paramsIndexes, params.count > 0{
            var paramValuesArray: [String] = []
            for paramIdx in params{
                if let objCtl = self.arrayOfControls.firstIndex(where: {$0.index == paramIdx}){
                    if  let val = arrayOfControls[objCtl].value as? [String], let str = val.first{
                        paramValuesArray.append(str)
                    }
                    
                }

                
            }
            
            if let paramCount = equation.totalNumberOfAffectedControls, paramCount == paramValuesArray.count, paramValuesArray.count > 0{
                if var equStr = equation.equation{
                    for i in 0 ... paramValuesArray.count - 1{
                        if equStr.contains("{\(params[i])}"){
                            equStr = equStr.replacingOccurrences(of: "{\(params[i])}", with: "\(paramValuesArray[i])")
                        }

                    }
                    let expression = Expression(equStr)
                    if let result = try? expression.evaluate(){
                        
                        self.arrayOfControls[resultIdx].value = ["\(result)"]
                        self.arrayOfReloadControlStatus[resultIdx] = true
                        self.doReload.accept([IndexPath(row: resultIdx, section: 0)])

                    }

                }
                
            }
        }
    }
    
    func submit(){
        if arrayOfControls.count > 0{
            var notValidArr: [Int] = []
            for i in 0 ... arrayOfControls.count - 1{
                if !arrayOfControls[i].isValid && !arrayOfControls[i].isHidden{
                    if let read =  arrayOfControls[i].readOnly, !read{
                        notValidArr.append(i)
                    }
                }
            }
            if notValidArr.count > 0{
                self.notValidList.accept(notValidArr)
                return
            }
            
            if isNestedForm{
//                tableControlValue = arrayOfControls
                nestedDataDelegate?.passDataToParentForm(parentControlIndex: self.nestedFormControlIndex, controlData: arrayOfControls, editNestedRowIndex: editNestedRowIndex)
                return
            }
            
            // Create JSON for submission
            var payload = ModelSubmitForm()
            payload.formCode = self.formData.value?.requestForm?.formCode
            payload.formVersion = self.formData.value?.formVersion
//            payload.onBehalf = true
            payload.createdForUsername = AuthManager.shared.profile.value?.name
            var payloadArr: [[String: Any]] = []
            for ctl in arrayOfControls{
                if ctl.isHidden{
                    continue
                }
                if ctl.value != nil && (ctl.value?.count ?? 0) > 0{
//                    payloadArr.append(createPayloadValue(ctl: ctl))

                }
            }

//            payload.payload = payloadArr
            
            var payloadJSON = payload.toJSON()
            payloadJSON["payload"] = payloadArr
            
            // Wohooo We Have a full Payload 💃🏻🔥
            // Let's make a call
            
            guard let id = selectedServiceId else{
                self.errorsSubject.onNext(BaseError.other(title: "No Service ID".localized))
                return
            }
            self.loadingSubject.onNext(.show)
            self.service.load(cerqel_CodableResponseObjectDynamicForm<String>(action: cerqel_BasicActionDynamicForm.submitService(Id: id, payload: payloadJSON))).subscribe(onNext: {
                [weak self] (response) in
                self?.loadingSubject.onNext(.hide)
                if let item = response.item?.data{
                    self?.serviceSubmittedResponse.accept(item)
                }
            }, onError: { (error) in
                self.errorsSubject.onNext(error)
                self.loadingSubject.onNext(.hide)
                
            }).disposed(by: self.disposeBag)
            


        }
    }
    
//    private func createPayloadValue(ctl: Field) -> [String: Any]{
//        var pObj = SubmitFormPayload(control: ctl).toJSON()
//        if pObj["value"] == nil{
//            if var val = ctl.value as? [String]{
//                // to handle DateRangePicker optional end date in sending it's value and send it with ""
//                if ctl.type?.rawValue == "DateRangePicker"{
//                    if val.count == 1{
//                        val.append("")
//                    }
//                }
//                pObj["value"] = val
//            }else if let val = ctl.value as? [Bool]{
//                pObj["value"] = val
//            }else if let arr = ctl.value as? [ModelUploadedMedia]{
//                var newArr: [ModelUploadedMediaFormPayload] = []
//                for item in arr{
//                    newArr.append(ModelUploadedMediaFormPayload.init(item: item))
//                }
//                pObj["value"] = newArr.toJSON()
//
//            }else if let arr = ctl.value as? [VisitorInfo]{
//                pObj["value"] = arr.toJSON()
//            }else if let arr = ctl.value as? [ModelNestedFormValue]{
//                var allRowsPayloadArr: [[[String: Any]]] = []
//
//                for item in arr{
//                    var oneRawPayloadArr: [[String: Any]] = []
////                    for ctlInRow in item.val ?? []{
////                        if ctlInRow.isHidden{
////                            continue
////                        }
////                        if ctlInRow.value != nil && (ctlInRow.value?.count ?? 0) > 0{
////                            oneRawPayloadArr.append(createPayloadValue(ctl: ctlInRow))
////
////                        }
////                    }
//
//                    allRowsPayloadArr.append(oneRawPayloadArr)
//                }
//                pObj["SubValues"] = allRowsPayloadArr
//            }
//        }
//
//        return pObj
//    }
    
    
    func uploadMedia(mediaImg: UIImage?, fileUrl: URL?) {
        self.loadingSubject.onNext(.show)

        cerqel_NormalAPIcallDynamicForm().uploadFile(action: .uploadFile(isPublic: false, serviceType: 0), photo: mediaImg, fileUrl: fileUrl, onCompletion: { (result) in
//            self.loadingSubject.onNext(.hide)
            if let res = result?["result"] as? [[String: Any]], let fir = res.first, let media = ModelUploadedMedia(JSON: fir), let id = media.id{
                if let idx = self.selectedMediaUploaderIdx{
                    if let val = self.arrayOfControls[idx].value, var arr = val as? [ModelUploadedMedia]{
                        arr.append(media)
                        self.arrayOfControls[idx].value = arr
                    }else{
                        self.arrayOfControls[idx].value = [media]
                    }
                        // edit by omar
                    self.checkValidation(control: self.arrayOfControls[idx]) { (isValid, conditionsArr, inValidCon, notValidConditionName) in

                        self.arrayOfControls[idx].isValid = isValid
                    }
                    self.doReload.accept([IndexPath(row: idx, section: 0)])
                }
            }
            self.loadingSubject.onNext(.hide)


        }, onError:  { (error) in
            self.loadingSubject.onNext(.hide)

            self.errorsSubject.onNext(BaseError.other(title: error?.localizedDescription ?? ""))
        })
    }
    
    // check validation for attachments
    func checkValidation(control: ModelControl, completion: @escaping(Bool, [Validations], Validations, ValidationName?)->Void){
        var isValid = false
        var inValidType: ValidationName?
        var inValidCondition = Validations()
        if var conds = control.validations, conds.count > 0{
            for i in 0 ... conds.count - 1{
                switch conds[i].name{
                case .required:
                    if let value = control.value{
                        if let arra = value as? [ModelUploadedMedia], let f = arra.first {
                            if f.name == nil {
                                conds[i].isValid = false
                                inValidType = .required
                            } else {
                                conds[i].isValid = true
                            }
                        } else {
                            conds[i].isValid = false
                            inValidType = .required
                        }
                    }
                case .none:
                    print("")
                    isValid = true
                case .some(.valueRequired):
                    print("")
                case .some(.pattern):
                    print("")
                case .some(.minlength):
                    print("")
                case .some(.maxlength):
                    print("")
                case .some(.min):
                    print("")
                case .some(.max):
                    print("")
                case .some(.dateRangeFrom_required):
                    print("")
                case .some(.dateRangeTo_required):
                    print("")
                case .some(.dateFrom_required):
                    print("")
                case .some(.dateTo_required):
                    print("")
                case .some(.timeFrom_required):
                    print("")
                case .some(.timeTo_required):
                    print("")
                case .some(.minRows):
                    print("")
                case .some(.maxRows):
                    print("")
                }
            }
        
        for item in conds{
            if item.isValid{
                isValid = true
            }else{
                isValid = false
                inValidCondition = item
                break
            }
        }

            completion(isValid, conds, inValidCondition, inValidType)
        }else{
            completion(true, [], Validations(), nil)
        }
        
    }
    
    func manageCascadingRelation(parentIdx: Int){
        if let cascIdxs = self.arrayOfControls[parentIdx].cascadingChildrenIndexes, cascIdxs.count > 0{
            var selectedParentValue: Options? = nil
            if let arr = self.arrayOfControls[parentIdx].value as? [Options], arr.count > 0{
                selectedParentValue = arr[0]
            }
            RemoveCascadingChildrenOldValues(parentIndex: parentIdx)

            if selectedParentValue == nil { return }
            for i in 0 ... cascIdxs.count - 1{
                var optionsUrl = self.arrayOfControls[cascIdxs[i] - 1].dataSourceUrl ?? ""
                if self.arrayOfControls.count >= cascIdxs[i]{
                    optionsUrl = optionsUrl.replacingOccurrences(of: "{\(i)}", with: selectedParentValue?.key ?? "")
                    fetchCascadingOptionsList(url: optionsUrl, controlIdx: cascIdxs[i] - 1)
                }
                self.arrayOfControls[cascIdxs[i] - 1].value = []
                self.arrayOfControls[cascIdxs[i] - 1].options = []
                
            }
        }

    }
    
    func fetchCascadingOptionsList(url: String, controlIdx: Int){
        self.loadingSubject.onNext(.show)
//        self.service.load(cerqel_CodableResponseObject<Options>(action: cerqel_BasicActionDynamicForm.fetchCascadingOptions(endPoint: url))).subscribe(onNext: {
//            [weak self] (response) in
//            self?.loadingSubject.onNext(.hide)
//            if let opts = response.item?.arrData{
//                self?.arrayOfControls[controlIdx].options = opts
//            }
//        }, onError: { (error) in
//            self.errorsSubject.onNext(error)
//            self.loadingSubject.onNext(.hide)
//
//        }).disposed(by: self.disposeBag)

        
    }
    
    func RemoveCascadingChildrenOldValues(parentIndex: Int){
        if let idxs = self.arrayOfControls[parentIndex].cascadingChildrenIndexes, idxs.count > 0{
            for item in idxs{
                if self.arrayOfControls.count > item{
                    self.arrayOfControls[item - 1].value?.removeAll()
                    self.arrayOfControls[item - 1].options?.removeAll()
                    self.doReload.accept([IndexPath(row: item - 1, section: 0)])

                    if let arr = self.arrayOfControls[item - 1].cascadingChildrenIndexes, arr.count > 0{
                        RemoveCascadingChildrenOldValues(parentIndex: item - 1)
                    }
                }
            }
        }
    }
    
    
    func checkTableControlValidation(control: ModelControl, completion: @escaping(Bool, [Validations], Validations, ValidationName?)->Void){
        var isValid = false
        var inValidType: ValidationName?
        var inValidCondition = Validations()
        if var conds = control.validations, conds.count > 0{
            for i in 0 ... conds.count - 1{
                switch conds[i].name{
                case .required:
                    if let value = control.value as? [ModelNestedFormValue], value.count > 0{
                        conds[i].isValid = true


                    }else{
                        conds[i].isValid = false
                        inValidType = .required
                    }
                    
                    
                case .maxRows:
                    if let value = control.value as? [ModelNestedFormValue], let maxStr = conds[i].value, let max =  Int(maxStr), value.count <= max{
                        conds[i].isValid = true

                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .maxRows
                        }

                    }

                case .minRows:
                    if let value = control.value as? [ModelNestedFormValue], let minStr = conds[i].value, let min =  Int(minStr), value.count >= min{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .minRows
                        }
                    }

//                case .min:
//                    if let valueStr = control.value as? String, let value = Int(valueStr), let min = conds[i].value as? Int, value >= min {
//                        conds[i].isValid = true
//                    }else{
//                        conds[i].isValid = false
//                        if inValidType == nil{
//                            inValidType = .min
//                        }
//
//                    }

//                case .max:
//                    if let valueStr = control.value as? String, let value = Int(valueStr), let min = conds[i].value as? Int, value <= min {
//                        conds[i].isValid = true
//                    }else{
//                        conds[i].isValid = false
//                        if inValidType == nil{
//                            inValidType = .max
//                        }
//
//                    }




                default:
                    print("\(conds[i].name) IS NOT HANDLED IN Table  CONTROL VALIDATION IN VIEW MODEL !!!!!!! 🔥")
                }
            }
            
            for item in conds{
                if item.isValid{
                    isValid = true
                }else{
                    isValid = false
                    inValidCondition = item
                    break
                }
            }

            completion(isValid, conds, inValidCondition, inValidType)
        }else{
            completion(true, [], Validations(), nil)
        }
    }
    
    func performSearchFromSearchControl(searchControlIdx: Int, searchText: String){
        guard self.arrayOfControls.count > searchControlIdx, !searchText.isEmpty else{
            return
        }
        let ctl = self.arrayOfControls[searchControlIdx]
        
        var baseURL = ""
        if ctl.dataSourceBaseUrl?.lowercased() == "UserManager".lowercased(){
            baseURL = (cerqel_Environment.Api_Base_URL + UrlBaseEndpoints.userManager.rawValue).replacingOccurrences(of: "api/", with: "")
        }
        let url = ctl.dataSourceId ?? ""
        
        if !baseURL.isEmpty, !url.isEmpty{
            let fullURL = baseURL + url + searchText
            self.loadingSubject.onNext(.show)
            cerqel_NormalAPIcallDynamicForm.sendRequest(action: cerqel_BasicActionDynamicForm.performSearchFromSearchControlInFormBuilder(url: fullURL)) { [weak self] responseJSON in
                self?.loadingSubject.onNext(.hide)

                if let result = responseJSON?["result"] as? [String: Any], let data = result["data"] as? [[String : Any]]{
                    if ctl.searchMappingModel?.lowercased() == SearchControlResultTypes.EmployeeModel.rawValue.lowercased(){
                        let arr = SearchControlResult_EmployeeModel.DTO(data: data)
                        self?.arrayOfControls[searchControlIdx].searchResultValue = arr
                        self?.doReload.accept([IndexPath.init(row: searchControlIdx, section: 0)])
                        
                    }
                    
                }
            }

        }
        
        
        
    }
    
    func setSearchResultValueToChildrenControls(searchValueResult: SearchControlResult, childIndex: [Int]){
        var dicValue: [String: Any] = [:]
        var reload_idxs: [IndexPath] = []
        if let model = searchValueResult as? SearchControlResult_EmployeeModel{
            dicValue = model.toJSON()
        }
        for idx in childIndex{
            if let mappedValue = self.arrayOfControls[idx - 1].mappedValue, let val = dicValue[mappedValue] as? String{
                self.arrayOfControls[idx - 1].value = [val]
                reload_idxs.append(IndexPath(row: idx - 1, section: 0))
            }
        }
        self.doReload.accept(reload_idxs)
    }
    
}
