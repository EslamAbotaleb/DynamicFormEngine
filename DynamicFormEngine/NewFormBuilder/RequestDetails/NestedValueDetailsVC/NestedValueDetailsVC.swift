//
//  NestedValueDetailsVC.swift
//
//
//  Created by iSlam AbdelAziz on 22/11/2021.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class NestedValueDetailsVC: BottomSheetVCCerqel {
    
    @IBOutlet weak var itemTV: UITableView!

    var arrayOfControls: [ModelControl]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationItem.title = ""
        self.navigationController?.navigationItem.backButtonTitle = ""
        
        // Do any additional setup after loading the view.
        itemTV.register(ActionControlAttachmentsTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlAttachmentsTVcell.cerqel_identifier)
        itemTV.register(TableControlValueTVcell.cerqel_nib, forCellReuseIdentifier: TableControlValueTVcell.cerqel_identifier)
        itemTV.register(ActionControlTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlTVcell.cerqel_identifier)
        itemTV.register(DetailsEmptyStateTVcell.cerqel_nib, forCellReuseIdentifier: DetailsEmptyStateTVcell.cerqel_identifier)
    }


}

extension NestedValueDetailsVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfControls?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let ctl = arrayOfControls?[indexPath.row]{
            if ctl.isVisibleInViewMode ?? false{
                if arrayOfControls?[indexPath.row].type == .FileUpload{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlAttachmentsTVcell.cerqel_identifier, for: indexPath) as! ActionControlAttachmentsTVcell
//                    cell.configure(ctl: arrayOfControls?[indexPath.row])
                    return cell
                }else if arrayOfControls?[indexPath.row].type == .table{
                    // This is Nested Form (Table Control)
                    let cell = tableView.dequeueReusableCell(withIdentifier: TableControlValueTVcell.cerqel_identifier, for: indexPath) as! TableControlValueTVcell
                    cell.configure(ctls: arrayOfControls?[indexPath.row].coltrolRow, title: arrayOfControls?[indexPath.row].label)
                    cell.didSelectRow = {  [weak self] idx in
                        
                    }
                    return cell
                }else if let ctl = arrayOfControls?[indexPath.row], let arr = ctl.value, arr.count > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlTVcell.cerqel_identifier, for: indexPath) as! ActionControlTVcell
//                    cell.configure(ctl: arrayOfControls?[indexPath.row])
                    return cell
                    
                }
                
                
                
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailsEmptyStateTVcell.cerqel_identifier, for: indexPath) as! DetailsEmptyStateTVcell
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    
}
