//
//  SuccessBottomSheetWithNavigationLinkVC.swift
//  CERQEL
//
//  Created by Youxel on 05/06/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
internal import PanModal

class SuccessBottomSheetWithNavigationLinkVC: BaseView<BottomSheetBaseViewModel, SuccessItem> {

    @IBOutlet weak var successLbl: LocalizedLabel!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var linkLbl: UILabel!
    @IBOutlet weak var sheetView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()

        self.titleLbl.text = item.successMessage
        self.linkLbl.text = item.successDescription
    }
    
    private func configureUI() {
        self.titleLbl.font = UIFont.bodyLMedium()
        self.titleLbl.textColor = typographyTitle
        self.closeIcon.tintColor = primaryMain
    }

    @IBAction func closIconPressed(_ sender: Any) {
        dismiss(animated: true)
        item.successCallBack()
    }
    
    @IBAction func linkBtnPressed(_ sender: Any) {
        dismiss(animated: true)
        item.successCallBack()
    }
    
    // MARK: - PanModalPresentable

    override var panScrollable: UIScrollView? {
        return nil
    }

    override var longFormHeight: PanModalHeight {
        return .contentHeight(sheetView.bounds.height)

    }
    
    override var allowsExtendedPanScrolling: Bool { return false }
    override var allowsDragToDismiss: Bool { return false }
    override var allowsTapToDismiss: Bool { return false  }
    
}


