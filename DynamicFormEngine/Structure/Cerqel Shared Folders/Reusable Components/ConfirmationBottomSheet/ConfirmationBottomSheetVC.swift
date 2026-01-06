//
//  ConfirmationBottomSheetVC.swift
//  CERQEL
//
//  Created by Youxel on 08/08/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
internal import PanModal

public typealias ConfirmationCallBack =  (()->())

public class ConfirmationItem: BaseItem {
    var confirmationCallBack: ConfirmationCallBack
    var confirmationTitle: String?
    var confirmationMessage: String?
    var confirmationBtnTitle: String?
    var confirmationImageName: String?

    public init(confirmationCallBack: @escaping ConfirmationCallBack,confirmationTitle: String?, confirmationMessage: String?, confirmationBtnTitle: String?, confirmationImageName: String?) {
        self.confirmationCallBack = confirmationCallBack
        self.confirmationTitle = confirmationTitle
        self.confirmationMessage = confirmationMessage
        self.confirmationBtnTitle = confirmationBtnTitle
        self.confirmationImageName = confirmationImageName
    }
}

class ConfirmationBottomSheetVC: BaseView<BottomSheetBaseViewModel, ConfirmationItem> {
    
    @IBOutlet weak var titleLbl: LocalizedLabel!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var confirmationMEssageLbl: LocalizedLabel!
    @IBOutlet weak var cancelBtn: LocalizedButton!
    @IBOutlet weak var confirmBtn: LocalizedButton!
    @IBOutlet weak var confirmationImage: UIImageView!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configure(confirmationTitle: String?,confirmationMessage: String?,confirmationBtnTitle: String?,confirmationImageName: String?) {
        if (item.confirmationTitle != nil)  {titleLbl.text = item.confirmationTitle}
        if (item.confirmationMessage != nil)  {confirmationMEssageLbl.text = item.confirmationMessage}
        if (item.confirmationBtnTitle != nil)  {confirmBtn.setTitle(item.confirmationBtnTitle, for: .normal) }
        if (item.confirmationImageName != nil)  {confirmationImage.image = UIImage(named: item.confirmationImageName!)}
    }
    
    override public var longFormHeight: PanModalHeight {
        return .contentHeight(450)
    }
    
    @IBAction func closeIconPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func leaveBtn(_ sender: Any) {
        item.confirmationCallBack()
    }
    
}

extension ConfirmationBottomSheetVC {
    private func configureUI() {
        confirmationMEssageLbl.textColor = typographyTitle
        confirmationMEssageLbl.font = UIFont.bodyLMedium()
        closeIcon.tintColor = primaryMain
        
        cancelBtn.setCancelButtonTheme()
        cancelBtn.setTitle("Cancel".localized, for: .normal)

        confirmBtn.setSubmitButtonTheme()
        confirmBtn.setTitle("Leave".localized, for: .normal)

    }
}



