//
//  NewBaseView.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 28/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit
import PanModal
import SkeletonView
import JGProgressHUD
import Toast
import XLPagerTabStrip
  
class PagerTabStripBaseView<ViewModel: BaseVM, Item: BaseItem>: ButtonBarPagerTabStripViewController, PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(10)
        
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
        
    }
    
    var cornerRadius: CGFloat {
        return 12
    }
    
    let frame = UIScreen.main.bounds
    var item: Item!
    let hud = JGProgressHUD(style: .dark)
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.implementAlert { (alert) in
                self.showToastCerqel(parentView: self, msg: alert)
                
            }
            
            viewModel.implementErrorMessage { (error) in
                self.showToastCerqel(parentView: self, msg: error)
            }
            
            viewModel.isLoading.bind { (loading) in
                if loading {
                    self.showLoadingCerqel()
                } else {
                    self.hideLoadingCerqel()
                }
            }
            viewModel.hudLoading.bind { (loading) in
                if loading {
                    self.showHudLoading()
                } else {
                    self.cerqel_hideLoading()
                }
            }
        }
    }
    
    //   public func puplicAlert(title: String, message: String, theme: Theme){
    //      //  self.showAlertMessage(title: "", message: message, theme: theme)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindind()
    }
    //
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        view.layoutSkeletonIfNeeded()
    //    }
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    
    
    func showLoadingCerqel() {
        // self.view.showGradientSkeleton()
        self.cerqel_showLoading()
    }
    func showHudLoading() {
        self.cerqel_showLoading()
        //self.hud.show(in: self.view)
    }
    
    func hideLoadingCerqel(){
        self.view.hideSkeleton()
        self.cerqel_hideLoading()
        self.hud.dismiss()
    }
    
    func bindind() {}
    
    func setupBackButton() {
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func showToastCerqel(parentView: UIViewController, msg: String){
        
        var style = ToastStyle()
        style.imageSize = CGSize(width: 20, height: 20)
        style.messageFont = UIFont.bodyLMedium()
        style.messageColor = .white
        style.backgroundColor = .black
        style.fadeDuration = 3
        
        parentView.view.makeToast(msg, point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140), title: nil, image: nil, style: style, completion: nil)
    }
}
