//
//  String+Extension.swift
//  DailyFeed
//
//  Created by Admin on 2/22/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
