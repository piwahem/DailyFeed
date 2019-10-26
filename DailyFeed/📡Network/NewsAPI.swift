//
//  NewsAPI.swift
//  DailyFeed
//
//  Created by Sumit Paul on 13/01/17.
//

import Foundation
import PromiseKit
import Alamofire

enum NewsAPI {
    
    case articles(source: String)
    case sources(category: String?, language: String?, country: String?)
    case search(query: String)
    case logo(source: String)
    
    static var baseURL = URLComponents(string: "https://newsapi.org")
    static let apiToken = "8e58842e74f2453bb5e6e3845b386a81"
    
    //NewsAPI.org API Endpoints
    var url: URL? {
        switch self {
        case .articles(let source):
            let lSource = source
            NewsAPI.baseURL?.path = "/v2/top-headlines"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "sources", value: lSource),
                                           URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
            
        case .sources(let category, let language, let country):
            NewsAPI.baseURL?.path = "/v2/sources"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "category", value: category),
                                           URLQueryItem(name: "language", value: language),
                                           URLQueryItem(name: "country", value: country),
                                           URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
            
        case .search(let query):
            NewsAPI.baseURL?.path = "/v2/everything"
            NewsAPI.baseURL?.queryItems = [URLQueryItem(name: "q", value: query),
                                           URLQueryItem(name: "apiKey", value: NewsAPI.apiToken)]
            guard let url = NewsAPI.baseURL?.url else { return nil }
            return url
            
        //Fetch NewsSourceLogo from Cloudinary as news source logo is deprecated by newsapi.org
        case .logo(let source):
            let sourceLogoUrl = "https://res.cloudinary.com/news-logos/image/upload/v1557987666/\(source).png"
            return URL.init(string: sourceLogoUrl)
        }
    }
}
