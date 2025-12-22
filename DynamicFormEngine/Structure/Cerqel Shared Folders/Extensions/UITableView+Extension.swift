//
//  UITableView+Extension.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 01/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//


import Foundation
import UIKit

extension UITableView {
    func scrollToRowSafely(at indexPath: IndexPath, animated: Bool) {
        // Step 1: Check Data Availability
        guard indexPath.section < numberOfSections,
              indexPath.row < numberOfRows(inSection: indexPath.section) else {
            // Invalid index path, do not proceed with scrolling
            return
        }

        // Step 2: Perform on Main Thread
        DispatchQueue.main.async {

            // Step 3: Scroll Animation
            let scrollPosition: UITableView.ScrollPosition = .top

            // Step 4: Scroll to Row
            self.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        }
    }
}
