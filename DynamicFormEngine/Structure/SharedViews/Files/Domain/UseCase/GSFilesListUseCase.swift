//
//  GSFilesListUseCase.swift
//  CERQEL
//
//  Created by Youxel on 08/02/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import Foundation
import Promises
import DynamicFormEngine

protocol GSFileListUseCase {
    func execute(cerqelFilterPayload: CerqelFilterPayload)  -> Promise<BaseResponse<FileDTO>>
}


class GSFileListUseCaseImpl: GSFileListUseCase {

    private let repository: GlobalSearchRepo

    init(repository: GlobalSearchRepo = GlobalSearchRepoImpl()) {
        self.repository = repository
   
    }
   
//    func execute(cerqelFilterPayload: CerqelFilterPayload) -> Promise<BaseResponse<FileDTO>> {
//        return Promise<BaseResponse<FileDTO>> { fulfill, reject in
//            self.repository.getAllFiles(cerqelFilterPayload: cerqelFilterPayload, feature: Features.Document).then { response in
//                let mappedEntities = response.result.data
//                let result = Result(totalCount: response.result.totalCount, data: FileDTO(files: mappedEntities, highlightedFilters: nil), pagesCount: response.result.pagesCount)
//                let baseResponse = BaseResponse(message: response.message, result: result)
//                fulfill(baseResponse)
//            }.catch { error in
//                reject(error)
//            }
//        }
//    }
    func execute(cerqelFilterPayload: CerqelFilterPayload) -> Promise<BaseResponse<FileDTO>> {
        return repository.getAllFiles(cerqelFilterPayload: cerqelFilterPayload, feature: Features.Document)
            .then { response -> BaseResponse<FileDTO> in
                let mappedEntities = response.result.data
                let result = Result(
                    totalCount: response.result.totalCount,
                    data: FileDTO(files: mappedEntities, highlightedFilters: nil),
                    pagesCount: response.result.pagesCount
                )
                return BaseResponse(message: response.message, result: result)
            }
    }
}

