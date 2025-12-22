//
//  NewHomeViewModel.swift
//  CERQEL
//
//  Created by Hassan elshair on 14/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

enum homeItems {
    case statistics
    case tasks
    case requests
    case services
    case favorites
    case calendarList
    case events
    case news
    case offers
    case aboutCompany
    case announcements
    case mediaLibrary
    case documentLibrary
}

class NewHomeViewModel: BaseVM,LocationManagerDelegate {

    private let service: cerqel_NetworkService
    private let disposeBag = DisposeBag()
    var router:CerqelRouterManager = CerqelRouterManagerImpl()
    var delegate: ActionsProtocol!

    var arrayOHomeItems: [homeItems] = [.statistics,.favorites,.calendarList,.events,.news,.offers, .announcements,.mediaLibrary, .documentLibrary]

    var requestsArray: DynamicObjects<[StatusDtoCerqel]?> = DynamicObjects([])
    var inboxArray: DynamicObjects<[StatusDtoCerqel]?> = DynamicObjects([])
    var announcementList: DynamicObjects<[ModelAnnouncementDataCerqel]?> = DynamicObjects([])
    var newsList: DynamicObjects<[ModelNewsDataCerqel]?> = DynamicObjects([])
    var internalNewsList: DynamicObjects<[ModelInternalNewsDataCerqel]?> = DynamicObjects([])
    var taskStatistics: DynamicObjects<[tasksStatisticsResultCerqel]?> = DynamicObjects([])
    var requestsStatistics: DynamicObjects<[tasksStatisticsResultCerqel]?> = DynamicObjects([])
    var offerList: DynamicObjects<[ModelOfferDataCerqel]?> = DynamicObjects([])
    var favServiceList: DynamicObjects<[ModelServicesCerqel]?> = DynamicObjects([])
    var recentServicesList: DynamicObjects<[ModelServicesCerqel]?> = DynamicObjects([])

    var eventsItemsList: DynamicObjects<[EventResponseDataCerqel]?> = DynamicObjects([])
    var calendarHomeList: DynamicObjects<[ModelCalendarHomeDataCerqel]?> = DynamicObjects([])
    var serviceFavStatusChanged: DynamicObjects<Bool> = DynamicObjects(false)
    var vipUpdatedFromAdmin: DynamicObjects<Bool> = DynamicObjects(false)
    var filesList : DynamicObjects<[FileModel]?> = DynamicObjects( [])
    var homeWidgetsList : DynamicObjects<[VipHomeEntity]?> = DynamicObjects( [])
    var homeDataSource : DynamicObjects<[HomeDataSource]?> = DynamicObjects( [])
    var homeDataSourceCopy : DynamicObjects<[HomeDataSource]?> = DynamicObjects( [])
    var typeOffReques: String = "Leaves"
    var pageNumber = 1
    var pageSize = 10
    var totalCount = -1
    var selectedNewsId: String?
    var isShowWidget:Bool = false

    var announcmentPayload = BasePayloadCerqel(pageNumber: 0, pageSize: 0, filterr: FilterCerqel(), orderByValuee: [OrderByValueCerqel(colID: "DateModified", sort: "desc")])
    var eventsPayload = BasePayloadCerqel(pageNumber: 0, pageSize: 0, filterr: FilterCerqel(), orderByValuee: [OrderByValueCerqel(colID: "StartTime", sort: "asc")])
    var newsPayload = BasePayloadCerqel(pageNumber: nil, pageSize: nil, filterr: FilterCerqel(), orderByValuee: [.init()])
    var offersPayload = DealsPromotionsSubmitModelCerqel(pageNumber: nil, pageSize: nil, filterr: DealPromotionFilterCerqel(), orderByValuee: [.init(colID: "ModifiedDate", sort: "desc")])
    var mediaPayload = BasePayloadCerqel(pageNumber: nil, pageSize: nil, filterr: FilterCerqel(), orderByValuee: [.init(colID: "ModifiedDate", sort: "desc")])

