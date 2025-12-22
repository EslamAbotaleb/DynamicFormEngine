//
//  EmployeeInfoControlTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 16/08/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class EmployeeInfoControlTVcell: ControlTVcell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var optionsTV_HContrsint: NSLayoutConstraint!

    var arrayOfVisitors: [VisitorInfoCerqel?] = []{
        didSet{
            optionsTV_HContrsint.constant = CGFloat(arrayOfVisitors.count * SingleVisitorInfoTVcell.cellHeight)
            self.optionsTV.reloadData()
        }
    }

    var didChangeItemsHeight: (()->())?
    var didChangeValue: ((_ val: [VisitorInfoCerqel?], _ isValid: Bool, _ inValidCon: ValidationsCerqel?, _ notValidCondName: ValidationName?)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        optionsTV.register(SingleVisitorInfoTVcell.cerqel_nib, forCellReuseIdentifier: SingleVisitorInfoTVcell.cerqel_identifier)
    }

    
    override func configure(control: ModelControlCerqel) {
        
        if let lbl = control.label, lbl != ""{
            self.titleLbl.isHidden = false
            self.titleLbl.text = lbl
        }else{
            self.titleLbl.isHidden = true
        }
        if let desc = control.description , desc != ""{
            self.descriptionLbl.isHidden = false
            self.descriptionLbl.text = desc
        }else{
            self.descriptionLbl.isHidden = true
        }

        self.controlData = control
        
        if let val = control.value as? [VisitorInfoCerqel], val.count > 0{
            self.arrayOfVisitors = val
        }else{
            self.arrayOfVisitors = [VisitorInfoCerqel()]
        }
        
//        if let val = control.value as? [String], val.count > 0{
//            valueTF.text = val.first
//            if val.first != ""{
//                            checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
//                                control.isValid = isValid
//                            }
//            }
//        }else{
//            valueTF.text = ""
//        }
        
        
//        if !control.isValid, let _ = control.notValidType{
//            valueTF.cerqel_borderColorV = .red
//
//        }else{
//            valueTF.cerqel_borderColorV = .clear
//        }
//
//        if control.readOnly ?? false{
//            valueTF.backgroundColor = .veryLightPink
//        }else{
//            valueTF.backgroundColor = .white
//        }
    }
    
    @IBAction func addMoreBtnTpped(){
        if arrayOfVisitors.last??.validate() ?? false{
            self.arrayOfVisitors.append(VisitorInfoCerqel())
            valuesUpdated()

        }
    }
    
    private func valuesUpdated(){
        self.controlData.value = self.arrayOfVisitors
        self.checkValidation(control: self.controlData) { (isValid, conditionsArr, inValidCon, notValidConditionName) in
            self.didChangeValue?(self.arrayOfVisitors, isValid, inValidCon, notValidConditionName)
        }

    }
}


extension EmployeeInfoControlTVcell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfVisitors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleVisitorInfoTVcell.cerqel_identifier, for: indexPath) as! SingleVisitorInfoTVcell
        cell.configure(arrayOfVisitors[indexPath.row])
        cell.removeBtn.isHidden = !(arrayOfVisitors.count > 1)
        cell.removeView.isHidden = !(arrayOfVisitors.count > 1)
        cell.didChangeMyValue = { visitor in
//            if visitor?.validate() ?? false{
                self.arrayOfVisitors[indexPath.row] = visitor
                self.valuesUpdated()
//            }
        }
        cell.didTapRemove = {
            self.arrayOfVisitors.remove(at: indexPath.row)
            self.valuesUpdated()
        }
        return cell
    }
    
    
}
