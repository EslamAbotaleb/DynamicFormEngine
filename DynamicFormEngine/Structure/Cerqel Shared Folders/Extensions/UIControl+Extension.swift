//
//  UIControl+Extension.swift
//  CERQEL
//
//  Created by Omar Ibrahim on 11/11/25.
//  Copyright © 2025 Youxel. All rights reserved.
//

import UIKit

extension UIControl {
    func addTargetClosure(_ closure: @escaping (UIControl) -> ()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke(_:)), for: .touchUpInside)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

class ClosureSleeve {
    let closure: (UIControl) -> ()
    init (_ closure: @escaping (UIControl) -> ()) { self.closure = closure }
    @objc func invoke(_ sender: UIControl) { closure(sender) }
}
