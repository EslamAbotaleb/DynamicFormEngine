//
//  ChatEmptyTVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 1/27/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ChatEmptyTVcell: UITableViewCell {

    @IBOutlet weak var chatEmptyTitleLbl: LocalizedLabel!
    @IBOutlet weak var commaIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ChatEmptyTVcell {
    func configureUI() {
        commaIcon.tintColor = primaryMain
        chatEmptyTitleLbl.textColor = typographySubtitle
    }
}
