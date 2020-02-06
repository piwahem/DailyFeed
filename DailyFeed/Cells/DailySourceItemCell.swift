//
//  DailySourceItemCell.swift
//  DailyFeed
//
//  Created by Sumit Paul on 11/01/17.
//

import UIKit

class DailySourceItemCell: UITableViewCell {
    
    @IBOutlet weak var sourceImageView: TSImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle  = .none
    }
    
    func bind(item: DailySourceModel, position: Int){
        sourceImageView.downloadedFromLink(NewsSource.logo(source: item.sid ?? "").url)
        label.text = "\(position)"
        label.isHidden = true
        backgroundColor = UIColor.white
        isUserInteractionEnabled = true
    }
    
}
