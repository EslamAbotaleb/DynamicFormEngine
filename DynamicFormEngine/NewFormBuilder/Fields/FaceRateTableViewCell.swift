//
//  FaceRateTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 14/04/2022.
//

import UIKit


class FaceRateTableViewCell: ParentFieldTableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet var facesCollection: [UIButton]!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelFaceRateItem {
                labelView.item = item
                labelView.required = item.required
                attachmentNoteView.item = item
                selectedRate = 0
                if let defValue = item.defaultAnswer?.value {
//                    selectedRate = Int(defValue)
                }
                if let value = (item.answer as? BaseAnswerText)?.value {
//                    selectedRate = Int(value)
                }
                handleHideAttachment(isEditable, item: item)
            }
        }
    }
    
    var isEditable: Bool! = true {
        didSet {
            attachmentNoteView.isEditable = isEditable
            labelView.isEditable = isEditable
            facesCollection.forEach {
                $0.isUserInteractionEnabled = isEditable
            }
        }
    }
    
    var valueChanged: ((BaseAnswerText?) -> ())?
    
    var selectedRate = 0 {
        didSet {
            for button in facesCollection {
                if button.tag == selectedRate {
                    button.imageView?.tintColor = UIColor(named: "face\(selectedRate)")
                } else {
//                    button.imageView?.tintColor = .normalBorderColor
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.attachmentView = attachmentNoteView
    }
    
    @IBAction func faceAction(_ sender: UIButton) {
        if selectedRate == sender.tag {
            selectedRate = 0
            valueChanged?(nil)
        } else {
            selectedRate = sender.tag
//            valueChanged?(BaseAnswerNumber(val: Double(selectedRate)))
        }
    }
}
