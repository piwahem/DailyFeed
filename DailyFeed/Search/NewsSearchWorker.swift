//
//  NewsSearchWorker.swift
//  DailyFeed
//
//  Created by Admin on 11/13/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import PromiseKit

protocol INewSearchWorker {
    func searchNews(_ query: String,
                    callback: @escaping ((Articles?, Error?)->Void),
                    completetion: @escaping ()->Void)
}

class NewsSearchWorker: INewSearchWorker {
    
    func searchNews(_ query: String,
                    callback: @escaping ((Articles?, Error?) -> Void),
                    completetion: @escaping ()->Void) {
        let newsClient = NewsClient()
        let newsCache = CacheNewsClient()
        var items: Articles?
        
        firstly {
            newsCache.searchNews(query: query)
            }
            .then { article -> Promise<Articles> in
                items = article
                callback(article, nil)
                return newsClient.searchNews(with: query)
            }
            .done { result in
                items = result
                callback(result, nil)
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                if (self.isShowError(error: err.localizedDescription, article: items)){
                    callback(nil, err)
                }
        }
    }
    
    private func isShowError(error: String, article: Articles?) -> Bool{
        return !(isNetworkError(error: error) && !isResultEmpty(article: article))
    }
    
    private func isNetworkError(error: String)->Bool{
        return error == NetworkError.NO_INTERNET_CONNECTION.rawValue
    }
    
    private func isResultEmpty(article: Articles?) -> Bool{
        return article?.articles.isEmpty ?? true
    }
}
