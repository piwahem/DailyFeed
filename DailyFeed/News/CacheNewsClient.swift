//
//  CacheNewsClient.swift
//  DailyFeed
//
//  Created by Admin on 12/10/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import PromiseKit

class CacheNewsClient: CacheClient<ArticleRealmModel> {
    
    override init() {
        super.init()
        self.getIdParams = { item in
            item.url ?? nil
        }
    }
    
    func searchNews(query: String) -> Promise<Articles> {
        return Promise { seal in
            var article = Articles()
            let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR articleDescription CONTAINS[c] %@ OR content CONTAINS[c] %@", query, query, query)
            seal.fulfill(self.update(&article, predicate: predicate))
        }
    }
    
    func getNews(source: String) -> Promise<Articles> {
        return Promise { seal in
            var article = Articles()
            seal.fulfill(update(&article ,predicate: NSPredicate(format: "source.id == %@", source)))
        }
    }
    
    func addNews(_ article: inout Articles, source: String) -> Promise<Articles>{
        return Promise { seal in
            let result = self.updateNews(&article, source: source)
            seal.fulfill(result)
        }
    }
    
    private func updateNews(_ article: inout Articles, source: String) -> Articles{
        addData(addList: article.articles.map { (item) -> ArticleRealmModel in
            ArticleRealmModel.convertFrom(from: item)
        })
        return update(&article, predicate: NSPredicate(format: "source.id == %@", source))
    }
    
    private func update(_ article: inout Articles, predicate: NSPredicate) -> Articles{
        article.articles = Array(getData().filter(predicate))
            .map {DailyFeedModel.convertFrom(from: $0)}
        sort(&article)
        return article
    }
    
    private func sort(_ article: inout Articles){
        article.articles.sort { (a, b) -> Bool in
            if let dateA = a.publishedAt?.dateFromTimestamp,
                let dateB = b.publishedAt?.dateFromTimestamp{
                return dateA > dateB
            }
            return false
        }
    }
}