    var isAnnounceAddedToFav: DynamicObjects<Bool> = DynamicObjects(false)
    var mediaList : DynamicObjects<[MediaResponseDatumCerqel]?> = DynamicObjects( [])
    var payload: MediaSubmitModelCerqel?
    var totalDataCount = 0
    var unopenedNotificationCount: DynamicObjects<Int?> = DynamicObjects(0)
    var isEventAdded: DynamicObjects<Bool> = DynamicObjects(false)
    private var documentRepo: DocumentLibraryRepo
    var prayerDataEntity: BehaviorRelay<PrayerDataEntity?> = BehaviorRelay(value: nil)
    var weatherDetailsEntity : BehaviorRelay<WeatherDetailsEntity?> = BehaviorRelay(value: nil)
    var weatherDetailsPayload = GetWeatherPayload(Lat: nil, Lon: nil, TempUnit: 1)
    var tempUnit : String = LocalStorageManager.getData(key: DefaultsKeys.tempretureUnit) ?? "ºC"
    var addedToCalendarTitle: String?
    @Published var locationCoordinate:CLLocationCoordinate2D = (CLLocationCoordinate2D(latitude: 0, longitude: 0))
    @Published var locationStatus : CLAuthorizationStatus = .notDetermined
    @Published var address = ""
    @Published var lat : Double = 0
    @Published var long : Double = 0
    @Published var nonAuthorizedStatus : Bool = false


    private var weatherDetailsUseCase = WeatherDetailsUseCaseImpl()
    private var prayersUseCase = PrayersUseCaseImpl()
    private var vipHomeUseCase: VipHomeUseCase
    var locationManager: LocationManagerProtocol!

    var appState: AppState = .initial
    init(_ service: cerqel_NetworkService) {
        self.service = service
        self.documentRepo = DocumentLibraryRepoImpl()
        self.vipHomeUseCase = VipHomeUseCaseImp()
        super.init()
        self.getLocationData()
    }

    func getVipHomeListEndPoint() {
        self.showLoadingCerqel()
        vipHomeUseCase.getVipHomeListV2().then { (response) in
            self.homeWidgetsList.value = response.1
            self.vipUpdatedFromAdmin.value = response.0.updatedByAdmin ?? false
            self.mapHomeDataSourse()
            self.homeDataSourseAction()
            self.hideLoadingCerqel()
        }.catch { (error) in
            self.hideLoadingCerqel()
            self.isLoading.value = false
            self.showSystemError(error: error)
        }
            .always {
                self.hideLoadingCerqel()
                self.isLoading.value = false
            }
    }

    func mapHomeDataSourse(){
        self.homeDataSource.value = self.homeWidgetsList.value?.map({ widget in
            switch widget.widgetId {
            case "RecentMedia" :  return HomeDataSource(type: .mediaLibrary, isVisible: widget.isVisible, endPoint: self.fetchMediaList)
            case "RecentDocuments" :  return HomeDataSource(type: .documentLibrary, isVisible: widget.isVisible, endPoint: self.fetchRecentDocument)
            case "RecentServices" :  return HomeDataSource(type: .services, isVisible: widget.isVisible, endPoint: self.fetchRecentServiceList)
            case "FavoriteServices" :  return HomeDataSource(type: .favorites,  isVisible: widget.isVisible , endPoint: self.fetchFavServiceList)
//            case "MyCalendar" :  return HomeDataSource(type: .calendarList, isVisible: widget.isVisible, endPoint: self.fetchCalendarHomeList)
            case "ActiveEvents" :  return HomeDataSource(type: .events, isVisible: widget.isVisible, endPoint: self.fetchEventsList)
            case "LatestNews" :  return HomeDataSource(type: .news, isVisible: widget.isVisible, endPoint: self.fetchNewsList)
            case "Offers" :  return HomeDataSource(type: .offers, isVisible: widget.isVisible, endPoint: self.fetchOffersList)
            case "LatestAnnouncement" :  return HomeDataSource(type: .announcements, isVisible: widget.isVisible, endPoint: self.fetchAnnouncementList)
            default: break
            }
            return HomeDataSource(type: .statistics, isVisible: false, endPoint: self.fetchNewsList)
        })

    }

