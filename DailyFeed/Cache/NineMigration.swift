//
//  NineMigration.swift
//  DailyFeed
//
//  Created by Admin on 12/17/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

class NineMigration: CacheMigration{
    
    init(migration: Migration) {
        super.init(migration: migration, oldSchemaVersion: 8)
    }
    
    override func migrating() {
        super.migrating()
        var urlBookmarks = [String]()
        self.migration.enumerateObjects(ofType: DailyFeedRealmModel.className(), { (old, newBook) in
            guard let old = old else {
                return
            }
            
            guard let bookmarkUrl = old["url"] as? String else{
                return
            }
            urlBookmarks.append(bookmarkUrl)
        })
        
        var testNewList = [MigrationObject]()
        self.migration.enumerateObjects(ofType: ArticleTestRealmModel.className(), { (old, new
            ) in
            guard let new = new else {
                return
            }
            testNewList.append(new)
        })
        
        print("urlBookmark size = \(urlBookmarks.count)")
        print("testNewList size = \(testNewList.count)")
        testNewList = testNewList.filter({ (item) -> Bool in
            guard let articleUrl = item["url"] as? String else {
                return false
            }
            return urlBookmarks.contains(articleUrl)
        })
        testNewList.forEach({ (item) in
            item["isBookmark"] = true
        })
    }
}
