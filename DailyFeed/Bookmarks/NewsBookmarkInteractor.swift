//
//  NewsBookmarkInteractor.swift
//  DailyFeed
//
//  Created by Admin on 11/18/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

protocol INewsBookmarkInteractor {
    func observerData() -> Results<DailyFeedRealmModel>
    func deleteData(item: DailyFeedRealmModel)
}

class NewsBookmarkInteractor: INewsBookmarkInteractor {
    
    var worker: INewsBookmarkWorker
    
    required init(worker: INewsBookmarkWorker) {
        self.worker = worker
    }
    
    func observerData() -> Results<DailyFeedRealmModel> {
        return worker.observerData()
    }
    
    func deleteData(item: DailyFeedRealmModel) {
        worker.deleteData(item: item)
    }
    
}
