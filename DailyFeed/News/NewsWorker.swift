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
}

class NewsWorker: INewsWorker {
    
    func getNews(_ source: String,
                 callback: @escaping ((Articles?, Error?) -> Void),
                 completetion: @escaping ()->Void) {
        let newsClient = NewsClient()
        
        firstly {
            newsClient.getNewsItems(source: source)
            }.done { result in
                callback(result, nil)
            }.ensure(on: .main) {
                completetion()
            }.catch(on: .main) { err in
                callback(nil, err)
        }
    }
}
