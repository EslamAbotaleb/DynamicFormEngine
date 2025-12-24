//
//  SuccessBottomSheetViewController.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 19/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import PanModal

typealias SuccessCallBack =  (()->())

open class SuccessItem: BaseItem {
    var successCallBack: SuccessCallBack
    var successMessage:String
    var successDescription:String?

    init(_ successCallBack: @escaping SuccessCallBack,_ successMessage: String,_ successDescription: String? = "") {
        self.successCallBack = successCallBack
        self.successMessage = successMessage
        self.successDescription = successDescription
    }
}


open class SuccessBottomSheetViewController: BaseView<FileActionsViewModel, SuccessItem> {

    @IBOutlet weak var successBodyLbl: UILabel!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var closeButton: LocalizedButton!
    @IBOutlet weak var describtionLbl: UILabel!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()

        self.successBodyLbl.text = item.successMessage
        self.describtionLbl.text = item.successDescription
    }

    private func configureUI() {
        self.titleLbl.font = UIFont.bodyLMedium()
        self.titleLbl.textColor = typographyTitle
        self.closeIcon.tintColor = primaryMain
        self.closeButton.tintColor = primaryMain
    }


    // MARK: - PanModalPresentable

    override public var panScrollable: UIScrollView? {
        return nil
    }

    override public var longFormHeight: PanModalHeight {
        return .contentHeight(420)
    }
    
    override public var allowsDragToDismiss: Bool {
        return false
    }


    override public var allowsTapToDismiss: Bool {
        return false
    }

    @IBAction func closeIconPressed(_ sender: Any) {
        dismiss(animated: true)
        item.successCallBack()

    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
        item.successCallBack()


    }
}
