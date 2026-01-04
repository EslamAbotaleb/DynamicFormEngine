//
//  RateTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 12/04/2022.
//

import UIKit
internal import Cosmos

class RateTableViewCell: ParentFieldTableViewCell {
    
    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!

    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelRateItem {
                labelView.item = item
                labelView.required = item.required
                attachmentNoteView.item = item
                
                rateView.settings.totalStars = item.scale ?? 5
                rateView.rating = 0
                if let defValue = item.defaultAnswer?.value as? Double {
                    rateView.rating = defValue
                }
                if let value = (item.answer as? BaseAnswerText)?.value {
//                    rateView.rating = value
                }
                handleRateType(item)
                
                rateView.settings.starMargin = 4
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.rateView.settings.starSize = ((self.frame.width - 48)/(CGFloat(item.scale ?? 5))) - (self.rateView.settings.starMargin)
                    if self.rateView.settings.starSize > 40 {
                        self.rateView.settings.starSize = 40
                    }
                }
                handleHideAttachment(isEditable, item: item)
            }
        }
    }
    
    var isEditable: Bool! = true {
        didSet {
            attachmentNoteView.isEditable = isEditable
            labelView.isEditable = isEditable
            rateView.isUserInteractionEnabled = isEditable
        }
    }
    
    var valueChanged: ((BaseAnswerText?) -> ())?
//    var rateColor: UIColor = .primaryColor
    var selectedRate: Double = 0 {
        didSet {
            rateView.rating = selectedRate
//            valueChanged?(BaseAnswerNumber(val: selectedRate))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.attachmentView = attachmentNoteView
        
        rateView.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else {
                return
            }
            if rating == self.selectedRate {
                self.selectedRate = 0
            } else {
                self.selectedRate = rating
            }
        }
    }
    
    func handleRateType(_ item: FormViewModelRateItem) {
        if let rateColor = item.rateColor {
//            self.rateColor = UIColor(hex: rateColor)
        }
        if let rateType = item.rateType {
            switch rateType {
            case .Star:
                rateView.settings.emptyImage = UIImage(named: "starEmpty")
                rateView.settings.filledImage = UIImage(named: "starFilled")//?.maskWithColor(color: rateColor)
            case .Heart:
                rateView.settings.emptyImage = UIImage(named: "heartEmpty")
                rateView.settings.filledImage = UIImage(named: "heartFilled")//?.maskWithColor(color: rateColor)
            case .Thumb:
                rateView.settings.emptyImage = UIImage(named: "thumbEmpty")
                rateView.settings.filledImage = UIImage(named: "thumbFilled")//?.maskWithColor(color: rateColor)
            }
        }
    }
}
