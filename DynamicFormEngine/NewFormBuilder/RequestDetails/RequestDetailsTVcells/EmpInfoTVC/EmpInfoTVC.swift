//
//  EmpInfoTVC.swift
// 
//
//  Created by Abdallah Elmahlawy on 12/31/20.
//  Copyright © 2020 All rights reserved.
//

import UIKit

class EmpInfoTVC: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var empImgV: UIImageView!
    @IBOutlet weak var empNameLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusLblContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        outerView.backgroundColor = .white
        outerView.addTopCornerWith(radius: 4)
    }
    
    func configure(_ item: Employee?, status: Status?){
        empNameLbl.text = /*"\("By".localized)*/"\(item?.name ?? "")"
        empImgV.cerqel_LoadImgWithUrl(imgUrl: (item?.photo ?? "").cerqel_CreateMediaURL(), brokenImgName: "avatar_Big") {[weak self] in
            self?.empImgV.loadSVGImageWithAuth(urlString: (item?.photo ?? "").cerqel_CreateMediaURL(),
                                                      targetSize: CGSize(width: 46, height: 46))
        }
        departmentLbl.text = item?.department ?? ""
        statusLbl.text = status?.name ?? ""
        handleStatus(status: status)
    }
    
    private func handleStatus(status: Status?) {
        if let statusCode = status?.statusCode, let status = StatusCode(rawValue: statusCode.lowercased()) {
            statusLbl.textColor = status.textColor
            statusLblContainerView.backgroundColor = status.backgroundColor
            return
        }
        
        if let statusColorString = status?.statusColor?.lowercased(), let statusColor = StatusColor(rawValue: statusColorString) {
            statusLbl.textColor = statusColor.textColor
            statusLblContainerView.backgroundColor = statusColor.backgroundColor
            return
        }
    }
    
    func handleStatusColor(statusColor: String){
        switch statusColor {
        case "ORANGE":
            statusLbl.textColor = UIColor.squash
            statusLblContainerView.backgroundColor = UIColor.squash.withAlphaComponent(0.1)
        case "GRAY":
            statusLbl.textColor = UIColor.blue_grey
            statusLblContainerView.backgroundColor = UIColor.blue_grey.withAlphaComponent(0.1)
        case "GREEN":
            statusLbl.textColor = UIColor.alertApprovedSuccess
            statusLblContainerView.backgroundColor = UIColor.alertApprovedSuccess.withAlphaComponent(0.1)
        case "RED":
            statusLbl.textColor = #colorLiteral(red: 0.9450980392, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
            statusLblContainerView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.4196078431, blue: 0.4196078431, alpha: 0.1044788099)
        default:
            statusLbl.textColor = UIColor.squash
            statusLblContainerView.backgroundColor = UIColor.squash.withAlphaComponent(0.1)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
