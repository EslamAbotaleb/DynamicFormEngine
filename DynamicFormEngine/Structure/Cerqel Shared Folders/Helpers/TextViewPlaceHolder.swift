//
//  HintPlaceHolder.swift
//  bblash
//
//  Created by Khaled on 5/31/17.
//  Copyright © 2017 khalid. All rights reserved.
//




import UIKit
@IBDesignable class TextViewPlaceHolder: UITextView {

    override var text: String! { // Ensures that the placeholder text is never returned as the field's text
        get {
            if showingPlaceholder {
                return "" // When showing the placeholder, there's no real text to return
            } else {
                return super.text
                
            }
        }
        set { super.text = newValue }
    }
    var currentText: String = "" {
        didSet {
            guard  currentText != "" else {
                return
            }
             updateLayout()
        }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    
    private var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    private var originalTextColor = UIColor.black
    private var showingPlaceholder: Bool = true // Keeps track of whether the field is currently showing a placeholder

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
        }
    }

    override func becomeFirstResponder() -> Bool {
        // If the current text is the placeholder, remove it
        if showingPlaceholder {
            text = nil
            textColor = nil // Put the text back to the default, unmodified color
            showingPlaceholder = false
        }
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        // If there's no text, put the placeholder backn
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func updateLayout() {
        showingPlaceholder = false
        textColor = originalTextColor
        tintColor = UIColor.black
        text = currentText
    }

    private func showPlaceholderText() {
        showingPlaceholder = true
        textColor = placeholderTextColor
        tintColor = UIColor.black
        self.font = UIFont.bodyLRegular(ofSize: 16)
        textContainerInset = padding
        text = placeholderText.localized
    }
}
