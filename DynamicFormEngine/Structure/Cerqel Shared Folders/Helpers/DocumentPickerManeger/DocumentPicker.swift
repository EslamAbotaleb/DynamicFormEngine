//
//  DocumentPicker.swift
//  it_graduate_new
//
//  Created by Mahmoud Ibaraheim on 7/8/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

open class DocumentPicker: NSObject {
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
    private weak var delegate: DocumentDelegate?

    private var folderURL: URL?
    private var sourceType: SourceType!
    private var documents = [DocumentCerqel]()
    private var sourceView: UIView!
    private var fromProfile: Bool?
    private var pdfOnly: Bool?

    init(presentationController: UIViewController, delegate: DocumentDelegate, fromProfile: Bool, pdfOnly: Bool) {
        super.init()

        self.presentationController = presentationController
        self.sourceView = presentationController.view
        self.delegate = delegate
        self.fromProfile = fromProfile
        self.pdfOnly = pdfOnly
    }

    public func folderAction(for type: SourceType, title: String) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.folder])
            self.pickerController!.delegate = self
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
    }

    public func fileAction(for type: SourceType, title: String, allowsMultipleSelection: Bool) -> UIAlertAction? {
        
        let allTypes: [UTType] = [
//                .item,          // any type of file
//                .content,       // any kind of user content
//                .data,          // any kind of binary data
                .package,       // packaged/bundled content

                // Documents
                .text,
                .plainText,
                .rtf,
                .spreadsheet,
                .presentation,
                .pdf,

//                // Images
//                .image,
//                .jpeg,
//                .png,
//                .heic,
//                .gif,
//                .tiff,
//
//                // Audio & Video
//                .audio,
//                .mp3,
//                .wav,
//                .aiff,
//                .midi,
//                .movie,
//                .mpeg,
//                .avi,
//                .quickTimeMovie,

                // Archives
                .zip,
                .gzip,
            ]

        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if pdfOnly == true {
                self.pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
            }else {
                let exts = ["pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "rtf", "txt", "zip", "gz"]
                let strictTypes: [UTType] = exts.compactMap { UTType(filenameExtension: $0) }
                self.pickerController = UIDocumentPickerViewController(forOpeningContentTypes: strictTypes, asCopy: true)
            }
            self.pickerController!.delegate = self
            self.pickerController!.allowsMultipleSelection = allowsMultipleSelection
            
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
    }

    public func present(from sourceView: UIView? = nil, allowsMultipleSelection: Bool = false) {

        let alertController = UIAlertController(title: "Select From".localized, message: nil, preferredStyle: .actionSheet)

        if let action = self.fileAction(for: .files, title: "Files".localized,allowsMultipleSelection: allowsMultipleSelection) {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = self.sourceView
            alertController.popoverPresentationController?.sourceRect = self.sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)

    }
}

extension DocumentPicker: UIDocumentPickerDelegate{

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        var fileSize : Double = 0
        do {
            
            if !urls.isEmpty, let url = urls.first {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                fileSize = (attr[FileAttributeKey.size] as? Double ?? 0) / 1000000
            }
        } catch {
        }
        
        if fromProfile == true {
            if fileSize > 25 {
                
//                appDelegate.showAlert(withText: "Max attachment size is 25 MB".localized)
                delegate?.didPickDocuments(URLs: nil, fromProfile: fromProfile ?? false)
            }else {
                delegate?.didPickDocuments(URLs: urls, fromProfile: fromProfile ?? false)
            }
        }else {
            delegate?.didPickDocuments(URLs: urls, fromProfile: fromProfile ?? false)
        }
        
        
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.didPickDocuments(URLs: nil, fromProfile: fromProfile ?? false)
    }

}

extension DocumentPicker: UINavigationControllerDelegate {}
