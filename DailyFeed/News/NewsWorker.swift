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
        let newsCached = CacheNewsClient()
        
        firstly {
            newsCached.getNews(source: source)
            }
            .then { article -> Promise<Articles> in
                callback(article, nil)
                return newsClient.getNewsItems(source: source)
            }
            .then { article -> Promise<Articles> in
                var result = article
                return newsCached.addNews(&result, source: source)
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
}
