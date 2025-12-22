//
//  Radio2ItemsOnlyTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/27/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class Radio2ItemsOnlyTVcell: ControlTVcell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var optionsBGView: UIView!
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!

    
    var didSelectOption: ((_ optionIdx: Int, _ conditionsAfterValidations: [ValidationsCerqel], _ isValid: Bool, _ inValidCon: ValidationsCerqel, ValidationName?)->())?

    var arrayOfOptions: [OptionsCerqel] = []{
        didSet{
            if arrayOfOptions.count >= 2{
                option1Btn.setTitle(arrayOfOptions[0].text, for: .normal)
                option2Btn.setTitle(arrayOfOptions[1].text, for: .normal)
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
    
    override func configure(control: ModelControlCerqel) {
        self.arrayOfOptions = control.options ?? []
        self.nameLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        
        self.controlData = control
        
        
        
        if let val = control.value as? [OptionsCerqel], val.count > 0{
            handleBtnSelection(value: val[0])
        }
        
        
        if !control.isValid, let _ = control.notValidType{
            optionsBGView.borderColorV = .red

        }else{
            optionsBGView.borderColorV = .light_periwinkle
        }

    }
    
    private func handleBtnSelection(value: OptionsCerqel){
        if arrayOfOptions.count >= 2{
            if arrayOfOptions[0].key == value.key{
                option1Btn.setTitleColor(.white, for: .normal)
                option1Btn.cerqel_setGradientColor(isVertical: false, colors: [UIColor.darkGreenBlue, UIColor.darkGreenBlue])
                
                option2Btn.setTitleColor(.slate_grey, for: .normal)
                option2Btn.cerqel_setGradientColor(isVertical: false, colors: [.white, .white])


            }else if arrayOfOptions[1].key == value.key{
                option1Btn.setTitleColor(.slate_grey, for: .normal)
                option1Btn.cerqel_setGradientColor(isVertical: false, colors: [.white, .white])


                option2Btn.setTitleColor(.white, for: .normal)
                option2Btn.cerqel_setGradientColor(isVertical: false, colors: [UIColor.darkGreenBlue, UIColor.darkGreenBlue])


            }else{
                option2Btn.setTitleColor(.slate_grey, for: .normal)
                option2Btn.cerqel_setGradientColor(isVertical: false, colors: [.white, .white])

                option1Btn.setTitleColor(.slate_grey, for: .normal)
                option1Btn.cerqel_setGradientColor(isVertical: false, colors: [.white, .white])


            }
        }
    }
    
    @IBAction func didTapOption1(){
        self.controlData.value = [arrayOfOptions[0]]
        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName)  in
            self.didSelectOption?(0, conditionsArr, isValid, inValidCon, notValidConditionName)
        }

    }
    
    @IBAction func didTapOption2(){
        self.controlData.value = [arrayOfOptions[1]]
        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
            self.didSelectOption?(1, conditionsArr, isValid, inValidCon, notValidConditionName)
        }

    }

}
