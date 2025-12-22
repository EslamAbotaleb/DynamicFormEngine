//
//  NPSTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 12/04/2022.
//

import UIKit


class NPSTableViewCell: ParentFieldTableViewCell {
    
    @IBOutlet weak var labelView: LabelView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelNPSItem {
                labelView.item = item
                labelView.required = item.required
                attachmentNoteView.item = item
                if let value = (item.answer as? BaseAnswerNumber)?.value {
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
            buttonsCollection.forEach {
                $0.isUserInteractionEnabled = isEditable
            }
        }
    }
    
    var selectedRate = 0 {
        didSet {
            for btn in buttonsCollection {
                if btn.tag == selectedRate {
//                    btn.backgroundColor = .primaryColor
                    btn.setTitleColor(.white, for: .normal)
                } else {
                    btn.backgroundColor = .clear
//                    btn.setTitleColor(.checkText, for: .normal)
                }
            }
        }
    }
    
    var valueChanged: ((BaseAnswerNumber?) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.attachmentView = attachmentNoteView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            for btn in self.buttonsCollection {
//                btn.layer.borderColor = UIColor.normalBorderColor.cgColor
                btn.layer.borderWidth = 1
                
//                btn.roundCorners()
//                if Localizer.currentAppLanguageArabic() {
//                    btn.setTitle(btn.title(for: .normal)?.toArabic, for: .normal)
//                }
            }
        }
    }
    
    @IBAction func rateAction(_ sender: UIButton) {
        if selectedRate == sender.tag {
            selectedRate = 0
            valueChanged?(nil)
        } else {
            selectedRate = sender.tag
//            valueChanged?(BaseAnswerNumber(val: Double(selectedRate)))
        }
    }
}
