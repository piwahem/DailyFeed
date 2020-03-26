//
//  TabBarController+Extension.swift
//  DailyFeed
//
//  Created by Admin on 3/13/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    
    func resetTabTitle() {
        let items = self.tabBar.items
        for (offset, element) in (items?.enumerated())! {
            self.tabBar.items![offset].title = getTabTitleByPosition(position: offset)
        }
    }
    
    private func getTabTitleByPosition(position: Int) -> String{
        switch position {
        case 0:
            return "DailyFeed".localized
        case 1:
            return "Bookmarks".localized
        case 2:
            return "Search".localized
        case 3:
            return "Settings".localized
        default:
            return "DailyFeed".localized
        }
    }
}

