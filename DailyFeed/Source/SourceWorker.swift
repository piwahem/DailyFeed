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
            }.done { result in
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
}
