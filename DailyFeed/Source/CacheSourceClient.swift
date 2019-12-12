//
//  CacheSourceClient.swift
//  DailyFeed
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation
import PromiseKit

class CacheSourceClient: CacheClient<SourceRealmModel> {
    
    override init() {
        super.init()
        self.getIdParams = { item in
            item.id ?? nil
        }
    }
    
    func getSources(sourceRequestParams: NewsSourceParameters) -> Promise<Sources> {
        return Promise { seal in
            var sources = Sources()
            seal.fulfill(update(&sources, sourceRequestParams: sourceRequestParams))
        }
    }
    
    func addSources(_ article: inout Sources, sourceRequestParams: NewsSourceParameters) -> Promise<Sources>{
        return Promise { seal in
            seal.fulfill(self.updateSources(&article, sourceRequestParams: sourceRequestParams))
        }
    }
    
    private func updateSources(_ source: inout Sources, sourceRequestParams: NewsSourceParameters) -> Sources{
        addData(addList: source.sources.map { (item) -> SourceRealmModel in
            SourceRealmModel.convertFrom(from: item)
        })
        return update(&source, sourceRequestParams: sourceRequestParams)
    }
    
    private func update(_ res: inout Sources, sourceRequestParams: NewsSourceParameters) -> Sources{
        res.sources = Array(getData())
            .filter({ (item) -> Bool in
                var isCategory = true
                var isLanguage = true
                var isCountry = true
                if let category = sourceRequestParams.category{
                    isCategory = category == item.category
                }
                if let language = sourceRequestParams.language{
                    isLanguage = language == item.language
                }
                if let country = sourceRequestParams.country{
                    isCountry = country == item.country
                }
                
                return isCountry && isLanguage && isCategory
            })
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
    
    func isInit(sourceRequestParams: NewsSourceParameters)-> Bool{
        return sourceRequestParams.category == nil &&
            sourceRequestParams.country == nil &&
            sourceRequestParams.language == nil
    }
}
