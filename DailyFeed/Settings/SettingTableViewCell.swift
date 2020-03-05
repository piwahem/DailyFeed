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
        self.selectionStyle  = .none
        let zeroInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.separatorInset = zeroInset
        self.layoutMargins = zeroInset
    }
    
    func bind(name: String){
        lbName.text = name
        accessoryType = .disclosureIndicator
    }
    
}
