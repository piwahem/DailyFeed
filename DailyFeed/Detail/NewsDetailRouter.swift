//
//  NewsDetailRouter.swift
//  DailyFeed
//
//  Created by Admin on 11/11/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

protocol INewsDetailRouter {
    func openSafari()
}

class NewsDetailRouter: INewsDetailRouter {
    
    weak var viewController: NewsDetailViewController!
    
    func openSafari(){
        guard let articleString = viewController.articleStringURL, let url = URL(string: articleString) else { return }
        let svc = DFSafariViewController(url: url)
        svc.delegate = viewController
        viewController.present(svc, animated: true, completion: nil)
    }
}
