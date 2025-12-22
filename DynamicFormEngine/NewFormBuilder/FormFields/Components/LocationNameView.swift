//
//  LocationNameView.swift
//  CHECK
//
//  Created by Yasser Osama on 17/02/2022.
//

import UIKit

class LocationNameView: UIView {
    
    let contentXibName = "LocationNameView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
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
