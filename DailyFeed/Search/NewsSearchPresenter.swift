//
//  NewsSearchPresenter.swift
//  DailyFeed
//
//  Created by Admin on 11/13/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

protocol INewsSearchPresenter {
    func onLoading()
    func onList(_ list: [DailyFeedModel])
    func onError(_ message: String)
}

class NewsSearchPresenter: INewsSearchPresenter {
    
    weak var view: INewsSearchView?
    
    func onLoading() {
        view?.onLoading()
    }
    
    func onList(_ list: [DailyFeedModel]) {
        view?.onList(list)
    }
    
    func onError(_ message: String) {
        view?.onError(message)
    }
    
}
