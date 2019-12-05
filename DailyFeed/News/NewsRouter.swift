//
//  NewsRouter.swift
//  DailyFeed
//
//  Created by Admin on 11/2/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol INewsRouter {
    // NOTE: Teach the router how to navigate to another scene. Some examples follow:
    
    // 1. Trigger a storyboard segue
    // viewController.performSegueWithIdentifier("ShowSomewhereScene", sender: nil)
    
    // 2. Present another view controller programmatically
    // viewController.presentViewController(someWhereViewController, animated: true, completion: nil)
    
    // 3. Ask the navigation controller to push another view controller onto the stack
    // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
    
    // 4. Present a view controller from a different storyboard
    // let storyboard = UIStoryboard(name: "OtherThanMain", bundle: nil)
    // let someWhereViewController = storyboard.instantiateInitialViewController() as! SomeWhereViewController
    // viewController.navigationController?.pushViewController(someWhereViewController, animated: true)
    func navigateToDetail(sender: Any?)
    func navigateToSource()
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?)
    func receiveDataFromScene(segue: UIStoryboardSegue)
}

class NewsRouter: INewsRouter {
    
    weak var viewController: DailyFeedNewsController!
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.dailyFeedNewsController.newsDetailSegue.identifier{
            passDataToNewsDetail(segue: segue, sender: sender)
        }
    }
    
    func receiveDataFromScene(segue: UIStoryboardSegue) {
        if segue.identifier == R.segue.newsSourceViewController.sourceUnwindSegue.identifier{
            receiveDataFromNewsSource(segue: segue, sender: nil)
        }
    }
    
    func navigateToDetail(sender: Any?) {
        viewController.performSegue(withIdentifier: R.segue.dailyFeedNewsController.newsDetailSegue,
                                    sender: sender)
    }
    
    func navigateToSource() {
        viewController.performSegue(withIdentifier: R.segue.dailyFeedNewsController.newsSourceSegue, sender: viewController)
    }
    
    private func passDataToNewsDetail(segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? NewsDetailViewController {
            guard let cell = sender as? UICollectionViewCell else { return }
            guard let indexpath = viewController.newsCollectionView?.indexPath(for: cell) else { return }
            vc.transitioningDelegate = viewController
            vc.modalPresentationStyle = .formSheet
            vc.receivedNewsItem = DailyFeedRealmModel.toDailyFeedRealmModel(from: viewController.newsItems[indexpath.row])
            vc.receivedItemNumber = indexpath.row + 1
            vc.receivedNewsSourceLogo = NewsSource.logo(source: (viewController.interactor?.source)!).url?.absoluteString
            vc.isLanguageRightToLeftDetailView = viewController.isLanguageRightToLeft
        }
    }
    
    private func receiveDataFromNewsSource(segue: UIStoryboardSegue, sender: Any?){
        if let sourceVC = segue.source as? NewsSourceViewController, let sourceId = sourceVC.selectedItem?.sid {
            
            let oldSource = (viewController.interactor?.source)!
            let oldIsLanguageRightToLeft = viewController.isLanguageRightToLeft
            
            viewController.isLanguageRightToLeft = sourceVC.selectedItem?.isoLanguageCode?.direction == .rightToLeft
            viewController.interactor?.source = sourceId
            viewController.loadNewsData(){ success in
                if (!success){
                    self.viewController.showErrorWithDelay("Your Internet Connection appears to be offline.")
                    self.viewController.interactor?.source = oldSource
                    self.viewController.isLanguageRightToLeft = oldIsLanguageRightToLeft
                }
            }
        }
    }
}
