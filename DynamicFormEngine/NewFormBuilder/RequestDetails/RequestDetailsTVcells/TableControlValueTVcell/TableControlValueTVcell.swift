//
//  TableControlValueTVcell.swift
//  CERQEL
//
//  Created by iSlam AbdelAziz on 21/11/2021.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

class TableControlValueTVcell: UITableViewCell {
    
    @IBOutlet weak var ttlLbl: UILabel!
    @IBOutlet weak var ctlsTV: UITableView!

    var arrayOfControls: [[ModelControl]] = []{
        didSet{
            self.ctlsTV.reloadData()
        }
    }
    
    var ttl: String = ""
    var didSelectRow: ((Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(ctls: [[ModelControl]]?, title: String?){
        ttlLbl.text = title
        ttl = title ?? ""
        self.arrayOfControls = ctls ?? []
    }

    
}

extension TableControlValueTVcell: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfControls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(ttl) \(indexPath.row + 1)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(indexPath.row)
    }
    
    
}
