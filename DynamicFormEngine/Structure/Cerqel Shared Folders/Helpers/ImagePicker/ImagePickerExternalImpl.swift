//
//  PickImageControllerExternal.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import YPImagePicker
import Photos
import PhotosUI

public class PickImageManager: PickImageProtocol {
    
    var viewController: UIViewController
    
    public init(_ currentViewController: UIViewController) {
        self.viewController = currentViewController
        
    }
    
    public func selectSingleImage(imageSource:[YPPickerScreen] ,image: @escaping (UIImage) -> Void) {
        var config = YPImagePickerConfiguration()
        config.screens = imageSource
        config.hidesStatusBar = false
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 1
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                if let asset = photo.asset {
                    self.getAssetSizeInMB(asset: asset) { size in
                        if size > 4 {
                            self.showToast(message: "Max attachment size is 4 MB".localized)
                            return
                        } else {
                            image(photo.image)
                            picker.dismiss(animated: false, completion: nil)
                        }
                    }
                } else {
                    // Fallback if asset not available
                    if self.isSizeAllowed(img: photo.image) {
                        image(photo.image)
                        picker.dismiss(animated: false, completion: nil)
                    } else {
                        self.showToast(message: "Max attachment size is 4 MB".localized)
                        return
                    }
                }
            }else {
                picker.dismiss(animated: false, completion: nil)
            }
        }
        
        viewController.present(picker, animated: false, completion: nil)
    }
    
    public func selectImage(maxNum: Int, completionBlock: @escaping (_ images :[YPMediaItem] )->Void) {
        var config = YPImagePickerConfiguration()
        config.screens = [.library,.photo]
        config.hidesStatusBar = false
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = maxNum
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            completionBlock(items)
            picker.dismiss(animated: false, completion: nil)
        }
        viewController.present(picker, animated: false, completion: nil)
    }
    
    public func selectMedia(screens:[YPPickerScreen],mediaType:YPlibraryMediaType,completionBlock: @escaping (_ video :[YPMediaItem] )->Void) {
        
        var config = YPImagePickerConfiguration()
        config.screens = screens
        config.video.fileType = .mp4
        config.video.recordingTimeLimit = 1000000
        config.video.libraryTimeLimit = 1000000
        config.video.trimmerMaxDuration = 1000000
        config.hidesStatusBar = false
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.library.mediaType = mediaType
        config.library.maxNumberOfItems = 1
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            completionBlock(items)
            picker.dismiss(animated: true, completion: nil)
        }
        viewController.present(picker, animated: true, completion: nil)
    }
}

extension PickImageManager {
    
    public func getAssetSizeInMB(asset: PHAsset, completion: @escaping (Double) -> Void) {
        let resources = PHAssetResource.assetResources(for: asset)
        if let resource = resources.first,
           let fileSize = resource.value(forKey: "fileSize") as? CLong {
            completion(Double(fileSize) / (1024.0 * 1024.0))
        } else {
            completion(0)
        }
    }

    
    public func isSizeAllowed(img: UIImage) -> Bool {
        var imageSize = 0
        if let imgData = img.jpeg(.highest) {
            imageSize = imgData.count / 1024 / 1024
        }
        return imageSize <= 4
    }
    
    public func showToast(message: String) {
        guard let window = UIApplication.shared.windows.first else { return }

        let toast = UILabel()
        toast.text = message
        toast.textColor = .white
        toast.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toast.textAlignment = .center
        toast.numberOfLines = 0
        toast.layer.cornerRadius = 10
        toast.clipsToBounds = true
        
        let padding: CGFloat = 16
        toast.frame = CGRect(
            x: padding,
            y: window.safeAreaInsets.top + 10,
            width: window.frame.width - 2 * padding,
            height: 50
        )
        
        window.addSubview(toast)
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
            toast.alpha = 0
        }, completion: { _ in
            toast.removeFromSuperview()
        })
    }
}
  
