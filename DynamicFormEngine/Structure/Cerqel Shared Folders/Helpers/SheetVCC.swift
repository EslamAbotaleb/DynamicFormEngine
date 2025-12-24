//
//  SheetVCC.swift
//  DynamicFormEngine
//
//  Created by Eslam on 21/12/2025.
//

import UIKit

public class SheetVCC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var stringsArray: [String] = []
    var titleText: String = ""
    
    let tableView = UITableView()
    let titleLabel = UILabel()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTitleLabel()
        setupTableView()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = titleText
        titleLabel.font = UIFont.SST_Arabic_Medium(ofSize: 16)//boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // UITableViewDataSource Methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringsArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = stringsArray[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate Methods
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
