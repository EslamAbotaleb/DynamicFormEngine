//
//  UIImageViewExtensions.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 19/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit
internal import Kingfisher
internal import SDWebImage
internal import SDWebImageSVGCoder

extension UIImageView {
    
    func loadSVGImageWithAuth(urlString: String, placeHolder: UIImage? = nil, targetSize: CGSize) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Add Authorization via custom downloader request modifier
        let downloader = SDWebImageDownloader.shared
        let token = AuthManagerDynamicForm.shared.token
        downloader.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Define rendering context for SVG with resizing
        let context: [SDWebImageContextOption: Any] = [
            .imageCoder: SDImageSVGCoder.shared,
            .imageThumbnailPixelSize: targetSize
        ]
        
        self.sd_setImage(with: url, placeholderImage: placeHolder, options: [], context: context)
        
    }

    func loadUserWebImage(imageUrl:String, placeHolderImage:String, completion: @escaping (()->())) {
        let image = ("" + imageUrl)
        let urlStr = (image).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        loadWebImage(imageUrl: urlStr!, placeHolder: UIImage(named: placeHolderImage)!) {
            completion()
        }
    }

    func loadUserWebImage(imageUrl:String, completion: @escaping (()->())) {
        let image = ("" + imageUrl)
        let urlStr = (image).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        loadWebImage(imageUrl: urlStr!, placeHolder: UIImage(named: "placeholder_ic")!){
            completion()
        }
    }

    func loadUserWebImage(imageUrl:String, placeHolderImage: UIImage) {
        let image = ("" + imageUrl)
        let urlStr = (image).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        loadWebImage(imageUrl: urlStr!, placeHolder: placeHolderImage){}
    }



    private func loadWebImage(imageUrl: String, placeHolder: UIImage, completion: @escaping (()->())) {
        self.startAnimating()
        self.kf.indicatorType = .activity
        let url = URL(string: imageUrl)

        let modifier = AnyModifier { request in
            var r = request

            let token = AuthManagerDynamicForm.shared.token
            r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            return r
        }

        self.kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage, .requestModifier(modifier)
                ]){ result in
                switch result {
                case .success(let value):
                    print("✅ Image loaded successfully: \(value.image)")
                case .failure(let error):
                    print("❌ Failed to load image: \(error.localizedDescription)")
                    completion()
                }
            }
    }

}

extension UIButton {
    func loadWebImageWithUrl(imageUrl: String) {
        let image = ("" + imageUrl)
        let urlStr = image.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        loadWebImage(imageUrl: urlStr!)
    }

    private func loadWebImage(imageUrl: String) {
        let url = URL(string: imageUrl)
        self.kf.setBackgroundImage(with: url, for: .normal)
    }
}
