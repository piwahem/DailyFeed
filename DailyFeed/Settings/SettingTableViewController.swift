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
    
    var settings = ["Notifications", "Contact us", "About", "Term of use", "Privacy policy"]
        
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
        } else if (position == 3){
            openTermOfUse()
        } else if (position == 4){
            openPrivacyPolicy()
        }
    }

    /*
     Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
             Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
     Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
     Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */
    
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
}

extension SettingTableViewController: SFSafariViewControllerDelegate{
    
}
