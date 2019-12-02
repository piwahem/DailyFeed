//
//  SourceRealmModel.swift
//  DailyFeed
//
//  Created by Admin on 12/2/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

public final class SourceRealmModel: Object{
    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var sourceDescription: String?
    @objc dynamic var category: String?
    @objc dynamic var language: String?
    @objc dynamic var country: String?
    
    @objc dynamic var url: String?
    
    override public static func primaryKey() -> String? {
        return "url"
    }
    
    class func convertFrom(from: DailySourceModel) -> SourceRealmModel{
        let item = SourceRealmModel()
        item.id = from.sid
        item.name = from.name
        item.sourceDescription = from.description
        item.url = from.url
        item.category = from.category
        item.language = from.isoLanguageCode
        item.country = from.country
        return item
    }
}
