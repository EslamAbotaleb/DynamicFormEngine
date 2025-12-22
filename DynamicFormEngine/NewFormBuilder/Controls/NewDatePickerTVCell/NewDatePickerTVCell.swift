//
//  NewDatePickerTVCell.swift
//
//
//  Created by Marwan on 24/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewDatePickerTVCell: ParentFieldTableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var dateFromContainerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateFromValueTF: UITextField!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var timeFromContainerView: UIView!
    @IBOutlet weak var dateToContainerView: UIView!
    @IBOutlet weak var dateToValueTF: UITextField!
    
    @IBOutlet weak var timeToContainerView: UIView!
    @IBOutlet weak var timeFromValueTF: UITextField!
    @IBOutlet weak var timeToValueTF: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var datesStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var dateFromBtn: UIButton!
    
    @IBOutlet weak var timeToBtn: UIButton!
    @IBOutlet weak var timeFromBtn: UIButton!
    @IBOutlet weak var dateToBtn: UIButton!
    @IBOutlet weak var toolTipIcon: UIButton!
    
    @IBOutlet weak var dfCalendarDateFrom: UIImageView!
    @IBOutlet weak var dfCalendarDateTo: UIImageView!
    @IBOutlet weak var dfCalendarTimeFrom: UIImageView!
    @IBOutlet weak var dfCalendarTimeTo: UIImageView!
    
    
    // MARK: - Variables
    
    lazy var startEdit = false
    var isSectionItem = false
    var dateProperties: DateTimeProperties?
    var toolTipTxt = ""
    var item: FormViewModelItem! {
        didSet {
            if !startEdit {
                dateFromValueTF.text = ""
                dateToValueTF.text = ""
                timeFromValueTF.text = ""
                timeToValueTF.text = ""
            }
            
            if let item = item as? FormViewModelDateItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                setupWith(item: item)
                updateErrorState(inlineError: item.inLineError, message: item.errorMessageInline)
            }
            [dfCalendarDateFrom, dfCalendarDateTo, dfCalendarTimeFrom, dfCalendarTimeTo].forEach {
                $0?.tintColor = (item.disabled || item.field?.properties?.readonly ?? false) ? .greyIcon : primaryMain
            }
        }
    }
    
    var dateFromValue = "" {
        didSet {
            if dateFromValue.isEmpty {
                dateFromValueTF.text = ""
                dateFromValueTF.placeholder = "Date From".localized
            } else {
                if dateProperties?.calendarType == .Gregorian {
                    if isArabicCerqel() {
                        dateFromValueTF.text = dateFromValue.toArabic
                    } else {
                        dateFromValueTF.text = dateFromValue.toEnglish
                    }
                }else {
                    if isArabicCerqel() {
                        dateFromValueTF.text = HelperFunctions.convertDateToHijriString(stringDate: dateFromValue, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat).toArabic
                    } else {
                        dateFromValueTF.text = HelperFunctions.convertDateToHijriString(stringDate: dateFromValue, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat).toEnglish
                    }
                }
            }
        }
    }
    var timeFromValue = "" {
        didSet {
            if timeFromValue.isEmpty {
                timeFromValueTF.text = ""
                timeFromValueTF.placeholder = "Time From".localized
            } else {
                if isArabicCerqel() {
                    timeFromValueTF.text = timeFromValue.toArabic
                } else {
                    timeFromValueTF.text = timeFromValue.toEnglish
                }
            }
        }
    }
    
    var dateToValue = "" {
        didSet {
            if dateToValue.isEmpty {
                dateToValueTF.text = ""
                dateToValueTF.placeholder = "Date To".localized
            } else {
                if dateProperties?.calendarType == .Gregorian {
                    if isArabicCerqel() {
                        dateToValueTF.text = dateToValue.toArabic
                    } else {
                        dateToValueTF.text = dateToValue.toEnglish
                    }
                }else {
                    if isArabicCerqel() {
                        dateToValueTF.text = HelperFunctions.convertDateToHijriString(stringDate: dateToValue, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat).toArabic
                    } else {
                        dateToValueTF.text = HelperFunctions.convertDateToHijriString(stringDate: dateToValue, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat).toEnglish
                    }
                }
            }
        }
    }
    var timeToValue = "" {
        didSet {
            if timeToValue.isEmpty {
                timeToValueTF.text = ""
                timeToValueTF.placeholder = "Time From".localized
            } else {
                if isArabicCerqel() {
                    timeToValueTF.text = timeToValue.toArabic
                } else {
                    timeToValueTF.text = timeToValue.toEnglish
                }
            }
        }
    }
    
    var checkedImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "checked")
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    
    // MARK: - Delegates
    
    var validationChanged: ((Bool) -> ())?
    var valueChanged: ((DateTimeAnswer?, Bool) -> ())?
    var dataSourceFetching: ((_ dataSource: String, FormViewModelItem)->())?
    var inlineError = false
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialUI()
        handleToolTipGesture()
    }
    
    
    // MARK: - Functions
    
    private func configureUI() {
        titleLbl.textColor = typographyTitle
        descriptionLbl.textColor = typographySubtitle
        toolTipIcon.tintColor = typographyTitle
    }
    
    /// adding TapGesture to title label to view the toolTip
    func handleToolTipGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        titleLbl.isUserInteractionEnabled = true
        titleLbl.addGestureRecognizer(tapGesture)
    }
    
    /// drawing ui for the 4 views
    func setupInitialUI() {
        [dateFromContainerView, dateToContainerView, timeFromContainerView, timeToContainerView].forEach {
            $0?.layer.cornerRadius = 7
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.init(hexString: "#969696").cgColor
        }
    }
    
    /// updating view constraints in section and normal view
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
    
    
    
    /// setting up tool tip from json
    /// - Parameters:
    ///   - item: date item
    ///   - localization: localization from json
    func setupToolTip(item: FormViewModelDateItem, localization: InteractiveLocalization) {
        if !isArabicCerqel() {
            if let localizedToolTip = localization["en"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item.tooltip ?? ""
            }
        } else {
            if let localizedToolTip = localization["ar"]?.tooltip, !localizedToolTip.isEmpty {
                self.toolTipTxt = localizedToolTip
            } else {
                self.toolTipTxt = item.tooltip ?? ""
            }
        }
        toolTipIcon.isHidden = toolTipTxt.isEmpty
    }
    
    /// setting up title
    /// - Parameter item: date item
    func setupTitle(item: FormViewModelDateItem) {
        guard let localization = item.localization as? InteractiveLocalization else { return }
        if !isArabicCerqel() {
            titleLbl.text = localization["en"]?.label
        } else {
            titleLbl.text = localization["ar"]?.label
        }
        setRequiredMark(item: item, value: titleLbl.text ?? "")
        titleLbl.isHidden = (titleLbl.text ?? "").isEmpty ? true : false
        setupToolTip(item: item, localization: localization)
    }
    
    /// setting up sub title
    /// - Parameter item: date item
    func setupSubTitle(item: FormViewModelDateItem) {
        guard let localization = item.localization as? InteractiveLocalization else { return }
        if !isArabicCerqel() {
            descriptionLbl.text = localization["en"]?.sublabel
        } else {
            descriptionLbl.text = localization["ar"]?.sublabel
        }
        descriptionLbl.isHidden = (descriptionLbl.text ?? "").isEmpty ? true : false
    }
    
    /// setting up placeholder
    /// - Parameter item: date item
    func setupSubPlaceholder(item: FormViewModelDateItem) {
        if let localization = item.localization as? InteractiveLocalization {
            if !isArabicCerqel() {
                dateFromValueTF.placeholder = localization["en"]?.placeholder
                dateToValueTF.placeholder = localization["en"]?.placeholder
                timeFromValueTF.placeholder = localization["en"]?.placeholder
                timeToValueTF.placeholder = localization["en"]?.placeholder
            }else {
                dateFromValueTF.placeholder = localization["ar"]?.placeholder
                dateToValueTF.placeholder = localization["ar"]?.placeholder
                timeFromValueTF.placeholder = localization["ar"]?.placeholder
                timeToValueTF.placeholder = localization["ar"]?.placeholder
            }
        }else {
            dateFromValueTF.placeholder = "Date From".localized
            dateToValueTF.placeholder = "Date To".localized
            timeFromValueTF.placeholder = "Time From".localized
            timeToValueTF.placeholder = "Time To".localized
        }
    }
    
    /// setting required mark for required items
    /// - Parameters:
    ///   - item: date item
    ///   - value: item's title
    func setRequiredMark(item:FormViewModelDateItem, value:String) {
        if item.required {
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
    
    
    /// setting red border to each field if required
    /// - Parameter fields: date from/to & time from/to views
    func setFieldsRequiredUI(fields: [UIView]) {
        [dateFromContainerView, dateToContainerView, timeFromContainerView, timeToContainerView].forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.init(hexString: "#969696").cgColor
        }
        
        guard let item = item as? FormViewModelDateItem else {return}
        guard item.required else {return}
        fields.forEach {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.redSupport.cgColor
        }
    }
    
    /// handling appearance in case date in single mode
    func handleDateTypeInSingleMode() {
        dateFromContainerView.isHidden = false
        timeFromContainerView.isHidden = true
        timeToContainerView.isHidden = true
        dateToContainerView.isHidden = true
        datesStackView.isHidden = false
        timeStackView.isHidden = true
    }
    
    /// handling appearance in case time in single mode
    func handleTimeTypeInSingleMode() {
        dateFromContainerView.isHidden = true
        timeFromContainerView.isHidden = false
        datesStackView.isHidden = true
        timeStackView.isHidden = false
    }
    
    /// handling appearance in case both in single mode
    func handleBothTypeInSingleMode() {
        dateFromContainerView.isHidden = false
        timeFromContainerView.isHidden = false
        datesStackView.isHidden = false
        timeStackView.isHidden = false
    }
    
    /// handling appearance in case single selection mode
    /// - Parameter item: date item
    func handleSingleSelectionMode(item: FormViewModelDateItem) {
        if item.dateSelectionMode == .Single {
            timeToContainerView.isHidden = true
            dateToContainerView.isHidden = true
        }
        if item.dateTimeType == .Date {
            handleDateTypeInSingleMode()
        } else if item.dateTimeType == .Time {
            handleTimeTypeInSingleMode()
        } else { // both type
            handleBothTypeInSingleMode()
        }
    }
    
    /// handling appearance in case date in multi mode
    func handleDateTypeInMultiMode() {
        dateFromContainerView.isHidden = false
        dateToContainerView.isHidden = true
        timeFromContainerView.isHidden = true
        timeToContainerView.isHidden = true
        datesStackView.isHidden = false
        timeStackView.isHidden = true
    }
    
    /// handling appearance in case time in multi mode
//    func handleTimeTypeInMultiMode() {
//        dateFromContainerView.isHidden = true
//        dateToContainerView.isHidden = true
//        timeFromContainerView.isHidden = false
//        timeToContainerView.isHidden = false
//        datesStackView.isHidden = true
//        timeStackView.isHidden = false
//    }
    
    /// handling appearance in case both in multi mode
//    func handleBothTypeInMultiMode() {
//        dateFromContainerView.isHidden = false
//        dateToContainerView.isHidden = false
//        datesStackView.isHidden = false
//        timeStackView.isHidden = false
//        timeFromContainerView.isHidden = false
//        timeToContainerView.isHidden = false
//    }
    
    /// setting up date item
    /// - Parameter item: date item
    func setupWith(item: FormViewModelDateItem) {
        if !startEdit {
            resetValues()
        }
        handleDisabledDateControl(disabled: (item.disabled || item.field?.properties?.readonly ?? false))
        setupTitle(item: item)
        setupSubTitle(item: item)
        setupSubPlaceholder(item: item)
        dateProperties = item.dateProperties

        if item.dateSelectionMode == .Single || item.dateSelectionMode == .Range {
            handleSingleSelectionMode(item: item)
        } else {
            handleDateTypeInMultiMode()
        }
        
        if !startEdit {
            if (((item.answer as? DateTimeAnswer)?.value)?.isEmpty ?? true) {
                if let defaultAnswer = item.defaultAnswer {
                    if let defaultDate = defaultAnswer.value, !defaultDate.isEmpty {
                        handleDefaultAnswer(defaultAnswer, item: item)
                    }
                }
            }
            if let dateValues = (item.answer as? DateTimeAnswer)?.value, !dateValues.isEmpty {
                handleDateValue(dateValues,(item.answer as? DateTimeAnswer)?.timeValues, item: item)
            }
            if let timeValues = (item.answer as? DateTimeAnswer)?.timeValues, !timeValues.isEmpty {
                handleTimeValue(timeValues, item: item)
            }
        }
        
        if item.required && item.disabled {
            item.required = false
        }
        
        if !item.required {
            validationChanged?(true)
        }else {
            if errorLabel.text == "" {
                validationChanged?(true)
            }else {
                validationChanged?(false)
            }
        }
        
        if !item.isUpdated {
            setupInitialUI()
        }
        
        if let dataSourceId = item.field?.properties?.dataSourcId {
            dataSourceFetching?(dataSourceId,item)
        }
    }
    
    /// clear values
    func resetValues() {
        dateFromValue = ""
        dateToValue = ""
        timeFromValue = ""
        timeToValue = ""
        errorView.isHidden = true
        errorLabel.text = ""
    }
    
    func getMultiDateString(value: [String], dateFormatter: DateFormatter, selectionMode: DateSelectionMode) {
        var dates = [Date]()
        for val in value {
            if let date = val.getDateFromString(dateFormatter: dateFormatter) {
                dates.append(date)
            }
        }
        var datesStr = [String]()
        if selectionMode == .Range {
            if let from = dates.first { datesStr.append(getDateStr(date: from) ?? "") }
            if let to = dates.last { datesStr.append(getDateStr(date: to) ?? "") }
            dateFromValue = datesStr.joined(separator: " - ")
        } else {
            for date in dates {
                datesStr.append(getDateStr(date: date) ?? "")
            }
            dateFromValue = datesStr.joined(separator: ", ")
        }
        
    }
    
    /// handling 'date from' value
    /// - Parameters:
    ///   - value: date values array
    ///   - dateFormatter: format
    func handleDateFromValue(value: [String], dateFormatter: DateFormatter, selectionMode: DateSelectionMode) {
        if let format = dateProperties?.dateFormat?.presentedSwiftFormat {
            dateFormatter.dateFormat = format
        }
        
        if selectionMode == .Multiple || selectionMode == .Range {//|| selectionMode == .Range {
            getMultiDateString(value: value, dateFormatter: dateFormatter, selectionMode: selectionMode)
        }else {
            if let dateFrom = value.first?.getDateFromString(dateFormatter: dateFormatter) {
                dateFromValue = getDateStr(date: dateFrom) ?? ""
            }
        }
    }
    
    /// handling 'date to' value
    /// - Parameters:
    ///   - value: date values array
    ///   - dateFormatter: format
    func handleDateToValue(value: [String], dateFormatter: DateFormatter) {
        if value.count > 1, let dateTo = value[1].getDateFromString(dateFormatter: dateFormatter) {
            dateToValue = getDateStr(date: dateTo) ?? ""
        }
    }
    
    /// handling 'time from' value in both mode
    /// - Parameters:
    ///   - value: date values array
    ///   - timeValues: time values array
    ///   - dateFormatter: format
    func handleTimeValueInBothMode(value: [String], timeValues: [String]? = nil, dateFormatter: DateFormatter) {
        if let timeFrom = timeValues?.first?.getDateFromString(dateFormatter: dateFormatter) {
            timeFromValue = getTimeStr(date: timeFrom) ?? ""
        } else {
            let components = value.first?.split(separator: " ")
            if components?.count == 2 {
                timeFromValue =  String(components?[1] ?? "")
            }
        }
    }
    
    /// handling time value in single mode
    /// - Parameters:
    ///   - value: date values array
    ///   - dateFormatter: format
    func handleTimeValueInSingleMode(value: [String], dateFormatter: DateFormatter) {
        if let timeFrom = value.first?.getDateFromString(dateFormatter: dateFormatter) {
            timeFromValue = getTimeStr(date: timeFrom) ?? ""
        }
    }
    
    /// handling date value
    /// - Parameters:
    ///   - value: date values array
    ///   - timeValues: time values array
    ///   - item: date item
    func handleDateValue(_ value: [String], _ timeValues: [String]? = nil, item: FormViewModelDateItem) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = isArabicCerqel() ? dateFormatterLocale_ar : dateFormatterLocal_en_US
        dateFormatter.timeZone = timeZone_UTC
        
        switch item.dateSelectionMode {
        case .Single:
            if item.dateTimeType == .Date {
                handleDateFromValue(value: value, dateFormatter: dateFormatter, selectionMode: .Single)
            } else if  item.dateTimeType == .Both {
                handleDateFromValue(value: value, dateFormatter: dateFormatter, selectionMode: .Single)
                handleTimeValueInBothMode(value:value, timeValues: timeValues, dateFormatter: dateFormatter)
            } else {
                handleTimeValueInSingleMode(value: value, dateFormatter: dateFormatter)
            }
        case .Range:
            handleDateFromValue(value: value, dateFormatter: dateFormatter, selectionMode: .Range)
            handleDateToValue(value: value, dateFormatter: dateFormatter)
            if  timeValues?.isEmpty ?? true {
                handleTimeValue(value, item: item)
            }
        case .Multiple:
            handleDateFromValue(value: value,
                                dateFormatter: dateFormatter,
                                selectionMode: .Multiple)
        default:
            break
        }
        
        let isDisabledOrReadOnly = item.disabled || (item.field?.properties?.readonly ?? false)
        let hasAnswer = item.answer != nil
        let dateAnswer = item.answer as? DateTimeAnswer
        let isDateFromDifferent = dateAnswer?.value?.first != dateFromValueTF.text
        let hasMultipleDates = (dateAnswer?.value?.count ?? 0) > 1
        let isDateToDifferent = dateAnswer?.value?.last != dateToValueTF.text
        
        if isDisabledOrReadOnly && hasAnswer && (isDateFromDifferent || (hasMultipleDates && isDateToDifferent)) {
            self.validate()
        }
    }
    
    /// handling 'time from' value
    /// - Parameter value: time values array
    func handleTimeFromValue(value: [String]) {
        if let timeFrom = value.first?.getDateFromString() {
            timeFromValue = getTimeStr(date: timeFrom) ?? ""
        }
    }
    
    /// handling 'time to' value
    /// - Parameter value: time values array
    func handleTimeToValue(value: [String]) {
        if value.count > 1, let timeTo = value[1].getDateFromString() {
            timeToValue = getTimeStr(date: timeTo) ?? ""
        }
    }
    
    /// handling time value
    /// - Parameters:
    ///   - value: time values array
    ///   - item: date item
    func handleTimeValue(_ value: [String], item: FormViewModelDateItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = isArabicCerqel() ? dateFormatterLocale_ar : dateFormatterLocal_en_US
        dateFormatter.timeZone = timeZone_UTC
        switch item.dateSelectionMode {
        case .Single:
            handleTimeFromValue(value: value)
        case .Range, .Multiple:
            handleTimeFromValue(value: value)
            handleTimeToValue(value: value)
        default:
            break
        }
        let isDisabledOrReadOnly = item.disabled || (item.field?.properties?.readonly ?? false)
        let hasAnswer = item.answer != nil
        let timeAnswer = item.answer as? DateTimeAnswer
        let isTimeFromDifferent = timeAnswer?.timeValues?.first != timeFromValueTF.text
        let hasMultipleTimes = (timeAnswer?.timeValues?.count ?? 0) > 1
        let isTimeToDifferent = timeAnswer?.timeValues?.last != timeToValueTF.text
        
        if isDisabledOrReadOnly && hasAnswer && (isTimeFromDifferent || (hasMultipleTimes && isTimeToDifferent)) {
            self.validate()
        }
    }
    
    /// get time as string
    /// - Parameter date: time
    /// - Returns: time as string
    func getTimeStr(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (item as? FormViewModelDateItem)?.timeFormat?.presentedSwiftFormat
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = timeZone_UTC
        return dateFormatter.string(from: date)
    }
    
    /// get date as string
    /// - Parameter date: date to be string
    /// - Returns: date as string
    func getDateStr(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = timeZone_UTC
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    /// get 'FullDay' locale
    /// - Returns: Locale
    func handleFullDayTimeFormat() -> Locale {
        if isArabicCerqel() {
            return Locale(identifier: "ar_KM")
        } else {
            return Locale(identifier: "en_GB")
        }
    }
    
    /// get 'HalfDay' locale
    /// - Returns: Locale
    func handleHalfDayTimeFormat() -> Locale {
        if isArabicCerqel() {
            return Locale(identifier: "ar")
        } else {
            return Locale(identifier: "en_US")
        }
    }
    
    /// get picker locale
    /// - Parameter item: date item
    /// - Returns: Locale
    func getPickerLocalizer(_ item: FormViewModelItem) -> Locale {
        if (item as? FormViewModelDateItem)?.timeFormat == .FullDay {
            handleFullDayTimeFormat()
        } else {
            handleHalfDayTimeFormat()
        }
    }
    
    /// extracting 'date from' & 'time from'
    /// - Parameters:
    ///   - dateFormatter: format
    ///   - timeFormatter: format
    ///   - fromDate: 'date from' value
    func extractDateTimeFrom(dateFormatter: DateFormatter, timeFormatter: DateFormatter, fromDate: Date) {
        let calendar = Calendar.current
        let fromDateString = dateFormatter.string(from: fromDate)
        let fromTimeString = timeFormatter.string(from: fromDate)
        
        if fromTimeString == "00:00" {
            dateFromValueTF.text = fromDateString
            dateFromValue = fromDateString
        }
        else {
            dateFromValueTF.text = fromDateString
            dateFromValue = fromDateString
            timeFromValueTF.text = fromTimeString
            timeFromValue = fromTimeString
        }
    }
    
    /// extracting 'date to' & 'time to'
    /// - Parameters:
    ///   - dateFormatter: format
    ///   - timeFormatter: format
    ///   - toDate: 'date to' value
    func extractDateTimeTo(dateFormatter: DateFormatter, timeFormatter: DateFormatter, toDate: Date) {
        let calendar = Calendar.current
        let toDateString = dateFormatter.string(from: toDate)
        let toTimeString = timeFormatter.string(from: toDate)
        
        if toTimeString == "00:00" {
            dateToValue = toDateString
            dateToValueTF.text = toDateString
        }else {
            dateToValue = toDateString
            dateToValueTF.text = toDateString
            timeToValue = toTimeString
            timeToValueTF.text = toTimeString
        }
    }
    
    /// handling default answer
    /// - Parameters:
    ///   - defaultAnswer: answer retrieved from json
    ///   - item: date item
    func handleDefaultAnswer(_ defaultAnswer: DefaultDateTimeAnswer, item: FormViewModelDateItem) {
        if let dateRange = defaultAnswer.value?.first {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let dateFormatterFromAndTo = DateFormatter()
            dateFormatterFromAndTo.dateFormat = "yyyy-MM-dd"
            
            // Extract 'from' date and time
            if let fromDate = dateRange.from {
                extractDateTimeFrom(dateFormatter: dateFormatterFromAndTo, timeFormatter: timeFormatter, fromDate: fromDate)
            }
            
            // Extract 'to' date and time
            if let toDate = dateRange.to {
                extractDateTimeTo(dateFormatter: dateFormatterFromAndTo, timeFormatter: timeFormatter, toDate: toDate)
            }
        }
        submitValue()
        
    }
    
    /// preparing btns to be enabled
    override func prepareForReuse() {
        super.prepareForReuse()
        dateFromBtn.isUserInteractionEnabled = true
        dateToBtn.isUserInteractionEnabled = true
        timeFromBtn.isUserInteractionEnabled = true
        timeToBtn.isUserInteractionEnabled = true
    }
    
    /// preparing date values
    /// - Parameters:
    ///   - dateFormatter: format
    ///   - dateFormat: desired format
    /// - Returns: date values
    func prepareDateValues(dateFormatter: DateFormatter, dateFormat: String) -> [String] {
        var finalValsDates = [String]()
        var stringDates = [String]()
        var dateArray = [String]()
        
        if (item as? FormViewModelDateItem)?.dateSelectionMode == .Range {
            dateArray = dateFromValue.components(separatedBy: " - ").map { $0.trimmingCharacters(in: .whitespaces) }
        } else {
            dateArray = dateFromValue.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        }

        for date in dateArray {
            stringDates.append(date)
        }
        stringDates.append(dateToValue)
        
        for i in 0..<stringDates.count {
            dateFormatter.dateFormat = dateFormat
            if let finalDate = dateFormatter.date(from: stringDates[i]) {
                let finalDateStr = dateFormatter.string(from: finalDate)
                finalValsDates.append(finalDateStr)
            }else {
                finalValsDates.append("")
            }
        }
        return finalValsDates
    }
    
    /// preparing time values
    /// - Parameters:
    ///   - dateFormatter: format
    ///   - timeFormat: desired format
    /// - Returns: time values
    func prepareTimeValues(dateFormatter: DateFormatter, timeFormat: String) -> [String] {
        var finalValsTimes = [String]()
        var stringTimes = [String]()
        
        stringTimes.append("\(timeFromValue)")
        stringTimes.append("\(timeToValue)")
        
        for i in 0..<stringTimes.count {
            dateFormatter.dateFormat = timeFormat
            if let finalDate = dateFormatter.date(from: stringTimes[i]) {
                let finalDateStr = dateFormatter.string(from: finalDate)
                finalValsTimes.append(finalDateStr)
            }else {
                finalValsTimes.append("")
            }
        }
        return finalValsTimes
    }
    
    /// preparing date/time values
    /// - Returns: date/time values
    func prepareValues() -> ([String], [String]) {
        if let item = item as? FormViewModelDateItem, let dateFormat = item.dateFormat?.presentedSwiftFormat, let timeFormat = item.timeFormat?.presentedSwiftFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = timeZone_UTC
            dateFormatter.locale = Locale(identifier: "en_US")
            
            let dateValues = prepareDateValues(dateFormatter: dateFormatter,
                                               dateFormat: dateFormat)
            let timeValues = prepareTimeValues(dateFormatter: dateFormatter,
                                               timeFormat: timeFormat)
            
            return (dateValues, timeValues)
        }
        
        return ([], [])
    }
    
    /// validating date control
    func validate() {
        guard let item = item as? FormViewModelDateItem else { return }
        let finalValsDates = prepareValues().0
        let finalValsTimes = prepareValues().1
        let isValid = FormBuilder.shared.handleDatePickerValidation(item: item, finalDates: finalValsDates, finalTimes: finalValsTimes, row: item.fieldId)
        
        var fields: [UIView] = []
        if isValid.fieldsError.contains("dateFrom") { fields.append(dateFromContainerView) }
        if isValid.fieldsError.contains("dateTo") { fields.append(dateToContainerView) }
        if isValid.fieldsError.contains("timeFrom") { fields.append(timeFromContainerView) }
        if isValid.fieldsError.contains("timeTo") { fields.append(timeToContainerView) }
        setFieldsRequiredUI(fields: fields)
        
        if isValid.isError {
            errorView.isHidden = false
            errorLabel.text = isValid.errorMessage
            item.inLineError = isValid.isError
            item.errorMessageInline = isValid.errorMessage
            if let valueChanged = self.valueChanged {
                valueChanged(nil, true)
            }
            
        } else {
            errorView.isHidden = true
            item.inLineError = false
            item.errorMessageInline = ""
            submitValue()
        }
        validationChanged?(!isValid.isError)
    }
    
    /// submitting date/time values
    func submitValue() {
        let type: FormCalendarType = dateProperties?.calendarType ?? .Gregorian
        let finalValsDates = prepareValues().0
        let finalValsTimes = prepareValues().1
        self.item.isUpdated = true
        if let valueChanged = self.valueChanged {
            valueChanged(DateTimeAnswer(val: finalValsDates, timeValues: finalValsTimes, type: type), checkError())
        }
        startEdit = false
    }
    
    /// checking error
    /// - Returns: if error exist
    func checkError() -> Bool {
        if !errorLabel.isHidden {
            return true
        } else {
            return false
        }
    }
    
    /// setting up borders with red color for the empty fields in required item
    func setEmptyFieldsWarningUI() {
        guard let item = item as? FormViewModelDateItem, item.required else { return }
        var emptyViews: [UIView] = []
        if item.dateSelectionMode == .Single {
            if item.dateTimeType == .Date {
                if dateFromValue.isEmpty { emptyViews.append(dateFromContainerView) }
            } else if item.dateTimeType == .Time {
                if timeFromValue.isEmpty { emptyViews.append(timeFromContainerView) }
            } else {
                if dateFromValue.isEmpty { emptyViews.append(dateFromContainerView) }
                if timeFromValue.isEmpty { emptyViews.append(timeFromContainerView) }
            }
            
        } else {
            if item.dateTimeType == .Date {
                if dateFromValue.isEmpty { emptyViews.append(dateFromContainerView) }
                if dateToValue.isEmpty { emptyViews.append(dateToContainerView) }
            } else if item.dateTimeType == .Time {
                if timeFromValue.isEmpty { emptyViews.append(timeFromContainerView) }
                if timeToValue.isEmpty { emptyViews.append(timeToContainerView) }
            } else {
                if dateFromValue.isEmpty { emptyViews.append(dateFromContainerView) }
                if dateToValue.isEmpty { emptyViews.append(dateToContainerView) }
                if timeFromValue.isEmpty { emptyViews.append(timeFromContainerView) }
                if timeToValue.isEmpty { emptyViews.append(timeToContainerView) }
            }
        }
        
        setFieldsRequiredUI(fields: emptyViews)
    }
    
    /// handling picked 'date from'
    /// - Parameter date: picked date
    func handlePickedDateFrom(dates: [Date]) {
        var datesStr = [String]()
        var sortedDates = dates.sorted { $0 < $1 }
        if (item as? FormViewModelDateItem)?.dateSelectionMode == .Range {
            if let from = sortedDates.first { datesStr.append(getDateStr(date: from) ?? "") }
            if let to = sortedDates.last { datesStr.append(getDateStr(date: to) ?? "") }
            self.dateFromValue = datesStr.joined(separator: " - ")
        } else {
            for date in sortedDates {
                datesStr.append(getDateStr(date: date) ?? "")
            }
            self.dateFromValue = datesStr.joined(separator: ", ")
        }
        self.dateToValue = ""
        self.dateToValueTF.text = ""
        if let item = item as? FormViewModelDateItem {
            self.setupSubPlaceholder(item: item)
        }
    }
    
    /// handling picked 'date to'
    /// - Parameter date: picked date
    func handlePickedDateTo(date: Date) {
        self.dateToValue = self.getDateStr(date: date) ?? ""
    }
    
    /// checking if same date and time, them clear 'time to' if true
    func checkIfSameDateTimeThenClearTimeTo() {
        if timeToValue.isNotEmpty , timeFromValue.isNotEmpty, dateToValue == dateFromValue ,
           let timeTo = self.timeToValue.getDateFromString(),
           let timeFrom = self.timeFromValue.getDateFromString(),
           timeTo <= timeFrom {
            // Reset timeToValue
            self.timeToValue = ""
        }
    }
    
    /// getting max date in custom type in 'date from'
    /// - Parameters:
    ///   - dateCalendarType: calendar type
    ///   - formatter: format
    /// - Returns: max date
    func getMaxDateInCustomTypeInFromDate(dateCalendarType: Calendar.Identifier, formatter: DateFormatter) -> Date? {
        var max: Date?
        if let maximumDate = dateProperties?.maximumDate {
            if dateCalendarType == .gregorian {
                max = maximumDate.getDateFromString(dateFormatter: formatter)
            }else {
                max = HelperFunctions.convertDateToHijriDate(stringDate: maximumDate, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
            }
        }
        return max
    }
    
    /// getting min date in custom type in 'date from'
    /// - Parameters:
    ///   - dateCalendarType: calendar type
    ///   - formatter: format
    /// - Returns: min date
    func getMinDateInCustomTypeInFromDate(dateCalendarType: Calendar.Identifier, formatter: DateFormatter) -> Date? {
        var minimum: Date?
        if let minimumDate = dateProperties?.minimumDate {
            if dateCalendarType == .gregorian {
                minimum = minimumDate.getDateFromString(dateFormatter: formatter)
            }else {
                minimum = HelperFunctions.convertDateToGregorianDate(stringDate: minimumDate, format: (item as? FormViewModelDateItem)?.dateFormat?.swiftFormat, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
            }
            if let daysOffset = dateProperties?.openCalendarDaysOffset {
                minimum = Calendar.current.date(byAdding: .day, value: daysOffset, to: minimum ?? Date())
            }
        }else{
            if let daysOffset = dateProperties?.openCalendarDaysOffset {
                minimum = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date())
            }else {
                minimum = nil
            }
        }
        
        return minimum
    }
    
    /// getting current date in custom type in 'date from'
    /// - Parameter formatter: format
    /// - Returns: current date
    func getCurrentDateInCustomTypeInFromDate(dateCalendarType: Calendar.Identifier, maxDate: Date?, formatter: DateFormatter) -> [Date] {
        
        var finalDates = [Date]()
        if dateFromValue != "" {
            var dateArray = [String]()
            if (item as? FormViewModelDateItem)?.dateSelectionMode == .Range {
                dateArray = dateFromValue.components(separatedBy: " - ").map { $0.trimmingCharacters(in: .whitespaces) }
            } else {
                dateArray = dateFromValue.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            }
            for stringDate in dateArray {
                if dateCalendarType == .gregorian {
                    if let date = stringDate.getDateFromString(dateFormatter: formatter) { finalDates.append(date) }
                }else {
                    finalDates.append(HelperFunctions.convertDateToHijriDate(stringDate: stringDate, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat))
                }
            }
        } else {
            if dateCalendarType == .gregorian {
                if let maxDate {
                    maxDate < Date() ? (finalDates = [maxDate]) : (finalDates = [])
                }
            }else {
                let max = maxDate ?? Date()
                let maxString = formatter.string(from: max)
                let currentDateString = formatter.string(from: Date())
                maxDate ?? Date() < Date() ? (finalDates = [HelperFunctions.convertDateToHijriDate(stringDate: maxString, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)]) : (finalDates = [HelperFunctions.convertDateToHijriDate(stringDate: currentDateString, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)])
            }
        }
        return finalDates
    }
    
    /// getting current date in custom tyoe in 'date to'
    /// - Parameter formatter: format
    /// - Returns: current date
    func getCurrentDateInCustomTypeInToDate(maxDate: Date?, formatter: DateFormatter) -> Date {
        if dateToValue != "" {
            return dateToValue.getDateFromString(dateFormatter: formatter) ?? Date()
        } else {
            return maxDate ?? Date() < Date() ? maxDate ?? Date() : Date()
        }
    }
    
    /// getting min date in custom type in 'date to'
    /// - Parameter formatter: format
    /// - Returns: min date
    func getMinDateInCustomTypeInToDate( formatter: DateFormatter) -> Date? {
        var minDate: Date?
        if  dateFromValue != "" {
            if let newminmum = dateFromValue.getDateFromString(dateFormatter: formatter){
                minDate = newminmum
            }
        }else {
            if let daysOffset = dateProperties?.openCalendarDaysOffset {
                minDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date())
            }else {
                minDate = Date()
            }
        }
        
        return minDate
    }
    
    /// getting max date in custom type in 'date to'
    /// - Parameters:
    ///   - dateCalendarType: calendar type
    ///   - formatter: format
    /// - Returns: max date
    func getMaxDateInCustomTypeInToDate(dateCalendarType: Calendar.Identifier, formatter: DateFormatter) -> Date? {
        var max: Date?
        if let maximumDate = dateProperties?.maximumDate {
            if dateCalendarType == .gregorian {
                max = maximumDate.getDateFromString(dateFormatter: formatter)
            }else {
                max = HelperFunctions.convertDateToGregorianDate(stringDate: maximumDate, format: (item as? FormViewModelDateItem)?.dateFormat?.swiftFormat, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
            }
            return max
        }else{
            return nil
        }
    }
    
    /// getting min date in future type in 'date from'
    /// - Parameters:
    ///   - openCalendarDaysOffset: calendar days offset
    ///   - currentDate: current date
    ///   - calendar: calendar
    /// - Returns: min date
    func getMinDateInFutureTypeInFromDate(openCalendarDaysOffset: Int?, currentDates: [Date], calendar: Calendar) -> Date? {
        var minDate: Date?
        if let offset = openCalendarDaysOffset {
            minDate = calendar.date(byAdding: .day, value: offset, to: currentDates.first ?? Date())
        } else {
            minDate = currentDates.first
        }
        return minDate
    }
    
    /// getting min date in future type in 'date to'
    /// - Parameter formatter: format
    /// - Returns: min date
    func getMinDateInFutureTypeInToDate(formatter: DateFormatter) -> Date? {
        var minDate: Date?
        if  dateFromValue != "" {
            if let newminmum = dateFromValue.getDateFromString(dateFormatter: formatter){
                minDate = newminmum
            }
        }else {
            if let daysOffset = dateProperties?.openCalendarDaysOffset {
                minDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date())
            }else {
                minDate = Date()
            }
        }
        return minDate
    }
    
    /// getting max date in future type in 'date to'
    /// - Parameters:
    ///   - dateCalendarType: calendar type
    ///   - formatter: format
    /// - Returns: max date
    func getMaxDateInFutureTypeInToDate(dateCalendarType: Calendar.Identifier, formatter: DateFormatter) -> Date? {
        if let maximumDate = dateProperties?.maximumDate {
            var max: Date?
            if dateCalendarType == .gregorian {
                max = maximumDate.getDateFromString(dateFormatter: formatter)
            }else {
                max = HelperFunctions.convertDateToGregorianDate(stringDate: maximumDate, format: (item as? FormViewModelDateItem)?.dateFormat?.swiftFormat, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
            }
            return max
        }else{
            return nil
        }
    }
    
    /// getting current date in futrure and past types in 'date to'
    /// - Parameter formatter: format
    /// - Returns: current date
    func getCurrentDateInFutureAndPastInToDate(maxDate: Date?, formatter: DateFormatter) -> Date {
        if dateToValue != "" {
            return dateToValue.getDateFromString(dateFormatter: formatter) ?? Date()
        } else {
            return maxDate ?? Date() < Date() ? maxDate ?? Date() : Date()
        }
    }
    
    /// getting current date in futrure and past types in 'date From'
    /// - Parameter formatter: format
    /// - Returns: current date
    func getCurrentDateInFutureAndPastInFromDate() -> [Date] {
        var dates = [Date]()
        if dateFromValue != "" {
            let dateArray = dateFromValue.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
            for stringDate in dateArray {
                dates.append(stringDate.getDateFromString(dateFormatter: DateFormatter()) ?? Date())
            }
            return dates
        }
        return [Date()]
    }
    
    /// getting max date in past type in 'date from'
    /// - Parameters:
    ///   - openCalendarDaysOffset: calendar days offset
    ///   - currentDate: current date
    ///   - calendar: calendar
    /// - Returns: max date
    func getMaxDateInPastInFromDate(dateCalendarType: Calendar.Identifier, openCalendarDaysOffset: Int?, currentDate: Date, calendar: Calendar) -> Date? {
        if let offset = openCalendarDaysOffset {
            if dateCalendarType == .gregorian {
                return calendar.date(byAdding: .day, value: offset, to: currentDate)
            }else {
                let date = calendar.date(byAdding: .day, value: offset, to: currentDate) ?? Date()
                return HelperFunctions.convertDateToHijriDate(stringDate: date.toString(), presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
            }
        }
        if dateCalendarType == .gregorian {
            return Date()
        }else {
            return HelperFunctions.convertDateToHijriDate(stringDate: Date().toString(), presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
        }
    }
    
    /// getting min date in past type in 'date to'
    /// - Parameter formatter: format
    /// - Returns: min date
    func getMinDateInPastInToDate(formatter: DateFormatter) -> Date? {
        var minDate: Date?
        if  dateFromValue != "" {
            if let newminmum = dateFromValue.getDateFromString(dateFormatter: formatter){
                minDate = newminmum
            }
        }else {
            if let daysOffset = dateProperties?.openCalendarDaysOffset {
                minDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date())
            }else {
                minDate = Date()
            }
        }
        return minDate
    }
    
    /// getting max date in past type in 'date to'
    /// - Parameters:
    ///   - dateCalendarType: calendar type
    ///   - formatter: format
    /// - Returns: max date
    func getMaxDateInPastInToDate(dateCalendarType: Calendar.Identifier,formatter: DateFormatter) -> Date? {
        var maxDate: Date?
        if let maximumDate = dateProperties?.maximumDate {
            var max: Date?
            if dateCalendarType == .gregorian {
                max = maximumDate.getDateFromString(dateFormatter: formatter)
            }else {
                max = HelperFunctions.convertDateToGregorianDate(stringDate: maximumDate, format: (item as? FormViewModelDateItem)?.dateFormat?.swiftFormat, presentedFormat: (item as? FormViewModelDateItem)?.dateFormat?.presentedSwiftFormat)
            }
            maxDate = max
        }else{
            maxDate = Date()
        }
        
        return maxDate
    }
    
    /// presenting date picker
    /// - Parameter isFromDate: checking if it was 'date from'
    func openDatePicker(isFromDate: Bool) {
        let calendarVC = CustomCalender()
        var dateCalendarType: Calendar.Identifier = .gregorian
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = dateFormatterLocal_en_US
        if let format = dateProperties?.dateFormat?.presentedSwiftFormat {
            formatter.dateFormat = format
        }
        if let type = dateProperties?.calendarType {
            switch type {
            case .Gregorian:
                dateCalendarType = .gregorian
            case .Hijri:
                dateCalendarType = hijriCalendarType
            default: break
                
            }
        }
        
        calendarVC.didPickDate = {[weak self] dates in
            guard let `self` = self else {return}
            if let format = self.dateProperties?.dateFormat?.swiftFormat {
                formatter.dateFormat = format
                formatter.calendar = .init(identifier: dateCalendarType)
                
                if isFromDate { // Set From Date
                    handlePickedDateFrom(dates: dates)
                } else {
                    handlePickedDateTo(date: dates.first ?? Date())
                    checkIfSameDateTimeThenClearTimeTo()
                }
            }
            startEdit = true
            self.validate()
        }
        
        var minDate: Date? = nil
        var maxDate: Date? = nil
        var currentDates = [Date]()
        let calendar = Calendar.current
        var openCalendarDaysOffset: Int?
        guard let item = item as? FormViewModelDateItem else { return }
        switch item.dateProperties?.validationType {
        case .Custom, nil:
            if isFromDate{
                
                maxDate = getMaxDateInCustomTypeInFromDate(dateCalendarType: dateCalendarType,
                                                           formatter: formatter)
                minDate = getMinDateInCustomTypeInFromDate(dateCalendarType: dateCalendarType,
                                                           formatter: formatter)
                currentDates = getCurrentDateInCustomTypeInFromDate(dateCalendarType: dateCalendarType, maxDate: maxDate, formatter: formatter)
                
            }else { // To Date
                // To Date MUST BE > From Date
                
                minDate = getMinDateInCustomTypeInToDate(formatter: formatter)
                maxDate = getMaxDateInCustomTypeInToDate(dateCalendarType: dateCalendarType,
                                                         formatter: formatter)
                currentDates = [getCurrentDateInCustomTypeInToDate(maxDate: maxDate, formatter: formatter)]
                
            }
            
        case .Future:
            if isFromDate {
                openCalendarDaysOffset = item.dateProperties?.openCalendarDaysOffset
                minDate = getMinDateInFutureTypeInFromDate(openCalendarDaysOffset: openCalendarDaysOffset,
                                                           currentDates: currentDates,
                                                           calendar: calendar)
                maxDate = nil
//                if openCalendarDaysOffset == nil {
                currentDates = getCurrentDateInCustomTypeInFromDate(dateCalendarType: dateCalendarType, maxDate: maxDate, formatter: formatter)
//                }else {
//                    
//                }
            } else {
                // To Date MUST BE > From Date
                minDate = getMinDateInFutureTypeInToDate(formatter: formatter)
                maxDate = getMaxDateInFutureTypeInToDate(dateCalendarType: dateCalendarType,
                                                         formatter: formatter)
                currentDates = [getCurrentDateInFutureAndPastInToDate(maxDate: maxDate, formatter: formatter)]
            }
            
        case .Past:
            if isFromDate {
                openCalendarDaysOffset = item.dateProperties?.openCalendarDaysOffset
                maxDate = getMaxDateInPastInFromDate(dateCalendarType: dateCalendarType,
                                                     openCalendarDaysOffset: openCalendarDaysOffset,
                                                     currentDate: currentDates.first ?? Date(),
                                                     calendar: calendar)
                minDate = nil
                //                if openCalendarDaysOffset == nil {
                currentDates = getCurrentDateInCustomTypeInFromDate(dateCalendarType: dateCalendarType, maxDate: maxDate, formatter: formatter)
                //                }else {
                //                    if let maxDate = maxDate {
                //                        currentDate = maxDate
                //                    }
                //                }
            } else {
                // To Date MUST BE > From Date
                minDate = getMinDateInPastInToDate(formatter: formatter)
                maxDate = getMaxDateInPastInToDate(dateCalendarType: dateCalendarType, formatter: formatter)
                currentDates = [getCurrentDateInFutureAndPastInToDate(maxDate: maxDate, formatter: formatter)]
            }
        }
        
        var presenterView = BottomSheetVCCerqel()
        if let formVC = self.formVC {
            presenterView = formVC
        }else if let nestedformVC = nestedFormVC {
            presenterView = nestedformVC
        }
        
        
        calendarVC.showDate(vc: presenterView,
                            sender: nil,
                            dateCalendarType: dateProperties?.calendarType ?? .Gregorian,
                            minimum: minDate,
                            maximum: maxDate,
                            currentDates: currentDates,
                            disabledDates:  dateProperties?.disabledDates,
                            disabledDays:/*dateProperties?.disabledDays*/[6,7],
                            disabledMonths: dateProperties?.disabledMonths,
                            disabledDaysOfMonth: dateProperties?.disabledDaysOfMonth,
                            presentedFormat: dateProperties?.dateFormat?.presentedSwiftFormat,
                            regularFormat: dateProperties?.dateFormat?.swiftFormat,
                            from: isFromDate,
                            firstWeekday: dateProperties?.firstDayOfWeek,
                            selectionMode: item.dateSelectionMode)
    }
    
    /// handling disabled item appearance
    /// - Parameter disabled: if it's disabled or not
    func handleDisabledDateControl(disabled:Bool){
        dateFromContainerView.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        dateToContainerView.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        timeFromContainerView.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        timeToContainerView.backgroundColor = disabled ? #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .clear
        dateFromBtn.isUserInteractionEnabled = disabled ? false : true
        dateToBtn.isUserInteractionEnabled = disabled ? false : true
        timeFromBtn.isUserInteractionEnabled = disabled ? false : true
        timeToBtn.isUserInteractionEnabled = disabled ? false : true
    }
    
    /// extracting time
    /// - Parameter value: time value
    /// - Returns: time result
    func extractTimeOrFull(from value: String) -> String {
        let components = value.split(separator: " ")
        
        // If there are two components, return only the time (second component)
        if components.count == 2 {
            return String(components[1]) // Return time part (e.g., "15:00")
        }
        
        // Otherwise, return the full value (if no date is present, assume it's just time)
        return value
    }
    
    /// presenting time picker
    /// - Parameter isFromTime: checking is it 'time from' or not
    func openTimePicker(isFromTime: Bool) {
        let picker = NewDatePickerPopup.instance()
        let dateCalendarType: Calendar.Identifier = .gregorian
        let formatter = DateFormatter()
        
        formatter.timeZone = timeZone_UTC
        formatter.locale = dateFormatterLocal_en_US
        
        picker.didPickDate = { date in
            if let format = self.dateProperties?.timeFormat?.presentedSwiftFormat {
                formatter.dateFormat = format
                formatter.calendar = .init(identifier: dateCalendarType)
                
                if isFromTime { // Set From Date
                    self.timeFromValue = self.getTimeStr(date: date) ?? ""
                    
                    // Check if timeToValue exists and is before the new timeFromValue
                    if let timeTo = self.timeToValue.getDateFromString(),
                       let timeFrom = self.timeFromValue.getDateFromString(),
                       timeTo <= timeFrom {
                        // Reset timeToValue
                        self.timeToValue = ""
                    }
                } else { // Set To Date
                    self.timeToValue = self.getTimeStr(date: date) ?? ""
                }
            }
            
            self.startEdit = true
            self.validate()
        }
        
        var minTime: Date? = nil
        var maxTime: Date? = nil
        var currentDate = Date()
        
        // Get minimum and maximum times from date properties
        minTime = extractTimeOrFull(from: dateProperties?.minimumTime ?? "").getDateUseringFormat(format: dateProperties?.timeFormat?.presentedSwiftFormat ?? "") ?? nil
        maxTime = extractTimeOrFull(from: dateProperties?.maximumTime ?? "").getDateUseringFormat(format: dateProperties?.timeFormat?.presentedSwiftFormat ?? "") ?? nil
        
        if isFromTime {
            // From Time Logic
            if let timeTo = timeToValue.getDateFromString(),
               let _ = dateProperties?.timeFormat?.presentedSwiftFormat {
                maxTime = timeTo
            }
            
            currentDate = timeFromValue.getTimeFromString() ?? "12:00".getTimeFromString()!
        } else {
            // To Time Logic
            if let timeFrom = timeFromValue.getDateFromString(),
               let _ = dateProperties?.timeFormat?.presentedSwiftFormat {
                // Set minimum time to 30 minutes after timeFromValue
                minTime = Calendar.current.date(byAdding: .minute, value: 30, to: timeFrom)
            }
            
            currentDate = timeToValue.getTimeFromString() ?? "12:00".getTimeFromString()!
        }
        
        // Additional validation for minimum and maximum times based on minimumDate
        
        if isFromTime  {
            minTime = nil
            maxTime = nil
        }
        if !isFromTime , dateToValue.isNotEmpty , dateFromValue.isNotEmpty, dateToValue != dateFromValue {
            minTime = nil
            maxTime = nil
        }
        
        var presenterView = BottomSheetVCCerqel()
        
        // Show the picker based on the current form view controller
        if let formVC = formVC {
            presenterView = formVC
        } else if let nestedformVC = nestedFormVC {
            presenterView = nestedformVC
        }
        picker.showDate(vc: presenterView,
                        sender: nil,
                        mode: .time,
                        minimum:  minTime,
                        maximum:   maxTime,
                        currentDate: currentDate,
                        disabledDates: dateProperties?.disabledDates,
                        disabledDays: dateProperties?.disabledDays,
                        presentedFormat: dateProperties?.timeFormat?.presentedSwiftFormat,
                        regularFormat: dateProperties?.dateFormat?.swiftFormat)
    }
    
    
    // MARK: - IBActions
    
    /// fired when user press 'date from' button
    @IBAction func didTapFromDateBtn() {
        openDatePicker(isFromDate: true)
    }
    
    /// fired when user press 'date to' button
    @IBAction func didTapToDateBtn() {
        openDatePicker(isFromDate: false)
    }
    
    /// fired when user press 'time from' button
    @IBAction func didTapFromTimeBtn() {
        openTimePicker(isFromTime: true)
    }
    
    /// fired when user press 'time to' button
    @IBAction func didTapToTimeBtn() {
        openTimePicker(isFromTime: false)
    }
    
    /// fired when user press on item's title label
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    /// fired when user press on tool tip button
    /// - Parameter sender: tool tip button
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
}


extension NewDatePickerTVCell: ValidatableCell {
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
        errorLabel.text = message
    }

    func clearValidationError() {
        errorView.isHidden = true
        errorLabel.text = ""
    }
}

