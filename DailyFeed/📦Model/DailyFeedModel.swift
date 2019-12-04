//
//  DailyFeedModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import Foundation
import MobileCoreServices

enum DailyFeedModelUTI {
    static let kUUTTypeDailyFeedModel = "kUUTTypeDailyFeedModel"
}

enum DailyFeedModelError: Error {
    case invalidTypeIdentifier
    case invalidDailyFeedModel
}

enum DailySourceConstant: String{
    case emptyId = "emptyId"
    case emptyName = "emptyName"
}

struct Articles: Codable {
    var articles: [DailyFeedModel]
}

//Data Model
final class DailyFeedModel: NSObject, Serializable {
    
    public var title: String = ""
    public var author: String?
    public var publishedAt: String?
    public var urlToImage: String?
    public var articleDescription: String?
    public var url: String?
    public var source: DailyFeedSource = DailyFeedSource(id: DailySourceConstant.emptyId.rawValue, name: DailySourceConstant.emptyName.rawValue)
    
    private enum CodingKeys: String, CodingKey {
        case articleDescription = "description"
        case title, author, publishedAt, urlToImage, url, source
    }
}

struct DailyFeedSource: Codable {
    public var id: String?
    public var name: String?
}

// MARK :- NSProvider read/write method implementations

extension DailyFeedModel: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] = [DailyFeedModelUTI.kUUTTypeDailyFeedModel, kUTTypeUTF8PlainText as String]
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == DailyFeedModelUTI.kUUTTypeDailyFeedModel {
            completionHandler(self.serialize(), nil)
        } else if typeIdentifier == kUTTypeUTF8PlainText as String {
            completionHandler(self.url?.data(using: .utf8), nil)
        } else {
            completionHandler(nil, DailyFeedModelError.invalidDailyFeedModel)
        }
        return nil
    }
}

extension DailyFeedModel: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [DailyFeedModelUTI.kUUTTypeDailyFeedModel]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> DailyFeedModel {
        if typeIdentifier == DailyFeedModelUTI.kUUTTypeDailyFeedModel {
            let dfm = DailyFeedModel()
            do {
                let dailyFeedModel = try dfm.deserialize(data: data)
                return dailyFeedModel
            } catch {
                throw DailyFeedModelError.invalidDailyFeedModel
            }
        } else {
            throw DailyFeedModelError.invalidTypeIdentifier
        }
    }
}

extension DailyFeedModel{
    class func convertFrom(from: ArticleRealmModel) -> DailyFeedModel {
        let item = DailyFeedModel()
        if let title = from.title{
            item.title = title
        }
        
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
        
        if let sourceId = from.sourceID {
            item.source.id = sourceId
        }
        
        return item
    }
}
