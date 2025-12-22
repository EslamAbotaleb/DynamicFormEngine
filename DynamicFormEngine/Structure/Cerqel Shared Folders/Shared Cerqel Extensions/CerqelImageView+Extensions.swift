//
//  ImageView+Extensions.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 09/04/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func loadWebImageWithUrl(imageUrl: String, placeHolder: UIImage = UIImage(named: "empty-dummy")!, completion: @escaping (()->())) {
        let image = ("" + imageUrl)
        let urlStr = image.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        loadWebImage(imageUrl: urlStr!, placeHolder: placeHolder) {
            completion()
        }
    }
    
    private func loadWebImage(imageUrl: String, placeHolder: UIImage, completion: @escaping (()->())) {
        
        self.startAnimating()
        self.kf.indicatorType = .activity
        let url = URL(string: imageUrl)
        
        let modifier = AnyModifier { request in
            var r = request
            
            let token = AuthManager.shared.token
            r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            return r
        }
        
        self.kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .transition(.fade(1)),
                .cacheMemoryOnly,
                .requestModifier(modifier)
            ]){ result in
                switch result {
                case .success(let value):
                    print("✅ Image loaded successfully: \(value.image)")
                case .failure(let error):
                    completion()
                }
            }
    }
    
    func cerqel_LoadImgWithUrl(imgUrl: String?, brokenImgName: String = "empty-dummy", completion: @escaping (()->())) {
        self.tintColor = primaryMain
        self.kf.indicatorType = .activity
        
        let modifier = AnyModifier { request in
            var r = request
            
            let token = AuthManager.shared.token
            r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            return r
        }
        
        self.kf.setImage(with: URL(string: (imgUrl ?? "").cerqel_replace(target: "Download",
                                                                         withString: "Preview").cerqel_CreateMediaURL()),
                         options: [
                            .cacheOriginalImage,
                            .requestModifier(modifier)
                         ],
                         completionHandler: { result in
            switch result {
            case .success(let value):
                print(value)
                
                /// - emptyRequest: The request is empty. Code 1001.
                /// - invalidURL: The URL of request is invalid. Code 1002.
                /// - URLSessionError: An error happens in the system URL session. Code 2003.
                /// - emptySource: The input resource is empty or `nil`. Code 5001.
            case .failure(let error):
                if error.errorCode == 1001 || error.errorCode == 1002 || error.errorCode == 2003 || error.errorCode == 5001 {
                    self.image = UIImage(named: brokenImgName)
                } else {
                    print(error)
                }
                completion()
            }
        })
    }
    
    func cerqel_loadImage(from url: URL?, placeHolderImage: UIImage? = nil) {
        let modifier = AnyModifier { request in
            var r = request
            
            let token = AuthManager.shared.token
            r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            return r
        }
        self.kf.setImage(with: url, placeholder: placeHolderImage, options: [.requestModifier(modifier), .forceRefresh])
        //    })
    }
    
    func cerqel_resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func cerqel_resizedImage(at url: URL, for size: CGSize) -> UIImage?
    {
        guard let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))}}
}

extension UIImage {
    
    func cerqel_resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func cerqel_resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func cerqel_scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
    
    enum ImageFormat: String {
        case jpeg = "jpg"
        case png = "png"
        case gif = "gif"
        case tiff = "tiff"
        case unknown = ""
    }
    
    /// Detect actual format from Data
    var imageFormat: ImageFormat {
        guard let data = self.pngData() ?? self.jpegData(compressionQuality: 1.0) else {
            return .unknown
        }
        return UIImage.format(for: data)
    }
    
    private static func format(for data: Data) -> ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 1)
        data.copyBytes(to: &buffer, count: 1)
        
        switch buffer[0] {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        default:
            return .unknown
        }
    }
    
}
