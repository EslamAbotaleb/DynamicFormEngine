//
//  BusinessCardVC.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 15/08/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class BusinessCardVC: CerqelBaseWireFrame<NewProfileViewModel> {
    

    @IBOutlet weak var cardTitleLbl: LocalizedLabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var downloadButton: LocalizedButton!
    @IBOutlet weak var userNameLabel: LocalizedLabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var personalPhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var personalImageView: UIView!
    @IBOutlet weak var closeIcon: UIButton!
    @IBOutlet weak var bussenissCardPicBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurUI()
        setCardData()

    }
    
    override func configure(with viewModel: NewProfileViewModel) {
        
    }
    
    
    func configurUI(){
        cardTitleLbl.text = "Business Card".localized
        cardView.layer.borderColor = UIColor.borderColor.cgColor
        downloadButton.tintColor = primaryMain
//        downloadButton.titleLabel?.font = .bodyLSemibold(ofSize: 18)
        dividerView.backgroundColor = primaryMain
        dividerView.alpha = 0.5
        cardTitleLbl.textColor = typographyTitle
        userMailLabel.textColor = typographyTitle
        userPhoneLabel.textColor = typographyTitle
//        jobTitleLabel.textColor = typographyBody
//        phoneLabel.textColor = typographyBody
//        emailLabel.textColor = typographyBody
        personalImageView.makeRounded(color: primaryMain, borderWidth: 0.58)
        closeIcon.tintColor = primaryMain
    }
    
    func setCardData(){
//        let basicInfo = viewModel.profile.value?.basicInfo
//        let jobDetails = viewModel.profile.value?.jobDetails
//        let contactInfo = viewModel.profile.value?.contactInfo
//        let medicalInsuranceInfo = viewModel.profile.value?.medicalInsuranceInfo

        let info = viewModel.profile.value

        self.userNameLabel.text = info?.name
        if(viewModel.profile.value?.photo != nil && viewModel.profile.value?.photo != ""){
            personalPhoto.cerqel_LoadImgWithUrl(imgUrl: (viewModel.profile.value?.photo ?? "").cerqel_CreateMediaURL(), brokenImgName: avatarImgNameCerqel)
        }
        else{
        handleImageWithKFCerqel(imgUrl: "", img: personalPhoto, name: viewModel.profile.value?.name ?? "", color: primaryMain.withAlphaComponent(0.1), textColor: primaryMain)
        }
        self.userMailLabel.text = info?.mail
        self.userPhoneLabel.text = info?.phone
        self.jobTitleLabel.text = info?.jobTitle
        self.qrCodeImage.image = UIImage(cgImage: viewModel.qrImage!)
        
    }
    
    func handleCardDownload(){
        if let image = convertViewToImage(cardView) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.dismiss(animated: true)
        }
    }
    
    func convertViewToImage(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        handleCardDownload()
    }
    
    @IBAction func bussinesCardViewPicBtn(_ sender: Any) {
        if(self.viewModel.profile.value?.photo != nil && self.viewModel.profile.value?.photo != ""){
            self.dismiss(animated: true)
            viewModel.viewProfilePhoto()
        }
    }
    
    
}
