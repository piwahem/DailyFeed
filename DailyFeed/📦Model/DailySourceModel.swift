//
//  DailySourceModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 30/12/16.
//

//Data Model

struct Sources: Codable {
    public let sources: [DailySourceModel]
}

struct DailySourceModel: Codable {
    public var sid: String? = ""
    public var name: String? = ""
    public var category: String? = ""
    public var description: String? = ""
    public var isoLanguageCode: String? = ""
    public var country: String? = ""
    public var url: String? = ""
    
    private enum CodingKeys: String, CodingKey {
        case sid = "id"
        case name, category, description, country, url
        case isoLanguageCode = "language"
    }
    
    static func convertFrom(from: SourceRealmModel) -> DailySourceModel {
            var sourceData  = DailySourceModel()
            sourceData.sid = from.id
            sourceData.name = from.name
            sourceData.category = from.category
            sourceData.isoLanguageCode = from.language
            sourceData.country = from.country
            sourceData.url = from.url
            sourceData.description = from.description
            return sourceData
    }
}

extension Sources {
    var countries: [String] {
        return Array(Set(sources.map { $0.country! }))
    }
    var languages: [String]{
        return Array(Set(sources.map { $0.isoLanguageCode! }))
    }
    
    var categories: [String]{
        return Array(Set(sources.map {$0.category!}))
    }
}
