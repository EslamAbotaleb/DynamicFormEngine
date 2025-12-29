//
//  FeedbackBottomSheetView.swift
//  CERQEL
//
//  Created by Muhammed Sabri on 25/12/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit
import PanModal

class SurveyItem: BaseItem {
    var successCallBack: SuccessCallBack
    var serviceId: String?
    var requestOrder: String?

    init(_ successCallBack: @escaping SuccessCallBack,serviceId: String?, requestOrder: String?) {
        self.successCallBack = successCallBack
        self.serviceId = serviceId
        self.requestOrder = requestOrder
    }
}

class FeedbackBottomSheetView: BaseView<FeedbackViewModel, SurveyItem> {

    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var giveYourFeedbackBtn: LocalizedButton!
    @IBOutlet weak var successContainerView: UIView!
    @IBOutlet weak var submitContainerView: UIView!
    @IBOutlet weak var colseBtn: UIButton!
    @IBOutlet weak var successfullyMessageLbl: LocalizedLabel!
    @IBOutlet weak var successfullySubmitView: UIView!
    @IBOutlet weak var excellentStackView: UIStackView!
    @IBOutlet weak var excellentImage: UIImageView!
    @IBOutlet weak var excellentLbl: LocalizedLabel!
    @IBOutlet weak var goodStackV: UIStackView!
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var goodLbl: LocalizedLabel!
    @IBOutlet weak var okayStackV: UIStackView!
    @IBOutlet weak var okayImage: UIImageView!
    @IBOutlet weak var okayLbl: LocalizedLabel!
    @IBOutlet weak var badStackV: UIStackView!
    @IBOutlet weak var badImage: UIImageView!
    @IBOutlet weak var badLbl: LocalizedLabel!
    @IBOutlet weak var veryBadStackV: UIStackView!
    @IBOutlet weak var veryBadImage: UIImageView!
    @IBOutlet weak var veryBadLbl: LocalizedLabel!
    @IBOutlet weak var noteTxtView: UITextView!
    @IBOutlet weak var placeHolderLbl: LocalizedLabel!
    @IBOutlet weak var txtViewContainer: UIView!
    @IBOutlet weak var submitBtn: LocalizedButton!
    @IBOutlet weak var submitYourFeedbackErrorLbl: LocalizedLabel!
    @IBOutlet weak var submitYourNoteErrorLbl: LocalizedLabel!
    @IBOutlet weak var bottomSheetHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAllServicesBtn: LocalizedButton!
    
    
    weak var delegate: PopViewControllerDelegate?


  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initialConfiguration()
        handleObservation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        item.successCallBack()
    }

    private func initialConfiguration(){
        viewModel = FeedbackViewModel(router: CerqelRouterManagerDynamicFormImpl(self), surveyUseCase: SurveyUseCaseImpl(),surveyItem: item)
    }
    
    private func handleObservation() {
        viewModel.isFullScreen.bind { isFullScreen in
            self.panModalSetNeedsLayoutUpdate()
            isFullScreen ? self.panModalTransition(to: .shortForm) : self.panModalTransition(to: .longForm)
            
        }
    }
    

    private func configureUI() {
        setupTapGestureViews()
        noteTxtView.delegate = self
        noteTxtView.textAlignment = isArabic() ? .right : .left
        [excellentImage,goodImage,okayImage,badImage,veryBadImage].forEach { img in
            img?.tintColor = defaultGrayColor
        }
        
        [excellentLbl,goodLbl,okayLbl,badLbl,veryBadLbl].forEach { lbl in
            lbl?.tintColor = typographyBody
            lbl?.font = UIFont.bodySSemibold()
            lbl?.textAlignment = isArabicCerqel() ? .right : .left
        }
        self.giveYourFeedbackBtn.contentHorizontalAlignment = isArabic() ? .right : .left
        self.successfullyMessageLbl.text = isArabic() ? ("لقد تم إرسال طلبك" + " \"\(item.requestOrder ?? "")\" " + "بنجاح" ) : ("Your request" + " \"\(item.requestOrder ?? "")\" " + "has been Submitted successfully")
        
        self.giveYourFeedbackBtn.setTitleColor(primaryMain, for: .normal)
    }
    

    override var longFormHeight: PanModalHeight {
        guard viewModel.isFullScreen.value else {
            return .contentHeight(320)
        }
        return .maxHeight

    }
    
    override var shortFormHeight: PanModalHeight {
        guard viewModel.isFullScreen.value else {
            return .contentHeight(320)
        }
        return .maxHeight

    }
    
   
    
    override var panScrollable: UIScrollView? {
        return nil
    }
    
    override open var allowsExtendedPanScrolling: Bool { return false }
    override open var allowsDragToDismiss: Bool { return true }
    override open var allowsTapToDismiss: Bool { return true  }
    
    @IBAction func viewAllServicesBtn(_ sender: Any) {
        self.dismiss(animated: true)
//        item.successCallBack()
        print("Viea All Services")
    }

}

//MARK: Actions
extension FeedbackBottomSheetView {
    
