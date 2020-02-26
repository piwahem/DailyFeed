//
//  SettingChangeLanguageTableViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/26/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingChangeLanguageTableViewController: UITableViewController {
    
    var languages = ["English".localized, "Chinese".localized]
    var showHideTabBarListner: OnShowHideTabbarListener? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.settingChangeLanguageTableViewCell)
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = false
        tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languages.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingChangeLanguageTableViewCell, for: indexPath)
        cell?.bind(name: languages[indexPath.row])
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) { // As soon as vc appears
        super.viewWillAppear(true)
        showHideTabBarListner?.onShow(isShow: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) { // As soon as vc disappears
        super.viewWillDisappear(true)
        showHideTabBarListner?.onShow(isShow: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt position = \(indexPath.row)")
        let position = indexPath.row
        if (position == 0){
            AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: "en")
        } else if (position == 1){
            AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: "zh-Hans")
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        return indexPath
    }
}
