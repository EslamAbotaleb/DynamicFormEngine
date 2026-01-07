//
//  UploadMediaTVcell.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 2/17/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit
/*
class UploadMediaTVcell: ControlTVcell {

    var isTimeOff: Bool = false
    
    @IBOutlet weak var ttlLbl: UILabel!
    @IBOutlet weak var attTV: UITableView!
    @IBOutlet weak var attTVHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIView!
    @IBOutlet weak var stackTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackLeadingConstraint: NSLayoutConstraint!
    
    var didTapAddAttachment: (()->())?
    var didRemoveAttachment: ((Int)->())?
    var arrayOfAttachment: [ModelUploadedMediaCerqel] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        attTV.register(MediaItemTVcell.cerqel_nib, forCellReuseIdentifier: MediaItemTVcell.cerqel_identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func configure(control: ModelControlCerqel) {
        
        self.controlData = control
        ttlLbl.text = control.label
        self.descriptionLbl.attributedText = control.description?.trimmingCharacters(in: .whitespacesAndNewlines).cerqel_convertHtmlToAttributedStringWithCSS(font: UIFont.SST_Arabic_Roman(ofSize: 10), csscolor: "blue_grey", lineheight: 20, csstextalign: isArabicCerqel() ? "right" : "left")

//        self.descriptionLbl.text = control.description ?? ""
        if let arr = control.value as? [ModelUploadedMediaCerqel]{
            self.arrayOfAttachment = arr
            attTV.reloadData()
        }
//        if arrayOfAttachment.count < control.filesNumber ?? 0{
//            addBtn.isHidden = false
//        }else{
//            addBtn.isHidden = true
//        }
        attTVHeighConstraint.constant = CGFloat(arrayOfAttachment.count * 60)
    }
    
    func configureTimeOffAttachmentUI(isTimeOff: Bool) {
        if isTimeOff {
            self.ttlLbl.text = "attachment".localized
            self.descriptionLbl.text = ""
            self.stackLeadingConstraint.constant = 30
            self.stackTrailingConstraint.constant = 30
        }
    }
        
     func configure(atts: [ModelUploadedMediaCerqel]) {
        self.ttlLbl.text = "attachment".localized
        self.arrayOfAttachment = atts
        attTV.reloadData()
        attTVHeighConstraint.constant = CGFloat(arrayOfAttachment.count * 60)
    }
    
    @IBAction func addAttachmentBtntTapped(){
        didTapAddAttachment?()
    }
}



extension UploadMediaTVcell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfAttachment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaItemTVcell.cerqel_identifier, for: indexPath) as! MediaItemTVcell
        cell.configure(arrayOfAttachment[indexPath.row])
        if isTimeOff {
            cell.viewTopConstraint.constant = 0
        }
        cell.didTapRemove = {
            print("remove Tapped")
            self.didRemoveAttachment?(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This is File Cell :D ")
    }
    
}
*/
