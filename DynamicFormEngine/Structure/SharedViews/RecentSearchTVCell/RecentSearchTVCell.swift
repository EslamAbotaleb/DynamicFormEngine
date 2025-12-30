//
//  RecentSearchTVCellTableViewCell.swift
//  CERQEL
//
//  Created by mac on 6/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

public class RecentSearchTVCell: UITableViewCell {

    public var deleteBtnTapped:(() ->())?

    @IBOutlet weak var closeV: UIView!
    @IBOutlet weak var closeImgV: UIImageView!
    @IBOutlet weak var recentSearchLbl: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        configureUI()
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(item: String?,searchType: SearchType) {
        recentSearchLbl.text = item ?? "-"
        closeV.isHidden = (searchType == .suggetion)
    }
    
    public func configure(item: String?) {
        recentSearchLbl.text = item ?? "-"
    }
    
    @IBAction func deleteBtnIsPressed(_ sender: Any) {
        deleteBtnTapped?()
    }
    
}

extension RecentSearchTVCell {
    private func configureUI() {
        
        recentSearchLbl.font = UIFont.bodyMMedium()
        recentSearchLbl.textColor = typographySubtitle
        closeV.backgroundColor = primaryLight
        closeImgV.tintColor = primaryMain
    }
}
