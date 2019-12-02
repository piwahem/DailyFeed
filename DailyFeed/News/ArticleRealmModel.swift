// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let articleRealmModel = try? newJSONDecoder().decode(ArticleRealmModel.self, from: jsonData)

import Foundation
import RealmSwift

// MARK: - ArticleRealmModel
public final class ArticleRealmModel: Object{
    @objc dynamic  var author: String?
    @objc dynamic  var title: String?
    @objc dynamic  var articleDescription: String?
    @objc dynamic  var url: String?
    @objc dynamic  var urlToImage: String?
    @objc dynamic  var publishedAt: String?
    @objc dynamic  var content: String?
    
    @objc dynamic  var sourceID: String?
    
    override public static func primaryKey() -> String? {
        return "url"
    }
    
    class func converFrom(from: DailyFeedModel) -> ArticleRealmModel {
        let item = ArticleRealmModel()
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
            item.sourceID = URL(string: url)?.baseURL?.absoluteString
        }
        
        if let imageFromUrl = from.urlToImage {
            item.urlToImage = imageFromUrl
        }
        
        return item
    }
}
