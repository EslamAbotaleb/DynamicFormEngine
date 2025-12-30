//
//  FileActions.swift
//  CERQEL
//
//  Created by ahmed maher on 13/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
public import PanModal

public protocol PushFromPrsentedScreen {
    func push(fileId: String, actionId : Int)
    func push( actionId : Int)
}
extension PushFromPrsentedScreen {
    public func push(fileId: String, actionId : Int) {
        
    }
    public func push( actionId : Int){
        
    }
}

public protocol ActionsProtocol {
    func handleFileAction(fileId: String, actionId : Int)
}

public class FileActionItem: BaseItem {
    public var file: FileModel
    public var router:CerqelRouterManager
    public var delegate:ActionsProtocol?
    
    public init(file: FileModel,router:CerqelRouterManager,delegate: ActionsProtocol ) {
        self.file = file
        self.router = router
        self.delegate = delegate
    }
}

public class FileActionsView: BaseView<FileActionsViewModel, FileActionItem> {
    
    public let fileActionCellIdintifier = String(describing: FileActionCell.self)
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            self.tableView.register(UINib(nibName: fileActionCellIdintifier, bundle: Bundle(for: type(of: self))),
                                    forCellReuseIdentifier: fileActionCellIdintifier)

            tableView.estimatedRowHeight = 50.0
            tableView.rowHeight = UITableView.automaticDimension
            
        }
    }
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    
    public var pushDelegate:PushFromPrsentedScreen?
    public var previousViewController:UIViewController?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initConfiguration()
        handleObservation()
        setFileDetails()
        
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    private func initConfiguration() {
//
        viewModel = FileActionsViewModel(router: item.router,currentRouter: CerqelRouterManagerDynamicFormImpl(self) ,file: item.file,delegate: item.delegate!,fileViewer: FileViewerManager(item.router))
        viewModel.allFileActions()
        viewModel.setDesiredFileActions()
        closeBtn.tintColor = primaryMain
        
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
    
    override public var longFormHeight: PanModalHeight {
        return .contentHeight(tableView.contentSize.height + 80)
    }
    
    override public var panScrollable: UIScrollView? {
        return tableView
    }
    
}
extension FileActionsView: UITableViewDataSource, UITableViewDelegate {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.actions.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = viewModel.actions.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: fileActionCellIdintifier) as! FileActionCell
        cell.configure(action,isVisible: nil,canDeleteImage: nil)
        if indexPath.row == viewModel.actions.value.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        }
        cell.selectionStyle = .none
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action : FileActions = viewModel.actions.value[indexPath.row]
        viewModel.push(fileId: item.file.id, actionId: action.id)

    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let action : FileActions = viewModel.actions.value[indexPath.row]
        if action.id == 6 {
            return  viewModel.file.fileAcknowledgeStatus.isAcknowledge && !viewModel.file.fileAcknowledgeStatus.isAcknowledged ? true : false
            
        }
        else {
            // Enable all other cells
            return true
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
}

