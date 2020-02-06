//
//  SourcePresenter.swift
//  DailyFeed
//
//  Created by Admin on 11/6/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import Foundation

public enum SourceTypeDialog: String {
    case language = "language"
    case country = "country"
    case category = "category"
}

protocol ISourcePresenter: class {
    func onLoading()
    func onList(_ list: [DailySourceModel],_ isLastPage: Bool)
    func onError(_ message: String)
    func onShowDialog(type dialog: SourceTypeDialog, filterSources: [String])
}

class SourcePresenter: ISourcePresenter {
    
    weak var view: ISourceView?
    
    func onLoading() {
        view?.onLoading()
    }
    
    func onList(_ list: [DailySourceModel],_ isLastPage: Bool) {
        view?.onList(list, isLastPage)
    }
    
    func onError(_ message: String) {
        view?.onError(message)
    }
    
    func onShowDialog(type dialog: SourceTypeDialog, filterSources: [String]){
        view?.onShowDialog(type: dialog, filterSources: filterSources)
    }
}
