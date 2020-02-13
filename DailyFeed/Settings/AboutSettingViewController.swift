//
//  AboutSettingViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/13/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class AboutSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Setting", style: .plain, target: self, action: #selector(self.closeBackButtonPressed))
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func closeBackButtonPressed(){
        self.dismiss(animated: false, completion: nil)
    }

}
