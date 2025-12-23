//
//  DatePickerPopup.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 11/23/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
//import TransitionButton

@objc protocol PickerVCDelegate {
    @objc optional func didSelect(sender: Any?, index: Int, value: String)
    @objc optional func didSelectDate(sender: Any?, date: Date)
}

public class DatePickerPopup: BottomSheetVCCerqel, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: TransitionButton!
    @IBOutlet weak var titleLbl: UILabel!

    //    static var shared = PickerVC()
    var currentVC: UIViewController!
    var dataArray: [String] = []
    var isDate = false
    var currentDate : Date?
    var selectedIndex = -1
    var selectedValue = ""
    var datePickerMode = UIDatePicker.Mode.dateAndTime
    var dateCalendarType: Calendar.Identifier = .gregorian
    var minimumDate: Date?
    var maximumDate: Date?
    var pickerTitle: String?
    private var blackBgView = UIView()
    
    
    var sender: Any?
    var delegate: PickerVCDelegate?
    
    
    
    var didPickDate: ((Date)->())?
    var didPickValue: ((Int)->())?

    
    static public func instance() -> DatePickerPopup{
        let vc = DatePickerPopup(nibName: "DatePickerPopup", bundle: nil)
        vc.cerqel_sheetHeight = 450
        return vc
    }

    
    override public func viewDidLoad() {
        super.viewDidLoad()
//        doneBtn.setTitle("Confirm".localized, for: .normal)
        titleLbl.text = pickerTitle
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePicker.isHidden = !isDate
        datePicker.locale = dateFormatterLocal_en_USCerqel
        if isArabicCerqel(){
            datePicker.locale = Locale(identifier: "ar_EG")
            
        }
        picker.isHidden = isDate
        
        datePicker.datePickerMode = datePickerMode
        if datePickerMode == .date{
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = UIDatePickerStyle.inline
                
            } else {
                // Fallback on earlier versions

            }

        }else if datePickerMode == .time{
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            } else {
                // Fallback on earlier versions

            }

        }

        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.timeZone = currentTimeZoneCerqel
        
        picker.reloadAllComponents()
        if selectedIndex >= 0 {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        self.cerqel_sheetCtl.closeSheet()
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (dataArray.count > 0) {
            selectedIndex = row
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = dataArray[row]
        return title
    }
    
    func show(vc: UIViewController, sender: Any?, array: [String], index: Int, value: String) {
        OperationQueue.main.addOperation {
            
            self.currentVC = vc
            //            self.modalPresentationStyle = .overFullScreen
            self.currentVC.view.endEditing(true)
            //            self.currentVC.present(self, animated: true, completion: nil)
            self.currentVC.cerqel_presentSheetController(viewToPresent: self, height: self.cerqel_sheetHeight)
            
            self.isDate = false
            self.sender = sender
            self.dataArray = array
            self.selectedIndex = index
            self.selectedValue = value
            if (self.dataArray.count > 0) {
                if self.selectedIndex < 0 || self.selectedIndex >= self.dataArray.count {
                    self.selectedIndex = 0
                }
            }
        }
    }
    
    func showDate(vc: UIViewController, sender: Any?, mode: UIDatePicker.Mode, minimum: Date?, maximum: Date? , currentDate: Date? = nil) {
        OperationQueue.main.addOperation {
            self.currentVC = vc
            //            self.modalPresentationStyle = .overCurrentContext
            //            self.modalPresentationStyle = .overFullScreen
            self.currentVC.view.endEditing(true)
            //            self.currentVC.present(self, animated: true, completion: nil)
            
            self.currentVC.cerqel_presentSheetController(viewToPresent: self, height: self.cerqel_sheetHeight)
            
            self.isDate = true
            self.sender = sender
            self.dataArray = []
            self.selectedIndex = -1
            self.selectedValue = ""
            self.datePickerMode = mode
            self.minimumDate = minimum
            self.maximumDate = maximum
//            if let currentDate = currentDate {
                self.datePicker.calendar = .init(identifier: self.dateCalendarType)
                self.datePicker.date = currentDate ?? Date()
                
//            }
        }
    }

    @IBAction func confirmBtnTapped(_ sender: Any?) {
        self.doneBtn.startAnimation()
        delayCerqel(seconds: 0.5) {
//            self.cerqel_sheetCtl.closeSheet {
//                if self.isDate {
//                    
//                    self.didPickDate?(self.datePicker.date)
//    //                if self.delegate != nil && self.delegate!.didSelectDate != nil {
//    //                    self.delegate!.didSelectDate!(sender: self.sender, date: self.datePicker.date)
//    //                }
//                } else {
////                    if self.delegate != nil && self.delegate!.didSelect != nil && self.selectedIndex >= 0 {
////                        self.selectedValue = self.dataArray[self.selectedIndex]
////                        self.delegate!.didSelect!(sender: self.sender, index: self.selectedIndex, value: self.selectedValue)
//                        self.didPickValue?(self.selectedIndex)
////                    }
//                }
//            }
        }
        
        
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}


