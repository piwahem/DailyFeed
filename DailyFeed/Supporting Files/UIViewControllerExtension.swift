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
    
    func showFilterDialog(type dialog: SourceTypeDialog, filterAction: UIAlertAction){
        var title = ""
        if dialog == .language {
            title = "Select a language"
        } else if dialog == .category{
            title = "Select a category"
        } else {
            title = "Select a country"
        }
        
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        alert.addAction(cancelButton)
        alert.addAction(filterAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

