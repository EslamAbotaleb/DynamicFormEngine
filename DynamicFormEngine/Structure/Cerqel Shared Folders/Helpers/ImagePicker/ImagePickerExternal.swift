//
//  ImagePickerExternal.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit
import YPImagePicker

public enum MediaType:String{
    case video = "video"
    case image = "image"
}

public protocol PickImageProtocol {
    func selectSingleImage (imageSource:[YPPickerScreen],image: @escaping (_ image :UIImage ) -> Void)
    func selectImage (maxNum: Int, completionBlock: @escaping (_ images :[YPMediaItem] )->Void)
    func selectMedia (screens:[YPPickerScreen],mediaType:YPlibraryMediaType,completionBlock: @escaping (_ video :[YPMediaItem] )->Void)
}
