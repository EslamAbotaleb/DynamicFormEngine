//
//  MediaItemTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 2/17/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class MediaItemTVcell: UITableViewCell {
    
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileSizeLbl: UILabel!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    var didTapRemove: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func configure(_ item: ModelUploadedMediaCerqel?){
//        fileNameLbl.text = item?.name
//        fileSizeLbl.text = item?.fileSize
//    }
    
    @IBAction func removeBtnTapped(){
        didTapRemove?()
    }
    
}
