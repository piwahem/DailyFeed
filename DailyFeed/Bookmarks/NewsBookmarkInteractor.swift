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
    func observerData(action: @escaping ((RealmCollectionChange<Results<ArticleRealmModel>>))->Void, completion: (NotificationToken)->Void) -> Results<ArticleRealmModel>
    func deleteData(item: ArticleRealmModel)
    func handleDeleteData(item: ArticleRealmModel)
    func addData(item: DailyFeedModel)
}

class NewsBookmarkInteractor: INewsBookmarkInteractor {
   
    var worker: INewsBookmarkWorker
    var view: IBookmarkViewController
    
    required init(worker: INewsBookmarkWorker, view: IBookmarkViewController) {
        self.worker = worker
        self.view = view
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
    
    func handleDeleteData(item: ArticleRealmModel) {
        view.showConfirmDeleteDialog(item: item)
    }
}
