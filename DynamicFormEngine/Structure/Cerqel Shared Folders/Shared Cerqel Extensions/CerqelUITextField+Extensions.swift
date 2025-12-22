//
//  UITextField+Extensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 12/10/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit

extension UITextField{

    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }


    func cerqel_addIconView(img: UIImage, isRight: Bool = false){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let imgV = UIImageView(frame: CGRect(x: 13, y: 3, width: 14, height: 14))
        view.addSubview(imgV)
        imgV.image = img
        imgV.contentMode = .scaleAspectFit
        if isRight{
            self.rightView = view
            self.rightViewMode = .always
        }else{
            self.leftView = view
            self.leftViewMode = .always
        }
        //        self.leftView!.backgroundColor = UIColor.red

    }

    func cerqel_addEmptyView(isLeft: Bool, width: Int){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        if isLeft{
            self.leftView = view
            self.leftViewMode = .always
        }else{
            self.rightView = view
            self.rightViewMode = .always
        }
    }


    func cerqel_addTitleView(isLeft: Bool, width: Int, text: String, txtColor: UIColor){
        let lbl = UILabel(frame: CGRect(x: 4, y: 0, width: width, height: 20))
        lbl.text = text
        lbl.textColor = txtColor
        lbl.textAlignment = .center
        lbl.font = UIFont.init(name: "Cairo-Regular", size: 11)
        if isLeft{
            self.leftView = lbl
            self.leftViewMode = .always
        }else{
            self.rightView = lbl
            self.rightViewMode = .always
        }
    }

    enum cerqel_PaddingSpace {
        case left(CGFloat)
        case right(CGFloat)
        case equalSpacing(CGFloat)
    }

    func cerqel_addPadding(padding: cerqel_PaddingSpace) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true

        switch padding {

        case .left(let spacing):
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always

        case .right(let spacing):
            let rightPaddingView = UIView(frame: CGRect(x: spacing, y: 0, width: spacing, height: self.frame.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always

        case .equalSpacing(let spacing):
            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = equalPaddingView
            self.leftViewMode = .always
            // right
            self.rightView = equalPaddingView
            self.rightViewMode = .always
        }
    }

}
