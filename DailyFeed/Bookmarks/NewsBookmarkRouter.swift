//
//  NewsBookmarkRouter.swift
//  DailyFeed
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol INewsBookmarkRouter {
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?)
    func navigateToDetail(sender: Any?)
}

class NewsBookmarkRouter: INewsBookmarkRouter {
    
    weak var viewController: BookmarkViewController!
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.bookmarkViewController.bookmarkSourceSegue.identifier {
            if let vc = segue.destination as? NewsDetailViewController {
                guard let cell = sender as? UICollectionViewCell else { return }
                guard let indexpath = viewController.bookmarkCollectionView.indexPath(for: cell) else { return }
                vc.receivedItemNumber = indexpath.row + 1
                let item = viewController.newsItems[indexpath.row]
                vc.receivedNewsItem = ArticleTestRealmModel.convertFrom(from: item)
            }
        }
    }
    
    func navigateToDetail(sender: Any?) {
        viewController.performSegue(withIdentifier: R.segue.bookmarkViewController.bookmarkSourceSegue, sender: sender)
    }
    
}
