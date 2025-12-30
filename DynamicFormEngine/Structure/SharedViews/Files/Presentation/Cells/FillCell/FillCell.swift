//
//  FillCell.swift
//  CERQEL
//
//  Created by ahmed maher on 06/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import DynamicFormEngine

class FillCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var fileTitle: UILabel!
    @IBOutlet weak var fileExtension: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var fileCreatedDate: UILabel!
    @IBOutlet weak var fileLanguage: UILabel!
    @IBOutlet weak var fileStatusLabel: UILabel!
    @IBOutlet weak var sepratorLabel: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var fileSelectedImageView: UIView!
    @IBOutlet weak var fileSelectedImage: UIImageView!
    @IBOutlet weak var fileStatusView: UIView!
    @IBOutlet weak var pinView: UIImageView!
    @IBOutlet weak var moreView: UIImageView!
    
    var fileSelected: (()->())!
    var fileActionIsShown: (()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
    }
    
    func configure(_ file: FileModel,selectionMode: SelectionMode){
        self.fileTitle.text = file.title
        self.fileExtension.text =  file.fileExtension
        self.fileSize.text = file.fileSize
        self.fileCreatedDate.text = file.fileCreatedDate.formatDateString(currentFormat: Formatter.FileISoFormat, desiredFormat: Formatter.FileDateFormat)
        self.fileImage.image = setFileImage(file.fileType)
        self.fileSelectedImageView.isHidden = file.fileCheckbox.isAppear ? false : true
        self.fileSelectedImage.image = file.fileCheckbox.isSelected ? UIImage(named: "selected_checkbox") : UIImage(named: "unSelected_checkbox")
        self.fileLanguage.text = file.versionType
        self.pinView.isHidden = !file.isPinned
        self.moreView.isHidden = selectionMode == .appear
        setFileAcknowledgeStatus(file.fileAcknowledgeStatus)
    }
    
    func setFileImage(_ fileType: FileType) -> UIImage{
        switch fileType {
        case .pdf: return UIImage(named: "pdf") ?? UIImage()
        case .doc : return UIImage(named: "docx")  ?? UIImage()
        case .ppt : return UIImage(named: "ppt")  ?? UIImage()
        case .docx:  return UIImage(named: "docx")  ?? UIImage()
        case .pptx:  return UIImage(named: "ppt")  ?? UIImage()
        case .xls: return UIImage(named: "xls")  ?? UIImage()
        case .xlsx:  return UIImage(named: "xls")  ?? UIImage()
        default: return UIImage(named: "pdf") ?? UIImage()

            
        }
    }
    
    func setFileAcknowledgeStatus(_ fileAcknowledgeStatus: FileAcknowledgeStatus) {
        guard fileAcknowledgeStatus.isAcknowledge else {
            self.fileStatusView.isHidden = true
            return
        }
        self.fileStatusView.isHidden = false
        self.fileStatusLabel.text =  fileAcknowledgeStatus.title
        self.fileStatusView.backgroundColor = UIColor(hexCerqel: fileAcknowledgeStatus.color)
    }
    
    @IBAction func selectFile(_ sender: Any) {
        self.fileSelected()
    }
    
    @IBAction func showFileAction(_ sender: Any) {
        self.fileActionIsShown()
        
    }
}

extension FillCell {
    private func configureUI() {
        fileTitle.font = UIFont.bodyMMedium()
        fileTitle.textColor  = typographyTitle
        fileCreatedDate.font = UIFont.caption3Regular()
        fileCreatedDate.textColor = typographyBody
        fileSize.font = UIFont.caption3Regular()
        fileSize.textColor = typographyBody
        fileLanguage.font = UIFont.bodySRegular()
        fileLanguage.textColor = typographyBody
        fileStatusLabel.font = UIFont.caption3Regular()
        moreView.tintColor = primaryMain
    }
}
