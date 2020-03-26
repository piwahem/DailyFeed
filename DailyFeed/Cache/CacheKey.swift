//
//  CacheKey.swift
//  DailyFeed
//
//  Created by Admin on 3/13/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation

class CacheKey {
    
    static func value<T>(forKey key: String, defaultValue: T) -> T{
        let preferences = UserDefaults.standard
        return preferences.object(forKey: key) == nil ? defaultValue : preferences.object(forKey: key) as! T
    }
    
    static func setValue(forKey key: String, value: Any){
        UserDefaults.standard.set(value, forKey: key)
    }
    
}
