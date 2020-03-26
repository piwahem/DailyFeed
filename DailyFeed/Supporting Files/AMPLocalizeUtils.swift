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
    let languageKey = "languageKey"
    
    var currentLanguage: LanguageLang {
        get {
            let language = CacheKey.value(forKey: languageKey, defaultValue: LanguageLang.English.rawValue) as! String
            return LanguageLang.init(rawValue: language)!
        }
        
        set {
            setSelectedLanguage(lang: newValue)
        }
    }
    
    private func setSelectedLanguage(lang: LanguageLang) {
        UserDefaults.standard.set(lang.rawValue, forKey: "AppleLanguage")
        Bundle.swizzleLocalization()
        CacheKey.setValue(forKey: languageKey, value: lang.rawValue)
    }
}

enum LanguageLang: String, Codable{
    case Chinese = "zh-Hans"
    case English = "en"
}
