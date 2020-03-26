//
//  NewsSourceRequestParameters.swift
//  DailyFeed
//
//  Created by Sumit Paul on 05/05/19.
//

import Foundation

public struct NewsSourceParameters: Equatable {
    let category: String?
    let language: String?
    let country: String?
    
    init(category: String? = nil, language: String? = nil, country: String? = nil) {
        self.category = category
        self.language = language
        self.country = country
    }
    
    public static func == (lhs: NewsSourceParameters, rhs: NewsSourceParameters) -> Bool {
        let isEqual = lhs.category == rhs.category
            && lhs.language == rhs.language
            && lhs.country == rhs.country
        return isEqual
    }
}
