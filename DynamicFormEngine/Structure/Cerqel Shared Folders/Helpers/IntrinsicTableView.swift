//
//  File.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit

public class IntrinsicTableView: UITableView {

//    override var contentSize:CGSize {
//          didSet {
//              invalidateIntrinsicContentSize()
//          }
//      }
//      override var intrinsicContentSize: CGSize {
//          layoutIfNeeded()
//          return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//      }


    override public var intrinsicContentSize: CGSize {
            self.layoutIfNeeded()
            return self.contentSize
        }

        override public var contentSize: CGSize {
            didSet{
                self.invalidateIntrinsicContentSize()
            }
        }

        override public func reloadData() {
            super.reloadData()
            self.invalidateIntrinsicContentSize()
        }
}
