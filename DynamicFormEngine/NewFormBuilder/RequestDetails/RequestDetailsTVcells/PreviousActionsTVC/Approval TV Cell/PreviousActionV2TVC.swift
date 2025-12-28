//
//  PreviousActionV2TVC.swift
//  KAFD
//
//  Created by Mohamed Karmout on 21/07/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
public import RxCocoa
internal import RxSwift

class PreviousActionV2TVC: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var senderImgView: MaskedImageView!

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPosition: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusLblContainerView: UIView!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var dashedView: UIView!
    
    @IBOutlet weak var attachmentsTV: UITableView!
    @IBOutlet weak var attachmentsContainerView: UIView!
    @IBOutlet weak var attachmentsTVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var controlsTV: UITableView!
    @IBOutlet weak var controlsTVContainerView: UIView!
//    @IBOutlet weak var controlsTVHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    
    var attachments: BehaviorRelay<[PreviousActionsAttachments]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    let attHeight = 40
//    let controlHeight = 80
    var attTapped: ((String)->())?
    
    var submittedControls: BehaviorRelay<[TaskSubmittedRowDataModel]> = BehaviorRelay(value: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCells()
        config()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
    
    // MARK: - Functions
    
    func setupCells() {
        attachmentsTV.register(DownloadAttTvcell.cerqel_nib, forCellReuseIdentifier: DownloadAttTvcell.cerqel_identifier)
        controlsTV.register(ActionControlTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlTVcell.cerqel_identifier)
    }
    
    func config() {
        attachments.subscribe(onNext: {[weak self] list in
            guard let `self` = self else {return}
            self.drawDashedView(list: list)
        }).disposed(by: disposeBag)
        
        submittedControls.subscribe(onNext: {[weak self] list in
            guard let `self` = self else {return}
//            self.controlsTVHeightConstraint.constant = CGFloat(list.count * self.controlHeight)
            self.controlsTV.reloadData()
            self.drawDottedLine(start: CGPoint(x: self.dashedView.bounds.minX, y: self.dashedView.bounds.minY), end: CGPoint(x: self.dashedView.bounds.minX, y: self.dashedView.bounds.height), view: self.dashedView)
            if !list.isEmpty {
                self.layoutIfNeeded()
                self.setNeedsLayout()
            }
        }).disposed(by: disposeBag)
    }
    
    func drawDashedView(list: [PreviousActionsAttachments]) {
        self.attachmentsTVHeightConstraint.constant = CGFloat(list.count * self.attHeight)
        self.attachmentsTV.reloadData()
        self.drawDottedLine(start: CGPoint(x: self.dashedView.bounds.minX, y: self.dashedView.bounds.minY), end: CGPoint(x: self.dashedView.bounds.minX, y: self.dashedView.bounds.height), view: self.dashedView)
        if !list.isEmpty {
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    func configure(_ action: PreviousActions?){
        senderImgView.cerqel_LoadImgWithUrl(imgUrl: (action?.taskOnUserPhoto ?? "").cerqel_CreateMediaURL(), brokenImgName: "avatar_Big") {[weak self] in
            self?.senderImgView.loadSVGImageWithAuth(urlString: action?.taskOnUserPhoto ?? "",
                                                      targetSize: CGSize(width: 24, height: 24))
        }
        userNameLbl.text = action?.taskOnUserName ?? ""
        userPosition.text = action?.taskOnUserJobTitle ?? ""
        let formatter = DateFormatter()
        if isArabic() {
            formatter.locale = Locale(identifier: "ar")
        } else {
            formatter.locale = Locale(identifier: "en")
        }
        formatter.dateFormat = "dd/MM/yyyy  h:mm a"
        if let date = action?.completionDate?.getDateFromString(){
            dateLbl.text = formatter.string(from: date)
        }else {
            dateLbl.text = formatter.string(from: Date())
        }
        statusLbl.text = action?.takenAction?.actionTakenLabel ?? ""
        handleStatus(action: action)
        if let comment = action?.comment, comment != "" {
            commentContainerView.isHidden = false
            commentLbl.text = comment
        }else {
            commentContainerView.isHidden = true
        }
        
        if let atts = action?.attachments, atts.count > 0 {
            attachmentsContainerView.isHidden = false
            attachments.accept(atts)
        }else {
            attachmentsContainerView.isHidden = true
        }
        let string = action?.taskSubmittedRowDataJson ?? ""
        let data = string.data(using: .utf8)!
        
        do {
            let jsonArray = try JSONDecoder().decode([TaskSubmittedRowDataModel].self, from: data)
            if jsonArray.count > 0 {
                self.controlsTVContainerView.isHidden = false
                self.submittedControls.accept(jsonArray)
            }else {
                self.controlsTVContainerView.isHidden = true
            }
        } catch {
            print(error)
        }
    }
    
    private func handleStatus(action: PreviousActions?) {
        if let statusCode = action?.takenAction?.actionCode, let status = StatusCode(rawValue: statusCode.lowercased()) {
            statusLbl.textColor = status.textColor
            statusLblContainerView.backgroundColor = status.backgroundColor
            return
        }
        
        if let statusColorString = action?.takenAction?.styleCode, let statusColor = StatusColor(rawValue: statusColorString) {
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
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(hexString: "#9385A8").cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p1, p0])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
}

extension PreviousActionV2TVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attachmentsTV {
            return attachments.value.count
        }else {
            return submittedControls.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == attachmentsTV {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadAttTvcell.cerqel_identifier, for: indexPath) as? DownloadAttTvcell else {return UITableViewCell()}
            cell.nameLbl.text = attachments.value[indexPath.row].fileName
            let att = attachments.value[indexPath.row]
            if att.attExtension?.lowercased() == "pdf".lowercased() {
                cell.attachIcon.image = UIImage(named: "pdff")
            }else{
                cell.attachIcon.image = UIImage(named: "jpeg")
            }
            cell.config(color: UIColor(hexString: "F2F2F6"), constraint: CGFloat(16))
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlTVcell.cerqel_identifier, for: indexPath) as? ActionControlTVcell else {return UITableViewCell()}
            cell.config(jsonArray: submittedControls.value[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView == attachmentsTV else {return}
        if let action = attTapped {
            action(attachments.value[indexPath.row].fileId ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == attachmentsTV {
            return CGFloat(attHeight)
        }else {
            return UITableView.automaticDimension  //CGFloat(controlHeight)
        }
    }
}
