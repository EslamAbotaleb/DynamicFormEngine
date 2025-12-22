//
//  LabelControleTVcell.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 4/18/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class LabelControleTVcell: ControlTVcell {

    @IBOutlet weak var contentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func configure(control: ModelControlCerqel) {
//        self.titleLbl.text = control.label
        
//        if let val = control.value as? [String]{
//            if val.count > 0{
        contentLbl.text = control.label //val.first
//            }
//        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
