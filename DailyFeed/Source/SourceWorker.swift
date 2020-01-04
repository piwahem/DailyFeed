//
//  SourceWorker.swift
//  DailyFeed
//
//  Created by Admin on 11/5/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import PromiseKit


protocol ISourceWorker {
    func getSources(params sourceRequestParams: NewsSourceParameters,
                    callback: @escaping ((Sources?, Error?)->Void),
                    completetion: @escaping ()->Void)
    func getCurrentSources() -> Sources?
}

class SourceWorker: ISourceWorker {
    var sources: Sources?
    var pagination: PaginationExecutor<DailySourceModel> = PaginationExecutor<DailySourceModel>()
    var sourceResult: Sources?
    var params: NewsSourceParameters = NewsSourceParameters()
    var page = 0
    
    func getSources(params sourceRequestParams: NewsSourceParameters,
                    callback: @escaping ((Sources?, Error?) -> Void),
                    completetion: @escaping ()->Void) {
        
        if (self.params != sourceRequestParams){
            page = 1
        }else{
            page+=1
        }
        self.params = sourceRequestParams
        
        let newsClient = NewsClient()
        let cachedClient = CacheSourceClient()
        
        firstly {
            cachedClient.getSources(sourceRequestParams: self.params)
            }
            .then { sources -> Promise<Sources> in
                self.pagination.data = sources.sources
                if (cachedClient.isInit(sourceRequestParams: self.params)){
                    self.sources = sources
                }
                self.sourceResult = sources
                self.sourceResult?.sources = self.pagination.getDataToPage(page: self.page)
                self.sourceResult?.firstPage = self.pagination.getFirstPage()
                self.sourceResult?.lastPage = self.pagination.getLastPage()
                self.sourceResult?.dataToCurrentPage = self.page
                callback(self.sourceResult, nil)
                return newsClient.getNewsSource(sourceRequestParams: self.params)
            }
            .then { sources -> Promise<Sources> in
                var result = sources
                return cachedClient.addSources(&result, sourceRequestParams: self.params)
            }
            .done { result in
                self.pagination.data = result.sources
                
                if (cachedClient.isInit(sourceRequestParams: self.params)){
                    self.sources = result
                }
                self.sourceResult = self.sources
                self.sourceResult?.sources = self.pagination.getDataToPage(page: self.page)
                self.sourceResult?.firstPage = self.pagination.getFirstPage()
                self.sourceResult?.lastPage = self.pagination.getLastPage()
                self.sourceResult?.dataToCurrentPage = self.page
                callback(self.sourceResult, nil)
                
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                if (self.isShowError(error: err.localizedDescription, source: self.sourceResult)){
                    callback(nil, err)
                }
        }
    }
    
    func getCurrentSources() -> Sources?{
        return sources
    }
    
    private func isShowError(error: String, source: Sources?) -> Bool{
        return !(isNetworkError(error: error) && !isResultEmpty(source: source))
    }
    
    private func isNetworkError(error: String)->Bool{
        return error == NetworkError.NO_INTERNET_CONNECTION.rawValue
    }
    
    private func isResultEmpty(source: Sources?) -> Bool{
        return source?.sources.isEmpty ?? true
    }
}
