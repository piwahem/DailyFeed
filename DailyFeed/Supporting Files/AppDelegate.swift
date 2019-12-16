//
//  AppDelegate.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit
import RealmSwift
import CoreSpotlight

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = .black
        application.extendStateRestoration()
        realmMigration()
        let _ = try! Realm()
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func realmMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 9,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    print("smaller than 1")
                }
                
                if (oldSchemaVersion < 2) {
                    print("smaller than 2")
                }
                
                if (oldSchemaVersion < 3) {
                    print("smaller than 3")
                }
                
                if (oldSchemaVersion < 4){
                    print("smaller than 4")
                }
                if (oldSchemaVersion < 9){
                    print("smaller than 9")
                    var urlBookmarks = [String]()
                    migration.enumerateObjects(ofType: DailyFeedRealmModel.className(), { (old, newBook) in
                        guard let old = old else {
                            return
                        }
                        
                        guard let bookmarkUrl = old["url"] as? String else{
                            return
                        }
                        urlBookmarks.append(bookmarkUrl)
                    })
                    
                    var testNewList = [MigrationObject]()
                    migration.enumerateObjects(ofType: ArticleTestRealmModel.className(), { (old, new
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
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
