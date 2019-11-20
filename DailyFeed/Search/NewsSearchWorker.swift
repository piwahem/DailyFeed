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
        
        firstly {
            newsClient.searchNews(with: query)
            }.done { result in
                callback(result, nil)
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                callback(nil, err)
        }
    }
}
