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
        let bundle = Bundle(for: Self.self)
        guard bundle.loadNibNamed(contentXibName, owner: self, options: nil) != nil else {
            fatalError("Could not load \(contentXibName) from DynamicFormEngine framework")
        }
        contentView.fixInView(self)
        
//        if Localizer.currentAppLanguageArabic() {
//            showMoreButton.contentHorizontalAlignment = .right
//        } else {
            showMoreButton.contentHorizontalAlignment = .left
//        }
    }
}
