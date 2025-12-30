//
//  SubCategoryServiceView.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class NewServiceFilterItem: BaseItem {
    
    var serviceFrom: ServiceDestination
    var displayName: String?
    var subcategory: GetAllCategoriesDTO?
    
    init(serviceFrom: ServiceDestination,displayName: String = "",subcategory: GetAllCategoriesDTO = GetAllCategoriesDTO() ) {
        self.serviceFrom = serviceFrom
        self.displayName = displayName
        self.subcategory = subcategory
        
    }
    
    override init() {
        self.serviceFrom = .allServices
        self.displayName = ""
        self.subcategory = GetAllCategoriesDTO()
    }

}


enum ServiceDestination: String {
    case subCategory
    case allServices
    case favorites
    case homeFavorites
}

class SubCategoryServiceView: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var headerView: CerqelReusableHeader!

    static var shared : SubCategoryServiceView = SubCategoryServiceView()

    var subCategoryIndex : Int = 0
    var filterStatus : String?
    var fileLayout: FileViewLayout?
    var categoriesLoaded : Bool = false
    var tabsItemViewController: [UIViewController] = []
    var category : GetAllCategoriesEntity = GetAllCategoriesEntity()
    var subCategoriesList : [GetAllCategoriesDTO] = []
    var viewModel: SubCategoryServiceViewModel!

    override func viewDidLoad() {
        setupHeaderView()
        configureHeaderV()
        initTabsStyle()
        updateSelectedHeaderItem()
        handleButtonBarLayout()
        initialConfiguration()
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !categoriesLoaded && subCategoryIndex != 0 else {
            return
        }
        scrollToTab(index: subCategoryIndex )
    }
    
    private func initialConfiguration(){
        viewModel =  SubCategoryServiceViewModel(router: CerqelRouterManagerImpl(self))
        viewModel.categoryId = category.id
        
    }
    
    private func setupHeaderView() {
       self.headerView.buttonsView.isHidden = true
        self.headerView.disableSearch()
        setNavigationTitle(category.name)
        setupBackButton()
    }
    
    private func configureHeaderV() {
        headerView.didSearchNewViewButton = { [weak self] in
            guard let self = self else { return }
           self.viewModel.routeToSearch()
        }
        
        headerView.didTapFilterButton = { [weak self] in
            guard let self = self else { return }
            self.viewModel.routeToFilter()

        }

    }
    
    private func setInstance() {
        SubCategoryServiceView.shared = SubCategoryServiceView()
    }
    
    private func scrollToTab(index: Int) {
        categoriesLoaded = true
        self.moveToViewController(at: index, animated: false)
        if let cell = self.buttonBarView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ButtonBarViewCell {
            cell.label.textColor = UIColor.black.withAlphaComponent(0.40)
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        tabsItemViewController = subCategoriesList.map({ (subCategory) -> UIViewController in
            let filesList = CerqelView.controller(controller: AllServicesViewController.self, viewModel: AllServicesViewModel.self, item: NewServiceFilterItem(serviceFrom: .subCategory,subcategory: subCategory))
            return  filesList
            
        })
        return tabsItemViewController
    }
    
    func setSharedValue(_ value: String) -> String{
        return value
    }
    
    
}

// Ui Configuration
extension SubCategoryServiceView {
    
    private func initTabsStyle() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = primaryMain
        settings.style.buttonBarItemFont = UIFont.bodyLMedium()
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = false
        settings.style.buttonBarItemLeftRightMargin = 10
        self.containerView.isScrollEnabled = false
        bgV.backgroundColor = bg
        
    }
    
    private func updateSelectedHeaderItem() {
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else { return }
            
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = primaryMain
            
        }
        
    }
    
    private func handleButtonBarLayout() {
        let layout = RTLCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        self.buttonBarView.collectionViewLayout = layout
    }
    
    private func setupBackButton() {
        let titleLabel = UILabel()
        titleLabel.text = "Back".localized
        titleLabel.textColor = typographyTitle
        let button = UIButton(type: .custom)
        if isArabicCerqel() {
            button.heightAnchor.constraint(equalToConstant: 15).isActive = true
            titleLabel.font = UIFont.bodyLRegular()
        } else {
            titleLabel.font = UIFont.bodyLRegular()
        }
        button.setImage(.init(named: "back1"), for: .normal)
        button.tintColor = typographyTitle
        if isArabicCerqel() { button.transform = .init(scaleX: -1, y: 1) }
        let stackview = UIStackView.init(arrangedSubviews: [button, titleLabel])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        if isArabicCerqel() {
            stackview.alignment = .lastBaseline
            stackview.spacing = 5
        } else {
            stackview.alignment = .center
            stackview.spacing = 5
        }
        stackview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        let leftBarButtonItem = UIBarButtonItem(customView: stackview)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
