//
//  SettingChangeLanguageTableViewCell.swift
//  DailyFeed
//
//  Created by Admin on 2/26/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingChangeLanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(name: String) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        lb.text = name.localized
    }
}
