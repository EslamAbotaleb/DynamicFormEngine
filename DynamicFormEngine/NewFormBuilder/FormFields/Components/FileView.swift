//
//  FileView.swift
//  CHECK
//
//  Created by Yasser Osama on 15/11/2021.
//

import UIKit


class FileView: UIView {
    let contentXibName = "FileView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var fileIconImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
//    var fileData: FileData! {
//        didSet {
//            if let fileURLStr = fileData.urlString, let fileURL = URL(string: fileURLStr) {
//                fileNameLabel.text = fileURL.lastPathComponent
//                let fileExtension = fileURL.pathExtension.lowercased()
//                fileIconImageView.image = Self.getFileExtensionImage(fileExtension)
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(contentXibName, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    static func getFileExtensionImage(_ fileExtension: String) -> UIImage? {
        if fileExtension.contains("pdf") {
            return UIImage(named: "pdfIcon")
        } else if fileExtension.contains("doc") {
            return UIImage(named: "docIcon")
        } else if fileExtension.contains("xl") {
            return UIImage(named: "excelIcon")
        } else {
            return UIImage(named: "unknownFileIcon")
        }
    }
}
