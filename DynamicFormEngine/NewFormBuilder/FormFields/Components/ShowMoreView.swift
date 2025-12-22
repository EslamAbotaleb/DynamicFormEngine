//
//  ShowMoreView.swift
//  CHECK
//
//  Created by Yasser Osama on 22/02/2022.
//

import UIKit

class ShowMoreView: UIView {
    
    let contentXibName = "ShowMoreView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    
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
        
//        if Localizer.currentAppLanguageArabic() {
//            showMoreButton.contentHorizontalAlignment = .right
//        } else {
            showMoreButton.contentHorizontalAlignment = .left
//        }
    }
}
