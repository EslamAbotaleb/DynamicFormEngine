//
//  ExpandedSectionHeader.swift
//  CERQEL
//
//  Created by hassan elshaer on 22/07/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

class ExpandedSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collapseImage: UIImageView!
    
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterViewHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    var collapsed : (()->())?
    
    override func awakeFromNib()  {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI(){
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(hex: "#BDBDBD33").cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
    
    func configure(sectionTitle : String, isExpanded: Bool, isEditMode: Bool,isParent: Bool? = false,index: Int? = nil){
        self.backgroundColor = isEditMode ? .clear :  UIColor.primaryLight
        headerView.backgroundColor = .white
        self.sectionTitle.text = sectionTitle
        self.sectionTitle.textColor = primaryMain
        self.collapseImage.tintColor = primaryMain
        isExpanded ? (collapseImage.image = UIImage(named: "arrow_up")) : (collapseImage.image = UIImage(named: "arrow_down"))
        counterView.makeRounded(color: primaryMain, borderWidth: 2)
        counterLbl.textColor = primaryMain
        counterView.isHidden = isParent! ? false : true
        counterViewHeightLayout.constant = isParent! ? 30 : 0
        counterLbl.text = "\(index ?? 0)"
    }
    
    @IBAction func collapseSection(_ sender: Any) {
        self.collapsed!()
    }

}
