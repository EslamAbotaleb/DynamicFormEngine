//
//  TextAreaTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 2/19/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class TextAreaTVcell: ControlTVcell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextView!

    var didChangeText: ((_ text: String, _ isValid: Bool, _ inValidCon: ValidationsCerqel, _ notValidCondName: ValidationName?)->())?

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

        self.controlData = control
        
        if let val = control.value as? [String], let fir = val.first, fir != ""{
            valueTF.text = val.first
            valueTF.textColor = .DarkBlack
        }else{
            valueTF.textColor = UIColor.slate_grey.withAlphaComponent(0.4)
            valueTF.text = control.placeHolder
            
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
            valueTF.borderColorV = .light_periwinkle
        }

    }
}


extension TextAreaTVcell: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView.text)
        var tex = ""
        if textView.text == self.controlData.placeHolder{
            tex = ""
        }else{
            tex = textView.text
        }
        self.controlData.value = [tex]
        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName)  in
            self.didChangeText?(tex, isValid, inValidCon, notValidConditionName)
            
        }

    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.controlData.placeHolder{
            textView.text.removeAll()
            textView.textColor = .DarkBlack
        }
        
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
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0{
            textView.text = self.controlData.placeHolder
            textView.textColor = UIColor.slate_grey.withAlphaComponent(0.4)
        }
        return true
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // as @nhgrif suggested, we can skip the string manipulations if
        // the beginning of the textView.text is not touched.
        guard range.location == 0 else {
            return true
        }

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
    }

}
