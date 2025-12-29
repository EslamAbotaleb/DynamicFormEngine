//
//  OtherOptionView.swift
//  CHECK
//
//  Created by Yasser Osama on 19/05/2022.
//

import UIKit

class OtherOptionView: UIView {

    let contentXibName = "OtherOptionView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var otherTextField: UITextField!
    
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
