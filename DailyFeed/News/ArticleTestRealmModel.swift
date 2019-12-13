//
//  ArticleTestRealmModel.swift
//  DailyFeed
//
//  Created by Admin on 12/13/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import RealmSwift

public final class ArticleTestRealmModel: Object{
    @objc dynamic  var author: String?
    @objc dynamic  var title: String?
    @objc dynamic  var articleDescription: String?
    @objc dynamic  var url: String?
    @objc dynamic  var urlToImage: String?
    @objc dynamic  var publishedAt: String?
    @objc dynamic  var content: String?
    
    @objc dynamic  var source: SourceRealmModel?
    
    override public static func primaryKey() -> String? {
        return "url"
    }
    
    class func convertFrom(from: ArticleRealmModel) -> ArticleTestRealmModel {
        let item = ArticleTestRealmModel()
        item.title = from.title
        
        if let author = from.author{
            item.author = author
        }
        
        if let artDescription = from.articleDescription {
            item.articleDescription = artDescription
        }
        
        if let writer = from.author {
            item.author = writer
            
        }
        
        if let publishedTime = from.publishedAt {
            item.publishedAt = publishedTime
        }
        
        if let url = from.url {
            item.url = url
        }
        
        if let imageFromUrl = from.urlToImage {
            item.urlToImage = imageFromUrl
        }
        
        if let source = from.source{
            item.source = source
        }
        
        return item
    }
}
