//
//  BaseSortVC.swift
//  CERQEL
//
//  Created by Mohamed Karmout on 22/11/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit
//import FittedSheets
import DynamicFormEngine

class CerqelBaseSortVC: CerqelBaseWireFrame<CerqelBaseSortViewModel> {
    
    @IBOutlet weak var seperateView: UIView! {
        didSet { 
            seperateView.cerqel_addNormalShadow()
        }
    }
    @IBOutlet weak var actionBtnsView: UIView!
    @IBOutlet weak var sortNameLbl: UILabel!
    @IBOutlet weak var tagsCV: UICollectionView!
    @IBOutlet weak var itemsTV: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var sortBaseName : String?
    var sortType:sortSectionsCerqel?
    var selectedRows:[IndexPath] = []
    var sortData = [sortModelCerqel]()
    var optionsRadio = ["Newest","Oldest","Alphabetical A-Z","Alphabetical Z-A"]
    var optionsCheck = ["Oldest","Alphabetical","Alphabetical A-Z","Alphabetical Z-A"]
    var optionsTags = ["# Newest","# Oldest","# Alphabetical A-Z","# Alphabetical Z-A","# Newest","# Newest","# Newest"]
    var didTapClose: (()->())?
    var didSelectedOption:((String) -> Void)? = nil
    var sortSelectedName: String?
    
    override func configure(with viewModel: CerqelBaseSortViewModel) {
        print("DONE")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        if let sortType = sortType {
            configure(type:sortType)
            sortNameLbl.text = sortBaseName
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        itemsTV.reloadData()
    }
    
    func configure(type:sortSectionsCerqel){
        switch type {
        case .radioBtnTV:
            itemsTV.isHidden = false
            tagsCV.isHidden = true
            actionBtnsView.isHidden = true
            seperateView.isHidden = true
        case .checkBoxTV:
            itemsTV.isHidden = false
            tagsCV.isHidden = true
            actionBtnsView.isHidden = false
            seperateView.isHidden = false
            itemsTV.reloadData()
        case .tagsCV:
            itemsTV.isHidden = true
            tagsCV.isHidden = false
            actionBtnsView.isHidden = true
            seperateView.isHidden = true
        }
    }
    
    static func presentSheet(sortData:[sortModelCerqel],sortType:sortSectionsCerqel,sortSelectedName:String?,sortTitle:String?,selectedAction:@escaping(String) -> Void,from:UIViewController) {
        if let customViewVc = CERQELShared_Router.goTo(viewName: .baseSort(sortName: sortTitle ?? "", sortType: sortType, sortData: sortData)) as? CerqelBaseSortVC {
            customViewVc.sortSelectedName = sortSelectedName
            var height = CGFloat()
            if sortType == .radioBtnTV{
                 height = (CGFloat(((sortData.count) * 48) + 150))
            } else if sortType == .checkBoxTV {
                 height = (CGFloat(((sortData.count) * 48) + 250))
            } else if sortType == .tagsCV{
                 height = (CGFloat(((sortData.count) * 48) + 150))
            }
            let sheetController = SheetViewController(controller: customViewVc,sizes: [.fixed(height)])
            customViewVc.didSelectedOption = selectedAction
            // MARK: - custom sheet view properties
            sheetController.blurBottomSafeArea = true
            sheetController.overlayColor = UIColor(rCerqel: 34, gCerqel: 16, bCerqel: 59).withAlphaComponent(0.5)
            sheetController.topCornersRadius = 15
            sheetController.pullBarView.isHidden = true
            from.present(sheetController,animated: false , completion: {})
        }
    }
    
    private func registerCells(){
        itemsTV.register(CerqelRadioButtonSortCell.cerqel_nib, forCellReuseIdentifier: CerqelRadioButtonSortCell.cerqel_identifier)
        itemsTV.register(CerqelCheckBoxSortCell.cerqel_nib, forCellReuseIdentifier: CerqelCheckBoxSortCell.cerqel_identifier)
        tagsCV.register(CerqelTagsSortCell.cerqel_nib, forCellWithReuseIdentifier: CerqelTagsSortCell.cerqel_identifier)
        itemsTV.delegate = self
        itemsTV.dataSource = self
        tagsCV.delegate = self
        tagsCV.dataSource = self
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        didTapClose?()
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func applyBtnPressed(_ sender: Any) {
        print("DONNNE")
    }
}

extension CerqelBaseSortVC {
    private func configureUI() {
        closeBtn.tintColor = primaryMain
        sortNameLbl.textColor = typographyTitle
        sortNameLbl.font = UIFont.bodyLMedium()
    }
}
