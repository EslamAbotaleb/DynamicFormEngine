//
//  RichTextView.swift
//  CHECK
//
//  Created by Yasser Osama on 07/12/2021.
//

import UIKit
import RichEditorView

protocol RichTextViewDelegate: AnyObject {
    func editorLostFocusWith(_ html: String)
    func editorContentChanged(_ content: String)
}

class RichTextView: UIView {

    let contentXibName = "RichTextView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var editorView: RichEditorView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var fullScreenView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    
    weak var delegate: RichTextViewDelegate? = nil
    var isCardMode = false
    var fieldLabel = ""
    var fullScreen: Bool! {
        didSet {
            if fullScreen {
                fullScreenView.isHidden = false
                fullScreenButton.isHidden = false
            } else {
                fullScreenView.isHidden = true
                fullScreenButton.isHidden = true
            }
        }
    }
    var isFromFullScreen = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.cerqel_fixInView(self)
        
        setupUI()
    }
    
    func setupUI() {
//        outerView.layer.borderColor = UIColor(r: 208, g: 217, b: 226).cgColor
        outerView.layer.borderWidth = 1
        outerView.layer.cornerRadius = 4
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "Done".localized, style: .done, target: self, action: #selector(doneAction))
        
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        editorView.inputAccessoryView = toolbar
        
        editorView.clipsToBounds = true
        editorView.isScrollEnabled = true
        editorView.delegate = self
        editorView.placeholder = "Type here"
        
        for (i, button) in buttonsCollection.enumerated() {
            button.tag = i
        }
    }
    
    @objc func doneAction() {
        editorView.endEditing(true)
    }
    
    @IBAction func propertiesAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            editorView.bold()
        case 1:
            editorView.italic()
        case 2:
            editorView.underline()
        case 3:
            editorView.orderedList()
        case 4:
            editorView.unorderedList()
        case 5:
            editorView.alignLeft()
        case 6:
            editorView.alignCenter()
        case 7:
            editorView.alignRight()
        case 8:
            showColorPicker(true)
        case 9:
            showColorPicker(false)
        default:
            break
        }
        if sender.tag != 8 || sender.tag != 9 {
            if sender.tintColor == .black {
//                sender.tintColor = .primaryColor
                if sender.tag == 5 || sender.tag == 6 || sender.tag == 7 {
                    handleAlignButtons(current: sender.tag)
                } else if sender.tag == 3 || sender.tag == 4 {
                    handleListButtons(current: sender.tag)
                }
            } else {
                sender.tintColor = .black
            }
        }
    }
    
    func handleAlignButtons(current: Int) {
        let alignButtons = [5, 6, 7]
        for buttonIndex in alignButtons {
            if buttonIndex != current {
                buttonsCollection[buttonIndex].tintColor = .black
            }
        }
    }
    
    func handleListButtons(current: Int) {
        let listButtons = [3, 4]
        for buttonIndex in listButtons {
            if buttonIndex != current {
                buttonsCollection[buttonIndex].tintColor = .black
            }
        }
    }
    
    @IBAction func fullScreenAction(_ sender: UIButton) {
//        let addNoteVC = Utilities.instantiateVCWithId("addNoteVC") as! AddNoteViewController
//        addNoteVC.delegate = self
//        addNoteVC.note = editorView.contentHTML
//        addNoteVC.fullScreenRichText = true
//        addNoteVC.fieldTitle = fieldLabel
//        self.parentContainerViewController()?.present(addNoteVC, animated: true, completion: nil)
    }
    
    func showColorPicker(_ isText: Bool) {
//        let colorPickerVC = Utilities.instantiateVCWithId("colorPickerVC") as! ColorPickerViewController
////        colorPickerVC.modalPresentationStyle = .overFullScreen
//        colorPickerVC.delegate = self
//        colorPickerVC.isText = isText
//        self.parentContainerViewController()?.present(colorPickerVC, animated: true, completion: nil)
    }
}

extension RichTextView: RichEditorDelegate {
    func richEditorTookFocus(_ editor: RichEditorView) {
        if isCardMode, !Utilities.deviceIsIpad(), !isFromFullScreen {
            UIView.animate(withDuration: 0.2) {
//                self.parentContainerViewController()?.view.frame.origin.y -= 180
            }
        }
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        if isCardMode, !Utilities.deviceIsIpad(), !isFromFullScreen {
            UIView.animate(withDuration: 0.2) { [weak self] in
//                self?.parentContainerViewController()?.view.frame.origin.y = 0
            }
        }
        if !isFromFullScreen {
            delegate?.editorLostFocusWith(editor.contentHTML)
        }
    }
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        delegate?.editorContentChanged(content)
    }
}

//extension RichTextView: ColorPickerDelegate {
//    func colorSelected(color: UIColor, isText: Bool) {
//        if isText {
//            editorView.setTextColor(color)
//        } else {
//            editorView.setTextBackgroundColor(color)
//        }
//    }
//}
//
//extension RichTextView: AddNoteDelegate {
//    func noteChangedWith(_ note: String) {
//        editorView.html = note
//        delegate?.editorLostFocusWith(note)
//    }
//}
