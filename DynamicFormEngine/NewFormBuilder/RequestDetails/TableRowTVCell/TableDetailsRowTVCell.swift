//
//  TableDetailsRowTVCell.swift
//  KAFDHUB
//
//  Created by hassan elshaer on 19/09/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit

class TableDetailsRowTVCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLblContainerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var itemsTV: UITableView!
    
    
    // MARK: - Variables
    var isSectionItem = false
    var expanded = false
    var items = [Field]()
    var backwardItems = [BackwardViewForm]()
    var expand: ((Bool)->())?
    var downloadMediaTapped: ((String)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        registerCells()
        addGesture()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Functions
    
    func registerCells() {
        itemsTV.register(EmptyTVcell.cerqel_nib, forCellReuseIdentifier: EmptyTVcell.cerqel_identifier)
        itemsTV.register(ActionControlTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlTVcell.cerqel_identifier)
        itemsTV.register(ActionControlAttachmentsTVcell.cerqel_nib, forCellReuseIdentifier: ActionControlAttachmentsTVcell.cerqel_identifier)
    }
    
    func setupUI() {
        titleLblContainerView.addBottomShadow()
        itemsTV.rowHeight = UITableView.automaticDimension
        itemsTV.estimatedRowHeight = 60
        itemsTV.reloadData()
        updateConstraintsForSectionItem()
    }
    
//    func config(items: [BackwardViewForm]?, title: String) {
//        titleLbl.text = title
//        self.backwardItems = items ?? []
////        self.itemsTVHeightConstraint.constant = CGFloat(self.items.count * 60)
//        itemsTV.isHidden = !expanded
//        itemsTV.rowHeight = UITableView.automaticDimension
//        itemsTV.estimatedRowHeight = 80
//        itemsTV.reloadData()
//    }
    
    func config(items: [Field]?, title: String) {
        contentView.backgroundColor = isSectionItem ? .white : .clear
        titleLbl.text = title
        self.items = items ?? []
        itemsTV.isHidden = !expanded
        itemsTV.rowHeight = UITableView.automaticDimension
        itemsTV.estimatedRowHeight = 60
        itemsTV.reloadData()
    }
    
    
//    func config(item: BackwardDataSoruceTableModel) {
//        titleLbl.text = "\(item.title ?? "") \(item.rowIndex ?? "")"
//        self.backwardItems = item.relatedItems ?? []
////        self.itemsTVHeightConstraint.constant = CGFloat(self.items.count * 60)
//        itemsTV.isHidden = !(item.expanded ?? false)
//        arrowImg.image = (item.expanded ?? false) ? UIImage(named: "expanded") : UIImage(named: "NotExpanded")
//        itemsTV.reloadData()
//    }

    func config(item: dataSoruceTableModel) {
        titleLbl.text = "\(item.title ?? "") \(item.rowIndex ?? "")"
        self.items = item.relatedItems ?? []
//        self.itemsTVHeightConstraint.constant = CGFloat(self.items.count * 60)
        itemsTV.isHidden = !(item.expanded ?? false)
        arrowImg.image = (item.expanded ?? false) ? UIImage(named: "expanded") : UIImage(named: "NotExpanded")
        itemsTV.reloadData()
    }


    
    func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Tapped))
        titleLblContainerView.isUserInteractionEnabled = true
        titleLblContainerView.addGestureRecognizer(tapGesture)
    }
    
    func toggleExpantion(expand: Bool, completion: @escaping(()->())) {
        itemsTV.isHidden = !expand
//        itemsTVHeightConstraint.constant = expand ? CGFloat(self.items.count * 60) : 0
        arrowImg.image = expand ? UIImage(named: "expanded") : UIImage(named: "NotExpanded")
         itemsTV.reloadData()
        completion()
    }
    
    private func updateConstraintsForSectionItem() {

           if isSectionItem {
               contentView.translatesAutoresizingMaskIntoConstraints = true
               NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        } else {
//            contentView.translatesAutoresizingMaskIntoConstraints = true
            NSLayoutConstraint.deactivate([
                contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
        }
    }
    
    // MARK: - IBActions
    
    @objc func Tapped() {
        expand?(expanded)
    }
    
}


extension TableDetailsRowTVCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let filteredItems = items.filter({$0.properties?.defaultAnswer?.defaultValue != nil})
//        return filteredItems.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let filteredItems = items.filter({$0.properties?.defaultAnswer?.defaultValue != nil})
//        let emptyCell = tableView.dequeueReusableCell(withIdentifier: EmptyTVcell.cerqel_identifier, for: indexPath) as! EmptyTVcell
//        if(filteredItems[indexPath.row].properties?.hidden ){
//            return emptyCell
//        } else {
//            if filteredItems[indexPath.row].type == .FileUpload {
//                let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlAttachmentsTVcell.cerqel_identifier, for: indexPath) as! ActionControlAttachmentsTVcell
//                cell.configure(properties: filteredItems[indexPath.row].properties)
//                cell.mediaTapped = {[weak self] id in
//                    guard let `self` = self else {return}
//                    self.downloadMediaTapped?(id)
//                }
//                return cell
//            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionControlTVcell.cerqel_identifier, for: indexPath) as? ActionControlTVcell else {return UITableViewCell()}
//            cell.configure(properties: filteredItems[indexPath.row].properties)
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

