//
//  NewsSearchRouter.swift
//  DailyFeed
//
//  Created by Admin on 11/13/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol INewsSearchRouter {
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?)
    func navigateToDetail(sender: Any?)
}

class NewsSearchRouter: INewsSearchRouter {
    
    weak var viewController: NewsSearchViewController!
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.newsSearchViewController.newsSearchSegue.identifier {
            if let vc = segue.destination as? NewsDetailViewController {
                guard let cell = sender as? UICollectionViewCell else { return }
                guard let indexpath = viewController.searchCollectionView?.indexPath(for: cell) else { return }
                viewController.selectedCell = cell
                vc.transitioningDelegate = viewController
                vc.modalPresentationStyle = .formSheet
                let article = ArticleRealmModel.convertFrom(from:viewController.searchItems[indexpath.row])
                vc.receivedNewsItem = ArticleTestRealmModel.convertFrom(from: article)
                vc.receivedItemNumber = indexpath.row + 1
            }
        }
    }
    
    func navigateToDetail(sender: Any?) {
        viewController.performSegue(withIdentifier: R.segue.newsSearchViewController.newsSearchSegue,
                                    sender: sender)
    }
}
