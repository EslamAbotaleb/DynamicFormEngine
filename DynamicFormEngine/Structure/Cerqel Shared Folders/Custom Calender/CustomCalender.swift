//
//  CustomCalender.swift
//  CERQEL
//
//  Created by ahmed maher on 05/11/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
public import PanModal
import FSCalendar

class CustomCalender: UIViewController,  FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    
    var currentVC: UIViewController?
    var disabledDates: [String] = []
    var disabledDays: [Int] = []
    var disabledMonths: [Int] = []
    var disabledDaysOfMonth: [Int] = []
    var minimumDate: Date?
    var maximumDate: Date?
    var presentedFormat: String?
    var regularFormat: String?
    var from: Bool?
    var selectedDates: [Date]?
    var dateCalendarType: FormCalendarType = .Gregorian
    var firstWeekday: Int?
    var didPickDate: (([Date])->())?
    var didPickValue: ((Int)->())?
    var allowsMultipleSelection = false
    var isRangePicker: Bool = false
    private var rangeStartDate: Date?
    private var rangeEndDate: Date?
    
    @IBOutlet weak var calendar: FSCalendar! {
        didSet {
            calendar.tintColor = .primary
        }
    }
    @IBOutlet weak var customHeader: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var closeIcon: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCalendar()
        updateHeaderTitle()
        addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleCalendarSelectedDates()
        setupCalendarAppearance()
        updateHeaderTitle(selectedDates: selectedDates)
    }
        
    private func handleCalendarSelectedDates() {
        if let selectedDates = self.selectedDates, !(self.from ?? true) {
            for selectedDate in selectedDates {
                calendar.select(selectedDate)
            }
            handleSubmitButton(enabled: true)
        } else if let minimumDate = self.minimumDate, !(self.from ?? true)  {
            calendar.select(minimumDate)
            selectedDates = [minimumDate]
            handleSubmitButton(enabled: true)
        } else if let selectedDates = self.selectedDates, !selectedDates.isEmpty {
            let currentCalendar = Calendar(identifier: dateCalendarType == .Gregorian ? .gregorian : .islamicUmmAlQura)
            let weekday = currentCalendar.component(.weekday, from: selectedDates[0])
            let month = currentCalendar.component(.month, from: selectedDates[0])
            let day = currentCalendar.component(.day, from: selectedDates[0])
            
            if( checkIFDateNotInDisabledDates(dates: selectedDates)) && !disabledDays.contains(weekday) && !disabledMonths.contains(month) && !disabledDaysOfMonth.contains(day) {
                for selectedDate in selectedDates {
                    calendar.select(selectedDate)
                }
                handleSubmitButton(enabled: true)
            }
            else {
                handleSubmitButton(enabled: false)
            }
        }
        handleCalendarRangeDates()
    }
    
    private func handleCalendarRangeDates() {
        guard isRangePicker else { return }
        let selectedDates = selectedDates ?? []
        if selectedDates.count > 1 {
            rangeStartDate = selectedDates.sorted().first
            rangeEndDate = selectedDates.sorted().last
        } else {
            rangeStartDate = selectedDates.sorted().first
        }
    }
    
    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.placeholderType = .none
        calendar.allowsMultipleSelection = self.allowsMultipleSelection || self.isRangePicker
        calendar.headerHeight = 0
        calendar.firstWeekday = UInt((self.firstWeekday ?? 0) + 1)
    }
    
    private func setupCalendarAppearance(shouldReload: Bool = true) {
        // Customize calendar appearance
        submitBtn.tintColor = primaryMain
        closeIcon.tintColor = primaryMain
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.selectionColor = primaryMain
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleDefaultColor = UIColor.black
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.headerTitleColor = UIColor.darkGray
        calendar.appearance.weekdayTextColor = primaryMain
        calendar.appearance.todaySelectionColor = primaryMain
        if calendar.selectedDates.isEmpty {
            calendar.appearance.titleTodayColor = .black
        }
        for selectedDate in calendar.selectedDates {
            calendar.appearance.titleTodayColor = Calendar.current.isDate(selectedDate, inSameDayAs: Date()) ? .white : .black
        }
        
        // Optionally set fonts
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 17)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        if shouldReload {
            calendar.reloadData()
        }
    }
    
    
    private func updateHeaderTitle(selectedDates: [Date]? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: dateCalendarType == .Gregorian ? .gregorian : .islamicUmmAlQura)
        dateFormatter.dateFormat = "MMMM yyyy"
        //  hijriFormatter.locale = Locale(identifier: "ar_SA") // Arabic locale for Hijri format
        
        customHeader.text = dateFormatter.string(from: selectedDates?.first ?? calendar.currentPage)
    }
    
    // This method is called when the calendar page changes
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateHeaderTitle()
    }
    
    func showDate(vc: UIViewController, sender: Any?, dateCalendarType: FormCalendarType = .Gregorian, minimum: Date?, maximum: Date?, currentDates: [Date]? = nil, disabledDates: [String]? = [], disabledDays: [Int]? = [], disabledMonths: [Int]? = [], disabledDaysOfMonth: [Int]? = [], presentedFormat: String? = "", regularFormat: String? = "", from: Bool? = nil, firstWeekday: Int?, selectionMode: DateSelectionMode?) {
        
        // Set properties
        self.currentVC = vc
        self.currentVC?.view.endEditing(true)
        self.dateCalendarType = dateCalendarType
        self.disabledDates = disabledDates ?? []
        self.disabledDays = disabledDays ?? []
        self.disabledMonths = disabledMonths ?? []
        self.disabledDaysOfMonth = disabledDaysOfMonth ?? []
        self.minimumDate = minimum
        self.maximumDate = maximum
        self.presentedFormat = presentedFormat
        self.regularFormat = regularFormat
        self.from = from
        self.selectedDates = selectionMode == .Range ? allDatesBetween(dates: currentDates ?? []) : currentDates ?? []
        self.firstWeekday = firstWeekday
        self.allowsMultipleSelection = selectionMode == .Multiple ? true : false
        self.isRangePicker = selectionMode == .Range
        // Present the view controller
        vc.presentPanModal(self)
    }
        
    // Prevent selection
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let calendar = Calendar(identifier: dateCalendarType == .Gregorian ? .gregorian : .islamicUmmAlQura)
        let weekday = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        
        // Ensure date is within minimum and maximum bounds
        if let minDate = minimumDate, Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: minDate) {
            return false
        }
        if let maxDate = maximumDate, Calendar.current.startOfDay(for: date) > Calendar.current.startOfDay(for: maxDate) {
            return false
        }
        
        
        // DisabledDates
        if !checkIFDateNotInDisabledDates(dates: [date]) {
            return false
        }
        
        
        // DisabledDays
        if disabledDays.contains(weekday) {
            return false
        }
        
        
        // DisabledMonths
        if disabledMonths.contains(month) {
            return false
        }
        
        // DisabledDaysOfMonths
        if disabledDaysOfMonth.contains(day) {
            return false
        }
        
        return true
    }
    
    
    
    // FSCalendar Delegate method to disable and set color to light gray
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        
        // Ensure date is within minimum and maximum bounds
        if let minDate = minimumDate, Calendar.current.startOfDay(for: date) < Calendar.current.startOfDay(for: minDate) {
            return UIColor.lightGray
        }
        if let maxDate = maximumDate, Calendar.current.startOfDay(for: date) > Calendar.current.startOfDay(for: maxDate) {
            return UIColor.lightGray
        }
        
        let calendar = Calendar(identifier: dateCalendarType == .Gregorian ? .gregorian : .islamicUmmAlQura)
        let weekday = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        
        
        // DisabledDates
        if !checkIFDateNotInDisabledDates(dates: [date]) {
            return UIColor.lightGray
        }
        
        // DisabledDays
        if disabledDays.contains(weekday) {
            return UIColor.lightGray
        }
        
        // DisabledMonths
        if disabledMonths.contains(month) {
            return UIColor.lightGray
        }
        
        
        // DisabledDaysOfMonths
        if disabledDaysOfMonth.contains(day) {
            return UIColor.lightGray
        }
        
        
        return nil // Use default color for other days
    }
        
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if isRangePicker {
            handleRangeSelection(for: calendar, selected: date)
        }
        handleSubmitButton(enabled: true)
    }
    
    func isDateSelectable(_ date: Date) -> Bool {
        
        lazy var activeCalendar: Calendar = {
            return Calendar(identifier: .gregorian)
        }()
        
        let month = activeCalendar.monthIndex(for: date)
        let day = activeCalendar.weekdayIndex(for: date)


        if disabledDays.contains(day) {
            return false
        }

        if disabledMonths.contains(month) {
            return false
        }

        if !disabledDates.isEmpty {
            for disabledDate in disabledDates where activeCalendar.isDate(date, inSameDayAs: disabledDate.toDate() ?? Date()) {
                return false
            }
        }

        if let minDate = minimumDate, let maxDate = maximumDate {
            return date >= minDate && date <= maxDate
        }
        
        if let minDate = minimumDate {
            return date >= minDate
        }
        
        if let maxDate = maximumDate {
            return date <= maxDate
        }

        return true
    }

    private func handleRangeSelection(for calendar: FSCalendar, selected date: Date) {
        if rangeStartDate == nil {
            rangeStartDate = date
            rangeEndDate = nil
            calendar.select(date)
        } else if rangeEndDate == nil {
            // Second selection → end date
            if let start = rangeStartDate, date >= start {
                rangeEndDate = date
            } else {
                // If selected date < start, swap
                rangeEndDate = rangeStartDate
                rangeStartDate = date
            }
            selectDatesBetween(start: rangeStartDate!, end: rangeEndDate!, in: calendar)
        } else {
            // Reset range on third tap
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            rangeStartDate = date
            rangeEndDate = nil
            calendar.select(date)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if isRangePicker {
            calendar.select(date)
        } else {
            setupCalendarAppearance(shouldReload: false)
        }
    }
    
    private func selectDatesBetween(start: Date, end: Date, in calendar: FSCalendar) {
        var date = start
        while date <= end {
            if isDateSelectable(date) {
                calendar.select(date)
            }
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }
    }
    
    private func dateOnly(from date: Date) -> Date? {
        let calendar = Calendar(identifier: dateCalendarType == .Gregorian ? .gregorian : .islamicUmmAlQura)
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)
    }
    
    private func checkIFDateNotInDisabledDates (dates: [Date]) -> Bool {
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Normalize the target date by removing time component
        for date in dates {
            guard let targetDateWithoutTime = dateOnly(from: date) else {
                print("Failed to normalize target date")
                exit(1)
            }
            
            // Convert disabled dates to Date objects with only the date part
            let datesArray = disabledDates.compactMap { dateString in
                if let date = isoDateFormatter.date(from: dateString) {
                    return dateOnly(from: date)
                }
                return nil
            }
            
            
            // Check if the target date (date-only) is in the array
            if datesArray.contains(targetDateWithoutTime) {
                return false
            }
        }
        
        return true
    }
    
    private func handleSubmitButton(enabled: Bool) {
        submitBtn.isUserInteractionEnabled = enabled
        submitBtn.tintColor = !enabled ? .alertClosed : primaryMain
    }
    
    // MARK: - IBActions
    @IBAction func confirmBtnTapped(_ sender: Any?) {
        var localDates = [Date]()
        if isRangePicker {
            if let start = rangeStartDate, let end = rangeEndDate {
                var date = start
                while date <= end {
                    if isDateSelectable(date) {
                        localDates.append(date)
                    }
                    guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
                    date = nextDate
                }
            } else if let start = rangeStartDate {
                // single date if end not picked yet, only if selectable
                if isDateSelectable(start) {
                    localDates = [start]
                }
            }
        } else {
            localDates = calendar.selectedDates.filter { isDateSelectable($0) }
        }
        
        let timeZone = TimeZone.current
        let adjusted = localDates.map { $0.addingTimeInterval(TimeInterval(timeZone.secondsFromGMT(for: $0))) }
        self.didPickDate?(adjusted)
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CustomCalender: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil // Return nil if you don't have a scroll view to manage dragging
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(500) // Height when the sheet is fully expanded
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500) // Height when the sheet is in a collapsed state
    }
    
    var cornerRadius: CGFloat {
        return 12.0 // Rounded corners
    }
    
    var allowsDragToDismiss: Bool {
        return true // Allow dragging down to dismiss
    }
    
    var allowsTapToDismiss: Bool {
        return true // Allow tapping outside to dismiss
    }
}

