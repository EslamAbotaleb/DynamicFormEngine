//
//  DynamicAuthManager.swift
//  CERQEL
//
//  Created by hassan elshaer on 18/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
internal import RxCocoa
internal import RxSwift

class DynamicAuthManager {
    
    private let service: cerqel_NetworkServiceDynamicForm = cerqel_BasicNetworkServiceDynamicFormImpl.shared
    private let disposeBag = DisposeBag()
    var documentTypesOfExtensions: [String] = []
    var isTasks = true
    static var shared = DynamicAuthManager()
    var isCameraOpened = false

    var isPopUpFromFormBuilder:((String) -> ())?
    var isInboxRefreshRequired = false
    
    func convertToUploadMediaUIModel(from attachment: AttachmentForDefault) -> UploadMediaUIModel {
        let state: UploadMediaUIModel.UploadingState = attachment.isSuccess ?? false ? .success : .success
        let uploadedMedia = ModelUploadedMedia(downloadUrl: attachment.downloadUrl,
                                               previewUrl: attachment.previewUrl,
                                               contentType: nil, // Set according to your requirement
                                               documentType: attachment.fileExtension, // Set according to your requirement
                                               fileSize: attachment.size,
                                               id: attachment.fileId,
                                               isPublic: attachment.isPublic,
                                               name: attachment.fileName,
                                               isStillUploading: false, // Not uploading again, so set to false
                                               additionalProperty01: nil,
                                               additionalProperty02: nil,
                                               additionalProperty03: nil,
                                               additionalProperty04: nil)
        
        return UploadMediaUIModel(id: attachment.fileId ?? "",
                                  uploadedMedia: uploadedMedia,
                                  state: state,
                                  request: nil)
    }
}
