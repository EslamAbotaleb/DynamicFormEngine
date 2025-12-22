//
//  ExecuteActionTVcell.swift
//
//
//  Created by Abdallah Elmahlawy on 3/17/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ExecuteActionTVcell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var firstBtn: UIButton! // first button
    @IBOutlet weak var firstBtnContainerView: UIView!
    @IBOutlet weak var secondBtn: UIButton! // second button
    @IBOutlet weak var secondBtnContainerView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var moreBtnContainerView: UIView!
    
    // MARK: - Variables
    var didFirstButtonPressedClosure: ((Action)->())?
    var didSecondButtonPressedClosure: ((Action)->())?
    var firstButton: Action?
    var secondButton: Action?
    var didMoreButtonPressed: (([Action])->())?
    var notPresentedActions = [Action]()
    
    // MARK: - Funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(actions: [Action]? = nil) {
        guard var actions = actions, !actions.isEmpty else {return}
        if actions.count <= 2 { // 2 buttons or less
            moreBtnContainerView.isHidden = true
            for (index,button) in actions.enumerated() {
                if index == 0 { // first button
                    firstBtn.backgroundColor = hexStringToUIColor(hex: button.styleCode ?? "#1C3968")
                    firstBtn.setTitleColor(hexStringToUIColor(hex: button.buttonStyleCode ?? "#FFFFFF"), for: .normal)
                    firstButton = button
                    firstBtnContainerView.isHidden = false
                    firstBtn.setTitle(button.label, for: .normal)
                }
                if index == 1 { // second button
                    secondBtn.backgroundColor = hexStringToUIColor(hex: button.styleCode ?? "#1C3968")
                    secondBtn.setTitleColor(hexStringToUIColor(hex: button.buttonStyleCode ?? "#FFFFFF"), for: .normal)
                    secondButton = button
                    secondBtnContainerView.isHidden = false
                    secondBtn.setTitle(button.label, for: .normal)
                }
            }
        }else { // more than 2 buttons
            
            moreBtnContainerView.isHidden = false
            let icon = UIImage(named: "moreIcon")!
            moreBtn.setImage(icon, for: .normal)
            moreBtn.imageView?.contentMode = .scaleAspectFit
            moreBtn.imageView?.tintColor = hexStringToUIColor(hex: "#712B81")
            moreBtn.tintColor = hexStringToUIColor(hex: "#712B81")
            moreBtn.imageEdgeInsets = isArabicCerqel() ? UIEdgeInsets(top: 0, left: -60, bottom: 0, right: 60) : UIEdgeInsets(top: 0, left: 60, bottom: 0, right: -60)
            actions = actions.sorted(by: {$0.actionOrder ?? 0 < $1.actionOrder ?? 0})
            var filteredArray = actions
            filteredArray.remove(at: 0)
            filteredArray.remove(at: 0)
            notPresentedActions = filteredArray
            
            
            let fButton = actions[0]
            firstBtn.backgroundColor = hexStringToUIColor(hex: fButton.buttonStyle?.backgroundColor ?? "#1C3968").withAlphaComponent(CGFloat(fButton.buttonStyle?.opacity ?? 0.0))
            firstBtn.layer.cornerRadius = 8
            firstBtn.layer.borderWidth = 1
            firstBtn.setTitleColor(hexStringToUIColor(hex: fButton.buttonStyle?.textColor ?? "#FFFFFF"), for: .normal)
            firstBtn.borderColorV = hexStringToUIColor(hex: fButton.buttonStyle?.borderColor ?? "#1C3968")
            firstButton = fButton
            firstBtnContainerView.isHidden = false
            firstBtn.setTitle(fButton.label, for: .normal)
            
            let sButton = actions[1]
            secondBtn.backgroundColor = hexStringToUIColor(hex: sButton.buttonStyle?.backgroundColor ?? "#1C3968").withAlphaComponent(CGFloat(sButton.buttonStyle?.opacity ?? 0.0))
            secondBtn.layer.cornerRadius = 8
            secondBtn.layer.borderWidth = 1
            secondBtn.setTitleColor(hexStringToUIColor(hex: sButton.buttonStyle?.textColor ?? "#FFFFFF"), for: .normal)
            secondBtn.borderColorV = hexStringToUIColor(hex: sButton.buttonStyle?.borderColor ?? "#1C3968")
            secondButton = sButton
            secondBtnContainerView.isHidden = false
            secondBtn.setTitle(sButton.label, for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction func firstBtnTapped() {
        if let action = didFirstButtonPressedClosure, let btn = firstButton {
            action(btn)
        }
    }
    
    @IBAction func secondBtnTapped() {
        if let action = didSecondButtonPressedClosure, let btn = secondButton {
            action(btn)
        }
    }
    
    @IBAction func moreTapped() {
        if let action = didMoreButtonPressed {
            action(notPresentedActions)
        }
    }
}
