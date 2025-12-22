//
//  DetailsTabsTVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 1/27/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class DetailsTabsTVcell: UITableViewCell {
    
    @IBOutlet weak var showHideEmptyFieldsView: UIView!
    
    @IBOutlet weak var switchLbl: UILabel!{
        didSet {
            switchLbl.text = "Show Empty Fields".localized
        }
    }
    @IBOutlet weak var switchCtl: UISwitch!
    
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var detailsBottomView: UIView!
    @IBOutlet weak var actionsBtn: UIButton!
    @IBOutlet weak var actionsBottomView: UIView!
    @IBOutlet weak var discussionBtn: UIButton!
    @IBOutlet weak var discussionsBottomView: UIView!
    
    var didChooseTab: ((Int)->())?
//    var reloaded: ((Bool)->())?
    var showEmptyFieldsFlag: DynamicObjects<Bool> = DynamicObjects(false)
    var showEmptyFieldsClosure: ((Bool)->())?
    var reloadExternalTableView: (()->())?
    
    var formBuilder = FormBuilder.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
        configUI()
        actionsBtn.setTitle("Approval History".localized, for: .normal)
        discussionBtn.setTitle("Discussions".localized, for: .normal)
    }
    
    
    // handle observation
    func config() {
        showEmptyFieldsFlag.bind {[weak self] show in
            guard let `self` = self else {return}
            self.showEmptyFieldsClosure?(show)
            if show { self.showEmptyFields() }
            self.reloadExternalTableView?()
        }
    }
    
    // handle fonts & colors
    func configUI() {
        switchLbl.font = UIFont.Poppins_regular(ofSize: 14)
        switchLbl.textColor = typographySubtitle
    }
    
    func showEmptyFields() {
        formBuilder.hiddenItemsIDs = []
    }
    
    func disableSwitch() {
        switchLbl.textColor = hexStringToUIColor(hex: "#AAB2C5")
        switchCtl.isEnabled = false
    }
    
    /// selection 1-> details, 2-> Discussion
    func configure(selection: Int = 1, myRequest: Bool){
        myRequest ? (detailsBtn.setTitle("Request Details".localized, for: .normal)) : (detailsBtn.setTitle("Task Details".localized, for: .normal))
        if selection == 1{
            doSelection(btn: detailsBtn, view: detailsBottomView)
            undoSelection(btn: actionsBtn, view: actionsBottomView)
            undoSelection(btn: discussionBtn, view: discussionsBottomView)
        }else if selection == 2 {
            undoSelection(btn: detailsBtn, view: detailsBottomView)
            doSelection(btn: actionsBtn, view: actionsBottomView)
            undoSelection(btn: discussionBtn, view: discussionsBottomView)
        }else{
            undoSelection(btn: actionsBtn, view: actionsBottomView)
            undoSelection(btn: detailsBtn, view: detailsBottomView)
            doSelection(btn: discussionBtn, view: discussionsBottomView)
        }
    }
    
    private func doSelection(btn: UIButton, view: UIView){
        btn.setTitleColor(primaryMain, for: .normal)
        btn.titleLabel?.font = UIFont.heading4(ofSize: 12)
        view.backgroundColor = primaryMain
    }
    private func undoSelection(btn: UIButton, view: UIView){
        btn.setTitleColor(typographySubtitle, for: .normal)
        btn.titleLabel?.font = UIFont.heading4(ofSize: 12)
        view.backgroundColor = .clear
    }

    
    // MARK: - IBActions
    
    @IBAction func detailsBtnTapped(){
        didChooseTab?(1)
    }
    
    @IBAction func actionsBtnTapped() {
        didChooseTab?(2)
    }
    
    @IBAction func discussionBtnTapped(){
        didChooseTab?(3)
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        showEmptyFieldsFlag.value.toggle()
    }
}
