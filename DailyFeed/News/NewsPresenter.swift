//
//  NewsPresenter.swift
//  DailyFeed
//
//  Created by Admin on 10/30/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

protocol INewsPresenter {
    func onLoading()
    func onList(_ list: [DailyFeedModel])
    func onError(_ message: String)
}

class NewsPresenter: INewsPresenter {
    
    weak var view: INewsView?
    
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
