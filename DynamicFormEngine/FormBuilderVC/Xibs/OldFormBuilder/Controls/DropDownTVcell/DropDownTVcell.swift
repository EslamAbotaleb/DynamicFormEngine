//
//  DropDownTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/24/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class DropDownTVcell: ControlTVcell {

    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var optionsListHeightContraint: NSLayoutConstraint!


    var didChangeExpand: (()->())?
    var didSelectOption: ((_ optionIdx: Int, _ conditionsAfterValidations: [ValidationsCerqel], _ isValid: Bool, _ inValidCon: ValidationsCerqel, ValidationName?)->())?
    
    var arrayOfOptions: [OptionsCerqel] = [] {
        didSet{
            if arrayOfOptions.count > 0, arrayOfOptions.count < 4{
                optionsListHeightContraint.constant = CGFloat(arrayOfOptions.count * 48)
            }else{
                optionsListHeightContraint.constant = 160
            }
            optionsTV.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        optionsTV.register(OptionTVcell.cerqel_nib, forCellReuseIdentifier: OptionTVcell.cerqel_identifier)
        valueTF.tintColor = .darkGreenBlue
        valueTF.cerqel_addIconView(img: UIImage(named: "down-arrow2")!, isRight: true)
        
        valueTF.cerqel_addEmptyView(isLeft: true, width: 20)
    }

    override func configure(control: ModelControlCerqel) {
        optionsTV.isHidden =  !control.isExpanded
        self.arrayOfOptions = control.options ?? []
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        self.valueTF.placeholder = control.placeHolder
        self.controlData = control
        
        if let val = control.value as? [OptionsCerqel], val.count > 0{
            var text = ""
            for item in val{
                text.append(" \(item.text ?? "")")
                text.append(",")
            }
            if text.last == ","{
                text.removeLast()
            }
            valueTF.text = text
        }else{
            valueTF.text = ""
        }
        
        
        if !control.isValid, let _ = control.notValidType{
            valueTF.borderColorV = .red

        }else{
            valueTF.borderColorV = .clear
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showHideOptions(){
        didChangeExpand?()
    }
    
}


extension DropDownTVcell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTVcell.cerqel_identifier, for: indexPath) as! OptionTVcell
        cell.configure(option: arrayOfOptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controlData.value = [arrayOfOptions[indexPath.row]]

        checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
            self.didSelectOption?(indexPath.row, conditionsArr, isValid, inValidCon, notValidConditionName)
        }
    }
    
}
