//
//  UIViewControllerExtension.swift
//  DailyFeed
//
//  Created by Miguel Revetria on 12/9/15.
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//

import UIKit

public extension UIViewController {
    
    /// shows an UIAlertController alert with error title and message
    func showError(_ title: String, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        if !Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.showError(title, message: message, handler: handler)
            }
            return
        }
        
        let attributedString = NSAttributedString(string: title,
                                                  attributes: [ NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        let controller = UIAlertController(title: "", message: "",
                                           preferredStyle: .alert)
        
        controller.setValue(attributedString, forKey: "attributedTitle")
        
        controller.view.tintColor = .black
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                           style: .default,
                                           handler: handler))
        
        present(controller, animated: true, completion: nil)
    }
    
    func showErrorWithDelay(_ title: String) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { 
            self.showError(title)
        }
    }
    
    func showFilterDialog(sources: [String], type dialog: SourceTypeDialog,
                          loadAction: @escaping ((NewsSourceParameters, String) -> Void)) -> UIPopoverPresentationController?{
        let title = getFilterAlertTitle(dialog: dialog)
        let actions: [UIAlertAction] = getFilterAction(sources: sources, type: dialog, loadAction: loadAction)
        
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alert.addAction(cancelButton)
        actions.forEach { (action) in
            alert.addAction(action)
        }
        let popOver = alert.popoverPresentationController
        popOver?.sourceRect = view.bounds
        self.present(alert, animated: true, completion: nil)
        return popOver
    }
    
    private func getFilterAction(sources: [String], type dialog: SourceTypeDialog,
                                 loadAction: @escaping ((NewsSourceParameters, String) -> Void)) -> [UIAlertAction]{
        var actions: [UIAlertAction] = []
        
        sources.forEach { (source) in
            let title = getFilterAlertActionTitle(type: dialog, source: source)
            let action = UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                let newsSourceParams = self!.getFilterAlertNewResourceParams(type: dialog, source: source)
                loadAction(newsSourceParams,source)
            })
            actions.append(action)
        }
        return actions
    }
    
    private func getFilterAlertTitle(dialog type: SourceTypeDialog)-> String{
        var title = ""
        if type == .language {
            title = "Select a language"
        } else if type == .category{
            title = "Select a category"
        } else {
            title = "Select a country"
        }
        return title
    }
    
    private func getFilterAlertActionTitle(type dialog: SourceTypeDialog, source: String)->String{
        var title = ""
        if dialog == .language {
            title = source.languageStringFromISOCode
        } else if dialog == .category{
            title = source
        } else {
            title = source.formattedCountryDescription
        }
        return title
    }
    
    func getFilterAlertNewResourceParams(type dialog: SourceTypeDialog, source: String) -> NewsSourceParameters {
        var newsSourceParams: NewsSourceParameters
        if dialog == .language {
            newsSourceParams = NewsSourceParameters(language: source)
        } else if dialog == .category{
            newsSourceParams = NewsSourceParameters(category: source)
        } else {
            newsSourceParams = NewsSourceParameters(country: source)
        }
        return newsSourceParams
    }
}

