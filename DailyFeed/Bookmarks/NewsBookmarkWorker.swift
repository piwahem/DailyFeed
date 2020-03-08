//
//  NewsBookmarkWorker.swift
//  DailyFeed
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

protocol INewsBookmarkWorker {
    func observerData() -> Results<ArticleRealmModel>
    func deleteData(item: ArticleRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkWorker: INewsBookmarkWorker {
    
    let realm = try! Realm()

    func observerData() -> Results<ArticleRealmModel> {
        let predicate = NSPredicate(format: "isBookmark = %@", NSNumber(value: true))
        return realm.objects(ArticleRealmModel.self).filter(predicate)
    }
    
    func deleteData(item: ArticleRealmModel){
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func addData(item: DailyFeedModel) {
        let dailyfeedRealmModel = ArticleRealmModel.convertFrom(from: item)
        try! realm.write {
            dailyfeedRealmModel.isBookmark = true
            realm.add(dailyfeedRealmModel, update: .all)
        }
    }
}
