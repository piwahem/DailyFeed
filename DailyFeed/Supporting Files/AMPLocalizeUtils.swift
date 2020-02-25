//
//  AMPLocalizeUtils.swift
//  DailyFeed
//
//  Created by Admin on 2/25/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation

class AMPLocalizeUtils: NSObject {
    
    static let defaultLocalizer = AMPLocalizeUtils()
    var appbundle = Bundle.main
    
    func setSelectedLanguage(lang: String) {
        guard let langPath = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            appbundle = Bundle.main
            return
        }
        appbundle = Bundle(path: langPath)!
    }
    
    func stringForKey(key: String) -> String {
        return appbundle.localizedString(forKey: key, value: "", table: nil)
    }
}
