//
//  ReportFooterTVCell.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 19/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class ReportFooterTVCell: UITableViewHeaderFooterView {

//    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: LocalizedLabel!
    
    var reasonSpecified: ((String)->())!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        setupUI()
    }

  
    
    func setupUI(){
        textView.text = "Please specify the reason".localized
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 8
        textView.layer.borderColor =  UIColor.cerqelColorGray3.cgColor
        textView.frame.size.height = 110
        textView.textAlignment = isArabicCerqel() ? .right : .left
        titleLabel.textAlignment = isArabicCerqel() ? .right : .left
    }
    

}
extension ReportFooterTVCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        reasonSpecified(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 500 // 10 Limit Value
    }

    
}

