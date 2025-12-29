//
//  LabelView.swift
//  CHECK
//
//  Created by Yasser Osama on 12/10/2021.
//

import UIKit

class LabelView: UIView {
    let contentXibName = "LabelView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var fieldLabel: UILabel!
    
    var item: FormViewModelItem! {
        didSet {
            setupLabelText(item)
        }
    }
    
    var required: Bool? {
        didSet {
            if required ?? false {
//                fieldLabel.addRequiredAsterisk()
            }
        }
    }
    
    var isEditable: Bool! = true {
        didSet {
            setLabelFont(isEditable)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
//        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        let bundle = Bundle(for: Self.self)
        
        guard bundle.loadNibNamed(contentXibName, owner: self, options: nil) != nil else {
            fatalError("Could not load \(contentXibName) from DynamicFormEngine framework")
        }
        contentView.fixInView(self)
        
        setLabelFont(true)
    }
    
    func setLabelFont(_ isEditable: Bool) {
        if isEditable {
//            fieldLabel.font = UIFont(name: Constants.mediumFont(), size: 16.0)!
//            fieldLabel.textColor = .checkText
        } else {
//            fieldLabel.font = UIFont(name: Constants.regularFont(), size: 14.0)!
//            fieldLabel.textColor = .blueGrey
        }
    }
    
    func setupLabelText(_ item: FormViewModelItem) {
        fieldLabel.text = item.label
//        if Localizer.isFormSameLanguage {
//            fieldLabel.text = item.label
//        } else {
//            if let localizedLabel = item.localization?[Localizer.currentLanguage]?.label, !localizedLabel.isEmpty {
//                fieldLabel.text = localizedLabel
//            } else {
//                fieldLabel.text = item.label
//            }
//        }
    }
}
