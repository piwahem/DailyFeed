//
//  SettingContactInfoTableViewCell.swift
//  DailyFeed
//
//  Created by Admin on 2/18/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit
import MessageUI

class SettingContactInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    var onActionListener: OnActionInfoListener?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bind(name: String, phoneNumber: String, email: String){
        lbName.text = " " + name
        lbPhoneNumber.text = phoneNumber
        lbEmail.text = email
        
        lbPhoneNumber.embedIcon(image: UIImage(named: "close")!)
        lbEmail.embedIcon(image: UIImage(named: "bookmark")!)
        
        setUpCallNumber()
        setUpSendEmail()
    }
    
    private func setUpCallNumber(){
        let tapCall = UITapGestureRecognizer(target: self, action: #selector(SettingContactInfoTableViewCell.callToNumber))
        lbPhoneNumber.isUserInteractionEnabled = true
        lbPhoneNumber.addGestureRecognizer(tapCall)
    }
    
    private func setUpSendEmail(){
        let tapSend = UITapGestureRecognizer(target: self, action: #selector(SettingContactInfoTableViewCell.sendToEmail))
        lbEmail.isUserInteractionEnabled = true
        lbEmail.addGestureRecognizer(tapSend)
    }
    
    @objc private func sendToEmail(){
        onActionListener?.onSendEmail(toUser: lbEmail.text!)
    }
    
    @objc private func callToNumber(){
        if let phoneNumber = lbPhoneNumber.text{
            callNumber(number: phoneNumber)
        }
    }
    
    private func callNumber(number: String){
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension SettingContactInfoTableViewCell: MFMailComposeViewControllerDelegate{
    
}


