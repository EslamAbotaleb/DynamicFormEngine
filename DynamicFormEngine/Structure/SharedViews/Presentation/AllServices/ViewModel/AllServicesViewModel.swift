//
//  AllServicesViewModel.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 27/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

class AllServicesViewModel: BaseVM {
    
    // Dependencies
    private var userAuthoriationHandler: AuthorizationHandler = UserAuthoriationHandler()
    private var router: CerqelRouterManager
    private var localNotification: LocalNotificationProtocol!
    private var localData: LocalData
    private var allServiceUseCase: AllServicesUseCase
    static var fiterPreviousView: PreviousView = .service
    var servicesList: DynamicObjects<AllServicesDataEntity> = DynamicObjects(AllServicesDataEntity())
    var serviceLayout: DynamicObjects<FileViewLayout> = DynamicObjects(.defaultLayout)
    var pullToRefresh: DynamicObjects<Bool> = DynamicObjects(false)
    var currentPages: DynamicObjects<Int> = DynamicObjects(1)
    var totalPages: DynamicObjects<Int> = DynamicObjects(1)
    var allServicesCount: DynamicObjects<Int> = DynamicObjects(0)
    var isSortApplied: DynamicObjects<Bool> = DynamicObjects( false)
    var selectedSort: DynamicObjects<String> = DynamicObjects( "Alphabetical A-Z")
    var serviceItem: DynamicObjects<NewServiceFilterItem> = DynamicObjects(NewServiceFilterItem())
    var sortRequestModel: DynamicObjects<[OrderByValue]> = DynamicObjects( [])
    var fiterPreviousView: PreviousView = .service
    var initialSortData: DynamicObjects<[sortModelCerqel]> = DynamicObjects( [])
    var filterModel: CerqelFilterCallBack? = CerqelFilterCallBack()
    var cerqelFilterPayload: CerqelFilterPayload!
    var filterViewModel: FilterViewModel =  FilterViewModel()
    var currentCategoryId: DynamicObjects<String> = DynamicObjects("")
    var payload = CerqelFilterPayload()

    
    init(serviceItem: NewServiceFilterItem, localData: LocalData = LocalDataImpl(), router: CerqelRouterManager, allServiceUseCase: AllServicesUseCase ) {
        self.serviceItem.value = serviceItem
        self.localData = localData
        self.router = router
        self.allServiceUseCase = allServiceUseCase
    }
    
    override func hydrate() {
        setupDepencies()
        setSortData()
    }
    
    private func setupDepencies() {
        
        self.localNotification = LocalNotificationManager.shared
    }
    
    
    // initial
    

    func setSortData() {
        initialSortData.value = [sortModelCerqel(sortName: "Alphabetical A-Z"), sortModelCerqel(sortName: "Alphabetical Z-A")]
        sortRequestModel.value =  [OrderByValue(colID: "name", sort: "asc")]
    }
    
    func handleSortPayload() {
        switch selectedSort.value {
        case  "Alphabetical A-Z":
            sortRequestModel.value =  [OrderByValue(colID: "name", sort: "asc")]
        case  "Alphabetical Z-A":
            sortRequestModel.value =  [OrderByValue(colID: "name", sort: "desc")]
        default: break
        }
        reloadAllServices()
    }
    
    // routes
    func popBack() {
        router.popBack()
    }
    
    func dismiss() {
        router.dismiss()
    }


    func routeToFilter() {
        router.presentFullScreen(controller: FilterView.self, viewModel: FilterViewModel.self, item:
                                    FilterItem(categoryId:self.filterModel?.categoryId,fromView: AllServicesViewModel.fiterPreviousView, sections: [
                                        CerqelFilterSection(id: 1, sectionTitle: "By Category".localized, sectionType: .categories(.multi),filterCategoriesType: .categories, endPoint: .categories)

                                    ],
                                               filterItem: filterModel!, repo: ServicesRepoImpl(), filterModelCallBack: filterModelCallBack
                                              ))

    }

    func filterModelCallBack(filterModel: CerqelFilterCallBack) {


    }
    

    func routeToSearch() {
        router.presentFullScreen(controller: SearchView.self, viewModel: FilterViewModel.self, item: SearchItem(fromView: AllServicesViewModel.fiterPreviousView, filterModelCallBack: filterModelCallBack ))
    }


