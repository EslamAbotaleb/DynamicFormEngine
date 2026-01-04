//
//  UIVIewController+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 10/31/20.
//  Copyright © 2020 Youxel. All rights reserved.
//
import UIKit
internal import JGProgressHUD
import MobileCoreServices
import UniformTypeIdentifiers

public protocol WireframeInterfaceCerqel: class {
    func cerqel_popFromNavigationController(animated: Bool)
    func cerqel_dismiss(animated: Bool)
    
    func cerqel_showErrorAlert(with message: String?)
    func cerqel_showAlert(with title: String?, message: String?)
    func cerqel_showAlert(with title: String?, message: String?, actions: [UIAlertAction])
}


extension UIViewController: WireframeInterfaceCerqel {
    
   public func cerqel_showError(error:Error){
        var message:String = error.localizedDescription
        if let error = error as? BaseError {
            
            message = error.errorDescription ?? ""
        }
        else {
            let code = (error as NSError).code
            if code == 3840{
                // not correct format
                message = BaseError.decodeResponse.localizedDescription
            }
            else if code == -1001 {
                // timeout
                message = BaseError.serverError.localizedDescription
            } else if code == -1009 {
                // no internet connection
                message = BaseError.NoInternet.localizedDescription
            }
            else {
                message = BaseError.timeOut.localizedDescription
            }
            // code == -1009 ||
        }
        let hud = flashHud(message: message, view: self.view, indicator: JGProgressHUDErrorIndicatorView())
        hud.dismiss(afterDelay: 2)
    }
    
    private struct cerqel_HUDHolder {
        static var shared: LottieHUD = {
//            let hud = JGProgressHUD(style: .dark)
            let hud = LottieHUD("loading")
//            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
//            hud.vibrancyEnabled = true
            return hud
            
        }()
    }
    
    var cerqel_HUD: LottieHUD {
        get {
            return cerqel_HUDHolder.shared
        }
    }
    
    public func showError(error:Error, flashNow: Bool = false){
        var message:String = error.localizedDescription
        if flashNow {
            let hud = flashHud(message: message, view: self.view, indicator: JGProgressHUDErrorIndicatorView())
            hud.dismiss(afterDelay: 5)
        }
        if let error = error as? BaseError {
            
            message = error.errorDescription ?? ""
        }
        else {
            let code = (error as NSError).code
            if code == 3840{
                // not correct format
                message = BaseError.decodeResponse.localizedDescription
            }
            else if code == -1001 {
                // timeout
                message = BaseError.serverError.localizedDescription
            } else if code == -1009 {
                // no internet connection
                message = BaseError.NoInternet.localizedDescription
            }
            else {
                message = BaseError.timeOut.localizedDescription
            }
        }
        if message != BaseError.timeOut.localizedDescription {
            let hud = flashHud(message: message, view: self.view, indicator: JGProgressHUDErrorIndicatorView())
            hud.dismiss(afterDelay: 2)
        }
    }

    public func cerqel_popFromNavigationController(animated: Bool) {
        let _ = navigationController?.popViewController(animated: animated)
    }
    
    public func cerqel_dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    public func cerqel_showErrorAlert(with message: String?) {
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        cerqel_showAlert(with: "Something went wrong", message: message, actions: [okAction])
    }
    
    public func cerqel_showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        cerqel_showAlert(with: title, message: message, actions: [okAction])
    }
    
    public func cerqel_showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    public func cerqel_showLoading(){
        cerqel_HUD.showHUD()
//        HUD.show(in: self.view)
    }
    
    public func cerqel_hideLoading(){
//        HUD.dismiss()
        cerqel_HUD.stopHUD()
    }
    
    
}


extension UIViewController {
    
    // Not using static as it wont be possible to override to provide custom storyboardID then
    public class var cerqel_storyboardID : String {
        
        return "\(self)"
    }
    
    static func cerqel_instantiate(fromAppStoryboard appStoryboard: CerqelAppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}


extension UIViewController{

    public func cerqel_presentSheetController(viewToPresent: BottomSheetVCCerqel, fullScreenModel: Bool = false, height: CGFloat, bottomControl: Bool = true){
        
        let mySize: SheetSize = .fixed(CGFloat(height))
        
        var sheet = SheetViewController(controller: viewToPresent, sizes: [mySize])
        if fullScreenModel{
            sheet = SheetViewController(controller: viewToPresent, sizes: [mySize])
        }
//        sheet.handleColor = UIColor.clear
//        sheet.adjustForBottomSafeArea = bottomControl
//        sheet.extendBackgroundBehindHandle = true
        
        viewToPresent.cerqel_sheetCtl = sheet
        self.present(sheet, animated: false, completion: nil)
        
        
    }

