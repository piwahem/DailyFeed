//
//  BookmarkActivity.swift
//  DailyFeed
//
//  Created by Sumit Paul on 10/02/17.
//

import UIKit
import RealmSwift

class BookmarkActivity: UIActivity {
    var bookMarkSuccessful: (() -> Void)? = nil
    
    override var activityTitle: String? {
        return "Bookmark"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "bookmark")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activity in activityItems {
            if activity is ArticleRealmModel {
                return true
            }
        }
        return false
    }
    
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for activity in activityItems {
            if let activity = activity as? ArticleRealmModel{
                let realm = try! Realm()
                try! realm.write {
                    activity.isBookmark = true
                    realm.add(activity, update: true)
                    bookMarkSuccessful?()
                }
                break
            }
        }
    }
}
