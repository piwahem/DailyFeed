//
//  NewsInteractor.swift
//  DailyFeed
//
//  Created by Admin on 10/30/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

protocol INewsInteractor {
    func getNews(_ source: String)
}

class NewsInteractor: INewsInteractor {
    
    private let worker: INewsWorker
    var presenter: INewsPresenter?
    
    required init(worker: INewsWorker) {
        self.worker = worker
    }
    
    func getNews(_ source: String) {
        worker.getNews(source, callback: { (data, error) in
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
            print("onCompleted")
        }
    }
}