extension CustomCalender {
    
    func allDatesBetween(dates: [Date]) -> [Date] {
        guard !dates.isEmpty else { return [] }
        
        let sorted = dates.sorted()
        let calendar = Calendar.current
        
        guard let start = sorted.first,
              let end = sorted.last else {
            return []
        }
        
        if calendar.isDate(start, inSameDayAs: end) {
            return [start, end]
        }
        
        var result: [Date] = []
        var current = start
        
        while current <= end {
            result.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        
        return result
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        customHeader.isUserInteractionEnabled = true
        customHeader.addGestureRecognizer(tapGesture)
    }
    
    @objc func dateTapped() {
        showCalendar()
    }
    
    func showCalendar() {
        let picker = NewDatePickerPopup.instance()
        picker.dateCalendarType = self.dateCalendarType == .Hijri ? .islamicUmmAlQura : .gregorian
        picker.didPickDate = {[weak self] date in
            guard let `self` = self else {return}
            
            self.selectedDates = [date]
            self.calendar.setCurrentPage(date, animated: true)
            
            self.handleCalendarSelectedDates()
            self.setupCalendarAppearance()
            self.updateHeaderTitle(selectedDates: selectedDates)
        }
        
        picker.showDate(vc: self,
                        sender: nil,
                        mode: .date,
                        minimum: self.minimumDate,
                        maximum: self.maximumDate,
                        currentDate: self.selectedDates?.first ?? Date(),
                        disabledDates: self.disabledDates,
                        disabledDays: self.disabledDays,
                        presentedFormat: self.presentedFormat,
                        regularFormat: self.regularFormat,
                        from: true,
                        isFromCustomCalender: true)
    }
}

extension Calendar {

    /// Returns 0-based weekday index (Sunday = 1, Monday = 2, ..., Saturday = 7)
    func weekdayIndex(for date: Date) -> Int {
        component(.weekday, from: date)
    }

    /// Returns the month number from a date (1-12)
    func monthIndex(for date: Date) -> Int {
        component(.month, from: date)
    }
}
