//
//  dbNewsCVcell.swift
//  CERQEL
//
//  Created by iSlam AbdelAziz on 28/10/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class dbNewsCVcell: UICollectionViewCell {
    
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var ttlLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: ModelNewsData?){
        if let date = item?.dateCreated?.getDateFromString(){
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            dateLbl.text = formatter.string(from: date)
        }else{
            dateLbl.text = ""
        }
        bgImgView.kf.indicatorType = .activity
        bgImgView.kf.setImage(with: URL(string: (item?.thumbnail?.url ?? "").CreateMediaURL()), placeholder: dummyEmptyImg)
        ttlLbl.text = item?.title


    }

}
