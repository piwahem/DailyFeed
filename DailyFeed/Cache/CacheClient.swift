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
    
    var getIdParams: ((T) -> String)?

    
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
    
    func deleteData(item: T){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func merge(oldList: [T], newList: [T]) -> [T]{
        guard let getId = getIdParams else {
            return [T]()
        }
        
        let ids = newList.map { (item) -> String in
            getId(item)
        }
        
        var result = oldList.filter { (item) -> Bool in
            !ids.contains(getId(item))
        }
        
        result.append(contentsOf: newList)
        return result
    }

}
