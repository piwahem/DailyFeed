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
    
    func getSources(params sourceRequestParams: NewsSourceParameters,
                    callback: @escaping ((Sources?, Error?) -> Void),
                    completetion: @escaping ()->Void) {
        let newsClient = NewsClient()
        let cachedClient = CacheSourceClient()
        var sourceResult: Sources?
        
        firstly {
            cachedClient.getSources(sourceRequestParams: sourceRequestParams)
            }
            .then { sources -> Promise<Sources> in
                if (cachedClient.isInit(sourceRequestParams: sourceRequestParams)){
                    self.sources = sources
                }
                sourceResult = sources
                callback(sources, nil)
                return newsClient.getNewsSource(sourceRequestParams: sourceRequestParams)
            }
            .then { sources -> Promise<Sources> in
                var result = sources
                return cachedClient.addSources(&result, sourceRequestParams: sourceRequestParams)
            }
            .done { result in
                if (cachedClient.isInit(sourceRequestParams: sourceRequestParams)){
                    self.sources = result
                }
                sourceResult = result
                callback(result, nil)
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                if (self.isShowError(error: err.localizedDescription, source: sourceResult)){
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
