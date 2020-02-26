//
//  String+Extension.swift
//  DailyFeed
//
//  Created by Admin on 2/22/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        guard let bundlePath = Bundle.main.path(forResource: AMPLocalizeUtils.defaultLocalizer.currentLanguage, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
    
    func localizeWithFormat(arguments: CVarArg...) -> String{
        return String(format: self.localized, arguments: arguments)
    }
}
