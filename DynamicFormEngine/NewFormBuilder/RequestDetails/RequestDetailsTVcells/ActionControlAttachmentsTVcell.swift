//
//  ActionControlAttachmentsTVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 2/22/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit

class ActionControlAttachmentsTVcell: UITableViewCell {
    
    @IBOutlet weak var nameTitleLbl: UILabel!
    @IBOutlet weak var attTV: UITableView!
    @IBOutlet weak var attTVHeigfhtConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        attTV.register(DownloadAttTvcell.cerqel_nib, forCellReuseIdentifier: DownloadAttTvcell.cerqel_identifier)
    }
    
    var attList = [ReqDetailsAttachmentValue]()
    var mediaTapped: ((String)->())?
    var isSectionItem = false
    
    
    func configure(properties: BackwardProperties?) {
        attList = []
        contentView.backgroundColor = isSectionItem ? .white : .clear
        updateConstraintsForSectionItem()
        let localization = properties?.localization
        if !isArabicCerqel() {
            if let localizedLabel = localization?.en?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }else {
            if let localizedLabel = localization?.ar?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }
        if let val = properties?.defaultAnswer?.defaultValue {
            switch val {
            case .dictionary(let dicts):
                
                if !dicts.isEmpty {
                    for dict in dicts {
                        if let attachmentName = dict["attachmentName"], let attachmentId = dict["attachmentId"], let attachmentExtension = dict["attachmentExtension"] {
                            let attachment = ReqDetailsAttachmentValue(url: "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Preview/\(attachmentId)", attachmentName: attachmentName, attachmentExtension: attachmentExtension, attachmentDisplaySize: nil, fileId: attachmentId, size: "0")
                            self.attList.append(attachment)
                        }
                    }
                }
                self.attTV.reloadData()
                attTVHeigfhtConstraint.constant = CGFloat(attList.count * 46)
            case .file(let files):
                for retrievedFile in files {
                    let obj = ReqDetailsAttachmentValue(url: retrievedFile.fileUrl ,
                                                        attachmentName: retrievedFile.fileName,
                                                        attachmentExtension: retrievedFile.fileExtension,
                                                        attachmentDisplaySize: retrievedFile.attachmentDisplaySize,
                                                        fileId: retrievedFile.fileId,
                                                        size: retrievedFile.attachmentDisplaySize ?? "0")
                    self.attList.append(obj)
                }
                self.attTV.reloadData()
                attTVHeigfhtConstraint.constant = CGFloat(attList.count * 46)
            default:
                return
            }
        }
    }
    
    func configure(properties: Properties?) {
        attList = []
        contentView.backgroundColor = isSectionItem ? .white : .clear
        updateConstraintsForSectionItem()
        let localization = properties?.localization
        if !isArabicCerqel() {
            if let localizedLabel = localization?.en?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }else {
            if let localizedLabel = localization?.ar?.label, !localizedLabel.isEmpty {
                nameTitleLbl.text = localizedLabel
            } else {
                nameTitleLbl.text = properties?.label
            }
        }
        if let val = properties?.defaultAnswer?.defaultValue {
            switch val {
            case .dictionary(let dicts):
                
                if !dicts.isEmpty {
                    for dict in dicts {
                        if let attachmentName = dict["attachmentName"], let attachmentId = dict["attachmentId"], let attachmentExtension = dict["attachmentExtension"] {
                            let attachment = ReqDetailsAttachmentValue(url: "\(cerqel_Environment.Api_Base_URL)Storage/api/FileManager/Preview/\(attachmentId)", attachmentName: attachmentName, attachmentExtension: attachmentExtension, attachmentDisplaySize: nil, fileId: attachmentId, size: "0")
                            self.attList.append(attachment)
                        }
                    }
                }
                self.attTV.reloadData()
                attTVHeigfhtConstraint.constant = CGFloat(attList.count * 46)
            case .file(let files):
                for retrievedFile in files {
                    let obj = ReqDetailsAttachmentValue(url: retrievedFile.fileUrl ,
                                                        attachmentName: retrievedFile.fileName,
                                                        attachmentExtension: retrievedFile.fileExtension,
                                                        attachmentDisplaySize: retrievedFile.attachmentDisplaySize,
                                                        fileId: retrievedFile.fileId,
                                                        size: retrievedFile.attachmentDisplaySize ?? "0")
                    self.attList.append(obj)
                }
                self.attTV.reloadData()
                attTVHeigfhtConstraint.constant = CGFloat(attList.count * 46)
            default:
                return
            }
        }
    }
    private func updateConstraintsForSectionItem() {
        if isSectionItem {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        } else {
            contentView.translatesAutoresizingMaskIntoConstraints = true
            NSLayoutConstraint.deactivate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ActionControlAttachmentsTVcell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadAttTvcell.cerqel_identifier) as! DownloadAttTvcell
        let att = attList[indexPath.row]
        if att.attachmentExtension?.lowercased() == "pdf".lowercased() {
            cell.attachIcon.image = UIImage(named: "pdff")
        }else{
            cell.attachIcon.image = UIImage(named: "jpeg")
        }
        cell.nameLbl.text = attList[indexPath.row].attachmentName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        openAttachment(withURLString: (attList[indexPath.row].url ?? "").CreateMediaURL())
        if let action = mediaTapped {
            if let id = attList[indexPath.row].fileId, id != "" {
                action(id)
            }
        }
    }
    
}
