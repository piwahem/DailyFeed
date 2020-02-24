//
//  SettingContactInstructionTableViewCell.swift
//  DailyFeed
//
//  Created by Admin on 2/18/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingContactInstructionTableViewCell: UITableViewCell {

    @IBOutlet weak var lbContacting: UILabel!
    @IBOutlet weak var lbNote1: UILabel!
    @IBOutlet weak var lbNote2: UILabel!
    @IBOutlet weak var lbNote3: UILabel!
    
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
        lbContacting.text = "When contacting us, to help us serve you better, please include:".localized
        lbNote1.text = "  • Specific problem you are experiencing".localized
        lbNote2.text = "  • Your supcription status".localized
        lbNote3.text = "  • Your device type".localized
    }
    
}
