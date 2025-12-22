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
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.fixInView(self)
    }
}
