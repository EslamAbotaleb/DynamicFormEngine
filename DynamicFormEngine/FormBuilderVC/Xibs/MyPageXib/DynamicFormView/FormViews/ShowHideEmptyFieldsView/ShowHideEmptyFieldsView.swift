//
//  ShowHideEmptyFieldsView.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 25/02/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit

class ShowHideEmptyFieldsView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var switchLbl: UILabel! {
        didSet {
            switchLbl.text = "Show Empty Fields".localized
        }
    }
    @IBOutlet weak var switchCtl: UISwitch!
    
    
    // MARK: - Variables
    
    var showEmptyFieldsFlag: DynamicObjects<Bool> = DynamicObjects(false)
    var showEmptyFieldsClosure: ((Bool)->())?
    var reloadExternalTableView: (()->())?
    var formBuilder = FormBuilder.shared
    
    // MARK: - Functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        config()
        
    }

    func commonInit() {
        let bundle = Bundle(for: Self.self)
        
        guard bundle.loadNibNamed("ShowHideEmptyFieldsView", owner: self, options: nil) != nil else {
            fatalError("Could not load ShowHideEmptyFieldsView from DynamicFormEngine framework")
        }

        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        configUI()
        handleInitUI()
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
        serviceNameLbl.font = UIFont.Poppins_semiBold(ofSize: 16)
        serviceNameLbl.textColor = typographyTitle
        switchLbl.font = UIFont.Poppins_regular(ofSize: 14)
        switchLbl.textColor = typographySubtitle
    }
    
    func handleInitUI() {
        serviceNameLbl.text = formBuilder.serviceName
    }
    
    func showEmptyFields() {
        formBuilder.hiddenItemsIDs = []
    }
    
    func hideServiceName(_ hide: Bool) {
        serviceNameLbl.isHidden = hide
    }
    
    
    func disableSwitch() {
        switchLbl.textColor = hexStringToUIColor(hex: "#AAB2C5")
        switchCtl.isEnabled = false
    }
    
    
    // MARK: - IBActions
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        showEmptyFieldsFlag.value.toggle()
    }
}
