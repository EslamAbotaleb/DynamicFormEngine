//import Alamofire
//import Promises
//
//class ConcurrentFileUploader {
//    private var uploadRequests: [UploadRequest] = []
//    
//    func uploadFile(endpoint: Endpoint) -> Promise<NetworkServiceResponse> {
//        return Promise<NetworkServiceResponse> { fulfill, reject in
//            let uploadRequest = Alamofire.upload(
//                multipartFormData: { multipartFormData in
//                    // Add your file data to multipartFormData
//                },
//                to: endpoint.url,
//                method: .post,
//                headers: HTTPHeaders(endpoint.headers),
//                interceptor: nil,
//                fileManager: FileManager.default
//            ).uploadProgress { progress in
//                print("Progress: \(progress.fractionCompleted)")
//                // Handle progress updates
//            }.response { response in
//                switch response.result {
//                case .success(let data):
//                    fulfill(NetworkServiceResponse(data: data,
//                                                   statusCode: response.response?.statusCode,
//                                                   headers: response.response?.allHeaderFields))
//                case .failure(let error):
//                    reject(error)
//                }
//            }
//            
//            // Store the uploadRequest for later management
//            self.uploadRequests.append(uploadRequest)
//        }
//    }
//    
//    func cancelUpload(at index: Int) {
//        if index >= 0 && index < uploadRequests.count {
//            uploadRequests[index].cancel()
//            uploadRequests.remove(at: index)
//        }
//    }
//}
