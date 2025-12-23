//
//  NewDatePickerPopup.swift
//
//
//  Created by Marwan on 06/02/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

public class NewDatePickerPopup: BottomSheetVCCerqel {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.tintColor = primaryMain
        }
    }
    @IBOutlet weak var doneBtn: UIButton! {
        didSet {
            handleDoneButton(enabled: valid())
        }
    }
    
    // MARK: - Variables
    
    var currentVC: UIViewController!
    var presentedFormat: String?
    var regularFormat: String?
    var dataArray: [String] = []
    var isDate = false
    var currentDate : Date?
    var selectedIndex = -1
    var selectedValue = ""
    var datePickerMode = UIDatePicker.Mode.dateAndTime
    var dateCalendarType: Calendar.Identifier = .gregorian
    var minimumDate: Date?
    var maximumDate: Date?
    var disabledDates: [String]?
    var disabledDays: [Int]?
    var pickerTitle: String?
    var from: Bool?
    var isFromCustomCalender = false
    private var blackBgView = UIView()
    
    var sender: Any?
    
    var didPickDate: ((Date)->())?
    var didPickValue: ((Int)->())?
    
    
    
    // MARK: - LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.setTitle("Confirm".localized, for: .normal)
        datePicker.addTarget(self, action: #selector(handleConfirmButtonStatus), for: .allEvents)
        doneBtn.backgroundColor =  primaryMain
        closeIcon.tintColor =  primaryMain
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.layer.cornerRadius = 12
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        datePicker.isHidden = !isDate
        datePicker.locale = dateFormatterLocal_en_US
        if isArabicCerqel(){
            datePicker.locale = Locale(identifier: "ar_EG")
        }
        picker.isHidden = isDate
        
        datePicker.datePickerMode = datePickerMode
        if datePickerMode == .date{
            titleLbl.text = "Select Date".localized
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = isFromCustomCalender ? UIDatePickerStyle.wheels : UIDatePickerStyle.inline
            }
            
        }else if datePickerMode == .time{
            titleLbl.text = "Select Time".localized
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            }
        }
        
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.timeZone = timeZone_UTC
        
        
            
        picker.reloadAllComponents()
        if selectedIndex >= 0 {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Functions
    
    /// setting date picker popup instance
    /// - Returns: date picker popup view
    static public func instance() -> NewDatePickerPopup {
        let vc = NewDatePickerPopup(nibName: "NewDatePickerPopup", bundle: nil)
        vc.cerqel_sheetHeight = 600
        return vc
    }
    
    /// handling done button behavior
    /// - Parameter enabled: if it's enabled or not
    public func handleDoneButton(enabled: Bool) {
        doneBtn.isUserInteractionEnabled = enabled
        doneBtn.backgroundColor = !enabled ? .alertClosed : primaryMain
    }
    
    /// checking if we should disable dates
    /// - Parameter date: date to be disabled or not
    /// - Returns: disable the date or not
    public func datePicker(shouldDisableDate date: Date) -> Bool {
        
        if let disabledDates = disabledDates {
            var disabledDatesInDate = [Date]()
            for disabledDate in disabledDates {
                if dateCalendarType != .gregorian {
                    disabledDatesInDate.append(convertDateToGregorianDate(stringDate: disabledDate))
                }else {
                    disabledDatesInDate.append(disabledDate.getDateFromString() ?? Date())
                }
            }
            for disabledDate in disabledDatesInDate {
                if Calendar.current.isDate(date, equalTo: disabledDate, toGranularity: .day) {
                    return true
                }else {
                    continue
                }
            }
        }
        
        let dayInWeek = date.weekday
        for disabledDay in disabledDays ?? [] {
            if dayInWeek == disabledDay {
                return true
            }else {
                continue
            }
        }
        return false
    }
    
    /// presenting date picker view
    /// - Parameters:
    ///   - vc: container view controller
    ///   - sender: any sender
    ///   - mode: date picker mode
    ///   - minimum: minimum date
    ///   - maximum: max date
    ///   - currentDate: current date
    ///   - disabledDates: disabled dates
    ///   - disabledDays: disabled days
    ///   - presentedFormat: format
    ///   - regularFormat: format
    ///   - from: is it 'date from' or not
    public func showDate(vc: UIViewController, sender: Any?, mode: UIDatePicker.Mode, minimum: Date?, maximum: Date? , currentDate: Date? = nil, disabledDates: [String]? = [], disabledDays: [Int]? = [], presentedFormat: String? = "", regularFormat: String? = "",from: Bool? = nil, isFromCustomCalender: Bool = false) {
        OperationQueue.main.addOperation {

            self.currentVC = vc
            self.currentVC.view.endEditing(true)
            self.currentVC.cerqel_presentSheetController(viewToPresent: self, height: self.cerqel_sheetHeight)
            self.presentedFormat = presentedFormat
            self.regularFormat = regularFormat
            self.isDate = true
            self.sender = sender
            self.dataArray = []
            self.selectedIndex = -1
            self.selectedValue = ""
            self.datePickerMode = mode
            self.minimumDate = minimum
            self.maximumDate = maximum
            self.datePicker.calendar = .init(identifier: self.dateCalendarType)
            self.datePicker.date = currentDate ?? Date()
            self.disabledDays = disabledDays
            self.disabledDates = disabledDates
            self.from = from
            self.isFromCustomCalender = isFromCustomCalender
            if mode == .date {
                if self.from != true {
                    self.datePicker.date = minimum ?? currentDate ?? Date()
                }
                self.handleDoneButton(enabled: self.valid())
            }
        }
    }
    
    /// converting hijri string date to gregorian date
    /// - Parameter stringDate: hijri string date
    /// - Returns: gregorian date
    public func convertDateToGregorianDate(stringDate: String) -> Date {
        let hijri = hijriCalendar
        let formatter = DateFormatter()
        formatter.calendar = hijri
        formatter.dateFormat = regularFormat
        formatter.timeZone = timeZone_UTC
        let hijriDate = formatter.date(from: stringDate) ?? Date()
        
        let gregorianFormatter = DateFormatter()
        gregorianFormatter.calendar = Calendar.init(identifier: .gregorian)
        gregorianFormatter.dateFormat = presentedFormat
        let gregorianString = gregorianFormatter.string(from: hijriDate)
        return gregorianFormatter.date(from: gregorianString) ?? Date()
    }
    
    /// check if it's valid date or not
    /// - Returns: result of valid date or not
    public func valid() -> Bool {
        if datePickerMode != .time {
                guard !datePicker(shouldDisableDate: datePicker.date) else {return false}
        }
        return true
    }
    
    // MARK: - IBActions
    
    /// handling confirm button status
    @objc func handleConfirmButtonStatus() {
        handleDoneButton(enabled: valid())
    }
    
    /// fired when user press on confirm button
    /// - Parameter sender: confirm button
    @IBAction func confirmBtnTapped(_ sender: Any?) {
        guard valid() else {return}
        delay(seconds: 0.5) {[weak self] in
            guard let `self` = self else {return}
            self.cerqel_sheetCtl.dismiss(animated: true) {
                if self.isDate {
                    self.didPickDate?(self.datePicker.date)
                } else {
                    self.didPickValue?(self.selectedIndex)
                }
            }
        }
    }
    
    /// fired when user press on X button
    /// - Parameter sender: X button
    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
