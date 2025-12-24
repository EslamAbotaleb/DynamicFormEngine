//
//  Dynamic.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/15/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation

open class DynamicObjects<T> {
    public typealias Listener = (T) -> Void
    open var listener: Listener?
    
    open func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    open func bind(_ listener: Listener?) {
        self.listener = listener
    }

    open var value: T {
        didSet {
            listener?(value)
        }
    }
    
    public init(_ value: T) {
        self.value = value
    }
}
