//
//  NewsBookmarkTestRouter.swift
//  DailyFeed
//
//  Created by Admin on 12/21/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol INewsBookmarkTestRouter {
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?)
    func navigateToDetail(sender: Any?)
}

class NewsBookmarkTestRouter: INewsBookmarkTestRouter {
    
    weak var viewController: TestViewController!

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.testViewController.bookmarkTestSourceSegue.identifier {
            if let vc = segue.destination as? NewsDetailViewController {
                guard let cell = sender as? UICollectionViewCell else { return }
                guard let indexpath = viewController.bookmarkCollectionView.indexPath(for: cell) else { return }
                vc.receivedItemNumber = indexpath.row + 1
                vc.receivedNewsItem = viewController.newsItems[indexpath.row]
            }
        }
    }

    func navigateToDetail(sender: Any?) {
        viewController.performSegue(withIdentifier: R.segue.testViewController.bookmarkTestSourceSegue, sender: sender)
    }
    
}
