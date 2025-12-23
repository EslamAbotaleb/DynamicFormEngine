//
//  BaseView.swift
//  SwiftMVVMStartupProject
//
//  Created by Maher on 6/15/20.
//  Copyright © 2020 MaherOrganization. All rights reserved.
//

import Foundation
import UIKit
import PanModal
import SkeletonView
import JGProgressHUD
import Toast

public class BaseView<ViewModel: BaseVM, Item: BaseItem>: BottomSheetVCCerqel, PanModalPresentable {
    public var panScrollable: UIScrollView? {
        return nil
    }
    public var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(10)
        
    }
    
    public var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
        
    }
    
    public  var allowsExtendedPanScrolling: Bool { return false }
    
    public var allowsTapToDismiss: Bool { return true }
    
    public var allowsDragToDismiss: Bool { return true  }
    
    public var cornerRadius: CGFloat {
        return 12
    }
    
    public let frame = UIScreen.main.bounds
    public var item: Item!
    public let hud = JGProgressHUD(style: .dark)
    
    public var viewModel: ViewModel! {
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        bindind()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    
    
    public func showLoadingCerqel() {
        // self.view.showGradientSkeleton()
        self.cerqel_showLoading()
    }
    public  func showHudLoading() {
        self.cerqel_showLoading()
        //self.hud.show(in: self.view)
    }
    
    public  func hideLoadingCerqel(){
        self.view.hideSkeleton()
        self.cerqel_hideLoading()
        self.hud.dismiss()
    }
    
    public func bindind() {}
    
}

extension BaseView {
    
    public   func showToastCerqel(parentView: UIViewController, msg: String){
        
        var style = ToastStyle()
        style.imageSize = CGSize(width: 20, height: 20)
        style.messageFont = UIFont.bodyLMedium()
        style.messageColor = .white
        style.backgroundColor = .black
        style.fadeDuration = 3
        
        parentView.view.makeToast(msg, point: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 140), title: nil, image: nil, style: style, completion: nil)
    }
    
    //private func showAlertMessage(title: String, message: String, theme: Theme) {
    //        let success = MessageView.viewFromNib(layout: .messageView)
    //        success.configureTheme(theme)
    //        success.configureDropShadow()
    //        success.configureContent(title: title, body: message)
    //        success.button?.isHidden = true
    //        var successConfig = SwiftMessages.defaultConfig
    //        successConfig.dimMode = .blur(style: .dark, alpha: 0.4, interactive: true)
    //        successConfig.presentationStyle = .top
    //        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
    //        SwiftMessages.show(config: successConfig, view: success)
    
    //  }
}
