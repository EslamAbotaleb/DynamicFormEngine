//
//  DropDownViewController.swift
//  CHECK
//
//  Created by Yasser Osama on 25/05/2022.
//

import UIKit

protocol DropDownDelegate: AnyObject {
    func userSelected(_ ids: [String])
}

class DropDownViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectAllView: UIView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: DropDownDelegate?
    var questionTitle = ""
    var allOptions = [MCQOption]()
    var filteredOptions = [MCQOption]()
    var options: [MCQOption] {
        if searchBar.searchActive() {
            return filteredOptions
        } else {
            return allOptions
        }
    }
    var selectedValues = [String]()
    var representation: CheckBoxRepresentation?
    var multiSelect = false
    var selectAllEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectAllView.isHidden = !selectAllEnabled
        if selectedValues.count == options.count {
            selectAllButton.setImage(UIImage(named: "selectAllIcon"), for: .normal)
        }
    }
    
    func setupUI() {
        titleLabel.text = questionTitle
        searchBar.placeholder = "Search".localized
        searchBar.delegate = self
        tableView.register(DropDownItemTableViewCell.cerqel_nib, forCellReuseIdentifier: DropDownItemTableViewCell.cerqel_identifier)
        tableView.tableFooterView = UIView()
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate?.userSelected(selectedValues)
    }
    
    @IBAction func selectAllAction(_ sender: UIButton) {
        if selectedValues.count == options.count {
            selectedValues = []
            selectAllButton.setImage(UIImage(named: "mcqCheckBox"), for: .normal)
        } else {
            selectedValues = options.map({$0.id ?? ""})
            selectAllButton.setImage(UIImage(named: "mcqCheckBoxSelected"), for: .normal)
        }
        tableView.reloadData()
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
        guard let id = options[index].id else {
            return
        }
        if selectedValues.contains(id) {
//            selectedValues.removeAll(where: {$0 == id})
        } else {
            selectedValues.append(id)
        }
    }
    
    func handleSingleSelect(_ index: Int) {
        guard let id = options[index].id else {
            return
        }
        if selectedValues.contains(id) {
//            selectedValues.removeAll(where: {$0 == id})
        } else {
            selectedValues = [id]
        }
    }
}

extension DropDownViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropDownItemTableViewCell.cerqel_identifier, for: indexPath) as! DropDownItemTableViewCell
        cell.value = options[indexPath.row].name
        cell.representation = representation ?? .CheckBox
        cell.checked = selectedValues.contains(options[indexPath.row].id ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCellAt(indexPath.row)
    }
}

extension DropDownViewController: UISearchBarDelegate {
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
