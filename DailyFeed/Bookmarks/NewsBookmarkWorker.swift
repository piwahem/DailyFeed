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
    func observerData() -> Results<DailyFeedRealmModel>
    func deleteData(item: DailyFeedRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkWorker: INewsBookmarkWorker {
    
    let realm = try! Realm()

    func observerData() -> Results<DailyFeedRealmModel> {
        return realm.objects(DailyFeedRealmModel.self)
    }
    
    func deleteData(item: DailyFeedRealmModel){
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func addData(item: DailyFeedModel) {
        let dailyfeedRealmModel = DailyFeedRealmModel.toDailyFeedRealmModel(from: item)
        try! realm.write {
            realm.add(dailyfeedRealmModel, update: true)
        }
    }
}
