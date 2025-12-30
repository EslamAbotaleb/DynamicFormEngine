//
//  AllServicesCell.swift
//  CERQEL
//
//  Created by Youxel on 25/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import DynamicFormEngine

class AllServicesCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceTitle: UILabel!
    @IBOutlet weak var servicesBody: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var servicesImage: UIImageView!
    @IBOutlet weak var sepratorView: UIView!


    var didTapFavBtn: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        
    }
    
    func configure(_ service: AllServicesDTO) {
        self.serviceTitle.text = service.name ?? ""
        setServiceDescriptionWithoutHTMLTags(service.description)
        let imageUrl = service.imageURL//?.replace(target: "Download", withString: "Preview")
        self.servicesImage.loadWebImageWithUrl(imageUrl: imageUrl ?? "") {[weak self] in
            self?.servicesImage.loadSVGImageWithAuth(urlString: imageUrl ?? "",
                                                      targetSize: CGSize(width: 24, height: 24))
        }
        self.favImage.tintColor = service.isFavorite ?? false ? .red : .gray
    }
    
    private func setServiceDescriptionWithoutHTMLTags(_ description: String?) {
        guard let description else {
            servicesBody.text = ""
            return
        }
        self.servicesBody.text = description.withoutHTMLTags
    }
    


    @IBAction func likeBtnPressed(_ sender: Any) {
        didTapFavBtn?()

    }
  func configureUI(){
        serviceTitle.font = UIFont.bodyMMedium()
        serviceTitle.textColor  = typographyTitle
        servicesBody.font = UIFont.caption3Regular()
        servicesBody.textColor = typographyBody
    }
}
