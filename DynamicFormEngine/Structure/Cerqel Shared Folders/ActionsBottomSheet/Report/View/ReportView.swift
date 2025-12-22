//
//  ReportVC.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import PanModal

class FileItem : BaseItem {
    var fileId: String
    
    init (fileId: String) {
        self.fileId = fileId
    }
}

class ReportView: BaseView<ReportViewModel, FileItem> {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.registerCell(idintifier: RadioButtonTVCell.cerqel_identifier)
            self.tableView.registerHaederFooterCell(idintifier: "ReportFooterTVCell")
        }
    }
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        configUI()
        initRefreshController()
        handleObservation()
        setNavigationTitle( "Report File".localized)
        setupBackButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

    }
   
    
    private func initialConfiguration(){
        viewModel = ReportViewModel(router: CerqelRouterManagerImpl(self), fileId: item.fileId)
        viewModel.reportListEndPoint()
        
    }
    
    private func configUI(){
        sendButton.setSubmitButtonTheme()
        cancelButton.setCancelButtonTheme()
        self.sendButton.setUnActiveButton()
    }
    
    private func handleObservation() {
      
        viewModel.reportList.bind{ list in
            self.refreshControl.endRefreshing()
            self.tableView.removeNoDataPlaceholder()
            if list.count == 0  {
                self.tableView.setNoDataPlaceholder()
            }
            self.tableView.reloadData()
        }
        
        viewModel.selectedItemId.bind{ selectedItemId in
            guard  selectedItemId != self.viewModel.reportList.value.last?.id else {
                self.viewModel.otherReason.value != "" ? self.sendButton.setActiveButton() :  self.sendButton.setUnActiveButton()
                return
            }     
            selectedItemId != "" ? self.sendButton.setActiveButton() :  self.sendButton.setUnActiveButton()

        }
        
        viewModel.otherReason.bind{ otherReason in
            otherReason != "" ? self.sendButton.setActiveButton() :  self.sendButton.setUnActiveButton()
        }
        
    }
    
    private func initRefreshController() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    
    @objc private func pullToRefresh(_ sender: Any) {
        viewModel.pullToRefresh.value = true
        viewModel.reportListEndPoint()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        viewModel.popBack()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        viewModel.sendReportEndPoint()

    }
    
}
