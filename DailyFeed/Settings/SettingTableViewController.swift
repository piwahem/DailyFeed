//
//  SettingTableViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/10/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit
import SafariServices

class SettingTableViewController: UITableViewController {
    
    var settings = ["Notifications".localized, "Contact us".localized, "About".localized, "Term of use".localized, "Privacy policy".localized, "Change language".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(R.nib.settingTableViewCell)
        tableView.tableFooterView = getFooterView2()
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = false
        tabBarController?.hidesBottomBarWhenPushed = true
        print("AppVersion: \(Bundle.main.appVersion)")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingTableViewCell, for: indexPath) as! SettingTableViewCell
        let position = indexPath.row
        let name = settings[position]
        cell.bind(name: name)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.contentView.layer.opacity = 0.3
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.contentView.layer.opacity = 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt position = \(indexPath.row)")
        let position = indexPath.row
        if (position == 0){
            openAppSetting()
        } else if (position == 1){
            openContactUs()
        }else if (position == 2){
            openAbout()
        } else if (position == 3){
            openTermOfUse()
        } else if (position == 4){
            openPrivacyPolicy()
        } else if (position == 5){
            openChangeLanguage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.settingTableViewController.settingContactTableViewController.identifier {
            if let vc = segue.destination as? SettingContactTableViewController {
                vc.showHideTabBarListner = self
            }
        } else if segue.identifier == R.segue.settingTableViewController.aboutSettingViewController.identifier {
            if let vc = segue.destination as? AboutSettingViewController {
                vc.showHideTabBarListner = self
            }
        } else if segue.identifier == R.segue.settingTableViewController.settingChangeLanguageTableViewController.identifier {
            if let vc = segue.destination as? SettingChangeLanguageTableViewController {
                vc.showHideTabBarListner = self
            }
        }
    }
    
    
    // remove redudant and last separator line of cell
    private func getFooterView() -> UIView{
        return UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 1))
    }
    
    // remove redudant separator line of cell
    private func getFooterView2() -> UIView{
        return UIView(frame: CGRect.zero)
    }
    
    private func openAppSetting() {
        if #available(iOS 11.0, *) {
            // Running iOS 11 OR NEWER
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Earlier version of iOS
            if let url = URL(string: "App-Prefs:root=General") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openTermOfUse(){
        openSafari(url: AppUrl.TERM_OF_USE.rawValue)
    }
    
    func openPrivacyPolicy(){
        openSafari(url: AppUrl.PRIVATE_POLICY.rawValue)
    }
    
    private func openSafari(url: String){
        if let url = URL(string: url) {
            let svc = DFSafariViewController(url: url)
            svc.delegate = self
            present(svc, animated: true, completion: nil)
        }
    }
    
    private func openAbout(){
        performSegue(withIdentifier: R.segue.settingTableViewController.aboutSettingViewController, sender: self)
    }
    
    private func openContactUs(){
        performSegue(withIdentifier: R.segue.settingTableViewController.settingContactTableViewController, sender: self)
    }
    
    private func openChangeLanguage(){
        performSegue(withIdentifier: R.segue.settingTableViewController.settingChangeLanguageTableViewController, sender: self)
    }
}

extension SettingTableViewController: SFSafariViewControllerDelegate{
    
}

extension SettingTableViewController: OnShowHideTabbarListener{
    func onShow(isShow: Bool) {
        self.tabBarController?.tabBar.isHidden = !isShow
    }
}
