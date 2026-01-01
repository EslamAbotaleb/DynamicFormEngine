//
//  FormProtocol.swift
//  CERQEL
//
//  Created by Mohamed Nagi on 05/01/2025.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit
public import RxCocoa
internal import RxSwift
//import EasyTipView

protocol UploadMedia: AnyObject {
    func uploadFile(fileSize: Double, url: URL, isVideo: Bool)
    func uploadImage(imageSize: Int, photo: UIImage)
}

class FormBaseViewController: BottomSheetVCCerqel {
    
    // MARK: - Variables
    
    var activeTableView: UITableView!
    var formBuilder = FormBuilder.shared
    let disposeBag = DisposeBag()
    var uploadingExtensions: String?
    var maxAttachmentsSize: Int?
    
    var currentTipView: EasyTipView?
    var outsideTapGesture: UITapGestureRecognizer?

    
    weak var uploadMediadelegate: UploadMedia?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Functions
    
    /// handling observations
    func configure() {
        FormManager.shared.managerSectionObjects.subscribe(onNext: {[weak self] (managerSectionObjects,vc) in
            guard let `self` = self else {return}
            if let formVC = vc as? NestedFormViewController {
                formVC.sectionObjects = managerSectionObjects
            }else {
                self.formBuilder.sectionObjects = managerSectionObjects
            }
        }).disposed(by: disposeBag)
    }
    
    
    /// draw toolTip text above controls
    func showToolTip(toolTip: String, sender: Any) {
        if let tipView = currentTipView {
            // Dismiss the tooltip if it's currently showing
            tipView.dismiss {
                self.currentTipView = nil
                self.outsideTapGesture?.isEnabled = false // Disable the outside tap gesture
            }
        } else {
            // Configure the tooltip preferences
            var preferences = EasyTipView.Preferences()
            preferences.drawing.backgroundColor = UIColor.black
            preferences.drawing.foregroundColor = UIColor.white
            preferences.drawing.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            preferences.drawing.arrowPosition = .bottom
            preferences.drawing.cornerRadius = 8
            
            EasyTipView.globalPreferences = preferences
            
            // Create and show the tooltip
            let tipView = EasyTipView(text: toolTip)
            if let button = sender as? UIView {
                tipView.show(forView: button) // Show tooltip for the sender view
            }
            currentTipView = tipView
            
            // Enable the outside tap gesture to detect taps outside of the tooltip
            outsideTapGesture?.isEnabled = true
        }
    }
    
}

extension FormBaseViewController: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        var fileSize : Double = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: url.path)
            fileSize = (attr[FileAttributeKey.size] as? Double ?? 0) / 1000000
            
        } catch {
        }
        
        let extensions = uploadingExtensions?.components(separatedBy: ",")
        let fileExtension = url.pathExtension
        
        if let extensions = extensions {
            if extensions.contains(fileExtension) {
                uploadMediadelegate?.uploadFile(fileSize: fileSize, url: url, isVideo: false)
            }else {
                let errMsg = formBuilder.getUploadFileExtensionErrorMsg(row: "\(formBuilder.fileUploadFieldID)")
                CerqelUIManager.showToast(parent: self, msg: errMsg)
                return
            }
        }else {
            uploadMediadelegate?.uploadFile(fileSize: fileSize, url: url, isVideo: false)
        }
    }
    
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    }
}

extension FormBaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {[weak self] in
            guard let `self` = self else {return}
            var extensions = [String]()
            if let exts = self.uploadingExtensions {
                if exts.contains(",") {
                    extensions = exts.components(separatedBy: ",")
                }else {
                    extensions = [exts]
                }
            }
            var videoSize = 0.0
            if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                print("WE HAVE IMAGE !!!! 🚀")
                let imgData = NSData(data: photo.jpegData(compressionQuality: 0.5)!)
                let imageSize: Int = imgData.count / 1000000
                
                
                if let imageURL = info[.imageURL] as? URL {
                    let imageExtension = imageURL.pathExtension
                    if extensions.contains(imageExtension) {
                        self.uploadMediadelegate?.uploadImage(imageSize: imageSize, photo: photo)
                    }else {
                        let errMsg = self.formBuilder.getUploadFileExtensionErrorMsg(row: "\(self.formBuilder.fileUploadFieldID)")
                        CerqelUIManager.showToast(parent: self, msg: errMsg)
                        return
                    }
                }else { // Camera image
                    uploadMediadelegate?.uploadImage(imageSize: imageSize, photo: photo)
                }
            }else { // video picked
                if let videoURL = info[.mediaURL] as? URL {
                    
                    videoSize = getFileSize(url: videoURL)
                    
                    // Get video file extension
                    let fileExtension = videoURL.pathExtension
                    print("Video file extension: \(fileExtension)")
                    if extensions.contains(fileExtension) {
                        uploadMediadelegate?.uploadFile(fileSize: videoSize, url: videoURL, isVideo: true)
                    }else {
                        let errMsg = self.formBuilder.getUploadFileExtensionErrorMsg(row: "\(self.formBuilder.fileUploadFieldID)")
                        CerqelUIManager.showToast(parent: self, msg: errMsg)
                    }
                }
            }
        }
    }
    
    // Function to get file size in MB
        func getFileSize(url: URL) -> Double {
            do {
                let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
                if let fileSize = resourceValues.fileSize {
                    return Double(fileSize) / 1000000 // Convert to MB
                }
            } catch {
                print("Error getting file size: \(error.localizedDescription)")
                return 0
            }
            return 0
        }
}
