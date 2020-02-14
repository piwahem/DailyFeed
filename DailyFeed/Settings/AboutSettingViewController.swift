//
//  AboutSettingViewController.swift
//  DailyFeed
//
//  Created by Admin on 2/13/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit

class AboutSettingViewController: UIViewController {

    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var lbAppVersion: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close"), for: [])
        button.setTitle("Settings", for: [])
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.self.closeBackButtonPressed), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        
        vBackground.addTopBorder(with: UIColor.gray, andWidth: 1)
        lbAppVersion.text = Bundle.main.appVersion
    }
    
    @objc func closeBackButtonPressed(){
        self.dismiss(animated: false, completion: nil)
    }

    
}
