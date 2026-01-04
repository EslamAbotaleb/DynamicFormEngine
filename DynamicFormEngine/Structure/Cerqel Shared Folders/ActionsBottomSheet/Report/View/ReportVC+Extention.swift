//
//  ReportVC+Extention.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 18/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import Foundation
import UIKit

extension ReportView : UITableViewDelegate, UITableViewDataSource{
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportList.value.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonTVCell.cerqel_identifier, for: indexPath) as! RadioButtonTVCell
        cell.configure(item: viewModel.reportList.value[indexPath.row])
        return cell 
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(index: indexPath.row)
        guard  viewModel.selectedItemId.value != viewModel.reportList.value.last?.id  else {
            return
        }
        self.view.endEditing(true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
   func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReportFooterTVCell") as! ReportFooterTVCell
        footerCell.reasonSpecified = {
            self.viewModel.otherReason.value = $0
        }
        return footerCell
    }
    
    
    //    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let height = viewModel.selectedItemId.value == viewModel.reportList.value.last?.id  ? 162 : 0
        
        return CGFloat(height)
    }
}

