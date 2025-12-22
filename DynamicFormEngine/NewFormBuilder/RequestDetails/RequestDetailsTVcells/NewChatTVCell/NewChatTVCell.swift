//
//  NewChatTVCell.swift
//  KAFDHUB
//
//  Created by Mohamed Nagi on 06/11/2023.
//  Copyright © 2023 Youxel. All rights reserved.
//

import UIKit


class NewChatTVCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var chatTV: UITableView!
    @IBOutlet weak var chatTVHeightConstraint: NSLayoutConstraint!

    
    
    // MARK: - Variables
    
    var attachmentTapped: ((String)-> ())?
    var chatList = [ModelDicussionMessageData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
    }
    
    
    // MARK: - Functions
    
    func config(chat: [ModelDicussionMessageData]?) {
        chatList = chat ?? []
        chatTV.reloadData()
        
        // Calculate the total height of all cells
        var totalHeight: CGFloat = 0.0
        for row in 0..<chatList.count {
            let indexPath = IndexPath(row: row, section: 0)
            totalHeight += tableView(chatTV, heightForRowAt: indexPath)
        }
        
        // Update the height constraint of chatTV
        chatTVHeightConstraint.constant = totalHeight
    }

    
    private func registerCells() {
        chatTV.register(ChatTVcell.cerqel_nib, forCellReuseIdentifier: ChatTVcell.cerqel_identifier)
        chatTV.register(ChatEmptyTVcell.cerqel_nib, forCellReuseIdentifier: ChatEmptyTVcell.cerqel_identifier)
    }
    
}

extension NewChatTVCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTVcell.cerqel_identifier, for: indexPath) as! ChatTVcell
        cell.configure(chatList[indexPath.row], empMail: AuthManager.shared.profile.value?.mail ?? "" ?? "")
        cell.attachmentTapped = {[weak self] id in
            guard let `self` = self else {return}
            if let action = self.attachmentTapped {
                action(id)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTVcell.cerqel_identifier) as! ChatTVcell
        cell.configure(chatList[indexPath.row], empMail: AuthManager.shared.profile.value?.mail ?? "")
        cell.layoutIfNeeded() // Ensure the cell has been laid out
        let height = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
}
