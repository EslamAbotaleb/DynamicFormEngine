//
//  NewCheckboxView.swift
//
//
//  Created by Marwan on 31/01/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit


class NewCheckboxView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    var canInteraction: Bool?
    
    // MARK: - Variables
    
    var checkboxRepresentation: CheckBoxRepresentation = .CheckBox
    var title: String = ""
    var isSelected = false
    var didCheck: (() -> ())?
    var didUncheck: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Functions
    
    private func commonInit() {
//        Bundle.main.loadNibNamed("NewCheckboxView", owner: self, options: nil)
        let bundle = Bundle(for: Self.self)
        
        guard bundle.loadNibNamed("NewCheckboxView", owner: self, options: nil) != nil else {
            fatalError("Could not load NewCheckboxView from DynamicFormEngine framework")
        }
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        layoutIfNeeded()
    }
    
    func setupUI() {
        titleLabel.text = title
        switch checkboxRepresentation {
        case .CheckBox:
            if(canInteraction ?? false){
                checkboxImageView.image = UIImage(named: "uncheckedBtnIcon")
                checkboxImageView.highlightedImage = UIImage(named: "checkedBtnIcon")
            }
            else{
                checkboxImageView.image = UIImage(named: "UnselectedCheckbox")
                checkboxImageView.highlightedImage = UIImage(named: "selectedCheckbox")
            }
        case .Radio:
            if(canInteraction ?? false){
                checkboxImageView.image = UIImage(named: "radio_button_unchecked")
                checkboxImageView.highlightedImage = UIImage(named: "radio_button_checked")
            }
            else{
                checkboxImageView.image = UIImage(named: "UnSelectedRiadio")
                checkboxImageView.highlightedImage = UIImage(named: "SelectedRadio")
            }
        }
        
        setupTextColor()
    }
    
    func setupTextColor() {
        if canInteraction ?? false {
            titleLabel.textColor = typographyTitle
        }else {
            titleLabel.textColor = typographySubtitle
        }
    }

    func setChecked(isDisabled: Bool) {
        checkboxImageView.isHighlighted = true
    }
    
    func setUnchecked(isDisabled: Bool) {
        checkboxImageView.isHighlighted = false
    }
    
    func checkboxDisabled() {
        checkBoxBtn.isUserInteractionEnabled = false
        canInteraction = false
    }
    
    // MARK: - IBActions
    
    @IBAction func checkboxTapped(_ sender: UIButton) {
        if(canInteraction ?? false){
            if isSelected {
                didUncheck?()
            } else {
                didCheck?()
            }
            isSelected.toggle()
        }
    }
}
