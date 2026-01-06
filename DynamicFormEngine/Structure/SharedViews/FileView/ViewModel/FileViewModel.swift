//
//  fileViewViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 20/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

class FileViewModel: BaseVM {
    private var router:CerqelRouterManager
    private var documentRepo: DocumentLibraryRepo!
    private var localNotification: LocalNotificationProtocol!

    public var fileDownloaded: DynamicObjects<Bool> = DynamicObjects(false)
    
    
    public init( router: CerqelRouterManager ) {
        self.router = router
    }
    
    override public func hydrate() {
        setupDepencies()
        
    }
    
    private func setupDepencies(){
        
        self.documentRepo = DocumentLibraryRepoImpl()
        self.localNotification = LocalNotificationManager.shared
    }
    
    public func downloadFile(file: FileModel) {
        showSystemAlert(alert: "Starting downloading the file".localized)
        DownloadManager.shared.downloadFiles(from: [file]) { (file, error) in
            if let fileDownloaded = file {
                self.localNotification.scheduleLocalNotification(file: fileDownloaded)
                self.fileDownloaded.value = true
            } else if let error = error {
                self.showErrorAlert(message: "Unable to download attachment, Server error".localized)
                print("Download error: \(error)")
            }
        }
    }
}
