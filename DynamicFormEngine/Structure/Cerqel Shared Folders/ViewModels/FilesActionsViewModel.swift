//
//  FilesActionsViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 13/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

public enum ActionCategory {
    case normal
    case delete
}

public struct FileActions {
    public var id: Int
    public var title: String
    public var isPinned: Bool?
    public var fileAcknowledge: FileAcknowledgeStatus?
    public var image: String?
    public var actionType: ActionCategory = .normal
    
    public init(id: Int, title: String, isPinned: Bool? = nil, fileAcknowledge: FileAcknowledgeStatus? = nil, image: String? = nil, actionType: ActionCategory) {
        self.id = id
        self.title = title
        self.isPinned = isPinned
        self.fileAcknowledge = fileAcknowledge
        self.image = image
        self.actionType = actionType
    }
    
    public init(id: Int, title: String, image: String? = nil) {
        self.id = id
        self.title = title
        self.image = image
    }
    
    public init(id: Int, title: String, fileAcknowledge: FileAcknowledgeStatus? = nil, image: String? = nil) {
        self.id = id
        self.title = title
        self.fileAcknowledge = fileAcknowledge
        self.image = image
    }
    
    public init(id: Int, title: String, isPinned: Bool? = nil, image: String? = nil) {
        self.id = id
        self.title = title
        self.isPinned = isPinned
        self.image = image
    }
}

internal class FileActionsViewModel: BaseVM {

    // Dependencies
    private var router:CerqelRouterManager
    private var currentRouter:CerqelRouterManager
    private var delegate: ActionsProtocol
    private var documentRepo: DocumentLibraryRepo!
    private var localNotification: LocalNotificationProtocol!
    private var fileViewer: FileViewer

    public var file: FileModel
    public var allActions: DynamicObjects<[FileActions]> = DynamicObjects([])
    public var actions: DynamicObjects<[FileActions]> = DynamicObjects([])

    public init(
         router: CerqelRouterManager,
         currentRouter: CerqelRouterManager,
         file: FileModel,
         delegate: ActionsProtocol,
         fileViewer: FileViewer) {
         self.router = router
         self.currentRouter = currentRouter
         self.file = file
         self.delegate = delegate
         self.fileViewer = fileViewer
         super.init()
     }

    override open func hydrate() {
        setupDepencies()
    }

    private func setupDepencies(){
        self.documentRepo = DocumentLibraryRepoImpl()
        self.localNotification = LocalNotificationManager.shared

    }

    // initial
    public func allFileActions() {
        allActions.value = [FileActions(id: 1, title: "View".localized, image: "eye"),
                            FileActions(id: 2, title: "Download".localized, image: "download_file"),
                            FileActions(id: 3, title: "Arabic Version".localized),
                            FileActions(id: 4, title: "English Version".localized),
                            FileActions(id: 5, title: "Report".localized, image: "export"),
                            FileActions(id: 6, title: "Acknowledge".localized, fileAcknowledge: file.fileAcknowledgeStatus, image: "Acknowledge"),
                            FileActions(id: 7, title:file.isPinned ? "unPin".localized : "Pin".localized, isPinned: file.isPinned, image: "pin_file")
        ]

    }

    public func setDesiredFileActions() {
        switch file.versionId {
        case 1 : actions.value =  allActions.value // both
        case 2,3 : actions.value =  allActions.value.filter{$0.id != 3 && $0.id != 4}
        default: actions.value =  allActions.value
        }


    }

    public func openFile(fileId: String) {
        currentRouter.dismissCurrentController( completion: { [weak self] in
            guard let self = self else { return }
            self.viewFileEndPoint(fileId: fileId)
        })
    }

    public func downloadFile(fileId: String, actionId: Int) {
        self.delegate.handleFileAction(fileId: fileId, actionId: actionId)
        file.fileURl = actionId == 2 ? file.fileURl : actionId == 3 ? file.fileUrlAr :  file.fileUrlEn
    }

    // routes
    public func push(fileId: String,actionId : Int) {
        if (actionId == 2 && file.versionId == 1) {
            return
        }
        else {
            dismiss()
            handleActions(fileId: fileId, actionId: actionId)

        }
    }

    public func handleActions(fileId: String, actionId: Int) {
        switch actionId {
        case 1: openFile(fileId: fileId)
        case 2 : downloadFile(fileId: fileId,actionId: actionId)
        case 3,4 : downloadFile(fileId: fileId, actionId: actionId)
        case 5 : routeToReport(fileId: fileId)
        case 6 : routeToAcknowledge(fileId: fileId)
        case 7 : pinEndPoint(fileId: fileId)
        default: break
        }
    }

    public func routeToReport(fileId: String) {
        router.pushTo(controller: ReportView.self, viewModel: ReportViewModel.self, item: FileItem(fileId: fileId))
    }
    public func routeToAcknowledge(fileId: String) {
        router.pushTo(controller: AcknowledgeVC.self, viewModel: AcknowledgeViewModel.self, item: FileItem(fileId: fileId))
    }


    public func dismiss() {
        router.dismiss()
    }

    //endPoint
    private func viewFileEndPoint(fileId: String ) {
        documentRepo.view(fileId: fileId).then { (response) in
            self.delegate.handleFileAction(fileId: fileId, actionId: 1)
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
        }
    }

    func pinEndPoint(fileId: String ) {
        self.showHudLoading()
        documentRepo.pin(fileId: fileId).then { (response) in
            self.delegate.handleFileAction(fileId: fileId, actionId: 7)
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()

        }
    }
}
