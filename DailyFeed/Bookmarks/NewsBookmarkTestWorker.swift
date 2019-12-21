//
//  NewsBookmarkTestWorker.swift
//  DailyFeed
//
//  Created by Admin on 12/21/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

protocol INewsBookmarkTestWorker {
    func observerData() -> Results<ArticleTestRealmModel>
    func deleteData(item: ArticleTestRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkTestWorker: INewsBookmarkTestWorker {
    
    let realm = try! Realm()
    
    func observerData() -> Results<ArticleTestRealmModel> {
        return realm.objects(ArticleTestRealmModel.self)
    }
    
    func deleteData(item: ArticleTestRealmModel){
        let bookmarkItem = realm.objects(ArticleTestRealmModel.self).filter { (newsItem) -> Bool in
            item.url == newsItem.url
        }.first
        if let item = bookmarkItem{
            try! realm.write {
                item.isBookmark = false
            }
        }
    }
    
    func addData(item: DailyFeedModel) {
        let article = ArticleRealmModel.convertFrom(from: item)
        let testArticle = ArticleTestRealmModel.convertFrom(from: article)
        try! realm.write {
            realm.add(testArticle, update: true)
        }
    }
}
