//
//  File.swift
//  SwiftMVVMStartupProject
//
//  Created by Mahmoud Ibaraheim on 6/14/20.
//  Copyright © 2020 MahmoudOrganization. All rights reserved.
//

import Foundation
import UIKit

class IntrinsicTableView: UITableView {

//    override var contentSize:CGSize {
//          didSet {
//              invalidateIntrinsicContentSize()
//          }
//      }
//      override var intrinsicContentSize: CGSize {
//          layoutIfNeeded()
//          return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
//      }


    override var intrinsicContentSize: CGSize {
            self.layoutIfNeeded()
            return self.contentSize
        }

        override var contentSize: CGSize {
            didSet{
                self.invalidateIntrinsicContentSize()
            }
        }

        override func reloadData() {
            super.reloadData()
            self.invalidateIntrinsicContentSize()
        }
}
