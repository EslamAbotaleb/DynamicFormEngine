//
//  ReportVC.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
public import PanModal

public class FileItem : BaseItem {
    public var fileId: String
    
    public init (fileId: String) {
        self.fileId = fileId
    }
}

public class ReportView: BaseView<ReportViewModel, FileItem> {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.registerCell(cellType: RadioButtonTVCell.self)
            self.tableView.registerHaederFooterCell(viewType: ReportFooterTVCell.self)
        }
    }
    private let refreshControl = UIRefreshControl()

    override public func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        configUI()
        initRefreshController()
        handleObservation()
        setNavigationTitle( "Report File".localized)
        setupBackButton()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
   
    private func initialConfiguration(){
        viewModel = ReportViewModel(router: CerqelRouterManagerDynamicFormImpl(self), fileId: item.fileId)
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
