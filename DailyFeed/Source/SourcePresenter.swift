//
//  SourcePresenter.swift
//  DailyFeed
//
//  Created by Admin on 11/6/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

enum SourceTypeDialog: String {
    case language = "language"
    case country = "country"
    case category = "category"
}

protocol ISourcePresenter: class {
    func onLoading()
    func onList(_ list: [DailySourceModel])
    func onError(_ message: String)
    func onShowDialog(type dialog: SourceTypeDialog)
}

class SourcePresenter: ISourcePresenter {
    
    weak var view: ISourceView?
    
    func onLoading() {
        view?.onLoading()
    }
    
    func onList(_ list: [DailySourceModel]) {
        view?.onList(list)
    }
    
    func onError(_ message: String) {
        view?.onError(message)
    }
    
    func onShowDialog(type dialog: SourceTypeDialog) {
        view?.onShowDialog(type: dialog)
    }
}
