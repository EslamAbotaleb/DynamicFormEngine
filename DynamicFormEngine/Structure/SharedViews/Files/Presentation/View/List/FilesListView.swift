//
//  OrderListView.swift
//  beauty_provider
//
//  Created by Mac on 10/25/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Foundation
import PanModal
import QuickLook
import DynamicFormEngine


struct FileFilter {
    var fileFrom:FileDestination?
    var subcategory: SubCategoryModel?
    var isPinned: Bool?

}

enum SelectionMode {
    case appear
    case hidden
}
enum FileDestination: String {
    case subCategory
    case allFiles
    case globalSearch
    case recent = "Recent"
    case pinned = "Pinned"
}

class FileFilterItem: GlobalSearchItem {
    var fileFrom:FileDestination
    var subcategory: ListModel?
    var isPinned: Bool?

    init(fileFrom: FileDestination = .allFiles,displayName: String = "",resultsCount: Int = 0 ,subcategory: ListModel = ListModel(), filterPayload: CerqelFilterPayload = CerqelFilterPayload () ) {

        self.fileFrom = fileFrom
        self.subcategory = subcategory
        super.init(destination: .cms, displayName: displayName,resultsCount: resultsCount,filterPayload: filterPayload)

    }

}


class FilesListView: BaseView<FilesListViewModel, FileFilterItem>  {

    let fileCellIdintifier = String(describing: FillCell.self)
    let fileGridCellIdintifier = String(describing: FileGridCell.self)

    private let refreshControl = UIRefreshControl()


    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var selectionModeImage: UIImageView!
    @IBOutlet weak var sortApplied: UIImageView!
    @IBOutlet weak var selectedFilesCount: UILabel!
    @IBOutlet weak var filesSelectStackView: UIView!
    @IBOutlet weak var filesActionStackView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var allFilesCount: UILabel!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var gridIcon: UIImageView!
    @IBOutlet weak var listModeView: UIStackView!
    @IBOutlet weak var listModeseprator: UIView!
    @IBOutlet weak var layoutBorder: UIStackView!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var headerView: CerqelReusableHeader!

    var localFileURLToPreview: URL?

    @IBOutlet weak var filesCollectionView: UICollectionView!{
        didSet{
            self.filesCollectionView.registerCell(idintifier: fileCellIdintifier)
            self.filesCollectionView.registerCell(idintifier: fileGridCellIdintifier)
        }
    }

    deinit {
        removerObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initialConfiguration()
        configureHeaderAction()
        initRefreshController()
        handleObservation()
        handleTableLongPress()
        setupHeaderView()
        viewModel.getFiles()

    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //  viewModel.reloadPage()
        viewModel.checkFileLayout()
        self.sortApplied.isHidden = SubCategoriesBaseView.shared.filterStatus == nil
        viewModel.selectedSort.value = SubCategoriesBaseView.shared.filterStatus ?? "Newest"
        viewModel.checkForfilterPreviousView()
    }


    private func initialConfiguration(){
        viewModel = FilesListViewModel(fileItem: item, router: CerqelRouterManagerImpl(self), delegate: self, gsFileListUseCase: GSFileListUseCaseImpl())


    }

