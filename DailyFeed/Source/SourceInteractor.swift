//
//  SourceInteractor.swift
//  DailyFeed
//
//  Created by Admin on 11/5/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation


protocol ISourceInteractor {
    func getSources(params sourceRequestParams: NewsSourceParameters)
}

class SourceInteractor: ISourceInteractor {
    
    private var worker: ISourceWorker
    //    var presenter: INewsPresenter?
    
    required init(worker: ISourceWorker) {
        self.worker = worker
    }
    
    func getSources(params sourceRequestParams: NewsSourceParameters){
        worker.getSources(params: sourceRequestParams, callback: { (data, error) in
            if let e = error {
                print("onError = \(e)")
                return
            }
            
            if let sources = data {
                print("onNext = \(sources)")
            }
            
        }) {
            print("onCompleted")
        }
    }
}
