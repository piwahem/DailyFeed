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
    func observerData() -> Results<ArticleRealmModel>
    func deleteData(item: ArticleRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkTestWorker: INewsBookmarkTestWorker {
    
    let realm = try! Realm()
    
    func observerData() -> Results<ArticleRealmModel> {
        return realm.objects(ArticleRealmModel.self)
    }
    
    func deleteData(item: ArticleRealmModel){
        if let url = item.url, let item = getBookmarkItem(url: url){
            try! realm.write {
                item.isBookmark = false
            }
        }
    }
    
    func addData(item: DailyFeedModel) {
        if let url = item.url, let updateItem = getBookmarkItem(url: url){
            try! realm.write {
                updateItem.isBookmark = true
            }
        } else {
            let article = ArticleRealmModel.convertFrom(from: item)
            try! realm.write {
                article.isBookmark = true
                realm.add(article, update: true)
            }
        }
    }
    
    private func getBookmarkItem(url: String)-> ArticleRealmModel?{
        let bookmarkItem = realm.objects(ArticleRealmModel.self).filter { (newsItem) -> Bool in
            url == newsItem.url
            }.first
        return bookmarkItem
    }
}
