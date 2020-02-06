//
//  DailySourceLoadingCell.swift
//  DailyFeed
//
//  Created by Admin on 1/6/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class DailySourceLoadingCell: UITableViewCell {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle  = .none
    }
    
    func bind(){
        loadingIndicator.color = UIColor.red
        loadingIndicator.backgroundColor = UIColor.white
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.center = center
        isUserInteractionEnabled = false
    }
    
}
