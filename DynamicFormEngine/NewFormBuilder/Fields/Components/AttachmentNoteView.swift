//
//  AttachmentNoteView.swift
//  CHECK
//
//  Created by Yasser Osama on 12/10/2021.
//

import UIKit
import EasyTipView


class AttachmentNoteView: UIView {

    let contentXibName = "AttachmentNoteView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addNoteAttachmentView: UIView!
    @IBOutlet weak var addNoteView: UIView!
    @IBOutlet weak var addNoteLabel: UILabel!
    @IBOutlet weak var addNoteImageView: UIImageView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var addAttachmentView: UIView!
    @IBOutlet weak var addAttachmentButton: UIButton!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var filesView: UIView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet var imageViewCollection: [UIImageView]!
    @IBOutlet var fileViewCollection: [FileView]!
    @IBOutlet weak var characterCountView: UIView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var images = [UIImage]()
//    var files = [FileData]()
    var indexPath: IndexPath!
    var formVC: FormViewController? //{
//        if let formVC = self.parentContainerViewController() as? FormViewController {
//            return formVC
//        }
//        return UIApplication.topViewController() as? FormViewController
//    }
//    var imageUploader = ImageUploader()
    
    var item: FormViewModelInteractiveItem! {
        didSet {
            setupSubLabelText(item)
            if let note = item.note, !note.isEmpty {
                noteView.isHidden = false
                noteLabel.text = note
                toggleNote(false)
            } else {
                noteView.isHidden = true
                noteLabel.text = ""
                toggleNote(true)
            }
            
            if let attachmentsImages = item.attachmentImages, attachmentsImages.count > 0 {
                handleAttachmentImages(attachmentsImages)
            } else {
                imagesView.isHidden = true
            }
            
            if let attachmentFiles = item.attachmentFiles, attachmentFiles.count > 0 {
                hanldeAttachmentFiles(attachmentFiles)
            } else {
                filesView.isHidden = true
            }
            handleCharacterLimitView(item)
            addNoteView.isHidden = !item.addNote
            addAttachmentView.isHidden = !item.addAttachment
            addNoteAttachmentView.isHidden = (!item.addNote && !item.addAttachment)
        }
    }
    
