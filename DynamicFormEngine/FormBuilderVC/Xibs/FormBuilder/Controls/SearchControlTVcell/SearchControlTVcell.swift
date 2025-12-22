//
//  SearchControlTVcell.swift
//  CERQEL
//
//  Created by iSlam AbdelAziz on 31/01/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit

class SearchControlTVcell: ControlTVcell {

    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    @IBOutlet weak var optionsListHeightContraint: NSLayoutConstraint!


    var requestSearchCall: ((String?)->())?
    var didChangeExpand: (()->())?
    var didSelectOption: ((_ optionIdx: Int, _ conditionsAfterValidations: [ValidationsCerqel], _ isValid: Bool, _ inValidCon: ValidationsCerqel, ValidationName?)->())?
    
    var arrayOfOptions: [SearchControlResultCerqel] = [] {
        didSet{
            optionsTV.isHidden = (arrayOfOptions.count == 0)
            
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
        valueTF.cerqel_addIconView(img: UIImage(named: "search_blue")!, isRight: true)
        
        valueTF.cerqel_addEmptyView(isLeft: true, width: 20)
    }

    func configure(control: ModelControlCerqel, searchResultArr: [SearchControlResultCerqel]?, searchedText: String?) {
        optionsTV.isHidden =  !control.isExpanded
        self.arrayOfOptions = searchResultArr ?? []
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        self.valueTF.placeholder = control.placeHolder
        self.controlData = control
        
        if let val = control.value as? [SearchControlResultCerqel], val.count > 0{
            var text = ""
            for item in val{
                text.append(" \(item.presentedText )")
                text.append(",")
            }
            if text.last == ","{
                text.removeLast()
            }
            valueTF.text = text
        }else{
            self.valueTF.text = searchedText ?? ""
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


extension SearchControlTVcell: UITableViewDelegate, UITableViewDataSource{
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

extension SearchControlTVcell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count > 0{
            print("SEARCH ACTION")
            textField.resignFirstResponder()
            requestSearchCall?(textField.text)
        }
        return true
    }
}
