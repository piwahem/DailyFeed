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
    func showDialog(type dialog: SourceTypeDialog)
}

class SourceInteractor: ISourceInteractor {
    
    private var worker: ISourceWorker
    var presenter: ISourcePresenter?
    
    required init(worker: ISourceWorker) {
        self.worker = worker
    }
    
    func getSources(params sourceRequestParams: NewsSourceParameters){
        presenter?.onLoading()
        worker.getSources(params: sourceRequestParams, callback: { (data, error) in
            if let e = error {
                print("onError = \(e)")
                self.presenter?.onError(e.localizedDescription)
                return
            }
            
            if let sources = data {
                print("onNext = \(sources)")
                self.presenter?.onList(sources.sources)
            }
            
        }) {
            print("onCompleted")
        }
    }
    
    func showDialog(type dialog: SourceTypeDialog) {
        if let sources = worker.getCurrentSources(){
            let filterSource = dialog == .category ? sources.categories :
                dialog == .country ? sources.countries :
                sources.languages
            presenter?.onShowDialog(type: dialog, filterSources: filterSource)
        }
    }
}