    private func fileActionObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HandlefileAction),
                                               name: NSNotification.Name(rawValue: "fileAction"),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HandlePinnedFile),
                                               name: NSNotification.Name(rawValue: "pinnedFile"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(downloadForPreviewStarted),
                                               name: NSNotification.Name(rawValue: "DownloadFileForPreviewStarted"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(downloadForPreviewEnded),
                                               name: NSNotification.Name(rawValue: "DownloadFileForPreviewEnded"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(downloadForPreviewFailed),
                                               name: NSNotification.Name(rawValue: "DownloadFileForPreviewFailed"),
                                               object: nil)

    }
    private func removerObserver(){
        NotificationCenter.default.removeObserver(self)
    }

    @objc fileprivate func downloadForPreviewStarted(notification: Notification){
        showLoadingCerqel()
    }
    
    @objc fileprivate func downloadForPreviewEnded(notification: Notification){
        hideLoadingCerqel()
    }
    
    @objc fileprivate func downloadForPreviewFailed(notification: Notification){
        self.cerqel_showAlert(with: nil, message: "Unable to view attachment, Server error".localized)
    }

    @objc fileprivate func HandlefileAction(notification: Notification){
        if let fileActionType = notification.userInfo?["fileActionType"] , let fileId = notification.userInfo?["fileId"] as? String {
            switch fileActionType as? FileActionType {
            case .acknowledge :
                if let acknowledge = notification.userInfo?["acknowledge"] as? FileAcknowledgeResponse {
                    viewModel.recieveFileAction(fileId: fileId, Acknowledge: acknowledge)

                }

            default: break

            }
        }
    }

    @objc fileprivate func HandlePinnedFile(notification: Notification){
        if let destination = notification.userInfo?["destination"] as? FileDestination {
            guard item.fileFrom != destination else {
                return
            }
            viewModel.reloadPage()
        }

    }


    private func setupHeaderView() {
        self.headerView.isHidden = item.fileFrom != .allFiles
        self.headerView.buttonsView.isHidden = true
        self.headerView.disableSearch()
    }

    private func configureUI() {
        //   self.view.backgroundColor = TypographyLinks
        self.allFilesCount.font = UIFont.bodyLRegular()
        self.allFilesCount.textColor = typographyTitle
        self.downloadView.backgroundColor = primaryMain
        cancelBtn.setTitleColor(.links, for: .normal)
        listIcon.tintColor = primaryMain
        gridIcon.tintColor = primaryMain
        layoutBorder.borderColorV = primaryMain
        sortBtn.tintColor = primaryMain
        sortApplied.tintColor = UIColor.error_Cerqel
        sortView.borderColorV = primaryMain
        listModeseprator.backgroundColor = primaryMain
        self.view.backgroundColor = .white
        self.bgV.backgroundColor = bg
        setNavigationTitle("All Files".localized)
        setupBackButton()
    }


    private func configureHeaderAction() {
        headerView.didSearchNewViewButton = { [weak self] in
            guard let self = self else { return }
            self.viewModel.routeToSearch()

        }

        headerView.didTapFilterButton = { [weak self] in
            guard let self = self else { return }
            self.viewModel.routeToFilter()
        }

    }

    private func handleObservation() {

        viewModel.filesList.bind{ list in
            self.refreshControl.endRefreshing()
            self.filesCollectionView.removeNoDataPlaceholder()
            if list.count == 0  {
                self.filesCollectionView.setNoDataPlaceholder()
            }
            self.filesActionStackView.isHidden = list.isEmpty || self.viewModel.selectionMode.value == .appear || self.item.fileFrom == .globalSearch
            self.filesCollectionView.reloadData()
            guard self.viewModel.pullToRefresh.value && !list.isEmpty  else {
                return
            }
            self.filesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)

        }
        viewModel.fileLayout.bind { layout in
            self.listView.backgroundColor = layout == .defaultLayout ? primaryLight : .white
            self.gridView.backgroundColor = layout == .gridLayout ? primaryLight : .white
            self.filesCollectionView.reloadData()
        }
        viewModel.allFilesCount.bind{ filesCount in
            self.allFilesCount.text = "Showing".localized  + " (\(filesCount))"
        }
        viewModel.selectedFilesCount.bind{ count in
            self.downloadView.isHidden = count == 0
            guard count != 0 else {
                self.selectionModeImage.image = UIImage(named: "Checkbox Unchecked")
                self.selectedFilesCount.text = "Select All"
                return
            }

            self.selectedFilesCount.text = "Selected (\(count)) "
            self.selectionModeImage.image =  self.viewModel.allFilesSelected.value ? UIImage(named:"Checkbox Checked") : UIImage(named:"un_select_all")
        }


        viewModel.selectionMode.bind{ mode in
            switch mode {
            case .appear :
                self.showSelectionModeView()
            case.hidden :
                self.hideSelectionModeView()
            }

        }
        fileActionObserver()
    }

    private func handleTableLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        filesCollectionView.addGestureRecognizer(longPress)
    }


    private func initRefreshController() {
        if #available(iOS 10.0, *) {
            filesCollectionView.refreshControl = refreshControl
        } else {
            filesCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }


    private func hideSelectionModeView(){
        self.filesSelectStackView.isHidden = true
        //        if item.fileFrom != .globalSearch {
        self.filesActionStackView.isHidden = item.fileFrom != .globalSearch
        //  }

        self.downloadView.isHidden = true
        viewModel.cancelSelectionMode()
    }

    private func showSelectionModeView(){
        self.filesSelectStackView.isHidden = false
        self.filesActionStackView.isHidden = true
        self.downloadView.isHidden = false
    }


    private func handleSortAction() {
        CerqelBaseSortVC.presentSheet(sortData: viewModel.initialSortData.value, sortType: .radioBtnTV, sortSelectedName: viewModel.selectedSort.value, sortTitle: "Sort By".localized, selectedAction: { [weak self] selectedSort in

            self?.viewModel.selectedSort.value = selectedSort
            self?.viewModel.handleSortPayload()
            if self?.item.fileFrom == .subCategory {
                SubCategoriesBaseView.shared.filterStatus = selectedSort
            }
            self?.sortApplied.isHidden = false
        }, from: self)
    }

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: filesCollectionView)
            if let indexPath = filesCollectionView.indexPathForItem(at: touchPoint) {
                viewModel.showSelectionMode(fileIndex: indexPath.row)
                viewModel.selectionMode(.appear)


            }
        }
    }

    @objc private func pullToRefresh(_ sender: Any) {
        viewModel.reloadAllFiles()
    }

}

