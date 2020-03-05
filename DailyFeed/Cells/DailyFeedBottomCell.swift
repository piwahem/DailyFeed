//
//  DailyFeedBottomCell.swift
//  DailyFeed
//
//  Created by Admin on 1/9/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class DailyFeedBottomCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(){
        label.text = "Powered by NewsAPI.org".localized
    }

}
