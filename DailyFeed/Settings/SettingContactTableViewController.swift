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
        tableView.register(R.nib.settingContactInstructionTableViewCell)
        tableView.register(R.nib.settingContactLabelTableViewCell)
        tableView.register(R.nib.settingContactInfoTableViewCell)
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = false
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = indexPath.row
        var cell: UITableViewCell?
        switch position {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingContactInstructionTableViewCell, for: indexPath) as! SettingContactInstructionTableViewCell
            (cell as! SettingContactInstructionTableViewCell).bind()
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingContactLabelTableViewCell, for: indexPath) as! SettingContactLabelTableViewCell
            (cell as! SettingContactLabelTableViewCell).bind()
        case 2,3,4,5:
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingContactInfoTableViewCell, for: indexPath) as! SettingContactInfoTableViewCell
            if (position == 2){
                (cell as! SettingContactInfoTableViewCell).bind(name: "North America", phoneNumber: "03332309200",email: "imeo@gmail.com")
            } else if (position == 3){
                (cell as! SettingContactInfoTableViewCell).bind(name: "United Kingdom", phoneNumber: "0980098000",email: "imeo@gmail.com")
            } else if (position == 4){
                (cell as! SettingContactInfoTableViewCell).bind(name: "North American", phoneNumber: "0980098000",email: "imeo@gmail.com")
            } else if (position == 5){
                (cell as! SettingContactInfoTableViewCell).bind(name: "North American", phoneNumber: "0980098000",email: "imeo@gmail.com")
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingContactInstructionTableViewCell, for: indexPath) as! SettingContactInstructionTableViewCell
            (cell as! SettingContactInstructionTableViewCell).bind()
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        showHideTabBarListner?.onShow(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) { // As soon as vc disappears
        super.viewWillDisappear(true)
        showHideTabBarListner?.onShow(isShow: true)
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
    
    func configureMailComposer(recipent: String, subject: String, message: String) -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([recipent])
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(message, isHTML: false)
        return mailComposeVC
    }
}

extension SettingContactTableViewController: MFMailComposeViewControllerDelegate{
    
}
