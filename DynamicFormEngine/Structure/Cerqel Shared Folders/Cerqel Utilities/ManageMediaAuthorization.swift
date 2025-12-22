//
//  ManageMediaAuthorization.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 2/17/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import Foundation
import Photos
import UIKit

enum AttachmentType: String{
    case camera, video, photoLibrary
}

func checkAuthorizationState(attachmentTypeEnum: AttachmentType, vc: UIViewController, parentView: Any){
    if attachmentTypeEnum ==  AttachmentType.camera{
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status{
        case .authorized: // The user has previously granted access to the camera.
            print("authhhhhhhh\(parentView)")
            DispatchQueue.main.async {
                openCamera(vc: vc, parentView: parentView)
            }
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("notttttttt\(vc)")
                    DispatchQueue.main.async {
                               openCamera(vc: vc, parentView: parentView)
                           }
                }
            }
            //denied - The user has previously denied access.
        //restricted - The user can't grant access due to restrictions.
        case .denied, .restricted:
            //            self.addAlertForSettings(attachmentTypeEnum)
            print("Access Denied")
            showAccessDeniedAlert(vc: vc)
            return
            
        default:
            break
        }
    }else if attachmentTypeEnum == AttachmentType.photoLibrary || attachmentTypeEnum == AttachmentType.video{
        let status = PHPhotoLibrary.authorizationStatus()
        switch status{
        case .authorized:
            if attachmentTypeEnum == AttachmentType.photoLibrary {
                photoLibrary(vc: vc, parentView: parentView, type: attachmentTypeEnum)
            }else if attachmentTypeEnum == AttachmentType.video {
                photoLibrary(vc: vc, parentView: parentView, type: attachmentTypeEnum)
            }
            
        case .denied, .restricted:
            //            self.addAlertForSettings(attachmentTypeEnum)
            print("Access Denied")
            showAccessDeniedAlert(vc: vc)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    photoLibrary(vc: vc, parentView: parentView, type: attachmentTypeEnum)
                }
                if attachmentTypeEnum == AttachmentType.video{
                    photoLibrary(vc: vc, parentView: parentView, type: attachmentTypeEnum)
                }
            })
        default:
            break
        }
    }
}


func openCamera(vc: UIViewController, parentView: Any){
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        let myPickerController = UIImagePickerController()
        if let mView = parentView as? UIImagePickerControllerDelegate & UINavigationControllerDelegate{
            myPickerController.delegate = mView
            myPickerController.sourceType = .camera
            vc.present(myPickerController, animated: true, completion: nil)
        }
    }
}


func photoLibrary(vc: UIViewController, parentView: Any, type: AttachmentType){
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            if let mView = parentView as? UIImagePickerControllerDelegate & UINavigationControllerDelegate{
                myPickerController.delegate = mView
                myPickerController.sourceType = .photoLibrary
                if type == .video {
                    myPickerController.mediaTypes = ["public.movie"]
                }
                vc.present(myPickerController, animated: true, completion: nil)
            }

        }

    }
}

func showAccessDeniedAlert(vc: UIViewController){
    let alertVC = UIAlertController(title: "Access Denied".localized, message: "Diwan doesn’t have access to resources, Go to Settings and allow access.".localized, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Settings".localized, style: .default, handler: { (alertAction) in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    })
    let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
    alertVC.addAction(ok)
    alertVC.addAction(cancel)
    vc.present(alertVC, animated: true, completion: nil)
    
}
