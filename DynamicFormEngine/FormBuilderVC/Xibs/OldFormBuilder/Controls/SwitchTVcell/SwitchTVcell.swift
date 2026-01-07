//
//  SwitchTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 4/6/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class SwitchTVcell: ControlTVcell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var valueSwitch: UISwitch!
    
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
        self.titleLbl.text = control.label

        self.controlData = control
        
        if let val = control.value as? [Bool], let ison = val.first{
            valueSwitch.setOn(ison, animated: true)
        }else{
            valueSwitch.setOn(false, animated: true)

        }
        
        if !control.isValid, let _ = control.notValidType{
            bgView.borderColorV = .red

        }else{
            bgView.borderColorV = .clear
        }
        
        if control.readOnly ?? false{
            bgView.backgroundColor = .veryLightPink
        }else{
            bgView.backgroundColor = .white
        }
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        print("SWTCH IS \(sender.isOn)")
        self.controlData.value = [sender.isOn]
        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
            self.didChangeText?(sender.isOn, isValid, inValidCon, notValidConditionName)
        }
    }
}
