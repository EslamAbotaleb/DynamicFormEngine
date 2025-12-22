//
//  ControlTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/24/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class ControlTVcell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!

    var controlData: ModelControlCerqel!{
        didSet{
            if controlData.readOnly ?? false{
                self.isUserInteractionEnabled = false
            }else{
                self.isUserInteractionEnabled = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(control: ModelControlCerqel) {
        fatalError("You did not override configure method.. ")
    }

    
    func checkValidation(control: ModelControlCerqel, completion: @escaping(Bool, [ValidationsCerqel], ValidationsCerqel, ValidationName?)->Void){
        var isValid = false
        var inValidType: ValidationName?
        var inValidCondition = ValidationsCerqel()
        if var conds = control.validations, conds.count > 0{
            for i in 0 ... conds.count - 1{
                switch conds[i].name{
                case .required:
                    if let value = control.value{
                        if let arr = value as? [String], let str = arr.first{
                            if control.type == .DateRangePicker{
                                if arr.count > 1, str != "", arr[1] != ""{
                                    conds[i].isValid = true
                                }else{
                                    conds[i].isValid = false
                                    inValidType = .required
                                }
                            }else if str.count > 0{
                                conds[i].isValid = true
                            }else{
                                conds[i].isValid = false
                                inValidType = .required
                            }
                        }else if let arr = value as? [Bool], let flag = arr.first{
                            conds[i].isValid = flag
                        } else if let arr = value as? [OptionsCerqel], let f = arr.first {
                            if f.key == nil  && f.text == nil {
                                conds[i].isValid = false
                                inValidType = .required
                            }else {
                                conds[i].isValid = true
                            }
                        }else if let arr = value as? [SearchControlResultCerqel], let f = arr.first {
                            conds[i].isValid = true
                        } else if let arra = value as? [ReqDetailsAttachmentValueCerqel], let f = arra.first {
                            if f.url == nil {
                                conds[i].isValid = false
                                inValidType = .required
                            } else {
                                conds[i].isValid = true
                            }
                        } else {
                            conds[i].isValid = true
                        }
                    }else{
                        conds[i].isValid = false
                        inValidType = .required
                    }
                    
                    
                case .pattern:
                    if let value = control.value as? [String] , let pattern = conds[i].value{
                        let regEx = pattern
                        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
                        if let str = value.first{
                            conds[i].isValid = test.evaluate(with: str)
                        }
                    }else{
                        conds[i].isValid = false
                    }

                case .minlength:
                    if let arr = control.value as? [String], let value = arr.first, !value.isEmpty{
                        if let min = Int(conds[i].value ?? ""), value.count >= min{
                            conds[i].isValid = true
                        }else{
                            conds[i].isValid = false
                            if inValidType == nil{
                                inValidType = .minlength
                            }
                        }
                    }else{
                        conds[i].isValid = true
                    }
                case .maxlength:
                    if let arr = control.value as? [String], let value = arr.first, !value.isEmpty{
                        
                        if let max = Int(conds[i].value ?? ""), value.count <= max{
                            conds[i].isValid = true
                        }else{
                            conds[i].isValid = false
                            if inValidType == nil{
                                inValidType = .maxlength
                            }
                        }
                    }else{
                        conds[i].isValid = true
                    }

                case .min:
                    if let valueStr = control.value as? String, let value = Int(valueStr), let min = conds[i].value as? Int, value >= min {
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .min
                        }

                    }

                case .max:
                    if let valueStr = control.value as? String, let value = Int(valueStr), let min = conds[i].value as? Int, value <= min {
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .max
                        }

                    }

                case .dateRangeFrom_required:
                    if let arr = control.value as? [String], let value = arr.first, !value.isEmpty{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .dateRangeFrom_required
                        }
                    }

                case .dateFrom_required:
                    if let arr = control.value as? [String], let value = arr.first, !value.isEmpty{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .dateFrom_required
                        }
                    }

                case .timeFrom_required:
                    if let arr = control.value as? [String], let value = arr.first, !value.isEmpty{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .timeFrom_required
                        }
                    }

                case .dateRangeTo_required:
                    if let arr = control.value as? [String], arr.count >= 2, !arr[1].isEmpty{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .dateRangeTo_required
                        }
                    }

                case .dateTo_required:
                    if let arr = control.value as? [String], arr.count >= 2, !arr[1].isEmpty{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .dateTo_required
                        }
                    }

                case .timeTo_required:
                    if let arr = control.value as? [String], arr.count >= 2, !arr[1].isEmpty{
                        conds[i].isValid = true
                    }else{
                        conds[i].isValid = false
                        if inValidType == nil{
                            inValidType = .timeTo_required
                        }
                    }

                default:
                    print("\(conds[i].name) IS NOT HANDLED IN CHECK MY VALIDATION IN CONTROL TV CELL !!!!!!! 🔥")
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
            completion(true, [], ValidationsCerqel(), nil)
        }
    }

    
}
