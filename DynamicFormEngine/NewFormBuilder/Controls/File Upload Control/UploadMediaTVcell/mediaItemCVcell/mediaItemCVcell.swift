//
//  mediaItemCVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 12/06/2022.
//  Copyright © 2022 All rights reserved.
//

import UIKit
//import DRPLoadingSpinner

class mediaItemCVcell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ttlLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var loadingIndicator: DRPLoadingSpinner!

    
    // MARK: - Variables
    
    var didTapRemove: (()->())?
    var didTapPreview: (()->())?

    
    //MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadingIndicator.colorSequence = [.darkGreenBlue]
        loadingIndicator.startAnimating()
        
        self.semanticContentAttribute = isArabicCerqel() ? .forceRightToLeft : .forceLeftToRight
    }
    
    func configure(_ item: ModelUploadedMedia?){
        if let uploading = item?.isStillUploading{
            loadingIndicator.isHidden = !uploading
            removeBtn.isHidden = uploading

        }else{
            loadingIndicator.isHidden = true
            removeBtn.isHidden = false
        }
        
        ttlLbl.text = item?.name
        infoLbl.text = item?.fileSize ?? "" + "MB"
        if let type = item?.documentType{
            if type.lowercased().contains("pdf"){
                imgView.image = UIImage(named: "filesPdf")
            }else if type.lowercased().contains("jpg"){
                imgView.image = UIImage(named: "filesJpg")

            }else if type.lowercased().contains("png"){
                imgView.image = UIImage(named: "filesPng")

            }else if type.lowercased().contains("xl"){
                imgView.image = UIImage(named: "filesExcel")

            }else{
                imgView.image = UIImage(named: "filesPng")

            }
        }
    }

    
    // MARK: - IBActions
    
    @IBAction func removeBtnTapped(){
        didTapRemove?()
    }
    
    @IBAction func previewBtn(_ sender: Any) {
        didTapPreview?()
    }
    
}
