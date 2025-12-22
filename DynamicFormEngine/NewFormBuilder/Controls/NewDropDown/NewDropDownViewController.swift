//
//  NewDropDownViewController.swift
// 
//
//  Created by mac on 1/29/23.
//  Copyright © 2023 All rights reserved.
//

import UIKit

protocol NewDropDownDelegate: AnyObject {
    func userSelected(_ ids: [MCQOption])
}

class NewDropDownViewController: BottomSheetVCCerqel {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var cancelButton: LocalizedButton! {
        didSet {
            cancelButton.setCancelButtonTheme()
        }
    }
    @IBOutlet weak var selectButton: LocalizedButton! {
        didSet {
            selectButton.setSubmitButtonTheme()
        }
    }
    
    
    // MARK: - Variables
    
    weak var delegate: NewDropDownDelegate?
    var questionTitle: String = "" {
        didSet {
            titleLabel.text = questionTitle
        }
    }
    var allOptions = [MCQOption]() {
        didSet {
            if allOptions.count > 0 {
                tableView.isHidden = false
                emptyLbl.isHidden = true
            }else {
                tableView.isHidden = true
                emptyLbl.isHidden = false
            }
        }
    }
    var filteredOptions = [MCQOption]()
    var options: [MCQOption] {
        return allOptions
    }
    var selectedValues = [MCQOption]()
    var otherValue = ""
    var representation: CheckBoxRepresentation?
    var multiSelect = false
    var selectAllEnabled = false
    var dismiss: (()->())?
    var selectOption: ((_ selectedOptions: [MCQOption],_ otherOption: String)->())?
    var isEditable:Bool? = false
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        setupUI()
    }
    
    
    // MARK: - Functions
    
    func setupUI() {
        tableView.register(NewOptionTVCell.cerqel_nib, forCellReuseIdentifier: NewOptionTVCell.cerqel_identifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyLbl.font = UIFont.Poppins_semiBold(ofSize: 14)
        emptyLbl.text = "No Results Found".localized
    }
    
    func handleSelectAll() {
        selectAllView.isHidden = !selectAllEnabled
        if selectedValues.count == options.count {
            selectAllButton.setImage(UIImage(named: "selectAllIcon"), for: .normal)
        }
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
    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAllTapped))
        selectAllView.isUserInteractionEnabled = true
        selectAllView.addGestureRecognizer(tapGesture)
    }
    
    func handleMultiSelect(_ index: Int) {
        guard let option: MCQOption? = options[index] else {
            return
        }
        if selectedValues.contains(option!) {
            selectedValues.removeAll(where: {$0 == option})
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
    
    func selectAllBehaviour() {
        if selectedValues.count == options.count {
            selectedValues = []
            selectAllButton.setImage(UIImage(named: "Rectangle 5961"), for: .normal)
        } else {
            selectedValues = options//.map({$0.id ?? ""})
            selectAllButton.setImage(UIImage(named: "selectAllIcon"), for: .normal)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - IBActions
    
    @objc func selectAllTapped() {
        selectAllBehaviour()
    }
    
    @IBAction func selectAllAction(_ sender: UIButton) {
        selectAllBehaviour()
    }
    
    @IBAction func selectAction(_ sender: Any) {
        selectOption!(self.selectedValues, otherValue)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss!()
    }
    
    
}

extension NewDropDownViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCellAt(indexPath.row)
    }
}

extension NewDropDownViewController: UISearchBarDelegate {
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredOptions = allOptions.filter({ (value) -> Bool in
            value.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
