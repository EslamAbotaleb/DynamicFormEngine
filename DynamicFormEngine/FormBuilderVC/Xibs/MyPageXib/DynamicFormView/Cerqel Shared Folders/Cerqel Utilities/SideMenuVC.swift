//
//  SideMenuVC.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 20/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
import SideMenuSwift
import RxCocoa
import RxSwift

class SideMenuVC: UIViewController {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var currentModuleImg: UIImageView!
    @IBOutlet weak var currentModuleName: UILabel!
    @IBOutlet weak var modulesTV: UITableView!
    @IBOutlet weak var appVersionLbl: UILabel!{
        didSet{
            if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String,
               let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                appVersionLbl.text =  " \("App Version".localized) - V\(appVersion).\(build)"
            }
        }
    }
    @IBOutlet weak var settingsStackView: UIStackView!
    
    @IBOutlet weak var logoutStackView: UIStackView!
    @IBOutlet weak var selectedKafdV: UIView!
    @IBOutlet weak var settingImgV: UIImageView!
    @IBOutlet weak var settingsLbl: LocalizedLabel!
    @IBOutlet weak var logoutImgV: UIImageView!
    @IBOutlet weak var logoutLbl: LocalizedLabel!
    @IBOutlet weak var rightArrowImgV: UIImageView!
    
    struct sideMenuMedules {
        var icon : String
        var title: String
    }
    private let disposeBag = DisposeBag()
    var modulesList :[sideMenuMedules] = [sideMenuMedules(icon: "tremvo", title: "TREMVO"),sideMenuMedules(icon: "check", title: "CHECK")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthManager.shared.fetchProfile()
        configUI()
        configureUI()
        configTV()
        subscribeToSettingClicks()
        subscribeToLogoutClicks()
        handleObservation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let profile = AuthManager.shared.profile.value {
            self.updateUserInfoUI(profile:profile)
        }
    }
    
    private func handleObservation(){
        AuthManager.shared.profile.bind { profile in
            if let profile = profile {
                self.updateUserInfoUI(profile:profile)
            }
        }
    }
    
    private func updateUserInfoUI(profile:ModelUserProfileDataCerqel){
        if(profile.photo != nil && profile.photo != ""){
            self.userImg.cerqel_LoadImgWithUrl(imgUrl: (profile.photo )?.cerqel_CreateMediaURL(), brokenImgName: avatarImgNameCerqel)
        }
        else{
            handleImageWithKFCerqel(imgUrl: "", img: self.userImg , name: profile.name ?? "",  color: primaryMain.withAlphaComponent(0.1), textColor: primaryMain)
        }
        self.userNameLbl.text = profile.name
        self.emailLbl.text = profile.mail
    }
    
    private func configUI() {
        if isArabicCerqel() {
            selectedKafdV.cerqel_cornerRadiusRound(usingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
        } else {
            selectedKafdV.cerqel_cornerRadiusRound(usingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        }
    }
    
    func configTV() {
        modulesTV.delegate = self
        modulesTV.dataSource = self
        modulesTV.register(ModulesCell.cerqel_nib, forCellReuseIdentifier: ModulesCell.cerqel_identifier)
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        goToProfile()
    }
    
    private func goToProfile() {
        sideMenuController?.hideMenu()
        guard let mainTabBar = sideMenuController?.contentViewController as? UITabBarController else { return }
        guard let navigationController = mainTabBar.selectedViewController as? UINavigationController else { return }
        navigationController.pushViewController(CERQEL_Router.goTo(viewName: .newProfile), animated: true)
    }
    
    func subscribeToSettingClicks() {
        let tapGesture = UITapGestureRecognizer()
        settingsStackView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
            guard let self = self else {return}
            self.sideMenuController?.hideMenu()
            guard let mainTabBar = self.sideMenuController?.contentViewController as? UITabBarController else { return }
            guard let navigationController = mainTabBar.selectedViewController as? UINavigationController else { return }
            navigationController.pushViewController(CERQEL_Router.goTo(viewName: .mainSetting), animated: true)
        }).disposed(by: disposeBag)
    }
    func subscribeToLogoutClicks() {
        let tapGesture = UITapGestureRecognizer()
        logoutStackView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind(onNext: { [weak self] recognizer in
            guard let self = self else {return}
            let alert = UIAlertController(title: "", message: "Are you sure you want to logout?".localized, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Logout".localized, style: .destructive) { (_) in
                print("Done")
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    if let topVC = UIApplication.cerqel_topVC() {
                        app.auth.logoutFromADFS(from: topVC)
                    }
                }
            }
            let cancel = UIAlertAction(title: "Cancel".localized, style: .default) { (_) in
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
extension SideMenuVC: UITableViewDataSource, UITableViewDelegate{
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        var lbl = UILabel()
        if isArabicCerqel() {
            lbl = UILabel(frame: CGRect(x: -5, y: 16, width: tableView.bounds.width, height: v.bounds.height))
            lbl.textAlignment = .right
        } else {
            lbl = UILabel(frame: CGRect(x: 5, y: 16, width: tableView.bounds.width, height: v.bounds.height))
            lbl.textAlignment = .left
        }
        lbl.text = "Add-ons".localized
        lbl.font = UIFont.bodyMRegular()
        lbl.textColor = typographySubtitle
        v.addSubview(lbl)
        v.backgroundColor = .white
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModulesCell.cerqel_identifier,for: indexPath) as! ModulesCell
        
            cell.modulesName.text = modulesList[indexPath.row].title
            cell.modulesImg.image = UIImage(named:modulesList[indexPath.row].icon)
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("DONE")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SideMenuVC {
    private func configureUI() {
        settingImgV.tintColor = primaryMain
        logoutImgV.tintColor = primaryMain
        settingsLbl.textColor = typographyTitle
        logoutLbl.textColor = typographyTitle
        appVersionLbl.textColor = typographyBody
        rightArrowImgV.tintColor = primaryMain
        userNameLbl.textColor = typographyTitle
        emailLbl.textColor = typographyBody
        settingsLbl.font = UIFont.bodyMRegular()
        logoutLbl.font = UIFont.bodyMRegular()
        appVersionLbl.font = UIFont.bodySRegular()
        userNameLbl.font = UIFont.bodyMSemibold()
        emailLbl.font = UIFont.bodyMRegular()
        selectedKafdV.backgroundColor = primaryLight
        currentModuleName.textColor = typographyTitle
        currentModuleName.font = UIFont.bodyMRegular()
        userImg.makeRounded(color: UIColor.clear)
    }
}
