//
//  AddEditInvitedCV.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 12/04/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class AddEditInvitedCV: UICollectionViewCell {

    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var invitedPeopleNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension AddEditInvitedCV {
    private func configureUI() {
        invitedPeopleNameLbl.textColor = typographyTitle
        invitedPeopleNameLbl.font = UIFont.bodySRegular()
    }
}
