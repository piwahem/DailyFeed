//
//  NewsSearchExecuter.swift
//  DailyFeed
//
//  Created by Admin on 12/26/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol ISearchExecutor {
    func execute(action: @escaping ((String)->Void))
}

class NewsSearchExecutor: ISearchExecutor{
    
    var searchController: UISearchController
    var searchWorkItem: DispatchWorkItem?

    init(searchController: UISearchController) {
        self.searchController = searchController
    }
    
    func execute(action: @escaping ((String)->Void)) {
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem{
            if let searchString = self.searchController.searchBar.text,
                searchString.count > 3 {
                print("searchItems \(searchString)")
                action(searchString)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: workItem)
        searchWorkItem = workItem
    }
}