    func homeDataSourseAction(){
        self.homeDataSource.value = self.homeDataSource.value?.filter{$0.isVisible == true}
        self.homeDataSourceCopy.value = self.homeDataSource.value
        fetchHomeEndpoints()
    }

    func filterHomeDataSource(){

        self.homeDataSource.value = self.homeDataSourceCopy.value?.map({ homeItem in
            var item = homeItem
            if homeItem.type == .favorites {
                item.isVisible = favServiceList.value?.count != 0 ? homeItem.isVisible : false
            }
            return item
        })
        guard favServiceList.value?.count == 0  else {
            return
        }
        self.homeDataSource.value = self.homeDataSource.value?.filter{$0.isVisible == true}

    }

    func fetchHomeEndpoints()  {
        self.homeDataSource.value?.forEach{item in
            item.endPoint()
        }
    }

    // location
    private func getLocationData(){
        if let savedLocation =  LocalStorageManager.getArrayData(key: DefaultsKeys.location){
            address = savedLocation[0]
            lat = Double(savedLocation[1]) ?? 0
            long = Double(savedLocation[2]) ?? 0
        }
        else {
            setUpLocationDependancy()
        }
    }

    func setUpLocationDependancy(){
        self.locationManager = LocationManager()
        self.locationManager.locationDelegate = self
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func didUpdateLocation(address: String,lat: Double,lng: Double) {
        self.address = address
        self.lat = lat
        self.long = lng
        LocalStorageManager.setArrayData(key: DefaultsKeys.location, value: [address,String(lat),String(lng)])
    }

    func requestAutorization() {
        self.nonAuthorizedStatus = true
    }

    func didUpdateAutorizeStatues(status: CLAuthorizationStatus) {
        switch status {
        case  .authorizedWhenInUse, .authorizedAlways:
            self.nonAuthorizedStatus = false
            self.locationStatus = status
        case  .notDetermined:
            self.nonAuthorizedStatus = false
            self.locationStatus = status

        default:
            self.nonAuthorizedStatus = true
            self.locationStatus = status

        }
    }

    func didFailWithError(error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    func getTempUnit()->String{
        tempUnit = LocalStorageManager.getData(key: DefaultsKeys.tempretureUnit) ?? "ºC"
        return tempUnit
    }

    private func setWeatherDetailsPayload(){
        weatherDetailsPayload.TempUnit = LocalStorageManager.getData(key: DefaultsKeys.tempretureUnit) == "ºF" ? 2 : 1
        weatherDetailsPayload.Lat = lat == 0 ? nil : lat
        weatherDetailsPayload.Lon = long == 0 ? nil : long
    }

    private func preparePayloadForMediaList() -> BasePayloadCerqel {
        var payload: BasePayloadCerqel = .init(pageNumber: nil, pageSize: nil, filterr: FilterCerqel(), orderByValuee: [.init(colID: "DateModified", sort: "desc")])

        payload.pageNumber = pageNumber
        payload.pageSize = pageSize
        payload.filter?.status = true
        self.mediaPayload = payload
        return payload
    }
    func getWeatherAndPrayer(){
        getWeatherDetailsEndPoint()
        getPrayers()
    }
    func getWeatherDetailsEndPoint() {
        self.showLoadingCerqel()
        self.isLoading.value = true
        getLocationData()
        setWeatherDetailsPayload()
        weatherDetailsUseCase.getWeatherDetails(payload:weatherDetailsPayload).then { (response) in
            self.weatherDetailsEntity.accept(response.result.data)
            self.hideLoadingCerqel()
            self.isLoading.value = false
        }.catch { (error) in
            self.isLoading.value = false
            self.hideLoadingCerqel()
            self.showSystemError(error: error)
        }.always {
            self.isLoading.value = false
            self.hideLoadingCerqel()
        }
    }

    func getPrayers() {
        self.showLoadingCerqel()
        self.isLoading.value = true
        prayersUseCase.getPrayer(payload: LocationCoordinatesPayload(lat: lat == 0 ? nil : lat, lon: long == 0 ? nil : long)).then { (response) in
            if let data = response.result.data
            {
                self.prayerDataEntity.accept(data)
            }
            self.isLoading.value = false
            self.hideLoadingCerqel()
        }.catch { (error) in
            self.isLoading.value = false
            self.hideLoadingCerqel()
            self.showSystemError(error: error)

        }.always {
            self.isLoading.value = false
            self.hideLoadingCerqel()
        }
    }

    func fetchMediaList(){
        let refresh = true
        if refresh {
            pageNumber = 1
            totalCount = -1
            mediaList.value = []
        }
        if totalCount == -1 || (totalCount > self.mediaList.value?.count ?? 0){
            self.showLoadingCerqel()
            self.isLoading.value = true
            self.service.load(cerqel_CodableResponseObject<MediaResponseDatumCerqel>(action: cerqel_BasicAction.mediaList(payload: preparePayloadForMediaList()))).subscribe(onNext: {
                [weak self] (response) in
                self?.hideLoadingCerqel()
                self?.isLoading.value = false
                if let mediaList = response.item?.arrData{
                    self?.totalDataCount = response.item?.totalCount ?? 0
                    if refresh {
                        self?.mediaList.value = mediaList
                    } else {
                        if self?.mediaList.value?.count == 0{
                            self?.mediaList.value = mediaList
                        }else{

                            var old = [MediaResponseDatumCerqel]()
                            for element in self?.mediaList.value ?? []{
                                old.append(element)
                            }
                            for item in mediaList{
                                old.append(item)
                            }
                            self?.mediaList.value = old
                        }
                    }

                }
                if let totalCount = response.item?.totalCount{
                    self?.totalCount = totalCount
                    self?.pageNumber += 1
                }
            }, onError: { (error) in
                self.showSystemError(error: error)
                self.hideLoadingCerqel()

            }).disposed(by: self.disposeBag)


        }
    }

    func updateFavouriteActionInAnnouncementsList(i: Int) {
        guard var announcementList = self.announcementList.value, announcementList.count > i else { return }
        announcementList[i].isBookmarked?.toggle()
        self.announcementList.value = announcementList
    }

    func addAnnounceToFav(index: Int){
        guard let id = selectedNewsId else {
            return
        }
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<Bool>(action: cerqel_BasicAction.addAnnounceToFavourite(id: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let isFav = response.item?.data, isFav {
                self?.updateFavouriteActionInAnnouncementsList(i: index )
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()

        }).disposed(by: self.disposeBag)
    }


    func fetchNewsList(){
        newsPayload.pageSize = 1
        newsPayload.pageNumber = 1
        newsPayload.filter?.status = true
        newsPayload.orderByValue = [.init(colID: "DateModified", sort: "desc")]
        self.showLoadingCerqel()
        self.isLoading.value = true
        self.service.load(cerqel_CodableResponseObject<ModelNewsDataCerqel>(action: cerqel_BasicAction.newsListNew(payload: newsPayload))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            self?.isLoading.value = false
            if let newsList = response.item?.arrData{
                self?.newsList.value = newsList
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)
    }


    func fetchInternalNewsList(){
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<ModelInternalNewsDataCerqel>(action: cerqel_BasicAction.internalNewsList(pageNumber: 0, pageSize: 2))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let newsList = response.item?.arrData{
                self?.internalNewsList.value = newsList
            }else{
                self?.internalNewsList.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)
    }

    func fetchCalendarHomeList(){
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<ModelCalendarHomeDataCerqel>(action: cerqel_BasicAction.calendarHomeList)).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let calendarList = response.item?.arrData {
                self?.calendarHomeList.value = calendarList
            }else{
                self?.calendarHomeList.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()

        }).disposed(by: self.disposeBag)
    }

    func fetchTasksStatistics(){
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<tasksStatisticsResultCerqel>(action: cerqel_BasicAction.myTasksStatistics)).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let tasksList = response.item?.arrData {
                self?.taskStatistics.value = tasksList
            }
            else{
                self?.taskStatistics.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)
    }

    func fetchRequestsStatistics(){
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<tasksStatisticsResultCerqel>(action: cerqel_BasicAction.myTasksStatistics)).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let tasksList = response.item?.arrData{
                self?.requestsStatistics.value = tasksList
            }else{
                self?.requestsStatistics.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)
    }


