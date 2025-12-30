//
//  UploadFileView.swift
//  CERQEL
//
//  Created by ahmed maher on 16/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import netfox
import DynamicFormEngine

class UploadFileView: BaseView<UploadFileViewModel, BaseItem> {
    
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var subCategoryText: UITextField!
    @IBOutlet weak var describtionTextView: UITextView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fileArabicVersionUploadView: UIView!
    @IBOutlet weak var fileEnglishVersionUploadView: UIView!
    @IBOutlet weak var fileEnglishVersionUploadBackgroundView: UIView!
    @IBOutlet weak var fileArabicVersionUploadBackgroundView: UIView!
    @IBOutlet var fileEnglishVersionLbl:[UILabel]?
    @IBOutlet var fileArabicVersionLbl:[UILabel]?
    @IBOutlet var fileEnglishVersionExtensionImage:[UIImageView]?
    @IBOutlet var fileArabicVersionExtensionImage:[UIImageView]?
    @IBOutlet weak var fileArabicUploadIcon: UIImageView!
    @IBOutlet weak var fileEnglishUploadIcon: UIImageView!
    @IBOutlet weak var fileArabichVersionView: UIView!
    @IBOutlet weak var fileEnglisVersionView: UIView!
    @IBOutlet weak var fileArabicVersionUploadProgressView: UIView!
    @IBOutlet weak var fileEnglisVersionUploadProgressView: UIView!
    
    @IBOutlet weak var fileArabicVersionFailView: UIStackView!
    @IBOutlet weak var fileEnglisVersionFailView: UIStackView!
    
    
    @IBOutlet weak var fileEnglishVersionProgressView: UIProgressView!
    @IBOutlet weak var fileArabicVersionProgressView: UIProgressView!
    
    @IBOutlet weak var fileEnglishVersionFailProgressView: UIProgressView!
    @IBOutlet weak var fileArabicVersionFailProgressView: UIProgressView!
    @IBOutlet weak var categoryDropIcon: UIImageView!
    @IBOutlet weak var subCategoryDropIcon: UIImageView!
    @IBOutlet weak var closeEnglishFile: UIImageView!
    @IBOutlet weak var closeArabicFile: UIImageView!
    
    var documentPicker: DocumentPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        handleObservation()
        checkForVaildUpload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    private func initialConfiguration(){
        viewModel = UploadFileViewModel(router: CerqelRouterManagerImpl(self))
        documentPicker = DocumentPicker(presentationController: self, delegate: self, fromProfile: false, pdfOnly: false)
    }
    
    private func configureUI(){
        fileEnglishVersionUploadBackgroundView.backgroundColor = primaryMain.withAlphaComponent(0.1)
        fileArabicVersionUploadBackgroundView.backgroundColor = primaryMain.withAlphaComponent(0.1)
        closeEnglishFile.tintColor = primaryMain
        closeArabicFile.tintColor = primaryMain
        fileArabicUploadIcon.tintColor = primaryMain
        fileEnglishUploadIcon.tintColor = primaryMain
        categoryDropIcon.tintColor = primaryMain
        subCategoryDropIcon.tintColor = primaryMain
                
        cancelButton.setCancelButtonTheme()
        cancelButton.setTitle("Cancel".localized, for: .normal)
        
        publishButton.setSubmitButtonTheme()
        publishButton.setTitle("Publish".localized, for: .normal)
        
        let title = NSAttributedString(
            string: "Cancel".localized,
            attributes: [
                NSAttributedString.Key.foregroundColor: primaryMain,
                NSAttributedString.Key.font: UIFont.buttonLSemibold()
            ]
        )
        
        
        cancelButton.setAttributedTitle(title, for: .normal)
        setNavigationTitle("Upload File".localized)
        setupBackButton()
    }
    
    override func goBack() {
        viewModel.dismiss()
    }
    
