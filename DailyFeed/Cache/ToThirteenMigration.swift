//
//  ToThirteenMigration.swift
//  DailyFeed
//
//  Created by Admin on 12/23/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

class ToThirteenMigration: CacheMigration{
    
    init(migration: Migration) {
        super.init(migration: migration, oldSchemaVersion: 12)
    }
    
    override func migrating() {
        super.migrating()
        // Add field isBookmark into ArticleRealmModel
        self.migration.enumerateObjects(ofType: ArticleRealmModel.className(), { (old, new
            ) in
            guard let new = new else {
                return
            }
            new["isBookmark"]? = false
        })
        print("add isBookmark field success")
        
        
        // Add value for field isBookmark of ArticleRealmModel from DailyFeedRealmModel
        var urlBookmarks = [String]()
        self.migration.enumerateObjects(ofType: "DailyFeedRealmModel", { (old, newBook) in
            guard let old = old else {
                return
            }
            
            guard let bookmarkUrl = old["url"] as? String else{
                return
            }
            urlBookmarks.append(bookmarkUrl)
        })
        
        var articleList = [MigrationObject]()
        self.migration.enumerateObjects(ofType: ArticleRealmModel.className(), { (old, new
            ) in
            guard let new = new else {
                return
            }
            articleList.append(new)
        })
        
        print("urlBookmark size = \(urlBookmarks.count)")
        print("articleList size = \(articleList.count)")
        articleList = articleList.filter({ (item) -> Bool in
            guard let articleUrl = item["url"] as? String else {
                return false
            }
            return urlBookmarks.contains(articleUrl)
        })
        articleList.forEach({ (item) in
            item["isBookmark"] = true
        })
        print("update isBookmark field success")
        
        // Delete ArticleTestRealmModel and DailyFeedRealmModel
        self.migration.deleteData(forType: "ArticleTestRealmModel")
        self.migration.deleteData(forType: "DailyFeedRealmModel")
        print("delete ArticleTestRealmModel success")
        print("delete DailyFeedRealmModel success")
    }
}
