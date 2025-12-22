//
//  ActionControlTVcell.swift
//
//
//  Created by iSlam AbdelAziz on 12/31/20.
//  Copyright © 2020 All rights reserved.
//

import UIKit

class ActionControlTVcell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var nameValueLbl: UILabel!
    @IBOutlet weak var attValueBtn: UIButton!
    @IBOutlet weak var attView: UIView!
    @IBOutlet weak var backgView: UIView!
    
    // MARK: - Variables
    var isSectionItem = false
    var attUrl: String? // tapped attachment url
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Functions
    
    
    /// Configure Control's properties
    /// - Parameter properties: Control's properties
    func configure(properties: BackwardProperties?) {
        let localization = properties?.localization
        if !isArabic() {
            if let localizedLabel = localization?.en?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }else {
            if let localizedLabel = localization?.ar?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }
        
        if let ans = properties?.defaultAnswer?.defaultValue {
            handleAnswers(ans: ans)
        }
    }
    
    /// Configure Control's properties
    /// - Parameter properties: Control's properties
    func configure(properties: Properties?) {
        backgView.backgroundColor = isSectionItem ? .white : .primaryLight
        updateConstraintsForSectionItem()
        let localization = properties?.localization
        if !isArabic() {
            if let localizedLabel = localization?.en?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }else {
            if let localizedLabel = localization?.ar?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }
        
        if  (properties != nil) {
            handleAnswersForView(properties: properties!)
        }
    }
    
    private func updateConstraintsForSectionItem() {
        backgView.translatesAutoresizingMaskIntoConstraints = false
        if isSectionItem {
            NSLayoutConstraint.activate([
                backgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                backgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = true
            NSLayoutConstraint.deactivate([
                backgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                backgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    }
    
    
    /// Handle Control's answer
    /// - Parameter ans: Control's answer
    func handleAnswers(ans: ValueType) {
        switch ans {
            
        case .double(let doubles):
            var str = ""
            for double in doubles {
                str.append("\(double) \n")
            }
            
            nameValueLbl.text = str
        case .singleDouble(let double):
            nameValueLbl.text = "\(double)"
            
        case .singleBool(let singleBool):
            nameValueLbl.text = "\(singleBool)"
            
        case .listOfString(let strs):
            var str = ""
            for string in strs {
                str.append("\(string) \n")
            }
            nameValueLbl.text = str
            
        case .ddl(let ddl):
            var str = ""
            for val in ddl.Value ?? [] {
                var stringVal = ""
                if isArabic() {
                    stringVal = val.name_ar ?? ""
                }else {
                    stringVal = val.name ?? ""
                }
                str.append("\(stringVal) \n")
            }
            nameValueLbl.text = str
            
        case .bcDDL(let ddl):
            var str = ""
            for val in ddl.Value ?? [] {
                var stringVal = ""
                if isArabic() {
                    stringVal = val.name_ar ?? ""
                }else {
                    stringVal = val.name ?? ""
                }
                str.append("\(stringVal) \n")
            }
            nameValueLbl.text = str

        case .dictionary(let dicts):
            var str = ""
            for dict in dicts {
                if let fdateVal = dict["from"], let tdateVal = dict["to"] {
                    str.append("\("From".localized) : \(fdateVal)\n")
                    str.append("\("To".localized) : \(tdateVal)\n")
                }else {
                    var val = ""
                    if isArabic() {
                        val = (dict["text"] ?? dict["name_ar"] ?? dict["nameAR"] ?? "") ?? ""
                    }else {
                        val = (dict["text"] ?? dict["name"] ?? dict["nameEN"] ?? "") ?? ""
                    }
                    str.append("\(val) \n")
                }
            }
            nameValueLbl.text = str
        case .singleString(let str):
            nameValueLbl.text = str
        case .bool(let bools):
            var str = ""
            for val in bools {
                str.append("\(val) \n")
            }
            nameValueLbl.text = str
        case .file, .empty:
            return
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameValueLbl.text = ""
    }
    
    /// Handle Control's answer For View
    /// - Parameter ans: Control's answer
    func handleAnswersForView(properties: Properties) {
        let ans = properties.defaultAnswer?.defaultValue
        switch ans {
            
        case .double(let doubles):
            var str = ""
            for double in doubles {
                str.append("\(double) \n")
            }
            
            nameValueLbl.text = str
        case .singleDouble(let double):
            nameValueLbl.text = "\(double)"
            
        case .singleBool(let singleBool):
            nameValueLbl.text = "\(singleBool)"
            
        case .listOfString(let strs):
            if(properties.defaultAnswer?.type == "Dropdown" || properties.defaultAnswer?.type == "Checkbox" || properties.defaultAnswer?.type == "Radio"){
                nameValueLbl.text = handleAnswersFromOptions(id:strs,properties: properties)
            }
            else {
                if properties.defaultAnswer?.type?.lowercased() == "dateTime".lowercased() {
                    nameValueLbl.text =  formattedString(from: strs)
                    return
                }
                var str = ""
                for string in strs {
                    str.append("\(string) \n")
                }
                nameValueLbl.text = str
            }
           
        case .ddl(let ddl):
            var str = ""
            for val in ddl.Value ?? [] {
                var stringVal = ""
                if isArabic() {
                    stringVal = val.name_ar ?? ""
                }else {
                    stringVal = val.name ?? ""
                }
                str.append("\(stringVal) \n")
            }
            nameValueLbl.text = str

        case .bcDDL(let ddl):
            var str = ""
            for val in ddl.Value ?? [] {
                var stringVal = ""
                if isArabic() {
                    stringVal = val.name_ar ?? ""
                }else {
                    stringVal = val.name ?? ""
                }
                str.append("\(stringVal) \n")
            }
            nameValueLbl.text = str

        case .dictionary(let dicts):
            var str = ""

            for dict in dicts {
                if let fdateVal = dict["from"], let tdateVal = dict["to"] {
                    var fromDate = fdateVal
                    var toDate = tdateVal
                    
                    // Check dateTimeType
                    if properties.dateTimeType?.lowercased() == "date" {
                        // Remove time from "from" and "to"
                        fromDate = String(fdateVal!.prefix(10))  // Extract date part only (e.g., "05-09-2030")
                        toDate = String(tdateVal!.prefix(10))  // Extract date part only (e.g., "06-09-2024")
                    } else if properties.dateTimeType?.lowercased() == "time" {
                        // Keep only time part (e.g., "00:00")
                        fromDate = String(fdateVal!.suffix(5))  // Extract time part only
                        toDate = String(tdateVal!.suffix(5))  // Extract time part only
                    }

                    str.append("\("From".localized) : \(fromDate)\n")
                    str.append("\("To".localized) : \(toDate)\n")
                } else {
                    var val = ""
                    if isArabic() {
                        val = (dict["text"] ?? dict["name_ar"] ?? dict["nameAR"] ?? "") ?? ""
                    } else {
                        val = (dict["text"] ?? dict["name"] ?? dict["nameEN"] ?? "") ?? ""
                    }
                    str.append("\(val) \n")
                }
            }
            nameValueLbl.text = str
        case .singleString(let str):
            nameValueLbl.text = str
        case .bool(let bools):
            var str = ""
            for val in bools {
                str.append("\(val) \n")
            }
            nameValueLbl.text = str
        case .file, .empty:
            return
        case .none:
            return
        }
    }
    
    func handleAnswersFromOptions(id:[String],properties: Properties) -> String{
        var result = ""
        for string in id {
            let val = properties.options?.first(where: { item in
                item.id == string
            })?.name
            result.append("\(val ?? "_") \n")
        }
        return result
    }
    
    
    /// Configure cell with submittedControls into Previous Actions
    /// - Parameter jsonArray: submittedControls
    func config(jsonArray: TaskSubmittedRowDataModel) {
        //        guard let json = jsonArray.first else {return}
        nameTitleLbl.text = jsonArray.name ?? ""
        if let ans = jsonArray.value {
            handleAnswers(ans: ans)
        }
    }
    

    // MARK: - IBActions
    
    @IBAction func attBtnTapped(){
        openAttachment(withURLString: (self.attUrl ?? "").CreateMediaURL())
    }
    
    func formatDates(array: [String]) -> [String: String]? {
        guard let firstDateString = array.first else {
            return nil
        }
        
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let readableFormatter = DateFormatter()
        readableFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let firstDate = isoFormatter.date(from: firstDateString) {
            // If the date string is in ISO format, convert it to readable format
            let from = readableFormatter.string(from: firstDate)
            if array.count == 1 {
                return ["from": from]
            } else if let lastDateString = array.last, let lastDate = isoFormatter.date(from: lastDateString) {
                let to = readableFormatter.string(from: lastDate)
                return ["from": from, "to": to]
            }
        } else {
            // If the date string is already in readable format
            if array.count == 1 {
                return ["from": firstDateString]
            } else if let lastDateString = array.last {
                return ["from": firstDateString, "to": lastDateString]
            }
        }
        
        return nil
    }
    
    func formattedString(from array: [String]) -> String {
        // Assuming formatDates is a function that returns a dictionary with "from" and "to" as keys
        guard let formattedDates = formatDates(array: array) else {
            return ""
        }
        var str = ""
        // Check and append "from" first if available
        if let fromDate = formattedDates["from"] {
            str.append("from: \(fromDate) \n")
        }
        
        // Check and append "to" second if available
        if let toDate = formattedDates["to"] {
            str.append("to: \(toDate) \n")
        }
        return str
    }
}
