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
    func observerData(action: @escaping ((RealmCollectionChange<Results<DailyFeedRealmModel>>))->Void, completion: (NotificationToken)->Void) -> Results<DailyFeedRealmModel>
    func deleteData(item: DailyFeedRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkInteractor: INewsBookmarkInteractor {
    
    var worker: INewsBookmarkWorker
    
    required init(worker: INewsBookmarkWorker) {
        self.worker = worker
    }
    
    func observerData(action: @escaping ((RealmCollectionChange<Results<DailyFeedRealmModel>>)) -> Void, completion: (NotificationToken)->Void) -> Results<DailyFeedRealmModel> {
        let data =  worker.observerData()
        let notificationToken = data.observe { [weak self] (changes: RealmCollectionChange) in
            action(changes)
        }
        completion(notificationToken)
        return data
    }
    
    func deleteData(item: DailyFeedRealmModel) {
        worker.deleteData(item: item)
    }
    
    func addData(item: DailyFeedModel){
        worker.addData(item: item)
    }
}
