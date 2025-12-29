//
//  AddEditInvitedCV.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 12/04/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

public class AddEditInvitedCV: UICollectionViewCell {

    @IBOutlet weak public var vw: UIView!
    @IBOutlet weak public var invitedPeopleNameLbl: UILabel!
    
    override public func awakeFromNib() {
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
