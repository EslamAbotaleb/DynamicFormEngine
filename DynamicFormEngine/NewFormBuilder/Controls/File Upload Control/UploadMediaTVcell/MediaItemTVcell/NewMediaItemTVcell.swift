//
//  MediaItemTVcell.swift
// 
//
//  Created by iSlam AbdelAziz on 2/17/21.
//  Copyright © 2021 All rights reserved.
//

import UIKit
internal import NicoProgress

class NewMediaItemTVcell: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var progressBar: NicoProgressBar!
    
    
    // MARK: - Variables
    
    var didTapRemove: (()->())?
    var item:UploadMediaUIModel?
    
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(_ item: UploadMediaUIModel?){
        self.item = item
        cancelBtn.tintColor = primaryMain
        deleteButton.tintColor = primaryMain
        deleteButton.layer.cornerRadius = 6
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor = primaryMain.cgColor

        fileNameLbl.isHidden = false
        progressBar.isHidden = false
        fileImageView.alpha = 0
        deleteButton.alpha = 0
        cancelBtn.alpha = 0
        
        switch item?.state {
            
        case .inProgress(_):
            fileNameLbl.isHidden = true
            progressBar.isHidden = false
            fileImageView.alpha = 0.3
            deleteButton.alpha = 0
            cancelBtn.alpha = 1
            progressBar.transition(to: .indeterminate)
            
        case .success:
            fileNameLbl.isHidden = false
            fileNameLbl.textColor = .black
            fileNameLbl.text = item?.uploadedMedia?.name
            progressBar.isHidden = true
            fileImageView.alpha = 1
            cancelBtn.alpha = 0
            deleteButton.alpha = 1

        case .failed:
            fileNameLbl.isHidden = false
            fileNameLbl.textColor = .redSupport
            fileNameLbl.text = "Something went wrong..."
            progressBar.isHidden = true
            fileImageView.alpha = 0.3
            cancelBtn.alpha = 0
            deleteButton.alpha = 1

        case .none:
            break
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func removeBtnTapped(){
        didTapRemove?()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        guard let item = self.item else {return}
        item.request?.cancel()
    }
}
