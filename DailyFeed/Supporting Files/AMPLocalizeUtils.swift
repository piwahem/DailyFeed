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
    var currentLanguage = LanguageLang.English

    func setSelectedLanguage(lang: LanguageLang) {
        currentLanguage = lang
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: "AppleLanguage")
        Bundle.swizzleLocalization()
    }
}

enum LanguageLang: String{
    case Chinese = "zh-Hans"
    case English = "en"
}
