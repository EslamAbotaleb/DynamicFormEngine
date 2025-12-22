//
//  CheckBoxControlTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 6/6/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class CheckBoxControlTVcell: ControlTVcell {
    
    @IBOutlet weak var ttlLbl: UILabel!
    @IBOutlet weak var selectionImgView: UIImageView!
    @IBOutlet weak var bgView: UIView!

    var didChangeText: ((_ value: Bool, _ isValid: Bool, _ inValidCon: ValidationsCerqel, _ notValidCondName: ValidationName?)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        self.ttlLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        self.controlData = control
        if let val = control.value as? [Bool], let bl = val.first{
            selectionImgView.isHighlighted = bl
        }else{
            selectionImgView.isHighlighted = false
        }
        
        if !control.isValid, let _ = control.notValidType{
            bgView.borderColorV = .red

        }else{
            bgView.borderColorV = .clear
        }

    }
    
    @IBAction func selectionBtnTapped(){
        let val = (controlData.value as? [Bool])?.first ?? false
        let newValue = val ? false : true
        self.controlData.value = [newValue]
        selectionImgView.isHighlighted = newValue

        
        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
            self.didChangeText?(newValue, isValid, inValidCon, notValidConditionName)
        }
        
    }
    
}