    func fetchAnnouncementList(){

        self.showLoadingCerqel()
        self.announcmentPayload.pageNumber = 1
        self.announcmentPayload.pageSize = 1
        self.announcmentPayload.filter?.bookmarkedOnly = false
        self.service.load(cerqel_CodableResponseObject<ModelAnnouncementDataCerqel>(action: cerqel_BasicAction.announcementsList(payload: announcmentPayload))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let newsList = response.item?.arrData{
                self?.announcementList.value = newsList
            }else{
                self?.announcementList.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()

        }).disposed(by: self.disposeBag)
    }

    func fetchOffersList(){
        offersPayload.pageSize = 1
        offersPayload.pageNumber = 1
        offersPayload.filter?.status = true
        self.showLoadingCerqel()
        self.isLoading.value = true
        self.service.load(cerqel_CodableResponseObject<ModelOfferDataCerqel>(action: cerqel_BasicAction.offersList(payload: offersPayload))).subscribe(onNext: {
            [weak self] (response) in
            self?.isLoading.value = false
            self?.hideLoadingCerqel()
            if let newsList = response.item?.arrData {
                self?.offerList.value = newsList
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)

    }


    func fetchEventsList(){
        self.eventsPayload.pageNumber = 1
        self.eventsPayload.pageSize = 5
        self.eventsPayload.filter?.isActive = true
        self.eventsPayload.filter?.eventOptions = 5
        self.showLoadingCerqel()
        self.isLoading.value = true
        self.service.load(cerqel_CodableResponseObject<EventResponseDataCerqel>(action: cerqel_BasicAction.eventsList(payload: eventsPayload))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            self?.isLoading.value = false
            if let eventList = response.item?.arrData{
                self?.eventsItemsList.value = eventList
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)

    }

    func addDeleteEventToCalendar(id: String, title: String, favouritedFromDetails: Bool = false){

        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<Bool>(action: CerqelEventsBasicAction.addEventToCalendar(id: id))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()

            if let isSuccess = response.success, isSuccess == true{
                self?.addedToCalendarTitle = title
                self?.fetchEventsList()
                self?.isEventAdded.value = isSuccess
            }

        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)
    }


    func fetchFavServiceList(){

        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<ModelServicesCerqel>(action: Dynamic_BasicAction.getFavoriteServices)).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let dataArr = response.item?.arrData{
                self?.favServiceList.value = dataArr
            }else{
                self?.favServiceList.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()

        }).disposed(by: self.disposeBag)
    }

