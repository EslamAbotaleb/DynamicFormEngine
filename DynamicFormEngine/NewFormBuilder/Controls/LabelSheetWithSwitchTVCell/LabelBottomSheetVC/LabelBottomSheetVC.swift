//
//  LabelBottomSheetVC.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 28/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class LabelBottomSheetVC: BottomSheetVCCerqel {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var lblTextView: UITextView!
    
    
    
    // MARK: - Variables
    
    var item: FormViewModelItem?
    var currentVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    static func instance(item: FormViewModelItem?) -> LabelBottomSheetVC{
        let vc = LabelBottomSheetVC(nibName: "LabelBottomSheetVC", bundle: nil)
        vc.cerqel_sheetHeight = 400
        vc.item = item
        return vc
    }
    
    func show(vc: UIViewController, sender: Any?) {
        OperationQueue.main.addOperation {
            
            self.currentVC = vc
            //            self.modalPresentationStyle = .overFullScreen
            self.currentVC.view.endEditing(true)
            //            self.currentVC.present(self, animated: true, completion: nil)
            self.currentVC.cerqel_presentSheetController(viewToPresent: self, height: self.cerqel_sheetHeight)
            
            
        }
    }
    
    
    // MARK: - Functions
    
    func setData() {
        guard let item = item else {return}
        guard let localization = item.localization as? ParagraphLocalization else { return }
        if let paragraphItem = item as? FormViewModelParagraphItem {
            titleLbl.text = (isArabicCerqel() ?  localization["ar"]?.label ?? "" :  localization["en"]?.label) ?? ""
            lblTextView.text = (paragraphItem.answer as? ParagraphAnswer)?.htmlValue?.cerqel_htmlToString
        }
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func exitTapped() {
        dismiss(animated: true, completion: nil)
    }

}


extension LabelBottomSheetVC {
    private func configureUI() {
        titleLbl.textColor = typographyTitle
        closeBtn.tintColor = primaryMain
        view.backgroundColor = bgHeader
        separatorView.backgroundColor = typographyBody
        lblTextView.textColor = typographyTitle
    }
}
