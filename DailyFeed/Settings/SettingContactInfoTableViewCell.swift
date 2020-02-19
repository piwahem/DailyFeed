//
//  SettingContactInfoTableViewCell.swift
//  DailyFeed
//
//  Created by Admin on 2/18/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingContactInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    @IBOutlet weak var lbEmail: UILabel!

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
    }
    
    //    func initStaticUI() {
    //        lbSubcriber.font = UIFont.boldSystemFont(ofSize: 17.0)
    //        lbNorthAmericanPhoneNumber.embedIcon(image: UIImage(named: "close")!)
    //        lbNorthAmericanEmail.embedIcon(image: UIImage(named: "bookmark")!)
    //
    //        let tapCall = UITapGestureRecognizer(target: self, action: #selector(SettingContactTableViewController.callNorthAmericanNumber))
    //        lbNorthAmericanPhoneNumber.isUserInteractionEnabled = true
    //        lbNorthAmericanPhoneNumber.addGestureRecognizer(tapCall)
    //
    //        let tapSend = UITapGestureRecognizer(target: self, action: #selector(SettingContactTableViewController.sendNorthAmericanEmail))
    //        lbNorthAmericanEmail.isUserInteractionEnabled = true
    //        lbNorthAmericanEmail.addGestureRecognizer(tapSend)
    //    }
    
    
    //    @objc private func sendNorthAmericanEmail(){
    //        let mailComposeViewController = configureMailComposer(recipent: lbNorthAmericanEmail.text!, subject: "", message: "")
    //        if MFMailComposeViewController.canSendMail(){
    //            self.present(mailComposeViewController, animated: true, completion: nil)
    //        }else{
    //            print("Can't send email")
    //        }
    //    }
    
    
    //    @objc private func callNorthAmericanNumber(){
    //        callNumber(number: lbNorthAmericanPhoneNumber.text!)
    //    }
}
