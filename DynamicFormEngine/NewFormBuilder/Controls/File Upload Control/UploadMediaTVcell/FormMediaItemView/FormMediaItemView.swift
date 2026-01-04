//
//  FormMediaItemView.swift
//
//
//  Created by Marwan on 15/02/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit
internal import NicoProgress

class FormMediaItemView: UIView {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet var dashedView: CustomDashedView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton! {
        didSet {
            cancelBtn.tintColor = primaryMain
        }
    }
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.tintColor = primaryMain
            deleteButton.layer.cornerRadius = 6
            deleteButton.layer.borderWidth = 1
            deleteButton.layer.borderColor = primaryMain.cgColor
        }
    }
    @IBOutlet weak var progressBar: NicoProgressBar!
    @IBOutlet weak var dawnloadFileBtn: UIButton! {
        didSet {
            dawnloadFileBtn.tintColor = primaryMain
        }
    }
    
    
    // MARK: - Delegates
    
    var didTapRemove: (()->())?
    var didTapDawnload: (()->())?
    
    
    // MARK: - Variables
    
    var item:UploadMediaUIModel?
    var defaultItem:File?
    var isDisabled: Bool?
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Functions
    
    /// initiating FormMediaItemView
//    private func commonInit() {
//        Bundle.main.loadNibNamed("FormMediaItemView", owner: self, options: nil)
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        layoutIfNeeded()
//    }

    private func commonInit() {
        let bundle = Bundle(for: Self.self)
        
        guard bundle.loadNibNamed("FormMediaItemView", owner: self, options: nil) != nil else {
            fatalError("Could not load FormMediaItemView from DynamicFormEngine framework")
        }

        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        layoutIfNeeded()
    }

    
    /// handling ui based on isRequest flag
    /// - Parameters:
    ///   - isRequest: is it presented in request details or not
    ///   - isDisable: is fileupload item disabled or not
    func handleHiddenBtnViews(isRequest: Bool,isDisable: Bool) {
        if isRequest {
            deleteButton.isHidden = true
            dashedView.dashColor = .lightGray
        }else {
            dashedView.dashColor = .clear
            deleteButton.isUserInteractionEnabled = !isDisable
            deleteButton.isHidden = isDisable
        }
        
        cancelBtn.isHidden = isRequest
        dawnloadFileBtn.isHidden = !isRequest
    }
    
    /// handling ui in case of inProgress uploading attachment
    func inProgressCase() {
        fileNameLbl.isHidden = true
        progressBar.isHidden = false
        fileImageView.alpha = 0.3
        deleteButton.alpha = 0
        cancelBtn.alpha = 1
        progressBar.transition(to: .indeterminate)
    }
    
    /// handling ui in case of media uploaded successfully
    /// - Parameter isRequest: is it presented in request details or not
    func uploadedSucceessfullyCase(isRequest: Bool?) {
        fileNameLbl.isHidden = false
        fileNameLbl.textColor = .black
        fileNameLbl.text = item?.uploadedMedia?.name
        if ((item?.uploadedMedia?.documentType?.lowercased().contains("pdf")) ?? false) {
            fileImageView.image = UIImage(named: "pdff")
        }else if (item?.uploadedMedia?.documentType?.lowercased().contains("jpg") ?? false) || (item?.uploadedMedia?.documentType?.lowercased().contains("jpeg") ?? false)  || (item?.uploadedMedia?.documentType?.lowercased().contains("png") ?? false)    {
            fileImageView.image = UIImage(named: "jpeg")
        }else if (item?.uploadedMedia?.documentType?.lowercased().contains("mov") ?? false) {
            fileImageView.image = UIImage(named: "video_files_ic")
        } else {
            fileImageView.image = UIImage(named: "attachment-1")
        }
        progressBar.isHidden = true
        fileImageView.alpha = 1
        cancelBtn.alpha = 0
        deleteButton.alpha = isRequest ?? false ? 0 : 1
    }
    
    /// handling ui in case of media failed to upload
    /// - Parameter isRequest: is it presented in request details or not
    func failedUploadingCase(isRequest: Bool?) {
        fileNameLbl.isHidden = false
        fileNameLbl.textColor = .redSupport
        fileNameLbl.text = "Something went wrong..."
        progressBar.isHidden = true
        fileImageView.alpha = 0.3
        cancelBtn.alpha = 0
        deleteButton.alpha = isRequest ?? false ? 0 : 1
    }
    
    /// setting up ui for uploading media
    /// - Parameters:
    ///   - item: media to be uploaded
    ///   - isRequest: is it presented in request details or not
    func setup(_ item: UploadMediaUIModel?,isRequest: Bool? = false){
        self.item = item
        handleHiddenBtnViews(isRequest: isRequest ?? false,isDisable: isDisabled ?? false)
        switch item?.state {
        case .inProgress(_):
            inProgressCase()
        case .success:
            uploadedSucceessfullyCase(isRequest: isRequest)
        case .failed:
            failedUploadingCase(isRequest: isRequest)
        case .none:
            break
        }
    }

    
    // MARK: - IBActions
    
    /// fired when user press on delete button
    @IBAction func removeBtnTapped(){
        didTapRemove?()
    }
    
    /// fired when user press on X button
    /// - Parameter sender: cancel button
    @IBAction func cancelPressed(_ sender: Any) {
        guard let item = self.item else {return}
        item.request?.cancel()
    }
    
    /// fired when user press on download button
    /// - Parameter sender: download button
    @IBAction func dawnloadFileBtn(_ sender: UIButton) {
        didTapDawnload?()
    }
}
