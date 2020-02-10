//
//  SettingTableViewCell.swift
//  DailyFeed
//
//  Created by Admin on 2/10/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(name: String){
        lbName.text = name
        accessoryType = .disclosureIndicator
    }
    
}
