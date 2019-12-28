//
//  NewsBookmarkTestInteractor.swift
//  DailyFeed
//
//  Created by Admin on 12/21/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

protocol INewsBookmarkTestInteractor {
    func observerData(action: @escaping ((RealmCollectionChange<Results<ArticleRealmModel>>))->Void, completion: (NotificationToken)->Void) -> Results<ArticleRealmModel>
    func deleteData(item: ArticleRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkTestInteractor: INewsBookmarkTestInteractor {
    
    var worker: INewsBookmarkTestWorker
    
    required init(worker: INewsBookmarkTestWorker) {
        self.worker = worker
    }
    
    func observerData(action: @escaping ((RealmCollectionChange<Results<ArticleRealmModel>>)) -> Void, completion: (NotificationToken)->Void) -> Results<ArticleRealmModel> {
        let data =  worker.observerData()
        let notificationToken = data.observe { [weak self] (changes: RealmCollectionChange) in
            action(changes)
        }
        completion(notificationToken)
        return data
    }
    
    func deleteData(item: ArticleRealmModel) {
        worker.deleteData(item: item)
    }
    
    func addData(item: DailyFeedModel){
        worker.addData(item: item)
    }
}
