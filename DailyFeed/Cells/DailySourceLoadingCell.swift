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

}
