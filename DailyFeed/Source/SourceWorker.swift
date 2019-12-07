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
        
        firstly {
            newsClient.getNewsSource(sourceRequestParams: sourceRequestParams)
            }
            .then { sources -> Promise<Sources> in
                var result = sources
                return self.handleResponse(&result)
            }
            .done { result in
                if (self.isInit(sourceRequestParams: sourceRequestParams)){
                    self.sources = result
                }
                callback(result, nil)
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                callback(nil, err)
        }
    }
    
    func getCurrentSources() -> Sources?{
        return sources
    }
    
    private func isInit(sourceRequestParams: NewsSourceParameters)-> Bool{
        return sourceRequestParams.category == nil &&
            sourceRequestParams.country == nil &&
            sourceRequestParams.language == nil
    }
    
    private func handleResponse(_ source: inout Sources) -> Promise<Sources>{
        return Promise { seal in
            let result = self.updateResponse(&source)
            seal.fulfill(result)
        }
    }
    
    private func updateResponse(_ res: inout Sources) -> Sources{
        let newsCache = CacheClient<SourceRealmModel>()
        newsCache.getIdParams = { item in
            item.id ?? nil
        }
        
        newsCache.addData(addList: res.sources.map { (item) -> SourceRealmModel in
            SourceRealmModel.convertFrom(from: item)
        })
        
        res.sources = Array(newsCache.getData())
            .map {DailySourceModel.convertFrom(from: $0)}
        
        res.sources.sort { (a, b) -> Bool in
            if let idA = a.sid,
                let idB = b.sid {
                return idA < idB
            }
            return false
        }
        return res
    }
}