    func  successBottomSheet() {
        router.presentbottomSheet(fromProfile: false, controller: SuccessBottomSheetViewController.self, viewModel: FileActionsViewModel.self, item: BaseItem())
    }

    
    func routeToReport(fileId: String) {
        router.pushTo(controller: ReportView.self, viewModel: ReportViewModel.self, item: FileItem(fileId: fileId))
    }
    func routeToAcknowledge(fileId: String) {
        router.pushTo(controller: AcknowledgeVC.self, viewModel: AcknowledgeViewModel.self, item: FileItem(fileId: fileId))
    }
    
    // actions
    func handleFileLayout (_ fileLayout: FileViewLayout) {
        self.serviceLayout.value = fileLayout
        SubCategoriesBaseView.shared.fileLayout = fileLayout
    }

    
    func checkFileLayout () {
        let layout =  SubCategoriesBaseView.shared.fileLayout
        serviceLayout.value = layout ?? .defaultLayout
    }

    
    func reloadAllServices() {
        pullToRefresh.value = true
        currentPages.value = 1
        totalPages.value = 1
        getServices()
    }
    
    func loadNextServices() {
        currentPages.value += 1
        getServices()
    }
    



    func  checkForfilterPreviousView(){
        switch serviceItem.value.serviceFrom {
        case .allServices :
            AllServicesViewModel.fiterPreviousView = .service
        case .subCategory :
            AllServicesViewModel.fiterPreviousView = .service
        case .favorites,.homeFavorites :
            AllServicesViewModel.fiterPreviousView = .favourite

        }
    }
    
    func getServices() {
        switch serviceItem.value.serviceFrom {
        case .allServices:
            payload = CerqelFilterPayload(pageNumber: currentPages.value, pageSize: 10, orderByValue: sortRequestModel.value)
            servicesEndPoint(payloadFilter: payload)
        case .subCategory:
            payload = CerqelFilterPayload(pageNumber: currentPages.value, pageSize: 10, filter: Filter(subCategoryID: [serviceItem.value.subcategory?.id ?? ""]), orderByValue: sortRequestModel.value)
            servicesEndPoint(payloadFilter: payload)
        case .favorites, .homeFavorites:
            payload = CerqelFilterPayload(pageNumber: currentPages.value, pageSize: 10, filter: Filter(isFavorite: true), orderByValue: sortRequestModel.value)
            servicesEndPoint(payloadFilter: payload)

        }
    }
    


    func setNextServicesFromPagination(service: AllServicesDataEntity){
        guard  currentPages.value != 1  else {
            self.servicesList.value = service
            return
        }
        servicesList.value.services.append(contentsOf: service.services)
    }

    func handleFavAction( index: Int) {
        let serviceId =  self.servicesList.value.services[index].id!
        let isFav = self.servicesList.value.services[index].isFavorite ?? false
        switch serviceItem.value.serviceFrom {
        case .favorites :
            self.servicesList.value.services.remove(at: index)
            guard allServicesCount.value > 0 else {return}
            var favCount = self.allServicesCount.value
            self.allServicesCount.value = favCount - 1
        default:
            self.servicesList.value.services[index].isFavorite?.toggle()
        }
        self.addRemoveServiceToFav(id: serviceId, isFav: isFav)
    }

    // endPoint

    func servicesEndPoint(payloadFilter: CerqelFilterPayload) {
        pullToRefresh.value || (currentPages.value > 1) ? self.hideLoadingCerqel(): self.showLoadingCerqel()
        payload.pageNumber = currentPages.value
        payload.pageSize = 10
        payload.orderByValue = sortRequestModel.value
        if payload.filter == nil {
            payload.filter = Filter()
            payload.filter?.categoryId = currentCategoryId.value != "" ? currentCategoryId.value : nil
            payload.filter?.isActive = true
        } else {
            payload.filter?.categoryId = currentCategoryId.value != "" ? currentCategoryId.value : nil
            payload.filter?.isActive = true
        }
        
        allServiceUseCase.execute(payload: payload).then { (response) in
            let allService = response.result.data
            self.allServicesCount.value = response.result.totalCount ?? 0
            self.setNextServicesFromPagination(service: allService)
            self.totalPages.value = response.result.pagesCount ?? 1
        }.catch { (error) in
            self.showSystemError(error: error)
        }.always {
            self.hideLoadingCerqel()
            self.pullToRefresh.value = false
        }

    }


    func addRemoveServiceToFav(id: String,isFav: Bool) {
        let  addToFavouritePayload = AddToFavouritePayload(serviceId: id, isFavorite: !isFav)
        allServiceUseCase.addRemoveServicesFav(addToFavouritePayload: addToFavouritePayload).then { _ in

        }.catch { (error) in
            self.showSystemError(error: error)
        }
    }
    
}
