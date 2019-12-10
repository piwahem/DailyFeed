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
    
    func getNews(source: String) -> Promise<Articles> {
        return Promise { seal in
            var article = Articles()
            update(&article, source: source)
            seal.fulfill(article)
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
        update(&article, source: source)
        return article
    }
    
    private func update(_ article: inout Articles, source: String){
        article.articles = Array(getData())
            .filter{$0.source?.id == source}
            .map {DailyFeedModel.convertFrom(from: $0)}
        
        article.articles.sort { (a, b) -> Bool in
            if let dateA = a.publishedAt?.dateFromTimestamp,
                let dateB = b.publishedAt?.dateFromTimestamp{
                return dateA > dateB
            }
            return false
        }
    }
}
