//
//  SourceSearchExecutor.swift
//  DailyFeed
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

class SourceSearchExecutor: ISearchExecutor {
    
    var searchController: UISearchController
    var searchWorkItem: DispatchWorkItem?
    
    init(searchController: UISearchController) {
        self.searchController = searchController
    }
    
    func execute(action: @escaping ((String)->Void)) {
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem{
            
            if let searchString = self.searchController.searchBar.text {
                print("search source \(searchString)")
                action(searchString)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
        searchWorkItem = workItem
    }
    
}
