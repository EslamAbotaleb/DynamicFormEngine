//
//  DateTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 22/11/2021.
//

import UIKit
import ActionSheetPicker_3_0


class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    @IBOutlet var viewsCollection: [UIView]!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelDateItem {
                setupWith(item: item)
            }
        }
    }
    
    var dateValue = "" {
        didSet {
            if dateValue.isEmpty {
                dateLabel.text = "Date".localized
            } else {
//                if Localizer.currentAppLanguageArabic() {
//                    dateLabel.text = dateValue.toArabic
//                } else {
//                    dateLabel.text = dateValue.toEnglish
//                }
            }
        }
    }
    var timeValue = "" {
        didSet {
            if timeValue.isEmpty {
                timeLabel.text = "Time".localized
            } else {
//                if Localizer.currentAppLanguageArabic() {
//                    timeLabel.text = timeValue.getArabicTime
//                } else {
                    timeLabel.text = timeValue
//                }
            }
        }
    }
    
    var valueChanged: ((DateTimeAnswer) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for view in viewsCollection {
//            view.layer.borderColor = UIColor(r: 208, g: 217, b: 226).cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 4
        }
    }
    
    func setupWith(item: FormViewModelDateItem) {
        labelView.item = item
        labelView.required = item.required
        attachmentNoteView.item = item
        
        if item.dateTimeType == .Date {
            dateView.isHidden = false
            timeView.isHidden = true
        } else if item.dateTimeType == .Time {
            dateView.isHidden = true
            timeView.isHidden = false
        } else {
            dateView.isHidden = false
            timeView.isHidden = false
        }
        
        if let defaultAnswer = item.defaultAnswer {
            handleDefaultAnswer(defaultAnswer, item: item)
        }
        
        if let value = (item.answer as? DateTimeAnswer)?.value {
            handleDateValue(value, item: item)
        }
    }
    
    func handleDateValue(_ value: [String], item: FormViewModelDateItem) {
        switch item.dateSelectionMode {
        case .Single:
            if let date = value.first?.getDateFromString() {
                dateValue = getDateStr(date: date) ?? ""
                timeValue = getTimeStr(date: date) ?? ""
            }
        case .Range:
            if let firstDate = value.first?.getDateFromString(), let lastDate = value.last?.getDateFromString() {
                dateValue = (getDateStr(date: firstDate) ?? "") + " - " + (getDateStr(date: lastDate) ?? "")
                timeValue = getTimeStr(date: firstDate) ?? ""
            }
        case .Multiple:
            var dates = [Date]()
            for val in value {
                if let date = val.getDateFromString() {
                    dates.append(date)
                }
            }
            var datesStr = [String]()
            for date in dates {
                datesStr.append(getDateStr(date: date) ?? "")
            }
            dateValue = datesStr.joined(separator: ", ")
            timeValue = getTimeStr(date: dates.first ?? Date()) ?? ""
        default:
            break
        }
    }
 
    @IBAction func dateAction(_ sender: UIButton) {
        if let selectionMode = (item as? FormViewModelDateItem)?.dateSelectionMode, selectionMode == .Single {
            openPicker(isDate: true, sender: sender)
        } else {
            openCalendarVC()
        }
    }
    
    @IBAction func timeAction(_ sender: UIButton) {
        openPicker(isDate: false, sender: sender)
    }
    
    func openCalendarVC() {
//        let calendarVC = Utilities.instantiateVCWithId("calendarVC") as! CalendarViewController
//        calendarVC.item = (item as? FormViewModelDateItem)
//        calendarVC.delegate = self
//        calendarVC.dateValue = dateValue
//        self.parentContainerViewController()?.present(calendarVC, animated: true, completion: nil)
    }
    
    func openPicker(isDate: Bool, sender: UIButton) {
        var title = ""
        var mode: UIDatePicker.Mode = .date
        var selectedDate = Date()
        if !isDate {
            title = "Select Time"
            mode = .time
            if !timeValue.isEmpty {
//                selectedDate = timeValue.getDateForTime ?? Date()
            }
        } else {
            title = "Select Date"
            if !dateValue.isEmpty {
//                selectedDate = dateValue.getDateFromStrWithFormat((item as? FormViewModelDateItem)?.dateFormat?.swiftFormat)
            }
        }
        
        let datePicker = ActionSheetDatePicker(title: title.localized, datePickerMode: mode, selectedDate: selectedDate, doneBlock: { (picker, value, view) in
            if let date = value as? Date {
                if isDate {
                    self.dateValue = self.getDateStr(date: date) ?? ""
                } else {
                    self.timeValue = self.getTimeStr(date: date) ?? ""
                }
                self.submitValue()
            }
        }, cancel: { ActionDateCancelBlock in
            if isDate {
                self.dateValue = ""
            } else {
                self.timeValue = ""
            }
            self.submitValue()
        }, origin: sender)
        
        datePicker?.setCancelButton(UIBarButtonItem(title: "Clear".localized, style: .plain, target: nil, action: nil))
        
        datePicker?.locale = getPickerLocalizer(item)
        
//        datePicker?.toolbarButtonsColor = .primaryColor
        datePicker?.show()
    }
    
    func getTimeStr(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (item as? FormViewModelDateItem)?.timeFormat?.swiftFormat
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    func getDateStr(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (item as? FormViewModelDateItem)?.dateFormat?.swiftFormat
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: date)
    }
    
    func getPickerLocalizer(_ item: FormViewModelItem) -> Locale {
        if (item as? FormViewModelDateItem)?.timeFormat == .FullDay {
//            if Localizer.currentAppLanguageArabic() {
//                return Locale(identifier: "ar_KM")
//            } else {
                return Locale(identifier: "en_GB")
//            }
        } else {
//            if Localizer.currentAppLanguageArabic() {
//                return Locale(identifier: "ar")
//            } else {
                return Locale(identifier: "en_US")
//            }
        }
    }
    
    func handleDefaultAnswer(_ defaultAnswer: DateTimeAnswer, item: FormViewModelDateItem) {
        if let value = defaultAnswer.value?.first, let date = value.getDateFromString() {
            if item.defaultTimeType == .Custom {
                timeValue = getTimeStr(date: date) ?? ""
            }
            if item.defaultDateType == .Custom {
                dateValue = getDateStr(date: date) ?? ""
            }
        } else {
            if item.defaultTimeType == .Current {
                timeValue = self.getTimeStr(date: Date()) ?? ""
            }
            if item.defaultDateType == .Current {
                dateValue = self.getDateStr(date: Date()) ?? ""
            }
        }
    }
    
    func submitValue() {
        if let item = item as? FormViewModelDateItem, let dateFormat = item.dateFormat?.swiftFormat, let timeFormat = item.timeFormat?.swiftFormat {
            var string = [String]()
            let dateFormatter = DateFormatter()
            var newFormat = ""
            if !dateValue.isEmpty && !timeValue.isEmpty {
                newFormat = "\(dateFormat) \(timeFormat)"
                let newDates = handleSubmiteDateValue(dateValue, dateFormat: dateFormat)
                string = newDates.map({ $0 + " " + timeValue})
            } else if !dateValue.isEmpty {
                newFormat = "\(dateFormat)"
                let newDates = handleSubmiteDateValue(dateValue, dateFormat: dateFormat)
                string = newDates.map({ $0 })
            } else if !timeValue.isEmpty {
                newFormat = "\(dateFormat) \(timeFormat)"
                string = [(getDateStr(date: Date()) ?? "") + " " + timeValue]
            }
            var finalVals = [String]()
            for str in string {
                dateFormatter.dateFormat = newFormat
                if let finalDate = dateFormatter.date(from: str) {
                    dateFormatter.dateFormat = "y-MM-dd'T'HH:mm:ssZ"
                    let finalDateStr = dateFormatter.string(from: finalDate)
                    finalVals.append(finalDateStr)
                }
            }
            self.valueChanged?(DateTimeAnswer(val: finalVals, type: item.dateProperties?.calendarType ?? .Gregorian))
        }
    }
    
    func handleSubmiteDateValue(_ string: String, dateFormat: String) -> [String] {
        var dates = [String]()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if string.contains("-") {
            let components = string.components(separatedBy: " - ")
            if var firstDate = components.first?.getDateFromString(), let lastDate = components.last?.getDateFromString() {
                while firstDate <= lastDate {
                    dates.append(formatter.string(from: firstDate))
                    firstDate = Calendar.current.date(byAdding: .day, value: 1, to: firstDate)!
                }
            }
        } else if string.contains(",") {
            let components = string.components(separatedBy: ", ")
            for component in components {
                dates.append(component)
            }
        }
        return dates
    }
}

//extension DateTableViewCell: CalendarDelegate {
//    func dateSelected(_ date: String) {
//        dateValue = date.toEnglish
//        self.submitValue()
//    }
//}
