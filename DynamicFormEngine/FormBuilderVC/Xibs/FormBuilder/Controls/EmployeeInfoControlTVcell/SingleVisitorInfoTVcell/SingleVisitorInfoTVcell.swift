//
//  SingleVisitorInfoTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 16/08/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class SingleVisitorInfoTVcell: UITableViewCell {

    static let cellHeight = 283
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idNumberTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    
    @IBOutlet weak var removeView: UIView!
    @IBOutlet weak var removeBtn: UIButton!

    var didChangeMyValue: ((VisitorInfoCerqel?)->())?
    var didTapRemove: (()->())?
    
    var visitorData: VisitorInfoCerqel?{
        didSet{
            print("Visitorrrr: \(visitorData.debugDescription)")
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTF.keyboardType = .default
        idNumberTF.keyboardType = .numberPad
        mobileTF.keyboardType = .phonePad
        
    }
    
    func configure(_ item: VisitorInfoCerqel?){
        nameTF.text = item?.name
        idNumberTF.text = item?.nationalPassport
        mobileTF.text = item?.mobileNumber
        self.visitorData = item
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func removeBtnTapped(){
        didTapRemove?()
    }
}


extension SingleVisitorInfoTVcell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF{
            self.visitorData?.name = nameTF.text
        }else if textField == idNumberTF{
            self.visitorData?.nationalPassport = idNumberTF.text

        }else if textField == mobileTF{
            self.visitorData?.mobileNumber = mobileTF.text
        }
        didChangeMyValue?(self.visitorData)

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            if textField == idNumberTF || textField == mobileTF{
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
        

        
        guard range.location == 0, let txt = textField.text else {
            return true
        }

        let newString = (txt as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0

    }
}
