//
//  CerqelReusableHeader.swift
//  CERQEL
//
//  Created by Marwan on 14/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
import SideMenu

public protocol CerqelFilterV {
     func hideFilter()
}

public protocol CerqelSearchInNewController {
     func disableSearch()
}

@IBDesignable
public class CerqelReusableHeader: UIView, CerqelFilterV, CerqelSearchInNewController {
        
    public func hideFilter() {
        filterButton.isHidden = true
        filterV.isHidden = true
//        buttonsStackV.isHidden = true
    }
    
    public func disableSearch() {
        searchBtn.isHidden = false
    }

    @IBOutlet private weak var searchIcon: UIImageView!
    @IBOutlet private weak var radioButtonsContainer: UIStackView!
    @IBOutlet private weak var searchBarContainerV: UIView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var firstButton: UIButton!
    @IBOutlet private weak var secondButton: UIButton!
    @IBOutlet private weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak public var searchTF: UITextField!
    @IBOutlet private weak var redDotImageView: UIImageView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var clearView: UIView!
    @IBOutlet weak public var buttonsView: UIView!
    @IBOutlet weak public var searchNewVBtn: UIButton!
    @IBOutlet weak public var filterV: UIView!
    @IBOutlet weak public var buttonsStackV: UIStackView!
    @IBOutlet weak public var closeImgV: UIImageView!
    @IBOutlet weak public var searchBtn: UIButton!
    
    @IBInspectable public var firstButtonTitle: String = "First" {
        didSet {
            firstButton.setTitle(firstButtonTitle.localized, for: .normal)
        }
    }
    
    @IBInspectable public var secondButtonTitle: String = "Second" {
        didSet {
            secondButton.setTitle(secondButtonTitle.localized, for: .normal)
        }
    }
    
