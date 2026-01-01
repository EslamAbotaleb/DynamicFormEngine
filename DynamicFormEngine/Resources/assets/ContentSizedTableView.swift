//
//  ContentSizedTableView.swift
//  DynamicFormEngine
//
//  Created by hassan elshaer on 01/03/2024.
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
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
}

