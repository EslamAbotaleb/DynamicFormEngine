//
//  ContentSizedTableView.swift
//  CERQEL
//
//  Created by hassan elshaer on 24/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//


import UIKit

class ContentSizedTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}


