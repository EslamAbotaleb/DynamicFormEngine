//
//  reqTaskCommentTVcell.swift
//  KAFDHUB
//
//  Created by hassan elshaer on 30/05/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class reqTaskCommentTVcell: UITableViewCell {
    
    @IBOutlet weak var commentTxtView: UITextView!
    @IBOutlet weak var attachCollectionView: UICollectionView!
    
    var attachmentUploadTapped: (() ->())?
    var attachmentRemoveTapped: ((Int)->())?
    var didChangeText: ((String)->())?
    let placeHolderText = "Type your comment here".localized
    let placeholderTextColor = UIColor.textPlaceholderGrayDark
    var arrayOfAttachment: [ModelUploadedMedia] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTxtView.delegate = self
        commentTxtView.text = placeHolderText
        commentTxtView.textColor = placeholderTextColor
        registerCells()
    }
    
    
    func registerCells() {
        attachCollectionView.register(AttachCommentCVcell.cerqel_nib, forCellWithReuseIdentifier: AttachCommentCVcell.cerqel_identifier)
        attachCollectionView.delegate = self
        attachCollectionView.dataSource = self
        attachCollectionView.reloadData()
    }
    
    func configure(atts: [ModelUploadedMedia]) {
        arrayOfAttachment = atts
        attachCollectionView.reloadData()
   }
    
    
    @IBAction func addAttachBtnTapped(_ sender: Any) {
        if let action = attachmentUploadTapped {
            action()
        }
    }
    
    
    
}


//MARK: - collection view data source
extension reqTaskCommentTVcell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAttachment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachCommentCVcell.cerqel_identifier, for: indexPath) as! AttachCommentCVcell
        cell.configure(data: arrayOfAttachment[indexPath.row])
        cell.removeTapped = {[weak self] in
            guard let `self` = self else {return}
            if let action  = self.attachmentRemoveTapped {
                action(indexPath.row)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let width = collectionView.bounds.width / 2.1
        return CGSize(width: width, height: 24)
    }
    
}

extension reqTaskCommentTVcell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var tex = ""
        if textView.text == self.placeHolderText {
            tex = ""
        }else{
            tex = textView.text
        }
        self.didChangeText?(tex)

    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.placeHolderText {
            textView.text.removeAll()
            textView.textColor = .DarkBlack
        }
        
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0{
            textView.text = self.placeHolderText
            textView.textColor = UIColor.slate_grey.withAlphaComponent(0.4)
        }
        return true
    }

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // as @nhgrif suggested, we can skip the string manipulations if
        // the beginning of the textView.text is not touched.
        guard range.location == 0 else {
            return true
        }

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
    }
    
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        // Hide the placeholder text when the user begins editing
//        if textView.text == placeholderText {
//            textView.text = ""
//            textView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        // Show the placeholder text again if the user didn't enter anything
//        if textView.text.isEmpty {
//            textView.text = placeholderText
//            textView.textColor = placeholderTextColor
//        }
//    }
}
