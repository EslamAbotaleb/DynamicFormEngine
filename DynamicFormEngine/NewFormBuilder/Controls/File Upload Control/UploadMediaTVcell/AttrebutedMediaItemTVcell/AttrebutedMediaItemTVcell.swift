//
//  AttrebutedMediaItemTVcell.swift
// 
//
//  Created by Abdallah Elmahlawy on 11/01/2022.
//  Copyright © 2022 All rights reserved.
//

import UIKit

class AttrebutedMediaItemTVcell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewAttImgView: UIImageView!
    @IBOutlet weak var fullScreenAttBgView: UIView!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fileSizeLbl: UILabel!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var additionalPropertyView1: UIView!
    @IBOutlet weak var additionalPropertyTitle1: LocalizedLabel!
    @IBOutlet weak var additionalPropertyTF1: UITextField!
    
    @IBOutlet weak var additionalPropertyView2: UIView!
    @IBOutlet weak var additionalPropertyTitle2: LocalizedLabel!
    @IBOutlet weak var additionalPropertyTF2: UITextField!
    
    @IBOutlet weak var additionalPropertyView3: UIView!
    @IBOutlet weak var additionalPropertyTitle3: LocalizedLabel!
    @IBOutlet weak var additionalPropertyTF3: UITextField!
    
    
    @IBOutlet weak var additionalPropertyView4: UIView!
    @IBOutlet weak var additionalPropertyTitle4: LocalizedLabel!
    @IBOutlet weak var additionalPropertyTF4: UITextField!
    
    
    // MARK: - Variables
    
    var didTapRemove: (()->())?
    var didShowFullScreen: ((UIImage)->())?
    var didEditAddAdditionalProperties: (( Int, String)->())?
    var attImg: UIImage?
    var showThumbnail = false
    
    
    // MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Functions
    
    func configure(_ item: ModelUploadedMedia?, additionalPropertyArr: [AdditionalProperty], showThumbnail: Bool = false){
        fileNameLbl.text = item?.name
        fileSizeLbl.text = item?.fileSize
        attImg = item?.viewImage
        self.showThumbnail = showThumbnail
        if let img = item?.viewImage, showThumbnail{
            viewAttImgView.image = img
            viewAttImgView.contentMode  = .scaleAspectFill
            fullScreenAttBgView.isHidden = false
        }else{
            viewAttImgView.image = UIImage(named: "attachedFiles")
            viewAttImgView.contentMode  = .scaleAspectFit
            fullScreenAttBgView.isHidden = true

        }
        if additionalPropertyArr.count > 0{
            self.handleAdditionalPropertyViews(additionalPropertyArr: additionalPropertyArr)
        }
    }
    
    func handleAdditionalPropertyViews(additionalPropertyArr: [AdditionalProperty]) {
        for i in 0 ... additionalPropertyArr.count - 1{
            switch i {
            case 0:
                handleAdditionalPropertyView01(additionalProperty: additionalPropertyArr[i])
            case 1:
                handleAdditionalPropertyView02(additionalProperty: additionalPropertyArr[i])
            case 2:
                handleAdditionalPropertyView03(additionalProperty: additionalPropertyArr[i])
            default:
                handleAdditionalPropertyView04(additionalProperty: additionalPropertyArr[i])
            }
        }
    }
    
    func handleAdditionalPropertyView01(additionalProperty: AdditionalProperty) {
        additionalPropertyView1.isHidden = false
        additionalPropertyTitle1.text = additionalProperty.label
        additionalPropertyTF1.placeholder = additionalProperty.placeHolder
        additionalPropertyTF1.text = additionalProperty.value
        additionalPropertyTF1.isUserInteractionEnabled = !(additionalProperty.readOnly ?? false)
    }
    
    func handleAdditionalPropertyView02(additionalProperty: AdditionalProperty) {
        additionalPropertyView2.isHidden = false
        additionalPropertyTitle2.text = additionalProperty.label
        additionalPropertyTF2.placeholder = additionalProperty.placeHolder
        additionalPropertyTF2.text = additionalProperty.value
        additionalPropertyTF2.isUserInteractionEnabled = !(additionalProperty.readOnly ?? false)
    }
    
    func handleAdditionalPropertyView03(additionalProperty: AdditionalProperty) {
        additionalPropertyView3.isHidden = false
        additionalPropertyTitle3.text = additionalProperty.label
        additionalPropertyTF3.placeholder = additionalProperty.placeHolder
        additionalPropertyTF3.text = additionalProperty.value
        additionalPropertyTF3.isUserInteractionEnabled = !(additionalProperty.readOnly ?? false)
    }
    
    func handleAdditionalPropertyView04(additionalProperty: AdditionalProperty) {
        additionalPropertyView4.isHidden = false
        additionalPropertyTitle4.text = additionalProperty.label
        additionalPropertyTF4.placeholder = additionalProperty.placeHolder
        additionalPropertyTF4.text = additionalProperty.value
        additionalPropertyTF4.isUserInteractionEnabled = !(additionalProperty.readOnly ?? false)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func removeBtnTapped(){
        didTapRemove?()
    }
    
    @IBAction func showFullScreenBtnTapped(){
        
        if let img = attImg, showThumbnail {
            didShowFullScreen?(img)
        }
    }
    
}
extension AttrebutedMediaItemTVcell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.didEditAddAdditionalProperties?(textField.tag, textField.text ?? "")
    }

}
