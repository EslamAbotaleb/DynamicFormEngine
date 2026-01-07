//
//  RangeDatePickerTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 4/7/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class RangeDatePickerTVcell: ControlTVcell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var fromValueTF: UITextField!
    @IBOutlet weak var toValueTF: UITextField!

    var didTapDate:((Bool)->())? // if true -> From date else To date

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fromValueTF.cerqel_addIconView(img: UIImage(named: "callenadrr")!, isRight: true)
        fromValueTF.cerqel_addIconView(img: UIImage())

        toValueTF.cerqel_addIconView(img: UIImage(named: "callenadrr")!, isRight: true)
        toValueTF.cerqel_addIconView(img: UIImage())

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
//        fromValueTF.placeholder = control.placeHolder
//        toValueTF.placeholder = control.placeHolder
        self.controlData = control
        
        if let val = control.value as? [String]{
            fromValueTF.text = val.first
            if val.count >= 2{
                toValueTF.text = val[1]
            }else{
                toValueTF.text = ""
            }
        }else{
            fromValueTF.text = ""
            toValueTF.text = ""
        }
        
        if let fromPlaceholder = control.dateFromPlaceholder{
            fromValueTF.placeholder = fromPlaceholder
        }
        
        if let toPlaceholder = control.dateToPlaceholder{
            toValueTF.placeholder = toPlaceholder
        }
        
        if !control.isValid, let _ = control.notValidType{
            fromValueTF.borderColorV = .red
            toValueTF.borderColorV = .red

        }else{
            fromValueTF.borderColorV = .clear
            toValueTF.borderColorV = .clear
        }
        
        if control.readOnly ?? false{
            fromValueTF.backgroundColor = .veryLightPink
            toValueTF.backgroundColor = .veryLightPink
        }else{
            fromValueTF.backgroundColor = .white
            toValueTF.backgroundColor = .white
        }
    }
    
    @IBAction func didTapFromDateBtn(){
        didTapDate?(true)
    }

    @IBAction func didTapToDateBtn(){
        didTapDate?(false)
    }


}
