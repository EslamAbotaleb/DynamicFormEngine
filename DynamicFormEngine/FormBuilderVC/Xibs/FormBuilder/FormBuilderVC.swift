//
//  FormBuilderVC.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
import MobileCoreServices
import DropDown


class FormBuilderVC: BaseWireFrame<FormBuilderViewModel> {

//    @IBOutlet weak var bgTopView: UIView!
//    @IBOutlet weak var bgBottomView: UIView!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var errorMsgLbl: UILabel!
//
//    @IBOutlet weak var controlsTV: UITableView!
//
//    @IBOutlet weak var formStackView: UIStackView!
//    @IBOutlet weak var successStackView: UIStackView!
//
//    @IBOutlet weak var successInfoLbl: UILabel!
//
//    @IBOutlet weak var subServicesTitleLbl: UILabel!
//    @IBOutlet weak var subServicesValueTF: UITextField!
//    @IBOutlet weak var subServicesBgView: UIView!
//
//    let dropDown = DropDown()
//
//    override func configure(with viewModel: FormBuilderViewModel) {
//        viewModel.doReload.subscribe(onNext: { [unowned self]  (list) in
//            if let arr = list{
////                self.viewModel.resetReloadStatus()
//                DispatchQueue.main.async {
//                    self.controlsTV.reloadRows(at: arr, with: .none)
//                }
//            }else{
//                self.controlsTV.reloadData()
//            }
//        }).disposed(by: self.disposeBag)
//
//        viewModel.formData.subscribe(onNext: { [unowned self]  (item) in
//            if let item = item{
//                if let subParentName = viewModel.subParentName{
//                    self.titleLbl.text = subParentName
//                }else{
//                    self.titleLbl.text = item.serviceName
//                }
//
//            }
//        }).disposed(by: self.disposeBag)
//
////        viewModel.formData.subscribe(onNext: { [unowned self]  (item) in
////            if let item = item{
////                if let subParentName = viewModel.subParentName{
////                    self.titleLbl.text = subParentName
////                }else{
////                    self.titleLbl.text = item.serviceName
////                }
////            }
////        }).disposed(by: self.disposeBag)
//
//        viewModel.serviceSubmittedResponse.subscribe(onNext: { [unowned self]  (item) in
//            if let item = item{
//                self.showSuccessResponse(serviceId: item)
//            }
//        }).disposed(by: self.disposeBag)
//        viewModel.notValidList.subscribe(onNext: { [unowned self]  (list) in
//            if let arr = list{
//                if let idx = arr.first{
//                    if let name = viewModel.arrayOfControls[idx].notValidType{
//                        for item in viewModel.arrayOfControls[idx].validations ?? []{
//                            if item.name == name{
//                                self.errorMsgLbl.text = item.message
//                                self.viewModel.arrayOfControls[idx].notValidType = name
//                                self.viewModel.arrayOfReloadControlStatus[idx] = true
//                                self.viewModel.doReload.accept([IndexPath(row: idx, section: 0)])
//
//                            }
//                        }
//                    }else{
//                        self.errorMsgLbl.text = viewModel.arrayOfControls[idx].validations?.first?.message
//                        self.viewModel.arrayOfControls[idx].notValidType = viewModel.arrayOfControls[idx].validations?.first?.name
//                        self.viewModel.arrayOfReloadControlStatus[idx] = true
//                        self.viewModel.doReload.accept([IndexPath(row: idx, section: 0)])
//
//                    }
//                }
//
//            }
//        }).disposed(by: self.disposeBag)
//
//        viewModel.inValidCon.subscribe(onNext: { [unowned self]  (item) in
//            if let con = item{
////                print("gooooooda \(con.message)")
//                self.errorMsgLbl.text = con.message
//            }
//        }).disposed(by: self.disposeBag)
//
//        viewModel.subservicesResponse.subscribe(onNext: { [unowned self]  (arr) in
//            if let sub = arr?.subServices{
//                print("WE HAVEEE SUB SERVICESS YABO 3MOOO 🚀")
//                self.viewModel.arrayOfSubServices = sub
//                if sub.count > 0{
////                    self.subServicesValueTF.text = sub[0].name
////                    self.viewModel.fetchService(id: sub[0].id ?? "")
//                    self.selectSubService(serv: sub[0], parentInfo: arr?.parentService)
//
//                }
//
//            }
//        }).disposed(by: self.disposeBag)
//
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        registerCells()
//        if let subServicesFlag = viewModel.hasSubService, subServicesFlag{
//            viewModel.fetchSubServices()
//            subServicesBgView.isHidden = false
//        }else if viewModel.isNestedForm{
//            subServicesBgView.isHidden = true
//            self.viewModel.createFormItems(controls: viewModel.nestedFormControlData ?? [])
//
//        } else {
//            viewModel.fetchService(id: viewModel.selectedServiceId ?? "")
//            subServicesBgView.isHidden = true
//        }
//        self.navigationItem.title = viewModel.categoryTitle
//
//        subServicesValueTF.tintColor = .darkGreenBlue
//        subServicesValueTF.cerqel_addIconView(img: UIImage(named: "down-arrow2")!, isRight: true)
//        subServicesValueTF.cerqel_addEmptyView(isLeft: true, width: 20)
//
//
//    }
//
//
//    @IBAction func submitBtnTapped(){
//        viewModel.submit()
//    }
//
//    @IBAction func cancelBtnTapped(){
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func viewmyRequestsbtnTapped(){
//        if let v = self.navigationController{
//        }
//    }
//
//    @IBAction func didTapSubserviceDropDown(){
//        var arr: [String] = []
//        for item in viewModel.arrayOfSubServices ?? []{
//            arr.append(item.displayName ?? "")
//        }
//        self.dropDown.dataSource = arr
//        self.dropDown.anchorView = self.subServicesValueTF
//        let appearance = DropDown.appearance()
//        appearance.cellHeight = 45
//        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
//        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
//        appearance.animationduration = 0.25
//        appearance.textColor = .blue_grey
//        appearance.selectedTextColor = .darkGreenBlue
//        self.dropDown.cellNib = UINib(nibName: "WithdrawDDOptionTVcell", bundle: nil)
//
//        self.dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//           guard let cell = cell as? WithdrawDDOptionTVcell else { return }
//        }
//
//        self.dropDown.bottomOffset = CGPoint(x: 0 , y: self.subServicesValueTF.frame.size.height )
//        self.dropDown.width = self.subServicesValueTF.frame.width
//        self.dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9486033819)
//        DropDown.appearance().textFont = UIFont.SST_Arabic_Medium(ofSize: 12)
//        self.dropDown.show()
//        self.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
//            guard let _ = self else { return }
//            print("\(item) ----- \(index)")
//            self?.selectSubService(serv: self?.viewModel.arrayOfSubServices?[index], parentInfo: self?.viewModel.subservicesResponse.value?.parentService )
////            self?.subServicesValueTF.text = item
////            self?.viewModel.fetchService(id: self?.viewModel.arrayOfSubServices?[index].id ?? "")
//
//        }
//
//    }
//
//    private func selectSubService(serv: ModelServicesCerqel?, parentInfo: ParentServiceCerqel?){
//        self.subServicesValueTF.text = serv?.displayName
//        if let subParentName = viewModel.subParentName{
//            self.titleLbl.text = subParentName
//        }
//        self.subServicesTitleLbl.text = parentInfo?.listName ?? serv?.listName
//
//        self.viewModel.fetchService(id: serv?.id ?? "")
////        self.viewModel.selectedServiceId = serv?.id
//    }
//
//    private func registerCells(){
//        controlsTV.register(DropDownTVcell.cerqel_nib, forCellReuseIdentifier: DropDownTVcell.cerqel_identifier)
//        controlsTV.register(Radio2ItemsOnlyTVcell.cerqel_nib, forCellReuseIdentifier: Radio2ItemsOnlyTVcell.cerqel_identifier)
//        controlsTV.register(TextBoxTVcell.cerqel_nib, forCellReuseIdentifier: TextBoxTVcell.cerqel_identifier)
//        controlsTV.register(UploadMediaTVcell.cerqel_nib, forCellReuseIdentifier: UploadMediaTVcell.cerqel_identifier)
//        controlsTV.register(TextAreaTVcell.cerqel_nib, forCellReuseIdentifier: TextAreaTVcell.cerqel_identifier)
//        controlsTV.register(LinkTVcellTableViewCell.cerqel_nib, forCellReuseIdentifier: LinkTVcellTableViewCell.cerqel_identifier)
//        controlsTV.register(DatePickerTVcell.cerqel_nib, forCellReuseIdentifier: DatePickerTVcell.cerqel_identifier)
//        controlsTV.register(SwitchTVcell.cerqel_nib, forCellReuseIdentifier: SwitchTVcell.cerqel_identifier)
//        controlsTV.register(RangeDatePickerTVcell.cerqel_nib, forCellReuseIdentifier: RangeDatePickerTVcell.cerqel_identifier)
//        controlsTV.register(LabelControleTVcell.cerqel_nib, forCellReuseIdentifier: LabelControleTVcell.cerqel_identifier)
//        controlsTV.register(InfoIndicatorTVcell.cerqel_nib, forCellReuseIdentifier: InfoIndicatorTVcell.cerqel_identifier)
//        controlsTV.register(TimePickerTVcell.cerqel_nib, forCellReuseIdentifier: TimePickerTVcell.cerqel_identifier)
//        controlsTV.register(CheckBoxControlTVcell.cerqel_nib, forCellReuseIdentifier: CheckBoxControlTVcell.cerqel_identifier)
//        controlsTV.register(DateTimeRangePickerTVcell.cerqel_nib, forCellReuseIdentifier: DateTimeRangePickerTVcell.cerqel_identifier)
//        controlsTV.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
//        controlsTV.register(EmployeeInfoControlTVcell.cerqel_nib, forCellReuseIdentifier: EmployeeInfoControlTVcell.cerqel_identifier)
//        controlsTV.register(tableControlTVcell.cerqel_nib, forCellReuseIdentifier: tableControlTVcell.cerqel_identifier)
//        controlsTV.register(SearchControlTVcell.cerqel_nib, forCellReuseIdentifier: SearchControlTVcell.cerqel_identifier)
//
//
//    }
//
//    private func showSuccessResponse(serviceId: String){
//        formStackView.isHidden = true
//        successStackView.isHidden = false
//
//        let st = "This is just a quick note to let you know that we have received your Request ".localized
//        let last = " and will respond , as soon as we can.".localized
//
//        let firstAttributes: [NSAttributedString.Key: Any] = [:]
//        let secondAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.SST_Arabic_Bold(ofSize: 14)]
//
//        let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
//        let lastString = NSMutableAttributedString(string: last, attributes: firstAttributes)
//        let secondString = NSAttributedString(string: "#\(serviceId)", attributes: secondAttributes)
//
//        firstString.append(secondString)
//        firstString.append(lastString)
//
//        self.successInfoLbl.attributedText = firstString
//
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        updateUI()
//    }
//
//    private func updateUI(){
//        bgTopView.cerqel_roundCorners(corners: .bottomLeft, radius: 50)
//        bgBottomView.cerqel_roundCorners(corners: .topRight, radius: 50)
//
//        self.view.layoutIfNeeded()
//
//    }
//

    
}


