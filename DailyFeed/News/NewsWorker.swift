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
    
    var article: Articles?
    var pagination: PaginationExecutor<DailyFeedModel> = PaginationExecutor<DailyFeedModel>()
    var articleResult: Articles?
    var params: String?
    var page = 0
    
    func getNews(_ source: String,
                 callback: @escaping ((Articles?, Error?) -> Void),
                 completetion: @escaping ()->Void) {
        
        if (self.params != source){
            page = 1
        }else{
            page+=1
        }
        self.params = source
        
        let newsClient = NewsClient()
        let newsCached = CacheNewsClient()
        
        firstly {
            newsCached.getNews(source: source)
            }
            .then { article -> Promise<Articles> in
                self.pagination.data = article.articles
                
                self.articleResult = article
                self.articleResult?.articles = self.pagination.getDataToPage(page: self.page)
                self.articleResult?.firstPage = self.pagination.getFirstPage()
                self.articleResult?.lastPage = self.pagination.getLastPage()
                self.articleResult?.dataToCurrentPage = self.page
                
                callback(self.articleResult, nil)
                return newsClient.getNewsItems(source: source)
            }
            .then { article -> Promise<Articles> in
                var result = article
                return newsCached.addNews(&result, source: source)
            }
            .done{ result in
                self.pagination.data = result.articles
                
                self.articleResult = result
                self.articleResult?.articles = self.pagination.getDataToPage(page: self.page)
                self.articleResult?.firstPage = self.pagination.getFirstPage()
                self.articleResult?.lastPage = self.pagination.getLastPage()
                self.articleResult?.dataToCurrentPage = self.page
                
                callback(self.articleResult, nil)
            }
            .ensure(on: .main) {
                completetion()
            }
            .catch(on: .main) { err in
                if (self.isShowError(error: err.localizedDescription, article: self.articleResult)){
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