    var isEditable: Bool! = true {
        didSet {
            addNoteAttachmentView.isHidden = !isEditable
            noteView.isUserInteractionEnabled = isEditable
            subLabel.isHidden = !isEditable
            characterCountView.isHidden = !isEditable
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.fixInView(self)
        for imageView in imageViewCollection {
//            imageView.rounderCornerWithRadius(4)
            imageView.contentMode = .scaleAspectFill
        }
//        imageUploader.delegate = self
        
//        noteLabel.font = UIFont(name: Constants.regularFont(), size: 12.0)!
//        noteLabel.textColor = .checkText
//        noteLabel.adjustAutoAlignment()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takeNoteAction(_:)))
        noteView.addGestureRecognizer(tap)
    }
    
    func setupSubLabelText(_ item: FormViewModelInteractiveItem) {
//        if Localizer.isFormSameLanguage {
//            subLabel.text = item.sublabel
//        } else {
//            if let localizedSubLabel = item.localization?[Localizer.currentLanguage]?.sublabel, !localizedSubLabel.isEmpty {
//                subLabel.text = localizedSubLabel
//            } else {
//                subLabel.text = item.sublabel
//            }
//        }
        subLabel.isHidden = (subLabel.text?.isEmpty) ?? true
    }
    
    func toggleNote(_ enabled: Bool) {
//        if enabled {
//            addNoteLabel.textColor = .primaryColor
//            addNoteImageView.tintColor = .primaryColor
//            addNoteButton.isEnabled = true
//        } else {
//            addNoteLabel.textColor = .blueGrey
//            addNoteImageView.tintColor = .blueGrey
//            addNoteButton.isEnabled = false
//        }
    }
    
    func handleCharacterLimitView(_ item: FormViewModelInteractiveItem) {
//        var currentLength = 0
//        if let item = item as? FormViewModelTextBaseItem {
//            var stringValue = ""
//            if let textBoxValue = (item.answer as? TextboxAnswer)?.value {
//                stringValue = textBoxValue
//            } else if let textAreaValue = (item.answer as? TextAreaAnswer)?.value {
//                stringValue = textAreaValue
//            }
//            currentLength = stringValue.count
//            if let entryLimit = item.entryLimit {
//                if entryLimit == .Character {
//                    currentLength = stringValue.count
//                } else {
//                    let spaces = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
//                    currentLength = stringValue.components(separatedBy: spaces).count
//                }
//            }
//            let result = FormBuilder.shared.handleTextLimitLabel(current: currentLength, fieldType: item.type, entryLimit: item.entryLimit ?? .Character, minLength: item.minimumLength, maxLength: item.maximumLength)
//            characterCountLabel.text = result.0
//            characterCountView.isHidden = result.0.isEmpty
//        } else if let item = item as? FormViewModelNumericItem {
//            if let value = (item.answer as? BaseAnswerNumber)?.value {
//                currentLength = "\(value)".count
//            }
//            let result = FormBuilder.shared.handleTextLimitLabel(current: currentLength, fieldType: item.type, minLength: item.minDigit, maxLength: item.maxDigit)
//            characterCountLabel.text = result.0
//            characterCountView.isHidden = result.0.isEmpty
//        } else {
//            characterCountView.isHidden = true
//        }
    }
    
    @IBAction func takeNoteAction(_ sender: UIButton) {
//        let addNoteVC = Utilities.instantiateVCWithId("addNoteVC") as! AddNoteViewController
//        addNoteVC.delegate = self
//        addNoteVC.note = item.note
//        self.parentContainerViewController()?.present(addNoteVC, animated: true, completion: nil)
    }
    
    @IBAction func takeAttachmentAction(_ sender: UIButton) {
//        self.imageUploader.presentAttachmentOptions(sender, sourceVC: self.parentContainerViewController(), attachmentType: item.attachmentType)
    }
    
    func handleAttachmentImages(_ attachments: [Any]) {
        images.removeAll()
        for attachment in attachments {
            if let imageData = attachment as? Data, let image = UIImage(data: imageData) {
                images.append(image)
            }
        }
        handleImages()
    }
    
    func handleImages() {
        if images.count > 0 {
            imagesView.isHidden = false
        } else {
            imagesView.isHidden = true
        }
        var displayedImages = images
        if displayedImages.count > 4 {
            let lastImage = displayedImages[3]
//            if let textImage = lastImage.generateImageWithText(text: "+\(displayedImages.count - 3)"), displayedImages.count > 0 {
//                displayedImages[3] = textImage
//            }
        }
        for (i, imageView) in imageViewCollection.enumerated() {
            if i < displayedImages.count {
                imageView.image = displayedImages[i]
                imageView.isHidden = false
            } else {
                imageView.isHidden = false
                imageView.image = nil
            }
        }
    }
    
    func hanldeAttachmentFiles(_ attachments: [Any]) {
//        files.removeAll()
//        for attachment in attachments {
//            if let fileDic = attachment as? [String: Any], let fileData = FileData(JSON: fileDic) {
//                files.append(fileData)
//            }
//        }
        handleFiles()
    }
    
    func handleFiles() {
//        if files.count > 0 {
//            filesView.isHidden = false
//        } else {
//            filesView.isHidden = true
//        }
//        if files.count > 2 {
//            let showMoreTitle = "Show more #count files".localized.replacingOccurrences(of: "#count", with: "\(files.count - 2)")
//            showMoreButton.setTitle(showMoreTitle, for: .normal)
//            showMoreButton.isHidden = false
//        } else {
//            showMoreButton.isHidden = true
//        }
//        for (i, fileView) in fileViewCollection.enumerated() {
//            if i < files.count {
//                fileView.deleteButton.tag = i
//                fileView.deleteButton.addTarget(self, action: #selector(deleteFile(_:)), for: .touchUpInside)
////                fileView.fileData = files[i]
//                fileView.isHidden = false
//                fileView.lineView.isHidden = i == 0
//                fileView.deleteButton.isHidden = !isEditable
//            } else {
//                fileView.isHidden = true
//            }
//        }
    }
    
    @IBAction func openImagesVC() {
//        let imagesVC = Utilities.instantiateVCWithId("imagesVC") as! ImagesViewController
//        imagesVC.modalPresentationStyle = .fullScreen
//        imagesVC.images = images
//        imagesVC.delegate = self
//        imagesVC.isEditable = isEditable
//        formVC?.shouldReset = false
//        self.parentContainerViewController()?.present(imagesVC, animated: true, completion: nil)
    }
    
    @objc func deleteFile(_ sender: UIButton) {
//        files.remove(at: sender.tag)
//        formVC?.saveAttachmentFiles(data: files, section: indexPath.section, row: indexPath.row)
    }
    
    @IBAction func showMoreFilesAction(_ sender: UIButton) {
//        let filesVC = Utilities.instantiateVCWithId("filesVC") as! FilesViewController
//        filesVC.files = files
//        filesVC.delegate = self
//        filesVC.isEditable = isEditable
//        self.parentContainerViewController()?.present(filesVC, animated: true, completion: nil)
    }
    
    @IBAction func textEntryInfoAction(_ sender: UIButton) {
        var preferences = EasyTipView.Preferences()
//        preferences.drawing.font = UIFont(name: Constants.regularFont(), size: 13)!
        preferences.drawing.foregroundColor = .white
//        preferences.drawing.backgroundColor = .primaryColor
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        
        EasyTipView.globalPreferences = preferences
        var infoText = ""
        
        if let item = item as? FormViewModelTextBaseItem, let entryLimit = item.entryLimit {
            infoText = handleItemInfo(min: item.minimumLength, max: item.maximumLength, entryLimit: entryLimit)
        } else if let item = item as? FormViewModelNumericItem {
            infoText = handleItemInfo(min: item.minDigit, max: item.maxDigit)
        }
        if !infoText.isEmpty {
            let tipView = EasyTipView(text: infoText)
            tipView.show(forView: sender)
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                tipView.dismiss()
            }
        }
    }
    
