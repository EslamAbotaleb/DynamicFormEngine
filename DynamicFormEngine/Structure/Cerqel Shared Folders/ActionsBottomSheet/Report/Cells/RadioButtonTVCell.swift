//
//  RadioButtonTVCell.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class RadioButtonTVCell: UITableViewCell {

    @IBOutlet weak var radioTitle: UILabel!
    @IBOutlet weak var radioImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
   
    func configure(item : ListModel){
        radioTitle.text = item.name
        radioImage.image = item.isSelected ?? false ? UIImage(named: "Radio Status") : UIImage(named: "Radio Status unselected")
      
    }
    
 
}
extension RadioButtonTVCell {
    private func configureUI() {
        radioTitle.font = UIFont.bodyLRegular()
        radioTitle.textColor  = typographyTitle
    
    }
}
