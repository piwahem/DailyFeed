//
//  NewsDetailRouter.swift
//  DailyFeed
//
//  Created by Admin on 11/11/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import UIKit

protocol INewsDetailRouter {
    func openSafari()
    func openBookmarkActivity(item: ArticleRealmModel?)
}

class NewsDetailRouter: INewsDetailRouter {
    
    weak var viewController: NewsDetailViewController!
    
    func openSafari(){
        guard let articleString = viewController.articleStringURL, let url = URL(string: articleString) else { return }
        let svc = DFSafariViewController(url: url)
        svc.delegate = viewController
        viewController.present(svc, animated: true, completion: nil)
    }
    
    func openBookmarkActivity(item: ArticleRealmModel?) {
        guard let shareURL = item?.url,
            let articleImage = viewController.captureScreenShot(),
        let articleToBookmarkData = item else {return}
        
        let bookmarkactivity = BookmarkActivity()
        
        bookmarkactivity.bookMarkSuccessful = {
            self.viewController.onBookmarkResult(isSuccess: true)
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [shareURL, articleImage, articleToBookmarkData],
            applicationActivities: [bookmarkactivity]
        )
        activityVC.excludedActivityTypes = [.saveToCameraRoll,
                                            .copyToPasteboard,
                                            .airDrop,
                                            .addToReadingList,
                                            .assignToContact,
                                            .postToTencentWeibo,
                                            .postToVimeo,
                                            .print,
                                            .postToWeibo]
        activityVC.completionWithItemsHandler = {(activityType, completed: Bool, _, _) in
            self.viewController.onBookmarkProcessing(isProcessing: false)
        }
        
        // Popover for iPad only
        
        let popOver = activityVC.popoverPresentationController
        popOver?.sourceView = self.viewController.shareButton
        popOver?.sourceRect = self.viewController.shareButton.bounds
        self.viewController.present(activityVC, animated: true, completion: nil)
    }
}