    func handleItemInfo(min: Int?, max: Int?, entryLimit: EntryLimit? = nil) -> String {
        let entryTxt = "#entry"
        var infoText = ""
        var maxLimit = ""
        var minLimit = ""
        if let minLength = min, let maxLength = max {
            minLimit = "\(minLength)"
            maxLimit = "\(maxLength)"
            infoText = "Your Minimum \(entryTxt) is #min & Maximum is #max."
        } else if let minLength = min {
            minLimit = "\(minLength)"
            infoText = "Your Minimum \(entryTxt) is #min."
        } else if let maxLength = max {
            maxLimit = "\(maxLength)"
            infoText = "Your Maximum \(entryTxt) is #max."
        }
        infoText = infoText.localized
        if let entryLimit = entryLimit {
            if entryLimit == .Character {
                infoText = infoText.replacingOccurrences(of: entryTxt, with: "Characters".localized)
            } else if entryLimit == .Word {
                infoText = infoText.replacingOccurrences(of: entryTxt, with: "Words".localized)
            }
        } else {
            infoText = infoText.replacingOccurrences(of: entryTxt, with: "Digit Length".localized)
        }
        infoText = infoText.replacingOccurrences(of: "#min", with: "\(minLimit)")
        infoText = infoText.replacingOccurrences(of: "#max", with: "\(maxLimit)")
        
        return infoText
    }
}

//extension AttachmentNoteView: ImagesViewDelegate {
//    func attachmentImages(_ images: [UIImage]) {
//        var dataArray = [Data]()
//        for image in images {
//            if let imageData = ImageUploader().imageData(mImage: image) {
//                dataArray.append(imageData)
//            }
//        }
//        formVC?.saveAttachmentImages(data: dataArray, section: indexPath.section, row: indexPath.row)
//        formVC?.shouldReset = true
//    }
//}
//
//extension AttachmentNoteView: FilesViewDelegate {
//    func attachmentFiles(_ files: [FileData]) {
//        formVC?.saveAttachmentFiles(data: files, section: indexPath.section, row: indexPath.row)
//    }
//}
//
//extension AttachmentNoteView: AddNoteDelegate {
//    func noteChangedWith(_ note: String) {
//        formVC?.saveNote(note, section: indexPath.section, row: indexPath.row)
//    }
//}
//
//extension AttachmentNoteView: ImageUploaderDelegate {
//    func selectedOption() {
//        formVC?.shouldReset = false
//    }
//
//    func pickerCancelled() {
//        formVC?.shouldReset = true
//    }
//
//    func imageSelected(_ image: UIImage) {
//        if let imageData = imageUploader.imageData(mImage: image) {
//            formVC?.saveAttachmentImage(data: imageData, section: indexPath.section, row: indexPath.row)
//            formVC?.shouldReset = true
//        }
//    }
//
//    func fileSelected(_ fileData: FileData) {
//        formVC?.saveAttachmentFile(data: fileData.toJSON(), section: indexPath.section, row: indexPath.row)
//    }
//}
