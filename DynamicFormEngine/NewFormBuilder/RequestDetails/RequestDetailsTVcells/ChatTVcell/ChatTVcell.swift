//
//  ChatTVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 1/27/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ChatTVcell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var senderImgView: MaskedImageView!
    @IBOutlet weak var senderNameLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var userTailImg: UIImageView!
    @IBOutlet weak var otherTailImg: UIImageView!
    
    @IBOutlet weak var attachmentContainer: UIView!
    @IBOutlet weak var attachmentTV: UITableView!
    @IBOutlet weak var attachmentTVHeightContraint: NSLayoutConstraint!

    
    var arrayOfAttachment: [dicussionAttachemnt]?{
        didSet{
            attachmentTV.reloadData()
        }
    }
    
    var attachmentTapped: ((String)-> ())?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
        attachmentTV.register(DownloadAttTvcell.cerqel_nib, forCellReuseIdentifier: DownloadAttTvcell.cerqel_identifier)
        
//        drawRoundedCorners(with: msgContainerView, cornerRadius: -200, direction: .leftBottom)
    }
    
    enum CornerDirection {
        case top
        case bottom
        case right
        case left
        case rightBottom
        case leftBottom
        case rightTop
        case leftTop
    }
    
    func drawRoundedCorners(with view: UIView, cornerRadius: CGFloat, direction: CornerDirection) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
        switch direction {
        case .top:
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .right:
            if isArabicCerqel() {
                view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            }else {
                view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
            }
        case .left:
            if isArabicCerqel() {
                view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
            }else {
                view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
            }
        case .rightBottom:
            if isArabicCerqel() {
                view.layer.maskedCorners = [.layerMinXMaxYCorner]
            }else {
                view.layer.maskedCorners = [.layerMaxXMaxYCorner]
            }
        case .leftBottom:
            if isArabicCerqel() {
                view.layer.maskedCorners = [.layerMaxXMaxYCorner]
            }else {
                view.layer.maskedCorners = [.layerMinXMaxYCorner]
            }
        case .rightTop:
            if isArabicCerqel() {
                view.layer.maskedCorners = [.layerMinXMinYCorner]
            }else {
                view.layer.maskedCorners = [.layerMaxXMinYCorner]
            }
        case .leftTop:
            if isArabicCerqel() {
                view.layer.maskedCorners = [.layerMaxXMinYCorner]
            }else {
                view.layer.maskedCorners = [.layerMinXMinYCorner]
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ item: ModelDicussionMessageData?, empMail: String){
        
        var dtLbl = ""
            dtLbl = setDateValue(item: item)
        
        if empMail.lowercased() == item?.employee?.email?.lowercased() {
            msgContainerView.backgroundColor = UIColor(hexString: "#F2F5FA")
            senderImgView.isHidden = true
            senderNameLbl.text = "\("You".localized) , \(dtLbl)"
            otherTailImg.isHidden = false
            userTailImg.isHidden = true
        }else {
            
            otherTailImg.isHidden = true
            userTailImg.isHidden = false
            
            senderNameLbl.text = "\(item?.employee?.name ?? "") , \(dtLbl)"
            
            msgContainerView.backgroundColor = .white
            msgContainerView.layer.shadowColor = UIColor.black.cgColor
            msgContainerView.layer.shadowOpacity = 10
            msgContainerView.layer.shadowOffset = .zero
            msgContainerView.layer.shadowRadius = 10
            
            senderImgView.isHidden = false
            
            senderImgView.cerqel_LoadImgWithUrl(imgUrl: (item?.employee?.photo ?? "").cerqel_CreateMediaURL(), brokenImgName: "avatar_Big") {[weak self] in
                self?.senderImgView.loadSVGImageWithAuth(urlString: (item?.employee?.photo ?? "").cerqel_CreateMediaURL(),
                                                          targetSize: CGSize(width: 36, height: 36))
            }
        }
        
        
        msgLbl.text = item?.comment
        
        if let att = item?.attachments, att.count > 0{
            attachmentContainer.isHidden = false
            attachmentTVHeightContraint.constant = CGFloat(att.count * 44)
            self.arrayOfAttachment = att
        }else{
            attachmentContainer.isHidden = true
        }
        

    }
    
    func setDateValue(item: ModelDicussionMessageData?) -> String {
        if let dt = item?.createdDate?.getDateFromString(){
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a" //"d MMM yyyy"
            formatter.amSymbol = "AM".localized
            formatter.pmSymbol = "PM".localized
            return formatter.string(from: dt)
        }else{
            return ""
        }
    }
    
}


extension ChatTVcell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAttachment?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadAttTvcell.cerqel_identifier, for: indexPath) as! DownloadAttTvcell
        cell.nameLbl.text = arrayOfAttachment?[indexPath.row].fileName ?? ""
        let att = arrayOfAttachment?[indexPath.row]
        if att?.attExtension?.lowercased() == "pdf".lowercased() {
            cell.attachIcon.image = UIImage(named: "pdff")
        }else{
            cell.attachIcon.image = UIImage(named: "jpeg")
        }
        cell.config(color: UIColor(hexString: "F2F2F6"), constraint: CGFloat(16))
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = attachmentTapped {
            action(arrayOfAttachment?[indexPath.row].id ?? "")
        }
    }
    
}

extension ChatTVcell {
    func configureUI() {
        containerView.backgroundColor = bg
    }
}
