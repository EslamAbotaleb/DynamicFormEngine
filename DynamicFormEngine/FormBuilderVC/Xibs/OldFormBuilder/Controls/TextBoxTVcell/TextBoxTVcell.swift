//
//  TextBoxTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/27/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class TextBoxTVcell: ControlTVcell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!

    var didChangeText: ((_ text: String, _ isValid: Bool, _ inValidCon: ValidationsCerqel?, _ notValidCondName: ValidationName?)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
//        if let vals = control.validations{
//            if let _ = vals.firstIndex(where: {$0.name == .required}){
//                let st = control.label ?? ""
//                let last = " *"
//
//                let firstAttributes: [NSAttributedString.Key: Any] = [:]
//                let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
//
//                let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
//                let lastString = NSMutableAttributedString(string: last, attributes: secondAttributes)
//
//                firstString.append(lastString)
//
//                self.titleLbl.attributedText = firstString
//
//            }
//        }

        self.valueTF.placeholder = control.placeHolder
        self.controlData = control
        
        if let val = control.value as? [String], val.count > 0{
            valueTF.text = val.first
            if val.first != ""{
                checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
//                    control.isValid = isValid
                    //                                self.didChangeText?(val.first ?? "", isValid, inValidCon, notValidConditionName)
                }
            }
        }else{
            valueTF.text = ""
        }
        if let contentType = control.contentType{
            if contentType == .number{
                valueTF.keyboardType = .numberPad
            }else{
                valueTF.keyboardType = .default
            }
        }else{
            valueTF.keyboardType = .default
        }
        
        
        if !control.isValid, let _ = control.notValidType{
            valueTF.borderColorV = .red

        }else{
            valueTF.borderColorV = .clear
        }
        
        if control.readOnly ?? false{
            valueTF.backgroundColor = .veryLightPink
        }else{
            valueTF.backgroundColor = .white
        }
    }
}


extension TextBoxTVcell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
        self.controlData.value = [textField.text]
        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
            self.didChangeText?(textField.text ?? "", isValid, inValidCon, notValidConditionName)
        }
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let contentType = controlData.contentType{
            if contentType == .number{
                valueTF.keyboardType = .numberPad
            }else{
                valueTF.keyboardType = .default
            }
        }else{
            valueTF.keyboardType = .default
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let contentType = controlData.contentType{
            if contentType == .number{
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
        }

        
        guard range.location == 0, let txt = textField.text else {
            return true
        }

        let newString = (txt as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0

    }

}
