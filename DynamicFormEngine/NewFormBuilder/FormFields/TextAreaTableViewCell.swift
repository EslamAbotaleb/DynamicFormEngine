//
//  TextAreaTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 12/10/2021.
//

import UIKit
import RichEditorView


class TextAreaTableViewCell: ParentFieldTableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    @IBOutlet weak var fullScreenButtonView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var resizeImageView: UIImageView!
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelTextAreaItem {
                setupWith(item: item)
            }
        }
    }
    
    var textViewEndEditing: ((TextAreaAnswer?, Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.attachmentView = attachmentNoteView
        super.objectOuterViews = [outerView]
        
        textView.delegate = self
//        outerView.layer.borderColor = UIColor(r: 208, g: 217, b: 226).cgColor
        outerView.layer.borderWidth = 1
        outerView.layer.cornerRadius = 4
//        textView.adjustAutoAlignment()
    }

    func setupWith(item: FormViewModelTextAreaItem) {
        labelView.item = item
        labelView.required = item.required
        textView.text = ""
//        textView.placeholder = item.placeHolder
        if let defaultValue = item.defaultAnswer?.value {
            textView.text = defaultValue
        }
        if let value = (item.answer as? TextAreaAnswer)?.value {
            textView.text = value
        }
        
        attachmentNoteView.item = item
        
        if item.allowSpellCheck ?? false {
            textView.spellCheckingType = .yes
        } else {
            textView.spellCheckingType = .no
        }
        textView.autocapitalizationType = .words
        
        if let fullScreen = item.fullScreen, let autoExpand = item.autoExpand {
            if fullScreen || autoExpand {
                fullScreenButtonView.isHidden = false
            } else {
                fullScreenButtonView.isHidden = true
            }
            fullScreenButton.isHidden = !fullScreen
            resizeImageView.isHidden = !autoExpand
            textView.isScrollEnabled = !autoExpand
        }
        updateErrorState(item.isError, with: "")
    }
    
//    @IBAction func fullScreenAction(_ sender: UIButton) {
//        let addNoteVC = Utilities.instantiateVCWithId("addNoteVC") as! AddNoteViewController
//        addNoteVC.delegate = self
//        addNoteVC.note = textView.text
//        addNoteVC.fullScreenTextView = true
//        addNoteVC.fieldTitle = (item as? FormViewModelTextAreaItem)?.label
//        self.parentContainerViewController()?.present(addNoteVC, animated: true, completion: nil)
//    }
    
    func checkError() -> Bool {
        if textView.text.lowercased().contains("error") {
            return true
        } else {
            return false
        }
    }
    
    func checkTextValueAndNotify(_ text: String) {
        textViewEndEditing?(TextAreaAnswer(val: text, htmlVal: text), checkError())
    }
}

extension TextAreaTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let autoExpand = (item as? FormViewModelTextAreaItem)?.autoExpand, autoExpand {
            let startHeight = textView.frame.size.height
            let calcHeight = textView.sizeThatFits(textView.frame.size).height
//            if startHeight != calcHeight, let formVC = self.parentContainerViewController() as? FormViewController {
//                UIView.setAnimationsEnabled(false) // Disable animations
//                formVC.activeTableView.beginUpdates()
//                formVC.activeTableView.endUpdates()
//                UIView.setAnimationsEnabled(true)  // Re-enable animations.
//            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        if let item = item as? FormViewModelTextAreaItem, let entryLimit = item.entryLimit {
            let result = FormBuilder.shared.handleEntryLimit(entryLimit, changedText: changedText, item: item, row: item.fieldId)
            if result.shouldChange {
                attachmentNoteView.characterCountLabel.text = result.countLabel
                updateErrorState(result.isError, with: result.errorMessage)
            }
            return result.shouldChange
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkTextValueAndNotify(textView.text)
    }
}

//extension TextAreaTableViewCell: AddNoteDelegate {
//    func noteChangedWith(_ note: String) {
//        textView.text = note
//        checkTextValueAndNotify(note)
//    }
//}
