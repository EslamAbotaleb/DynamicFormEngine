//
//  AllServicesCollectionViewCell.swift
//  CERQEL
//
//  Created by Youxel on 25/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import DynamicFormEngine

class AllServicesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var servicesBody: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var servicesImage: UIImageView!
    
    var didTapFavBtn: ((_ serviceFrom: ServiceDestination,_ cellIndex: Int) -> ())?
    var serviceFrom: ServiceDestination?
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
    }
    func customFav(isGlobalSearch: Bool) {
        favImage.isHidden = isGlobalSearch
        favView.isHidden = isGlobalSearch
        favBtn.isHidden = isGlobalSearch
    }
    
    func configure(_ service: AllServicesDTO) {
        self.serviceTitle.text = service.name ?? ""
        setServiceDescriptionWithoutHTMLTags(service.description)
        let imageUrl = service.imageURL//?.replace(target: "Download", withString: "Preview")
        self.servicesImage.loadWebImageWithUrl(imageUrl: imageUrl ?? "") {[weak self] in
            self?.servicesImage.loadSVGImageWithAuth(urlString: imageUrl ?? "",
                                                      targetSize: CGSize(width: 60, height: 60))
        }
        self.favImage.tintColor = service.isFavorite ?? false ? #colorLiteral(red: 0.9250587821, green: 0.28805843, blue: 0.2918981016, alpha: 1) : #colorLiteral(red: 0.7411764264, green: 0.7411764264, blue: 0.7411764264, alpha: 1)
        
    }
    
    func configure(service: ServicesGlobalSearchEntity?) {
        self.serviceTitle.text = service?.name ?? ""
        setServiceDescriptionWithoutHTMLTags(service?.description)
        let imageUrl = service?.imageUrl?.replace(target: "Download", withString: "Preview")
        self.servicesImage.loadWebImageWithUrl(imageUrl: imageUrl ?? "") {[weak self] in
            self?.servicesImage.loadSVGImageWithAuth(urlString: imageUrl ?? "",
                                                      targetSize: CGSize(width: 60, height: 60))
        }
        self.favImage.tintColor = service?.isFavorite ?? false ? #colorLiteral(red: 0.9250587821, green: 0.28805843, blue: 0.2918981016, alpha: 1) : #colorLiteral(red: 0.7411764264, green: 0.7411764264, blue: 0.7411764264, alpha: 1)
    }
    
    func configureHome(_ service: ModelServicesCerqel, serviceFrom: ServiceDestination, index: Int) {
        self.tag = index
        self.serviceFrom = serviceFrom
        self.serviceTitle.text = service.name ?? ""
        setServiceDescriptionWithoutHTMLTags(service.description)
        let imageUrl = service.imageUrl//?.replace(target: "Download", withString: "Preview")
        self.servicesImage.loadWebImageWithUrl(imageUrl: imageUrl ?? "") {[weak self] in
            self?.servicesImage.loadSVGImageWithAuth(urlString: imageUrl ?? "",
                                                      targetSize: CGSize(width: 60, height: 60))
        }
        self.favImage.tintColor = service.isFavorite ?? false ? #colorLiteral(red: 0.9250587821, green: 0.28805843, blue: 0.2918981016, alpha: 1) : #colorLiteral(red: 0.7411764264, green: 0.7411764264, blue: 0.7411764264, alpha: 1)
    }
    
    
    @IBAction func likeBtnPressed(_ sender: Any) {
        didTapFavBtn?(self.serviceFrom ?? .allServices, self.tag)
    }
    
    private func setServiceDescriptionWithoutHTMLTags(_ description: String?) {
        guard let description else {
            servicesBody.text = ""
            return
        }
        self.servicesBody.text = description.withoutHTMLTags
    }
    
}

extension AllServicesCollectionViewCell {
    private func configureUI() {
        serviceTitle.font = UIFont.bodyMMedium()
        serviceTitle.textColor  = typographyTitle
        servicesBody.font = UIFont.caption3Regular()
        servicesBody.textColor = typographyBody
        
    }
}
