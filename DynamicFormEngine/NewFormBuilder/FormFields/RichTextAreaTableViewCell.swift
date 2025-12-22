//
//  RichTextAreaTableViewCell.swift
//  CHECK
//
//  Created by Yasser Osama on 13/10/2021.
//

import UIKit


class RichTextAreaTableViewCell: ParentFieldTableViewCell {

    @IBOutlet weak var labelView: LabelView!
    @IBOutlet weak var richTextView: RichTextView!
    @IBOutlet weak var attachmentNoteView: AttachmentNoteView!
    
    
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelTextAreaItem {
                labelView.item = item
                labelView.required = item.required
                richTextView.editorView.html = ""
                if let defaultValue = item.defaultAnswer?.value {
                    richTextView.editorView.html = defaultValue
                }
                if let value = item.answer as? TextAreaAnswer {
                    richTextView.editorView.html = value.value ?? ""
                }
                attachmentNoteView.item = item
                richTextView.fieldLabel = item.label
                richTextView.fullScreen = item.fullScreen ?? false
                updateErrorState(item.isError, with: "")
            }
        }
    }
    
    var isCardMode: Bool! {
        didSet {
            richTextView.isCardMode = isCardMode
        }
    }
    
    var valueChanged: ((TextAreaAnswer?) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        super.attachmentView = attachmentNoteView
        super.objectOuterViews = [richTextView]
        
        richTextView.delegate = self
    }
    
    func checkRichTextValueAndNotify(_ text: String) {
        if text.isEmpty {
            valueChanged?(nil)
        } else {
            valueChanged?(TextAreaAnswer(val: text, htmlVal: text))
        }
    }
}

extension RichTextAreaTableViewCell: RichTextViewDelegate {
    func editorLostFocusWith(_ html: String) {
        checkRichTextValueAndNotify(html)
    }
    
    func editorContentChanged(_ content: String) {
        if let maxLimit = (item as? FormViewModelTextBaseItem)?.maximumLength, let entryLimit = (item as? FormViewModelTextBaseItem)?.entryLimit {
            if entryLimit == .Character {
                if content.count <= maxLimit {
                    attachmentNoteView.characterCountLabel.text = "\(content.count)/\(maxLimit)"
                }
            } else if entryLimit == .Word {
                let spaces = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
                let words = content.components(separatedBy: spaces)
                if words.count <= maxLimit {
                    attachmentNoteView.characterCountLabel.text = "\(words.count)/\(maxLimit)"
                }
            }
        }
    }
}

//extension RichTextAreaTableViewCell: AddNoteDelegate {
//    func noteChangedWith(_ note: String) {
//        checkRichTextValueAndNotify(note)
//    }
//}
