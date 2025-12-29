//
//  CheckBoxView.swift
//  CHECK
//
//  Created by Yasser Osama on 17/05/2022.
//

import UIKit


class CheckBoxView: UIView {
    
    let contentXibName = "CheckBoxView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var selectionImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    
    var representation: CheckBoxRepresentation!
    
    var checked: Bool! {
        didSet {
            if representation == .CheckBox {
                if checked {
                    selectionImageView.image = UIImage(named: "mcqCheckBoxSelected")
                } else {
                    selectionImageView.image = UIImage(named: "mcqCheckBox")
                }
            } else {
                if checked {
                    selectionImageView.image = UIImage(named: "mcqRadioSelected")
                } else {
                    selectionImageView.image = UIImage(named: "mcqRadio")
                }
            }
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
        let bundle = Bundle(for: Self.self)
        guard bundle.loadNibNamed(contentXibName, owner: self, options: nil) != nil else {
            fatalError("Could not load \(contentXibName) from DynamicFormEngine framework")
        }
        
        contentView.fixInView(self)
    }
}
