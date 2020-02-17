//
//  SettingContactTableViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/16/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingContactTableViewController: UITableViewController {
    
    @IBOutlet weak var lbSubcriber: UILabel!
    @IBOutlet weak var lbNorthAmericanPhoneNumber: UILabel!
    @IBOutlet weak var lbNorthAmericanEmail: UILabel!
    
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
        
        lbSubcriber.font = UIFont.boldSystemFont(ofSize: 17.0)
        lbNorthAmericanPhoneNumber.embedIcon(image: UIImage(named: "close")!)
        lbNorthAmericanEmail.embedIcon(image: UIImage(named: "bookmark")!)
    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        showHideTabBarListner?.onShow(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) { // As soon as vc disappears
        super.viewWillDisappear(true)
        showHideTabBarListner?.onShow(isShow: true)
    }
}
