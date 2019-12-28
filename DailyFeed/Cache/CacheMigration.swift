//
//  CacheMigration.swift
//  DailyFeed
//
//  Created by Admin on 12/17/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

protocol CacheMigrating {
    func migrating()
}

class CacheMigration: CacheMigrating {
    var migration: Migration
    var oldSchemaVersion: Int64
    
    init(migration: Migration, oldSchemaVersion: Int64) {
        self.migration = migration
        self.oldSchemaVersion  = oldSchemaVersion
    }
    
    func migrating() {
        print("migrating from \(oldSchemaVersion)")
    }
}
