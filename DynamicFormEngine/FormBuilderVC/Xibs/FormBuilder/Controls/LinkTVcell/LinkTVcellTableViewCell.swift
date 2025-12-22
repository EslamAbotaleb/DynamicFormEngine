//
//  LinkTVcellTableViewCell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 3/31/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class LinkTVcellTableViewCell: ControlTVcell {
    
    @IBOutlet weak var urlLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        self.titleLbl.text = control.label
        self.descriptionLbl.text = control.description ?? ""

        self.controlData = control
        
        if let val = control.value as? [String]{
            urlLbl.text = val.first
        }else{
            urlLbl.text = ""
        }
        
        
        
        if control.readOnly ?? false{
            bgView.backgroundColor = .veryLightPink
        }else{
            bgView.backgroundColor = .white
        }
    }
    
    
    @IBAction func didTapGoToURL(){
        if let val = controlData.value as? [String], let url = val.first{
            openAttachmentCerqel(withURLString: url)
        }
    }
}
