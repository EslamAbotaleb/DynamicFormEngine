//
//  imageView+Extention.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 15/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//


import Foundation
import UIKit
extension UIImageView {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
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
    
    func resizedImage(at url: URL, for size: CGSize) -> UIImage?
    {
        guard let image = UIImage(contentsOfFile: url.path) else {
        return nil
    }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))}}
    
      func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
      }
    
}
//    func loadFrom(URLAddress: String) -> UIImage{
//        let loadImage = UIImage()
//     if let url = URL(string: URLAddress){
//
//    DispatchQueue.main.async { [weak self] in
//    if let imageData = try? Data(contentsOf: url) {
//    if let loadedImage = UIImage(data: imageData) {
//    self?.image = loadedImage
//        self.loadImage = loadedImage
//        }
//       }
//      }
//     }
//    }
//    return loadImage
//}

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

extension UIImage {
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
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

    func toData() -> Data? {
        return self.pngData()
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return  self.jpegData(compressionQuality: jpegQuality.rawValue)
    }

}
extension UIImageView {
    
    func makeRounded(borderColor : UIColor?) {
        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.borderColor = borderColor == nil ? UIColor.black.cgColor : borderColor?.cgColor
        layer.cornerRadius = self.frame.size.height / 2
        clipsToBounds = true
    }
  
}
