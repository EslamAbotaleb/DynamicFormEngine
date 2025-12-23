//
//  UploadMediaUIModel.swift
//  CERQEL
//
//  Created by hassan elshaer on 24/12/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
internal import Alamofire
import UIKit

class UploadMediaUIModel {
    var id: String
    var uploadedMedia: ModelUploadedMedia?
    var state: UploadingState
    var request: UploadRequest?

    init(
        id: String, uploadedMedia: ModelUploadedMedia? = nil,
        state: UploadingState, request: UploadRequest? = nil
    ) {
        self.id = id
        self.uploadedMedia = uploadedMedia
        self.state = state
        self.request = request
    }

    enum UploadingState {
        case failed, success
        case inProgress(Double)
    }
}
