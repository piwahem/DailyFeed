//
//  NewsSearchInteractor.swift
//  DailyFeed
//
//  Created by Admin on 11/13/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

protocol INewsSearchInteractor {
    func searchNews(_ source: String)
}

class NewsSearchInteractor: INewsSearchInteractor {
    
    var worker: INewSearchWorker
    var presenter: INewsSearchPresenter?
    
    required init(worker: INewSearchWorker) {
        self.worker = worker
    }
    
    func searchNews(_ source: String) {
        worker.searchNews(source, callback: { (data, error) in
            if let e = error {
                print("onError = \(e)")
                self.presenter?.onError(e.localizedDescription)
                return
            }
            
            if let articles = data {
                print("onNext = \(articles)")
                self.presenter?.onList(articles.articles)
            }
        }) {
            print("completion")
        }
    }
}
