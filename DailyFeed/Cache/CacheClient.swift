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
    
    func addData(list: [T]) {
        let realm = try! Realm()
        list.forEach { (item) in
            try! realm.write {
                realm.add(item, update: true)
            }
        }
    }
    
    func getData() -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }

}