    public func cerqel_openMediaMenu(isFileOnly: Bool = false, isImgOnly: Bool = false){
        let alert = UIAlertController(title: "Choose Image Source".localized, message: "", preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "Camera".localized, style: .default) { (_) in
            checkAuthorizationState(attachmentTypeEnum: .camera, vc: self,  parentView: self)
        }
        let actionGallary = UIAlertAction(title: "Photo Library".localized, style: .default) { (_) in
            checkAuthorizationState(attachmentTypeEnum: .photoLibrary, vc: self, parentView: self)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
        }
        let actionFile = UIAlertAction(title: "File".localized, style: .default) { (_) in
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            if let sself = self as? UIDocumentPickerDelegate{
                importMenu.delegate = sself
            }
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)

        }
        if !isFileOnly {
            alert.addAction(actionCamera)
            alert.addAction(actionGallary)
        }
        if !isImgOnly {
            alert.addAction(actionFile)
        }
        
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)

    }
    
    public  func documentType(forFileExtension fileExtension: String) -> String? {
        if #available(iOS 14.0, *) {
            switch fileExtension.lowercased() {
            case "pdf":
                return UTType.pdf.identifier
            case "powerpoint", "ppt", "pptx":
                return UTType.presentation.identifier
            case "word", "doc", "docx":
                return "org.openxmlformats.wordprocessingml.document"
            case "txt":
                return UTType.plainText.identifier
            case "msg":
                return UTType.message.identifier
                // Add more cases for other file types as needed
            default:
                return nil
            }
        } else {
            switch fileExtension.lowercased() {
              case "pdf":
                  return "public.pdf"
              case "powerpoint", "ppt", "pptx":
                  return "com.microsoft.powerpoint.ppt"
              case "word", "doc", "docx":
                  return "com.microsoft.word.doc"
              case "txt":
                  return "public.plain-text"
              case "msg":
                  return "com.apple.mail-message"
              // Add more cases for other file types as needed
              default:
                  return nil
              }
        }
    }
    
    public func openMFileMenu(attachmentExtensions: String) {
        DynamicAuthManager.shared.documentTypesOfExtensions.removeAll()
        var alertStyle: UIAlertController.Style = .actionSheet
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = .alert
        }

        let alert = UIAlertController(title: "Choose Source".localized, message: "", preferredStyle: alertStyle)

        let actionCancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
            // Handle cancellation if needed
        }

        alert.addAction(actionCancel)

        let extensions = attachmentExtensions.components(separatedBy: ",")

        var hasFileAction = false
        var hasImageAction = false
        var hasVideoAction = false

        for ext in extensions {
            if #available(iOS 14.0, *) {
                if let docType = documentType(forFileExtension: ext) {
                    DynamicAuthManager.shared.documentTypesOfExtensions.append(docType)
                   }
            }
        }
        for ext in extensions {
            let action: UIAlertAction

            if isFileType(ext) && !hasFileAction {
                hasFileAction = true
                action = UIAlertAction(title: "File".localized, style: .default) { (_) in
                        let importMenu = UIDocumentPickerViewController(documentTypes: DynamicAuthManager.shared.documentTypesOfExtensions, in: .import)
                        if let sself = self as? UIDocumentPickerDelegate {
                            importMenu.delegate = sself
                        }
                        importMenu.modalPresentationStyle = .formSheet
                        self.present(importMenu, animated: true, completion: nil)
                    }
            } else if isImageType(ext) && !hasImageAction {
                hasImageAction = true
                let actionCamera = UIAlertAction(title: "Camera".localized, style: .default) { (_) in
                    DynamicAuthManager.shared.isCameraOpened = true
                    checkAuthorizationState(attachmentTypeEnum: .camera, vc: self, parentView: self)
                }
                let actionGallery = UIAlertAction(title: "Photo Library".localized, style: .default) { (_) in
                    checkAuthorizationState(attachmentTypeEnum: .photoLibrary, vc: self, parentView: self)
                }
                
                action = actionCamera
                alert.addAction(actionGallery)
                
            }else if isVideoType(ext) && !hasVideoAction {
                hasVideoAction = true
                let videoAction = UIAlertAction(title: "Video Library".localized, style: .default) {(_) in
                    checkAuthorizationState(attachmentTypeEnum: .video, vc: self, parentView: self)
                }
                action = videoAction
            } else {
                continue
            }

            alert.addAction(action)
        }

        self.present(alert, animated: true, completion: nil)
    }

    public func isFileType(_ attachExtension: String) -> Bool {
        let fileExtensions = ["pdf", "excel", "powerpoint", "word", "txt", "msg"]
        return fileExtensions.contains(attachExtension.lowercased())
    }

    public func isImageType(_ attachExtension: String) -> Bool {
        let imageExtensions = ["jpg", "png", "jpeg"]
        return imageExtensions.contains(attachExtension.lowercased())
    }
    
    public func isVideoType(_ attachExtension: String) -> Bool {
        let videoExtensions = ["mp4", "mov"]
        return videoExtensions.contains(attachExtension.lowercased())
    }

}
