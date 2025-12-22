//
//  ActionCommentTVcell.swift
// 
//
//  Created by Abdallah Elmahlawy on 3/17/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ActionCommentTVcell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextView!

    var placeHolderText = "Example of additional information to provide: Any error messages received or description of issue(s)".localized
    var didChangeText: ((String)->())?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func configure(texVal: String) {
        self.titleLbl.text = "Comments".localized
        if texVal == ""{
            valueTF.text = self.placeHolderText
            valueTF.textColor = UIColor.slate_grey.withAlphaComponent(0.4)
        }else{
            valueTF.text = texVal
            valueTF.textColor = .DarkBlack
        }



    }
}


extension ActionCommentTVcell: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var tex = ""
        if textView.text == self.placeHolderText{
            tex = ""
        }else{
            tex = textView.text
        }
        self.didChangeText?(tex)

    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == self.placeHolderText{
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

}

