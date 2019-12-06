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
            }
            .then { article -> Promise<Articles> in
                var result = article
                return self.handleResponse(&result, source: source)
            }
            .done{ result in
                callback(result, nil)
            }
            .ensure(on: .main) {
                completetion()
            }
            .catch(on: .main) { err in
                callback(nil, err)
        }
    }
    
    private func handleResponse(_ article: inout Articles, source: String) -> Promise<Articles>{
        return Promise { seal in
            let result = self.updateResponse(&article, source: source)
            seal.fulfill(result)
        }
    }
    
    private func updateResponse(_ article: inout Articles, source: String) -> Articles{
        let newsCache = CacheClient<ArticleRealmModel>()
        newsCache.getIdParams = { item in
            item.url ?? nil
        }
        
        newsCache.addData(addList: article.articles.map { (item) -> ArticleRealmModel in
            ArticleRealmModel.convertFrom(from: item)
        })

        article.articles = Array(newsCache.getData())
                            .filter{$0.source?.id == source}
                            .map {DailyFeedModel.convertFrom(from: $0)}
        
        article.articles.sort { (a, b) -> Bool in
            if let dateA = a.publishedAt?.dateFromTimestamp,
                let dateB = b.publishedAt?.dateFromTimestamp{
                return dateA > dateB
            }
            return false
        }
        return article
    }
}
