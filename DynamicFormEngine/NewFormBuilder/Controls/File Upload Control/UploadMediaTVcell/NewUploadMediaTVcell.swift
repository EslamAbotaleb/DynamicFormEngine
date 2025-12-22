//
//  UploadMediaTVcell.swift
//
//
//  Created by iSlam AbdelAziz on 2/17/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class NewUploadMediaTVcell: ParentFieldTableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var attachmenStackView: UIStackView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var dashedView: CustomDashedView!
    @IBOutlet weak var ttlLbl: UILabel!
    @IBOutlet weak var supportsLbl: UILabel!
    @IBOutlet weak var maxFilesLabel: UILabel!
    @IBOutlet weak var maxSizeLabel: UILabel!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var addAttachLbl: LocalizedLabel!
    @IBOutlet weak var dashedViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var uploadFileLbl: LocalizedLabel!
    @IBOutlet weak var toolTipIcon: UIButton!
    @IBOutlet weak var attachIcon: UIImageView!
    
    
    // MARK: - Delegates
    
    var didTapAddAttachment: (()->())?
    var didTapDownloadAttachment: ((String)->())?
    var didRemoveAttachment: ((String)->())?
    var arrayOfAttachment = [UploadMediaUIModel]()
    var validationChanged: ((Bool) -> ())?
    var valueChanged: ((FileUploadAnswer?) -> ())?
    var inlineError = false
    
    // MARK: - Variables

    var isRequest = false
    var isSummary = false
    var isSectionItem = false
    var maxAttachmentsSize: Int?
    var toolTipTxt = ""
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelFileUploadItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl)
                setupWith(item: item)
            }
        }
    }
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        handleToolTipGesture()
        configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Functions
    
    private func configureUI() {
        ttlLbl.textColor = typographyTitle
        supportsLbl.textColor = typographyTitle
        maxFilesLabel.textColor = typographyTitle
        maxSizeLabel.textColor = typographyTitle
        attachIcon.tintColor = primaryMain
    }
    
    /// adding toolTip tap gesture on title label
    func handleToolTipGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toolTipPressed))
        ttlLbl.isUserInteractionEnabled = true
        ttlLbl.addGestureRecognizer(tapGesture)
    }
    
    /// updating cell constraints in normal/section cases
    private func updateConstraintsForSectionItem(section: Bool) {
        if section {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = true
            NSLayoutConstraint.deactivate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    }
    
    /// remove attachment from the control
    /// - Parameter id: media id that will be removed
    func removeAttachment(with id: String) {
        didRemoveAttachment?(id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            guard let `self` = self else {return}
            self.handleValidation()
        }
    }
    
    /// add attachment to the control
    /// - Parameter id: media id that will be added
    func addAttachment(with id: String) {
        didTapDownloadAttachment?(id)
    }
    
    /// drawing list of uploaded attachments
    /// - Parameters:
    ///   - model: single attachment model
    ///   - isRequest: is it presented in request details or not
    func generateAndAppendAttachmentView(model: UploadMediaUIModel,isRequest: Bool) {
        let view = FormMediaItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.isDisabled = item.disabled
        view.setup(model,isRequest: isRequest || isSummary)
        attachmenStackView.addArrangedSubview(view)
        view.didTapRemove = {[weak self] in
            guard let `self` = self else {return}
            self.removeAttachment(with: model.id)
        }
        
        view.didTapDawnload = {[weak self] in
            guard let `self` = self else {return}
            guard let downloadUrl = model.uploadedMedia?.downloadUrl, !downloadUrl.isEmpty else { return }
            self.addAttachment(with: downloadUrl)
        }
    }
    
    /// drawing list of uploaded attachments generated from default answer
    /// - Parameter model: single attachment model
    func generateAndAppendAttachmentViewForDefaultAnswer(model: AttachmentForDefault) {
        let view = FormMediaItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.isDisabled = item.disabled
        view.setup(DynamicAuthManager.shared.convertToUploadMediaUIModel(from: model))
        attachmenStackView.addArrangedSubview(view)
        view.didTapRemove = {[weak self] in
            guard let `self` = self else {return}
            self.removeAttachment(with: model.fileId ?? "")
        }
        
        view.didTapDawnload = {[weak self] in
            guard let `self` = self else {return}
            self.addAttachment(with: model.fileId ?? "")
        }
    }
    
    /// settingup ui in requestDetails view
    func setupDetailsView() {
        dashedView.isHidden = true
        dashedViewHeightConstraints.constant = 0
    }
    
    /// getting available extensions from json
    /// - Parameter item: fileupload item
    /// - Returns: list of valid extensions as string
    func getAvailableExtensions(item: FormViewModelFileUploadItem) -> String {
        var availableExtensions = ""
        if let extensions = item.attachmentExtensions, extensions != "" {
            availableExtensions = "Supports : ".localized + extensions
            supportsLbl.isHidden = false
        }else {
            supportsLbl.isHidden = true
        }
        return availableExtensions
    }
    
    /// handling ui whether it's disabled or not
    /// - Parameter item: fileupload item
    func handleDisabledState(item: FormViewModelFileUploadItem) {
        if item.disabled || item.field?.properties?.readonly ?? false {
            addAttachLbl.textColor = #colorLiteral(red: 0.6666666667, green: 0.6980392157, blue: 0.7725490196, alpha: 1)
            uploadFileLbl.textColor = #colorLiteral(red: 0.6666666667, green: 0.6980392157, blue: 0.7725490196, alpha: 1)
            dashedView.isUserInteractionEnabled = false
            dashedView.tintColor = UIColor(hexCerqel: "#BDBDBD")
            dashedView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9529411765, blue: 0.9764705882, alpha: 1)
        } else {
            addAttachLbl.textColor = .black
            uploadFileLbl.textColor = .graySubtitle
            dashedView.isUserInteractionEnabled = true
            dashedView.tintColor = UIColor(hexCerqel: "#007AFF")
            dashedView.backgroundColor = UIColor(hexCerqel: "#EFF1F3")
        }
    }
    
    /// setting required mark for required controls
    /// - Parameter item: fileupload item
    func setRequiredMark(item: FormViewModelFileUploadItem) {
        let st = ttlLbl.text ?? ""
        let second = " *"
        
        
        let firstAttributes: [NSAttributedString.Key: Any] = [:]
        let secondAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.SST_Arabic_Bold(ofSize: 15)]
        
        let firstString = NSMutableAttributedString(string: st, attributes: firstAttributes)
        let secondString = NSMutableAttributedString(string: second, attributes: secondAttributes)
        
        firstString.append(secondString)
        self.ttlLbl.attributedText = firstString
    }
    
    /// Setting valid extensions for the control
    /// - Parameter item: file upload control
    func setExtensionsLabel(item: FormViewModelFileUploadItem) {
        if !isRequest {
            supportsLbl.text = getAvailableExtensions(item: item)
        }
    }
    
    /// Setting files number and files size for the control
    /// - Parameter item: file upload control
    func setFilesInfo(item: FormViewModelFileUploadItem) {
        guard !isRequest else  { return }
        if let maxFilesNumber = item.maxAttachmentsNumber, maxFilesNumber > 0  {
            maxFilesLabel.text = "Max files : ".localized + "\(maxFilesNumber)"
            maxFilesLabel.isHidden = false
        }else {
            maxFilesLabel.text = ""
            maxFilesLabel.isHidden = true
        }
        
        if let maxFileSize = item.maxAttachmentsSize, maxFileSize > 0  {
            maxSizeLabel.text = "Max size : ".localized + "\(maxFileSize) " + "MB".localized
            maxSizeLabel.isHidden = false
        }else {
            maxSizeLabel.text = ""
            maxSizeLabel.isHidden = true
        }
    }
    
    /// setting control's title from json
    /// - Parameter item: fileupload item
    func setTitle(item: FormViewModelFileUploadItem) {
        if let localization = item.localization as? InteractiveLocalization {
            if !isArabicCerqel() {
                ttlLbl.text = localization["en"]?.label
            }else {
                ttlLbl.text = localization["ar"]?.label
            }
        }else {
            ttlLbl.text = item.label
        }
        if item.required {
            setRequiredMark(item: item)
        }else {
            let st = ttlLbl.text ?? ""
            if isRequest {
                self.ttlLbl.text = st
            }else {
                self.ttlLbl.text = st
            }
        }
    }
    
    /// setting toolTip icon
    /// - Parameter item: fileupload item
    func setToolTip(item: FormViewModelFileUploadItem) {
        if let localization = item.localization as? InteractiveLocalization {
            if !isArabicCerqel() {
                if let localizedToolTip = localization["en"]?.tooltip, !localizedToolTip.isEmpty {
                    self.toolTipTxt = localizedToolTip
                } else {
                    self.toolTipTxt = item.tooltip ?? ""
                }
            } else {
                if let localizedToolTip = localization["ar"]?.tooltip, !localizedToolTip.isEmpty {
                    self.toolTipTxt = localizedToolTip
                } else {
                    self.toolTipTxt = item.tooltip ?? ""
                }
            }
        }
        toolTipIcon.isHidden = toolTipTxt.isEmpty
    }
    
    
    /// setting up the control with it's properties
    /// - Parameter item: fileupload item
    func setupWith(item: FormViewModelFileUploadItem) {
        resetValues()
        for attachment in item.attachmentsList {
            generateAndAppendAttachmentView(model: attachment,isRequest: isRequest)
        }
        handleDisabledState(item: item)
        maxAttachmentsSize = item.maxAttachmentsSize
        setTitle(item: item)
        setExtensionsLabel(item: item)
        setFilesInfo(item: item)
        setToolTip(item: item)
        
        if item.isUpdated {
            handleValidation()
        }
        if !isRequest && !isSummary {
            updateErrorState(item.inLineError, message: item.errorMessageInline)
        }
        if isRequest || isSummary {
            setupDetailsView()
        }
    }
    
    /// resetting control with it's initial state
    func resetValues() {
        attachmenStackView.removeAllArrangedSubviewsCompletely()
        errorView.isHidden = true
    }
    
    /// handlling control's validations
    func handleValidation() {
        guard let item = item as? FormViewModelFileUploadItem else { return }
        guard item.required else {return}
        let validation = FormBuilder.shared.handleUplaodFileError(attachCount: item.attachmentsList.count, maxAttachNumber: item.maxAttachmentsNumber, item: item, row: item.fieldId)
        if validation.isError {
            errorView.isHidden = false
            errorLbl.text = validation.errorMessage
            item.errorMessageInline = validation.errorMessage
            item.inLineError = validation.isError
            validationChanged?(false)
        } else {
            item.errorMessageInline = ""
            item.inLineError = false
            errorView.isHidden = true
            validationChanged?(true)
        }
    }
    
    /// checking if control has internal error msg
    /// - Parameter item: fileupload item
    /// - Returns: (has internal error, internal error msg)
    func hasInternalError(item: FormViewModelFileUploadItem) -> (Bool,String) {
        if let customErrorMessage = FormBuilder.shared.getErrorMessageForInternalWarning(validation: .maxAttachmentNumber, for: item.maxAttachmentsNumber ?? 0, row: item.fieldId), customErrorMessage != "" {
            return (true,customErrorMessage)
        }
        return (false,"")
    }
    
    /// getting global error from json
    /// - Parameter item: fileupload item
    /// - Returns: global error from json
    func getGlobalError(item: FormViewModelFileUploadItem) -> String? {
        let errorMsg = FormBuilder.shared.getErrorMessageFor(validation: .maxAttachmentNumber, for: item.maxAttachmentsNumber ?? 0, fieldValidationRequiredType: .fileUpload)
        return errorMsg
    }
    
    
    // MARK: - IBActions
    
    /// fired when user press on control's title label
    @objc func toolTipPressed() {
        showToolTip(toolTip: self.toolTipTxt, sender: toolTipIcon)
    }
    
    /// fired when user press on tooltip button
    /// - Parameter sender: tooltip button
    @IBAction func toolTipTapped(_ sender: Any) {
        showToolTip(toolTip: self.toolTipTxt, sender: sender)
    }
    
    /// fired when user press on add attachment
    /// checking maxAttachmentsNumber first before adding
    @IBAction func addAttachmentBtntTapped(){
        guard let item = item as? FormViewModelFileUploadItem else {return}
        if item.attachmentsList.count < item.maxAttachmentsNumber ?? 0 || item.maxAttachmentsNumber == nil {
            didTapAddAttachment?()
        } else {
            errorView.isHidden = false
            hasInternalError(item: item).0 ? (errorLbl.text = hasInternalError(item: item).1) : (errorLbl.text = getGlobalError(item: item))
        }
    }
}

extension NewUploadMediaTVcell: ValidatableCell {
    func updateErrorState(_ isValid: Bool, message: String? = nil) {
        inlineError = !isValid
        if inlineError {
            clearValidationError()
        } else {
            displayValidationError(message ?? "")
        }
    }

    func displayValidationError(_ message: String) {
//        updateConstraintsForSectionItem(section: item.isSectionControl)
        inlineError = true
        errorView.isHidden = false
        errorLbl.text = message
        validationChanged?(false)
    }

    func clearValidationError() {
        inlineError = false
        errorView.isHidden = true
        errorLbl.text = ""
        validationChanged?(true)
    }
}

