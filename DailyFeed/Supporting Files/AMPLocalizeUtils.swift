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
    var currentLanguage = "en"

    func setSelectedLanguage(lang: String) {
        currentLanguage = lang
        UserDefaults.standard.set(currentLanguage, forKey: "AppleLanguage")
        Bundle.swizzleLocalization()
    }
}
