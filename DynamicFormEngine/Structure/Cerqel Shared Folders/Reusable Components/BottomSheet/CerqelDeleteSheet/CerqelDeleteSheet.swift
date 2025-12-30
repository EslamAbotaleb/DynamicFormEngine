//
//  CerqelDeleteSheet.swift
//  CERQEL
//
//  Created by Ahmed Ezzat on 19/05/2024.
//  Copyright © 2024 Youxel. All rights reserved.
//

import UIKit
import PanModal

public typealias DeleteCallBack =  (()->())

public class DeleteItem: BaseItem {
    public var deleteCallBack: DeleteCallBack
    public var deleteTitle:String
    public var deleteMessage:String?
    public var deleteicon:String?
    public var deleteButtonTitle:String?
    public var cancelButtonTitle:String?
    public var deleteBtnColor:UIColor?

    public init(_ deleteCallBack: @escaping DeleteCallBack,_ deleteTitle: String,_ deleteMessage: String,_ deleteicon: String,_ deleteButtonTitle: String,_ cancelButtonTitle: String,_ deleteBtnColor: UIColor) {
        self.deleteCallBack = deleteCallBack
        self.deleteTitle = deleteTitle
        self.deleteMessage = deleteMessage
        self.deleteicon = deleteicon
        self.deleteButtonTitle = deleteButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        self.deleteBtnColor = deleteBtnColor 
    }
}

public class CerqelDeleteSheet: BaseView<FileActionsViewModel, DeleteItem> {
    @IBOutlet weak var sheetView: UIStackView!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var confirmationDeleteLbl: UILabel!
    @IBOutlet weak var deleteMsgLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
       
       override public func viewDidLoad() {
           super.viewDidLoad()
           configureUI()
           self.deleteIcon.image = UIImage(named: item.deleteicon ?? "")
           self.confirmationDeleteLbl.text = item.deleteTitle
           self.deleteMsgLbl.text = item.deleteMessage
           self.deleteBtn.setTitle(item.deleteButtonTitle, for: .normal)
           self.cancelBtn.setTitle(item.cancelButtonTitle, for: .normal)
        
       }
       
       @IBAction func closePressed(_ sender: Any) {
         
           dismiss(animated: true)
        
       }
       
       @IBAction func cancelPressed(_ sender: Any) {
   
           dismiss(animated: true)
       }
       
       @IBAction func deletePressed(_ sender: Any) {
     
           item.deleteCallBack()
       }
    override public var panScrollable: UIScrollView? {
        return nil
    }

    override public var longFormHeight: PanModalHeight {
        return .contentHeight(sheetView.bounds.height)

    }
   }

extension CerqelDeleteSheet {
    private func configureUI() {
        confirmationDeleteLbl.textColor = typographyTitle
        closeBtn.tintColor = primaryMain
        confirmationDeleteLbl.font = UIFont.bodyLMedium()
        deleteBtn.titleLabel?.font = UIFont.buttonLSemibold()
        deleteBtn.backgroundColor = item.deleteBtnColor
                
        cancelBtn.setCancelButtonTheme()

    }
}