    @IBInspectable public var thirdButtonTitle: String = "Third" {
        didSet {
            thirdButton.setTitle(thirdButtonTitle.localized, for: .normal)
        }
    }
    @IBInspectable public var fourthButtonTitle: String = "Fourth" {
        didSet {
            fourthButton.setTitle(fourthButtonTitle.localized, for: .normal)
        }
    }

    
    /// closure to be set in the view controller
    public var didChangeSearchText: ((String?) -> ())?
    public var didTapFilterButton: (() -> ())?
    public var didTapFirstRadioButton: (() -> ())?
    public var didTapSecondRadioButton: (() -> ())?
    public var didTapThirdRadioButton: (() -> ())?
    public var didTapFourthRadioButton: (() -> ())?
    public var didSearchNewViewButton: (() -> ())?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CerqelReusableHeader", owner: self)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchTF.delegate = self
        searchTF.attributedPlaceholder = NSAttributedString(string: "Search".localized, attributes: [NSAttributedString.Key.foregroundColor : typographyBody])
        searchTF.addTarget(self, action: #selector(searchTextDidChange(_:)), for: .editingChanged)

        filterV.layer.cornerRadius = 10
        filterV.layer.borderWidth = 1
        searchBarContainerV.layer.cornerRadius = 10
        searchBarContainerV.layer.borderWidth = 1
        filterV.layer.borderColor = UIColor.borderColorCerqel.cgColor
        searchBarContainerV.layer.borderColor = UIColor.borderColorCerqel.cgColor

        clearView.isHidden = true
        searchTF.textAlignment = isArabicCerqel() ? .right : .left
        searchTF.addTarget(self, action: #selector(didChange(textField:)), for: .editingChanged)
        thirdButton.isHidden = true // third button is initially hidden
        fourthButton.isHidden = true // fourth button is initially hidden
        configureUI()
    }
    
    @objc final private func didChange(textField: UITextField) {
        DispatchQueue.main.cerqel_asyncDeduped(target: self, after: 1) {
            var searchText = textField.text!
                .trimmingCharacters(in: .whitespacesAndNewlines)
            searchText = textField.text!.trimmingCharacters(in: .init(charactersIn: "[ !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+’"))
            textField.text = searchText
            self.didChangeSearchText?(searchText)
            if searchText.count == 0 {
                textField.resignFirstResponder()
            }
        }
        
    }
    
    public func hideRadioBtns() {
        buttonsView.isHidden = true
    }
    
    public func hideSearchBar() {
        searchBarContainerV.isHidden = true
    }
    
    public func showRedDot(show: Bool) {
        redDotImageView.isHidden = !show
    }

    public func handleClearViewVisibilty(show: Bool) {
        clearView.isHidden = !show
    }

    
    public func showThirdButton(show: Bool) {
        thirdButton.isHidden = !show
    }
    public  func showFourthButton(show: Bool) {
        fourthButton.isHidden = !show
    }
    @objc private func searchTextDidChange(_ textField: UITextField) {
        updateSearchView()
    }
    
    private func updateSearchView() {
        let textIsEmpty = (searchTF.text ?? "").isEmpty
        searchBarContainerV.layer.borderColor = textIsEmpty ? UIColor.borderColorCerqel.cgColor : primaryMain.cgColor
        searchIcon.tintColor = textIsEmpty ? .textPlaceholderGrayDarkCerqel : primaryMain
        clearView.isHidden = textIsEmpty
//        buttonsStackV.isHidden = textIsEmpty
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        didTapFilterButton?()
    }
    
    @IBAction func firstButtonTapped(_ sender: UIButton) {
        didTapFirstRadioButton?()
        firstButton.titleLabel?.font = .bodyLMedium()
        firstButton.titleLabel?.textColor = .white
        firstButton.setTitleColor(.white, for: .normal)
        firstButton.backgroundColor = primaryMain
        
        secondButton.titleLabel?.font = .bodyLMedium()
        secondButton.titleLabel?.textColor = typographyBody
        secondButton.setTitleColor(typographyBody, for: .normal)
        secondButton.backgroundColor = .clear
        
        thirdButton.titleLabel?.font = .bodyLMedium()
        thirdButton.titleLabel?.textColor = typographyBody
        thirdButton.setTitleColor(typographyBody, for: .normal)
        thirdButton.backgroundColor = .clear

        fourthButton.titleLabel?.font = .bodyLMedium()
        fourthButton.titleLabel?.textColor = typographyBody
        fourthButton.setTitleColor(typographyBody, for: .normal)
        fourthButton.backgroundColor = .clear
        
        radioButtonsContainer.bringSubviewToFront(firstButton)
    }
    
    @IBAction func secondButtonTapped(_ sender: UIButton) {
        didTapSecondRadioButton?()
        firstButton.titleLabel?.font = .bodyLMedium()
        firstButton.titleLabel?.textColor = typographyBody
        firstButton.setTitleColor(typographyBody, for: .normal)
        firstButton.backgroundColor = .clear
        
        secondButton.titleLabel?.font = .bodyLMedium()
        secondButton.titleLabel?.textColor = .white
        secondButton.setTitleColor(.white, for: .normal)
        secondButton.backgroundColor = primaryMain
        
        thirdButton.titleLabel?.font = .bodyLMedium()
        thirdButton.titleLabel?.textColor = typographyBody
        thirdButton.setTitleColor(typographyBody, for: .normal)
        thirdButton.backgroundColor = .clear
        
        fourthButton.titleLabel?.font = .bodyLMedium()
        fourthButton.titleLabel?.textColor = typographyBody
        fourthButton.setTitleColor(typographyBody, for: .normal)
        fourthButton.backgroundColor = .clear
        
        radioButtonsContainer.bringSubviewToFront(secondButton)
    }
    
    @IBAction func thirdButtonTapped(_ sender: UIButton) {
        didTapThirdRadioButton?()
        firstButton.titleLabel?.font = .bodyLMedium()
        firstButton.titleLabel?.textColor = typographyBody
        firstButton.setTitleColor(typographyBody, for: .normal)
        firstButton.backgroundColor = .clear
        
        secondButton.titleLabel?.font = .bodyLMedium()
        secondButton.titleLabel?.textColor = typographyBody
        secondButton.setTitleColor(typographyBody, for: .normal)
        secondButton.backgroundColor = .clear
        
        thirdButton.titleLabel?.font = .bodyLMedium()
        thirdButton.titleLabel?.textColor = .white
        thirdButton.setTitleColor(.white, for: .normal)
        thirdButton.backgroundColor = primaryMain
        
        fourthButton.titleLabel?.font = .bodyLMedium()
        fourthButton.titleLabel?.textColor = typographyBody
        fourthButton.setTitleColor(typographyBody, for: .normal)
        fourthButton.backgroundColor = .clear
        
        radioButtonsContainer.bringSubviewToFront(thirdButton)
        
    }
    @IBAction func fourthButtonTapped(_ sender: Any) {
        didTapFourthRadioButton?()
        firstButton.titleLabel?.font = .bodyLMedium()
        firstButton.titleLabel?.textColor = typographyBody
        firstButton.setTitleColor(typographyBody, for: .normal)
        firstButton.backgroundColor = .clear
        
        secondButton.titleLabel?.font = .bodyLMedium()
        secondButton.titleLabel?.textColor = typographyBody
        secondButton.setTitleColor(typographyBody, for: .normal)
        secondButton.backgroundColor = .clear
        
        thirdButton.titleLabel?.font = .bodyLMedium()
        thirdButton.titleLabel?.textColor = typographyBody
        thirdButton.setTitleColor(typographyBody, for: .normal)
        thirdButton.backgroundColor = .clear
        
        fourthButton.titleLabel?.font = .bodyLMedium()
        fourthButton.titleLabel?.textColor = .white
        fourthButton.setTitleColor(.white, for: .normal)
        fourthButton.backgroundColor = primaryMain
        
        radioButtonsContainer.bringSubviewToFront(fourthButton)
    }
    @IBAction func clearTapped(_ sender: UIButton) {
        searchTF.text = ""
        searchTF.resignFirstResponder()
        updateSearchView()
        didChangeSearchText?("")
    }
    
    @IBAction func searchBtnIsPressed(_ sender: Any) {
        didSearchNewViewButton?()
    }
    
}

extension CerqelReusableHeader: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var searchText = textField.text!
            .trimmingCharacters(in: .whitespacesAndNewlines)
        searchText = textField.text!.trimmingCharacters(in: .init(charactersIn: "[ !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+’"))
        textField.text = searchText
        textField.resignFirstResponder()
        self.didChangeSearchText?(searchText)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: textField.text!) as NSString
        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
        
    }
}