    private func handleObservation() {
        viewModel.fileArabicVersion.bind{ file in
            switch file.fileStatus {
            case .new,.removed :
                self.resetProgressForArabic()
                self.showUploadArabicFileView()
            case .inProgress :
                self.fileArabicVersionProgressView.setProgress(Float(file.progress!), animated: true)
                
            case .uploadBegin :
                self.showProgressView(type: .arabic)
            case .uploaded :
                self.resetProgressForArabic()
                self.showInitialView(type: .arabic)
                NFX.sharedInstance().start()
            case .failed :
                self.showFailView(type: .arabic)
                NFX.sharedInstance().start()
            }
            self.fileArabicVersionLbl?[0].text = file.fileName
            self.fileArabicVersionLbl?[1].text = file.fileName
            self.fileArabicVersionExtensionImage?[0].image = self.checkfileExtension(FileType(rawValue: file.fileExtension ?? "pdf 1") ?? .pdf)
            self.fileArabicVersionExtensionImage?[1].image = self.checkfileExtension(FileType(rawValue: file.fileExtension ?? "pdf 1") ?? .pdf)
            self.checkForVaildUpload()
            
        }
        viewModel.fileEnglishVersion.bind{ file in
            switch file.fileStatus {
            case .new,.removed :
                self.resetProgressForEnglish()
                self.showUploadEnglishFileView()
            case .inProgress :
                self.fileEnglishVersionProgressView.setProgress(Float(file.progress!), animated: true)
            case .uploadBegin :
                self.showProgressView(type: .english)
            case .uploaded :
                self.showFailView(type:.english)
                NFX.sharedInstance().start()
//                self.resetProgressForEnglish()
//                self.showInitialView(type: .english)
//                NFX.sharedInstance().start()
            case .failed :
                self.showFailView(type:.english)
                NFX.sharedInstance().start()
                
            }
            self.fileEnglishVersionLbl?[0].text = file.fileName
            self.fileEnglishVersionLbl?[1].text = file.fileName
            self.fileEnglishVersionExtensionImage?[0].image = self.checkfileExtension(FileType(rawValue: file.fileExtension ?? "pdf 1") ?? .pdf)
            self.fileEnglishVersionExtensionImage?[1].image = self.checkfileExtension(FileType(rawValue: file.fileExtension ?? "pdf 1") ?? .pdf)
            self.checkForVaildUpload()
        }
        viewModel.category.bind{ category in
            self.categoryText.text = category.name
        }
        
        viewModel.subCategory.bind{ subCategory in
            self.subCategoryText.text = subCategory.name
        }
        
    }
    
    func checkForVaildUpload(){
        if viewModel.fileArabicVersion.value.fileStatus == .uploaded || viewModel.fileEnglishVersion.value.fileStatus == .uploaded  {
            self.publishButton.setActiveButton()
        }
        else {
            self.publishButton.setUnActiveButton()
        }
    }
    
    func resetProgressForEnglish(){
        self.fileEnglishVersionProgressView.setProgress(0, animated: false)
    }
    
    func resetProgressForArabic(){
        self.fileArabicVersionProgressView.setProgress(0, animated: false)
    }
    
    private func checkfileExtension(_ fileType: FileType) -> UIImage{
        switch fileType {
        case .pdf,.PDF: return UIImage(named: "pdf 1") ?? UIImage()
        case .doc,.DOC : return UIImage(named: "docx")  ?? UIImage()
        case .ppt,.PPT : return UIImage(named: "ppt")  ?? UIImage()
        case .docx,.DOCX:  return UIImage(named: "docx")  ?? UIImage()
        case .pptx,.PPTX:  return UIImage(named: "ppt")  ?? UIImage()
        case .xls,.XLS: return UIImage(named: "xls")  ?? UIImage()
        case .xlsx,.XLSX:  return UIImage(named: "xls")  ?? UIImage()
        case .mp4,.MP4:  return UIImage(named: "mp4")  ?? UIImage()
        case .jpg, .svg, .png, .PNG: return UIImage(named: "jpg") ?? UIImage()
        case .jpeg: return UIImage(named: "jpeg") ?? UIImage()
            
        }
    }
    
