//
//  NewSearchVC.swift
//
//
//  Created by Mohamed Nagi on 13/02/2023.
//  Copyright © 2023 All rights reserved.
//

import UIKit
internal import RxSwift
public import RxCocoa


public class NewSearchVC: BottomSheetVCCerqel {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cancelButton: LocalizedButton!
    @IBOutlet weak var selectButton: LocalizedButton!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.backgroundColor = .white
                let backgroundView = textField.subviews.first
                if #available(iOS 11.0, *) { // If `searchController` is in `navigationItem`
                    backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3) //Or any transparent color that matches with the `navigationBar color`
                    backgroundView?.subviews.forEach({ $0.removeFromSuperview() }) // Fixes an UI bug when searchBar appears or hides when scrolling
                }
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - Variables
    
    let disposeBag = DisposeBag()
    public var searchCode = ""
    public var localSearch = true // passed true if it has options
    weak var delegate: NewDropDownDelegate?
    var questionTitle: String = "" {
        didSet {
            titleLabel.text = questionTitle
        }
    }
    var searchBarPlaceHolder: String = "" {
        didSet {
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.placeholder = searchBarPlaceHolder
            }
            
            if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

                 clearButton.addTarget(self, action: #selector(self.clearTapped), for: .touchUpInside)
            }
        }
    }
    var allOptions: BehaviorRelay<[MCQOption]> = BehaviorRelay(value: [])
    var filteredOptions = [MCQOption]()
    private var options: [MCQOption] = [] {
        didSet {
            //options = allOptions.value
            tableView.reloadData()
        }
    }
    var selectedValues = [MCQOption]()
    var otherValue = ""
    var representation: CheckBoxRepresentation?
    var multiSelect = false
    var selectAllEnabled = false
    var dismiss: ((_ selectedOptions: [MCQOption],_ otherOption: String)->())?
    var selectOption: ((_ selectedOptions: [MCQOption],_ otherOption: String)->())?
    var getSearchUrl: ((_ code: String, _ keyword: String) ->Void)?
    
    
    
    // MARK: - Functions
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addGesture()
        setupUI()
    }
    
    public func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAllTapped))
        selectAllView.isUserInteractionEnabled = true
        selectAllView.addGestureRecognizer(tapGesture)
    }
    
    public func handleSelectAll() {
        selectAllView.isHidden = !selectAllEnabled
        if selectedValues.count == options.count {
            selectAllButton.setImage(UIImage(named: "selectAllIcon"), for: .normal)
        }
    }
    
    public func setupUI() {
        tableView.register(NewOptionTVCell.cerqel_nib, forCellReuseIdentifier: NewOptionTVCell.cerqel_identifier)
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        cancelButton.setCancelButtonTheme()
        selectButton.setSubmitButtonTheme()
    }
    
    public func configure() {
        allOptions.subscribe(onNext: { [weak self] opts in
            guard let `self` = self else {return}
            self.options = opts
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
    }
    
    public func selectAllBehaviour() {
        if selectedValues.count == options.count {
            selectedValues = []
            selectAllButton.setImage(UIImage(named: "Rectangle 5961"), for: .normal)
        } else {
            selectedValues = options
            selectAllButton.setImage(UIImage(named: "selectAllIcon"), for: .normal)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - IBActions
    
    @objc func selectAllTapped() {
        selectAllBehaviour()
    }
    
    @objc func clearTapped() {
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    @IBAction func selectAllAction(_ sender: UIButton) {
        selectAllBehaviour()
    }
    
    @IBAction func selectAction(_ sender: Any) {
        if let action = selectOption {
            action(self.selectedValues, otherValue)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
//            if selectedValues.count > 0 {
//                let action = selectOption
//                action?(self.selectedValues, otherValue)
//            }else{
                let action = dismiss
                action?(self.selectedValues, otherValue)
//            }
    }
    
    @IBAction func exitAction(_ sender: UIButton) {
//        if selectedValues.count > 0 {
//            let action = selectOption
//            action?(self.selectedValues, otherValue)
//        }else{
            let action = dismiss
            action?(self.selectedValues, otherValue)
//        }
    }
    
    func selectCellAt(_ index: Int) {
        if let representation = representation {
            if representation == .CheckBox {
                handleMultiSelect(index)
            } else {
                handleSingleSelect(index)
            }
        } else {
            if multiSelect {
                handleMultiSelect(index)
            } else {
                handleSingleSelect(index)
            }
        }
        tableView.reloadData()
    }
    
    func handleMultiSelect(_ index: Int) {
        guard let option: MCQOption? = options[index] else {
            return
        }
        if selectedValues.contains(option!) {
//            selectedValues.removeAll(where: {$0 == option})
        } else {
            selectedValues.append(option!)
        }
    }
    
    func handleSingleSelect(_ index: Int) {
        guard let option: MCQOption? = options[index] else {
            return
        }
        if selectedValues.contains(option!) {
//            selectedValues.removeAll(where: {$0 == option})
        } else {
            selectedValues = [option!]
        }
    }
}

extension NewSearchVC: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewOptionTVCell.cerqel_identifier, for: indexPath) as! NewOptionTVCell
        if isArabicCerqel() {
            cell.value = options[indexPath.row].name_ar
        }else {
            cell.value = options[indexPath.row].name
        }
        cell.representation = representation ?? .CheckBox
        cell.checked = selectedValues.contains(options[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        selectCellAt(indexPath.row)
    }
}

extension NewSearchVC: UISearchBarDelegate {
    public func filterContentForSearchText(searchText: String, scope: String = "All") {
        if localSearch {
            let filteredArr = allOptions.value.filter({$0.name!.lowercased().contains(searchText.lowercased())})
            options = filteredArr
        }else {
            getSearchUrl?(searchCode,searchText)
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !localSearch {
            guard !searchText.isEmpty else {
                allOptions.accept([])
                getSearchUrl?(searchCode,"")
                searchBar.resignFirstResponder()
                return
            }
        }else {
            guard !searchText.isEmpty else {
                options = allOptions.value
                return
            }
            
        }
        if !localSearch {
            guard searchText.count >= 3 else {
                allOptions.accept([])
                return
            }
        }
        
        filterContentForSearchText(searchText: searchText)
        tableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard range.location == 0 else {
                return true
            }
        if searchBar.text == "" {
            return true
        }
        let newString = (searchBar.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
