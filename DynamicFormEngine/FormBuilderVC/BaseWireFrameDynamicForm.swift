//
//  BaseWireFrameDynamicForm.swift
//  GAZT
//
//  Created by iSlam on 10/11/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
public import RxCocoa
import RxRelay
public import RxSwift
import JGProgressHUD
internal import Kingfisher
import SideMenu
import Reachability
//import PopupDialog
import SwiftUI

public class BaseWireFrameDynamicForm<T: BaseViewModel>: BottomSheetVCCerqel {
    
    var disposeBag = DisposeBag()
    public var viewModel: T!
    public let reachability = try! Reachability()

    public func configure(with viewModel: T) {
        fatalError("You did not override configure method.. ")
    }
    

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view = view
        checkReachabilty()
        self.setupBackButton()
      

        self.errorObsereve(errorsObservable: self.viewModel.errorsObservable)
        self.loadingViewObsereve(loadingObservable: self.viewModel.loadingSubject)
        configure(with: viewModel)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
      //  self.setNavigationBarStyle()
    }
    
    public func checkReachabilty() {
        //declare this property where it won't go out of scope relative to your listener
        
        reachability.whenReachable = { reachability in
            
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            }
            
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            DispatchQueue.main.async {
                showNoConnectionPopupCerqel(parentView: self)
                UIApplication.shared.keyWindow!.isUserInteractionEnabled = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    public func setNavigationBarStyle(){
        self.navigationController?.cerqel_setDefaultNavigationAppearance()
    }
    
    public func getDate(dateString: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    public func getDateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateFormatted = dateFormatter.string(from: date)
        return dateFormatted
    }

    public func errorObsereve(errorsObservable: Observable<Error>){
        
        errorsObservable.subscribe(onNext:{ [unowned self](error) in
            self.viewModel.loadingSubject.onNext(BaseLoading.hide)
            self.cerqel_showError(error: error )
        }).disposed(by: disposeBag)
        
    }
    
    public func loadingViewObsereve(loadingObservable: Observable<BaseLoading>){
        
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
    
    
    public func goToProfile(){
//        self.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .myProfile()), animated: true)

    }
    
    /// To be renamed (setupNavigationBarForMainTabs(title: String))
    /// To be removed from other view controllers (will be used in main tabs only)
    public func addCircleProfileToNavigation(title: String = "", notificationCounter: Int) {
        self.title = title
        guard let profilePhoto = AuthManagerDynamicForm.shared.profile.value?.photo.value else {
            addDefaultProfileNavigation(notificationCounter: notificationCounter)
            return
        }
        guard  let imageURL = profilePhoto.base64ImageToCustomMediaURL() else {
            addDefaultProfileNavigation(notificationCounter: notificationCounter)
            return
        }
        let width: CGFloat = 40
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: width, height: width)) |> RoundCornerImageProcessor(cornerRadius: width/2)
        
        let _ = KingfisherManager.shared.retrieveImage(with: URL(string: imageURL)!, options: [.cacheMemoryOnly,.processor(processor)], progressBlock: nil, downloadTaskUpdated: nil) { [weak self] response in
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
                    
                    label.textColor = .white
                    label.font = UIFont.caption3Regular()
                    label.textAlignment = .center
                    label.backgroundColor = .error
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
        let userImage = UIImageView()
        handleImageWithKFCerqel(imgUrl: "", img: userImage, name: AuthManagerDynamicForm.shared.profile.value?.name ?? "", color: primaryMain.withAlphaComponent(0.1), textColor: primaryMain)
        
        /// left profile button
        userImage.makeRounded(borderColor: primaryMain)
        userImage.contentMode = .scaleAspectFit
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        profileButton.addTarget(self, action: #selector(self.goToProfileFromNavigation), for: .touchUpInside)
        profileButton.setImage(userImage.image, for: .normal)
        profileButton.borderColorV = primaryMain
        profileButton.borderWidthV = 0.5
        profileButton.cornerRadiusV = 20
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
            
            label.textColor = .white
            label.font = UIFont.caption3Regular()
            label.textAlignment = .center
//            label.backgroundColor = Color.error
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
    
    public func addGlobalSearchItem(){
        if FF_GlobalSearch_isAvalable{
            if var items = self.navigationItem.rightBarButtonItems{
                let search = UIBarButtonItem.init(image: UIImage(named: "search_nav"), style: .plain, target: self, action: #selector(self.goToGlobalSearch))
                items.append(search)
                self.navigationItem.setRightBarButtonItems(items, animated: true)
            }
        }
    }
    
    @objc  func goToGlobalSearch(){
//        let vc = SearchView(nibName: "SearchView", bundle: nil)
//        vc.hidesBottomBarWhenPushed = true
//        vc.viewModel = FilterViewModel()
//        vc.item = SearchItem(fromView: .globalSearch, filterModelCallBack: filterModelCallBack )
//        let navController = UINavigationController(rootViewController: vc)
//        navController.modalPresentationStyle = .fullScreen
//        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func gotoNotification(){
//        self.navigationController?.pushViewController(CERQEL_Router.goTo(viewName: .notificationList), animated: true)
    }
    
    /// To be removed
    public func setupPageTitle(title: String) {
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
     
    public  func addCircleProfileToNavigationToMainScreens() {
         guard let profilePhoto = AuthManagerDynamicForm.shared.profile.value?.photo/*profilePicture*/ else {
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
    
}

public func flashHud(message:String,view:UIView,indicator:JGProgressHUDIndicatorView) -> JGProgressHUD {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = message
    hud.indicatorView = nil
    hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
    hud.vibrancyEnabled = true
    hud.show(in: view)
    hud.dismiss(afterDelay: 2.0)
    return hud
}
