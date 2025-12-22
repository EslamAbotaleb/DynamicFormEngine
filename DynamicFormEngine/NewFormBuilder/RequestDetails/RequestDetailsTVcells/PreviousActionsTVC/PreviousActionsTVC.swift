//
//  PreviousActionsTVC.swift
// 
//
//  Created by Abdallah Elmahlawy on 1/3/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class PreviousActionsTVC: UITableViewCell {

    
    @IBOutlet weak var upperContentView: UIView!
    
    @IBOutlet weak var lowerContentView: UIView!
    
    @IBOutlet weak var empIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var depLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var processedAsLbl: UILabel!
    
    @IBOutlet weak var processDateLbl: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!

    @IBOutlet weak var attachmentsView: UIView!
    
    @IBOutlet weak var attachmentNameLbl: UILabel!
    
//    var attachment = PreviousActionsAttachments()
    override func awakeFromNib() {
        super.awakeFromNib()
        upperContentView.addNormalShadow()
        upperContentView.layer.cornerRadius = 10
        // Initialization code
    }
    
    func configure(_ oldAction: PreviousActions?){
//        let action = PreviousActions(id: "1", bpmTaskId: "1", taskOnUserName: "111", taskOnUserJobTitle: "111", taskOnUserDepartmentName: "111", taskOnUserPhoto: "111", taskOnUserEmail: "111", createdDate: "111", completionDate: "111", comment: "111", isCompleted: true, takenAction: TakenAction(id: "", name: "1", label: "11", actionTakenLabel: "11", styleCode: "GREEN", buttonStyleCode: "GREEN", actionCode: "11", isCommentRequired: false, isAttachmentRequired: false, isFormValidateBeforeExecuteActionRequired: false), attachments: [], isExpanded: true)
//        lowerContentView.isHidden = !(action.isExpanded ?? false)
//        
//        empIV.cerqel_LoadImgWithUrl(imgUrl: (action.taskOnUserPhoto ?? "").cerqel_CreateMediaURL())
//        nameLbl.text = action.taskOnUserName
//        depLbl.text = action.taskOnUserDepartmentName
//        statusLbl.text = action.takenAction?.actionTakenLabel
//        handleStatusColor(statusColor: action.takenAction?.styleCode ?? "")
//        if let date = action.completionDate?.getDateFromString(){
//            let formatter = DateFormatter()
//            formatter.dateFormat = "d MMM yyyy"
//            timeLbl.text = formatter.string(from: date)
//        }
//        
//        if let dt = action.completionDate?.getDateFromString(){
//            let time = getTimeDifference(dt: dt, includeDays: true, includeDaysIfCurrentIsLess: false)
//            
//            if let d = time.3{
//                timeLbl.text = d
//            }else if let h = time.0{
//                timeLbl.text = h
//            }else if let m = time.1{
//                timeLbl.text = m
//            }else if let _ = time.2{
//                timeLbl.text = "seconds ago".localized
//            }else if time.0 == nil, time.1 == nil, time.2 == nil , time.3 == nil{
//                let formatter = DateFormatter()
//                formatter.dateFormat = "d MMM yyyy"
//                timeLbl.text = formatter.string(from: dt)
//            }
//            
//        }
//                
//        processedAsLbl.text = action.taskOnUserDepartmentName
//        
//        commentLbl.text = action.comment ?? "  "
//        
//        if let date = action.createdDate?.getDateFromString(){
//            let formatter = DateFormatter()
//            formatter.dateFormat = "d MMM yyyy  h:mm a"
//            processDateLbl.text = formatter.string(from: date)
//        }
//        
//        if let attachment = action.attachments?.first{
//            attachmentsView.isHidden = false
//            attachmentNameLbl.text = attachment.fileName
//            self.attachment = attachment
//        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func downloadAttachmentBtnPressed(_ sender: Any) {
//        storeFile(withURLString: (attachment.url ?? "").CreateMediaURL(), fileName: attachment.fileName ?? "", fileExtension: attachment.attExtension ?? "")
    }
    
    
    func storeFile(withURLString: String, fileName: String, fileExtension: String) {
        guard let url = URL(string: withURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    func handleStatusColor(statusColor: String){
        switch statusColor {
        case "ORANGE":
            statusLbl.textColor = UIColor.squash
        case "GRAY":
            statusLbl.textColor = UIColor.blue_grey
        case "GREEN":
            statusLbl.textColor = UIColor.alertApprovedSuccess
        case "RED":
            statusLbl.textColor = #colorLiteral(red: 0.9450980392, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        default:
            statusLbl.textColor = UIColor.squash
        }
    }
    
}
