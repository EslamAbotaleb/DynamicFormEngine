//
//  SuccessEditEventVC.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 02/04/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class SuccessAddEditEventVC: BottomSheetVCCerqel  {
    
    var isEdit: Bool?
    
    @IBOutlet weak var successLbl: UILabel!
    @IBOutlet weak var successMsg: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var xBtn: UIButton!
    
    var didTapClose: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if isEdit ?? false {
            successMsg.text = "Your request has been edited successfully".localized
        } else {
            successMsg.text = "Your request has been added successfully".localized
        }
    }

    @IBAction func closePressed(_ sender: Any) {
        didTapClose?()
    }
}

extension SuccessAddEditEventVC {
    private func configureUI() {
        successLbl.textColor = typographyTitle
        successMsg.textColor = typographyTitle
        closeBtn.backgroundColor = primaryMain
        successLbl.font = UIFont.bodyLMedium()
        successMsg.font = UIFont.subtitleLRegular()
        closeBtn.titleLabel?.font = UIFont.bodyLSemibold()
        xBtn.tintColor = primaryMain
    }
}
