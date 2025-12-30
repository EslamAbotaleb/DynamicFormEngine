//
//  SubCategoryServiceViewModel.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation

public enum SelectionMode {
    case appear
    case hidden
}

public enum PreviousView {
    case document
    case faq
    case knowledgeBase
    case service
    case documentSearchResult
    case serviceSearchResults
    case faqSearchResults
    case knowledgeBaseSearchResults
    case recent
    case pinned
    case favourite
    case globalSearch
    case globalSearchResults
    case employee
    case employeeSearchResults
}

public enum FileDestination: String {
    case subCategory
    case allFiles
    case globalSearch
    case recent = "Recent"
    case pinned = "Pinned"
}

class ServiceFilterItem: BaseItem {
    var fileFrom:FileDestination
    var displayName: String?
    var subcategory: GetAllCategoriesDTO?
    var isPinned: Bool?
    
    init(fileFrom: FileDestination,displayName: String = "",subcategory: GetAllCategoriesDTO = GetAllCategoriesDTO() ) {
        self.fileFrom = fileFrom
        self.displayName = displayName
        self.subcategory = subcategory
        
    }
    
    override init() {
        self.fileFrom = .allFiles
        self.displayName = ""
        self.subcategory = GetAllCategoriesDTO()
        self.isPinned = false
    }

}


class SubCategoryServiceViewModel: BaseVM {
    
    // Dependencies
    
    var filterModel: CerqelFilterCallBack? = CerqelFilterCallBack()
    var categoryId: String = ""
    private var router:CerqelRouterManager
    
    init( router: CerqelRouterManager) {
        self.router = router
    }
    
    override func hydrate() {
        
    }
    
    func routeToAllServices(){
        router.pushTo(controller: AllServicesViewController.self, viewModel: AllServicesViewModel.self, item: NewServiceFilterItem(serviceFrom: .allServices))
    }
    

    
    func routeToSearch(){
        router.presentFullScreen(controller: SearchView.self, viewModel: FilterViewModel.self, item: SearchItem(fromView: .service,categoryId: categoryId, filterModelCallBack: filterModelCallBack ))
    }
    
    
    func routeToFilter(){
        router.presentFullScreen(controller: FilterView.self, viewModel: FilterViewModel.self, item:
                                    FilterItem(categoryId:self.filterModel?.categoryId,fromView:.service, sections: [
                            CerqelFilterSection(id: 1, sectionTitle: "By Sub-Category".localized, sectionType: .categories(.single),filterCategoriesType: .subCategories, endPoint: .subCategories(categoryId: categoryId)
                                               ),
                        ],
                                    filterItem: filterModel!, repo: ServicesRepoImpl(),filterModelCallBack: filterModelCallBack
                                  ))


    }
    
    func filterModelCallBack(filterModel:CerqelFilterCallBack){

    
    }
  
 
}
