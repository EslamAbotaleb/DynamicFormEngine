//
//  ExpandedTableHeader.swift
//  CERQEL
//
//  Created by Youxel on 21/07/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit

class ExpandedTableHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLbl: LocalizedLabel!
    @IBOutlet weak var dropDownIcon: UIImageView!
 
    var collapsed : (()->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    private func configureUI(){
        headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        headerView.layer.shadowColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 0.2).cgColor
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowRadius = 10
        headerView.layer.masksToBounds = false
    }
    
    func configure(sectionTitle : String, isExpanded: Bool){
        titleLbl.text = sectionTitle
        isExpanded ? (dropDownIcon.image = UIImage(named: "arrow_up")) : (dropDownIcon.image = UIImage(named: "arrow_down"))
    }


    @IBAction func dropDownButtonPressed(_ sender: Any) {
        collapsed?()
    }
    

}