    @IBAction func giveYourFeedbackBtn(_ sender: UIButton) {

//        self.viewModel.isFullScreen.value = true
//
//        UIView.animate(withDuration: 4.0, animations: {
//            self.submitContainerView.transform = .identity
//            self.view.layoutIfNeeded()
//        }) { finished in
//            self.submitContainerView.isHidden = false
//            self.giveYourFeedbackBtn.isEnabled = false
//            self.giveYourFeedbackBtn.contentHorizontalAlignment = isArabic() ? .right : .left
//        }
    
    }
    
    
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true)
//        item.successCallBack()
    }
        
    @IBAction func submitBtn(_ sender: UIButton) {
        viewModel.callSurveyEndPoint(serviceId: item.serviceId ?? "",  comment: noteTxtView.text!,complition: ifSubmittedSuccessfully)

    }
    private func ifSubmittedSuccessfully(){
        UIView.animate(withDuration: 4.0, animations: {
            self.submitContainerView.transform = .identity
            self.view.layoutIfNeeded()
        }) { finished in
            self.submitContainerView.isHidden = true
            self.giveYourFeedbackBtn.isEnabled = false
            self.giveYourFeedbackBtn.isHidden = true
            self.successfullySubmitView.isHidden = false
            self.successfullyMessageLbl.text = "Your Feedback has been submitted Successfully".localized
        }
        
        self.viewModel.isFullScreen.value = false
        self.view.endEditing(true)
    }
}




extension FeedbackBottomSheetView : UIGestureRecognizerDelegate {
    func setupTapGestureViews() {
        let excellentViewTap = UITapGestureRecognizer(target: self, action: #selector(self.excellentViewHandleTap(_:)))
        excellentStackView.addGestureRecognizer(excellentViewTap)
        
        let goodViewTap = UITapGestureRecognizer(target: self, action: #selector(self.goodViewHandleTap(_:)))
        goodStackV.addGestureRecognizer(goodViewTap)
        
        let okayViewTap = UITapGestureRecognizer(target: self, action: #selector(self.okayViewHandleTap(_:)))
        okayStackV.addGestureRecognizer(okayViewTap)
        
        let badViewTap = UITapGestureRecognizer(target: self, action: #selector(self.badViewHandleTap(_:)))
        badStackV.addGestureRecognizer(badViewTap)
        
        let veryBadViewTap = UITapGestureRecognizer(target: self, action: #selector(self.veryBadViewHandleTap(_:)))
        veryBadStackV.addGestureRecognizer(veryBadViewTap)
    }
    
    @objc func excellentViewHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        changeEmojiViewsColors(tag: 5, isSubmitBtnEnabled: true)
    }
    
    @objc func goodViewHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        changeEmojiViewsColors(tag: 4, isSubmitBtnEnabled: true)
    }
    
    @objc func okayViewHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        changeEmojiViewsColors(tag: 3, isSubmitBtnEnabled: placeHolderLbl.isHidden)
    }
    
    @objc func badViewHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        changeEmojiViewsColors(tag: 2, isSubmitBtnEnabled: placeHolderLbl.isHidden)
    }
    
    @objc func veryBadViewHandleTap(_ sender: UITapGestureRecognizer? = nil) {
        changeEmojiViewsColors(tag: 1, isSubmitBtnEnabled: placeHolderLbl.isHidden)
    }
    
    func changeEmojiViewsColors(tag: Int,isSubmitBtnEnabled: Bool) {
        
        placeHolderLbl.text = "Please share details of your experience regarding the service provided".localized
        
        viewModel.rating = tag
        print("tag \(tag),rating \(viewModel.rating) ")

        submitBtn.isUserInteractionEnabled = true
        submitBtn.backgroundColor = primaryMain
        
        excellentLbl.textColor = tag == 5 ? .alertApprovedSuccess : defaultGrayColor
        excellentImage.tintColor = tag == 5 ? .alertApprovedSuccess : defaultGrayColor
        
        goodLbl.textColor = tag == 4 ? .supportGreen : defaultGrayColor
        goodImage.tintColor = tag == 4 ? .supportGreen : defaultGrayColor
        
        okayLbl.textColor = tag == 3 ? .supportYellow : defaultGrayColor
        okayImage.tintColor = tag == 3 ? .supportYellow : defaultGrayColor
        
        badLbl.textColor = tag == 2 ? .supportOrange : defaultGrayColor
        badImage.tintColor = tag == 2 ? .supportOrange : defaultGrayColor
        
        veryBadLbl.textColor = tag == 1 ? .alertErrorColor : defaultGrayColor
        veryBadImage.tintColor = tag == 1 ? .alertErrorColor : defaultGrayColor
        
        if isSubmitBtnEnabled {
            submitBtn.isUserInteractionEnabled = true
            submitBtn.backgroundColor = primaryMain
            txtViewContainer.setBorder(color: defaultGrayColor, radius: 8)
            submitYourNoteErrorLbl.isHidden = true
            submitYourFeedbackErrorLbl.isHidden = true
        }else {
            submitBtn.isUserInteractionEnabled = false
            submitBtn.backgroundColor = defaultGrayColor
            txtViewContainer.setBorder(color: .red, radius: 8)
            submitYourNoteErrorLbl.isHidden = false
        }

    }
}

extension FeedbackBottomSheetView : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLbl.isHidden = !textView.text.isEmpty
        
        if placeHolderLbl.isHidden {
            if viewModel.rating != 0 {
                submitBtn.isUserInteractionEnabled = true
                submitBtn.backgroundColor = primaryMain
                txtViewContainer.setBorder(color: defaultGrayColor, radius: 8)
                submitYourNoteErrorLbl.isHidden = true
            }
        }
        else {
            if viewModel.rating == 4 || viewModel.rating == 5 {
                submitBtn.isUserInteractionEnabled = true
                submitBtn.backgroundColor = primaryMain
                txtViewContainer.setBorder(color: defaultGrayColor, radius: 8)
                submitYourNoteErrorLbl.isHidden = true
            }else {
                submitBtn.isUserInteractionEnabled = false
                submitBtn.backgroundColor = defaultGrayColor
                txtViewContainer.setBorder(color: .red, radius: 8)
                submitYourNoteErrorLbl.isHidden = false
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
    }
}