extension CerqelReusableHeader {
    private func configureUI() {
        redDotImageView.tintColor = UIColor.error_Cerqel
        closeImgV.tintColor = primaryMain
        filterButton.tintColor = primaryMain
        firstButton.titleLabel?.font = UIFont.bodyLMedium()
        secondButton.titleLabel?.font = UIFont.bodyLMedium()
        thirdButton.titleLabel?.font = UIFont.bodyLMedium()
        fourthButton.titleLabel?.font = UIFont.bodyLMedium()
        searchTF.font = UIFont.bodyMRegular()
        
        firstButton.titleLabel?.font = .bodyLMedium()
        firstButton.backgroundColor = primaryMain
        firstButton.titleLabel?.textColor = .white
        firstButton.setTitleColor(.white, for: .normal)
        
        secondButton.titleLabel?.font = .bodyLMedium()
        secondButton.titleLabel?.textColor = typographyBody
        secondButton.setTitleColor(typographyBody, for: .normal)
        secondButton.backgroundColor = .clear
        
        thirdButton.titleLabel?.font = .bodyLMedium()
        thirdButton.titleLabel?.textColor = typographyBody
        thirdButton.setTitleColor(typographyBody, for: .normal)
        thirdButton.backgroundColor = .clear
        
        fourthButton.titleLabel?.font = .bodyLMedium()
        fourthButton.titleLabel?.textColor = typographyBody
        fourthButton.setTitleColor(typographyBody, for: .normal)
        fourthButton.backgroundColor = .clear
        
        buttonsView.backgroundColor = primaryLight
    }
}

