//
//  ReqInfoTVC.swift
//
//
//  Created by Abdallah Elmahlawy on 12/31/20.
//  Copyright © 2020 All rights reserved.
//

import UIKit

class ReqInfoTVC: UITableViewCell {
    
    @IBOutlet weak var ticketNumLbl: UILabel!
    @IBOutlet weak var reqNameLbl: UILabel!
    @IBOutlet weak var createdDateLbl: UILabel!
    @IBOutlet weak var actionsBtn: LocalizedButton!
    
    @IBOutlet weak var requestIconImg: UIImageView!
    @IBOutlet weak var requestNameLbl: UILabel!
    @IBOutlet weak var requestIdLbl: UILabel!
    @IBOutlet weak var requestPendingOnLbl: UILabel!
    @IBOutlet weak var pendingonContainerView: UIView!
    @IBOutlet weak var requestDateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusLblContainerView: UIView!
    @IBOutlet weak var editActionBtn: UIButton!
    @IBOutlet weak var myRequestStackV: UIStackView!
    
    var HandlePendingOnGroupBtn: (() -> ())?
    var actionList: [ListModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addGesture()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HandlePendingOnGroupTap))
        pendingonContainerView.isUserInteractionEnabled = true
        pendingonContainerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func HandlePendingOnGroupTap() {
        HandlePendingOnGroupBtn?()
    }
    
    func configure(icon: String?, name: String?, id: String?, department: String?, pendingOn: String?, status: Status?, date: String?, isMyReqFlag: Bool) {
        requestIconImg.cerqel_LoadImgWithUrl(imgUrl: (icon ?? "").cerqel_CreateMediaURL(), brokenImgName: "avatar_Big") {[weak self] in
            self?.requestIconImg.loadSVGImageWithAuth(urlString: (icon ?? "").cerqel_CreateMediaURL(),
                                                      targetSize: CGSize(width: 50, height: 50))
        }
        
        requestNameLbl.text = name ?? ""
        if let dept = department, dept != "" {
            requestIdLbl.text = "ID".localized + " \(id ?? "") - \(dept)"
        }else {
            requestIdLbl.text = "ID".localized + " \(id ?? "")"
        }
        
        if let pendingOn = pendingOn, pendingOn != "", pendingOn != "N/A" {
            pendingonContainerView.isHidden = false
            requestPendingOnLbl.text = "\("Pending On:".localized) \(pendingOn)"
        }else {
            pendingonContainerView.isHidden = true
        }
        statusLbl.text = status?.name ?? ""
        handleStatus(status: status)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy  h:mm a"
        requestDateLbl.text = formatter.string(from: date?.getDateFromString() ?? Date())
        myRequestStackV.isHidden = isMyReqFlag ? false : true
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
    
    func configure(_ name: String?, _ date: String?, _ ticketNum: String?, _ isWithdrawal: Bool?){
        reqNameLbl.text = name
        if let date = date?.getDateFromString(){
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy  h:mm a"
            createdDateLbl.text = formatter.string(from: date)
        }
        if let ticket = ticketNum{
            if ticket != ""{
                ticketNumLbl.text = "\("Ticket".localized): \(ticket)"
            }
        }
        
        if let withdrawal = isWithdrawal{
            if withdrawal{
                actionsBtn.isHidden = false
                if isArabicCerqel(){
                    actionsBtn.setBackgroundImage(UIImage(named: "ActionsWthAr"), for: .normal)
                }else{
                    actionsBtn.setBackgroundImage(UIImage(named: "ActionsWthEn"), for: .normal)
                }
            }else{
                actionsBtn.isHidden = false
            }
        }
    }
    
    @IBAction func editRequestBtnTapped(_ sender: Any) {}
    
    @IBAction func actionsBtnClicked(_ sender: Any) {}
    
}
