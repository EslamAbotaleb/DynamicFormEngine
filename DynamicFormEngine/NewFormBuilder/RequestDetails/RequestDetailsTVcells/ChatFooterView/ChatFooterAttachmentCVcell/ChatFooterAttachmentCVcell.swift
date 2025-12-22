//
//  ChatFooterAttachmentCVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 3/10/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ChatFooterAttachmentCVcell: UICollectionViewCell {
    
    @IBOutlet weak var titleBtn: UIButton!
    
    
    var removeBtnTapped: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ item: ModelUploadedMedia?){
        self.titleBtn.setTitle(item?.name, for: .normal)
    }
    
    @IBAction func didTapRrmoveBtnBtn(){
        removeBtnTapped?()
    }

}
