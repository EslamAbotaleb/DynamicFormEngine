//
//  AllServicesViewController.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Foundation
import PanModal

public class AllServicesViewController: BaseView<AllServicesViewModel, NewServiceFilterItem>  {
    
    let serviceCellIdintifier = String(describing: AllServicesCell.self)
    let serviceGridCellIdintifier = String(describing: AllServicesCollectionViewCell.self)
    
    private let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var selectionModeImage: UIImageView!
    @IBOutlet weak var sortApplied: UIImageView!
    @IBOutlet weak var selectedServicesCount: UILabel!
    @IBOutlet weak var servicesSelectStackView: UIView!
    @IBOutlet weak var servicesActionStackView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var allServicesCount: UILabel!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var gridIcon: UIImageView!
    @IBOutlet weak var listModeView: UIStackView!
    @IBOutlet weak var listModeseprator: UIView!
    @IBOutlet weak var layoutBorder: UIStackView!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var headerView: CerqelReusableHeader!
    
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!{
        didSet{
            self.servicesCollectionView.delegate = self
            self.servicesCollectionView.dataSource = self
            self.servicesCollectionView.registerCell(idintifier: serviceCellIdintifier)
            self.servicesCollectionView.registerCell(idintifier: serviceGridCellIdintifier)
        }
    }
    
    deinit {
        removerObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        configureHeaderAction()
        initRefreshController()
        configureUI()
        handleObservation()
        setupHeaderView()
        viewModel.getServices()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.checkFileLayout()
        switch self.item.serviceFrom {
        case .favorites:
            self.allServicesCount.text = "Showing".localized 
            viewModel.reloadAllServices()
            
        default: break
        }
        viewModel.checkForfilterPreviousView()
        self.sortApplied.isHidden = SubCategoryServiceView.shared.filterStatus == nil
        viewModel.selectedSort.value = SubCategoryServiceView.shared.filterStatus ?? "Alphabetical A-Z"
       
    }
    

    private func initialConfiguration(){
        viewModel = AllServicesViewModel(serviceItem: item, router: CerqelRouterManagerImpl(self), allServiceUseCase: AllServicesUseCaseImpl())
    }
    
   
    private func removerObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func setupHeaderView() {
        self.headerView.isHidden = item.serviceFrom != .allServices && item.serviceFrom != .homeFavorites
        self.headerView.buttonsView.isHidden = true
        self.headerView.disableSearch()
    }
    
    private func configureUI() {
        self.allServicesCount.font = UIFont.bodyLRegular()
        self.allServicesCount.textColor = typographyTitle
        cancelBtn.setTitleColor(.links, for: .normal)
        listIcon.tintColor = primaryMain
        gridIcon.tintColor = primaryMain
        layoutBorder.borderColorV = primaryMain
        sortBtn.tintColor = primaryMain
        sortApplied.tintColor = UIColor.error_Cerqel
        sortView.borderColorV = primaryMain
        listModeseprator.backgroundColor = primaryMain
        self.bgV.backgroundColor = bg
        self.item.serviceFrom == .favorites || self.item.serviceFrom == .homeFavorites  ?  setNavigationTitle("Favorites".localized) :  setNavigationTitle("All Services".localized)
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
     
        viewModel.servicesList.bind{ list in
            self.refreshControl.endRefreshing()
            self.servicesCollectionView.removeNoDataPlaceholder()
            if list.services.count == 0  {
                switch self.item.serviceFrom {
                case .favorites :
                    self.servicesCollectionView.setNoDataPlaceholder(title: "No Services Yet!".localized, message: "", messageImage: UIImage(named: "empty_services") ?? UIImage(), showImage: true)
                default: self.servicesCollectionView.setNoDataPlaceholder(title: "No Services Yet!".localized, message: "", messageImage: UIImage(named: "empty_services") ?? UIImage(), showImage: true)
                }
                
            }
            self.servicesActionStackView.isHidden = list.services.isEmpty

            self.servicesCollectionView.reloadData()
            guard self.viewModel.pullToRefresh.value && !list.services.isEmpty  else {
                return
            }
            self.servicesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            
        }
        viewModel.serviceLayout.bind { layout in
            self.listView.backgroundColor = layout == .defaultLayout ? primaryLight : .white
            self.gridView.backgroundColor = layout == .gridLayout ? primaryLight : .white
            self.servicesCollectionView.reloadData()
        }
        viewModel.allServicesCount.bind{ servicesCount in
            self.allServicesCount.text = "Showing".localized  + " (\(servicesCount))"
        }
    }
    
