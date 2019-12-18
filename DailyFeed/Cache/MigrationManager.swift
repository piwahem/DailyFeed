//
//  MigrationManager.swift
//  DailyFeed
//
//  Created by Admin on 12/17/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

enum CacheVersion:Int {
    case CURRENT_VERSION = 12
    
}

class MigrationManager {
    
    var currentVersion: Int64 = Int64(CacheVersion.CURRENT_VERSION.rawValue)
    var oldVersion: Int64
    var migration: Migration
    
    init(migration: Migration, oldVersion: Int64) {
        self.migration = migration
        self.oldVersion = oldVersion
    }
    
    func handle() {
        for i in oldVersion...currentVersion - 1 {
            switch i {
            case 0..<7:
                CacheMigration(migration: migration, oldSchemaVersion: Int64(i)).migrating()
            case 8:
                ToNineMigration(migration: migration).migrating()
            case 11:
                ToTwelveMigration(migration: migration).migrating()
            default:
                CacheMigration(migration: migration, oldSchemaVersion: Int64(i)).migrating()
            }
        }
    }
}
