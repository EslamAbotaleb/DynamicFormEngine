//
//  AcknowledgeVC.swift
//  CERQEL
//
//  Created by Mahmoud Elfooly on 17/07/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

public class AcknowledgeVC: BaseView<AcknowledgeViewModel, FileItem> {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkBoxImage: UIImageView!
    @IBOutlet weak var checkBoxTitlelabel: UILabel!
    @IBOutlet weak var cancelButton: LocalizedButton!
    @IBOutlet weak var submitButton: LocalizedButton!
    
    public  var isAgreedAcknowledge : Bool = false

    override public func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        setNavigationTitle( "Acknowledgement".localized)
        setupBackButton()
        setupUI()
    }
    

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func initialConfiguration(){
        viewModel = AcknowledgeViewModel(router: CerqelRouterManagerDynamicFormImpl(self), fileId: item.fileId)

        
    }

    public func setupUI(){
        textLabel.font = .bodyMRegular()
        checkBoxTitlelabel.font = .bodyMRegular()
        
        submitButton.setSubmitButtonTheme()
        cancelButton.setCancelButtonTheme()

        topView.backgroundColor = bg
        setSubmitButtonUI()
        setCheckBoxUI()
        generateRichText()
    }
    
    public func  setSubmitButtonUI(){
        if(isAgreedAcknowledge){
            submitButton.backgroundColor = primaryMain
            submitButton.isUserInteractionEnabled = true
        }
        else {
            submitButton.backgroundColor = .cerqelColorGray3
            submitButton.isUserInteractionEnabled = false
        }
    }
    
    public func setCheckBoxUI(){
        if(isAgreedAcknowledge){
            checkBoxImage.image = UIImage(named: "Checkbox Checked")
        }
        else {
            checkBoxImage.image = UIImage(named: "Checkbox Unchecked")
        }
    }
    
    public func generateRichText(){

        textLabel.textAlignment = isArabic() ? .right : .left
        textLabel.attributedText =
            NSMutableAttributedString()
            .normal("Please confirm that you have reviewed the uploaded file by checking the box below and clicking ".localized)
            .bold("“Submit ” ".localized)
            .normal(".\n By doing so, you agree to the information contained within the document. Contact the administrator if you have any questions.".localized)
    }
    
    @IBAction func checkBoxPressedButton(_ sender: UIButton) {
        isAgreedAcknowledge = !isAgreedAcknowledge
        setCheckBoxUI()
        setSubmitButtonUI()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        viewModel.popBack()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if(isAgreedAcknowledge){
            viewModel.acknowledgementEndPoint()
        }
    }

}
extension NSMutableAttributedString {
    public var fontSize:CGFloat { return 14 }
    public var boldFont:UIFont { return UIFont.bodyMRegular() }
    public var normalFont:UIFont { return UIFont.bodyMRegular()}

    public func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
            .foregroundColor : UIColor.black
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    public func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    public func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    public func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    public func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
