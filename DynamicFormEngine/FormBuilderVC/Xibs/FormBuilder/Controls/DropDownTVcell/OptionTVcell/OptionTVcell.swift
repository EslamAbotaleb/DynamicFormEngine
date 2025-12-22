//
//  OptionTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/24/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

class OptionTVcell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var viewBtn: UIButton!
    
    var deleteBtnTapped: (()->())?
    var editBtnTapped: (()->())?
    var viewBtnTapped: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BGView.addBottomShadow()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func handleDisabledData(isDisable:Bool){
        BGView.backgroundColor =  isDisable ?  #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) : .white
    }
    
    func configure(option: OptionsCerqel?){
        if let option = option as? SearchControlResult_EmployeeModelCerqel{
            nameLbl.text = option.arabicName
            
        }
        deleteBtn.isHidden = true
        if option?.isSelected ?? false{
            nameLbl.textColor = .ocean_green1
        }else{
            nameLbl.textColor = .slate_grey
        }
    }
    
    func configure(option: SearchControlResultCerqel?){
        if let option = option as? SearchControlResult_EmployeeModelCerqel{
            nameLbl.text = option.arabicName

        }
        deleteBtn.isHidden = true
        if option?.isSelected ?? false{
            nameLbl.textColor = .ocean_green1
        }else{
            nameLbl.textColor = .slate_grey
        }
    }
    
    @IBAction func  didTapDelete(){
        deleteBtnTapped?()
    }
    
    @IBAction func edititemTapped(_ sender: Any) {
        editBtnTapped?()
    }
    
    
    @IBAction func viewBtn(_ sender: Any) {
        viewBtnTapped?()
    }
}