    private func initRefreshController() {
        if #available(iOS 10.0, *) {
            servicesCollectionView.refreshControl = refreshControl
        } else {
            servicesCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    
    private func handleSortAction() {
        CerqelBaseSortVC.presentSheet(sortData: viewModel.initialSortData.value, sortType: .radioBtnTV, sortSelectedName: viewModel.selectedSort.value, sortTitle: "Sort By".localized, selectedAction: { [weak self] selectedSort in
            
            self?.viewModel.selectedSort.value = selectedSort
            self?.viewModel.handleSortPayload()
            if self?.item.serviceFrom == .subCategory {
                SubCategoryServiceView.shared.filterStatus = selectedSort
            }
            self?.sortApplied.isHidden = false
        }, from: self)
    }
    
    @objc private func pullToRefresh(_ sender: Any) {
        viewModel.reloadAllServices()
    }
    
}

//MARK: - Actions
extension AllServicesViewController {
    
    @IBAction func ServicesGridLayout(_ sender: Any) {
        viewModel.handleFileLayout(.gridLayout)
        
    }
    
    @IBAction func servicesDefaultLayout(_ sender: Any) {
        viewModel.handleFileLayout(.defaultLayout)
    }

    @IBAction func sort(_ sender: Any) {
        handleSortAction()
    }
}


extension AllServicesViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch item.serviceFrom {
        case .subCategory : return IndicatorInfo(title: item.subcategory?.name ?? "")
        case .favorites : return IndicatorInfo(title: "Favorites".localized )
        default: break
        }
        return IndicatorInfo(title: item.subcategory?.name ?? "")
        
        
    }
    
    
}



//MARK:- Colection Delegate
extension AllServicesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  viewModel.servicesList.value.services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        let service = viewModel.servicesList.value.services[indexPath.row]
        switch viewModel.serviceLayout.value  {
        case .defaultLayout :
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: serviceCellIdintifier, for: indexPath) as! AllServicesCell
            (cell as!AllServicesCell).configure(service)
            (cell as!AllServicesCell).didTapFavBtn = {
                    self.viewModel.handleFavAction(index: indexPath.row)
            }
            (cell as!AllServicesCell).sepratorView.isHidden = indexPath.row == viewModel.servicesList.value.services.count - 1
           
        case .gridLayout :
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: serviceGridCellIdintifier, for: indexPath) as! AllServicesCollectionViewCell
            (cell as!AllServicesCollectionViewCell).configure(service)
            (cell as!AllServicesCollectionViewCell).didTapFavBtn = { _,_ in
                self.viewModel.handleFavAction(index: indexPath.row)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let service = viewModel.servicesList.value.services[indexPath.row]
        self.navigationController?.pushViewController(DynamicSharedRouterDynamicForm.goTo(viewName: .formViewController(serviceId: service.id!, actionId: nil, buttonId: nil, requestId: "")), animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        switch viewModel.serviceLayout.value {
        case .defaultLayout :
            return CGSize(width: collectionWidth, height: 94)
        case .gridLayout :
            return CGSize(width: collectionWidth/2 - 8 , height: 200)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch viewModel.serviceLayout.value  {
        case .defaultLayout :
            return 0
        case .gridLayout :
            return 15
        }
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height + 1
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if distanceFromBottom < height {
            guard viewModel.currentPages.value < viewModel.totalPages.value else { return }
            self.viewModel.loadNextServices()
        }

    }
    
}

