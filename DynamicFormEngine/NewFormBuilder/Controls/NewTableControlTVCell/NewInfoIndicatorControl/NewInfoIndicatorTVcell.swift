//
//  NewInfoIndicatorTVcell.swift
//
//
//  Created by Hassan elshair on 20/02/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit

class NewInfoIndicatorTVcell: ParentFieldTableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var infoIndicateIcon: UIImageView!
    @IBOutlet weak var infoIndicateLbl: LocalizedLabel!
    @IBOutlet weak var infoContainer: UIView!
    
    
    // MARK: - Variables
    var isSectionItem = false
    var item: FormViewModelItem! {
        didSet {
            if let item = item as? FormViewModelParagraphItem {
                item.isSectionControl = isSectionItem
                contentView.backgroundColor = isSectionItem ? .white : .clear
                updateConstraintsForSectionItem(section: item.isSectionControl )
                guard let localization = item.localization as? ParagraphLocalization else { return }
                let value = isArabicCerqel() ?  localization["ar"]?.paragraphText :  localization["en"]?.paragraphText
                infoIndicateLbl.text = value
                
                if let style = item.paragraphStyle{
                    if let bGColor = style.backgroundColor{
                        self.infoContainer.backgroundColor = UIColor(hexString: bGColor)
                    }
                    if let txtColor = style.textColor{
                        self.infoIndicateLbl.textColor = UIColor(hexString: txtColor)
                    }
                    if let borderColor = style.borderColor{
                        self.infoContainer.layer.borderColor = UIColor(hexString: borderColor).cgColor
                    }
                }
                
                
                if let iconURL = item.icon{
                    self.infoIndicateIcon.cerqel_LoadImgWithUrl(imgUrl: (iconURL).cerqel_CreateMediaURL()) {[weak self] in
                        self?.infoIndicateIcon.loadSVGImageWithAuth(urlString: (iconURL).cerqel_CreateMediaURL(),
                                                                  targetSize: CGSize(width: 24, height: 24))
                    }
                }
            }
        }
    }
    
    private func updateConstraintsForSectionItem(section: Bool) {
        if section {
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
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
