//
//  BundleExtension.swift
//  DailyFeed
//
//  Created by Admin on 2/13/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appVersion: String{
        guard let releaseVersionNumber = releaseVersionNumber,
            let buildVersionNumber = buildVersionNumber else {
                return ""
        }
        return "Version %@ (%@)".localizeWithFormat(arguments: releaseVersionNumber, buildVersionNumber)
    }
    
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }
        
        let mySelector = #selector(myLocaLizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }
        
        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }
    
    @objc private func myLocaLizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let bundlePath = Bundle.main.path(forResource: AMPLocalizeUtils.defaultLocalizer.currentLanguage.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.myLocaLizedString(forKey: key, value: value, table: table)
        }
        return bundle.myLocaLizedString(forKey: key, value: value, table: table)
    }
}
