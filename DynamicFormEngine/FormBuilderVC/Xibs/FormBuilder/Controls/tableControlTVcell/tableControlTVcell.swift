//
//  tableControlTVcell.swift
//  CERQEL
//
//  Created by iSlam AbdelAziz on 15/11/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class tableControlTVcell: ControlTVcell {

    @IBOutlet weak var optionsTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var optionsListHeightContraint: NSLayoutConstraint!


    var didTapAdd: (()->())?
    var didTaptableItem: ((Int)->())?
    var didDeletetableItem: ((Int)->())?

    
    var didSelectOption: ((_ optionIdx: Int, _ conditionsAfterValidations: [ValidationsCerqel], _ isValid: Bool, _ inValidCon: ValidationsCerqel, ValidationName?)->())?
    
    var arrayOfOptions: [ModelNestedFormValueCerqel] = [] {
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
    }

    override func configure(control: ModelControlCerqel) {
        if let val = control.value as? [ModelNestedFormValueCerqel]{
            self.arrayOfOptions = val
        }else{
            self.arrayOfOptions = []

        }

        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""
        self.controlData = control
        
        
        
        if !control.isValid, let _ = control.notValidType{
//            valueTF.cerqel_borderColorV = .red

        }else{
//            valueTF.cerqel_borderColorV = .clear
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addBtnTapped(){
        didTapAdd?()
    }
    
}


extension tableControlTVcell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTVcell.cerqel_identifier, for: indexPath) as! OptionTVcell
        cell.deleteBtn.isHidden = false
        cell.nameLbl.text =  "\(controlData.label ?? "Value".localized) \(indexPath.row + 1)"
        cell.deleteBtnTapped = { [weak self] in
            self?.didDeletetableItem?(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTaptableItem?(indexPath.row)
    }
    
}
