//
//  CerqelBaseWireFrame.swift
//  CERQEL
//
//  Created by mac on 6/21/23.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import RxCocoa
import RxRelay
internal import RxSwift
import JGProgressHUD
import Kingfisher
import SideMenu
import Reachability
import Toast

class CerqelBaseWireFrameDynamicForm<T: CerqelBaseViewModel>: BottomSheetVCCerqel {
    
    var disposeBag = DisposeBag()
    var viewModel: T! {
        didSet {
            viewModel.implementAlert { (alert) in
                self.showToastCerqel(parentView: self, msg: alert)
                
            }
        }
    }
    let reachability = try! Reachability()
    
    func configure(with viewModel: T) {
        fatalError("You did not override configure method.. ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = view
        checkReachabilty()
        self.setupBackButton()
      
    
//        if viewModel == nil, let _ = self as? LoginCerqelVC{
//            viewModel = LoginViewModel(cerqel_BasicNetworkServiceImpl.shared) as? T
//        }
//      
//        if viewModel == nil, let _ = self as? CerqelBaseSortVC{
//            viewModel = CerqelBaseSortViewModel(cerqel_BasicNetworkServiceImpl.shared) as? T
//        }
//        
//        if viewModel == nil, let _ = self as? NewServicesVC {
//            viewModel = NewServicesViewModel(cerqel_BasicNetworkServiceImpl.shared) as? T
//        }
//
//        if viewModel == nil, let _ = self as? EventDetailsVC {
//            viewModel = MyCalendarViewModel(cerqel_BasicNetworkServiceImpl.shared) as? T
//        }
        
        
        self.errorObsereve(errorsObservable: self.viewModel.errorsObservable)
        self.loadingViewObsereve(loadingObservable: self.viewModel.loadingSubject)
        configure(with: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  self.setNavigationBarStyle()
    }
    
    func checkReachabilty() {
        //declare this property where it won't go out of scope relative to your listener
        
        reachability?.whenReachable = { reachability in
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            }
            
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
            DispatchQueue.main.async {
                showNoConnectionPopupCerqel(parentView: self)
                UIApplication.shared.keyWindow!.isUserInteractionEnabled = false
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    
    func setNavigationBarStyle(){
        self.navigationController?.cerqel_setDefaultNavigationAppearance()
    }
    
    func showHideV(view: UIView, hide: Bool) {
        view.isHidden = hide
    }
    
    func getDate(dateString: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    func getDateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateFormatted = dateFormatter.string(from: date)
        return dateFormatted
    }
    
    func errorObsereve(errorsObservable: Observable<Error>){
        
        errorsObservable.subscribe(onNext:{ [unowned self](error) in
            self.viewModel.loadingSubject.onNext(BaseLoading.hide)
            self.cerqel_showError(error: error )
        }).disposed(by: disposeBag)
        
    }
    
    func loadingViewObsereve(loadingObservable: Observable<BaseLoading>){
        
        loadingObservable.subscribe(onNext:{ [unowned self] (loading) in
            switch loading {
                
            case .show:
                self.cerqel_showLoading()
            case .hide:
                self.cerqel_hideLoading()
            case .withText(_):
                fatalError()
                //            case .showSkeleton:
                //                self.view.showAnimatedGradientSkeleton()
                //            case .hideSkeleton:
                //                self.view.hideSkeleton(reloadDataAfter: true)
                
            }
        }).disposed(by: disposeBag)
        
    }
    
    
    func goToProfile(){
        //        self.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .myProfile()), animated: true)
        
    }
    
    /// To be renamed (setupNavigationBarForMainTabs(title: String))
    /// To be removed from other view controllers (will be used in main tabs only)
    func addCircleProfileToNavigation(title: String = "", notificationCounter: Int) {
        self.title = title
        guard let profilePhoto = AuthManager.shared.profile.value?.photo else {
            addDefaultProfileNavigation(notificationCounter: notificationCounter)
            return
        }
        
        let width: CGFloat = 30
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: width, height: width)) |> RoundCornerImageProcessor(cornerRadius: width/2)
        
        let _ = KingfisherManager.shared.retrieveImage(with: URL(string: profilePhoto)!, options: [.cacheMemoryOnly,.processor(processor)], progressBlock: nil, downloadTaskUpdated: nil) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                /// left profile button
                let profileButton = UIButton(type: .custom)
                profileButton.addTarget(self, action: #selector(self.goToProfileFromNavigation), for: .touchUpInside)
                profileButton.setImage(result.image, for: .normal)
                let navProfileButton = UIBarButtonItem(customView: profileButton)
                
                /// right search button
                let searchButton = UIButton(type: .custom)
                searchButton.addTarget(self, action: #selector(self.goToGlobalSearch), for: .touchUpInside)
                searchButton.setImage(UIImage(named: "search"), for: .normal)
                searchButton.tintColor = primaryMain
                if isArabicCerqel() { searchButton.transform = .init(scaleX: -1, y: 1) }
                let navSearchButton = UIBarButtonItem(customView: searchButton)
                
                /// right notifications button
                let notificationsButton = UIButton(type: .custom)
                notificationsButton.addTarget(self, action: #selector(self.goToNotifications), for: .touchUpInside)
                notificationsButton.setImage(UIImage(named: "notificationC"), for: .normal)
                notificationsButton.tintColor = primaryMain
                
                var label = UILabel()
                if notificationCounter > 0 {
                    
                    if notificationCounter <= 9 {
                        if isArabicCerqel() {
                            label = UILabel(frame: CGRect(x: -8.5, y: -5, width: 20, height: 20))
                        } else {
                            label = UILabel(frame: CGRect(x: 11.5, y: -5, width: 20, height: 20))
                        }
                    } else {
                        if isArabicCerqel() {
                            label = UILabel(frame: CGRect(x: -13.5, y: -8, width: 25, height: 25))
                        } else {
                            label = UILabel(frame: CGRect(x: 12.5, y: -8, width: 25, height: 25))
                        }
                    }
                    
                    label.textColor = .whiteCerqel
                    label.font = UIFont.caption3Regular()
                    label.textAlignment = .center
                    label.backgroundColor = .errorCerqel
                    label.layer.cornerRadius = label.frame.width / 2
                    label.layer.masksToBounds = true
                    if notificationCounter >= 100 {
                        label.text = "+99".localized
                    } else {
                        label.text = "\(notificationCounter)"
                    }
                    notificationsButton.addSubview(label)
                }
                
                let navNotificationButton = UIBarButtonItem(customView: notificationsButton)
                
                /// spacing between notification & search buttons
                let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                spacing.width = 20
                
                self.navigationItem.leftBarButtonItem = navProfileButton
                self.navigationItem.rightBarButtonItems = [navNotificationButton, spacing, navSearchButton]
            case.failure(let kfError):
                print("❌❌❌ Profile Image error \(kfError.localizedDescription)❌❌❌")
                self.addDefaultProfileNavigation(notificationCounter: notificationCounter)
            }
        }
    }
    
    private func addDefaultProfileNavigation(notificationCounter: Int) {
        /// left profile button
        let profileButton = UIButton(type: .custom)
        profileButton.addTarget(self, action: #selector(self.goToProfileFromNavigation), for: .touchUpInside)
        profileButton.setImage(UIImage(named: "User"), for: .normal)
        let navProfileButton = UIBarButtonItem(customView: profileButton)
        
        /// right search button
        let searchButton = UIButton(type: .custom)
        searchButton.addTarget(self, action: #selector(self.goToGlobalSearch), for: .touchUpInside)
        searchButton.setImage(UIImage(named: "search_nav"), for: .normal)
        searchButton.tintColor = primaryMain
        if isArabicCerqel() { searchButton.transform = .init(scaleX: -1, y: 1) }
        let navSearchButton = UIBarButtonItem(customView: searchButton)
        
        /// right notifications button
        let notificationsButton = UIButton(type: .custom)
        notificationsButton.addTarget(self, action: #selector(self.goToNotifications), for: .touchUpInside)
        notificationsButton.setImage(UIImage(named: "notificationC"), for: .normal)
        notificationsButton.tintColor = primaryMain
        
        var label = UILabel()
        if notificationCounter > 0 {
            
            if notificationCounter <= 9 {
                if isArabicCerqel() {
                    label = UILabel(frame: CGRect(x: -8.5, y: -5, width: 20, height: 20))
                } else {
                    label = UILabel(frame: CGRect(x: 11.5, y: -5, width: 20, height: 20))
                }
            } else {
                if isArabicCerqel() {
                    label = UILabel(frame: CGRect(x: -13.5, y: -8, width: 25, height: 25))
                } else {
                    label = UILabel(frame: CGRect(x: 12.5, y: -8, width: 25, height: 25))
                }
            }
            
            label.textColor = .whiteCerqel
            label.font = UIFont.caption3Regular()
            label.textAlignment = .center
            label.backgroundColor = .errorCerqel
            label.layer.cornerRadius = label.frame.width / 2
            label.layer.masksToBounds = true
            if notificationCounter >= 100 {
                label.text = "+99".localized
            } else {
                label.text = "\(notificationCounter)"
            }
            notificationsButton.addSubview(label)
        }
        
        let navNotificationButton = UIBarButtonItem(customView: notificationsButton)
        
        /// spacing between notification & search buttons
        let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing.width = 20
        
        self.navigationItem.leftBarButtonItem = navProfileButton
        self.navigationItem.rightBarButtonItems = [navNotificationButton, spacing, navSearchButton]
    }
    
    /// Change the action to open side menu
    @objc func goToProfileFromNavigation() {
        sideMenuController?.revealMenu()
    }
    
    @objc func goToNotifications() {
//        self.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .notificationList), animated: true)
    }
    
    func addGlobalSearchItem(){
        if FF_GlobalSearch_isAvalable{
            if var items = self.navigationItem.rightBarButtonItems{
                let search = UIBarButtonItem.init(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(self.goToGlobalSearch))
                items.append(search)
                self.navigationItem.setRightBarButtonItems(items, animated: true)
            }
        }
    }
    
    @objc private func goToGlobalSearch(){
//        let vc = SearchView(nibName: "SearchView", bundle: nil)
//        vc.hidesBottomBarWhenPushed = true
//        vc.viewModel = FilterViewModel()
//        vc.item = SearchItem(fromView: .globalSearch, filterModelCallBack: filterModelCallBack )
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalPresentationStyle = .fullScreen
//        self.present(navController, animated: true, completion: nil)
    }
    
    
    
    @objc private func gotoNotification(){
//        self.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .notificationList), animated: true)
    }
    
    /// To be removed
    func setupPageTitle(title: String) {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont(name: "SSTArabic-Bold", size: 16)
        titleLbl.textColor = primaryMain
        let search = UIBarButtonItem.init(image: UIImage(named: "searchIconNew"), style: .plain, target: self, action: #selector(self.goToGlobalSearch))
        let alert = UIBarButtonItem.init(image: UIImage(named: "AlertNewIcon"), style: .plain, target: self, action: #selector(self.gotoNotification))
        let user = UIBarButtonItem.init(image: UIImage(named: "User"), style: .plain, target: self, action: #selector(self.goToProfileFromNavigation))
        addCircleProfileToNavigationToMainScreens()
        search.tintColor = primaryMain
        alert.tintColor = primaryMain
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: primaryMain,NSAttributedString.Key.font: UIFont.heading4()]
        
        //        let titleItem = UIBarButtonItem(customView: titleLbl)
        navigationItem.rightBarButtonItems = [alert,search]
    }
    
    func addCircleProfileToNavigationToMainScreens() {
        guard let profilePhoto = AuthManager.shared.profile.value?.photo.value else {
            let user = UIBarButtonItem.init(image: UIImage(named: "User"), style: .plain, target: self, action: #selector(self.goToProfileFromNavigation))
            self.navigationItem.leftBarButtonItems = [user]
            return
        }
        
        let width: CGFloat = 30
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: width, height: width)) |> RoundCornerImageProcessor(cornerRadius: width/2)
        
        let _ = KingfisherManager.shared.retrieveImage(with: URL(string: profilePhoto)!, options: [.cacheMemoryOnly,.processor(processor)], progressBlock: nil, downloadTaskUpdated: nil) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let button = UIButton(type: .custom)
                button.addTarget(self, action: #selector(self.goToProfileFromNavigation), for: .touchUpInside)
                button.setImage(result.image, for: .normal)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
                let stackview = UIStackView.init(arrangedSubviews: [button])
                stackview.distribution = .equalSpacing
                stackview.axis = .horizontal
                stackview.alignment = .center
                stackview.spacing = 14
                let rightBarButton = UIBarButtonItem(customView: stackview)
                self.navigationItem.rightBarButtonItem = rightBarButton
            case.failure(let kfError):
                print("❌❌❌ Profile Image error \(kfError.localizedDescription)❌❌❌")
                let user = UIBarButtonItem.init(image: UIImage(named: "User"), style: .plain, target: self, action: #selector(self.goToProfileFromNavigation))
                self.navigationItem.leftBarButtonItems = [user]
            }
        }
    }
    
    func showToastCerqel(parentView: UIViewController, msg: String){
        
        var style = ToastStyle()
        style.imageSize = CGSize(width: 20, height: 20)
        style.messageFont = UIFont.bodyLMedium()
        style.messageColor = .white
        style.backgroundColor = .black
        style.fadeDuration = 2
        
        parentView.view.makeToast(msg, duration: 2, point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140), title: nil, image: nil, style: style, completion: nil)
    }
    
}
