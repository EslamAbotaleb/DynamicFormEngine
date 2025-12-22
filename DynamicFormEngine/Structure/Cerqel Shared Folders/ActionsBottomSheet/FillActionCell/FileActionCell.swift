//
//  FileActionCell.swift
//  CERQEL
//
//  Created by ahmed maher on 13/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class FileActionCell: UITableViewCell {
   var isVisible : Bool = true
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var actionImageView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI(itemIsVisible: true)
    }
    
    func configure(_ file: FileActions , isVisible : Bool? , canDeleteImage : Bool?){
        if (isVisible != nil){
            self.isVisible = isVisible!
        }
        self.title.text = file.title
        self.actionImage.image = (file.image != nil) ?  UIImage(named: file.image!) : nil
        self.actionImageView.isHidden = file.image == nil
        if(file.id == 1 ){
            configureUI(itemIsVisible: self.isVisible)
        }
        if( file.id == 4){
            configureUI(itemIsVisible: canDeleteImage ?? true)
        }
        if file.id == 6 {
            setFileAcknowledgeStatus(file.fileAcknowledge!)
        }
//        if file.id == 7 {
//            setFilePinnedStatus(file.isPinned ?? false)
//        }
         
    }
    
    func configure(_ file: ListModel){
        self.title.text = file.name
    }
    
    
    private func setFilePinnedStatus(_ fileIsPinned: Bool) {
         guard fileIsPinned else {
             configureActionUI(disable: false)
             return
         }
        configureActionUI()
     }
    
   private func setFileAcknowledgeStatus(_ fileAcknowledgeStatus: FileAcknowledgeStatus) {
        guard fileAcknowledgeStatus.isAcknowledge else {
            configureActionUI()
            return
        }
         fileAcknowledgeStatus.isAcknowledged ?   configureActionUI() : configureActionUI(disable: false)
    }
    
    private func configureActionUI( disable: Bool = true) {
        self.title.textColor =  disable ?  UIColor(hexCerqel: "#D6DCE8") : typographySubtitle
        self.actionImage.tintColor = disable ?  UIColor(hexCerqel: "#D6DCE8") : typographySubtitle
        
        
    }
    
}
extension FileActionCell {
    private func configureUI(itemIsVisible : Bool) {
        title.font =  UIFont.bodyLRegular()
        title.textColor = itemIsVisible ? typographySubtitle : UIColor(hexCerqel: "#D6DCE8")
        self.actionImage.tintColor = itemIsVisible ?  typographySubtitle : UIColor(hexCerqel: "#D6DCE8")
        if(!itemIsVisible) {
            actionImage.setImageColor(color : UIColor(hexCerqel: "#D6DCE8")!)
        }

    }
}
