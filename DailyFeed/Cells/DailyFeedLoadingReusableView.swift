//
//  DailyFeedLoadingReusableView.swift
//  DailyFeed
//
//  Created by Admin on 1/15/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class DailyFeedLoadingReusableView: UICollectionReusableView {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(){
//        loadingIndicator.color = UIColor.red
//        loadingIndicator.backgroundColor = UIColor.green
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.center = center
        isUserInteractionEnabled = false
    }
    
}
