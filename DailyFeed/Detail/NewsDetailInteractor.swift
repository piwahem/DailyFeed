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
        let result = realm.objects(ArticleRealmModel.self).filter(urlPredicate)
        view.onShowBookmarkButton(isShow: result.count == 0)
    }
}
