//
//  AttachCommentCVcell.swift
//  KAFDHUB
//
//  Created by hassan elshaer on 30/05/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class AttachCommentCVcell: UICollectionViewCell {

    @IBOutlet weak var imgICon: UIImageView!
    @IBOutlet weak var attachTitleLbl: UILabel!
    @IBOutlet weak var pinBtn: UIButton!
    
    
    var removeTapped: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: ModelUploadedMedia?){
        guard let data = data else {return}
        attachTitleLbl.text = data.name
    }
    
   

    @IBAction func pinBtnTapped(_ sender: Any) {
        if let action = removeTapped {
            action()
        }
    }
}
