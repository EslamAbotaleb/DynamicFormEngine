//
//  ExpandNoteFooterView.swift
// 
//
//  Created by Abdallah Elmahlawy on 4/28/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ExpandNoteFooterView: UIView {
    
    
    
    @IBOutlet weak var contentView: UIView!

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        create()

    }
    
    func create(){
        let bundle = Bundle(for: Self.self)
        guard bundle.loadNibNamed("ExpandNoteFooterView", owner: self, options: nil) != nil else {
            fatalError("Could not load ExpandNoteFooterView from DynamicFormEngine framework")
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        contentView.backgroundColor = UIColor.clear
        
    }
}
