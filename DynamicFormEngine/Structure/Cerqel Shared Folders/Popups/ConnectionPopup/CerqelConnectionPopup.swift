//
//  CerqelConnectionPopup.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 3/22/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

public class CerqelConnectionPopup: BottomSheetVCCerqel {
    @IBOutlet weak var okBtn: UIButton!

    var didTapOk: (()->())?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        okBtn.setTitle("Ok".localized, for: .normal)
        print("Ok")
    }
    
    @IBAction func okBtnTapped(){
        didTapOk?()
    }

}
