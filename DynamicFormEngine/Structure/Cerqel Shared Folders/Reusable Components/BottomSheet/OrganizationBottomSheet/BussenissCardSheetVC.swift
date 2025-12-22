//
//  BussenissCardSheetVC.swift
//  CERQEL
//
//  Created by Youxel on 06/06/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
import PanModal
/*
class EmpolyeeItem: BaseItem {
    var empolyee: OrgModel
    
    init( empolyee: OrgModel) {
        self.empolyee = empolyee
    }
}
class BussenissCardSheetVC: BaseView<BottomSheetBaseViewModel, EmpolyeeItem> {

    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var personalImage: UIImageView!
    @IBOutlet weak var imageShadwo: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var departmentNameLbl: UILabel!
    @IBOutlet weak var extentionNumberLbl: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        self.closeIcon.tintColor = primaryMain
        self.personName.text = item.empolyee.name
        self.jobTitleLbl.text = item.empolyee.jobTitle
        self.emailLbl.text = item.empolyee.email
        self.phoneLbl.text = item.empolyee.phone
        self.extentionNumberLbl.text = item.empolyee.extensionNumber
        self.departmentNameLbl.text = item.empolyee.department
        self.personalImage.loadWebImageWithUrl(imageUrl: item.empolyee.photo ?? "", placeHolder: UIImage(named: "dummy_user_profile")!) {[weak self] in
            self?.personalImage.loadSVGImageWithAuth(urlString: self?.item.empolyee.photo ?? "",
                                                     placeHolder: UIImage(named: "dummy_user_profile"),
                                                     targetSize: CGSize(width: 85, height: 85))
        }
    }
    
    @IBAction func closeIconPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - PanModalPresentable

       override var panScrollable: UIScrollView? {
           return nil
       }

       override var longFormHeight: PanModalHeight {
           return .contentHeight(sheetView.frame.height + 160)

       }
    
    override var shortFormHeight: PanModalHeight {
        return .contentHeight(sheetView.frame.height + 160)

    }
}
*/
