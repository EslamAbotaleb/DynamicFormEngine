//
//  FilesActionsViewModel.swift
//  CERQEL
//
//  Created by ahmed maher on 13/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit
import DynamicFormEngine

enum ActionCategory {
    case normal
    case delete
}

struct FileActions {
    var id: Int
    var title: String
    var isPinned: Bool?
    var fileAcknowledge: FileAcknowledgeStatus?
    var image: String?
    var actionType: ActionCategory = .normal
}


class FileActionsViewModel: BaseVM {

    // Dependencies

    private var router:CerqelRouterManager
    private var currentRouter:CerqelRouterManager
    private var delegate: ActionsProtocol
    private var documentRepo: DocumentLibraryRepo!
    private var localNotification: LocalNotificationProtocol!
//    private var fileViewer: FileViewer

    var file: FileModel
    var allActions: DynamicObjects<[FileActions]> = DynamicObjects([])
    var actions: DynamicObjects<[FileActions]> = DynamicObjects([])

    init(router: CerqelRouterManager,currentRouter: CerqelRouterManager,file: FileModel,delgate: ActionsProtocol) {
        self.router = router
        self.currentRouter = currentRouter
        self.file = file
        self.delegate = delgate
    }

    override func hydrate() {
        setupDepencies()
    }

    private func setupDepencies(){
        self.documentRepo = DocumentLibraryRepoImpl()
        self.localNotification = LocalNotificationManager.shared

    }

    // initial
    func allFileActions() {
        allActions.value = [FileActions(id: 1, title: "View".localized, image: "eye"),
                            FileActions(id: 2, title: "Download".localized, image: "download_file"),
                            FileActions(id: 3, title: "Arabic Version".localized),
                            FileActions(id: 4, title: "English Version".localized),
                            FileActions(id: 5, title: "Report".localized, image: "export"),
                            FileActions(id: 6, title: "Acknowledge".localized, fileAcknowledge: file.fileAcknowledgeStatus, image: "Acknowledge"),
                            FileActions(id: 7, title:file.isPinned ? "unPin".localized : "Pin".localized, isPinned: file.isPinned, image: "pin_file")
        ]

    }

    func setDesiredFileActions() {
        switch file.versionId {
        case 1 : actions.value =  allActions.value // both
        case 2,3 : actions.value =  allActions.value.filter{$0.id != 3 && $0.id != 4}
        default: actions.value =  allActions.value
        }


    }

    func openFile(fileId: String) {
        currentRouter.dismissCurrentController( completion: { [weak self] in
            guard let self = self else { return }
            self.viewFileEndPoint(fileId: fileId)
        })
    }

    func downloadFile(fileId: String, actionId: Int) {
        self.delegate.handleFileAction(fileId: fileId, actionId: actionId)
        file.fileURl = actionId == 2 ? file.fileURl : actionId == 3 ? file.fileUrlAr :  file.fileUrlEn
    }

    // routes
    func push(fileId: String,actionId : Int) {
        if (actionId == 2 && file.versionId == 1) {
            return
        }
        else {
            dismiss()
            handleActions(fileId: fileId, actionId: actionId)

        }
    }

    func handleActions(fileId: String, actionId: Int) {
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

    func routeToReport(fileId: String) {
        router.pushTo(controller: ReportView.self, viewModel: ReportViewModel.self, item: FileItem(fileId: fileId))
    }
    func routeToAcknowledge(fileId: String) {
        router.pushTo(controller: AcknowledgeVC.self, viewModel: AcknowledgeViewModel.self, item: FileItem(fileId: fileId))
    }


    func dismiss() {
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