//MARK: - Actions
extension FilesListView {

    @IBAction func fileGridLayout(_ sender: Any) {
        viewModel.handleFileLayout(.gridLayout)

    }

    @IBAction func fileDefaultLayout(_ sender: Any) {
        viewModel.handleFileLayout(.defaultLayout)
    }

    @IBAction func handleSelectFiles(_ sender: Any) {
        viewModel.selectedFilesCount.value == 0 && !viewModel.allFilesSelected.value ?  viewModel.selectAllFile() :   viewModel.unSelectionFiles()
    }

    @IBAction func cancelSelectionMode(_ sender: Any) {
        viewModel.selectionMode(.hidden)
    }

    @IBAction func download(_ sender: Any) {
        viewModel.downloadMultibleFile()
    }


    @IBAction func sort(_ sender: Any) {
        handleSortAction()
    }


    func viewDoc(_ indx: Int) {
        let file = self.viewModel.filesList.value[indx]
        if file.fileExtension.lowercased().contains("pdf") {
            let fileWebViewController = FileWebViewController()
            fileWebViewController.file = file
            let navController = UINavigationController(rootViewController: fileWebViewController)
            self.viewModel.viewFileEndPoint(fileId: self.viewModel.filesList.value[indx].id)
            self.present(navController, animated: true)
        } else {
            self.showLoadingCerqel()
            viewModel.downloadFileForPreview(file: file) { file in
                self.hideLoadingCerqel()
                if let fileURL = file?.localFileUrl {
                    DispatchQueue.main.async {
                        self.openInQuickLook(url: fileURL)
                    }
                }
             }
        }
    }
    
    func openInQuickLook(url: URL) {
        self.localFileURLToPreview = url
        let preview = QLPreviewController()
        preview.dataSource = self
        preview.delegate = self
        self.present(preview, animated: true)
    }
}

extension FilesListView: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return localFileURLToPreview! as QLPreviewItem
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension FilesListView: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch item.fileFrom {
        case .subCategory : return IndicatorInfo(title: item.subcategory?.name ?? "")
        case .recent : return IndicatorInfo(title: item.displayName)
        case .pinned : return IndicatorInfo(title: item.displayName)
        case.globalSearch : return IndicatorInfo(title: item.displayName.localized, image: nil,userInfo: item.resultsCount)
        default: break
        }
        return IndicatorInfo(title: item.subcategory?.name ?? "")


    }


}

extension FilesListView: ActionsProtocol {
    func handleFileAction(fileId: String, actionId: Int) {
        switch actionId {
        case 1:
            let destination: [String: Any] = [ "destination":item.fileFrom ]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pinnedFile"), object: nil, userInfo: destination)
        case 2,3,4 : viewModel.showDownloadMessage()
        case 7 : viewModel.HandleFilePinnedAction(fileId: fileId)
        default: break
        }
    }
}

//MARK:- Colection Delegate
extension FilesListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  viewModel.filesList.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        let file = viewModel.filesList.value[indexPath.row]
        switch viewModel.fileLayout.value  {
        case .defaultLayout :
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: fileCellIdintifier, for: indexPath) as! FillCell
            (cell as!FillCell).configure(file,selectionMode: viewModel.selectionMode.value)
            (cell as!FillCell).sepratorLabel.isHidden = indexPath.row == viewModel.filesList.value.count - 1
            (cell as!FillCell).fileActionIsShown = {[weak self] in
                self?.viewModel.presentFileAction(file: file)
            }
            (cell as!FillCell).fileSelected = {[weak self] in
                self?.viewModel.selectFile(fileIndex: indexPath.row)
            }
        case .gridLayout :
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: fileGridCellIdintifier, for: indexPath) as! FileGridCell
            (cell as!FileGridCell).configure(file,selectionMode: viewModel.selectionMode.value)
            (cell as!FileGridCell).fileSelected = {[weak self] in
                self?.viewModel.selectFile(fileIndex: indexPath.row)
            }
            (cell as!FileGridCell).fileActionIsShown = {[weak self] in
                self?.viewModel.presentFileAction(file: file)

            }
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.filesList.value.count - 1 && viewModel.currentPage.value < viewModel.totalPages.value &&  !viewModel.pullToRefresh.value {
            viewModel.loadNextFiles()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewDoc(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        switch viewModel.fileLayout.value {
        case .defaultLayout :
            return CGSize(width: collectionWidth, height: 96)
        case .gridLayout :
            return CGSize(width: collectionWidth/2 - 8 , height: 230)
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch viewModel.fileLayout.value  {
        case .defaultLayout :
            return 0
        case .gridLayout :
            return 16
        }

    }

}

extension FilesListView: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
