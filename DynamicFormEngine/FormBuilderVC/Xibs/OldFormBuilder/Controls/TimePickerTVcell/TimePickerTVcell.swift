//
//  TimePickerTVcell.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 4/18/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class TimePickerTVcell: ControlTVcell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!

    var didTapTime:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueTF.cerqel_addIconView(img: UIImage(named: "clock (2) 1")!, isRight: true)
        valueTF.cerqel_addIconView(img: UIImage())

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        valueTF.placeholder = control.placeHolder
        self.controlData = control
        
        if let val = control.value as? [String]{
            valueTF.text = val.first
        }else{
            valueTF.text = ""
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
    
    @IBAction func didTapFromDateBtn(){
        didTapTime?()
    }
    
}
