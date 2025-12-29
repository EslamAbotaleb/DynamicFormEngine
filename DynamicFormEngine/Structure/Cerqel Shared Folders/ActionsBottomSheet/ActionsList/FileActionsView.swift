//
//  FileActions.swift
//  CERQEL
//
//  Created by ahmed maher on 13/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
public import PanModal

protocol PushFromPrsentedScreen {
    func push(fileId: String, actionId : Int)
    func push( actionId : Int)
}
extension PushFromPrsentedScreen {
    func push(fileId: String, actionId : Int) {
        
    }
    func push( actionId : Int){
        
    }
}

protocol ActionsProtocol {
    func handleFileAction(fileId: String, actionId : Int)
}




class FileActionItem: BaseItem {
    var file: FileModel
    var router:CerqelRouterManager
    var delegate:ActionsProtocol?
    
    init(file: FileModel,router:CerqelRouterManager,delegate: ActionsProtocol ) {
        self.file = file
        self.router = router
        self.delegate = delegate
    }
}

class FileActionsView: BaseView<FileActionsViewModel, FileActionItem> {
    
    let fileActionCellIdintifier = String(describing: FileActionCell.self)
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
//            self.tableView.registerCell(idintifier: fileActionCellIdintifier)
            self.tableView.register(UINib(nibName: fileActionCellIdintifier, bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: fileActionCellIdintifier)

            tableView.estimatedRowHeight = 50.0
            tableView.rowHeight = UITableView.automaticDimension
            
        }
    }
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var pushDelegate:PushFromPrsentedScreen?
    var previousViewController:UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initConfiguration()
        handleObservation()
        setFileDetails()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    private func initConfiguration() {
//
//        viewModel = FileActionsViewModel(router: item.router,currentRouter: CerqelRouterManagerImpl(self) ,file: item.file,delgate: item.delegate!,fileViewer: FileViewerManager( item.router))
//        viewModel.allFileActions()
//        viewModel.setDesiredFileActions()
//        closeBtn.tintColor = primaryMain
        
    }
    
    private func setFileDetails() {
        fileName.text = (item.file.title ) + ".\(item.file.fileExtension)"
        self.fileImage.image = setFileImage(item.file.fileType)
        
    }
    
    
    private func setFileImage(_ fileType: FileType) -> UIImage{
        switch fileType {
        case .pdf: return UIImage(named: "pdf") ?? UIImage()
        case .doc : return UIImage(named: "docx")  ?? UIImage()
        case .ppt : return UIImage(named: "ppt")  ?? UIImage()
        case .docx:  return UIImage(named: "docx")  ?? UIImage()
        case .pptx:  return UIImage(named: "ppt")  ?? UIImage()
        case .xls: return UIImage(named: "xls")  ?? UIImage()
        case .xlsx:  return UIImage(named: "xls")  ?? UIImage()
        default: return UIImage(named: "pdf") ?? UIImage()
        }
    }
    
    private func handleObservation() {
        viewModel.actions.bind{_ in
            self.tableView.reloadData()
            
        }
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override var longFormHeight: PanModalHeight {
        return .contentHeight(tableView.contentSize.height + 80)
    }
    
    override var panScrollable: UIScrollView? {
        return tableView
    }
    
}
extension FileActionsView: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actions.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = viewModel.actions.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: fileActionCellIdintifier) as! FileActionCell
        cell.configure(action,isVisible: nil,canDeleteImage: nil)
        if indexPath.row == viewModel.actions.value.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action : FileActions = viewModel.actions.value[indexPath.row]
        viewModel.push(fileId: item.file.id, actionId: action.id)

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let action : FileActions = viewModel.actions.value[indexPath.row]
        if action.id == 6 {
            return  viewModel.file.fileAcknowledgeStatus.isAcknowledge && !viewModel.file.fileAcknowledgeStatus.isAcknowledged ? true : false
            
        }
        else {
            // Enable all other cells
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
}

