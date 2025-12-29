//
//  SalaryItem.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 01/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SalaryItem : UIView{
    
    @IBOutlet var contentView: SalaryItem!
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondeLabel: UILabel!
    
    let nibName = "SalaryItem"
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          commonInit()
      }

    private func commonInit() {
        let bundle = Bundle(for: Self.self)
        guard bundle.loadNibNamed(nibName, owner: self, options: nil) != nil else {
            fatalError("Could not load \(nibName) from DynamicFormEngine framework")
        }
        
        self.addSubview(contentView)
        contentView.frame = self.bounds

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        firstLabel.text = ""
    }

    
    func setData(title : String? , descreption : String?){
        firstLabel.text = title ?? "_"
        secondeLabel.text = descreption ?? "_"
    }
    
 
}
