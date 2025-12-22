//
//  InfoIndicatorTVcell.swift
//  GAZT
//
//  Created by Abdallah Elmahlawy on 4/18/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class InfoIndicatorTVcell: ControlTVcell {
    
    
    @IBOutlet weak var infoContentView: UIView!
    @IBOutlet weak var infoIconImgV: UIImageView!
    @IBOutlet weak var infoLbl: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        infoContentView.layer.masksToBounds = false
        infoContentView.layer.cornerRadius = 10

        infoContentView.cerqel_addNormalShadow()
        // Initialization code
    }

    override func configure(control: ModelControlCerqel) {
//        self.titleLbl.text = control.label
        
//        if let val = control.value as? [String]{
//            if val.count > 0{
////                contentLbl.text = val.first
//            }
//        }
        
        if let lbl = control.label{
//            self.infoLbl.text = lbl
            self.infoLbl.text = lbl.cerqel_htmlToString
//                .trimmingCharacters(in: .whitespacesAndNewlines).convertHtmlToAttributedStringWithCSS(font: UIFont.SST_Arabic_Roman(ofSize: 12), csscolor: "slate_grey", lineheight: 20, csstextalign: isArabicCerqel() ? "right" : "left")
        }

        
        if let style = control.style{
            if let bGColor = style.backgroundColor{
                self.infoContentView.backgroundColor = UIColor(hexStringCerqel: bGColor)
            }
            if let txtColor = style.textColor{
                self.infoLbl.textColor = UIColor(hexStringCerqel: txtColor)
            }
        }
        
        
        if let iconURL = control.icon{
            self.infoIconImgV.kf.indicatorType = .activity
            self.infoIconImgV.kf.setImage(with: URL(string: iconURL.cerqel_CreateMediaURL()), placeholder: UIImage())
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
