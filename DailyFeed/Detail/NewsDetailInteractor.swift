//
//  NewsDetailInteractor.swift
//  DailyFeed
//
//  Created by Admin on 3/10/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import RealmSwift

protocol INewsDetailInteractor {
    func handleInit(detailItem: ArticleRealmModel?)
    func bookmarkDetail()
}
class NewsDetailInteractor: INewsDetailInteractor {
    var view: INewsDetailViewController
    
    required init(view: INewsDetailViewController) {
        self.view = view
    }
    
    func handleInit(detailItem: ArticleRealmModel?) {
        guard let url = detailItem?.url else {
            return
        }
        let realm = try! Realm()
        let urlPredicate = NSPredicate(format: "url == %@", url)
        let isBookmarkPredicate = NSPredicate(format: "isBookmark = %@", NSNumber(value: true))
        let result =  realm.objects(ArticleRealmModel.self).filter(urlPredicate).filter(isBookmarkPredicate)
        view.onShowBookmarkButton(isShow: result.count == 0)
    }
    
    func bookmarkDetail() {
        view.onBookmarkProcessing(isProcessing: true)
        let delay = DispatchTime.now() + 0.11
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.view.onBookmarkActivity()
        }
    }
}
