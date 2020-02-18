//
//  SettingContactTableViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/16/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit
import MessageUI

class SettingContactTableViewController: UITableViewController {
    
//    @IBOutlet weak var lbSubcriber: UILabel!
//    @IBOutlet weak var lbNorthAmericanPhoneNumber: UILabel!
//    @IBOutlet weak var lbNorthAmericanEmail: UILabel!
    
    var showHideTabBarListner: OnShowHideTabbarListener? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
//    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 3
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingContactInstructionTableViewCell, for: indexPath) as! SettingContactInstructionTableViewCell
//        return cell
//    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        showHideTabBarListner?.onShow(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) { // As soon as vc disappears
        super.viewWillDisappear(true)
        showHideTabBarListner?.onShow(isShow: true)
    }
    
//    @objc private func callNorthAmericanNumber(){
//        callNumber(number: lbNorthAmericanPhoneNumber.text!)
//    }
    
    private func callNumber(number: String){
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
//    @objc private func sendNorthAmericanEmail(){
//        let mailComposeViewController = configureMailComposer(recipent: lbNorthAmericanEmail.text!, subject: "", message: "")
//        if MFMailComposeViewController.canSendMail(){
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        }else{
//            print("Can't send email")
//        }
//    }
    
    func configureMailComposer(recipent: String, subject: String, message: String) -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([recipent])
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(message, isHTML: false)
        return mailComposeVC
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
}

extension SettingContactTableViewController: MFMailComposeViewControllerDelegate{
    
}
