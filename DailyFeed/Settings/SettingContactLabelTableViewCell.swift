//
//  SettingContactLabelTableViewCell.swift
//  DailyFeed
//
//  Created by Admin on 2/18/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingContactLabelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        lb.text = "Digital subscriber service centres".localized
    }
}
