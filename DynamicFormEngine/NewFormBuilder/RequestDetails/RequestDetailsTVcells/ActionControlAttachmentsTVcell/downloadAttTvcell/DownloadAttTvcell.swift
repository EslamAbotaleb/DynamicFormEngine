//
//  DownloadAttTvcell.swift
// 
//
//  Created by iSlam AbdelAziz on 2/22/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class DownloadAttTvcell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachIcon: UIImageView!
    
    @IBOutlet weak var downloadAttachIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(color: UIColor, constraint: CGFloat) {
        contentView.backgroundColor = color
//        leadingConstraint.constant = constraint
    }
    
    
}
extension DownloadAttTvcell {
    func configureUI(){
        downloadAttachIcon.tintColor = primaryMain
    }
}
