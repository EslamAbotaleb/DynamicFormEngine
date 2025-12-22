//
//  ChatFooterView.swift
//
//
//  Created by iSlam AbdelAziz on 1/31/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ChatFooterView: UIView {


    @IBOutlet weak var chatTxtV: UITextView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var attachmentCV: UICollectionView!

//    var delegate: ChatFooterMethods?
    
    var arrayOfAttachment: [ModelUploadedMedia] = []{
        didSet{
            if arrayOfAttachment.count > 0 {
                self.attachmentCV.isHidden = false
            }else{
                self.attachmentCV.isHidden = true
            }
            self.attachmentCV.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        create()

    }
    
    func create(){
        Bundle.main.loadNibNamed("ChatFooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        contentView.backgroundColor = UIColor.clear
        chatTxtV.text = "Add discussion comment....".localized
        chatTxtV.textColor = .slate_grey
        shadowView.cerqel_addNormalShadow()
        attachmentCV.register(ChatFooterAttachmentCVcell.cerqel_nib, forCellWithReuseIdentifier: ChatFooterAttachmentCVcell.cerqel_identifier)
    }

    
    
    @IBAction func sendMsgBtnTapped(){
////        if self.chatTxtV.text.count > 0{
//        self.delegate?.sendMessage(txt: self.chatTxtV.text ?? "")
//        chatTxtV.text = "Add discussion comment....".localized
//        chatTxtV.textColor = .slate_grey
////        }
    }
//
    @IBAction func attachmentBtnTapped(){
//        self.delegate?.sendAttachment()
    }


    
}

extension ChatFooterView: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "Add discussion comment....".localized{
            textView.text.removeAll()
            textView.textColor = .DarkBlack
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0{
            textView.text = "Add discussion comment....".localized
            textView.textColor = .slate_grey
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // as @nhgrif suggested, we can skip the string manipulations if
        // the beginning of the textView.text is not touched.
//        if range.location >= 200{
//            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//            let numberOfChars = newText.count
//            return numberOfChars < 200
//        }

        guard range.location == 0 else {
            return true
        }

        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
    }

}


extension ChatFooterView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAttachment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatFooterAttachmentCVcell.cerqel_identifier, for: indexPath) as! ChatFooterAttachmentCVcell
        cell.configure(arrayOfAttachment[indexPath.row])
        cell.removeBtnTapped = {
//            self.delegate?.didRemoveAttachment(idx: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.7
        return CGSize(width: width, height: 36)
    }
    
}