    func showInitialView(type: FileVersionType){
        switch type {
        case .arabic :
            self.fileArabicVersionUploadView.isHidden = true
            self.fileArabichVersionView.isHidden = false
            self.fileArabicVersionUploadProgressView.isHidden = true
        case .english :
            self.fileEnglishVersionUploadView.isHidden = true
            self.fileEnglisVersionView.isHidden = false
            self.fileEnglisVersionUploadProgressView.isHidden = true
        }
    }
    
    func showProgressView(type: FileVersionType){
        switch type {
        case .arabic :
            self.fileArabicVersionUploadView.isHidden = true
            self.fileArabichVersionView.isHidden = true
            self.fileArabicVersionUploadProgressView.isHidden = false
        case .english :
            self.fileEnglishVersionUploadView.isHidden = true
            self.fileEnglisVersionView.isHidden = true
            self.fileEnglisVersionUploadProgressView.isHidden = false
        }
    }
    
    func showFailView(type: FileVersionType){
        switch type {
        case .arabic :
            self.fileArabicVersionUploadView.isHidden = true
            self.fileArabichVersionView.isHidden = true
            self.fileArabicVersionUploadProgressView.isHidden = true
            self.fileArabicVersionFailView.isHidden = false
        case .english :
            self.fileEnglishVersionUploadView.isHidden = true
            self.fileEnglisVersionView.isHidden = true
            self.fileEnglisVersionUploadProgressView.isHidden = true
            self.fileEnglisVersionFailView.isHidden = false
            
        }
    }
    
    func showUploadArabicFileView() {
        self.fileArabicVersionUploadView.isHidden = false
        self.fileArabicVersionUploadProgressView.isHidden = true
        self.fileArabichVersionView.isHidden = true
    }
    
    func showUploadEnglishFileView() {
        self.fileEnglishVersionUploadView.isHidden = false
        self.fileEnglisVersionUploadProgressView.isHidden = true
        self.fileEnglisVersionView.isHidden = true
    }
    
    
    
    
}

//MARK: - Actions
extension UploadFileView {
    
    @IBAction func selectFileWithEnglishVersion(_ sender: Any) {
        NFX.sharedInstance().stop()
        viewModel.FileVersionType.value = .english
        documentPicker.present(from: view)
        
    }
    
    @IBAction func selectFileWithArabicVersion(_ sender: Any) {
        NFX.sharedInstance().stop()
        viewModel.FileVersionType.value = .arabic
        documentPicker.present(from: view)
    }
    
    @IBAction func cancelEnglishFile(_ sender: Any) {
        viewModel.FileVersionType.value = .english
        viewModel.cancelFile()
    }
    
    @IBAction func cancelArabicFile(_ sender: Any) {
        viewModel.FileVersionType.value = .arabic
        viewModel.cancelFile()
        
    }
    
    @IBAction func resetEnglishFile(_ sender: Any) {
        viewModel.FileVersionType.value = .english
        viewModel.removeFile()
        fileEnglisVersionFailView.isHidden = true
    }
    
    @IBAction func resetArabicFile(_ sender: Any) {
        viewModel.FileVersionType.value = .arabic
        viewModel.removeFile()
        fileArabicVersionFailView.isHidden = true
    }
    
    
    @IBAction func publish(_ sender: Any) {
        viewModel.uploadEndPoint()
        
    }
    @IBAction func selectCategories(_ sender: Any) {
        viewModel.getCategories()
        
    }
    
    @IBAction func selectSubCategories(_ sender: Any) {
        viewModel.getSubCategories()
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        viewModel.dismiss()
        
    }
    
    
}
//MARK: - Actions
extension UploadFileView: DocumentDelegate {
    func didPickDocuments(URLs: [URL]?, fromProfile: Bool) {
        guard let fileUrl = URLs?.first else {
            return
        }
        viewModel.pickFile(url: fileUrl, fromProfile: fromProfile)
    }
    
    
}

extension UploadFileView: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.description.value = textView.text
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 500 // 10 Limit Value
    }
}
