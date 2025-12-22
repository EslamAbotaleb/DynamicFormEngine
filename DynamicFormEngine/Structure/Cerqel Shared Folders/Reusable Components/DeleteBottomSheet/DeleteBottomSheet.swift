//
//  DeleteEventVC.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 02/04/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class DeleteBottomSheet: BottomSheetVCCerqel {
    
    @IBOutlet weak var confirmationDeleteLbl: UILabel!
    @IBOutlet weak var deleteMsgLbl: UILabel!
    @IBOutlet weak var cancelBtn: LocalizedButton!
    @IBOutlet weak var xBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var fullDeleteMsg: String?
    var deleteMsg: String?
    var deleteObjectString: String?
    var didTapDelete: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if (fullDeleteMsg != nil){
            self.deleteMsgLbl.text = fullDeleteMsg ?? "_"
        }
        else{
            let attrs1 = [NSAttributedString.Key.font : UIFont.bodyLRegular(), NSAttributedString.Key.foregroundColor : typographyBody]
            
            let attrs2 = [NSAttributedString.Key.font : UIFont.bodyLMedium(), NSAttributedString.Key.foregroundColor : typographyTitle]
            
            let msg = "Are you sure you want to delete this".localized + " " + (deleteObjectString?.localized ?? "-") + " "
            let attributedString1 = NSMutableAttributedString(string: msg, attributes:attrs1)

            let attributedString2 = NSMutableAttributedString(string: "\"\(deleteMsg ?? "-")\"" , attributes:attrs2)

            attributedString1.append(attributedString2)
            self.deleteMsgLbl.attributedText = attributedString1
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
//        sheetViewController?.closeSheet()
        sheetViewController?.dismiss(animated: true)

    }
    
    @IBAction func cancelPressed(_ sender: Any) {
//        sheetViewController?.closeSheet()
        sheetViewController?.dismiss(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        didTapDelete?()
    }
}

extension DeleteBottomSheet {
    private func configureUI() {
        xBtn.tintColor = primaryMain
        confirmationDeleteLbl.textColor = typographyTitle
        confirmationDeleteLbl.font = UIFont.bodyLMedium()
                
        cancelBtn.setCancelButtonTheme()
        cancelBtn.setTitle("Cancel".localized, for: .normal)

        deleteBtn.titleLabel?.font = UIFont.buttonLSemibold()

    }
}
