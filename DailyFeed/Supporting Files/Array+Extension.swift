//
//  Array+Extension.swift
//  DailyFeed
//
//  Created by Admin on 1/18/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
