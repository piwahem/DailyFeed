//
//  DailyFeedLoadingCell.swift
//  DailyFeed
//
//  Created by Admin on 1/9/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class DailyFeedLoadingCell: UICollectionViewCell {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(){
        loadingIndicator.color = UIColor.red
        loadingIndicator.backgroundColor = UIColor.white
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.center = center
        isUserInteractionEnabled = false
    }
}