    func fetchRecentServiceList(){

        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<ModelServicesCerqel>(action: Dynamic_BasicAction.getRecentServices)).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let dataArr = response.item?.arrData{
                self?.recentServicesList.value = dataArr
            }else{
                self?.recentServicesList.value = []
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()

        }).disposed(by: self.disposeBag)
    }


    func addServicetoFav(index: Int,serviceFrom: ServiceDestination){

        switch serviceFrom {
        case .favorites :
            let service = self.favServiceList.value?[index]
            addRemoveServiceToFav(id: service?.id ?? "", isFav: !(service?.isFavorite ?? false), serviceFrom: serviceFrom)
            self.favServiceList.value?.remove(at: index)

        case .allServices :
            let service = self.recentServicesList.value?[index]
            addRemoveServiceToFav(id: service?.id ?? "", isFav: !(service?.isFavorite ?? false), serviceFrom: serviceFrom)
            self.recentServicesList.value?[index].isFavorite?.toggle()
        default: break
        }

    }

    func addRemoveServiceToFav(id: String, isFav: Bool, serviceFrom: ServiceDestination){
        self.service.load(cerqel_CodableResponseObject<Bool>(action: Dynamic_BasicAction.addServiceToFavourite(id: id, isFav: isFav))).subscribe(onNext: {
            [weak self] (response) in
            if let isFav = response.item?.data {
                self?.hideLoadingCerqel()
                //self?.serviceFavStatusChanged.value = isFav
                switch serviceFrom {
                case .favorites :
                    self?.fetchRecentServiceList()
                case .allServices :
                    self?.fetchFavServiceList()
                default: break
                }
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)


    }

    func checkUnOpenedNotification() {
        self.service.load(cerqel_CodableResponseObject<ModelNotificationCountDataCerqel>(action: cerqel_BasicAction.unOpenedNotificationCount)).subscribe(onNext: {
            (response) in
            if let val = response.item?.data{
                self.unopenedNotificationCount.value = val.notificationCounter ?? 0
                print("Unopened Notifications : \(val.notificationCounter ?? 0)")
            }else{
                self.unopenedNotificationCount.value = 0
            }
        }, onError: { (error) in
            self.unopenedNotificationCount.value = 0
        }).disposed(by: self.disposeBag)
    }



    func addNewsToFavourite(newsID: String) {
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<Bool>(action: cerqel_BasicAction.addNewsToFavourite(id: newsID))).subscribe(onNext: {
            [weak self] (response) in
            guard let self = self else { return }
            self.hideLoadingCerqel()
            if let isFav = response.item?.data, isFav {
                self.fetchNewsList()
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)

    }

    func fetchRecentDocument() {
        self.showLoadingCerqel()
        documentRepo.recentFiles(cerqelFilterPayload:  CerqelFilterPayload(pageNumber: 1, pageSize: 10,orderByValue: [])).then { (response) in

            let files = response.result.data.files.map{$0.toFileModel()}
            self.filesList.value = files
        }.catch { (error) in
            self.hideLoadingCerqel()
        }.always {
            self.hideLoadingCerqel()
        }
    }

    func addDealToFavorites(dealID: String) {
        self.showLoadingCerqel()
        self.service.load(cerqel_CodableResponseObject<Bool>(action: cerqel_BasicAction.addOfferToFavourite(id: dealID))).subscribe(onNext: {
            [weak self] (response) in
            self?.hideLoadingCerqel()
            if let isFav = response.item?.data, isFav {
                self?.fetchOffersList()
            }
        }, onError: { (error) in
            self.showSystemError(error: error)
            self.hideLoadingCerqel()
        }).disposed(by: self.disposeBag)
    }

    func  presentFileAction (file: FileModel) {
        router.presentbottomSheet(controller: FileActionsView.self, viewModel: FileActionsViewModel.self, item: FileActionItem(file: file, router: router, delegate: self.delegate))
    }

    func routeToAllFiles(){
        router.pushTo(controller: FilesListView.self, viewModel: FilesListViewModel.self, item: FileFilterItem(fileFrom: .allFiles))
    }

    func routeToFavService() {
        router.pushTo(controller: AllServicesViewController.self, viewModel: AllServicesViewModel.self, item:  NewServiceFilterItem(serviceFrom: .homeFavorites,displayName: "favorites".localized))
    }
    func routeToRecentService() {
        router.pushTo(controller: AllServicesViewController.self, viewModel: AllServicesViewModel.self, item: NewServiceFilterItem(serviceFrom: .allServices,displayName: "All Services".localized))
    }

    func recieveFileAction(fileId: String,Acknowledge: FileAcknowledgeResponse){
        if let selectedFileIndex = self.filesList.value?.firstIndex(where: {$0.id == fileId}) {
            self.filesList.value?[selectedFileIndex].fileAcknowledgeStatus = FileAcknowledgeStatus(title: Acknowledge.acknowledgeTitle, color: Acknowledge.acknowledgeColor, isAcknowledge: true,isAcknowledged: true)
        }
    }



    func HandleFilePinnedAction(fileId: String){
        let fileIndex = self.filesList.value?.firstIndex(where: {$0.id == fileId}) ?? 0
        self.filesList.value?[fileIndex].isPinned.toggle()
    }
}

