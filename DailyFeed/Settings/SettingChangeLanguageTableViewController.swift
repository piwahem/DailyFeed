//
//  SettingChangeLanguageTableViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/26/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class SettingChangeLanguageTableViewController: UITableViewController {
    
    var languages: [SettingLanguages] = []
    var showHideTabBarListner: OnShowHideTabbarListener? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languages = getLanguages()
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
        cell?.bind(name: languages[indexPath.row].language)
        cell?.accessoryType = languages[indexPath.row].isCheck ? .checkmark : .none
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
        let position = indexPath.row
        if (position == 0){
            AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: "en")
        } else if (position == 1){
            AMPLocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: "zh-Hans")
        }
        updateCellState(indexPath: indexPath)
    }
    
    private func getLanguages() -> [SettingLanguages] {
        let eng = SettingLanguages(language: "English".localized, isCheck: false)
        let han = SettingLanguages(language: "Chinese".localized, isCheck: false)
        return [eng, han]
    }
    
    private func updateCellState(indexPath: IndexPath){
        let size = languages.count
        for index in 0..<size {
            if (index == indexPath.row){
                languages[index].isCheck = true
            } else {
                languages[index].isCheck = false
            }
        }
        tableView.reloadData()
    }
}

struct SettingLanguages {
    var language: String
    var isCheck: Bool
}
