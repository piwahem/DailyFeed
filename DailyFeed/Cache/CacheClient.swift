//
//  CacheClient.swift
//  DailyFeed
//
//  Created by Admin on 11/28/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

class CacheClient<T: Object> {
    
    var getIdParams: ((T) -> String?)?

    
    func addData(addList: [T]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(addList, update: true)
        }
    }
    
    func getData() -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    func deleteData(item: T){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
    }
}
