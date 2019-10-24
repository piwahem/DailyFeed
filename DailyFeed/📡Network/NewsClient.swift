//
//  NewsClient.swift
//  DailyFeed
//
//  Created by Admin on 10/23/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class NewsClient: RestClient {
    
    init() {
        super.init(baseUrl: BaseURL.base)
    }
    
    // Get News articles from /articles endpoint
    func getNewsItems(source: String) -> Promise<Articles> {
        let url = NewsAPI.articles(source: source).url
        return request(url)
    }
    
    // Get News source from /sources endpoint of NewsAPI
    func getNewsSource(sourceRequestParams: NewsSourceParameters) -> Promise<Sources> {
        let url = NewsAPI.sources(category: sourceRequestParams.category,
                                  language: sourceRequestParams.language,
                                  country: sourceRequestParams.country).url
        return request(url)
    }
    
    func searchNews(with query: String) -> Promise<Articles> {
        let url = NewsAPI.search(query: query).url
        return request(url)
    }
}
