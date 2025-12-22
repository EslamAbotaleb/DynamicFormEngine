//
//  DatePickerTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 4/4/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class DatePickerTVcell: ControlTVcell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!

    var didTapDate:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueTF.cerqel_addIconView(img: UIImage(named: "callenadrr")!, isRight: true)
        valueTF.cerqel_addEmptyView(isLeft: true, width: 8)

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
    
    func configureTimeOffExamDate(examDate: String?) {
        self.titleLbl.text = "Date Of Exam".localized
        self.descriptionLbl.text = ""
        self.valueTF.placeholder = "Enter date of exam".localized
        if let dateOfExam = examDate {
            self.valueTF.text = dateOfExam
        }
    }
    
    @IBAction func didTapFromDateBtn(){
        didTapDate?()
    }
    
}
