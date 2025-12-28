//
//  SubmittedSuccessRequestBottomSheet.swift
//  KAFDHUB
//
//  Created by Hassan elshair on 21/05/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
//internal import FittedSheetsDF
import RxCocoa
internal import RxSwift

protocol Popup {
    func popup()
}

struct successRequestData{
    var service: String
    var title: String
    var description: String
    var isRequest: Bool
    var reqId: String
}

class SubmittedSuccessRequestBottomSheet: BottomSheetVCCerqel {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var serviceTitleLbl: LocalizedLabel!
    @IBOutlet weak var successMessageLbl: LocalizedLabel!
    @IBOutlet weak var descriptionLbl: LocalizedLabel!
    @IBOutlet weak var submitViewBtn: LocalizedButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var submitContainerView: UIView!
    
    
    // MARK: - Variables
    
    static var viewAllTapped:(() -> ())?
    static var navigateToRequests:((Bool, String) -> ())?
    static var delegate: Popup?
    var isRequest = false
    var reqId = ""
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
    }
    
    
    // MARK: - Functions
    
    private func updateUI() {
        [containerView, topView].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        let layer = btnsView.layer
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: -0.5)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5

    }
    
    static func open(presenter vc: UIViewController, data:successRequestData, fromDetails: Bool) {
        let submittedSheet = SubmittedSuccessRequestBottomSheet()
        let mySize: SheetSize = .fixed(490)
        let sheet = SheetViewController(controller: submittedSheet, sizes: [mySize])
        
        sheet.handleColor = UIColor.clear
        sheet.adjustForBottomSafeArea = true
        sheet.blurBottomSafeArea = false
        sheet.extendBackgroundBehindHandle = false

        vc.present(sheet, animated: false, completion: nil)
        submittedSheet.passData(data: data, fromDetails: fromDetails)
    }
    
    func passData(data: successRequestData?, fromDetails: Bool){
        DispatchQueue.main.async {
            self.submitContainerView.isHidden = fromDetails
            self.serviceTitleLbl.text = data?.service
            self.successMessageLbl.text = data?.title
            self.descriptionLbl.text = data?.description
            self.isRequest = data?.isRequest ?? false
            self.submitViewBtn.isHidden = !(data?.isRequest ?? false)
            self.submitViewBtn.setTitle((data?.isRequest ?? false) ? "View Request".localized : "", for: .normal)
            if let requestID = data?.description.components(separatedBy: "#").last  {
                let id = requestID
                self.reqId = id
            }
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func dismissTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            if let delegate = SubmittedSuccessRequestBottomSheet.delegate {
                delegate.popup()
            }
        }
    }
    
    @IBAction func submitViewBtnTapped(_ sender: Any) {
        dismiss(animated: true) {
            SubmittedSuccessRequestBottomSheet.navigateToRequests?(self.isRequest, self.reqId)
        }
    }
}

extension SubmittedSuccessRequestBottomSheet {
    private func configureUI() {
        closeBtn.layer.borderColor = primaryMain.cgColor
        closeBtn.setTitleColor(primaryMain, for: .normal)
        submitViewBtn.backgroundColor = primaryMain
    }
}
