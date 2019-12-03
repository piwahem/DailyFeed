//
//  NewsWorker.swift
//  DailyFeed
//
//  Created by Admin on 10/29/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import PromiseKit



protocol INewsWorker {
    func getNews(_ source: String,
                 callback: @escaping ((Articles?, Error?)->Void),
                 completetion: @escaping ()->Void)
    
    var source: String {get set}
}

class NewsWorker: INewsWorker {
    
    var source: String {
        get {
            guard let defaultSource = UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.string(forKey: "source") else {
                return "the-wall-street-journal"
            }
            
            return defaultSource
        }
        
        set {
            UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.set(newValue, forKey: "source")
        }
    }
    
    
    func getNews(_ source: String,
                 callback: @escaping ((Articles?, Error?) -> Void),
                 completetion: @escaping ()->Void) {
        let newsClient = NewsClient()
        
        firstly {
            newsClient.getNewsItems(source: source)
            }.done { result in
                callback(result, nil)
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                callback(nil, err)
        }
    }
    
    private func handleResponse(_ article: inout Articles) -> Articles{
        let newsCache = CacheClient<ArticleRealmModel>()
        newsCache.getIdParams = { item in
            item.url ?? nil
        }
        
        let reamlItems = article.articles.map { (item) -> ArticleRealmModel in
            ArticleRealmModel.converFrom(from: item)
        }
        newsCache.addData(addList: reamlItems)
        
        let data = newsCache.getData()
        let list = Array(data)
        let items = list.map {DailyFeedModel.converFrom(from: $0)}
        article.articles = items
        return article
    }
}
